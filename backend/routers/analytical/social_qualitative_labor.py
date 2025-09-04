from typing import Dict

from fastapi import APIRouter, Depends, HTTPException, Query, Body
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import LaborQualitative
from core.permissions import require_access, get_current_user, require_factory

router = APIRouter(prefix="/analytical/social_qualitative_labor", tags=["分析数据-社会定性-劳工"])

# 定性：劳动
QUAL_INDICATORS = {"雇佣": ["员工聘用及解雇", "行业员工流失率", "光大同创的员工流失率与行业流失率的对比表", "薪酬管理"],
                   "职业健康与安全": ["职业健康安全管理体系", "安全生产政策", "保障职业健康与安全目标",
                                      "保障职业健康与安全目标措施", "危害识别、风险评估和事故调查",
                                      "职业健康安全事务：工作者的参与、意见征询和沟通", "工作者职业健康安全培训",
                                      "促进工作者健康"],
                   "员工满意度": ["员工满意度调查计划", "员工满意度调查覆盖率/覆盖情况", "员工满意度项目排名"],
                   "员工关爱": ["提供给全职员工（不包括临时或兼职员工）的福利", "员工关爱"],
                   "培训": ["年度培训计划小时数目标", "年度培训计划小时数目标达成率（%）", "年度培训计划",
                            "年度培训计划达成率（%）"], "多元化与平等机会": ["多元化和机会平等", "晋升机制"],
                   "反歧视": ["歧视事件及采取的纠正行动"], "童工": ["具有重大童工事件风险的运营点和供应商"],
                   "强迫或强制劳动": ["具有强迫或强制劳动事件重大风险的运营点和供应商"], "民主权益": ["民主管理"],
                   "应急管理": ["应急管理体系", "安全应急措施"]}


@router.get("")
async def get_labor_qualitative(factory: str = Query(...), year: int = Query(...), db: Session = Depends(get_db),
                                current_user: dict = Depends(get_current_user)):
    try:
        require_access(factory, current_user)
        rows = db.query(LaborQualitative).filter(LaborQualitative.factory == factory,
                                                 LaborQualitative.year == year).all()
        existing = {r.indicator: r for r in rows}

        # 组装结构：{类别: {indicatorKey: {currentText, lastText, comparisonText, reason}}}
        result = {}
        for category, indicators in QUAL_INDICATORS.items():
            group = {}
            for ind in indicators:
                r = existing.get(ind)
                group[ind] = {"currentText": r.current_text if r else "", "lastText": r.last_text if r else "",
                              "comparisonText": r.comparison_text if r else "", "reason": r.reason if r else ""}
            result[category] = group
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取劳动定性数据失败: {str(e)}")


@router.post("")
async def save_labor_qualitative(factory: str = Body(...), year: int = Body(...),
                                 data: Dict[str, Dict[str, Dict[str, str]]] = Body(...), db: Session = Depends(get_db),
                                 current_user: dict = Depends(get_current_user)):
    try:
        require_factory(factory, current_user)
        # data: {类别: { 指标: {currentText, lastText, comparisonText, reason} }}
        for category, indicators in data.items():
            for indicator, payload in indicators.items():
                r = db.query(LaborQualitative).filter(LaborQualitative.factory == factory,
                                                      LaborQualitative.year == year,
                                                      LaborQualitative.indicator == indicator).first()
                if r:
                    r.current_text = payload.get('currentText', r.current_text)
                    r.last_text = payload.get('lastText', r.last_text)
                    r.comparison_text = payload.get('comparisonText', r.comparison_text)
                    r.reason = payload.get('reason', r.reason)
                else:
                    db.add(LaborQualitative(factory=factory, year=year, indicator=indicator,
                                            current_text=payload.get('currentText', ''),
                                            last_text=payload.get('lastText', ''),
                                            comparison_text=payload.get('comparisonText', ''),
                                            reason=payload.get('reason', '')))
        db.commit()
        return {"status": "success", "message": "劳动定性内容已保存"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"保存劳动定性失败: {str(e)}")
