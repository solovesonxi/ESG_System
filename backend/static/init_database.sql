-- sql
-- File: backend/static/init_database.sql
-- 为 ON CONFLICT 创建唯一索引（若不存在）
CREATE UNIQUE INDEX IF NOT EXISTS idx_categories_name_en ON categories (name_en);
CREATE UNIQUE INDEX IF NOT EXISTS idx_fields_category_name_en ON fields (category, name_en);


-- 插入 categories（冲突时不做任何操作）
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active)
VALUES ('material', '物料', 'MaterialData', '环境', 'month', TRUE),
       ('energy', '能源', 'EnergyData', '环境', 'month', TRUE),
       ('water', '水资源', 'WaterData', '环境', 'month', TRUE),
       ('emission', '排放', 'EmissionData', '环境', 'month', TRUE),
       ('waste', '废弃物', 'WasteData', '环境', 'month', TRUE),
       ('investment', '资金投入', 'InvestmentData', '环境', 'month', TRUE),
       ('management', '环境管理', 'ManagementData', '环境', 'month', TRUE),
       ('employment', '雇佣', 'EmploymentData', '社会', 'month', TRUE),
       ('training', '教育与培训', 'TrainingData', '社会', 'month', TRUE),
       ('ohs', '职健与安全', 'OHSData', '社会', 'month', TRUE),
       ('satisfaction', '员工满意度', 'SatisfactionData', '社会', 'month', TRUE),
       ('supply', '供应链', 'SupplyData', '社会', 'month', TRUE),
       ('responsibility', '产品责任', 'ResponsibilityData', '社会', 'month', TRUE),
       ('ip', '知识产权', 'IPData', '社会', 'month', TRUE),
       ('community', '社区参与与志愿活动', 'CommunityData', '社会', 'month', TRUE),
       ('env_quant', '定量（分析）', 'EnvQuantData', '环境', 'year', TRUE),
       ('env_qual', '定性（分析）', 'EnvQualData', '环境', 'year', TRUE),
       ('social_quant_labor', '定量-劳动（分析）', 'SocialQuantLaborData', '社会', 'year', TRUE),
       ('social_qual_labor', '定性-劳动（分析）', 'SocialQualLaborData', '社会', 'year', TRUE),
       ('social_qual_other', '定性-其他（分析）', 'SocialQualOtherData', '社会', 'year', TRUE),
       ('social_quant_other', '定量-其他（分析）', 'SocialQuantOtherData', '社会', 'year', TRUE),
       ('governance', '治理', 'GovernanceData', '治理', 'year', TRUE)
ON CONFLICT (name_en) DO NOTHING ;




-- MaterialData 字段
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES
(1, 'default', 'renewable_input', '可再生进料量', 0.01, NULL, 'T', '可再生进料量 (按月)', NULL, TRUE),
(1, 'default', 'non_renewable_input', '不可再生进料量', 0.01, NULL, 'T', '不可再生进料量 (按月)', NULL, TRUE),
(1, 'default', 'renewable_output', '可再生出料量', 0.01, NULL, 'T', '可再生出料量 (按月)', NULL, TRUE),
(1, 'default', 'non_renewable_output', '不可再生出料量', 0.01, NULL, 'T', '不可再生出料量 (按月)', NULL, TRUE),
(1, 'default', 'material_consumption', '物料消耗量', 0.01, NULL, 'T', '物料消耗量 (按月)', NULL, TRUE),
(1, 'default', 'wood_fiber', '木质纤维消耗量', 0.01, NULL, 'T', '木质纤维消耗量 (按月)', NULL, TRUE),
(1, 'default', 'aluminum', '铝消耗量', 0.01, NULL, 'T', '铝消耗量 (按月)', NULL, TRUE),
(1, 'default', 'packaging_material', '包装材料消耗量', 0.01, NULL, 'T', '包装材料消耗量 (按月)', NULL, TRUE),
(1, 'default', 'paper_consumption', '纸张消耗量', 0.01, NULL, 'T', '纸张消耗量 (按月)', NULL, TRUE),
(1, 'default', 'total_revenue', '总营收', 0.01, NULL, '万元', '总营收', NULL, TRUE),
(1, 'default', 'packaging_intensity', '包装材料消耗强度', 0.0001, NULL, 'T/万元', '包装材料消耗强度', NULL, TRUE),
(1, 'default', 'paper_intensity', '纸张消耗强度', 0.0001, NULL, 'T/万元', '纸张消耗强度', NULL, TRUE),
(1, 'default', 'total_input', '进料总量', 0.01, NULL, 'T', '进料总量', NULL, TRUE),
(1, 'default', 'total_output', '出料总量', 0.01, NULL, 'T', '出料总量', NULL, TRUE),
(1, 'default', 'renewable_input_ratio', '可再生进料占比', 0.01, NULL, '%', '可再生进料占比', NULL, TRUE),
(1, 'default', 'renewable_output_ratio', '可再生出料占比', 0.01, NULL, '%', '可再生出料占比', NULL, TRUE)
ON CONFLICT (category, name_en) DO NOTHING;

-- EnergyData 字段
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active)
SELECT id, 'default', 'purchased_power', '外购电量', 1, NULL, 'kWh', '外购电量 (按月)', NULL, TRUE FROM categories WHERE name_en = 'energy'
UNION ALL SELECT id, 'default', 'renewable_power', '再生能源电量', 1, NULL, 'kWh', '再生能源电量 (按月)', NULL, TRUE FROM categories WHERE name_en = 'energy'
UNION ALL SELECT id, 'default', 'gasoline', '汽油用量', 0.01, NULL, 'T', '汽油用量 (按月)', NULL, TRUE FROM categories WHERE name_en = 'energy'
UNION ALL SELECT id, 'default', 'diesel', '柴油用量', 0.01, NULL, 'T', '柴油用量 (按月)', NULL, TRUE FROM categories WHERE name_en = 'energy'
UNION ALL SELECT id, 'default', 'natural_gas', '天然气用量', 0.01, NULL, 'T', '天然气用量 (按月)', NULL, TRUE FROM categories WHERE name_en = 'energy'
UNION ALL SELECT id, 'default', 'other_energy', '其他能源', 0.01, NULL, 'Tce', '其他能源 (按月)', NULL, TRUE FROM categories WHERE name_en = 'energy'
UNION ALL SELECT id, 'default', 'water', '水用量', 1, NULL, 'm³', '水用量 (按月)', NULL, TRUE FROM categories WHERE name_en = 'energy'
UNION ALL SELECT id, 'default', 'coal', '煤用量', 0.01, NULL, 'Tce', '煤用量 (按月)', NULL, TRUE FROM categories WHERE name_en = 'energy'
UNION ALL SELECT id, 'default', 'total_energy_consumption', '总能源消耗', 0.01, NULL, 'Tce', '总能源消耗', NULL, TRUE FROM categories WHERE name_en = 'energy'
UNION ALL SELECT id, 'default', 'turnover', '营业额', 0.01, NULL, '万元', '营业额', NULL, TRUE FROM categories WHERE name_en = 'energy'
UNION ALL SELECT id, 'default', 'energy_consumption_intensity', '能源消耗强度', 0.0001, NULL, 'Tce/万元', '能源消耗强度', NULL, TRUE FROM categories WHERE name_en = 'energy';

-- WaterData 字段
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active)
SELECT id, 'default', 'industrial', '工业用水', 1, NULL, 'm³', '工业用水量 (按月)', NULL, TRUE FROM categories WHERE name_en = 'water'
UNION ALL SELECT id, 'default', 'domestic', '生活用水', 1, NULL, 'm³', '生活用水量 (按月)', NULL, TRUE FROM categories WHERE name_en = 'water'
UNION ALL SELECT id, 'default', 'reclaimed', '再生水', 1, NULL, 'm³', '再生水量 (按月)', NULL, TRUE FROM categories WHERE name_en = 'water'
UNION ALL SELECT id, 'default', 'total', '总用水量', 1, NULL, 'm³', '总用水量 (按月)', NULL, TRUE FROM categories WHERE name_en = 'water'
UNION ALL SELECT id, 'default', 'industrial_total', '工业用水总量', 1, NULL, 'm³', '工业用水总量', NULL, TRUE FROM categories WHERE name_en = 'water'
UNION ALL SELECT id, 'default', 'industrial_drainage', '工业排水量', 1, NULL, 'm³', '工业排水量', NULL, TRUE FROM categories WHERE name_en = 'water'
UNION ALL SELECT id, 'default', 'industrial_consumption', '工业耗水量', 1, NULL, 'm³', '工业耗水量', NULL, TRUE FROM categories WHERE name_en = 'water'
UNION ALL SELECT id, 'default', 'industrial_recycled', '工业回用水量', 1, NULL, 'm³', '工业回用水量', NULL, TRUE FROM categories WHERE name_en = 'water'
UNION ALL SELECT id, 'default', 'domestic_total', '生活用水总量', 1, NULL, 'm³', '生活用水总量', NULL, TRUE FROM categories WHERE name_en = 'water'
UNION ALL SELECT id, 'default', 'domestic_drainage', '生活排水量', 1, NULL, 'm³', '生活排水量', NULL, TRUE FROM categories WHERE name_en = 'water'
UNION ALL SELECT id, 'default', 'domestic_consumption', '生活耗水量', 1, NULL, 'm³', '生活耗水量', NULL, TRUE FROM categories WHERE name_en = 'water'
UNION ALL SELECT id, 'default', 'domestic_recycled', '生活回用水量', 1, NULL, 'm³', '生活回用水量', NULL, TRUE FROM categories WHERE name_en = 'water'
UNION ALL SELECT id, 'default', 'reclaimed_total', '再生水总量', 1, NULL, 'm³', '再生水总量', NULL, TRUE FROM categories WHERE name_en = 'water'
UNION ALL SELECT id, 'default', 'total_revenue', '总营收', 0.01, NULL, '万元', '总营收', NULL, TRUE FROM categories WHERE name_en = 'water'
UNION ALL SELECT id, 'default', 'reclaimed_intensity', '再生水强度', 0.0001, NULL, 'm³/万元', '再生水强度', NULL, TRUE FROM categories WHERE name_en = 'water'
UNION ALL SELECT id, 'default', 'total_intake', '总取水量', 1, NULL, 'm³', '总取水量', NULL, TRUE FROM categories WHERE name_en = 'water'
UNION ALL SELECT id, 'default', 'total_drainage', '总排水量', 1, NULL, 'm³', '总排水量', NULL, TRUE FROM categories WHERE name_en = 'water'
UNION ALL SELECT id, 'default', 'total_consumption', '总耗水量', 1, NULL, 'm³', '总耗水量', NULL, TRUE FROM categories WHERE name_en = 'water'
UNION ALL SELECT id, 'default', 'total_recycled', '总回用水量', 1, NULL, 'm³', '总回用水量', NULL, TRUE FROM categories WHERE name_en = 'water'
UNION ALL SELECT id, 'default', 'water_intensity', '水强度', 0.0001, NULL, 'm³/万元', '水强度', NULL, TRUE FROM categories WHERE name_en = 'water'
UNION ALL SELECT id, 'default', 'water_recycle_rate', '水循环利用率', 0.01, NULL, '%', '水循环利用率', NULL, TRUE FROM categories WHERE name_en = 'water';

-- EmissionData 字段
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active)
SELECT id, 'default', 'category_one', '范畴一排放', 0.01, NULL, 'tCO₂e', '范畴一排放', NULL, TRUE FROM categories WHERE name_en = 'emission'
UNION ALL SELECT id, 'default', 'category_two', '范畴二排放', 0.01, NULL, 'tCO₂e', '范畴二排放', NULL, TRUE FROM categories WHERE name_en = 'emission'
UNION ALL SELECT id, 'default', 'category_three', '范畴三排放', 0.01, NULL, 'tCO₂e', '范畴三排放', NULL, TRUE FROM categories WHERE name_en = 'emission'
UNION ALL SELECT id, 'default', 'category_four', '范畴四排放', 0.01, NULL, 'tCO₂e', '范畴四排放', NULL, TRUE FROM categories WHERE name_en = 'emission'
UNION ALL SELECT id, 'default', 'category_five', '范畴五排放', 0.01, NULL, 'tCO₂e', '范畴五排放', NULL, TRUE FROM categories WHERE name_en = 'emission'
UNION ALL SELECT id, 'default', 'category_six', '范畴六排放', 0.01, NULL, 'tCO₂e', '范畴六排放', NULL, TRUE FROM categories WHERE name_en = 'emission'
UNION ALL SELECT id, 'default', 'total_revenue', '总营收', 0.01, NULL, '万元', '总营收', NULL, TRUE FROM categories WHERE name_en = 'emission'
UNION ALL SELECT id, 'default', 'category_three_total', '范畴三排放总量', 0.01, NULL, 'tCO₂e', '范畴三排放总量', NULL, TRUE FROM categories WHERE name_en = 'emission'
UNION ALL SELECT id, 'default', 'total_emission', '总排放量', 0.01, NULL, 'tCO₂e', '总排放量', NULL, TRUE FROM categories WHERE name_en = 'emission'
UNION ALL SELECT id, 'default', 'emission_intensity', '排放强度', 0.0001, NULL, 'tCO₂e/万元', '排放强度', NULL, TRUE FROM categories WHERE name_en = 'emission'
UNION ALL SELECT id, 'default', 'voc', 'VOC排放', 0.01, NULL, 'T', '挥发性有机物排放', NULL, TRUE FROM categories WHERE name_en = 'emission'
UNION ALL SELECT id, 'default', 'nmhc', 'NMHC排放', 0.01, NULL, 'T', '非甲烷总烃排放', NULL, TRUE FROM categories WHERE name_en = 'emission'
UNION ALL SELECT id, 'default', 'benzene', '苯排放', 0.01, NULL, 'T', '苯排放', NULL, TRUE FROM categories WHERE name_en = 'emission'
UNION ALL SELECT id, 'default', 'particulate', '颗粒物排放', 0.01, NULL, 'T', '颗粒物排放', NULL, TRUE FROM categories WHERE name_en = 'emission'
UNION ALL SELECT id, 'default', 'nox_sox_other', '氮氧化物等排放', 0.01, NULL, 'T', '氮氧化物、硫氧化物等其他排放', NULL, TRUE FROM categories WHERE name_en = 'emission'
UNION ALL SELECT id, 'default', 'waste_gas_total', '废气排放总量', 0.01, NULL, 'T', '废气排放总量', NULL, TRUE FROM categories WHERE name_en = 'emission';

-- WasteData 字段
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active)
SELECT id, 'default', 'epe', 'EPE废弃物', 0.01, NULL, 'T', 'EPE废弃物 (按月)', NULL, TRUE FROM categories WHERE name_en = 'waste'
UNION ALL SELECT id, 'default', 'plastic_paper', '塑料纸张废弃物', 0.01, NULL, 'T', '塑料纸张废弃物 (按月)', NULL, TRUE FROM categories WHERE name_en = 'waste'
UNION ALL SELECT id, 'default', 'domestic_industrial', '生活和工业废弃物', 0.01, NULL, 'T', '生活和工业废弃物 (按月)', NULL, TRUE FROM categories WHERE name_en = 'waste'
UNION ALL SELECT id, 'default', 'hazardous', '危险废弃物', 0.01, NULL, 'T', '危险废弃物 (按月)', NULL, TRUE FROM categories WHERE name_en = 'waste'
UNION ALL SELECT id, 'default', 'wastewater', '废水废弃物', 0.01, NULL, 'T', '废水废弃物 (按月)', NULL, TRUE FROM categories WHERE name_en = 'waste'
UNION ALL SELECT id, 'default', 'non_hazardous_total', '非危险废弃物总量', 0.01, NULL, 'T', '非危险废弃物总量', NULL, TRUE FROM categories WHERE name_en = 'waste'
UNION ALL SELECT id, 'default', 'recyclable_total', '可回收废弃物总量', 0.01, NULL, 'T', '可回收废弃物总量', NULL, TRUE FROM categories WHERE name_en = 'waste'
UNION ALL SELECT id, 'default', 'total_waste', '废弃物总量', 0.01, NULL, 'T', '废弃物总量', NULL, TRUE FROM categories WHERE name_en = 'waste'
UNION ALL SELECT id, 'default', 'disposal_required_total', '需处置废弃物总量', 0.01, NULL, 'T', '需处置废弃物总量', NULL, TRUE FROM categories WHERE name_en = 'waste'
UNION ALL SELECT id, 'default', 'recycle_rate', '回收率', 0.01, NULL, '%', '回收率', NULL, TRUE FROM categories WHERE name_en = 'waste'
UNION ALL SELECT id, 'default', 'total_revenue', '总营收', 0.01, NULL, '万元', '总营收', NULL, TRUE FROM categories WHERE name_en = 'waste'
UNION ALL SELECT id, 'default', 'protective_reuse_rate', '防护性再利用率', 0.01, NULL, '%', '防护性再利用率', NULL, TRUE FROM categories WHERE name_en = 'waste'
UNION ALL SELECT id, 'default', 'exceed_events', '超标事件数', 1, NULL, '次', '超标事件数', NULL, TRUE FROM categories WHERE name_en = 'waste'
UNION ALL SELECT id, 'default', 'hazardous_intensity', '危险废弃物强度', 0.0001, NULL, 'T/万元', '危险废弃物强度', NULL, TRUE FROM categories WHERE name_en = 'waste'
UNION ALL SELECT id, 'default', 'wastewater_intensity', '废水废弃物强度', 0.0001, NULL, 'T/万元', '废水废弃物强度', NULL, TRUE FROM categories WHERE name_en = 'waste';

-- InvestmentData 字段
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active)
SELECT id, 'default', 'env_invest', '环保投资', 0.01, NULL, '万元', '环保投资 (按月)', NULL, TRUE FROM categories WHERE name_en = 'investment'
UNION ALL SELECT id, 'default', 'clean_tech_invest', '清洁技术投资', 0.01, NULL, '万元', '清洁技术投资 (按月)', NULL, TRUE FROM categories WHERE name_en = 'investment'
UNION ALL SELECT id, 'default', 'climate_invest', '气候相关投资', 0.01, NULL, '万元', '气候相关投资 (按月)', NULL, TRUE FROM categories WHERE name_en = 'investment'
UNION ALL SELECT id, 'default', 'green_income', '绿色收入', 0.01, NULL, '万元', '绿色收入 (按月)', NULL, TRUE FROM categories WHERE name_en = 'investment'
UNION ALL SELECT id, 'default', 'total_investment', '总投资额', 0.01, NULL, '万元', '总投资额', NULL, TRUE FROM categories WHERE name_en = 'investment'
UNION ALL SELECT id, 'default', 'green_income_ratio', '绿色收入占比', 0.01, NULL, '%', '绿色收入占比', NULL, TRUE FROM categories WHERE name_en = 'investment'
UNION ALL SELECT id, 'default', 'total_revenue', '总营收', 0.01, NULL, '万元', '总营收', NULL, TRUE FROM categories WHERE name_en = 'investment'
UNION ALL SELECT id, 'default', 'env_invest_intensity', '环保投资强度', 0.0001, NULL, '万元/万元', '环保投资强度', NULL, TRUE FROM categories WHERE name_en = 'investment';

-- ManagementData 字段
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active)
SELECT id, 'default', 'national_green_factory', '国家级绿色工厂', 1, NULL, '个', '国家级绿色工厂 (按月)', NULL, TRUE FROM categories WHERE name_en = 'management'
UNION ALL SELECT id, 'default', 'provincial_green_factory', '省级绿色工厂', 1, NULL, '个', '省级绿色工厂 (按月)', NULL, TRUE FROM categories WHERE name_en = 'management'
UNION ALL SELECT id, 'default', 'environmental_penalty_intensity', '环境处罚强度', 0.01, NULL, '万元/万元', '环境处罚强度 (按月)', NULL, TRUE FROM categories WHERE name_en = 'management'
UNION ALL SELECT id, 'default', 'environmental_penalty_amount', '环境处罚金额', 0.01, NULL, '万元', '环境处罚金额 (按月)', NULL, TRUE FROM categories WHERE name_en = 'management'
UNION ALL SELECT id, 'default', 'environmental_violation', '环境违规次数', 1, NULL, '次', '环境违规次数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'management';

-- EmploymentData 字段
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active)
SELECT id, 'default', 'full_time', '全职员工', 1, NULL, '人', '全职员工数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'part_time', '兼职员工', 1, NULL, '人', '兼职员工数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'male', '男性员工', 1, NULL, '人', '男性员工数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'female', '女性员工', 1, NULL, '人', '女性员工数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'management', '管理人员', 1, NULL, '人', '管理人员数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'management_female', '女性管理人员', 1, NULL, '人', '女性管理人员数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'middle', '中层员工', 1, NULL, '人', '中层员工数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'general', '普通员工', 1, NULL, '人', '普通员工数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'mainland', '大陆员工', 1, NULL, '人', '大陆员工数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'overseas', '海外员工', 1, NULL, '人', '海外员工数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'edu_phd', '博士学历', 1, NULL, '人', '博士学历员工数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'edu_master', '硕士学历', 1, NULL, '人', '硕士学历员工数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'edu_bachelor', '本科学历', 1, NULL, '人', '本科学历员工数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'edu_junior', '大专及以下学历', 1, NULL, '人', '大专及以下学历员工数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'avg_social_fund', '平均社保公积金', 0.01, NULL, '元', '平均社保公积金 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'inc_social_fund', '社保公积金增长', 0.01, NULL, '元', '社保公积金增长 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'age18_30', '18-30岁员工', 1, NULL, '人', '18-30岁员工数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'age31_45', '31-45岁员工', 1, NULL, '人', '31-45岁员工数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'age46_60', '46-60岁员工', 1, NULL, '人', '46-60岁员工数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'new_hires', '新招聘员工', 1, NULL, '人', '新招聘员工数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'quit_male', '男性离职员工', 1, NULL, '人', '男性离职员工数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'quit_female', '女性离职员工', 1, NULL, '人', '女性离职员工数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'quit_mainland', '大陆离职员工', 1, NULL, '人', '大陆离职员工数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'quit_overseas', '海外离职员工', 1, NULL, '人', '海外离职员工数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'quit18_30', '18-30岁离职员工', 1, NULL, '人', '18-30岁离职员工数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'quit31_45', '31-45岁离职员工', 1, NULL, '人', '31-45岁离职员工数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'quit46_60', '46-60岁离职员工', 1, NULL, '人', '46-60岁离职员工数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'quit_management', '管理人员离职', 1, NULL, '人', '管理人员离职数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'quit_middle', '中层员工离职', 1, NULL, '人', '中层员工离职数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'quit_general', '普通员工离职', 1, NULL, '人', '普通员工离职数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'total_employees', '员工总数', 1, NULL, '人', '员工总数', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'quit_total', '离职总数', 1, NULL, '人', '离职总数', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'turnover_rate', '离职率', 0.01, NULL, '%', '离职率', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'male_turnover_rate', '男性离职率', 0.01, NULL, '%', '男性离职率', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'female_turnover_rate', '女性离职率', 0.01, NULL, '%', '女性离职率', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'mainland_turnover_rate', '大陆员工离职率', 0.01, NULL, '%', '大陆员工离职率', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'overseas_turnover_rate', '海外员工离职率', 0.01, NULL, '%', '海外员工离职率', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'age18_30_turnover_rate', '18-30岁离职率', 0.01, NULL, '%', '18-30岁离职率', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'age31_45_turnover_rate', '31-45岁离职率', 0.01, NULL, '%', '31-45岁离职率', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'age46_60_turnover_rate', '46-60岁离职率', 0.01, NULL, '%', '46-60岁离职率', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'management_turnover_rate', '管理人员离职率', 0.01, NULL, '%', '管理人员离职率', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'middle_turnover_rate', '中层员工离职率', 0.01, NULL, '%', '中层员工离职率', NULL, TRUE FROM categories WHERE name_en = 'employment'
UNION ALL SELECT id, 'default', 'general_turnover_rate', '普通员工离职率', 0.01, NULL, '%', '普通员工离职率', NULL, TRUE FROM categories WHERE name_en = 'employment';

-- TrainingData 字段
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active)
SELECT id, 'default', 'total', '总人数', 1, NULL, '人', '总人数', NULL, TRUE FROM categories WHERE name_en = 'training'
UNION ALL SELECT id, 'default', 'trained', '受训人数', 1, NULL, '人', '受训人数', NULL, TRUE FROM categories WHERE name_en = 'training'
UNION ALL SELECT id, 'default', 'male', '男性受训人次', 1, NULL, '人次', '男性受训人次', NULL, TRUE FROM categories WHERE name_en = 'training'
UNION ALL SELECT id, 'default', 'female', '女性受训人次', 1, NULL, '人次', '女性受训人次', NULL, TRUE FROM categories WHERE name_en = 'training'
UNION ALL SELECT id, 'default', 'mgmt', '管理层受训人次', 1, NULL, '人次', '管理层受训人次', NULL, TRUE FROM categories WHERE name_en = 'training'
UNION ALL SELECT id, 'default', 'middle', '中层受训人次', 1, NULL, '人次', '中层受训人次', NULL, TRUE FROM categories WHERE name_en = 'training'
UNION ALL SELECT id, 'default', 'general', '普通员工受训人次', 1, NULL, '人次', '普通员工受训人次', NULL, TRUE FROM categories WHERE name_en = 'training'
UNION ALL SELECT id, 'default', 'hours_total', '培训总学时', 0.1, NULL, '小时', '培训总学时', NULL, TRUE FROM categories WHERE name_en = 'training'
UNION ALL SELECT id, 'default', 'hours_male', '男性学时', 0.1, NULL, '小时', '男性学时', NULL, TRUE FROM categories WHERE name_en = 'training'
UNION ALL SELECT id, 'default', 'hours_female', '女性学时', 0.1, NULL, '小时', '女性学时', NULL, TRUE FROM categories WHERE name_en = 'training'
UNION ALL SELECT id, 'default', 'hours_mgmt', '管理层学时', 0.1, NULL, '小时', '管理层学时', NULL, TRUE FROM categories WHERE name_en = 'training'
UNION ALL SELECT id, 'default', 'hours_middle', '中层学时', 0.1, NULL, '小时', '中层学时', NULL, TRUE FROM categories WHERE name_en = 'training'
UNION ALL SELECT id, 'default', 'hours_general', '普通学时', 0.1, NULL, '小时', '普通学时', NULL, TRUE FROM categories WHERE name_en = 'training'
UNION ALL SELECT id, 'default', 'coverage_rate', '培训覆盖率', 0.01, NULL, '%', '培训覆盖率', NULL, TRUE FROM categories WHERE name_en = 'training'
UNION ALL SELECT id, 'default', 'male_rate', '男性占比', 0.01, NULL, '%', '男性占比', NULL, TRUE FROM categories WHERE name_en = 'training'
UNION ALL SELECT id, 'default', 'female_rate', '女性占比', 0.01, NULL, '%', '女性占比', NULL, TRUE FROM categories WHERE name_en = 'training'
UNION ALL SELECT id, 'default', 'mgmt_rate', '管理层占比', 0.01, NULL, '%', '管理层占比', NULL, TRUE FROM categories WHERE name_en = 'training'
UNION ALL SELECT id, 'default', 'middle_rate', '中层占比', 0.01, NULL, '%', '中层占比', NULL, TRUE FROM categories WHERE name_en = 'training'
UNION ALL SELECT id, 'default', 'general_rate', '普通员工占比', 0.01, NULL, '%', '普通员工占比', NULL, TRUE FROM categories WHERE name_en = 'training';

-- OHSData 字段
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active)
SELECT id, 'default', 'training_count', '培训次数', 1, NULL, '次', '培训次数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'ohs'
UNION ALL SELECT id, 'default', 'training_participants', '培训参与人次', 1, NULL, '人次', '培训参与人次 (按月)', NULL, TRUE FROM categories WHERE name_en = 'ohs'
UNION ALL SELECT id, 'default', 'training_hours', '培训学时', 0.1, NULL, '小时', '培训学时 (按月)', NULL, TRUE FROM categories WHERE name_en = 'ohs'
UNION ALL SELECT id, 'default', 'injury_count', '工伤数量', 1, NULL, '次', '工伤数量 (按月)', NULL, TRUE FROM categories WHERE name_en = 'ohs'
UNION ALL SELECT id, 'default', 'incident_count', '安全事故数量', 1, NULL, '次', '安全事故数量 (按月)', NULL, TRUE FROM categories WHERE name_en = 'ohs'
UNION ALL SELECT id, 'default', 'fatality_count', '工亡人数', 1, NULL, '人', '工亡人数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'ohs'
UNION ALL SELECT id, 'default', 'lost_workdays', '工伤损失工作日数', 1, NULL, '天', '工伤损失工作日数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'ohs'
UNION ALL SELECT id, 'default', 'safety_investment', '安全生产投入', 0.01, NULL, '万元', '安全生产投入 (按月)', NULL, TRUE FROM categories WHERE name_en = 'ohs'
UNION ALL SELECT id, 'default', 'training_count_total', '培训次数总计', 1, NULL, '次', '培训次数总计', NULL, TRUE FROM categories WHERE name_en = 'ohs'
UNION ALL SELECT id, 'default', 'training_participants_total', '培训参与人次总计', 1, NULL, '人次', '培训参与人次总计', NULL, TRUE FROM categories WHERE name_en = 'ohs'
UNION ALL SELECT id, 'default', 'training_hours_total', '培训学时总计', 0.1, NULL, '小时', '培训学时总计', NULL, TRUE FROM categories WHERE name_en = 'ohs'
UNION ALL SELECT id, 'default', 'injury_count_total', '工伤数量总计', 1, NULL, '次', '工伤数量总计', NULL, TRUE FROM categories WHERE name_en = 'ohs'
UNION ALL SELECT id, 'default', 'incident_count_total', '安全事故数量总计', 1, NULL, '次', '安全事故数量总计', NULL, TRUE FROM categories WHERE name_en = 'ohs'
UNION ALL SELECT id, 'default', 'fatality_count_total', '工亡人数总计', 1, NULL, '人', '工亡人数总计', NULL, TRUE FROM categories WHERE name_en = 'ohs'
UNION ALL SELECT id, 'default', 'lost_workdays_total', '工伤损失工作日数总计', 1, NULL, '天', '工伤损失工作日数总计', NULL, TRUE FROM categories WHERE name_en = 'ohs'
UNION ALL SELECT id, 'default', 'safety_investment_total', '安全生产投入总计', 0.01, NULL, '万元', '安全生产投入总计', NULL, TRUE FROM categories WHERE name_en = 'ohs'
UNION ALL SELECT id, 'default', 'safety_managers', '专职安全管理人员', 1, NULL, '人', '专职安全管理人员', NULL, TRUE FROM categories WHERE name_en = 'ohs'
UNION ALL SELECT id, 'default', 'medical_checks', '员工体检人数', 1, NULL, '人', '员工体检人数', NULL, TRUE FROM categories WHERE name_en = 'ohs'
UNION ALL SELECT id, 'default', 'coverage_rate', '员工体检覆盖率', 0.01, NULL, '%', '员工体检覆盖率', NULL, TRUE FROM categories WHERE name_en = 'ohs'
UNION ALL SELECT id, 'default', 'emergency_drills', '安全应急演练次数', 1, NULL, '次', '安全应急演练次数', NULL, TRUE FROM categories WHERE name_en = 'ohs'
UNION ALL SELECT id, 'default', 'hazards_found', '安全检查排查隐患数', 1, NULL, '个', '安全检查排查隐患数', NULL, TRUE FROM categories WHERE name_en = 'ohs'
UNION ALL SELECT id, 'default', 'occupational_checks', '职业病体检人数', 1, NULL, '人', '职业病体检人数', NULL, TRUE FROM categories WHERE name_en = 'ohs';

-- SatisfactionData 字段
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active)
SELECT id, 'default', 'satisfaction', '员工满意度', 0.01, NULL, '分', '员工满意度 (按月)', NULL, TRUE FROM categories WHERE name_en = 'satisfaction'
UNION ALL SELECT id, 'default', 'annual_average', '年度平均满意度', 0.01, NULL, '分', '年度平均满意度', NULL, TRUE FROM categories WHERE name_en = 'satisfaction';

-- SupplyData 字段
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active)
SELECT id, 'default', 'east', '华东地区供应商', 1, NULL, '个', '华东地区供应商数量', NULL, TRUE FROM categories WHERE name_en = 'supply'
UNION ALL SELECT id, 'default', 'south', '华南地区供应商', 1, NULL, '个', '华南地区供应商数量', NULL, TRUE FROM categories WHERE name_en = 'supply'
UNION ALL SELECT id, 'default', 'other', '其他地区供应商', 1, NULL, '个', '其他地区供应商数量', NULL, TRUE FROM categories WHERE name_en = 'supply'
UNION ALL SELECT id, 'default', 'total_suppliers', '供应商总数', 1, NULL, '个', '供应商总数', NULL, TRUE FROM categories WHERE name_en = 'supply'
UNION ALL SELECT id, 'default', 'env_screened', '环境筛选供应商', 1, NULL, '个', '环境筛选供应商数量', NULL, TRUE FROM categories WHERE name_en = 'supply'
UNION ALL SELECT id, 'default', 'soc_screened', '社会标准供应商', 1, NULL, '个', '社会标准供应商数量', NULL, TRUE FROM categories WHERE name_en = 'supply'
UNION ALL SELECT id, 'default', 'local_amount', '当地采购金额', 0.01, NULL, '万元', '当地采购金额', NULL, TRUE FROM categories WHERE name_en = 'supply'
UNION ALL SELECT id, 'default', 'total_amount', '采购总金额', 0.01, NULL, '万元', '采购总金额', NULL, TRUE FROM categories WHERE name_en = 'supply'
UNION ALL SELECT id, 'default', 'env_penalty_count', '环境处罚次数', 1, NULL, '次', '环境处罚次数', NULL, TRUE FROM categories WHERE name_en = 'supply'
UNION ALL SELECT id, 'default', 'env_penalty_amount', '环境处罚金额', 0.01, NULL, '万元', '环境处罚金额', NULL, TRUE FROM categories WHERE name_en = 'supply'
UNION ALL SELECT id, 'default', 'cyber_incidents', '数据安全事件', 1, NULL, '次', '数据安全事件次数', NULL, TRUE FROM categories WHERE name_en = 'supply'
UNION ALL SELECT id, 'default', 'env_ratio', '环境维度占比', 0.01, NULL, '%', '环境维度占比', NULL, TRUE FROM categories WHERE name_en = 'supply'
UNION ALL SELECT id, 'default', 'soc_ratio', '社会标准占比', 0.01, NULL, '%', '社会标准占比', NULL, TRUE FROM categories WHERE name_en = 'supply'
UNION ALL SELECT id, 'default', 'local_purchase_ratio', '当地采购比例', 0.01, NULL, '%', '当地采购比例', NULL, TRUE FROM categories WHERE name_en = 'supply'
UNION ALL SELECT id, 'default', 'env_assessment_count', '环境影响评估供应商数', 1, NULL, '个', '开展环境影响评估的供应商数量', NULL, TRUE FROM categories WHERE name_en = 'supply'
UNION ALL SELECT id, 'default', 'soc_assessment_count', '社会影响评估供应商数', 1, NULL, '个', '开展社会影响评估的供应商数量', NULL, TRUE FROM categories WHERE name_en = 'supply';

-- ResponsibilityData 字段
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active)
SELECT id, 'default', 'complaints', '客户投诉总数', 1, NULL, '次', '客户投诉总数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'responsibility'
UNION ALL SELECT id, 'default', 'handled', '有效处理件数', 1, NULL, '次', '有效处理件数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'responsibility'
UNION ALL SELECT id, 'default', 'quality_issues', '产品质量问题数', 1, NULL, '次', '产品质量问题数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'responsibility'
UNION ALL SELECT id, 'default', 'recalls', '产品召回次数', 1, NULL, '次', '产品召回次数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'responsibility'
UNION ALL SELECT id, 'default', 'shipments', '产品出货量', 1, NULL, '件', '产品出货量 (按月)', NULL, TRUE FROM categories WHERE name_en = 'responsibility'
UNION ALL SELECT id, 'default', 'customer_satisfaction', '客户满意度', 0.01, NULL, '分', '客户满意度 (按月)', NULL, TRUE FROM categories WHERE name_en = 'responsibility'
UNION ALL SELECT id, 'default', 'cyber_incidents', '网络数据安全事件', 1, NULL, '次', '网络数据安全事件 (按月)', NULL, TRUE FROM categories WHERE name_en = 'responsibility'
UNION ALL SELECT id, 'default', 'complaints_total', '客户投诉总数', 1, NULL, '次', '客户投诉总数', NULL, TRUE FROM categories WHERE name_en = 'responsibility'
UNION ALL SELECT id, 'default', 'handled_total', '有效处理件数', 1, NULL, '次', '有效处理件数', NULL, TRUE FROM categories WHERE name_en = 'responsibility'
UNION ALL SELECT id, 'default', 'handled_rate', '客户投诉有效处理率', 0.01, NULL, '%', '客户投诉有效处理率', NULL, TRUE FROM categories WHERE name_en = 'responsibility'
UNION ALL SELECT id, 'default', 'customer_satisfaction_average', '客户满意度平均值', 0.01, NULL, '分', '客户满意度平均值', NULL, TRUE FROM categories WHERE name_en = 'responsibility'
UNION ALL SELECT id, 'default', 'recall_total', '产品召回总次数', 1, NULL, '次', '产品召回总次数', NULL, TRUE FROM categories WHERE name_en = 'responsibility'
UNION ALL SELECT id, 'default', 'recall_rate', '产品召回百分比', 0.01, NULL, '%', '产品召回百分比', NULL, TRUE FROM categories WHERE name_en = 'responsibility'
UNION ALL SELECT id, 'default', 'quality_issues_total', '产品安全质量问题总数', 1, NULL, '次', '产品安全质量问题总数', NULL, TRUE FROM categories WHERE name_en = 'responsibility'
UNION ALL SELECT id, 'default', 'cyber_incidents_total', '网络数据安全事件总数', 1, NULL, '次', '网络数据安全事件总数', NULL, TRUE FROM categories WHERE name_en = 'responsibility';

-- IPData 字段
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active)
SELECT id, 'default', 'patents', '专利总数', 1, NULL, '个', '专利总数 (按月)', NULL, TRUE FROM categories WHERE name_en = 'ip'
UNION ALL SELECT id, 'default', 'inv_patents', '发明专利', 1, NULL, '个', '发明专利 (按月)', NULL, TRUE FROM categories WHERE name_en = 'ip'
UNION ALL SELECT id, 'default', 'inv_applications', '发明专利申请', 1, NULL, '个', '发明专利申请 (按月)', NULL, TRUE FROM categories WHERE name_en = 'ip'
UNION ALL SELECT id, 'default', 'utility_patents', '实用新型专利', 1, NULL, '个', '实用新型专利 (按月)', NULL, TRUE FROM categories WHERE name_en = 'ip'
UNION ALL SELECT id, 'default', 'design_patents', '外观设计专利', 1, NULL, '个', '外观设计专利 (按月)', NULL, TRUE FROM categories WHERE name_en = 'ip'
UNION ALL SELECT id, 'default', 'granted_patents', '被授权专利', 1, NULL, '个', '被授权专利 (按月)', NULL, TRUE FROM categories WHERE name_en = 'ip'
UNION ALL SELECT id, 'default', 'software_copyrights', '软件著作权', 1, NULL, '个', '软件著作权 (按月)', NULL, TRUE FROM categories WHERE name_en = 'ip'
UNION ALL SELECT id, 'default', 'trademarks', '商标注册', 1, NULL, '个', '商标注册 (按月)', NULL, TRUE FROM categories WHERE name_en = 'ip'
UNION ALL SELECT id, 'default', 'new_patents', '新增专利数', 1, NULL, '个', '新增专利数', NULL, TRUE FROM categories WHERE name_en = 'ip'
UNION ALL SELECT id, 'default', 'patents_total', '累计获得专利数量', 1, NULL, '个', '累计获得专利数量', NULL, TRUE FROM categories WHERE name_en = 'ip'
UNION ALL SELECT id, 'default', 'inv_patents_total', '累计发明专利数量', 1, NULL, '个', '累计发明专利数量', NULL, TRUE FROM categories WHERE name_en = 'ip'
UNION ALL SELECT id, 'default', 'inv_applications_total', '发明专利申请数量', 1, NULL, '个', '发明专利申请数量', NULL, TRUE FROM categories WHERE name_en = 'ip'
UNION ALL SELECT id, 'default', 'utility_patents_total', '累计实用新型专利数量', 1, NULL, '个', '累计实用新型专利数量', NULL, TRUE FROM categories WHERE name_en = 'ip'
UNION ALL SELECT id, 'default', 'design_patents_total', '累计外观设计专利数量', 1, NULL, '个', '累计外观设计专利数量', NULL, TRUE FROM categories WHERE name_en = 'ip'
UNION ALL SELECT id, 'default', 'granted_patents_total', '累计被授权专利数', 1, NULL, '个', '累计被授权专利数', NULL, TRUE FROM categories WHERE name_en = 'ip'
UNION ALL SELECT id, 'default', 'software_copyrights_total', '累计软件著作权数量', 1, NULL, '个', '累计软件著作权数量', NULL, TRUE FROM categories WHERE name_en = 'ip'
UNION ALL SELECT id, 'default', 'trademarks_total', '累计商标注册数量', 1, NULL, '个', '累计商标注册数量', NULL, TRUE FROM categories WHERE name_en = 'ip';

-- CommunityData 字段
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active)
SELECT id, 'default', 'charity_donations', '公益慈善捐赠总额', 0.01, NULL, '万元', '公益慈善捐赠总额 (按月)', NULL, TRUE FROM categories WHERE name_en = 'community'
UNION ALL SELECT id, 'default', 'community_investment', '社区发展投入金额', 0.01, NULL, '万元', '社区发展投入金额 (按月)', NULL, TRUE FROM categories WHERE name_en = 'community'
UNION ALL SELECT id, 'default', 'volunteer_participants', '志愿者活动参与人次', 1, NULL, '人次', '志愿者活动参与人次 (按月)', NULL, TRUE FROM categories WHERE name_en = 'community'
UNION ALL SELECT id, 'default', 'volunteer_hours', '志愿者服务总时长', 0.1, NULL, '小时', '志愿者服务总时长 (按月)', NULL, TRUE FROM categories WHERE name_en = 'community'
ON CONFLICT (category, name_en) DO NOTHING;

-- 新增环境定性指标字段（category=17，set='default'，定性数据，无需step、calculation、unit、description、source）
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES
(17, 'default', 'board_supervision', '董事会监督', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'management_responsibility', '管理层责任', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'environment_strategy', '环境战略', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'risk_opportunity_identification', '风险与机遇识别', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'climate_risk_disclosure', '气候风险披露', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'risk_matrix', '风险矩阵', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'risk_impact', '风险影响', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'resilience', '韧性', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'risk_process', '风险流程', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'risk_management_process', '风险管理流程', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'business_strategy', '业务战略', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'ghg_reduction_target', '温室气体减排目标', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'ghg_reduction_rate', '温室气体减排率', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'ghg_reduction_action', '温室气体减排行动', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'carbon_capture_target', '碳捕集目标', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'carbon_capture_rate', '碳捕集率', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'waste_reduction_target', '废弃物减排目标', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'waste_reduction_action', '废弃物减排行动', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'annual_water_use_target', '年度用水目标', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'annual_water_use_target_rate', '年度用水目标达成率', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'annual_reclaimed_water_use_target', '年度再生水利用目标', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'annual_reclaimed_water_use_target_rate', '年度再生水利用目标达成率', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'water_saving_target', '节水目标', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'water_saving_target_rate', '节水目标达成率', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'water_management_policy', '用水管理政策', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'water_risk_management', '水风险管理', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'water_saving_action', '节水行动', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'clean_technology_strategy', '清洁技术战略', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'clean_technology_practice', '清洁技术实践', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'biodiversity_impact', '生物多样性影响', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'ecological_restoration', '生态修复', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'environmental_accident', '环境事故', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'environmental_penalty', '环境处罚', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'environmental_management_system', '环境管理体系', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'environmental_resource_policy', '环境资源政策', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'environmental_emergency_plan', '环境应急预案', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'green_office', '绿色办公', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'green_factory_policy', '绿色工厂政策', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'environmental_committee', '环境委员会', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'key_pollution_unit', '重点污染单位', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'waste_product_recycling', '废旧产品回收', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'hazardous_waste_emission_target', '危险废物排放目标', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'hazardous_waste_emission_target_rate', '危险废物排放目标达成率', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'sustainable_product_certification', '可持续产品认证', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'material_reduction_target', '材料减量目标', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'annual_packaging_material_target', '年度包装材料目标', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'annual_packaging_material_target_rate', '年度包装材料目标标达成率', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'packaging_material_reduction_target', '包装材料减量目标', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'packaging_material_reduction_target_rate', '包装材料减量目标达成率', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'product_lifecycle_management', '产品生命周期管理', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'annual_office_paper_target', '年度办公用纸目标', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'annual_office_paper_target_rate', '年度办公用纸目标达成率', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'chemical_management', '化学品管理', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'chemical_inventory', '化学品库存', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'energy_reduction_target', '能源减排目标', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'renewable_energy_target', '可再生能源目标', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'renewable_energy_use_development', '可再生能源利用发展', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'energy_saving_action_results', '节能行动成果', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'energy_management_system', '能源管理体系', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'product_carbon_footprint', '产品碳足迹', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'product_carbon_footprint_plan', '产品碳足迹规划', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'carbon_neutrality_target_year', '碳中和目标年份', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'carbon_neutrality_plan', '碳中和计划', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'carbon_neutrality_target_scheme', '碳中和目标方案', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'carbon_neutrality_plan_rate', '碳中和计划达成率', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'carbon_reduction_target', '碳减排目标', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'joined_sbti', '加入SBTi', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'cdp_disclosure', 'CDP披露', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'carbon_inventory_disclosure', '碳盘查披露', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'carbon_inventory_report_verification', '碳盘查报告核查', NULL, NULL, NULL, '', '', TRUE),
(17, 'default', 'greenhouse_gas_verification_system', '温室气体核查体系', NULL, NULL, NULL, '', '', TRUE);

-- 新增社会定性-劳工指标字段（category=19，set='default'，定性数据，无需step、calculation、unit、description、source）
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES
(19, 'default', 'employee_hiring_and_dismissal', '员工聘用及解雇', NULL, NULL, NULL, '', '', TRUE),
(19, 'default', 'industry_employee_turnover_rate', '行业员工流失率', NULL, NULL, NULL, '', '', TRUE),
(19, 'default', 'guangda_vs_industry_turnover_comparison', '光大同创的员工流失率与行业流失率的对比表', NULL, NULL, NULL, '', '', TRUE),
(19, 'default', 'salary_management', '薪酬管理', NULL, NULL, NULL, '', '', TRUE),
(19, 'default', 'ohs_management_system', '职业健康安全管理体系', NULL, NULL, NULL, '', '', TRUE),
(19, 'default', 'safety_production_policy', '安全生产政策', NULL, NULL, NULL, '', '', TRUE),
(19, 'default', 'ohs_target', '保障职业健康与安全目标', NULL, NULL, NULL, '', '', TRUE),
(19, 'default', 'ohs_target_measures', '保障职业健康与安全目标措施', NULL, NULL, NULL, '', '', TRUE),
(19, 'default', 'hazard_identification_risk_assessment_accident_investigation', '危害识别、风险评估和事故调查', NULL, NULL, NULL, '', '', TRUE),
(19, 'default', 'ohs_participation_consultation_communication', '职业健康安全事务：工作者的参与、意见征询和沟通', NULL, NULL, NULL, '', '', TRUE),
(19, 'default', 'ohs_training', '工作者职业健康安全培训', NULL, NULL, NULL, '', '', TRUE),
(19, 'default', 'promote_worker_health', '促进工作者健康', NULL, NULL, NULL, '', '', TRUE),
(19, 'default', 'employee_satisfaction_survey_plan', '员工满意度调查计划', NULL, NULL, NULL, '', '', TRUE),
(19, 'default', 'employee_satisfaction_survey_coverage', '员工满意度调查覆盖率/覆盖情况', NULL, NULL, NULL, '', '', TRUE),
(19, 'default', 'employee_satisfaction_project_ranking', '员工满意度项目排名', NULL, NULL, NULL, '', '', TRUE),
(19, 'default', 'full_time_employee_benefits', '提供给全职员工（不包括临时或兼职员工）的福利', NULL, NULL, NULL, '', '', TRUE),
(19, 'default', 'employee_care', '员工关爱', NULL, NULL, NULL, '', '', TRUE),
(19, 'default', 'annual_training_plan_hours_target', '年度培训计划小时数目标', NULL, NULL, NULL, '', '', TRUE),
(19, 'default', 'annual_training_plan_hours_target_rate', '年度培训计划小时数目标达成率（%）', NULL, NULL, NULL, '', '', TRUE),
(19, 'default', 'annual_training_plan', '年度培训计划', NULL, NULL, NULL, '', '', TRUE),
(19, 'default', 'annual_training_plan_completion_rate', '年度培训计划达成率（%）', NULL, NULL, NULL, '', '', TRUE),
(19, 'default', 'diversity_and_equal_opportunity', '多元化和机会平等', NULL, NULL, NULL, '', '', TRUE),
(19, 'default', 'promotion_mechanism', '晋升机制', NULL, NULL, NULL, '', '', TRUE),
(19, 'default', 'discrimination_events_and_corrective_actions', '歧视事件及采取的纠正行动', NULL, NULL, NULL, '', '', TRUE),
(19, 'default', 'child_labor_risk_sites_suppliers', '具有重大童工事件风险的运营点和供应商', NULL, NULL, NULL, '', '', TRUE),
(19, 'default', 'forced_labor_risk_sites_suppliers', '具有强迫或强制劳动事件重大风险的运营点和供应商', NULL, NULL, NULL, '', '', TRUE),
(19, 'default', 'democratic_management', '民主管理', NULL, NULL, NULL, '', '', TRUE),
(19, 'default', 'emergency_management_system', '应急管理体系', NULL, NULL, NULL, '', '', TRUE),
(19, 'default', 'safety_emergency_measures', '安全应急措施', NULL, NULL, NULL, '', '', TRUE)
ON CONFLICT (category, name_en) DO NOTHING;

-- SocialQualOtherData fields
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES
(21, 'default', 'supplier_management_system', '供应商管理体系', NULL, NULL, '', '', '', TRUE),
(21, 'default', 'supplier_integrity_requirements', '供应商廉洁要求', NULL, NULL, '', '', '', TRUE),
(21, 'default', 'supplier_management_goals_measures', '供应商管理目标及措施', NULL, NULL, '', '', '', TRUE),
(21, 'default', 'supplier_identification', '供应商识别', NULL, NULL, '', '', '', TRUE),
(21, 'default', 'green_supply_chain', '绿色供应链', NULL, NULL, '', '', '', TRUE),
(21, 'default', 'supply_chain_diversity_policy', '供应链多元化政策', NULL, NULL, '', '', '', TRUE),
(21, 'default', 'supply_chain_negative_environmental_impact_actions', '供应链对环境的负面影响及采取的行动', NULL, NULL, '', '', '', TRUE),
(21, 'default', 'supply_chain_negative_social_impact_actions', '供应链对社会的负面影响及采取的行动', NULL, NULL, '', '', '', TRUE),
(21, 'default', 'supply_chain_environmental_commitment_rate', '供应链环境承诺书签署率', NULL, NULL, '', '', '', TRUE),
(21, 'default', 'supply_chain_environmental_audit_completion_rate', '供应链环境现场审核完成率', NULL, NULL, '', '', '', TRUE),
(21, 'default', 'supply_chain_environmental_audit_improvement', '供应链环境现场审核改进情况说明', NULL, NULL, '', '', '', TRUE),
(21, 'default', 'supply_chain_environmental_management_goals', '供应链环境管理目标', NULL, NULL, '', '', '', TRUE),
(21, 'default', 'product_quality_safety_mechanism', '产品质量与安全机制', NULL, NULL, '', '', '', TRUE),
(21, 'default', 'truthful_fair_information_contract', '真实公正的信息与合同签订', NULL, NULL, '', '', '', TRUE),
(21, 'default', 'intellectual_property_policy', '知识产权保护政策', NULL, NULL, '', '', '', TRUE),
(21, 'default', 'intellectual_property_practices', '维护及保障知识产权有关的惯例', NULL, NULL, '', '', '', TRUE),
(21, 'default', 'customer_privacy_protection', '客户隐私保护', NULL, NULL, '', '', '', TRUE),
(21, 'default', 'data_security_management', '数据安全管理', NULL, NULL, '', '', '', TRUE),
(21, 'default', 'data_security_privacy_certification_disclosure', '数据安全隐私认证与信披', NULL, NULL, '', '', '', TRUE),
(21, 'default', 'information_security_management_system_certification', '信息安全管理体系认证', NULL, NULL, '', '', '', TRUE),
(21, 'default', 'community_participation', '社区参与', NULL, NULL, '', '', '', TRUE),
(21, 'default', 'stakeholder_community_communication_goals_plan', '利益相关方社区沟通目标计划', NULL, NULL, '', '', '', TRUE),
(21, 'default', 'stakeholder_community_communication_completion_rate', '利益相关方社区沟通目标计划完成率（%）', NULL, NULL, '', '', '', TRUE),
(21, 'default', 'local_community_participation_assessment_development', '有当地社区参与、影响评估和发展计划的运营点', NULL, NULL, '', '', '', TRUE),
(21, 'default', 'green_finance_products', '绿色金融产品', NULL, NULL, '', '', '', TRUE),
(21, 'default', 'digital_transformation', '数字转型', NULL, NULL, '', '', '', TRUE)
ON CONFLICT (category, name_en) DO NOTHING;

-- GovernanceData fields
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES
(22, 'default', 'governance_structure', '治理结构', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'activities_value_chain_other_business_relationships', '活动、价值链和其他业务关系', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'regulatory_framework_composition', '管制架构和组成', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'nomination_selection_highest_governance_body', '最高管治机构的提名与遴选', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'number_of_committees', '委员会数目', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'board_of_directors', '董事会', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'board_independence', '董事会独立性', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'board_gender_ratio', '董事会性别比例', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'board_of_supervisors', '监事会', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'shareholders_meeting', '股东大会', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'governance_mechanism', '治理机制', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'delegated_responsibility_for_managing_impacts', '为管理影响的责任授权', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'management_compensation_incentive_system', '管理层薪酬激励制度及执行情况说明', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'senior_management_stability', '高层管理人员稳定性', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'communication_of_important_concerns', '重要关切问题的沟通', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'shared_knowledge_highest_governance_body', '最高管治机构的共同知识', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'oversight_highest_governance_body', '在管理影响方面，最高管治机构的监督作用', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'association_membership', '协会的成员资格', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'internal_control', '内部控制', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'accountability_mechanism', '追责机制', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'protecting_minority_shareholders_rights', '中小股东权益保护', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'investor_communication', '投资者沟通交流', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'esg_governance', 'ESG治理', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'esg_strategy_goal_management', 'ESG战略与目标管理', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'stakeholder_communication_management', '利益相关方沟通管理', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'stakeholder_opposition', '利益相关者的反对', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'esg_executive_compensation_link', 'ESG与高管薪酬挂钩', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'third_party_assurance', '第三方鉴证', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'assurance_report_disclosure', '鉴证报告披露', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'assurance_agency_personnel_qualification', '鉴证机构人员资质', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'assurance_agency_qualification', '鉴证机构资质', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'board_esg_committee_setup', '董事会ESG委员会的设置', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'highest_governance_body_role_sustainability_report', '最高管治机构在可持续发展报告中的作用', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'materiality_assessment', '重要性评估', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'materiality_assessment_results', '重要性评估结果', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'social_responsibility_awards_honors', '社会责任奖项及荣誉', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'anti_corruption_policy', '反腐败政策', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'corruption_litigation_events_results', '腐败诉讼事件及结果', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'anti_corruption_prevention_measures', '反腐败防范措施', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'anti_corruption_training', '反腐败培训', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'anti_bribery_training_completion_rate', '反贪污和贿赂培训及达成率（%）', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'anti_bribery_training_implementation', '反贪污和贿赂培训及执行情况说明', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'business_ethics_code_disclosure', '商业道德行为准则与信披', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'stakeholder_notification_completion_rate', '利益相关方公示告知及达成率（%）', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'guangda_tongchuang_coc_code', '光大同创的CoC行为准则', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'negative_executive_events_two_years', '两年高管负面事件', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'disclosure_violations_two_years', '两年信披违规事件', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'financial_fraud_two_years', '两年财务造假事件', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'corruption_bribery_two_years', '两年腐败与贿赂事件', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'embezzlement_misappropriation_two_years', '两年职务侵占与挪用事件', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'litigation_amount_within_one_year', '1年以内的诉讼涉案金额', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'litigation_exists', '是否有诉讼', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'external_penalties', '外部处分', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'case_investigation', '立案调查', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'risk_management_system', '风险管理体系', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'esg_risk_management', 'ESG风险管理', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'board_oversight_risk_management', '董事会监督风险管理', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'risk_management_system_reference_standards', '风险管理体系参照标准', NULL, NULL, '', '', '', TRUE),
(22, 'default', 'tax_transparency_policy_implementation', '税收透明度相关政策及执行情况说明', NULL, NULL, '', '', '', TRUE);

