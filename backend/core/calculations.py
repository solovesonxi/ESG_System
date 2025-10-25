import json
from typing import Any, List, Optional

from sqlalchemy.orm import Session

from core.dependencies import logger
from core.dynamic_mapping import get_model_for_category
from core.models import FieldData, Category


def get_field_value_by_id(fid: int, db: Session, factory: str, year: int, mode: str = "sum") -> float:
    """
    根据字段id查询字段值，自动处理int、float、list、str类型。
    mode: "sum"（默认，求和），"last_nonzero"（取list最后一个有效值）
    """
    field = db.query(FieldData.category, FieldData.name_en).filter_by(id=fid).first()
    if not field:
        return 0
    cat = db.query(get_model_for_category(db, field.category)).filter_by(factory=factory, year=year).first()
    if not cat:
        return 0
    val = getattr(cat, field.name_en, 0)
    if val is None:
        return 0
    if isinstance(val, (int, float)):
        return val
    elif isinstance(val, list):
        if mode == "last_nonzero":
            for v in reversed(val):
                if v not in (0, None, ""):
                    return v
            return 0
        elif mode == "max":
            return max(val)
        elif mode == "min":
            return min(val)
        elif mode == "average":
            return sum(val) / len(val) if val else 0
        else:
            return sum(val)
    return 0

def compute_sum_total(fields: List[int], db: Session, factory: str, year: int) -> float:
    """
    fields: 字段id数组
    """
    total = 0
    for fid in fields:
        logger.info("计算字段 ID 为 {} 的值".format(fid))
        total += get_field_value_by_id(fid, db, factory, year)
    return total

def compute_quotient(fields: List[int], db: Session, factory: str, year: int) -> Optional[float]:
    """
    fields: [被除数id, 除数id]
    """
    if len(fields) != 2:
        return None
    numerator = get_field_value_by_id(fields[0], db, factory, year)
    denominator = get_field_value_by_id(fields[1], db, factory, year)
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

    op = (calc.get("operation") or "sum").lower()
    fields = calc.get("fields", [])
    if len(fields) == 1:
        return get_field_value_by_id(fields[0], db, factory, year, op)
    if op == "sum":
        return compute_sum_total(fields, db, factory, year)
    if op == "ratio":
        return compute_quotient(fields, db, factory, year)
    return None
