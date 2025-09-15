from typing import Dict

from fastapi import APIRouter, Depends, HTTPException, Query, Body
from sqlalchemy.orm import Session

from core.dependencies import get_db, indicators
from core.models import LaborQualitative
from core.permissions import require_access, get_current_user, require_factory, check_factory_year

router = APIRouter(prefix="/analytical/social_qualitative_labor", tags=["分析数据-社会定性-劳工"])

# 定性：劳动
QUAL_INDICATORS = {"雇佣": ["员工聘用及解雇", "行业员工流失率", "光大同创的员工流失率与行业流失率", "薪酬管理"],
                   "职业健康与安全": ["职业健康安全管理体系", "安全生产政策", "保障职业健康与安全目标",
                                      "保障职业健康与安全目标措施", "危害识别、风险评估和事故调查",
                                      "职业健康安全事务：工作者的参与、意见征询和沟通", "工作者职业健康安全培训",
                                      "促进工作者健康"],
                   "员工满意度": ["员工满意度调查计划", "员工满意度调查覆盖率/覆盖情况", "员工满意度项目排名"],
                   "员工关爱": ["提供给全职员工（不包括临时或兼职员工）的福利", "员工关爱"],
                   "培训": ["年度培训计划小时数目标", "年度培训计划小时数目标达成率（%）", "年度培训计划",
                            "年度培训计划达成率（%）"], "多元化与平等机会": ["多元化和机会平等", "晋升机制"],
                   "反歧视": ["歧视事件及采取的纠正行动"], "童工": ["具有重大童工事件风险的运营点和供应商"],
                   "强迫或强制劳动": ["具有强迫或强制劳动事件重大风险的运营点和供应商"], "民主权益": ["民主管理"],
                   "应急管理": ["应急管理体系", "安全应急措施"]}


@router.get("")
async def get_labor_qualitative(factory: str = Query(...), year: int = Query(...), db: Session = Depends(get_db),
                                current_user: dict = Depends(get_current_user)):
    try:
        require_access(factory, current_user)
        # 获取当前年数据
        current_rows = db.query(LaborQualitative).filter(LaborQualitative.factory == factory,
                                                         LaborQualitative.year == year).all()
        current_data = {r.indicator: r for r in current_rows}

        # 获取上一年数据
        prev_rows = db.query(LaborQualitative).filter(LaborQualitative.factory == factory,
                                                     LaborQualitative.year == year - 1).all()
        prev_data = {r.indicator: r for r in prev_rows}

        # 组装结构：{类别: {indicatorKey: {currentText, comparisonText, reason}}}
        result = {}
        for category, indicator in indicators["social_qual_labor"].items():
            group = {}
            for ind in indicator:
                current_record = current_data.get(ind)
                prev_record = prev_data.get(ind)

                group[ind] = {
                    "currentText": current_record.current_text if current_record else "",
                    "lastText": prev_record.current_text if prev_record else "",
                    "comparisonText": current_record.comparison_text if current_record else "",
                    "reason": current_record.reason if current_record else ""
                }
            result[category] = group
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取劳动定性数据失败: {str(e)}")


@router.post("")
async def save_labor_qualitative(factory: str = Body(..., description="工厂名称"),
                                 year: int = Body(..., description="统计年份"),
                                 isSubmitted: bool = Body(..., description="是否提交"),
                                 data: Dict[str, Dict[str, Dict[str, str]]] = Body(...), db: Session = Depends(get_db),
                                 current_user: dict = Depends(get_current_user)):
    try:
        require_factory(factory, current_user)
        check = check_factory_year(factory, year, db, isSubmitted, 3)
        if check["status"] == "fail":
            return check
        for category, indicators in data.items():
            for indicator, payload in indicators.items():
                r = db.query(LaborQualitative).filter(LaborQualitative.factory == factory,
                                                      LaborQualitative.year == year,
                                                      LaborQualitative.indicator == indicator).first()
                if r:
                    r.current_text = payload.get('currentText', r.current_text)
                    r.comparison_text = payload.get('comparisonText', r.comparison_text)
                    r.reason = payload.get('reason', r.reason)
                else:
                    db.add(LaborQualitative(factory=factory, year=year, indicator=indicator,
                                            current_text=payload.get('currentText', ''),
                                            comparison_text=payload.get('comparisonText', ''),
                                            reason=payload.get('reason', '')))
        db.commit()
        return {"status": "success", "message": "劳动定性内容已保存"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"保存劳动定性失败: {str(e)}")
