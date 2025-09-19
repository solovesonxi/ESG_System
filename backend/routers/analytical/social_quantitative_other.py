from datetime import datetime
from typing import Dict

from fastapi import APIRouter, Depends, HTTPException, Query, Body
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import OtherReason, SupplyData, ResponsibilityData, IPData, CommunityData
from core.permissions import get_current_user
from core.utils import _calc_comparison, send_yearly_message, get_review_info, check_review_record, require_view, require_edit

router = APIRouter(prefix="/analytical/social_quantitative_other", tags=["分析数据-社会定量-其他"])


@router.get("")
async def get_data(factory: str = Query(...), year: int = Query(...), db: Session = Depends(get_db),
                   current_user: dict = Depends(get_current_user)):
    try:
        require_view(factory, "social_quant_other", current_user)
        supply_cur = db.query(SupplyData).filter(SupplyData.factory == factory, SupplyData.year == year).first()
        supply_prev = db.query(SupplyData).filter(SupplyData.factory == factory, SupplyData.year == year - 1).first()

        product_cur = db.query(ResponsibilityData).filter(ResponsibilityData.factory == factory,
                                                          ResponsibilityData.year == year).first()
        product_prev = db.query(ResponsibilityData).filter(ResponsibilityData.factory == factory,
                                                           ResponsibilityData.year == year - 1).first()

        ipr_cur = db.query(IPData).filter(IPData.factory == factory, IPData.year == year).first()
        ipr_prev = db.query(IPData).filter(IPData.factory == factory, IPData.year == year - 1).first()

        community_cur = db.query(CommunityData).filter(CommunityData.factory == factory,
                                                       CommunityData.year == year).first()
        community_prev = db.query(CommunityData).filter(CommunityData.factory == factory,
                                                        CommunityData.year == year - 1).first()
        # reasons
        reasons_rows = db.query(OtherReason).filter(OtherReason.factory == factory, OtherReason.year == year).all()
        reasons_map = {row.indicator: row.reason for row in reasons_rows}

        def entry(indicator_key, cur, prev):
            return {"currentYear": cur, "lastYear": prev, "comparison": _calc_comparison(cur, prev),
                    "reason": reasons_map.get(indicator_key, "")}

        def entry_sum(indicator_key, cur, prev):
            cur_add = sum(cur) if cur else None
            prev_add = sum(prev) if prev else None
            return {"currentYear": cur_add, "lastYear": prev_add, "comparison": _calc_comparison(cur_add, prev_add),
                    "reason": reasons_map.get(indicator_key, "")}

        def gv(obj, attr):
            return getattr(obj, attr) if obj is not None else None

        data = {"供应链管理": {}, "产品责任": {}, "知识产权保护": {}, "社区参与": {}, "志愿活动": {}}

        # 供应链管理
        for key in ['total_suppliers', 'env_screened', 'soc_screened', 'env_assessment_count', 'soc_assessment_count',
                    'env_penalty_count', 'env_penalty_amount', 'cyber_incidents', 'local_amount', 'total_amount',
                    'local_purchase_ratio']:
            data["供应链管理"][f"supply_{key}"] = entry(f"supply_{key}", gv(supply_cur, key), gv(supply_prev, key))

        # 产品责任
        for key in ['complaints_total', 'handled_total', 'handled_rate', 'customer_satisfaction_average',
                    'recall_total', 'recall_rate', 'quality_issues_total', 'cyber_incidents_total']:
            data["产品责任"][f"product_{key}"] = entry(f"product_{key}", gv(product_cur, key), gv(product_prev, key))

        # 知识产权
        for key in ['patents_total', 'inv_patents_total', 'inv_applications_total', 'utility_patents_total',
                    'design_patents_total', 'granted_patents_total', 'new_patents', 'software_copyrights_total',
                    'trademarks_total']:
            data["知识产权保护"][f"ipr_{key}"] = entry(f"ipr_{key}", gv(ipr_cur, key), gv(ipr_prev, key))

        # 社区参与
        for key in ['charity_donations', 'community_investment']:
            data["社区参与"][f"community_{key}"] = entry_sum(f"community_{key}", gv(community_cur, key),
                                                             gv(community_prev, key))

        # 志愿活动
        for key in ['volunteer_participants', 'volunteer_hours']:
            data["志愿活动"][f"volunteer_{key}"] = entry_sum(f"volunteer_{key}", gv(community_cur, key),
                                                             gv(community_prev, key))
        return {"data": data,
                "review": get_review_info(db, factory, year, "social_quant_other")}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取社会定量-其他数据失败: {str(e)}")


@router.post("")
async def save_reasons(factory: str = Body(..., description="工厂名称"), year: int = Body(..., description="统计年份"),
                       reasons: Dict[str, str] = Body(...), isSubmitted: bool = Body(..., description="是否提交"),
                       db: Session = Depends(get_db), current_user: dict = Depends(get_current_user)):
    try:
        require_edit(factory, "social_quant_other", current_user)
        check = check_review_record(db, factory, year, "social_quant_other", isSubmitted)
        if check["status"] == "fail":
            return check
        for indicator, reason in reasons.items():
            existing = db.query(OtherReason).filter(OtherReason.factory == factory, OtherReason.year == year,
                                                    OtherReason.indicator == indicator).first()
            if existing:
                existing.reason = reason
            else:
                db.add(OtherReason(factory=factory, year=year, indicator=indicator, reason=reason))
        db.commit()
        send_yearly_message(db, current_user, factory, year, isSubmitted, "social_quant_other")
        return {"status": "success", "message": "社会定量-其他原因说明已保存"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"保存社会定量-其他原因失败: {str(e)}")
