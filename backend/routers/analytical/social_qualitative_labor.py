from typing import Dict

from fastapi import APIRouter, Depends, HTTPException, Query, Body
from sqlalchemy.orm import Session

from core.dependencies import get_db, indicators
from core.models import LaborQualitative
from core.permissions import get_current_user
from core.utils import send_yearly_message, get_review_info, check_review_record, require_view, require_edit

router = APIRouter(prefix="/analytical/social_qualitative_labor", tags=["分析数据-社会定性-劳工"])


@router.get("")
async def get_labor_qualitative(factory: str = Query(...), year: int = Query(...), db: Session = Depends(get_db),
                                current_user: dict = Depends(get_current_user)):
    try:
        require_view(factory, "social_qual_labor", current_user)
        # 获取当前年数据
        current_rows = db.query(LaborQualitative).filter(LaborQualitative.factory == factory,
                                                         LaborQualitative.year == year).all()
        current_data = {r.indicator: r for r in current_rows}

        # 获取上一年数据
        prev_rows = db.query(LaborQualitative).filter(LaborQualitative.factory == factory,
                                                      LaborQualitative.year == year - 1).all()
        prev_data = {r.indicator: r for r in prev_rows}

        # 组装结构：{类别: {indicatorKey: {currentText, comparisonText, reason}}}
        result = {}
        for category, indicator in indicators["social_qual_labor"].items():
            group = {}
            for ind in indicator:
                current_record = current_data.get(ind)
                prev_record = prev_data.get(ind)

                group[ind] = {"currentText": current_record.current_text if current_record else "",
                              "lastText": prev_record.current_text if prev_record else "",
                              "comparisonText": current_record.comparison_text if current_record else "",
                              "reason": current_record.reason if current_record else ""}
            result[category] = group
        return {"data": result, "review": get_review_info(db, factory, year, "social_qual_labor")}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取劳动定性数据失败: {str(e)}")


@router.post("")
async def save_labor_qualitative(factory: str = Body(..., description="工厂名称"),
                                 year: int = Body(..., description="统计年份"),
                                 isSubmitted: bool = Body(..., description="是否提交"),
                                 data: Dict[str, Dict[str, Dict[str, str]]] = Body(...), db: Session = Depends(get_db),
                                 current_user: dict = Depends(get_current_user)):
    try:
        require_edit(factory, "social_qual_labor", current_user)
        check = check_review_record(db, factory, year, "social_qual_labor", isSubmitted)
        if check["status"] == "fail":
            return check
        for category, indicators in data.items():
            for indicator, payload in indicators.items():
                r = db.query(LaborQualitative).filter(LaborQualitative.factory == factory,
                                                      LaborQualitative.year == year,
                                                      LaborQualitative.indicator == indicator).first()
                if r:
                    r.current_text = payload.get('currentText', r.current_text)
                    r.comparison_text = payload.get('comparisonText', r.comparison_text)
                    r.reason = payload.get('reason', r.reason)
                else:
                    db.add(LaborQualitative(factory=factory, year=year, indicator=indicator,
                                            current_text=payload.get('currentText', ''),
                                            comparison_text=payload.get('comparisonText', ''),
                                            reason=payload.get('reason', '')))
        db.commit()
        send_yearly_message(db, current_user, factory, year, isSubmitted, "social_qual_labor")
        return {"status": "success", "message": "社会定性-劳工内容已保存"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"保存社会定性-劳工失败: {str(e)}")
