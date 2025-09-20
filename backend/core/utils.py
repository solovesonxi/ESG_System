from datetime import datetime, timezone
from typing import Type, Any

from fastapi import Depends, HTTPException, status
from sqlalchemy import and_
from sqlalchemy.orm import Session

from core.dependencies import indicators
from core.models import MaterialData, EnergyData, WaterData, EmissionData, WasteData, InvestmentData, ManagementData, \
    EmploymentData, TrainingData, OHSData, SatisfactionData, SupplyData, ResponsibilityData, IPData, CommunityData, \
    LaborQualitative, OtherReason, OtherQualitative, Governance, EnvQuantData, EnvQualData, Message, LaborReason, \
    ReviewRecord
from core.permissions import get_current_user

QUANT_MODEL_MAP = {"material": MaterialData, "energy": EnergyData, "water": WaterData, "emission": EmissionData,
                   "waste": WasteData, "investment": InvestmentData, "management": ManagementData,
                   "employment": EmploymentData, "training": TrainingData, "ohs": OHSData,
                   "satisfaction": SatisfactionData, "supply": SupplyData, "responsibility": ResponsibilityData,
                   "ip": IPData, "community": CommunityData, }
ANALY_MODEL_MAP = {"env_quant": EnvQuantData, "env_qual": EnvQualData, "social_quant_labor": LaborReason,
                   "social_quant_other": OtherReason, "social_qual_labor": LaborQualitative,
                   "social_qual_other": OtherQualitative, "governance": Governance}


def _calc_comparison(current_value, last_value):
    try:
        if last_value is None or last_value == 0 or current_value is None:
            return None
        value = ((current_value - last_value) / last_value) * 100
        return round(value, 2)
    except Exception:
        return None


def require_view(factory: str, data_type: str, current_user: dict = Depends(get_current_user)):
    user = current_user["user"]
    role = current_user["role"]
    if role == "headquarter" or role == "admin":
        return
    if role == "factory" and user.factory == factory:
        return
    if role == "department" and user.factory == factory and data_type in user.departments:
        return
    raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="无权访问其他工厂数据")


def require_edit(factory: str, data_type: str, current_user: dict = Depends(get_current_user)):
    if current_user["role"] == "headquarter":
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="总部账号无权提交数据")
    elif current_user["role"] == "admin":
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="管理员账号无权提交数据")
    elif current_user["factory"] != factory:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="无权提交其他工厂数据")
    else:
        if current_user["role"] == "factory":
            if data_type not in ANALY_MODEL_MAP:
                raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="无权提交子部门月度数据")
        elif current_user["role"] == "department":
            if not (current_user["departments"] and data_type in current_user["departments"]):
                raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="无权提交其他部门数据")
            if data_type not in QUANT_MODEL_MAP:
                raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="无权提交工厂年度数据")
        else:
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="未知类型账号无权提交数据")


# 部门提交月度定量数据通用函数
async def submit_data(db: Session, model: Type[Any], data: Any, current_user: dict, field_mapping: str):
    try:
        require_edit(data.factory, field_mapping, current_user)
        # 1. 检查是否已提交
        review_record = db.query(ReviewRecord).filter_by(factory=data.factory, year=data.year,
                                                         month=getattr(data, "month", None),
                                                         data_type=field_mapping).first()
        if review_record and review_record.is_submitted:
            return {"status": "fail", "message": "数据已提交过，请等待审核"}
        # 2. 保存业务数据
        existing = db.query(model).filter(
            and_(getattr(model, "factory") == data.factory, getattr(model, "year") == data.year)).first()
        record_data = {field: getattr(data, key) for key, field in indicators[field_mapping]["submit"].items()}
        if existing:
            for k, v in record_data.items():
                setattr(existing, k, v)
            db.merge(existing)
        else:
            db_record = model(**record_data)
            db.add(db_record)
        # 3. 更新/新建审核记录
        if not review_record:
            review_record = ReviewRecord(factory=data.factory, year=data.year, month=getattr(data, "month", None),
                                         data_type=field_mapping)
            db.add(review_record)
        if data.isSubmitted:
            review_record.is_submitted = True
            review_record.level1_status = "pending"
            review_record.level1_comment = None
            review_record.level1_reviewer = None
            review_record.level1_review_time = None
            review_record.level2_status = "pending"
            review_record.level2_comment = None
            review_record.level2_reviewer = None
            review_record.level2_review_time = None
        db.commit()
        # 4. 推送消息
        now_str = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        msg_title = f"{"提交" if data.isSubmitted else "保存"}了{data.factory}{data.year}年{getattr(data, 'month', '')}月的{indicators['categories'][field_mapping]}数据"
        if data.isSubmitted:
            msg_content = f"{current_user['user'].username}于{now_str}{msg_title}，请工厂及时审核。"
            send_message(db, "月报", msg_title, msg_content, sender_factory=data.factory,
                         sender_department=field_mapping, receiver_factory=data.factory)
        send_message(db, "最近操作", msg_title, receiver_role='department', receiver_factory=data.factory,
                     receiver_department=field_mapping)
        return {"status": "success"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"数据提交失败: {str(e)}")


# 通用单条消息发送函数
def send_message(db: Session, msg_type: str, title: str, content: str = None, sender_role: str = "department",
                 sender_factory: str = None, sender_department: str = None, receiver_role: str = "factory",
                 receiver_factory: str = None, receiver_department: str = None):
    db.add(Message(type=msg_type, title=title, content=content, sender_role=sender_role, sender_factory=sender_factory,
                   sender_department=sender_department, receiver_role=receiver_role, receiver_factory=receiver_factory,
                   receiver_department=receiver_department, created_at=datetime.now(timezone.utc), is_read=False))
    db.commit()


# 工厂提交年度定性/定量数据通用函数
def send_yearly_message(db, current_user: dict, factory, year, is_submitted, data_type, msg_type="年报",
                        msg_title=None):
    now_str = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    if not msg_title:
        msg_title = f"{"提交" if is_submitted else "保存"}了{factory}工厂{year}年的{indicators["categories"][data_type]}数据"
    if is_submitted:
        msg_content = f"{current_user["user"].username}于{now_str}{msg_title}，请管理员和总部及时审核。"
        send_message(db, msg_type, msg_title, msg_content, sender_role="factory", sender_factory=factory,
                     receiver_role='headquarter')
        send_message(db, msg_type, msg_title, msg_content, sender_role="factory", sender_factory=factory,
                     receiver_role='admin')
    send_message(db, "最近操作", msg_title, sender_role="factory", receiver_factory=factory)


# 获取各类数据审核信息
def get_review_info(db, factory, year, data_type, months=12):
    # 判断类型
    is_quant = data_type in QUANT_MODEL_MAP
    is_analytical = data_type in ANALY_MODEL_MAP
    fields = [("id", "id", -1), ("is_submitted", "is_submitted", False), ("level1_status", "status1", "pending"),
              ("level1_comment", "comment1", ""), ("level2_status", "status2", "pending"),
              ("level2_comment", "comment2", "")]
    if is_quant:
        # 定量月报，返回数组
        review_records = db.query(ReviewRecord).filter_by(factory=factory, data_type=data_type, year=year).all()
        result = {name: [default] * months for _, name, default in fields}
        for rec in review_records:
            month_idx = rec.month - 1 if rec.month else 0
            if 0 <= month_idx < months:
                for field, name, default in fields:
                    value = getattr(rec, field)
                    result[name][month_idx] = value if value is not None else default
        return result
    elif is_analytical:
        # 定性年报，返回单值
        review_record = db.query(ReviewRecord).filter_by(factory=factory, data_type=data_type, year=year).order_by(
            ReviewRecord.month.asc()).first()
        result = {}
        for field, name, default in fields:
            value = getattr(review_record, field) if review_record else default
            result[name] = value if value is not None else default
        return result
    else:
        # 未知类型，返回空
        return {name: None for _, name, _ in fields}


def check_review_record(db, factory, year, data_type, is_submitted):
    try:
        review_record = db.query(ReviewRecord).filter_by(factory=factory, year=year, data_type=data_type).first()
        if review_record and review_record.is_submitted:
            return {"status": "success", "message": "数据已提交过，请等待审核"}
        if is_submitted:
            if not review_record:
                review_record = ReviewRecord(factory=factory, year=year, data_type=data_type)
                db.add(review_record)
            review_record.is_submitted = True
            review_record.level1_status = "pending"
            review_record.level1_comment = None
            review_record.level1_reviewer = None
            review_record.level1_review_time = None
            review_record.level2_status = None
            review_record.level2_comment = None
            review_record.level2_reviewer = None
            review_record.level2_review_time = None
        db.commit()
        return {"status": "success"}
    except Exception as e:
        db.rollback()
        return {"status": "fail", "message": f"审核记录检查/创建失败: {str(e)}"}
