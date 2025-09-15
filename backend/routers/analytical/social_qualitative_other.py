from typing import Dict

from fastapi import APIRouter, Depends, HTTPException, Query, Body
from sqlalchemy.orm import Session

from core.dependencies import get_db, indicators
from core.models import OtherQualitative
from core.permissions import require_access, get_current_user, require_factory, check_factory_year

router = APIRouter(prefix="/analytical/social_qualitative_other", tags=["分析数据-社会定性-其他"])


@router.get("")
async def get_other_qualitative(factory: str = Query(...), year: int = Query(...), db: Session = Depends(get_db),
                                current_user: dict = Depends(get_current_user)):
    try:
        require_access(factory, current_user)
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
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取其他定性数据失败: {str(e)}")


@router.post("")
async def save_other_qualitative(factory: str = Body(..., description="工厂名称"),
                                 year: int = Body(..., description="统计年份"),
                                 isSubmitted: bool = Body(..., description="是否提交"),
                                 data: Dict[str, Dict[str, Dict[str, str]]] = Body(...), db: Session = Depends(get_db),
                                 current_user: dict = Depends(get_current_user)):
    try:
        require_factory(factory, current_user)
        check = check_factory_year(factory, year, db, isSubmitted, 5)
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
        return {"status": "success", "message": "其他定性内容已保存"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"保存其他定性失败: {str(e)}")
