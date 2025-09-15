from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from core.dependencies import indicators, get_db
from core.models import LaborQualitative, OtherReason, OtherQualitative
from core.models import MaterialData, EnergyData, WaterData, EmissionData, WasteData, InvestmentData, ManagementData, \
    EmploymentData, TrainingData, OHSData, SatisfactionData, SupplyData, ResponsibilityData, IPData, CommunityData

router = APIRouter(prefix="/progress", tags=["进度查询"])

MODEL_MAP = {"material": MaterialData, "energy": EnergyData, "water": WaterData, "emission": EmissionData,
             "waste": WasteData, "investment": InvestmentData, "management": ManagementData,
             "employment": EmploymentData, "training": TrainingData, "ohs": OHSData, "satisfaction": SatisfactionData,
             "supply": SupplyData, "responsibility": ResponsibilityData, "ip": IPData, "community": CommunityData, }


@router.get("/quantitative")
def calc_quantitative_progress(factory: str, year: int, db: Session = Depends(get_db)):
    env_models = ["material", "energy", "water", "emission", "waste", "investment", "management"]
    labor_models = ["employment", "training", "ohs", "satisfaction"]
    other_models = ["supply", "responsibility", "ip", "community"]
    data_dict = {}
    for model_name in env_models + labor_models + other_models:
        model = MODEL_MAP.get(model_name)
        if model:
            data = db.query(model).filter_by(factory=factory, year=year).first()
            data_dict[model_name] = data

    def is_json_field(model_cls, field):
        column = getattr(model_cls, field, None)
        return column is not None and hasattr(column, 'type') and 'JSON' in str(column.type)

    def count_json_field_progress(value, is_submitted):
        if not isinstance(value, list):
            return 0, 0
        total = len(value)
        submitted = 0
        for i, v in enumerate(value):
            if is_submitted and isinstance(is_submitted, list) and i < len(is_submitted):
                if is_submitted[i]:
                    submitted += 1
                elif v not in [None, "", 0]:
                    submitted += 1
            else:
                if v not in [None, "", 0]:
                    submitted += 1
        return total, submitted

    def count_submit_fields(models):
        total, submitted = 0, 0
        for m in models:
            submit_fields = indicators[m]["submit"].values()
            data = data_dict.get(m)
            model_cls = MODEL_MAP.get(m)
            is_submitted = getattr(data, "is_submitted", None) if data else None
            for field in submit_fields:
                if is_json_field(model_cls, field):
                    value = getattr(data, field, []) if data else []
                    t, s = count_json_field_progress(value, is_submitted)
                    total += t if t else 12
                    submitted += s
                else:
                    value = getattr(data, field, None) if data else None
                    total += 1
                    if value not in [None, "", 0]:
                        submitted += 1
        return round(submitted / total * 100, 2) if total else 0

    return {"environment": count_submit_fields(env_models), "social_labor": count_submit_fields(labor_models),
            "social_other": count_submit_fields(other_models)}


@router.get("/analytical")
def calc_analytical_progress(factory: str, year: int, db: Session = Depends(get_db)):
    from core.models import YearInfo, EnvQualData, LaborReason
    year_info = db.query(YearInfo).filter_by(factory=factory, year=year).first()
    is_submitted = year_info.is_submitted if year_info and hasattr(year_info, "is_submitted") else [False] * 7
    result = {}

    if is_submitted[0]:  # env_quantitative (index=0)
        result["env_quant"] = 100.00
    else:
        quant_models = [MaterialData, EnergyData, WaterData, EmissionData, WasteData, InvestmentData, ManagementData]
        total, filled = 0, 0
        for model in quant_models:
            data = db.query(model).filter_by(factory=factory, year=year).first()
            value = getattr(data, "reasons", []) if data else []
            if isinstance(value, list):
                total += len(value)
                filled += sum(1 for v in value if v not in [None, ""])
        result["env_quant"] = round(filled / total * 100, 2) if total else 0

    if is_submitted[1]:  # env_qual (index=1)
        result["env_qual"] = 100.00
    else:
        data = db.query(EnvQualData).filter_by(factory=factory, year=year).first()
        if data:
            exclude = {"factory", "year", "comparison", "reasons"}
            fields = [c.name for c in EnvQualData.__table__.columns.values() if c.name not in exclude]
            total = len(fields)
            filled = sum(1 for f in fields if getattr(data, f, None) not in [None, ""])
            result["env_qual"] = round(filled / total * 100, 2) if total else 0
        else:
            result["env_qual"] = 0

    # 社会定量-劳工进度计算 - 统计labor_reasons表中已填报的reason数量
    if is_submitted[2]:  # social_quantitative_labor (index=2)
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

    # 社会定性-劳工进度计算 - 统计labor_qualitative表中已填报的字段各项数量
    if is_submitted[3]:  # social_qualitative_labor (index=3)
        result["social_qual_labor"] = 100.00
    else:
        all_indicators = []
        for category_indicators in indicators["social_qual_labor"].values():
            all_indicators.extend(category_indicators)
        total = len(all_indicators) * 3  # 每个指标有3个字段需要填写
        qualitative_rows = db.query(LaborQualitative).filter(LaborQualitative.factory == factory,
                                                             LaborQualitative.year == year).all()
        filled = 0
        for row in qualitative_rows:
            if row.current_text and row.current_text.strip():
                filled = filled + 1
            if row.comparison_text and row.comparison_text.strip():
                filled = filled + 1
            if row.reason and row.reason.strip():
                filled = filled + 1
        result["social_qual_labor"] = round(filled / total * 100, 2) if total else 0

    # 社会定量-其他进度计算 - 统计other_reasons表中已填报的reason数量
    if is_submitted[4]:  # social_quantitative_other (index=4)
        result["social_quant_other"] = 100.00
    else:
        all_fields = [field for category in indicators["social_quant_other"].values() for field in category]
        total = len(all_fields)
        reasons_rows = db.query(OtherReason).filter(OtherReason.factory == factory, OtherReason.year == year).all()
        reasons_map = {row.indicator: row.reason for row in reasons_rows}
        filled = sum(1 for field in all_fields if reasons_map.get(field, "").strip())
        result["social_quant_other"] = round(filled / total * 100, 2) if total else 0

    # 社会定性-其他进度计算 - 统计other_qualitative表中已填报的字段各项数量
    if is_submitted[5]:  # social_qualitative_other (index=5)
        result["social_qual_other"] = 100.00
    else:
        all_indicators = [ind for category in indicators["social_qual_other"].values() for ind in category]
        total_fields = len(all_indicators) * 3  # 每个字段需要填写 current_text, comparison_text, reason
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
        result["social_qual_other"] = round(filled / total_fields * 100, 2) if total_fields else 0
    result["governance"] = 100.00 if is_submitted[6] else 0
    return result
