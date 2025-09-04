from typing import Dict

from fastapi import APIRouter, Depends, HTTPException, Query, Body
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import OtherQualitative
from core.permissions import require_access, get_current_user, require_factory

router = APIRouter(prefix="/analytical/social_qualitative_other", tags=["分析数据-社会定性-其他"])

# 定性：其他
OTHER_QUAL_INDICATORS = {
    "供应商管理": ["供应商管理体系", "供应商廉洁要求", "供应商管理目标及措施", "供应商识别", "绿色供应链",
                   "供应链多元化政策", "供应链对环境的负面影响及采取的行动", "供应链对社会的负面影响及采取的行动",
                   "供应链环境承诺书签署率", "供应链环境现场审核完成率", "供应链环境现场审核改进情况说明",
                   "供应链环境管理目标"], "产品安全管理": ["产品质量与安全机制"],
    "责任营销": ["真实公正的信息与合同签订"], "知识产权保护": ["知识产权保护政策", "维护及保障知识产权有关的惯例"],
    "数据安全与客户隐私保护": ["客户隐私保护", "数据安全管理", "数据安全隐私认证与信披", "信息安全管理体系认证"],
    "社区参与": ["社区参与", "利益相关方社区沟通目标计划", "利益相关方社区沟通目标计划完成率（%）",
                 "有当地社区参与、影响评估和发展计划的运营点"], "绿色金融": ["绿色金融产品"], "数字化": ["数字转型"]}


@router.get("")
async def get_other_qualitative(factory: str = Query(...), year: int = Query(...), db: Session = Depends(get_db),
                                current_user: dict = Depends(get_current_user)):
    try:
        require_access(factory, current_user)
        rows = db.query(OtherQualitative).filter(OtherQualitative.factory == factory,
                                                 OtherQualitative.year == year).all()
        existing = {r.indicator: r for r in rows}
        result = {}
        for category, indicators in OTHER_QUAL_INDICATORS.items():
            group = {}
            for ind in indicators:
                r = existing.get(ind)
                group[ind] = {"currentText": r.current_text if r else "", "lastText": r.last_text if r else "",
                              "comparisonText": r.comparison_text if r else "", "reason": r.reason if r else ""}
            result[category] = group
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取其他定性数据失败: {str(e)}")


@router.post("")
async def save_other_qualitative(factory: str = Body(...), year: int = Body(...),
                                 data: Dict[str, Dict[str, Dict[str, str]]] = Body(...), db: Session = Depends(get_db),
                                 current_user: dict = Depends(get_current_user)):
    try:
        require_factory(factory, current_user)
        for category, indicators in data.items():
            for indicator, payload in indicators.items():
                r = db.query(OtherQualitative).filter(OtherQualitative.factory == factory,
                                                      OtherQualitative.year == year,
                                                      OtherQualitative.indicator == indicator).first()
                if r:
                    r.current_text = payload.get('currentText', r.current_text)
                    r.last_text = payload.get('lastText', r.last_text)
                    r.comparison_text = payload.get('comparisonText', r.comparison_text)
                    r.reason = payload.get('reason', r.reason)
                else:
                    db.add(OtherQualitative(factory=factory, year=year, indicator=indicator,
                                            current_text=payload.get('currentText', ''),
                                            last_text=payload.get('lastText', ''),
                                            comparison_text=payload.get('comparisonText', ''),
                                            reason=payload.get('reason', '')))
        db.commit()
        return {"status": "success", "message": "其他定性内容已保存"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"保存其他定性失败: {str(e)}")
