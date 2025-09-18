from datetime import datetime, timezone
from typing import Dict

from fastapi import APIRouter, Depends, HTTPException, Query, Body
from sqlalchemy.orm import Session

from core.dependencies import get_db, indicators
from core.models import Governance, YearInfo
from core.permissions import require_view, get_current_user, require_edit, check_factory_year
from core.utils import send_yearly_message

router = APIRouter(prefix="/analytical/governance", tags=["分析数据-治理"])


@router.get("")
async def fetch_governance_data(factory: str = Query(...), year: int = Query(...), db: Session = Depends(get_db),
                                current_user: dict = Depends(get_current_user)):
    try:
        require_view(factory, current_user)
        # 获取当前年数据
        current_rows = db.query(Governance).filter(Governance.factory == factory, Governance.year == year).all()
        current_data = {r.indicator: r for r in current_rows}

        # 获取上一年数据
        prev_rows = db.query(Governance).filter(Governance.factory == factory, Governance.year == year - 1).all()
        prev_data = {r.indicator: r for r in prev_rows}

        result = {}
        for category, indicator_list in indicators["governance"].items():
            group = {}
            for ind in indicator_list:
                current_record = current_data.get(ind)
                prev_record = prev_data.get(ind)
                group[ind] = {"currentText": current_record.current_text if current_record else "",
                              "lastText": prev_record.current_text if prev_record else "",
                              "comparisonText": current_record.comparison_text if current_record else "",
                              "reason": current_record.reason if current_record else ""}
            result[category] = group
        year_info = db.query(YearInfo).with_entities(YearInfo.review_status, YearInfo.review_comment).filter_by(
            factory=factory, year=year).first()
        return {"data": result,
                "review": {"status": year_info.review_status[6], "comment": year_info.review_comment[6]}}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取治理数据失败: {str(e)}")


@router.post("")
async def submit_governance_data(factory: str = Body(..., description="工厂名称"),
                                 year: int = Body(..., description="统计年份"),
                                 isSubmitted: bool = Body(..., description="是否提交"),
                                 data: Dict[str, Dict[str, Dict[str, str]]] = Body(...), db: Session = Depends(get_db),
                                 current_user: dict = Depends(get_current_user)):
    try:
        require_edit(factory, current_user)
        check = check_factory_year(factory, year, db, isSubmitted, 6)
        if check["status"] == "fail":
            return check
        for category, indicators in data.items():
            for indicator, payload in indicators.items():
                r = db.query(Governance).filter(Governance.factory == factory, Governance.year == year,
                                                Governance.indicator == indicator).first()
                if r:
                    r.current_text = payload.get('currentText', r.current_text)
                    r.comparison_text = payload.get('comparisonText', r.comparison_text)
                    r.reason = payload.get('reason', r.reason)
                else:
                    new_record = Governance(factory=factory, year=year, indicator=indicator,
                        current_text=payload.get('currentText', ''), comparison_text=payload.get('comparisonText', ''),
                        reason=payload.get('reason', ''))
                    db.add(new_record)
        db.commit()
        send_yearly_message(db, current_user, factory, year, isSubmitted, "governance")
        return {"status": "success", "message": "治理内容已保存"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"保存治理失败: {str(e)}")
