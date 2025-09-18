from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core.dependencies import get_db, indicators
from core.models import YearInfo
from core.permissions import get_current_user
from core.utils import send_message, QUANT_MODEL_MAP, ANALY_MODEL_MAP

router = APIRouter(prefix="/review", tags=["审核"])

from core.schemas import ReviewUpdateRequest


@router.patch("/")
async def update_review_status(request: ReviewUpdateRequest, db: Session = Depends(get_db),
                               current_user: dict = Depends(get_current_user)):
    role = current_user["role"]
    if role == "factory":
        raise HTTPException(status_code=403, detail="无权限进行审核操作")
    if request.formType in QUANT_MODEL_MAP:
        model = QUANT_MODEL_MAP.get(request.formType)
        data = db.query(model).filter_by(factory=request.factory, year=request.year).first()
        if not data:
            raise HTTPException(status_code=404, detail="未找到数据")
        # 更新定量数据表的审核状态和评论
        for field, value in [("review_status", request.status), ("review_comment", request.comment)]:
            if hasattr(data, field):
                if request.month is not None:
                    arr = getattr(data, field).copy()
                    arr[request.month - 1] = value
                    setattr(data, field, arr)
                else:
                    setattr(data, field, [value] * 12)
        # 更新提交状态
        if hasattr(data, "is_submitted") and request.month is not None:
            is_submit = getattr(data, "is_submitted").copy()
            if request.status == "approved":
                is_submit[request.month - 1] = True
            elif request.status == "rejected":
                is_submit[request.month - 1] = False
            setattr(data, "is_submitted", is_submit)
    elif request.formType in ANALY_MODEL_MAP:
        # 处理分析数据 - 操作year_info表
        data = db.query(YearInfo).filter_by(factory=request.factory, year=request.year).first()
        if not data:
            raise HTTPException(status_code=404, detail="未找到年度信息数据")
        module_index = list(ANALY_MODEL_MAP.keys()).index(request.formType)
        # 更新year_info表的审核状态和评论
        review_status = data.review_status.copy()
        review_comment = data.review_comment.copy()
        review_status[module_index] = request.status
        review_comment[module_index] = request.comment
        data.review_status = review_status
        data.review_comment = review_comment
        is_submitted = data.is_submitted.copy()
        if request.status == "approved":
            is_submitted[module_index] = True
        elif request.status == "rejected":
            is_submitted[module_index] = False
        data.is_submitted = is_submitted
    else:
        raise HTTPException(status_code=400, detail="无效的formType")
    db.commit()
    action = "审核通过" if request.status == "approved" else "审核拒绝" if request.status == "rejected" else "反审核"
    month_str = f"{request.month}月" if request.month is not None else ""
    title = f"{action}了{request.factory}{request.year}年{month_str}的{indicators["categories"][request.formType]}数据"
    content = current_user["user"].username + title + "，请知悉。"
    send_message(db, "审核", title, content=content, sender_role=role, receiver_role="factory",
                 receiver_factory=request.factory)
    send_message(db, "最近操作", title, sender_role=role, receiver_role=role)
    send_message(db, "审核", title, sender_role=role, receiver_role="headquarter" if role == "admin" else "admin")
    return {"status": "success"}
