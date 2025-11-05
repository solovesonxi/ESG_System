import json
from typing import Any, List, Optional

from sqlalchemy.orm import Session

from core.dependencies import logger
from core.dynamic_mapping import get_model_for_category
from core.models import FieldData, Category, Revenue


def get_field_value_by_id(fid: int, coefficient: float, db: Session, factory: str, year: int,
                          mode: str = "总和") -> float:
    field = db.query(FieldData.category, FieldData.name_en).filter_by(id=fid).first()
    if not field:
        return 0
    category = db.query(Category).filter_by(id=field.category).first()
    if not category:
        return 0
    elif category.period_type == "month":
        query = db.query(get_model_for_category(db, field.category)).filter_by(year=year)
        if isinstance(factory, str) and factory.strip():
            query = query.filter_by(factory=factory.strip())
        data = query.all()
        if not data:
            return 0
        vals = [getattr(d, field.name_en, []) for d in data]
        if mode == "总和":
            return sum(sum(v) for v in vals if isinstance(v, list)) * coefficient
        elif mode == "最终有效值":
            total = 0
            for v in vals:
                if isinstance(v, list):
                    for mv in reversed(v):
                        if mv not in (0, None, ""):
                            total += mv
                            break
            return total * coefficient
        elif mode == "最大":
            return sum(max(v) for v in vals if isinstance(v, list)) * coefficient
        elif mode == "最小":
            return sum(min(v) for v in vals if isinstance(v, list)) * coefficient
        elif mode == "平均":
            total, count = 0.0, 0
            for sub in vals:
                if not isinstance(sub, list):
                    continue
                for x in sub:
                    if x in (None, "") or x == 0:
                        continue
                    try:
                        num = float(x)
                    except ValueError:
                        continue
                    total += num
                    count += 1
            return coefficient * (total / count) if count > 0 else 0.0
        elif mode == "对比去年":
            model = get_model_for_category(db, field.category)
            total_diff = 0.0
            for row in data:
                factory_name = getattr(row, "factory", None)
                # 计算当前行的和值
                curr_val = getattr(row, field.name_en, [])
                curr_sum = 0.0
                if isinstance(curr_val, list):
                    curr_sum = sum(curr_val)
                # 查找同厂去年的记录并计算去年和值
                last_sum = 0.0
                if factory_name and model:
                    last_row = db.query(model).filter_by(factory=factory_name, year=year - 1).first()
                    if last_row:
                        last_val = getattr(last_row, field.name_en, [])
                        if isinstance(last_val, list):
                            last_sum = sum(last_val)
                        elif isinstance(last_val, (int, float)):
                            last_sum = float(last_val)
                total_diff += (curr_sum - last_sum)
            return total_diff * coefficient
    elif category.period_type == "year":
        field = db.query(FieldData).filter_by(id=fid).first()
        return compute_field_value(field.calculation, db, factory, year) * coefficient
    return 0


def compute_sum_total(fields: List[int], coefficient: List[float], db: Session, factory: str, year: int) -> float:
    total = 0
    for i in range(len(fields)):
        total += get_field_value_by_id(fields[i], coefficient[i], db, factory, year)
    return total


def compute_intensity(fields: int, coefficient: float, db: Session, factory: str, year: int) -> Optional[
    float]:
    numerator = get_field_value_by_id(fields, coefficient, db, factory, year)
    query = db.query(Revenue.amount).filter_by(year=year)
    if isinstance(factory, str) and factory.strip():
        query = query.filter_by(factory=factory.strip())
    data = query.all()
    revenue = sum(d[0] for d in data if d and d[0] is not None)
    if revenue and revenue != 0:
        return numerator / revenue
    return None


def compute_quotient(fields: List[int], coefficient: List[float], db: Session, factory: str, year: int) -> Optional[
    float]:
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

    op = calc.get("operation", "总和")
    fields = calc.get("fields", [])
    coefficient = calc.get("coefficient", [1] * len(fields))
    res = None
    if op == "强度":
        res = compute_intensity(fields[0], coefficient[0], db, factory, year)
    elif len(fields) == 1:
        res = get_field_value_by_id(fields[0], coefficient[0], db, factory, year, op)
    elif op == "总和":
        res = compute_sum_total(fields, coefficient, db, factory, year)
    elif op == "占比":
        res = compute_quotient(fields, coefficient, db, factory, year)
    if res is None:
        return None
    return round(res, 4 if op == "强度" else 2)
