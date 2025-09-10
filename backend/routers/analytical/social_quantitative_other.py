from typing import Dict

from fastapi import APIRouter, Depends, HTTPException, Query, Body
from sqlalchemy.orm import Session

from core.dependencies import get_db
from core.models import OtherReason, SupplyData, ProductResponsibilityData, IPRData, CommunityData, VolunteerData
from core.permissions import require_access, get_current_user, require_factory
from core.utils import _calc_comparison

router = APIRouter(prefix="/analytical/social_quantitative_other", tags=["分析数据-社会定量-其他"])


@router.get("")
async def get_data(factory: str = Query(...), year: int = Query(...), db: Session = Depends(get_db),
                   current_user: dict = Depends(get_current_user)):
    try:
        require_access(factory, current_user)
        supply_cur = db.query(SupplyData).filter(SupplyData.factory == factory, SupplyData.year == year).first()
        supply_prev = db.query(SupplyData).filter(SupplyData.factory == factory, SupplyData.year == year - 1).first()

        product_cur = db.query(ProductResponsibilityData).filter(ProductResponsibilityData.factory == factory,
                                                                 ProductResponsibilityData.year == year).first()
        product_prev = db.query(ProductResponsibilityData).filter(ProductResponsibilityData.factory == factory,
                                                                  ProductResponsibilityData.year == year - 1).first()

        ipr_cur = db.query(IPRData).filter(IPRData.factory == factory, IPRData.year == year).first()
        ipr_prev = db.query(IPRData).filter(IPRData.factory == factory, IPRData.year == year - 1).first()

        community_cur = db.query(CommunityData).filter(CommunityData.factory == factory,
                                                       CommunityData.year == year).first()
        community_prev = db.query(CommunityData).filter(CommunityData.factory == factory,
                                                        CommunityData.year == year - 1).first()

        volunteer_cur = db.query(VolunteerData).filter(VolunteerData.factory == factory,
                                                       VolunteerData.year == year).first()
        volunteer_prev = db.query(VolunteerData).filter(VolunteerData.factory == factory,
                                                        VolunteerData.year == year - 1).first()

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
        for key in ['total_suppliers', 'env_screened', 'soc_screened', 'env_assessment_count',
                    'soc_assessment_count', 'env_penalty_count', 'env_penalty_amount', 'cyber_incidents',
                    'local_amount', 'total_amount', 'local_purchase_ratio']:
            data["供应链管理"][f"supply_{key}"] = entry(f"supply_{key}", gv(supply_cur, key), gv(supply_prev, key))

        # 产品责任
        for key in ['complaints_total', 'complaints_handled', 'complaints_handle_rate', 'customer_satisfaction',
                    'recall_count', 'recall_percent', 'product_quality_issues', 'cyber_incidents']:
            data["产品责任"][f"product_{key}"] = entry(f"product_{key}", gv(product_cur, key),
                                                       gv(product_prev, key))

        # 知识产权
        for key in ['patents_total', 'invention_total', 'invention_applications', 'utility_model_total',
                    'design_total', 'authorized_total', 'new_patents_year', 'software_copyright_total',
                    'trademarks_total']:
            data["知识产权保护"][f"ipr_{key}"] = entry(f"ipr_{key}", gv(ipr_cur, key), gv(ipr_prev, key))

        # 社区参与
        for key in ['charity_donations', 'community_investment']:
            data["社区参与"][f"community_{key}"] = entry_sum(f"community_{key}", gv(community_cur, key),
                                                         gv(community_prev, key))

        # 志愿活动
        for key in ['volunteer_participants', 'volunteer_hours']:
            data["志愿活动"][f"volunteer_{key}"] = entry_sum(f"volunteer_{key}", gv(volunteer_cur, key),
                                                         gv(volunteer_prev, key))
        return data
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取其他定量数据失败: {str(e)}")


@router.post("")
async def save_reasons(factory: str = Body(...), year: int = Body(...), reasons: Dict[str, str] = Body(...),
                       db: Session = Depends(get_db), current_user: dict = Depends(get_current_user)):
    try:
        require_factory(factory, current_user)
        for indicator, reason in reasons.items():
            existing = db.query(OtherReason).filter(OtherReason.factory == factory, OtherReason.year == year,
                                                    OtherReason.indicator == indicator).first()
            if existing:
                existing.reason = reason
            else:
                db.add(OtherReason(factory=factory, year=year, indicator=indicator, reason=reason))
        db.commit()
        return {"status": "success", "message": "其他定量原因说明已保存"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"保存其他原因失败: {str(e)}")
