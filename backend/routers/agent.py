import json
import os
import re
from datetime import datetime, timezone
from typing import Any, Dict, List, Optional, cast

from dotenv import load_dotenv
from fastapi import APIRouter, Depends, Body, HTTPException
from openai import OpenAI as OpenAIClient
from pydantic import BaseModel
from sqlalchemy import text
from sqlalchemy.orm import Session

from core.dependencies import get_db, Base, logger
from core.models import AgentConversation, AgentMessage
from core.permission import get_current_user

router = APIRouter(prefix="/agent", tags=["AI助手"])

# configuration
MAX_ROWS = 500
DEFAULT_LIMIT = 100
FORBIDDEN_TABLES = {"users", "messages"}
load_dotenv()
os.environ['OPENAI_API_KEY'] = 'sk-gNQFZkPoY33sr5zouuSsa1C2K6pRaUtpxqhMfmdgSgyzAd1N'
os.environ['BASE_URL'] = 'https://api5.xhub.chat/v1'
OPENAI_API_KEY = os.environ.get("OPENAI_API_KEY") or os.environ.get("CHATGPT_API_KEY")
OPENAI_API_BASE = os.environ.get("BASE_URL") or os.environ.get("CHATGPT_BASE_URL")
CHATGPT_MODEL = os.environ.get("CHATGPT_MODEL", "gpt-4")
MODEL_SERVICE_URL = os.environ.get("MODEL_SERVICE_URL")

if OPENAI_API_KEY:
    try:
        sdk_client = OpenAIClient(api_key=OPENAI_API_KEY, base_url=OPENAI_API_BASE)
    except Exception as _err:
        logger.warning(f"OpenAI SDK client init failed: {_err}")
        sdk_client = None
else:
    sdk_client = None


class AgentQuery(BaseModel):
    table: str
    fields: Optional[List[str]] = None
    filters: Optional[Dict[str, Any]] = None
    limit: Optional[int] = DEFAULT_LIMIT


def _get_or_create_user_conversation(db: Session, user) -> type[AgentConversation] | AgentConversation:
    conv = db.query(AgentConversation).filter_by(user_id=user.id).order_by(AgentConversation.id.desc()).first()
    if conv is None:
        ts = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S")
        conv = AgentConversation(user_id=int(user.id), title=f'{user.username} - {ts}')
        db.add(conv)
        db.commit()
        db.refresh(conv)
    return conv


@router.get('')
async def get_conversation(db: Session = Depends(get_db), current_user: dict = Depends(get_current_user)):
    user = current_user.get('user') if isinstance(current_user, dict) else None
    if not user:
        raise HTTPException(status_code=401, detail='未认证的用户')
    conv = _get_or_create_user_conversation(db, user)
    msgs = db.query(AgentMessage).filter_by(conversation_id=conv.id).order_by(AgentMessage.id.asc()).all()
    return {"id": conv.id, "title": conv.title, "created_at": conv.created_at,
            "messages": [{"id": m.id, "role": m.role, "content": m.content, "meta": m.meta, "created_at": m.created_at}
                for m in msgs]}


def call_model(prompt: str, model_id: str = CHATGPT_MODEL, max_tokens: int = 1024, temperature: float = 0.2) -> str:
    if sdk_client is not None:
        try:
            messages = [{"role": "user", "content": prompt}]
            if hasattr(sdk_client, "chat") and hasattr(sdk_client.chat, "completions"):
                resp = sdk_client.chat.completions.create(model=model_id, messages=cast(Any, messages),
                                                          max_tokens=max_tokens, temperature=temperature)
                try:
                    # newest SDK: resp.choices[0].message.content
                    choices = getattr(resp, "choices", None) or resp.get("choices", [])
                    if choices:
                        first = choices[0]
                        msg = first.get("message") if isinstance(first, dict) else getattr(first, "message", None)
                        if isinstance(msg, dict):
                            return msg.get("content") or first.get("text") or ""
                        elif msg is not None:
                            return getattr(msg, "content", "") or getattr(first, "text", "") or ""
                except ValueError:
                    data = resp if isinstance(resp, dict) else None
                    if data:
                        c = data.get("choices", [])
                        if c:
                            m = c[0].get("message") or {}
                            return m.get("content") or c[0].get("text") or ""
        except Exception as e:
            logger.warning(f"OpenAI SDK call failed for model {model_id}, error: {e}")
    return "抱歉，模型服务未配置或调用失败，无法生成答案。"


def simple_parse_intent(question: str):
    intent = {"queries": []}
    import re
    years = re.findall(r"\b(20\d{2})\b", question)
    year = int(years[0]) if years else None
    # factory extraction: look for known factories via selection store? for now naive
    factory = None
    # default: query summary of yearly_data
    q = {"table": "yearly_data", "fields": [], "filters": {}}
    if year:
        q['filters']['year'] = year
    if factory:
        q['filters']['factory'] = factory
    intent['queries'].append(q)
    return intent


def parse_intent_via_chatgpt(question: str, allowed_tables: Dict[str, List[str]], schema_text: str,
                             model_id: str = CHATGPT_MODEL) -> Dict[str, Any]:
    try:
        prompt = ("你是严格的解析器。用户会提出数据查询类的问题。\n"
                  "你只能基于下面给出的数据库结构（表名与列）生成意图，不要引用或假设数据库中不存在的表或列。\n"
                  "返回一个 JSON 对象且仅返回 JSON，不要包含任何其他说明文本。JSON 格式如下：\n"
                  "{\"queries\": [{\"table\": string, \"fields\": [string], \"filters\": {string: string|number}, \"limit\": int}]}\n"
                  "数据库结构（供参考）：\n"
                  f"{schema_text}\n"
                  "说明：filters 只支持简单的等值或 in 列表；fields 可以为空表示默认字段；limit 不超过 500。\n"
                  "当无法解析合适的表时，返回 {\"queries\": []}。\n"
                  "用户问题：\n" + question)
        raw = call_model(prompt, model_id, 512, 0.0)
        logger.info(model_id)
        if not raw:
            return simple_parse_intent(question)
        # extract first JSON object
        m = re.search(r"(\{.*})", raw, flags=re.S)
        if not m:
            return simple_parse_intent(question)
        js = m.group(1)
        parsed = json.loads(js)
        # basic validation
        if not isinstance(parsed, dict) or "queries" not in parsed:
            return simple_parse_intent(question)
        # clamp limits and sanitize fields/tables
        for q in parsed.get("queries", []):
            t = q.get("table")
            if t not in allowed_tables:
                q["table"] = None
                continue
            flds = q.get("fields") or []
            q["fields"] = [x for x in flds if x in allowed_tables[t]]
            lim = int(q.get("limit") or DEFAULT_LIMIT)
            q["limit"] = max(1, min(lim, MAX_ROWS))
        return parsed
    except Exception as e:
        logger.error(f"parse_intent_via_chatgpt failed: {e}")
        return simple_parse_intent(question)


@router.post('')
async def post_message(body: Dict[str, Any] = Body(...), db: Session = Depends(get_db),
                       current_user: dict = Depends(get_current_user)):
    """Post a user message to the current user's single conversation.

    Body JSON fields:
      - text (str) required: the user's message
      - continuous (bool) optional: whether to include recent conversation history (default False)
      - query_database (bool) optional: whether to parse the question into DB queries and run them (default False)
      - context_size (int) optional: how many recent messages to include as context when continuous is true (default 12)

    Behavior summary:
      - Always persist the user message.
      - If continuous is true: fetch recent messages (context_size) and include them when calling the model.
      - If query_database is true: use the intent parser to build queries, run them, build a query summary, and include it in the model prompt; otherwise skip parsing and DB queries.
      - The two flags are independent.
    """
    user = current_user.get('user') if isinstance(current_user, dict) else None
    if not user:
        raise HTTPException(status_code=401, detail='未认证的用户')
    if not isinstance(body, dict):
        raise HTTPException(status_code=400, detail='请求体必须为 JSON 对象')
    text_input = body.get('text')
    if not text_input or not isinstance(text_input, str):
        raise HTTPException(status_code=400, detail='缺少 text 字段或类型不正确')

    continuous = bool(body.get('continuous', False))
    query_database = bool(body.get('query_database', False))
    context_size = int(body.get('context_size', 12) or 12)
    model_id = str(body.get('model_id') or CHATGPT_MODEL)
    conv = _get_or_create_user_conversation(db, user)
    um = AgentMessage(conversation_id=int(conv.id), role='user', content=text_input, meta=None)
    try:
        db.add(um)
        db.commit()
        db.refresh(um)
    except Exception as e:
        db.rollback()
        logger.error(f"save user message failed: {e}")
        raise HTTPException(status_code=500, detail='保存消息失败')

    # optionally fetch recent context only when continuous is True
    context = ""
    if continuous:
        msgs = db.query(AgentMessage).filter_by(conversation_id=conv.id).order_by(AgentMessage.id.asc()).all()
        recent_msgs = msgs[-context_size:] if context_size > 0 else []
        context = "\n".join([f"{m.role}: {m.content}" for m in recent_msgs])

    allowed = {n: [c.name for c in tbl.columns] for n, tbl in Base.metadata.tables.items() if n not in FORBIDDEN_TABLES}
    schema_lines = []
    for t, cols in allowed.items():
        schema_lines.append(f"{t}: {', '.join(cols)}")
    schema_text = "\n".join(schema_lines)
    if len(schema_text) > 4000:
        schema_text = schema_text[:3000] + "\n... (truncated)"
    all_results: List[Dict[str, Any]] = []
    query_text = ""
    if query_database:
        intent = parse_intent_via_chatgpt(text_input, allowed, schema_text, model_id)
        logger.info(f"解析到的意图: {intent}")
        if intent and isinstance(intent, dict) and intent.get('queries'):
            for q in intent.get('queries', []):
                t = q.get('table')
                if t is None or t not in allowed:
                    continue
                fields = q.get('fields') or allowed[t]
                fields = [f for f in fields if f in allowed[t]]
                limit = min(int(q.get('limit', DEFAULT_LIMIT)), MAX_ROWS)
                filters = q.get('filters') or {}
                clauses = []
                params = {}
                idx = 0
                for k, v in (filters.items() if isinstance(filters, dict) else []):
                    if k not in allowed[t]:
                        continue
                    if v is None:
                        clauses.append(f"{k} IS NULL")
                    elif isinstance(v, (list, tuple)):
                        pname = f"p{idx}"
                        clauses.append(f"{k} IN :{pname}")
                        params[pname] = tuple(v)
                        idx += 1
                    elif isinstance(v, (str, int, float, bool)):
                        pname = f"p{idx}"
                        clauses.append(f"{k} = :{pname}")
                        params[pname] = v
                        idx += 1
                where = ("WHERE " + " AND ".join(clauses)) if clauses else ""
                sql = f"SELECT {', '.join(fields)} FROM {t} {where} LIMIT {limit}"
                try:
                    res = db.execute(text(sql), params).mappings().all()
                    rows = [dict(r) for r in res]
                    all_results.append({"table": t, "rows": rows})
                except Exception as e:
                    logger.error(f"query failed in conversation flow: {e}")
        if all_results:
            parts = []
            for r in all_results:
                tab = r.get('table')
                rows = r.get('rows', [])
                parts.append(f"{tab} 表格返回 {len(rows)} 行: {rows}。")
            query_text = "\n".join(parts)
    if query_text:
        prompt = f"\n一、用户问题: {text_input}\n\n二、数据库结构（供参考）：{schema_text}\n\n三、查询结果:\n{query_text}\n\n四、对话上下文:\n{context}\n\n五、请基于上述查询结果和上下文回答用户的问题，中文回答。"
    else:
        prompt = f"\n一、用户问题: {text_input}\n\n二、数据库结构（供参考）：{schema_text}\n\n三、对话上下文:\n{context}\n\n四、请基于上下文直接回答用户的问题，中文回答。"
    assistant_text = call_model(prompt, model_id)
    am = AgentMessage(conversation_id=int(conv.id), role='assistant', content=assistant_text, meta=None)
    try:
        db.add(am)
        conv.updated_at = datetime.now(timezone.utc)
        logger.info(f"新增AI回答：{am.content}")
        db.commit()
        db.refresh(am)
    except Exception as e:
        db.rollback()
        logger.error(f"save assistant message failed: {e}")
    logger.info(f"连续对话：{continuous}，查询数据库：{query_database}，提示词: {prompt}")
    logger.info(f"回答: {assistant_text}")
    return assistant_text


@router.delete('')
async def clear_conversation(db: Session = Depends(get_db), current_user: dict = Depends(get_current_user)):
    user = current_user.get('user') if isinstance(current_user, dict) else None
    if not user:
        raise HTTPException(status_code=401, detail='未认证的用户')
    conv = db.query(AgentConversation).filter_by(user_id=user.id).order_by(AgentConversation.id.desc()).first()
    if not conv:
        return {"status": "success", "deleted": 0, "message": "无会话或已清空"}
    try:
        db.query(AgentMessage).filter_by(conversation_id=conv.id).delete(synchronize_session=False)
        conv.updated_at = datetime.now(timezone.utc)
        db.commit()
        return {"status": "success", "message": "对话已清空"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail='清除对话失败')
