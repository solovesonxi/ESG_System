from datetime import datetime

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy import or_, and_
from sqlalchemy.orm import Session

from core.dependencies import get_db, indicators, logger
from core.models import ReviewRecord
from core.permissions import get_current_user
from core.utils import send_message

router = APIRouter(prefix="/review", tags=["审核"])

from core.schemas import ReviewUpdateRequest


@router.patch("/")
async def update_review_status(request: ReviewUpdateRequest, db: Session = Depends(get_db),
                               current_user: dict = Depends(get_current_user)):
    role = current_user["role"]
    username = current_user["user"].username if hasattr(current_user["user"], "username") else current_user["user"][
        "username"]
    if role == "department":
        raise HTTPException(status_code=403, detail="部门账号无审核权限")
    if request.level not in [1, 2]:
        raise HTTPException(status_code=400, detail="审核级别错误")
    record = db.query(ReviewRecord).filter_by(id=request.id).first()
    if not record:
        raise HTTPException(status_code=404, detail="数据暂未提交，无法审核")
    factory = str(record.factory)
    department = str(record.data_type)
    now_str = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    action = '审核通过' if request.status == "approved" else '驳回' if request.status == "rejected" else '反审核'
    record.is_submitted = True if request.status == "approved" else False if request.status == "rejected" else record.is_submitted
    if request.level == 1:
        if record.level1_comment or record.level1_reviewer or record.level1_review_time:
            raise HTTPException(status_code=400, detail="该数据已被一级审核，无法重复审核")
        record.level1_status = request.status
        record.level1_comment = request.comment
        record.level1_reviewer = username
        record.level1_review_time = datetime.now()
        # 工厂审核部门月度数据
        if record.month:
            msg_title = f"{action}了{factory}{record.year}年{record.month}月的{indicators['categories'][department]}数据"
            msg_content = f"{username}于{now_str}{msg_title}"
            send_message(db, "审核", msg_title, msg_content + "，请悉知。", sender_role=role, receiver_role='department',
                         receiver_factory=factory, receiver_department=department)
            if request.status == "approved":
                send_message(db, "审核", msg_title, msg_content + "，请总部审核。", sender_role=role,
                             receiver_role='headquarter')
                send_message(db, "审核", msg_title, msg_content + "，请管理员审核。", sender_role=role,
                             receiver_role='admin')
            send_message(db, "最近操作", msg_title, sender_role=role, receiver_role=role)
        # 总部审核工厂年度数据
        else:
            msg_title = f"{action}了{factory}{record.year}年的{indicators['categories'][department]}数据"
            msg_content = f"{username}于{now_str}{msg_title}"
            send_message(db, "审核", msg_title, msg_content, sender_role=role, receiver_role='factory',
                         receiver_factory=factory)
            send_message(db, "最近操作", msg_title, sender_role=role, receiver_role=role)
    elif request.level == 2:
        if role != "headquarter" and role != "admin":
            raise HTTPException(status_code=403, detail="只有总部和管理员账号有二级审核权限")
        if record.level2_comment or record.level2_reviewer or record.level2_review_time:
            raise HTTPException(status_code=400, detail="该数据已被二级审核，无法重复审核")
        record.level2_status = request.status
        record.level2_comment = request.comment
        record.level2_reviewer = username
        record.level2_review_time = datetime.now()
        # 总部二次审核部门月度数据
        if record.month:
            msg_title = f"{action}了{factory}{record.year}年{record.month}月的{indicators['categories'][department]}数据"
            msg_content = f"{username}于{now_str}{msg_title}"
            send_message(db, "审核", msg_title, msg_content, sender_role=role, receiver_role='factory',
                         receiver_factory=factory)
            send_message(db, "审核", msg_title, msg_content, sender_role=role, receiver_role='department',
                         receiver_factory=factory, receiver_department=department)
            send_message(db, "最近操作", msg_title, sender_role=role, receiver_role=role)

    db.commit()
    return {"status": "success", "id": request.id, "message": "审核状态已更新"}


@router.get("/")
async def get_review_records(db: Session = Depends(get_db), current_user: dict = Depends(get_current_user),
                             page: int = Query(1, ge=1), page_size: int = Query(10, ge=1, le=10),
                             factory: str = Query(None), department: str = Query(None), year: int = Query(None),
                             month: int = Query(None), is_submitted: bool = Query(None),
                             level1_status: str = Query(None), level2_status: str = Query(None),
                             comment_keyword: str = Query(None)):
    role = current_user["role"]
    user_factory = current_user.get("factory")
    departments = current_user.get("departments", [])
    query = db.query(ReviewRecord)

    # 权限过滤
    if role == "factory":
        query = query.filter(ReviewRecord.factory == user_factory)
    elif role == "department":
        query = query.filter(ReviewRecord.factory == user_factory, ReviewRecord.data_type.in_(departments))
    elif role not in ["admin", "headquarter"]:
        raise HTTPException(status_code=403, detail="无权限访问审核记录")
    logger.info(f"get_review_records: {role}, {user_factory}, {departments}")
    logger.info(
        f"筛选 - factory: {factory}, department: {department}, year: {year}, month: {month}, is_submitted: {is_submitted}, level1_status: {level1_status}, level2_status: {level2_status}, comment_keyword: {comment_keyword}")
    # 筛选条件
    if factory:
        query = query.filter(ReviewRecord.factory == factory)
    if department:
        query = query.filter(ReviewRecord.data_type == department)
    if year:
        query = query.filter(ReviewRecord.year == year)
    if month is not None:
        query = query.filter(ReviewRecord.month == month)
    if is_submitted is not None:
        query = query.filter(ReviewRecord.is_submitted == is_submitted)
    if level1_status:
        query = query.filter(ReviewRecord.level1_status == level1_status)
    if level2_status:
        query = query.filter(ReviewRecord.level2_status == level2_status)
    if comment_keyword:
        query = query.filter(
            or_(and_(ReviewRecord.level1_comment != None, ReviewRecord.level1_comment.contains(comment_keyword)),
                and_(ReviewRecord.level2_comment != None, ReviewRecord.level2_comment.contains(comment_keyword))))
    total = query.count()
    records = query.order_by(ReviewRecord.id.desc()).offset((page - 1) * page_size).limit(page_size).all()

    # 转为dict，去除SQLAlchemy对象属性
    def record_to_dict(r):
        return {"id": r.id, "factory": r.factory, "data_type": r.data_type, "year": r.year, "month": r.month,
                "is_submitted": r.is_submitted, "level1_status": r.level1_status, "level1_comment": r.level1_comment,
                "level2_status": r.level2_status, "level2_comment": r.level2_comment,
                "level1_reviewer": r.level1_reviewer, "level1_review_time": r.level1_review_time,
                "level2_reviewer": r.level2_reviewer, "level2_review_time": r.level2_review_time}

    return {"total": total, "records": [record_to_dict(r) for r in records]}
