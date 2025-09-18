// constants/indicators.js
export const CATEGORY = {
    "material": "物料",
    "energy": "能源",
    "water": "水资源",
    "emission": "排放",
    "waste": "废弃物",
    "investment": "资金投入",
    "management": "环境管理",
    "climate_change": "气候变化",
    "env_opportunities": "环境机遇",
    "bio_conservation": "生物多样性保护",
    "env_inc_management": "环境事故管理",
    "material_consumption": "物料消耗",
    "energy_consumption": "能源消耗",
    "carbon_emission": "碳排放"
};
// 环境定量指标名称映射
export const ENV_QUANT_INDICATORS = {
    "material": {
        "renewable_input": "可再生进料量 （吨）",
        "non_renewable_input": "不可再生进料量 （吨）",
        "renewable_output": "可再生出料量 （吨）",
        "non_renewable_output": "不可再生出料量 （吨）",
        "material_consumption": "物料消耗量 （吨）",
        "wood_fiber": "木纤维 （吨）",
        "aluminum": "铝 （吨）",
        "packaging_material": "包装材料 （吨）",
        "paper_consumption": "纸张消耗 （吨）",
        "packaging_intensity": "包装消耗强度 （吨/万元）",
        "paper_intensity": "纸张消耗强度 （吨/万元）",
        "total_input": "进料总量 （吨）",
        "total_output": "出料总量 （吨）",
        "renewable_input_ratio": "可再生进料占比 （%）",
        "renewable_output_ratio": "可再生出料占比 （%）"
    }, "energy": {
        "purchased_power": "外购电量 （千瓦时）",
        "renewable_power": "再生能源电量 （千瓦时）",
        "coal": "煤炭使用量 （吨标准煤）",
        "gasoline": "汽油用量 （吨）",
        "diesel": "柴油用量 （吨）",
        "natural_gas": "天然气用量 （吨）",
        "other_energy": "其他能源消耗量 （吨标准煤）",
        "total_energy_consumption": "综合能耗 （吨标准煤）",
        "energy_consumption_intensity": "能源消耗强度 （吨标准煤/万元）"
    }, "water": {
        "industrial_total": "取水量（工业） （吨）",
        "domestic_total": "取水量（生活） （吨）",
        "total_intake": "取水总量 （吨）",
        "water_intensity": "用水强度 （吨/万元）",
        "total_drainage": "排水量 （吨）",
        "total_consumption": "耗水量 （吨）",
        "total_recycled": "循环水量 （吨）",
        "water_recycle_rate": "水资源回收利用率 （%）",
        "reclaimed_intensity": "中水用水强度 （吨/万元）",
        "reclaimed_total": "中水用水量 （吨）"
    }, "emission": {
        "category_one": "温室气体直接排放量（范围一） （吨二氧化碳当量）",
        "category_two": "温室气体直接排放量（范围二） （吨二氧化碳当量）",
        "category_three_total": "价值链上下游各项活动的间接排放数据（范围三） （吨二氧化碳当量）",
        "total_emission": "温室气体排放总量 （吨二氧化碳当量）",
        "emission_intensity": "温室气体排放强度 （吨二氧化碳当量/万元） （吨二氧化碳当量）",
        "voc": "挥发性有机物（VOC） （吨）",
        "nmhc": "碳氢化合物（非甲烷总烃） （吨）",
        "benzene": "苯类（苯、甲苯、二甲苯） （吨）",
        "particulate": "颗粒物（吨）",
        "nox_sox_other": "氮氧化物、硫氧化物及其他气体排放 （吨）"
    }, "waste": {
        "hazardous": "危险废弃物总量 （吨）",
        "hazardous_intensity": "危险废弃物强度 （吨/万元）",
        "epe": "电子废弃物 （吨）",
        "plastic_paper": "塑料和纸张废弃物 （吨）",
        "domestic_industrial": "生活和工业废弃物 （吨）",
        "recyclable_total": "可回收废弃物总量 （吨）",
        "non_hazardous_total": "非危险废弃物总量 （吨）",
        "total_waste": "废弃物总量 （吨）",
        "recycle_rate": "回收率 （%）",
        "protective_reuse_rate": "保护性再利用率 （%）",
        "disposal_required_total": "需处置废弃物总量 （吨）",
        "wastewater": "废水总量 （吨）",
        "wastewater_intensity": "废水强度 （吨/万元）",
        "exceed_events": "超标事件 （次）"
    }, "investment": {
        "env_invest": "环保总投入 （万元）",
        "env_invest_intensity": "环保投入强度 （%）",
        "green_income_ratio": "绿色收入占比 （%）",
        "climate_invest": "气候相关投入 （万元）",
        "clean_tech_invest": "清洁技术投入 （万元）"
    }, "management": {
        "national_green_factory": "国家级绿色工厂 （个）",
        "provincial_green_factory": "省级绿色工厂 （个）",
        "environmental_penalty_intensity": "环境处罚强度 （%）",
        "environmental_penalty_amount": "环境处罚额 （万元）",
        "environmental_violation": "环境违规 （次）"
    }
};

// 环境定性指标名称映射
export const ENV_QUAL_INDICATORS = {
    "climate_change": {
        "board_supervision": "董事会监管",
        "management_responsibility": "管理层职责",
        "environment_strategy": "环境战略",
        "risk_opportunity_identification": "风险与机遇识别以及应对措施",
        "climate_risk_disclosure": "气候风险应对披露",
        "risk_matrix": "物理风险、转型风险、短期风险、长期风险",
        "risk_impact": "风险影响",
        "resilience": "能力韧性",
        "risk_process": "识别、评估风险流程",
        "risk_management_process": "管理风险流程",
        "business_strategy": "纳入业务策略",
        "ghg_reduction_target": "温室气体排放物减排目标",
        "ghg_reduction_rate": "温室气体减排目标达成率（%）",
        "ghg_reduction_action": "温室气体排放物减排行动",
        "carbon_capture_target": "碳捕捉计划目标",
        "carbon_capture_rate": "碳捕捉计划目标达成率（%）"
    }, "waste": {
        "waste_reduction_target": "废弃物减排目标", "waste_reduction_action": "废弃物减排行动"
    }, "water": {
        "annual_water_use_target": "年度用水量目标",
        "annual_water_use_target_rate": "年度用水量目标达成率（%）",
        "annual_reclaimed_water_use_target": "年度中水使用量目标",
        "annual_reclaimed_water_use_target_rate": "年度中水使用量目标达成率（%）",
        "water_saving_target": "节水目标/水资源减排目标",
        "water_saving_target_rate": "水资源减排目标达成率（%）",
        "water_management_policy": "水资源管理政策",
        "water_risk_management": "水资源风险管理",
        "water_saving_action": "节水行动"
    }, "env_opportunities": {
        "clean_technology_strategy": "清洁技术战略", "clean_technology_practice": "清洁技术实践"
    }, "bio_conservation": {
        "biodiversity_impact": "生物多样性影响", "ecological_restoration": "生态修复"
    }, "env_inc_management": {
        "environmental_accident": "环境事故", "environmental_penalty": "环境处罚",
    }, "management": {
        "environmental_management_system": "环境管理体系认证与披露",
        "environmental_resource_policy": "环境/资源使用政策",
        "environmental_emergency_plan": "环境应急预案办法",
        "green_office": "绿色办公",
        "green_factory_policy": "绿色工厂政策以及目标计划",
        "environmental_committee": "环保委员会或工作组的设置",
        "key_pollution_unit": "列入重点排污单位",
        "waste_product_recycling": "废旧产品回收项目",
        "hazardous_waste_emission_target": "有害废弃物排放总量目标",
        "hazardous_waste_emission_target_rate": "有害废弃物排放总量目标达成率（%）",
        "sustainable_product_certification": "可持续产品认证与信披"
    }, "material_consumption": {
        "material_reduction_target": "减少物料消耗目标",
        "annual_packaging_material_target": "年度包装材料消耗目标",
        "annual_packaging_material_target_rate": "年度包装材料消耗目标达成率（%）",
        "packaging_material_reduction_target": "包装材料资源降低目标",
        "packaging_material_reduction_target_rate": "包装材料资源降低目标达成率（%）",
        "product_lifecycle_management": "产品生命周期管理",
        "annual_office_paper_target": "年度办公用纸消耗量目标",
        "annual_office_paper_target_rate": "年度办公用纸消耗量目标达成率（%）",
        "chemical_management": "化学品管理",
        "chemical_inventory": "化学品清单"
    }, "energy_consumption": {
        "energy_reduction_target": "减少能源消耗目标",
        "renewable_energy_target": "可再生能源目标",
        "renewable_energy_use_development": "可再生能源利用及开发",
        "energy_saving_action_results": "能源节约行动与成果",
        "energy_management_system": "能源管理体系认证与信披"
    }, "carbon_emission": {
        "product_carbon_footprint": "产品碳足迹",
        "product_carbon_footprint_plan": "产品碳足迹计划及执行情况说明",
        "carbon_neutrality_target_year": "碳中和目标年份",
        "carbon_neutrality_plan": "碳中和计划",
        "carbon_neutrality_target_scheme": "碳中和目标指标方案",
        "carbon_neutrality_plan_rate": "碳中和计划达成率（%）",
        "carbon_reduction_target": "碳减排目标",
        "joined_sbti": "是否加入科学碳目标SBTi",
        "cdp_disclosure": "CDP收据披露及说明",
        "carbon_inventory_disclosure": "碳盘查数据披露",
        "carbon_inventory_report_verification": "碳盘查报告验证",
        "greenhouse_gas_verification_system": "是否有温室气体核查体系"
    }
};




