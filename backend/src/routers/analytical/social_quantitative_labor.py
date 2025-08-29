from typing import Dict

from fastapi import APIRouter, Depends, HTTPException, Query, Body
from sqlalchemy.orm import Session

from src.core.database import get_db
from src.core.models import EmploymentData, TrainingData, OHSData, SatisfactionData, LaborReason
from src.utils import _calc_comparison

router = APIRouter(prefix="/analytical/social_quantitative_labor", tags=["分析模式-社会定量-劳工"])


@router.get("")
async def get_data(factory: str = Query(...), year: int = Query(...), db: Session = Depends(get_db)):
    try:
        # 当前年与去年数据
        emp_cur = db.query(EmploymentData).filter(EmploymentData.factory == factory,
                                                  EmploymentData.year == year).first()
        emp_prev = db.query(EmploymentData).filter(EmploymentData.factory == factory,
                                                   EmploymentData.year == year - 1).first()

        trn_cur = db.query(TrainingData).filter(TrainingData.factory == factory, TrainingData.year == year).first()
        trn_prev = db.query(TrainingData).filter(TrainingData.factory == factory, TrainingData.year == year - 1).first()

        ohs_cur = db.query(OHSData).filter(OHSData.factory == factory, OHSData.year == year).first()
        ohs_prev = db.query(OHSData).filter(OHSData.factory == factory, OHSData.year == year - 1).first()

        sat_cur = db.query(SatisfactionData).filter(SatisfactionData.factory == factory,
                                                    SatisfactionData.year == year).first()
        sat_prev = db.query(SatisfactionData).filter(SatisfactionData.factory == factory,
                                                     SatisfactionData.year == year - 1).first()

        # 读取原因
        reasons_rows = db.query(LaborReason).filter(LaborReason.factory == factory, LaborReason.year == year).all()
        reasons_map = {row.indicator: row.reason for row in reasons_rows}

        def entry(indicator_key, cur, prev):
            return {"currentYear": cur, "lastYear": prev, "comparison": _calc_comparison(cur, prev),
                    "reason": reasons_map.get(indicator_key, "")}

        data = {"雇佣": {}, "教育和培训": {}, "职业健康与安全": {}, "员工满意度": {}}

        # 雇佣
        if emp_cur or emp_prev:
            def gv(obj, attr):
                return getattr(obj, attr) if obj is not None else None

            total_employees_cur = gv(emp_cur, 'total_employees')
            total_employees_prev = gv(emp_prev, 'total_employees')
            data["雇佣"]["employment_total_employees"] = entry("employment_total_employees", total_employees_cur,
                                                               total_employees_prev)

            data["雇佣"]["employment_full_time"] = entry("employment_full_time", gv(emp_cur, 'full_time'),
                                                         gv(emp_prev, 'full_time'))
            data["雇佣"]["employment_part_time"] = entry("employment_part_time", gv(emp_cur, 'part_time'),
                                                         gv(emp_prev, 'part_time'))

            data["雇佣"]["employment_gender_male"] = entry("employment_gender_male", gv(emp_cur, 'male'),
                                                           gv(emp_prev, 'male'))
            data["雇佣"]["employment_gender_female"] = entry("employment_gender_female", gv(emp_cur, 'female'),
                                                             gv(emp_prev, 'female'))

            data["雇佣"]["employment_category_management"] = entry("employment_category_management",
                                                                   gv(emp_cur, 'management'),
                                                                   gv(emp_prev, 'management'))
            data["雇佣"]["employment_category_middle"] = entry("employment_category_middle", gv(emp_cur, 'middle'),
                                                               gv(emp_prev, 'middle'))
            data["雇佣"]["employment_category_general"] = entry("employment_category_general", gv(emp_cur, 'general'),
                                                                gv(emp_prev, 'general'))

            # 管理层女性占比
            mgmt_female_rate_cur = None
            mgmt_female_rate_prev = None
            try:
                if gv(emp_cur, 'management') and gv(emp_cur, 'management') != 0:
                    mgmt_female_rate_cur = round(
                        (gv(emp_cur, 'management_female') or 0) / gv(emp_cur, 'management') * 100, 2)
                if gv(emp_prev, 'management') and gv(emp_prev, 'management') != 0:
                    mgmt_female_rate_prev = round(
                        (gv(emp_prev, 'management_female') or 0) / gv(emp_prev, 'management') * 100, 2)
            except Exception:
                pass
            data["雇佣"]["employment_mgmt_female_rate"] = entry("employment_mgmt_female_rate", mgmt_female_rate_cur,
                                                                mgmt_female_rate_prev)

            # 地区
            data["雇佣"]["employment_region_mainland"] = entry("employment_region_mainland", gv(emp_cur, 'mainland'),
                                                               gv(emp_prev, 'mainland'))
            data["雇佣"]["employment_region_overseas"] = entry("employment_region_overseas", gv(emp_cur, 'overseas'),
                                                               gv(emp_prev, 'overseas'))

            # 年龄组
            for key in ['age18_30', 'age31_45', 'age46_60']:
                data["雇佣"][f"employment_{key}"] = entry(f"employment_{key}", gv(emp_cur, key), gv(emp_prev, key))

            # 离职、新进
            data["雇佣"]["employment_quit_total"] = entry("employment_quit_total", gv(emp_cur, 'quit_total'),
                                                          gv(emp_prev, 'quit_total'))
            data["雇佣"]["employment_new_hires"] = entry("employment_new_hires", gv(emp_cur, 'new_hires'),
                                                         gv(emp_prev, 'new_hires'))

            # 五险一金
            data["雇佣"]["employment_avg_social_fund"] = entry("employment_avg_social_fund",
                                                               gv(emp_cur, 'avg_social_fund'),
                                                               gv(emp_prev, 'avg_social_fund'))
            data["雇佣"]["employment_inc_social_fund"] = entry("employment_inc_social_fund",
                                                               gv(emp_cur, 'inc_social_fund'),
                                                               gv(emp_prev, 'inc_social_fund'))

            # 学历结构
            for key in ['edu_phd', 'edu_master', 'edu_bachelor', 'edu_junior']:
                data["雇佣"][f"employment_{key}"] = entry(f"employment_{key}", gv(emp_cur, key), gv(emp_prev, key))

            # 流失率总体与分组
            rate_keys = ['turnover_rate', 'male_turnover_rate', 'female_turnover_rate', 'mainland_turnover_rate',
                         'overseas_turnover_rate', 'age18_30_turnover_rate', 'age31_45_turnover_rate',
                         'age46_60_turnover_rate', 'management_turnover_rate', 'middle_turnover_rate',
                         'general_turnover_rate']
            for key in rate_keys:
                data["雇佣"][f"employment_{key}"] = entry(f"employment_{key}", gv(emp_cur, key), gv(emp_prev, key))

        # 教育与培训
        if trn_cur or trn_prev:
            def tv(obj, attr):
                return getattr(obj, attr) if obj is not None else None

            data["教育和培训"]["training_total"] = entry("training_total", tv(trn_cur, 'total'), tv(trn_prev, 'total'))
            data["教育和培训"]["training_coverage_rate"] = entry("training_coverage_rate", tv(trn_cur, 'coverage_rate'),
                                                                 tv(trn_prev, 'coverage_rate'))

            for key in ['male', 'female', 'mgmt', 'middle', 'general']:
                data["教育和培训"][f"training_{key}"] = entry(f"training_{key}", tv(trn_cur, key), tv(trn_prev, key))

            for key in ['male_rate', 'female_rate', 'mgmt_rate', 'middle_rate', 'general_rate']:
                data["教育和培训"][f"training_{key}"] = entry(f"training_{key}", tv(trn_cur, key), tv(trn_prev, key))

            # 学时总量与人均
            hours_total_cur = tv(trn_cur, 'hours_total')
            hours_total_prev = tv(trn_prev, 'hours_total')
            data["教育和培训"]["training_hours_total"] = entry("training_hours_total", hours_total_cur,
                                                               hours_total_prev)

            avg_hours_cur = None
            avg_hours_prev = None
            try:
                if tv(trn_cur, 'trained') and tv(trn_cur, 'trained') != 0:
                    avg_hours_cur = round((tv(trn_cur, 'hours_total') or 0) / tv(trn_cur, 'trained'), 2)
                if tv(trn_prev, 'trained') and tv(trn_prev, 'trained') != 0:
                    avg_hours_prev = round((tv(trn_prev, 'hours_total') or 0) / tv(trn_prev, 'trained'), 2)
            except Exception:
                pass
            data["教育和培训"]["training_avg_hours_per_person"] = entry("training_avg_hours_per_person", avg_hours_cur,
                                                                        avg_hours_prev)

            # 按性别/层级平均受训时数
            def safe_div(n, d):
                try:
                    if n is None or d in (None, 0):
                        return None
                    return round(n / d, 2)
                except Exception:
                    return None

            data["教育和培训"]["training_avg_hours_male"] = entry("training_avg_hours_male",
                                                                  safe_div(tv(trn_cur, 'hours_male'),
                                                                           tv(trn_cur, 'male')),
                                                                  safe_div(tv(trn_prev, 'hours_male'),
                                                                           tv(trn_prev, 'male')))
            data["教育和培训"]["training_avg_hours_female"] = entry("training_avg_hours_female",
                                                                    safe_div(tv(trn_cur, 'hours_female'),
                                                                             tv(trn_cur, 'female')),
                                                                    safe_div(tv(trn_prev, 'hours_female'),
                                                                             tv(trn_prev, 'female')))
            data["教育和培训"]["training_avg_hours_mgmt"] = entry("training_avg_hours_mgmt",
                                                                  safe_div(tv(trn_cur, 'hours_mgmt'),
                                                                           tv(trn_cur, 'mgmt')),
                                                                  safe_div(tv(trn_prev, 'hours_mgmt'),
                                                                           tv(trn_prev, 'mgmt')))
            data["教育和培训"]["training_avg_hours_middle"] = entry("training_avg_hours_middle",
                                                                    safe_div(tv(trn_cur, 'hours_middle'),
                                                                             tv(trn_cur, 'middle')),
                                                                    safe_div(tv(trn_prev, 'hours_middle'),
                                                                             tv(trn_prev, 'middle')))
            data["教育和培训"]["training_avg_hours_general"] = entry("training_avg_hours_general",
                                                                     safe_div(tv(trn_cur, 'hours_general'),
                                                                              tv(trn_cur, 'general')),
                                                                     safe_div(tv(trn_prev, 'hours_general'),
                                                                              tv(trn_prev, 'general')))

        # 职业健康与安全
        if ohs_cur or ohs_prev:
            def ov(obj, attr):
                return getattr(obj, attr) if obj is not None else None

            for key in ['training_count_total', 'training_hours_total', 'injury_count_total', 'incident_count_total',
                        'fatality_count_total', 'lost_workdays_total', 'safety_investment_total',
                        'training_participants_total', 'safety_managers', 'medical_checks', 'coverage_rate',
                        'emergency_drills', 'hazards_found', 'occupational_checks']:
                data["职业健康与安全"][f"ohs_{key}"] = entry(f"ohs_{key}", ov(ohs_cur, key), ov(ohs_prev, key))

            # 因工死亡率
            fatality_rate_cur = None
            fatality_rate_prev = None
            try:
                if ov(ohs_cur, 'fatality_count_total') is not None and total_employees_cur:
                    fatality_rate_cur = round(ov(ohs_cur, 'fatality_count_total') / total_employees_cur * 100, 4)
                if ov(ohs_prev, 'fatality_count_total') is not None and total_employees_prev:
                    fatality_rate_prev = round(ov(ohs_prev, 'fatality_count_total') / total_employees_prev * 100, 4)
            except Exception:
                pass
            data["职业健康与安全"]["ohs_fatality_rate"] = entry("ohs_fatality_rate", fatality_rate_cur,
                                                                fatality_rate_prev)

            # OHS 人均受训学时（使用培训参与人数）
            ohs_avg_hours_cur = None
            ohs_avg_hours_prev = None
            try:
                if ov(ohs_cur, 'training_participants_total') not in (None, 0):
                    ohs_avg_hours_cur = round(
                        ov(ohs_cur, 'training_hours_total') / ov(ohs_cur, 'training_participants_total'), 2)
                if ov(ohs_prev, 'training_participants_total') not in (None, 0):
                    ohs_avg_hours_prev = round(
                        ov(ohs_prev, 'training_hours_total') / ov(ohs_prev, 'training_participants_total'), 2)
            except Exception:
                pass
            data["职业健康与安全"]["ohs_avg_training_hours_per_person"] = entry("ohs_avg_training_hours_per_person",
                                                                                ohs_avg_hours_cur, ohs_avg_hours_prev)

        # 员工满意度
        if sat_cur or sat_prev:
            def sv(obj, attr):
                return getattr(obj, attr) if obj is not None else None

            data["员工满意度"]["satisfaction_annual_average"] = entry("satisfaction_annual_average",
                                                                      sv(sat_cur, 'annual_average'),
                                                                      sv(sat_prev, 'annual_average'))

        return data
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取劳动定量数据失败: {str(e)}")


@router.post("")
async def save_reasons(factory: str = Body(...), year: int = Body(...), reasons: Dict[str, str] = Body(...),
                             db: Session = Depends(get_db)):
    try:
        for indicator, reason in reasons.items():
            existing = db.query(LaborReason).filter(LaborReason.factory == factory, LaborReason.year == year,
                                                    LaborReason.indicator == indicator).first()
            if existing:
                existing.reason = reason
            else:
                db.add(LaborReason(factory=factory, year=year, indicator=indicator, reason=reason))
        db.commit()
        return {"status": "success", "message": "劳动定量原因说明已保存"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"保存劳动原因失败: {str(e)}")
