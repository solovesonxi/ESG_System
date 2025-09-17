from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from core.dependencies import indicators, get_db, logger
from core.models import LaborQualitative, OtherReason, OtherQualitative, Governance, EnvQuantData
from core.models import MaterialData, EnergyData, WaterData, EmissionData, WasteData, InvestmentData, ManagementData, \
    EmploymentData, TrainingData, OHSData, SatisfactionData, SupplyData, ResponsibilityData, IPData, CommunityData

router = APIRouter(prefix="/progress", tags=["进度查询"])

MODEL_MAP = {
    "material": MaterialData, "energy": EnergyData, "water": WaterData, "emission": EmissionData,
    "waste": WasteData, "investment": InvestmentData, "management": ManagementData,
    "employment": EmploymentData, "training": TrainingData, "ohs": OHSData, "satisfaction": SatisfactionData,
    "supply": SupplyData, "responsibility": ResponsibilityData, "ip": IPData, "community": CommunityData,
}


@router.get("/quantitative")
def calc_quantitative_progress(factory: str, year: int, db: Session = Depends(get_db)):
    data_dict = {}
    for category, model in MODEL_MAP.items():
        data_dict[category] = db.query(model).filter_by(factory=factory, year=year).first()

    def is_json_field(model_cls, field):
        column = getattr(model_cls, field, None)
        return column is not None and hasattr(column, 'type') and 'JSON' in str(column.type)

    def count_json_field_progress(value, is_submitted):
        if not isinstance(value, list):
            return 0, 0
        submitted = 0
        for i, v in enumerate(value):
            if v not in [None, "", 0]:
                submitted += 1
            elif is_submitted and isinstance(is_submitted, list) and i < len(is_submitted) and is_submitted[i]:
                submitted += 1
        return len(value), submitted

    def count_submit_fields(c):
        total, submitted = 0, 0
        submit_fields = indicators[c]["submit"].values()
        data = data_dict.get(c)
        model_cls = MODEL_MAP.get(c)
        is_submitted = getattr(data, "is_submitted", None) if data else None
        for field in submit_fields:
            if is_json_field(model_cls, field):
                value = getattr(data, field, []) if data else []
                t, s = count_json_field_progress(value, is_submitted)
                total += t if t else 12
                submitted += s if s else 0
            else:
                value = getattr(data, field, None) if data else None
                total += 1
                if value not in [None, "", 0]:
                    submitted += 1
        return round(submitted / total * 100, 2) if total else 0

    progress = {category: count_submit_fields(category) for category in MODEL_MAP.keys()}
    return progress


@router.get("/analytical")
def calc_analytical_progress(factory: str, year: int, db: Session = Depends(get_db)):
    from core.models import YearInfo, EnvQualData, LaborReason
    year_info = db.query(YearInfo).filter_by(factory=factory, year=year).first()
    is_submitted = year_info.is_submitted if year_info and hasattr(year_info, "is_submitted") else [False] * 7
    result = {}

    total_fields, total_filled = 0, 0

    if is_submitted[0]:  # env_quant (index=0)
        result["env_quant"] = 100.00
    else:
        all_fields = [field for category in indicators["env_quant"].values() for field in category]
        total = len(all_fields)
        reasons_rows = db.query(EnvQuantData).filter(EnvQuantData.factory == factory, EnvQuantData.year == year).all()
        reasons_map = {row.indicator: row.reason for row in reasons_rows}
        filled = sum(1 for field in all_fields if reasons_map.get(field, "").strip())
        result["env_quant"] = round(filled / total * 100, 2) if total else 0
        total_fields += total
        total_filled += filled

    if is_submitted[1]:  # env_qual (index=1)
        result["env_qual"] = 100.00
    else:
        data = db.query(EnvQualData).filter_by(factory=factory, year=year).first()
        if data:
            exclude = {"factory", "year", "comparison", "reasons"}
            fields = [c.name for c in EnvQualData.__table__.columns.values() if c.name not in exclude]
            total = len(fields) * 3
            filled = sum(1 for f in fields if getattr(data, f, None) not in [None, ""])
            comparison = getattr(data, "comparison", None)
            reasons  = getattr(data, "reasons", None)
            if comparison and isinstance(comparison, dict):
                filled += sum(1 for (_,v) in comparison.items() if v not in [None, ""])
            if reasons and isinstance(reasons, dict):
                filled += sum(1 for (_,v) in reasons.items() if v not in [None, ""])
            result["env_qual"] = round(filled / total * 100, 2) if total else 0
            total_fields += total
            total_filled += filled
        else:
            result["env_qual"] = 0

    if is_submitted[2]:  # social_quant_labor (index=2)
        result["social_quant_labor"] = 100.00
    else:
        labor_keys = indicators["social_quant_labor"]
        total = len(labor_keys)
        filled = 0
        reasons_rows = db.query(LaborReason).filter(LaborReason.factory == factory, LaborReason.year == year).all()
        reasons_map = {row.indicator: row.reason for row in reasons_rows}
        for key in labor_keys:
            reason = reasons_map.get(key, None)
            if reason not in (None, ""):
                filled += 1
        result["social_quant_labor"] = round(filled / total * 100, 2) if total else 0
        total_fields += total
        total_filled += filled

    if is_submitted[3]:  # social_qual_labor (index=3)
        result["social_qual_labor"] = 100.00
    else:
        all_indicators = []
        for category_indicators in indicators["social_qual_labor"].values():
            all_indicators.extend(category_indicators)
        total = len(all_indicators) * 3
        qualitative_rows = db.query(LaborQualitative).filter(LaborQualitative.factory == factory,
                                                             LaborQualitative.year == year).all()
        filled = 0
        for row in qualitative_rows:
            if row.current_text and row.current_text.strip():
                filled += 1
            if row.comparison_text and row.comparison_text.strip():
                filled += 1
            if row.reason and row.reason.strip():
                filled += 1
        result["social_qual_labor"] = round(filled / total * 100, 2) if total else 0
        total_fields += total
        total_filled += filled

    if is_submitted[4]:  # social_quant_other (index=4)
        result["social_quant_other"] = 100.00
    else:
        all_fields = [field for category in indicators["social_quant_other"].values() for field in category]
        total = len(all_fields)
        reasons_rows = db.query(OtherReason).filter(OtherReason.factory == factory, OtherReason.year == year).all()
        reasons_map = {row.indicator: row.reason for row in reasons_rows}
        filled = sum(1 for field in all_fields if reasons_map.get(field, "").strip())
        result["social_quant_other"] = round(filled / total * 100, 2) if total else 0
        total_fields += total
        total_filled += filled

    if is_submitted[5]:  # social_qual_other (index=5)
        result["social_qual_other"] = 100.00
    else:
        all_indicators = [ind for category in indicators["social_qual_other"].values() for ind in category]
        total = len(all_indicators) * 3
        filled = 0
        rows = db.query(OtherQualitative).filter(OtherQualitative.factory == factory,
                                                 OtherQualitative.year == year).all()
        for row in rows:
            if row.current_text and row.current_text.strip():
                filled += 1
            if row.comparison_text and row.comparison_text.strip():
                filled += 1
            if row.reason and row.reason.strip():
                filled += 1
        result["social_qual_other"] = round(filled / total * 100, 2) if total else 0
        total_fields += total
        total_filled += filled

    if is_submitted[6]:  # governance (index=6)
        result["governance"] = 100.00
    else:
        all_indicators = [ind for category in indicators["governance"].values() for ind in category]
        total = len(all_indicators) * 3
        filled = 0
        rows = db.query(Governance).filter(Governance.factory == factory,
                                           Governance.year == year).all()
        for row in rows:
            if row.current_text and row.current_text.strip():
                filled += 1
            if row.comparison_text and row.comparison_text.strip():
                filled += 1
            if row.reason and row.reason.strip():
                filled += 1
        result["governance"] = round(filled / total * 100, 2) if total else 0
        total_fields += total
        total_filled += filled

    result["total"] = round(total_filled / total_fields * 100, 2) if total_fields else 0
    return result
