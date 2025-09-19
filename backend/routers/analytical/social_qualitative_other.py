from typing import Dict

from fastapi import APIRouter, Depends, HTTPException, Query, Body
from sqlalchemy.orm import Session

from core.dependencies import get_db, indicators
from core.models import OtherQualitative
from core.permissions import get_current_user
from core.utils import send_yearly_message, get_review_info, check_review_record, require_view, require_edit

router = APIRouter(prefix="/analytical/social_qualitative_other", tags=["分析数据-社会定性-其他"])


@router.get("")
async def get_other_qualitative(factory: str = Query(...), year: int = Query(...), db: Session = Depends(get_db),
                                current_user: dict = Depends(get_current_user)):
    try:
        require_view(factory, "social_qual_other", current_user)
        current_rows = db.query(OtherQualitative).filter(OtherQualitative.factory == factory,
                                                         OtherQualitative.year == year).all()
        last_year_rows = db.query(OtherQualitative).filter(OtherQualitative.factory == factory,
                                                           OtherQualitative.year == year - 1).all()
        current_data = {r.indicator: r for r in current_rows}
        last_year_data = {r.indicator: r for r in last_year_rows}
        result = {}
        for category, indicator in indicators["social_qual_other"].items():
            group = {}
            for ind in indicator:
                current = current_data.get(ind)
                last_year = last_year_data.get(ind)
                group[ind] = {"currentText": current.current_text if current else "",
                              "lastText": last_year.current_text if last_year else "",
                              "comparisonText": current.comparison_text if current else "",
                              "reason": current.reason if current else ""}
            result[category] = group
        return {"data": result, "review": get_review_info(db, factory, year, "social_qual_other")}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取其他定性数据失败: {str(e)}")


@router.post("")
async def save_other_qualitative(factory: str = Body(..., description="工厂名称"),
                                 year: int = Body(..., description="统计年份"),
                                 isSubmitted: bool = Body(..., description="是否提交"),
                                 data: Dict[str, Dict[str, Dict[str, str]]] = Body(...), db: Session = Depends(get_db),
                                 current_user: dict = Depends(get_current_user)):
    try:
        require_edit(factory, "social_qual_other", current_user)
        check = check_review_record(db, factory, year, "social_qual_other", isSubmitted)
        if check["status"] == "fail":
            return check
        for category, indicators in data.items():
            for indicator, payload in indicators.items():
                r = db.query(OtherQualitative).filter(OtherQualitative.factory == factory,
                                                      OtherQualitative.year == year,
                                                      OtherQualitative.indicator == indicator).first()
                if r:
                    r.current_text = payload.get('currentText', r.current_text)
                    r.comparison_text = payload.get('comparisonText', r.comparison_text)
                    r.reason = payload.get('reason', r.reason)
                else:
                    db.add(OtherQualitative(factory=factory, year=year, indicator=indicator,
                                            current_text=payload.get('currentText', ''),
                                            comparison_text=payload.get('comparisonText', ''),
                                            reason=payload.get('reason', '')))
        db.commit()
        send_yearly_message(db, current_user, factory, year, isSubmitted, "social_qual_other")
        return {"status": "success", "message": "社会定性-其他内容已保存"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"保存社会定性-其他失败: {str(e)}")
