import json
from typing import Any, List, Optional

from sqlalchemy.orm import Session

from core.dependencies import logger
from core.dynamic_mapping import get_model_for_category
from core.models import FieldData, Category, Revenue


def get_field_value_by_id(fid: int, coefficient: float, db: Session, factory: str, year: int, mode: str = "总和") -> float:
    """
    根据字段id查询字段值，自动处理int、float、list、str类型。
    mode: "sum"（默认，求和），"last_nonzero"（取list最后一个有效值）
    coefficient: 系数，默认1
    """
    field = db.query(FieldData.category, FieldData.name_en).filter_by(id=fid).first()
    if not field:
        return 0
    # id来自于月度数据表格、
    category = db.query(Category).filter_by(id=field.category).first()
    if not category:
        return 0
    elif category.period_type == "month":
        cat = db.query(get_model_for_category(db, field.category)).filter_by(factory=factory, year=year).first()
        if not cat:
            return 0
        val = getattr(cat, field.name_en, 0)
        if val is None:
            return 0
        if isinstance(val, (int, float)):
            return val * coefficient
        elif isinstance(val, list):
            if mode == "总和":
                return sum(val) * coefficient
            elif mode == "最终有效值":
                for v in reversed(val):
                    if v not in (0, None, ""):
                        return v
                return 0
            elif mode == "最大":
                return max(val) * coefficient
            elif mode == "最小":
                return min(val) * coefficient
            elif mode == "平均":
                valid_vals = [v for v in val if v not in (None, "") and v != 0]
                return coefficient * (sum(valid_vals) / len(valid_vals)) if valid_vals else 0
            elif mode == "对比去年":
                last_cat = db.query(get_model_for_category(db, field.category)).filter_by(factory=factory, year=year-1).first()
                if not last_cat:
                    return sum(val) * coefficient
                last_val = getattr(last_cat, field.name_en, [])
                if isinstance(last_val, list):
                    return (sum(val) - sum(last_val)) * coefficient
    elif category.period_type == "year":
        field = db.query(FieldData).filter_by(id=fid).first()
        return compute_field_value(field.calculation, db, factory, year) * coefficient
    return 0

def compute_sum_total(fields: List[int], coefficient: List[float],  db: Session, factory: str, year: int) -> float:
    """
    fields: 字段id数组
    """
    total = 0
    for i in range(len(fields)):
        total += get_field_value_by_id(fields[i], coefficient[i], db, factory, year)
    return total

def compute_intensity(fields: List[int], coefficient: List[float], db: Session, factory: str, year: int) -> Optional[float]:
    """
    fields: [消耗品id]
    """
    if len(fields) != 2:
        return None
    numerator = get_field_value_by_id(fields[0], coefficient[0], db, factory, year)
    denominator = db.query(Revenue.amount).filter_by(factory=factory, year=year).first()
    if denominator and denominator[0] and denominator[0] != 0:
        return numerator / denominator[0]
    return None

def compute_quotient(fields: List[int],  coefficient: List[float], db: Session, factory: str, year: int) -> Optional[float]:
    """
    fields: [被除数id, 除数id]
    """
    if len(fields) != 2:
        return None
    numerator = get_field_value_by_id(fields[0], coefficient[0], db, factory, year)
    denominator = get_field_value_by_id(fields[1], coefficient[1], db, factory, year)
    if denominator == 0:
        return None
    return numerator / denominator


def compute_field_value(calculation: Optional[str], db: Session, factory: str, year: int) -> Any:
    if not calculation:
        return None
    try:
        if isinstance(calculation, dict):
            calc = calculation
        else:
            calc = json.loads(calculation)
    except Exception as e:
        logger.error(f"解析 calculation 失败: {e}")
        return None

    op = calc.get("operation") or "总和"
    fields = calc.get("fields", [])
    coefficient = calc.get("coefficient", [1] * len(fields))
    if len(fields) == 1:
        return get_field_value_by_id(fields[0], coefficient[0], db, factory, year, op)
    elif op == "总和":
        return compute_sum_total(fields, coefficient, db, factory, year)
    elif op == "强度":
        return compute_intensity(fields, coefficient, db, factory, year)
    elif op == "占比":
        return compute_quotient(fields, coefficient, db, factory, year)
    return None
