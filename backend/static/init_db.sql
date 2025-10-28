-- search_path: "$user", public


CREATE TABLE categories (
	id SERIAL NOT NULL, 
	name_en VARCHAR(128) NOT NULL, 
	name_zh VARCHAR(128) NOT NULL, 
	model_class VARCHAR(128) NOT NULL, 
	domain VARCHAR(64) NOT NULL, 
	period_type VARCHAR(12) NOT NULL, 
	is_active BOOLEAN NOT NULL, 
	CONSTRAINT categories_pkey PRIMARY KEY (id)
);

INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ('energy', '能源', 'EnergyData', '环境', 'month', true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ('water', '水资源', 'WaterData', '环境', 'month', true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ('emission', '排放', 'EmissionData', '环境', 'month', true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ('waste', '废弃物', 'WasteData', '环境', 'month', true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ('investment', '资金投入', 'InvestmentData', '环境', 'month', true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ('management', '环境管理', 'ManagementData', '环境', 'month', true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ('env_quant', '定量', 'EnvQuantData', '环境', 'year', true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ('env_qual', '定性', 'EnvQualData', '环境', 'year', true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ('governance', '定性', 'GovernanceData', '治理', 'year', true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ('social_qual_other', '定性-其他', 'SocialQualOtherData', '社会', 'year', true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ('social_qual_labor', '定性-劳工', 'SocialQualLaborData', '社会', 'year', true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ('social_quant_labor', '定量-劳工', 'SocialQuantLaborData', '社会', 'year', true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ('social_quant_other', '定量-其他', 'SocialQuantOtherData', '社会', 'year', true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ('material', '物料', 'MaterialData', '环境', 'month', true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ('satisfaction', '员工满意度', 'SatisfactionData', '社会', 'month', true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ('training', '教育与培训', 'TrainingData', '社会', 'month', true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ('employment', '雇佣', 'EmploymentData', '社会', 'month', true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ('supply', '供应链', 'SupplyData', '社会', 'month', true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ('ohs', '职健与安全', 'OHSData', '社会', 'month', true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ('ip', '知识产权', 'IPData', '社会', 'month', true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ('community', '社区参与与志愿活动', 'CommunityData', '社会', 'month', true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ('responsibility', '产品责任', 'ResponsibilityData', '社会', 'month', true);


CREATE TABLE community (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	charity_donations JSON, 
	community_investment JSON, 
	volunteer_participants JSON, 
	volunteer_hours JSON, 
	CONSTRAINT community_pkey PRIMARY KEY (factory, year)
);

INSERT INTO community (factory, year, charity_donations, community_investment, volunteer_participants, volunteer_hours) VALUES ('安徽光大美科', 2025, '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.07, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0]', '[0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]');
INSERT INTO community (factory, year, charity_donations, community_investment, volunteer_participants, volunteer_hours) VALUES ('安徽光大同创', 2025, '[0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 3.0, 0.0, 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0]', '[0.0, 0.0, 1.0, 0.0, 3.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]');


CREATE TABLE emission (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	category_one DOUBLE PRECISION NOT NULL, 
	category_two DOUBLE PRECISION NOT NULL, 
	category_three DOUBLE PRECISION NOT NULL, 
	category_four DOUBLE PRECISION NOT NULL, 
	category_five DOUBLE PRECISION NOT NULL, 
	category_six DOUBLE PRECISION NOT NULL, 
	total_revenue DOUBLE PRECISION NOT NULL, 
	category_three_total DOUBLE PRECISION NOT NULL, 
	total_emission DOUBLE PRECISION NOT NULL, 
	emission_intensity DOUBLE PRECISION NOT NULL, 
	voc DOUBLE PRECISION NOT NULL, 
	nmhc DOUBLE PRECISION NOT NULL, 
	benzene DOUBLE PRECISION NOT NULL, 
	particulate DOUBLE PRECISION NOT NULL, 
	nox_sox_other DOUBLE PRECISION NOT NULL, 
	waste_gas_total DOUBLE PRECISION NOT NULL, 
	CONSTRAINT emission_pkey PRIMARY KEY (factory, year)
);

INSERT INTO emission (factory, year, category_one, category_two, category_three, category_four, category_five, category_six, total_revenue, category_three_total, total_emission, emission_intensity, voc, nmhc, benzene, particulate, nox_sox_other, waste_gas_total) VALUES ('安徽光大美科', 2024, 3.0, 7.0, 11.0, 4.0, 5.0, 0.0, 1.0, 20.0, 30.0, 30.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
INSERT INTO emission (factory, year, category_one, category_two, category_three, category_four, category_five, category_six, total_revenue, category_three_total, total_emission, emission_intensity, voc, nmhc, benzene, particulate, nox_sox_other, waste_gas_total) VALUES ('安徽光大美科', 2025, 7.0, 8.0, 7.0, 17.0, 0.0, 0.0, 0.0, 24.0, 39.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);


CREATE TABLE employment (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	full_time JSON NOT NULL, 
	part_time JSON NOT NULL, 
	male JSON NOT NULL, 
	female JSON NOT NULL, 
	management JSON NOT NULL, 
	management_female JSON NOT NULL, 
	middle JSON NOT NULL, 
	general JSON NOT NULL, 
	mainland JSON NOT NULL, 
	overseas JSON NOT NULL, 
	edu_phd JSON NOT NULL, 
	edu_master JSON NOT NULL, 
	edu_bachelor JSON NOT NULL, 
	edu_junior JSON NOT NULL, 
	avg_social_fund JSON NOT NULL, 
	inc_social_fund JSON NOT NULL, 
	age18_30 JSON NOT NULL, 
	age31_45 JSON NOT NULL, 
	age46_60 JSON NOT NULL, 
	new_hires JSON NOT NULL, 
	quit_male JSON NOT NULL, 
	quit_female JSON NOT NULL, 
	quit_mainland JSON NOT NULL, 
	quit_overseas JSON NOT NULL, 
	quit18_30 JSON NOT NULL, 
	quit31_45 JSON NOT NULL, 
	quit46_60 JSON NOT NULL, 
	quit_management JSON NOT NULL, 
	quit_middle JSON NOT NULL, 
	quit_general JSON NOT NULL, 
	total_employees INTEGER, 
	quit_total INTEGER, 
	turnover_rate DOUBLE PRECISION, 
	male_turnover_rate DOUBLE PRECISION, 
	female_turnover_rate DOUBLE PRECISION, 
	mainland_turnover_rate DOUBLE PRECISION, 
	overseas_turnover_rate DOUBLE PRECISION, 
	age18_30_turnover_rate DOUBLE PRECISION, 
	age31_45_turnover_rate DOUBLE PRECISION, 
	age46_60_turnover_rate DOUBLE PRECISION, 
	management_turnover_rate DOUBLE PRECISION, 
	middle_turnover_rate DOUBLE PRECISION, 
	general_turnover_rate DOUBLE PRECISION, 
	CONSTRAINT employment_pkey PRIMARY KEY (factory, year)
);

INSERT INTO employment (factory, year, full_time, part_time, male, female, management, management_female, middle, general, mainland, overseas, edu_phd, edu_master, edu_bachelor, edu_junior, avg_social_fund, inc_social_fund, age18_30, age31_45, age46_60, new_hires, quit_male, quit_female, quit_mainland, quit_overseas, quit18_30, quit31_45, quit46_60, quit_management, quit_middle, quit_general, total_employees, quit_total, turnover_rate, male_turnover_rate, female_turnover_rate, mainland_turnover_rate, overseas_turnover_rate, age18_30_turnover_rate, age31_45_turnover_rate, age46_60_turnover_rate, management_turnover_rate, middle_turnover_rate, general_turnover_rate) VALUES ('安徽光大美科', 2025, '[0, 0, 0, 0, 0, 0, 0, 0, 50, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 11, 0, 0, 0]', '[0, 0, 3, 0, 0, 0, 0, 0, 13, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 18, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 15, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', 61, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);


CREATE TABLE energy (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	purchased_power JSON NOT NULL, 
	renewable_power JSON NOT NULL, 
	gasoline JSON NOT NULL, 
	diesel JSON NOT NULL, 
	natural_gas JSON NOT NULL, 
	other_energy JSON NOT NULL, 
	water JSON NOT NULL, 
	coal JSON NOT NULL, 
	total_energy_consumption DOUBLE PRECISION, 
	turnover DOUBLE PRECISION, 
	energy_consumption_intensity DOUBLE PRECISION, 
	CONSTRAINT energy_pkey PRIMARY KEY (factory, year)
);

INSERT INTO energy (factory, year, purchased_power, renewable_power, gasoline, diesel, natural_gas, other_energy, water, coal, total_energy_consumption, turnover, energy_consumption_intensity) VALUES ('安徽光大美科', 2025, '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.22, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.28, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.37, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0]', 1.93, 0.0, 0.0);
INSERT INTO energy (factory, year, purchased_power, renewable_power, gasoline, diesel, natural_gas, other_energy, water, coal, total_energy_consumption, turnover, energy_consumption_intensity) VALUES ('安徽光大美科', 2024, '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.26, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', 0.38, 0.0, 0.0);
INSERT INTO energy (factory, year, purchased_power, renewable_power, gasoline, diesel, natural_gas, other_energy, water, coal, total_energy_consumption, turnover, energy_consumption_intensity) VALUES ('安徽光大同创', 2025, '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', NULL, NULL, NULL);


CREATE TABLE env_qual (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	indicator VARCHAR(100) NOT NULL, 
	current_text TEXT, 
	comparison_text TEXT, 
	reason TEXT, 
	CONSTRAINT env_qual_pkey PRIMARY KEY (factory, year, indicator)
);

INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'climate_risk_disclosure', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'risk_matrix', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'risk_impact', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'resilience', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'risk_process', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'risk_management_process', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'business_strategy', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'ghg_reduction_target', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'ghg_reduction_rate', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'ghg_reduction_action', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'carbon_capture_target', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'carbon_capture_rate', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'waste_reduction_target', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'waste_reduction_action', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'annual_water_use_target', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'annual_water_use_target_rate', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'annual_reclaimed_water_use_target', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'annual_reclaimed_water_use_target_rate', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'water_saving_target', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'water_saving_target_rate', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'water_management_policy', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'water_risk_management', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'water_saving_action', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'clean_technology_strategy', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'clean_technology_practice', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'biodiversity_impact', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'ecological_restoration', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'environmental_accident', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'environmental_penalty', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'environmental_management_system', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'environmental_resource_policy', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'environmental_emergency_plan', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'green_office', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'green_factory_policy', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'environmental_committee', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'key_pollution_unit', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'waste_product_recycling', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'hazardous_waste_emission_target', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'hazardous_waste_emission_target_rate', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'sustainable_product_certification', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'material_reduction_target', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'annual_packaging_material_target', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'annual_packaging_material_target_rate', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'packaging_material_reduction_target', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'packaging_material_reduction_target_rate', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'product_lifecycle_management', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'annual_office_paper_target', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'annual_office_paper_target_rate', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'chemical_management', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'chemical_inventory', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'energy_reduction_target', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'renewable_energy_target', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'renewable_energy_use_development', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'energy_saving_action_results', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'energy_management_system', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'product_carbon_footprint', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'product_carbon_footprint_plan', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'carbon_neutrality_target_year', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'carbon_neutrality_plan', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'carbon_neutrality_target_scheme', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'carbon_neutrality_plan_rate', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'carbon_reduction_target', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'joined_sbti', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'cdp_disclosure', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'carbon_inventory_disclosure', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'carbon_inventory_report_verification', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'greenhouse_gas_verification_system', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'board_supervision', '', '', NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'environment_strategy', '', '', NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'management_responsibility', '', '', NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, 'risk_opportunity_identification', '', NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'climate_risk_disclosure', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'risk_matrix', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'risk_impact', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'resilience', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'risk_process', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'risk_management_process', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'business_strategy', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'ghg_reduction_target', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'ghg_reduction_rate', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'ghg_reduction_action', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'carbon_capture_target', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'carbon_capture_rate', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'waste_reduction_target', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'waste_reduction_action', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'annual_water_use_target', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'annual_water_use_target_rate', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'annual_reclaimed_water_use_target', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'annual_reclaimed_water_use_target_rate', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'water_saving_target', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'water_saving_target_rate', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'water_management_policy', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'water_risk_management', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'board_supervision', '无', '', '');
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'management_responsibility', '无', '', '');
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'environment_strategy', '环境管理手册--环境方针', '', '');
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'water_saving_action', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'clean_technology_strategy', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'clean_technology_practice', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'biodiversity_impact', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'ecological_restoration', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'environmental_accident', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'environmental_penalty', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'environmental_management_system', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'environmental_resource_policy', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'environmental_emergency_plan', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'green_office', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'green_factory_policy', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'environmental_committee', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'key_pollution_unit', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'waste_product_recycling', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'hazardous_waste_emission_target', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'hazardous_waste_emission_target_rate', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'sustainable_product_certification', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'material_reduction_target', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'annual_packaging_material_target', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'annual_packaging_material_target_rate', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'packaging_material_reduction_target', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'packaging_material_reduction_target_rate', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'product_lifecycle_management', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'annual_office_paper_target', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'annual_office_paper_target_rate', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'chemical_management', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'chemical_inventory', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'energy_reduction_target', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'renewable_energy_target', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'renewable_energy_use_development', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'energy_saving_action_results', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'energy_management_system', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'product_carbon_footprint', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'product_carbon_footprint_plan', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'carbon_neutrality_target_year', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'carbon_neutrality_plan', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'carbon_neutrality_target_scheme', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'carbon_neutrality_plan_rate', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'carbon_reduction_target', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'joined_sbti', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'cdp_disclosure', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'carbon_inventory_disclosure', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'carbon_inventory_report_verification', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'greenhouse_gas_verification_system', NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, 'risk_opportunity_identification', '《风险和机遇控制程序》-【风险和机遇识别应对措施表】', '', '');


CREATE TABLE env_quant (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	indicator VARCHAR(200) NOT NULL, 
	reason VARCHAR(2000), 
	CONSTRAINT env_quant_pkey PRIMARY KEY (factory, year, indicator)
);

INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'input_renewable_material_weight_or_volume', '不知道');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'input_non_renewable_material_weight_or_volume', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'total_input_material', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'material_consumption', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'share_of_renewable_input_materials', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'output_total_renewable_material', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'total_output', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'share_of_renewable_output', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'packaging_materials', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'paper', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'packaging_material_consumption_intensity', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'paper_consumption_intensity', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'wood_fiber', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'aluminum', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'purchased_electricity', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'renewable_energy_consumption', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'coal_consumption', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'gasoline_consumption', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'diesel_consumption', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'natural_gas_consumption', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'other_energy_consumption', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'total_energy_consumption', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'energy_consumption_intensity', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'water_withdrawal_industrial', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'water_withdrawal_domestic', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'total_water_withdrawal', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'water_use_intensity', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'effluent_discharge_volume', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'water_consumption', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'recycled_water_resource_recovery_volume', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'water_resource_recovery_rate', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'total_reclaimed_water_use_intensity', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'total_reclaimed_water_use', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'total_greenhouse_gas_emissions', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'greenhouse_gas_emission_intensity', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'greenhouse_gas_direct_emissions', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'greenhouse_gas_indirect_emissions', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'value_chain_indirect_emissions_scope_3', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'volatile_organic_compounds', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'non_methane_total_hydrocarbons', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'benzene_compounds', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'particulate_matter', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'nox_sox_and_other_major_gas_emissions', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'total_hazardous_waste', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'hazardous_waste_intensity', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'recycled_epe_material', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'recycled_blister_paper_plastic_materials', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'municipal_industrial_waste', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'total_non_hazardous_waste', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'total_waste_generated', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'recycled_waste', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'waste_recycling_rate', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'protective_product_waste_comprehensive_utilization_rate', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'waste_sent_for_disposal', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'wastewater_discharge_volume', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'wastewater_discharge_intensity', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'emission_exceedance_incidents', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'improper_three_wastes_disposal_incidents', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'environmental_protection_investment', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'environmental_investment_intensity', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'share_of_green_revenue', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'climate_change_r_and_d_expenditure', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'clean_technology_r_and_d_investment', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'national_level_green_factory', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'provincial_level_green_factory', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'environmental_penalty_intensity', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'environmental_penalty_amount', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大同创', 2025, 'environmental_violations', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'packaging_material_consumption_intensity', '24年营业额待确认');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'paper_consumption_intensity', '24年营业额待确认');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'aluminum', '未使用');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'coal_consumption', '未使用');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'wood_fiber', '未使用');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'input_renewable_material_weight_or_volume', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'input_non_renewable_material_weight_or_volume', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'total_input_material', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'material_consumption', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'share_of_renewable_input_materials', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'output_total_renewable_material', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'total_output', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'share_of_renewable_output', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'packaging_materials', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'paper', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'purchased_electricity', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'renewable_energy_consumption', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'gasoline_consumption', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'diesel_consumption', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'natural_gas_consumption', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'other_energy_consumption', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'total_energy_consumption', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'water_use_intensity', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'effluent_discharge_volume', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'water_consumption', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'water_resource_recovery_rate', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'total_reclaimed_water_use_intensity', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'total_reclaimed_water_use', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'total_greenhouse_gas_emissions', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'volatile_organic_compounds', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'non_methane_total_hydrocarbons', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'benzene_compounds', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'particulate_matter', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'nox_sox_and_other_major_gas_emissions', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'total_hazardous_waste', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'recycled_epe_material', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'recycled_blister_paper_plastic_materials', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'municipal_industrial_waste', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'total_non_hazardous_waste', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'total_waste_generated', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'recycled_waste', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'waste_recycling_rate', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'protective_product_waste_comprehensive_utilization_rate', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'waste_sent_for_disposal', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'wastewater_discharge_volume', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'wastewater_discharge_intensity', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'emission_exceedance_incidents', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'improper_three_wastes_disposal_incidents', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'environmental_protection_investment', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'clean_technology_r_and_d_investment', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'national_level_green_factory', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'provincial_level_green_factory', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'environmental_penalty_intensity', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'environmental_penalty_amount', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'environmental_violations', '');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'climate_change_r_and_d_expenditure', '有能源管理改善方案，未统计具体金额');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'energy_consumption_intensity', '24年营业额待确认');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'environmental_investment_intensity', '24年营业额待确认');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'greenhouse_gas_direct_emissions', '最终数据待第三方核查');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'greenhouse_gas_emission_intensity', '24年营业额待确认');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'greenhouse_gas_indirect_emissions', '最终数据待第三方核查');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'hazardous_waste_intensity', '24年营业额待确认');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'recycled_water_resource_recovery_volume', '循环水是统计进水量，估算');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'share_of_green_revenue', '24年营业额待确认');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'total_water_withdrawal', '数据引用错误');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'value_chain_indirect_emissions_scope_3', '最终数据待第三方核查');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'water_withdrawal_domestic', '数据引用错误');
INSERT INTO env_quant (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'water_withdrawal_industrial', '数据引用错误');


CREATE TABLE factories (
	id SERIAL NOT NULL, 
	name VARCHAR(100) NOT NULL, 
	address VARCHAR(100), 
	phone VARCHAR(20), 
	email VARCHAR(50), 
	is_active BOOLEAN NOT NULL, 
	CONSTRAINT factories_pkey PRIMARY KEY (id), 
	CONSTRAINT factories_name_key UNIQUE NULLS DISTINCT (name)
);

INSERT INTO factories (name, address, phone, email, is_active) VALUES ('安徽光大美科', NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ('安徽光大同创', NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ('昆山一', NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ('昆山二', NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ('成都厂', NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ('惠阳厂', NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ('厦门奔方', NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ('武汉厂', NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ('南昌厂', NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ('越南', NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ('墨西哥', NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ('深圳光大', NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ('沃普智选', NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ('青岛音诺', NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ('天津茂创', NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ('合肥山秀', NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ('苏州领新', NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ('东莞美科同创', NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ('重庆致贯', NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ('苏州致贯', NULL, NULL, NULL, true);


CREATE TABLE governance (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	indicator VARCHAR(200) NOT NULL, 
	current_text TEXT, 
	comparison_text TEXT, 
	reason TEXT, 
	CONSTRAINT governance_pkey PRIMARY KEY (factory, year, indicator)
);

INSERT INTO governance (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '活动、价值链和其他业务关系', '方针', 'to24', '原因');
INSERT INTO governance (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '最高管治机构的提名与遴选', '文件', '', '');
INSERT INTO governance (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '委员会数目', '记录', '', '');
INSERT INTO governance (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '管制架构和组成', '政策', 'to', '');
INSERT INTO governance (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '活动、价值链和其他业务关系', '', '', '也要');
INSERT INTO governance (factory, year, indicator, current_text, comparison_text, reason) VALUES ('昆山二', 2025, '活动、价值链和其他业务关系', '', '对比', '');
INSERT INTO governance (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '活动、价值链和其他业务关系', '', '', '对比');
INSERT INTO governance (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '活动、价值链和其他业务关系', '', '', '原因');


CREATE TABLE investment (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	env_invest JSON NOT NULL, 
	clean_tech_invest JSON NOT NULL, 
	climate_invest JSON NOT NULL, 
	green_income JSON NOT NULL, 
	total_investment DOUBLE PRECISION NOT NULL, 
	green_income_ratio DOUBLE PRECISION NOT NULL, 
	total_revenue DOUBLE PRECISION NOT NULL, 
	env_invest_intensity DOUBLE PRECISION NOT NULL, 
	CONSTRAINT investment_pkey PRIMARY KEY (factory, year)
);

INSERT INTO investment (factory, year, env_invest, clean_tech_invest, climate_invest, green_income, total_investment, green_income_ratio, total_revenue, env_invest_intensity) VALUES ('安徽光大美科', 2024, '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', 2.0, 0.0, 0.0, 0.0);
INSERT INTO investment (factory, year, env_invest, clean_tech_invest, climate_invest, green_income, total_investment, green_income_ratio, total_revenue, env_invest_intensity) VALUES ('安徽光大美科', 2025, '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0]', 3.5, 0.0, 0.0, 0.0);


CREATE TABLE ip (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	patents JSON NOT NULL, 
	inv_patents JSON NOT NULL, 
	inv_applications JSON NOT NULL, 
	utility_patents JSON NOT NULL, 
	design_patents JSON NOT NULL, 
	granted_patents JSON NOT NULL, 
	software_copyrights JSON NOT NULL, 
	trademarks JSON NOT NULL, 
	new_patents INTEGER, 
	patents_total INTEGER, 
	inv_patents_total INTEGER, 
	inv_applications_total INTEGER, 
	utility_patents_total INTEGER, 
	design_patents_total INTEGER, 
	granted_patents_total INTEGER, 
	software_copyrights_total INTEGER, 
	trademarks_total INTEGER, 
	CONSTRAINT ip_pkey PRIMARY KEY (factory, year)
);

INSERT INTO ip (factory, year, patents, inv_patents, inv_applications, utility_patents, design_patents, granted_patents, software_copyrights, trademarks, new_patents, patents_total, inv_patents_total, inv_applications_total, utility_patents_total, design_patents_total, granted_patents_total, software_copyrights_total, trademarks_total) VALUES ('安徽光大美科', 2025, '[0, 0, 0, 0, 0, 0, 0, 0, 22, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 11, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 11, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 18, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 28, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0]', 22, 22, 11, 9, 9, 11, 18, 28, 7);
INSERT INTO ip (factory, year, patents, inv_patents, inv_applications, utility_patents, design_patents, granted_patents, software_copyrights, trademarks, new_patents, patents_total, inv_patents_total, inv_applications_total, utility_patents_total, design_patents_total, granted_patents_total, software_copyrights_total, trademarks_total) VALUES ('安徽光大美科', 2024, '[0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0]', 7, 7, 8, 10, 10, 2, 4, 4, 3);
INSERT INTO ip (factory, year, patents, inv_patents, inv_applications, utility_patents, design_patents, granted_patents, software_copyrights, trademarks, new_patents, patents_total, inv_patents_total, inv_applications_total, utility_patents_total, design_patents_total, granted_patents_total, software_copyrights_total, trademarks_total) VALUES ('安徽光大同创', 2025, '[12, 6, 0, 0, 13, 29, 14, 0, 18, 0, 0, 0]', '[9, 7, 0, 0, 9, 7, 5, 0, 10, 0, 0, 0]', '[10, 6, 0, 0, 15, 13, 8, 0, 14, 0, 0, 0]', '[3, 0, 0, 0, 9, 0, 6, 0, 13, 0, 0, 0]', '[0, 0, 0, 0, 4, 0, 0, 0, 10, 0, 0, 0]', '[0, 0, 0, 0, 3, 0, 0, 0, 9, 0, 0, 0]', '[0, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0]', '[0, 0, 0, 0, 6, 0, 0, 0, 7, 0, 0, 0]', 92, 92, 47, 66, 31, 14, 12, 4, 13);


CREATE TABLE labor_qualitative (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	indicator VARCHAR(200) NOT NULL, 
	current_text VARCHAR(4000), 
	comparison_text VARCHAR(1000), 
	reason VARCHAR(2000), 
	CONSTRAINT labor_qualitative_pkey PRIMARY KEY (factory, year, indicator)
);

INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '行业员工流失率', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '光大同创的员工流失率与行业流失率的对比表', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '薪酬管理', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '职业健康安全管理体系', '', '对比24', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '安全生产政策', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '保障职业健康与安全目标', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '保障职业健康与安全目标措施', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '危害识别、风险评估和事故调查', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '职业健康安全事务：工作者的参与、意见征询和沟通', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '工作者职业健康安全培训', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '促进工作者健康', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '员工满意度调查覆盖率/覆盖情况', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '员工满意度项目排名', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '提供给全职员工（不包括临时或兼职员工）的福利', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '员工关爱', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '年度培训计划小时数目标', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '年度培训计划小时数目标达成率（%%）', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '年度培训计划', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '年度培训计划达成率（%%）', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '多元化和机会平等', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '晋升机制', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '歧视事件及采取的纠正行动', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '具有重大童工事件风险的运营点和供应商', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '具有强迫或强制劳动事件重大风险的运营点和供应商', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '民主管理', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '应急管理体系', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '安全应急措施', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '员工满意度调查计划', '今年满意度', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '员工聘用及解雇', '', '对比', '原因分析1');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '员工聘用及解雇', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '行业员工流失率', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '光大同创的员工流失率与行业流失率的对比表', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '薪酬管理', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '职业健康安全管理体系', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '安全生产政策', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '保障职业健康与安全目标', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '保障职业健康与安全目标措施', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '危害识别、风险评估和事故调查', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '职业健康安全事务：工作者的参与、意见征询和沟通', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '工作者职业健康安全培训', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '促进工作者健康', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '员工满意度调查计划', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '员工满意度调查覆盖率/覆盖情况', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '员工满意度项目排名', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '提供给全职员工（不包括临时或兼职员工）的福利', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '员工关爱', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '年度培训计划小时数目标', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '年度培训计划小时数目标达成率（%%）', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '年度培训计划', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '年度培训计划达成率（%%）', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '多元化和机会平等', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '晋升机制', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '歧视事件及采取的纠正行动', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '具有重大童工事件风险的运营点和供应商', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '具有强迫或强制劳动事件重大风险的运营点和供应商', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '民主管理', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '应急管理体系', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '安全应急措施', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '员工聘用及解雇', '', '', '一样');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '行业员工流失率', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '光大同创的员工流失率与行业流失率的对比表', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '薪酬管理', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '职业健康安全管理体系', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '安全生产政策', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '保障职业健康与安全目标', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '保障职业健康与安全目标措施', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '危害识别、风险评估和事故调查', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '职业健康安全事务：工作者的参与、意见征询和沟通', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '工作者职业健康安全培训', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '促进工作者健康', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '员工满意度调查计划', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '员工满意度调查覆盖率/覆盖情况', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '员工满意度项目排名', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '提供给全职员工（不包括临时或兼职员工）的福利', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '员工关爱', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '年度培训计划小时数目标', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '年度培训计划小时数目标达成率（%%）', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '年度培训计划', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '年度培训计划达成率（%%）', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '多元化和机会平等', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '晋升机制', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '歧视事件及采取的纠正行动', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '具有重大童工事件风险的运营点和供应商', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '具有强迫或强制劳动事件重大风险的运营点和供应商', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '民主管理', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '应急管理体系', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '安全应急措施', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '薪酬管理', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '职业健康安全管理体系', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '安全生产政策', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '保障职业健康与安全目标', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '保障职业健康与安全目标措施', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '危害识别、风险评估和事故调查', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '职业健康安全事务：工作者的参与、意见征询和沟通', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '工作者职业健康安全培训', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '促进工作者健康', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '员工满意度调查计划', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '员工满意度调查覆盖率/覆盖情况', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '员工满意度项目排名', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '提供给全职员工（不包括临时或兼职员工）的福利', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '员工关爱', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '年度培训计划小时数目标', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '年度培训计划小时数目标达成率（%%）', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '年度培训计划', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '年度培训计划达成率（%%）', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '多元化和机会平等', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '晋升机制', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '歧视事件及采取的纠正行动', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '具有重大童工事件风险的运营点和供应商', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '具有强迫或强制劳动事件重大风险的运营点和供应商', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '民主管理', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '应急管理体系', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '安全应急措施', '', '', '');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '行业员工流失率', '', 'duibi', '原因1');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '光大同创的员工流失率与行业流失率的对比表', '', '', '原因2');
INSERT INTO labor_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '员工聘用及解雇', '', '对比', 'yyfx');


CREATE TABLE labor_reasons (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	indicator VARCHAR(200) NOT NULL, 
	reason VARCHAR(2000), 
	CONSTRAINT labor_reasons_pkey PRIMARY KEY (factory, year, indicator)
);

INSERT INTO labor_reasons (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'employment_total_employees', '25原因分析');
INSERT INTO labor_reasons (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'employment_gender_male', '男性');
INSERT INTO labor_reasons (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'training_total', '受训');
INSERT INTO labor_reasons (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'ohs_training_count_total', '25培训');
INSERT INTO labor_reasons (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'satisfaction_annual_average', '加油');
INSERT INTO labor_reasons (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'employment_full_time', '全职');
INSERT INTO labor_reasons (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'employment_part_time', '兼职（人');
INSERT INTO labor_reasons (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'employment_gender_female', '女');
INSERT INTO labor_reasons (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'employment_category_management', '管理');
INSERT INTO labor_reasons (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'employment_category_middle', '中');
INSERT INTO labor_reasons (factory, year, indicator, reason) VALUES ('安徽光大美科', 2021, 'employment_total_employees', '原因');
INSERT INTO labor_reasons (factory, year, indicator, reason) VALUES ('安徽光大美科', 2020, 'employment_total_employees', '一样');
INSERT INTO labor_reasons (factory, year, indicator, reason) VALUES ('昆山二', 2025, 'employment_total_employees', '原因');
INSERT INTO labor_reasons (factory, year, indicator, reason) VALUES ('安徽光大美科', 2024, 'employment_total_employees', '原因分析');
INSERT INTO labor_reasons (factory, year, indicator, reason) VALUES ('安徽光大美科', 2020, 'employment_full_time', '原因');
INSERT INTO labor_reasons (factory, year, indicator, reason) VALUES ('安徽光大美科', 2020, 'employment_part_time', '原因');


CREATE TABLE management (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	national_green_factory JSON NOT NULL, 
	provincial_green_factory JSON NOT NULL, 
	environmental_penalty_intensity JSON NOT NULL, 
	environmental_penalty_amount JSON NOT NULL, 
	environmental_violation JSON NOT NULL, 
	CONSTRAINT management_pkey PRIMARY KEY (factory, year)
);

INSERT INTO management (factory, year, national_green_factory, provincial_green_factory, environmental_penalty_intensity, environmental_penalty_amount, environmental_violation) VALUES ('安徽光大美科', 2024, '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 20.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]');
INSERT INTO management (factory, year, national_green_factory, provincial_green_factory, environmental_penalty_intensity, environmental_penalty_amount, environmental_violation) VALUES ('安徽光大美科', 2025, '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 11.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.3, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.2, 0.0, 0.0, 0.0]', '[0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0]');


CREATE TABLE material (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	renewable_input JSON NOT NULL, 
	non_renewable_input JSON NOT NULL, 
	renewable_output JSON NOT NULL, 
	non_renewable_output JSON NOT NULL, 
	material_consumption JSON NOT NULL, 
	wood_fiber JSON NOT NULL, 
	aluminum JSON NOT NULL, 
	packaging_material JSON NOT NULL, 
	paper_consumption JSON NOT NULL, 
	total_revenue DOUBLE PRECISION NOT NULL, 
	packaging_intensity DOUBLE PRECISION NOT NULL, 
	paper_intensity DOUBLE PRECISION NOT NULL, 
	total_input DOUBLE PRECISION NOT NULL, 
	total_output DOUBLE PRECISION NOT NULL, 
	renewable_input_ratio DOUBLE PRECISION NOT NULL, 
	renewable_output_ratio DOUBLE PRECISION NOT NULL, 
	CONSTRAINT material_pkey PRIMARY KEY (factory, year)
);

INSERT INTO material (factory, year, renewable_input, non_renewable_input, renewable_output, non_renewable_output, material_consumption, wood_fiber, aluminum, packaging_material, paper_consumption, total_revenue, packaging_intensity, paper_intensity, total_input, total_output, renewable_input_ratio, renewable_output_ratio) VALUES ('安徽光大美科', 2021, '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', 0.0, 0.0, 0.0, 0.0, 0.5, 0.0, 100.0);
INSERT INTO material (factory, year, renewable_input, non_renewable_input, renewable_output, non_renewable_output, material_consumption, wood_fiber, aluminum, packaging_material, paper_consumption, total_revenue, packaging_intensity, paper_intensity, total_input, total_output, renewable_input_ratio, renewable_output_ratio) VALUES ('昆山二', 2022, '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 1.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', 0.0, 0.0, 0.0, 1.1, 0.0, 0.0, 0.0);
INSERT INTO material (factory, year, renewable_input, non_renewable_input, renewable_output, non_renewable_output, material_consumption, wood_fiber, aluminum, packaging_material, paper_consumption, total_revenue, packaging_intensity, paper_intensity, total_input, total_output, renewable_input_ratio, renewable_output_ratio) VALUES ('安徽光大同创', 2025, '[1, 0, 0.24, 0, 0.16, 0, 0, 0, 1, 2, 0, 0]', '[0.15, 0, 0.07, 0, 0.24, 0.21, 0, 0, 0, 0, 0, 0]', '[0.3, 0, 0.16, 0, 0, 0.2, 0, 0, 0.3, 0, 0, 0]', '[0, 0, 0, 0, 0, 0.15, 0, 0, 0, 0, 0, 0]', '[0, 0, 0.07, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0.06, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', 0.0, 0.0, 0.0, 0.0, 0.3, 0.0, 100.0);
INSERT INTO material (factory, year, renewable_input, non_renewable_input, renewable_output, non_renewable_output, material_consumption, wood_fiber, aluminum, packaging_material, paper_consumption, total_revenue, packaging_intensity, paper_intensity, total_input, total_output, renewable_input_ratio, renewable_output_ratio) VALUES ('安徽光大美科', 2024, '[32, 0.0, 0.0, 12, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', 0.0, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0);
INSERT INTO material (factory, year, renewable_input, non_renewable_input, renewable_output, non_renewable_output, material_consumption, wood_fiber, aluminum, packaging_material, paper_consumption, total_revenue, packaging_intensity, paper_intensity, total_input, total_output, renewable_input_ratio, renewable_output_ratio) VALUES ('安徽光大美科', 2025, '[0.0, 0.0, 0.0, 0.8, 0.0, 0.0, 0.0, 0.0, 1.2, 0.0, 0.0, 0.0]', '[2.2, 1.0, 0.0, 2.2, 0.0, 0.0, 0.0, 0.0, 1.4, 0.0, 0.0, 0.0]', '[0.7, 0.6, 0.8, 0.3, 0.0, 0.0, 0.0, 0.0, 0.1, 0.0, 0.0, 0.0]', '[0.0, 1.0, 0.6, 0.7, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[1.5, 2.6, 0.0, 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 1.0, 0.8, 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 2.4, 0.8, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 2.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', 0.0, 0.0, 0.0, 8.8, 4.8, 22.73, 52.08);
INSERT INTO material (factory, year, renewable_input, non_renewable_input, renewable_output, non_renewable_output, material_consumption, wood_fiber, aluminum, packaging_material, paper_consumption, total_revenue, packaging_intensity, paper_intensity, total_input, total_output, renewable_input_ratio, renewable_output_ratio) VALUES ('安徽光大美科', 2023, '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);


CREATE TABLE messages (
	id SERIAL NOT NULL, 
	type VARCHAR(30) NOT NULL, 
	title VARCHAR(30) NOT NULL, 
	content TEXT, 
	sender_role VARCHAR(20) NOT NULL, 
	sender_factory VARCHAR(50), 
	sender_department VARCHAR(50), 
	receiver_role VARCHAR(20) NOT NULL, 
	receiver_factory VARCHAR(50), 
	receiver_department VARCHAR(50), 
	created_at TIMESTAMP WITHOUT TIME ZONE, 
	is_read BOOLEAN NOT NULL, 
	CONSTRAINT messages_pkey PRIMARY KEY (id)
);

INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大美科2025年9月的物料数据', '安徽环境组于2025-09-20 05:46:44提交了安徽光大美科2025年9月的物料数据，请工厂及时审核。', 'department', '安徽光大美科', 'material', 'factory', '安徽光大美科', NULL, '2025-09-20 05:46:44.541819', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('审核', '审核通过了安徽光大美科2025年9月的物料数据', '陈世有于2025-09-20 06:18:29审核通过了安徽光大美科2025年9月的物料数据', 'factory', NULL, NULL, 'factory', '安徽光大美科', NULL, '2025-09-20 06:18:29.107122', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年5月的物料数据', '安徽环境组于2025-10-27 13:25:26提交了安徽光大同创2025年5月的物料数据，请工厂及时审核。', 'department', '安徽光大同创', 'material', 'factory', '安徽光大同创', NULL, '2025-10-27 13:25:26.103241', true);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年6月的物料数据', '安徽环境组于2025-10-27 13:26:02提交了安徽光大同创2025年6月的物料数据，请工厂及时审核。', 'department', '安徽光大同创', 'material', 'factory', '安徽光大同创', NULL, '2025-10-27 13:26:02.981389', true);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('审核', '驳回了安徽光大美科2025年9月的物料数据', '光大同创总部于2025-09-20 07:04:00驳回了安徽光大美科2025年9月的物料数据', 'headquarter', NULL, NULL, 'factory', '安徽光大美科', NULL, '2025-09-20 07:04:00.364208', true);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('审核', '驳回了安徽光大美科2025年9月的物料数据', '光大同创总部于2025-09-20 07:04:00驳回了安徽光大美科2025年9月的物料数据', 'headquarter', NULL, NULL, 'department', '安徽光大美科', 'material', '2025-09-20 07:04:00.386820', true);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大美科2025年9月的物料数据', '安徽环境组于2025-09-20 07:05:32提交了安徽光大美科2025年9月的物料数据，请工厂及时审核。', 'department', '安徽光大美科', 'material', 'factory', '安徽光大美科', NULL, '2025-09-20 07:05:32.023924', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大美科2025年9月的物料数据', '安徽环境组于2025-09-20 07:24:28提交了安徽光大美科2025年9月的物料数据，请工厂及时审核。', 'department', '安徽光大美科', 'material', 'factory', '安徽光大美科', NULL, '2025-09-20 07:24:28.127094', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('审核', '审核通过了安徽光大美科2025年9月的物料数据', '陈世有于2025-09-20 07:24:44审核通过了安徽光大美科2025年9月的物料数据，请悉知。', 'factory', NULL, NULL, 'department', '安徽光大美科', 'material', '2025-09-20 07:24:44.076642', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('审核', '审核通过了安徽光大美科2025年9月的物料数据', '管理员于2025-09-20 07:24:59审核通过了安徽光大美科2025年9月的物料数据', 'admin', NULL, NULL, 'factory', '安徽光大美科', NULL, '2025-09-20 07:24:59.254540', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('审核', '审核通过了安徽光大美科2025年9月的物料数据', '管理员于2025-09-20 07:24:59审核通过了安徽光大美科2025年9月的物料数据', 'admin', NULL, NULL, 'department', '安徽光大美科', 'material', '2025-09-20 07:24:59.260090', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('审核', '审核通过了安徽光大美科2025年9月的物料数据', '陈世有于2025-09-20 07:24:44审核通过了安徽光大美科2025年9月的物料数据，请总部审核。', 'factory', NULL, NULL, 'headquarter', NULL, NULL, '2025-09-20 07:24:44.082137', true);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('审核', '审核通过了安徽光大美科2025年的环境定量数据', '陈世有于2025-09-20 15:36:49审核通过了安徽光大美科2025年的环境定量数据', 'factory', NULL, NULL, 'factory', '安徽光大美科', NULL, '2025-09-20 15:36:49.426821', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大美科2025年1月的物料数据', '安徽环境组于2025-09-20 17:39:16提交了安徽光大美科2025年1月的物料数据，请工厂及时审核。', 'department', '安徽光大美科', 'material', 'factory', '安徽光大美科', NULL, '2025-09-20 17:39:16.915785', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大美科2025年2月的物料数据', '安徽环境组于2025-09-20 17:39:25提交了安徽光大美科2025年2月的物料数据，请工厂及时审核。', 'department', '安徽光大美科', 'material', 'factory', '安徽光大美科', NULL, '2025-09-20 17:39:25.865084', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('审核', '驳回了安徽光大美科2025年1月的物料数据', '陈世有于2025-09-20 17:45:07驳回了安徽光大美科2025年1月的物料数据，请悉知。', 'factory', NULL, NULL, 'department', '安徽光大美科', 'material', '2025-09-20 17:45:07.489544', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('审核', '驳回了安徽光大美科2025年2月的物料数据', '管理员于2025-09-22 04:06:33驳回了安徽光大美科2025年2月的物料数据', 'admin', NULL, NULL, 'factory', '安徽光大美科', NULL, '2025-09-22 04:06:33.192050', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('审核', '驳回了安徽光大美科2025年2月的物料数据', '管理员于2025-09-22 04:06:33驳回了安徽光大美科2025年2月的物料数据', 'admin', NULL, NULL, 'department', '安徽光大美科', 'material', '2025-09-22 04:06:33.250916', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年2月的水资源数据', '安徽环境组于2025-09-24 02:46:13提交了安徽光大同创2025年2月的水资源数据，请工厂及时审核。', 'department', '安徽光大同创', 'water', 'factory', '安徽光大同创', NULL, '2025-09-24 02:46:13.420640', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年1月的水资源数据', '安徽环境组于2025-09-24 02:46:17提交了安徽光大同创2025年1月的水资源数据，请工厂及时审核。', 'department', '安徽光大同创', 'water', 'factory', '安徽光大同创', NULL, '2025-09-24 02:46:17.025909', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年3月的水资源数据', '安徽环境组于2025-09-24 02:46:21提交了安徽光大同创2025年3月的水资源数据，请工厂及时审核。', 'department', '安徽光大同创', 'water', 'factory', '安徽光大同创', NULL, '2025-09-24 02:46:21.040681', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年9月的水资源数据', '安徽环境组于2025-09-24 02:46:29提交了安徽光大同创2025年9月的水资源数据，请工厂及时审核。', 'department', '安徽光大同创', 'water', 'factory', '安徽光大同创', NULL, '2025-09-24 02:46:29.718078', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年2月的知识产权数据', '安徽环境组于2025-09-24 02:46:48提交了安徽光大同创2025年2月的知识产权数据，请工厂及时审核。', 'department', '安徽光大同创', 'ip', 'factory', '安徽光大同创', NULL, '2025-09-24 02:46:48.073954', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年1月的知识产权数据', '安徽环境组于2025-09-24 02:46:58提交了安徽光大同创2025年1月的知识产权数据，请工厂及时审核。', 'department', '安徽光大同创', 'ip', 'factory', '安徽光大同创', NULL, '2025-09-24 02:46:58.686868', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年6月的知识产权数据', '安徽环境组于2025-09-24 02:47:12提交了安徽光大同创2025年6月的知识产权数据，请工厂及时审核。', 'department', '安徽光大同创', 'ip', 'factory', '安徽光大同创', NULL, '2025-09-24 02:47:12.527561', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年5月的知识产权数据', '安徽环境组于2025-09-24 02:47:38提交了安徽光大同创2025年5月的知识产权数据，请工厂及时审核。', 'department', '安徽光大同创', 'ip', 'factory', '安徽光大同创', NULL, '2025-09-24 02:47:38.491303', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年5月的社区参与与志愿活动数据', '安徽环境组于2025-09-24 02:47:51提交了安徽光大同创2025年5月的社区参与与志愿活动数据，请工厂及时审核。', 'department', '安徽光大同创', 'community', 'factory', '安徽光大同创', NULL, '2025-09-24 02:47:51.422104', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年3月的社区参与与志愿活动数据', '安徽环境组于2025-09-24 02:48:02提交了安徽光大同创2025年3月的社区参与与志愿活动数据，请工厂及时审核。', 'department', '安徽光大同创', 'community', 'factory', '安徽光大同创', NULL, '2025-09-24 02:48:02.983039', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年9月的教育与培训数据', '安徽环境组于2025-09-24 02:48:53提交了安徽光大同创2025年9月的教育与培训数据，请工厂及时审核。', 'department', '安徽光大同创', 'training', 'factory', '安徽光大同创', NULL, '2025-09-24 02:48:53.343295', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年3月的教育与培训数据', '安徽环境组于2025-09-24 02:49:01提交了安徽光大同创2025年3月的教育与培训数据，请工厂及时审核。', 'department', '安徽光大同创', 'training', 'factory', '安徽光大同创', NULL, '2025-09-24 02:49:01.985474', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年3月的知识产权数据', '安徽环境组于2025-09-24 02:49:15提交了安徽光大同创2025年3月的知识产权数据，请工厂及时审核。', 'department', '安徽光大同创', 'ip', 'factory', '安徽光大同创', NULL, '2025-09-24 02:49:15.525041', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年7月的知识产权数据', '安徽环境组于2025-09-24 02:49:31提交了安徽光大同创2025年7月的知识产权数据，请工厂及时审核。', 'department', '安徽光大同创', 'ip', 'factory', '安徽光大同创', NULL, '2025-09-24 02:49:31.040195', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('审核', '审核通过了安徽光大同创2025年7月的知识产权数据', '管理员于2025-10-16 19:56:43审核通过了安徽光大同创2025年7月的知识产权数据', 'admin', NULL, NULL, 'factory', '安徽光大同创', NULL, '2025-10-16 19:56:43.935044', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年10月的物料数据', '安徽环境组于2025-10-17 23:49:56提交了安徽光大同创2025年10月的物料数据，请工厂及时审核。', 'department', '安徽光大同创', 'material', 'factory', '安徽光大同创', NULL, '2025-10-17 23:49:56.201147', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年1月的物料数据', '安徽环境组于2025-10-18 00:07:00提交了安徽光大同创2025年1月的物料数据，请工厂及时审核。', 'department', '安徽光大同创', 'material', 'factory', '安徽光大同创', NULL, '2025-10-18 00:07:00.635193', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('审核', '审核通过了安徽光大美科2025年1月的物料数据', '光大同创总部于2025-10-18 00:08:06审核通过了安徽光大美科2025年1月的物料数据', 'headquarter', NULL, NULL, 'factory', '安徽光大美科', NULL, '2025-10-18 00:08:06.925772', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('审核', '审核通过了安徽光大美科2025年1月的物料数据', '光大同创总部于2025-10-18 00:08:06审核通过了安徽光大美科2025年1月的物料数据', 'headquarter', NULL, NULL, 'department', '安徽光大美科', 'material', '2025-10-18 00:08:06.930846', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('年报', '提交了安徽光大美科工厂2025年的环境定量数据', '陈世有于2025-09-20 15:36:43提交了安徽光大美科工厂2025年的环境定量数据，请管理员和总部及时审核。', 'factory', '安徽光大美科', NULL, 'headquarter', NULL, NULL, '2025-09-20 15:36:43.960627', true);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年3月的物料数据', '安徽环境组于2025-10-22 12:10:52提交了安徽光大同创2025年3月的物料数据，请工厂及时审核。', 'department', '安徽光大同创', 'material', 'factory', '安徽光大同创', NULL, '2025-10-22 12:10:52.915399', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('年报', '提交了安徽光大美科2024年的定性数据', '陈世有于2025-10-25 01:08:51提交了安徽光大美科2024年的定性数据，请总部及时审核。', 'factory', '安徽光大美科', NULL, 'headquarter', NULL, NULL, '2025-10-25 01:08:51.509904', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年10月的物料数据', '安徽环境组于2025-10-25 01:13:25提交了安徽光大同创2025年10月的物料数据，请工厂及时审核。', 'department', '安徽光大同创', 'material', 'factory', '安徽光大同创', NULL, '2025-10-25 01:13:25.078920', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年3月的物料数据', '安徽环境组于2025-10-25 01:13:35提交了安徽光大同创2025年3月的物料数据，请工厂及时审核。', 'department', '安徽光大同创', 'material', 'factory', '安徽光大同创', NULL, '2025-10-25 01:13:35.582899', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年1月的物料数据', '安徽环境组于2025-10-25 01:33:16提交了安徽光大同创2025年1月的物料数据，请工厂及时审核。', 'department', '安徽光大同创', 'material', 'factory', '安徽光大同创', NULL, '2025-10-25 01:33:16.091028', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年2月的物料数据', '安徽环境组于2025-10-25 01:33:25提交了安徽光大同创2025年2月的物料数据，请工厂及时审核。', 'department', '安徽光大同创', 'material', 'factory', '安徽光大同创', NULL, '2025-10-25 01:33:25.019282', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年4月的物料数据', '安徽环境组于2025-10-25 01:36:35提交了安徽光大同创2025年4月的物料数据，请工厂及时审核。', 'department', '安徽光大同创', 'material', 'factory', '安徽光大同创', NULL, '2025-10-25 01:36:35.074208', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年10月的能源数据', '安徽环境组于2025-10-25 01:38:02提交了安徽光大同创2025年10月的能源数据，请工厂及时审核。', 'department', '安徽光大同创', 'energy', 'factory', '安徽光大同创', NULL, '2025-10-25 01:38:02.370918', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年1月的能源数据', '安徽环境组于2025-10-25 01:38:36提交了安徽光大同创2025年1月的能源数据，请工厂及时审核。', 'department', '安徽光大同创', 'energy', 'factory', '安徽光大同创', NULL, '2025-10-25 01:38:36.615132', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年2月的能源数据', '安徽环境组于2025-10-25 01:38:48提交了安徽光大同创2025年2月的能源数据，请工厂及时审核。', 'department', '安徽光大同创', 'energy', 'factory', '安徽光大同创', NULL, '2025-10-25 01:38:48.766388', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年5月的物料数据', '安徽环境组于2025-10-25 01:40:29提交了安徽光大同创2025年5月的物料数据，请工厂及时审核。', 'department', '安徽光大同创', 'material', 'factory', '安徽光大同创', NULL, '2025-10-25 01:40:29.797519', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年6月的物料数据', '安徽环境组于2025-10-25 01:40:33提交了安徽光大同创2025年6月的物料数据，请工厂及时审核。', 'department', '安徽光大同创', 'material', 'factory', '安徽光大同创', NULL, '2025-10-25 01:40:33.441962', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年7月的物料数据', '安徽环境组于2025-10-25 01:40:36提交了安徽光大同创2025年7月的物料数据，请工厂及时审核。', 'department', '安徽光大同创', 'material', 'factory', '安徽光大同创', NULL, '2025-10-25 01:40:36.755638', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年8月的物料数据', '安徽环境组于2025-10-25 01:40:40提交了安徽光大同创2025年8月的物料数据，请工厂及时审核。', 'department', '安徽光大同创', 'material', 'factory', '安徽光大同创', NULL, '2025-10-25 01:40:40.421344', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年9月的物料数据', '安徽环境组于2025-10-25 01:40:43提交了安徽光大同创2025年9月的物料数据，请工厂及时审核。', 'department', '安徽光大同创', 'material', 'factory', '安徽光大同创', NULL, '2025-10-25 01:40:43.149613', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年11月的物料数据', '安徽环境组于2025-10-25 01:40:47提交了安徽光大同创2025年11月的物料数据，请工厂及时审核。', 'department', '安徽光大同创', 'material', 'factory', '安徽光大同创', NULL, '2025-10-25 01:40:47.461938', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年3月的能源数据', '安徽环境组于2025-10-25 01:41:05提交了安徽光大同创2025年3月的能源数据，请工厂及时审核。', 'department', '安徽光大同创', 'energy', 'factory', '安徽光大同创', NULL, '2025-10-25 01:41:05.574785', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年4月的能源数据', '安徽环境组于2025-10-25 01:41:07提交了安徽光大同创2025年4月的能源数据，请工厂及时审核。', 'department', '安徽光大同创', 'energy', 'factory', '安徽光大同创', NULL, '2025-10-25 01:41:07.918953', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年5月的能源数据', '安徽环境组于2025-10-25 01:41:11提交了安徽光大同创2025年5月的能源数据，请工厂及时审核。', 'department', '安徽光大同创', 'energy', 'factory', '安徽光大同创', NULL, '2025-10-25 01:41:11.173953', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年12月的物料数据', '安徽环境组于2025-10-25 01:40:49提交了安徽光大同创2025年12月的物料数据，请工厂及时审核。', 'department', '安徽光大同创', 'material', 'factory', '安徽光大同创', NULL, '2025-10-25 01:40:49.726071', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年6月的能源数据', '安徽环境组于2025-10-25 01:41:21提交了安徽光大同创2025年6月的能源数据，请工厂及时审核。', 'department', '安徽光大同创', 'energy', 'factory', '安徽光大同创', NULL, '2025-10-25 01:41:21.528320', true);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年7月的能源数据', '安徽环境组于2025-10-25 01:41:25提交了安徽光大同创2025年7月的能源数据，请工厂及时审核。', 'department', '安徽光大同创', 'energy', 'factory', '安徽光大同创', NULL, '2025-10-25 01:41:25.380479', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年8月的能源数据', '安徽环境组于2025-10-25 01:41:28提交了安徽光大同创2025年8月的能源数据，请工厂及时审核。', 'department', '安徽光大同创', 'energy', 'factory', '安徽光大同创', NULL, '2025-10-25 01:41:28.567257', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年9月的能源数据', '安徽环境组于2025-10-25 01:41:31提交了安徽光大同创2025年9月的能源数据，请工厂及时审核。', 'department', '安徽光大同创', 'energy', 'factory', '安徽光大同创', NULL, '2025-10-25 01:41:31.312160', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('月报', '提交了安徽光大同创2025年11月的能源数据', '安徽环境组于2025-10-25 01:41:41提交了安徽光大同创2025年11月的能源数据，请工厂及时审核。', 'department', '安徽光大同创', 'energy', 'factory', '安徽光大同创', NULL, '2025-10-25 01:41:41.291157', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ('年报', '提交了安徽光大美科2024年的定性数据', '陈世有于2025-10-25 01:08:51提交了安徽光大美科2024年的定性数据，请总部及时审核。', 'factory', '安徽光大美科', NULL, 'admin', NULL, NULL, '2025-10-25 01:08:51.511293', true);


CREATE TABLE ohs (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	training_count JSON NOT NULL, 
	training_participants JSON NOT NULL, 
	training_hours JSON NOT NULL, 
	injury_count JSON NOT NULL, 
	incident_count JSON NOT NULL, 
	fatality_count JSON NOT NULL, 
	lost_workdays JSON NOT NULL, 
	safety_investment JSON NOT NULL, 
	training_count_total INTEGER, 
	training_participants_total INTEGER, 
	training_hours_total DOUBLE PRECISION, 
	injury_count_total INTEGER, 
	incident_count_total INTEGER, 
	fatality_count_total INTEGER, 
	lost_workdays_total INTEGER, 
	safety_investment_total DOUBLE PRECISION, 
	safety_managers INTEGER, 
	medical_checks INTEGER, 
	coverage_rate DOUBLE PRECISION, 
	emergency_drills INTEGER, 
	hazards_found INTEGER, 
	occupational_checks INTEGER, 
	CONSTRAINT ohs_pkey PRIMARY KEY (factory, year)
);

INSERT INTO ohs (factory, year, training_count, training_participants, training_hours, injury_count, incident_count, fatality_count, lost_workdays, safety_investment, training_count_total, training_participants_total, training_hours_total, injury_count_total, incident_count_total, fatality_count_total, lost_workdays_total, safety_investment_total, safety_managers, medical_checks, coverage_rate, emergency_drills, hazards_found, occupational_checks) VALUES ('安徽光大美科', 2025, '[0.0, 0.0, 35.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 16.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 1.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 9.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', 35, 16, 1.9, 0, 9, 1, 0, 0.0, 0, 0, 0.0, 0, 0, 0);


CREATE TABLE other_qualitative (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	indicator VARCHAR(200) NOT NULL, 
	current_text VARCHAR(4000), 
	comparison_text VARCHAR(1000), 
	reason VARCHAR(2000), 
	CONSTRAINT other_qualitative_pkey PRIMARY KEY (factory, year, indicator)
);

INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '供应商识别', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '绿色供应链', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '供应链多元化政策', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '供应链对环境的负面影响及采取的行动', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '供应链对社会的负面影响及采取的行动', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '供应链环境承诺书签署率', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '供应链环境现场审核完成率', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '供应链环境现场审核改进情况说明', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '供应链环境管理目标', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '维护及保障知识产权有关的惯例', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '客户隐私保护', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '数据安全管理', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '数据安全隐私认证与信披', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '信息安全管理体系认证', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '社区参与', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '利益相关方社区沟通目标计划', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '利益相关方社区沟通目标计划完成率（%%）', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '有当地社区参与、影响评估和发展计划的运营点', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '绿色金融产品', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '数字转型', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '供应商管理体系', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '供应商廉洁要求', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '产品质量与安全机制', '今年产品定性', 'to24', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '供应商廉洁要求', '今年', '', '要求是什么');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '真实公正的信息与合同签订', '今年合同', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '知识产权保护政策', '', 'to24', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '供应商管理体系', '25', '', '25原因分析');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '供应商管理体系', '24年', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '供应商管理目标及措施', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '供应商识别', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '绿色供应链', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '供应链多元化政策', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '供应链对环境的负面影响及采取的行动', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '供应链对社会的负面影响及采取的行动', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '供应链环境承诺书签署率', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '供应链环境现场审核完成率', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '供应链环境现场审核改进情况说明', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '供应链环境管理目标', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '产品质量与安全机制', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '真实公正的信息与合同签订', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '知识产权保护政策', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '维护及保障知识产权有关的惯例', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '客户隐私保护', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '数据安全管理', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '数据安全隐私认证与信披', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '信息安全管理体系认证', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '社区参与', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '利益相关方社区沟通目标计划', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '利益相关方社区沟通目标计划完成率（%%）', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '有当地社区参与、影响评估和发展计划的运营点', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '绿色金融产品', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '数字转型', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2024, '供应商廉洁要求', '24', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2025, '供应商管理目标及措施', '25', '', '25供应商');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '供应商管理体系', '', '', '其他');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '供应商廉洁要求', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '供应商管理目标及措施', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '供应商识别', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '绿色供应链', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '供应链多元化政策', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '供应链对环境的负面影响及采取的行动', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '供应链对社会的负面影响及采取的行动', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '供应链环境承诺书签署率', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '供应链环境现场审核完成率', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '供应链环境现场审核改进情况说明', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '供应链环境管理目标', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '产品质量与安全机制', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '真实公正的信息与合同签订', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '知识产权保护政策', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '维护及保障知识产权有关的惯例', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '客户隐私保护', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '数据安全管理', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '数据安全隐私认证与信披', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '信息安全管理体系认证', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '社区参与', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '利益相关方社区沟通目标计划', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '利益相关方社区沟通目标计划完成率（%%）', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '有当地社区参与、影响评估和发展计划的运营点', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '绿色金融产品', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2021, '数字转型', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '供应商管理目标及措施', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '供应商识别', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '绿色供应链', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '供应链多元化政策', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '供应链对环境的负面影响及采取的行动', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '供应链对社会的负面影响及采取的行动', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '供应链环境承诺书签署率', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '供应链环境现场审核完成率', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '供应链环境现场审核改进情况说明', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '供应链环境管理目标', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '产品质量与安全机制', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '真实公正的信息与合同签订', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '知识产权保护政策', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '维护及保障知识产权有关的惯例', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '客户隐私保护', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '数据安全管理', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '数据安全隐私认证与信披', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '信息安全管理体系认证', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '社区参与', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '利益相关方社区沟通目标计划', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '利益相关方社区沟通目标计划完成率（%%）', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '有当地社区参与、影响评估和发展计划的运营点', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '绿色金融产品', '', '', '');
INSERT INTO other_qualitative (factory, year, indicator, current_text, comparison_text, reason) VALUES ('安徽光大美科', 2020, '数字转型', '', '', '');


CREATE TABLE other_reasons (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	indicator VARCHAR(200) NOT NULL, 
	reason VARCHAR(2000), 
	CONSTRAINT other_reasons_pkey PRIMARY KEY (factory, year, indicator)
);

INSERT INTO other_reasons (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'product_complaints_total', '变少了');
INSERT INTO other_reasons (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'product_handled_total', '加油');
INSERT INTO other_reasons (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'community_charity_donations', '多捐点');
INSERT INTO other_reasons (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'volunteer_volunteer_hours', '太短了');
INSERT INTO other_reasons (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'ipr_patents_total', '变多了');
INSERT INTO other_reasons (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'ipr_utility_patents_total', '翻倍');
INSERT INTO other_reasons (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'community_community_investment', '有点少');
INSERT INTO other_reasons (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'volunteer_volunteer_participants', '还行');
INSERT INTO other_reasons (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'supply_total_suppliers', '供应商总数1');
INSERT INTO other_reasons (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'supply_env_screened', '原因分析');
INSERT INTO other_reasons (factory, year, indicator, reason) VALUES ('安徽光大美科', 2025, 'supply_soc_screened', '原因');
INSERT INTO other_reasons (factory, year, indicator, reason) VALUES ('安徽光大美科', 2020, 'supply_total_suppliers', '原因');
INSERT INTO other_reasons (factory, year, indicator, reason) VALUES ('安徽光大美科', 2020, 'supply_env_screened', '一样');


CREATE TABLE responsibility (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	complaints JSON NOT NULL, 
	handled JSON NOT NULL, 
	quality_issues JSON NOT NULL, 
	recalls JSON NOT NULL, 
	shipments JSON NOT NULL, 
	customer_satisfaction JSON NOT NULL, 
	cyber_incidents JSON NOT NULL, 
	complaints_total INTEGER, 
	handled_total INTEGER, 
	handled_rate DOUBLE PRECISION, 
	customer_satisfaction_average DOUBLE PRECISION, 
	recall_total INTEGER, 
	recall_rate DOUBLE PRECISION, 
	quality_issues_total INTEGER, 
	cyber_incidents_total INTEGER, 
	CONSTRAINT responsibility_pkey PRIMARY KEY (factory, year)
);

INSERT INTO responsibility (factory, year, complaints, handled, quality_issues, recalls, shipments, customer_satisfaction, cyber_incidents, complaints_total, handled_total, handled_rate, customer_satisfaction_average, recall_total, recall_rate, quality_issues_total, cyber_incidents_total) VALUES ('安徽光大美科', 2025, '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 5, 0, 0, 0, 0, 0, 3, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0.0, 0.0, 90.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', 0, 0, 0.0, 7.5, 0, 0.0, 8, 0);


CREATE TABLE review_records (
	id SERIAL NOT NULL, 
	factory VARCHAR(100) NOT NULL, 
	category INTEGER NOT NULL, 
	year INTEGER NOT NULL, 
	month INTEGER, 
	is_submitted BOOLEAN, 
	level1_status VARCHAR(20), 
	level1_comment TEXT, 
	level1_reviewer VARCHAR(50), 
	level1_review_time TIMESTAMP WITHOUT TIME ZONE, 
	level2_status VARCHAR(20), 
	level2_comment TEXT, 
	level2_reviewer VARCHAR(50), 
	level2_review_time TIMESTAMP WITHOUT TIME ZONE, 
	CONSTRAINT review_records_pkey PRIMARY KEY (id)
);

INSERT INTO review_records (factory, category, year, month, is_submitted, level1_status, level1_comment, level1_reviewer, level1_review_time, level2_status, level2_comment, level2_reviewer, level2_review_time) VALUES ('安徽光大同创', 1, 2025, 10, true, 'pending', NULL, NULL, NULL, 'pending', NULL, NULL, NULL);
INSERT INTO review_records (factory, category, year, month, is_submitted, level1_status, level1_comment, level1_reviewer, level1_review_time, level2_status, level2_comment, level2_reviewer, level2_review_time) VALUES ('安徽光大同创', 1, 2025, 3, true, 'pending', NULL, NULL, NULL, 'pending', NULL, NULL, NULL);
INSERT INTO review_records (factory, category, year, month, is_submitted, level1_status, level1_comment, level1_reviewer, level1_review_time, level2_status, level2_comment, level2_reviewer, level2_review_time) VALUES ('安徽光大同创', 1, 2025, 1, true, 'pending', NULL, NULL, NULL, 'pending', NULL, NULL, NULL);
INSERT INTO review_records (factory, category, year, month, is_submitted, level1_status, level1_comment, level1_reviewer, level1_review_time, level2_status, level2_comment, level2_reviewer, level2_review_time) VALUES ('安徽光大同创', 1, 2025, 2, true, 'pending', NULL, NULL, NULL, 'pending', NULL, NULL, NULL);
INSERT INTO review_records (factory, category, year, month, is_submitted, level1_status, level1_comment, level1_reviewer, level1_review_time, level2_status, level2_comment, level2_reviewer, level2_review_time) VALUES ('安徽光大同创', 1, 2025, 4, true, 'pending', NULL, NULL, NULL, 'pending', NULL, NULL, NULL);
INSERT INTO review_records (factory, category, year, month, is_submitted, level1_status, level1_comment, level1_reviewer, level1_review_time, level2_status, level2_comment, level2_reviewer, level2_review_time) VALUES ('安徽光大同创', 2, 2025, 10, true, 'pending', NULL, NULL, NULL, 'pending', NULL, NULL, NULL);
INSERT INTO review_records (factory, category, year, month, is_submitted, level1_status, level1_comment, level1_reviewer, level1_review_time, level2_status, level2_comment, level2_reviewer, level2_review_time) VALUES ('安徽光大同创', 2, 2025, 1, true, 'pending', NULL, NULL, NULL, 'pending', NULL, NULL, NULL);
INSERT INTO review_records (factory, category, year, month, is_submitted, level1_status, level1_comment, level1_reviewer, level1_review_time, level2_status, level2_comment, level2_reviewer, level2_review_time) VALUES ('安徽光大同创', 2, 2025, 2, true, 'pending', NULL, NULL, NULL, 'pending', NULL, NULL, NULL);
INSERT INTO review_records (factory, category, year, month, is_submitted, level1_status, level1_comment, level1_reviewer, level1_review_time, level2_status, level2_comment, level2_reviewer, level2_review_time) VALUES ('安徽光大美科', 17, 2025, NULL, false, NULL, NULL, NULL, NULL, 'pending', NULL, NULL, NULL);
INSERT INTO review_records (factory, category, year, month, is_submitted, level1_status, level1_comment, level1_reviewer, level1_review_time, level2_status, level2_comment, level2_reviewer, level2_review_time) VALUES ('安徽光大美科', 17, 2024, NULL, true, NULL, NULL, NULL, NULL, 'pending', NULL, NULL, NULL);
INSERT INTO review_records (factory, category, year, month, is_submitted, level1_status, level1_comment, level1_reviewer, level1_review_time, level2_status, level2_comment, level2_reviewer, level2_review_time) VALUES ('安徽光大同创', 1, 2025, 5, true, 'pending', NULL, NULL, NULL, 'pending', NULL, NULL, NULL);
INSERT INTO review_records (factory, category, year, month, is_submitted, level1_status, level1_comment, level1_reviewer, level1_review_time, level2_status, level2_comment, level2_reviewer, level2_review_time) VALUES ('安徽光大同创', 1, 2025, 6, true, 'pending', NULL, NULL, NULL, 'pending', NULL, NULL, NULL);
INSERT INTO review_records (factory, category, year, month, is_submitted, level1_status, level1_comment, level1_reviewer, level1_review_time, level2_status, level2_comment, level2_reviewer, level2_review_time) VALUES ('安徽光大同创', 16, 2025, NULL, false, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL);


CREATE TABLE satisfaction (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	satisfaction JSON NOT NULL, 
	annual_average DOUBLE PRECISION, 
	CONSTRAINT satisfaction_pkey PRIMARY KEY (factory, year)
);

INSERT INTO satisfaction (factory, year, satisfaction, annual_average) VALUES ('安徽光大美科', 2025, '[60.0, 0.47, 80.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', 46.82);


CREATE TABLE social_qual_labor (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	indicator VARCHAR(100) NOT NULL, 
	current_text TEXT, 
	comparison_text TEXT, 
	reason TEXT, 
	CONSTRAINT social_qual_labor_pkey PRIMARY KEY (factory, year, indicator)
);


CREATE TABLE social_qual_other (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	indicator VARCHAR(100) NOT NULL, 
	current_text TEXT, 
	comparison_text TEXT, 
	reason TEXT, 
	CONSTRAINT social_qual_other_pkey PRIMARY KEY (factory, year, indicator)
);


CREATE TABLE social_quant_labor (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	indicator VARCHAR(100) NOT NULL, 
	reason TEXT, 
	CONSTRAINT social_quant_labor_pkey PRIMARY KEY (factory, year, indicator)
);


CREATE TABLE social_quant_other (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	indicator VARCHAR(100) NOT NULL, 
	reason TEXT, 
	CONSTRAINT social_quant_other_pkey PRIMARY KEY (factory, year, indicator)
);


CREATE TABLE supply (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	east JSON, 
	south JSON, 
	other JSON, 
	env_screened JSON, 
	soc_screened JSON, 
	local_amount JSON, 
	env_penalty_count JSON, 
	env_penalty_amount JSON, 
	cyber_incidents JSON, 
	CONSTRAINT supply_pkey PRIMARY KEY (factory, year)
);


CREATE TABLE training (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	total JSON, 
	trained JSON, 
	male JSON, 
	female JSON, 
	mgmt JSON, 
	middle JSON, 
	general JSON, 
	hours_total JSON, 
	hours_male JSON, 
	hours_female JSON, 
	hours_mgmt JSON, 
	hours_middle JSON, 
	hours_general JSON, 
	CONSTRAINT training_pkey PRIMARY KEY (factory, year)
);

INSERT INTO training (factory, year, total, trained, male, female, mgmt, middle, general, hours_total, hours_male, hours_female, hours_mgmt, hours_middle, hours_general) VALUES ('安徽光大同创', 2025, '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]', '[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]');


CREATE TABLE users (
	id SERIAL NOT NULL, 
	username VARCHAR(50) NOT NULL, 
	hashed_password VARCHAR(100) NOT NULL, 
	factory VARCHAR(100), 
	departments JSON, 
	role VARCHAR(20) NOT NULL, 
	phone VARCHAR(20), 
	email VARCHAR(50), 
	avatar VARCHAR(60), 
	is_active BOOLEAN DEFAULT true NOT NULL, 
	CONSTRAINT users_pkey1 PRIMARY KEY (id), 
	CONSTRAINT users_username_key UNIQUE NULLS DISTINCT (username)
);

INSERT INTO users (username, hashed_password, factory, departments, role, phone, email, avatar, is_active) VALUES ('陈世有', '$2b$12$ZFWETyp24/u21lZARUvbfej5ZHvZr2oVM5u/T9Qjq0x0usIV3mKQi', '安徽光大同创', NULL, 'factory', '15297790365', 'chensy_1213@qq.com', '/static/avatars/user_3.jpg', true);
INSERT INTO users (username, hashed_password, factory, departments, role, phone, email, avatar, is_active) VALUES ('安徽光大同创', '$2b$12$M2RDl5WbaKsvjiU0tBWLuev1s9pjulrL2I8DUf68wQ0iZkFZIDntC', '安徽光大同创', NULL, 'factory', '120', 'csy@qq.com', '/static/avatars/user_35.png', true);
INSERT INTO users (username, hashed_password, factory, departments, role, phone, email, avatar, is_active) VALUES ('管理员', '$2b$12$/u6SzCo4X.yoU8WErKtlU.vn18YKp7kmVNAsaBweSqfStlxgt80ta', NULL, NULL, 'admin', NULL, '2172449563@qq.com', '/static/avatars/user_1.jpg', true);
INSERT INTO users (username, hashed_password, factory, departments, role, phone, email, avatar, is_active) VALUES ('安徽环境组2', '$2b$12$/upBRdnX1SLn7TQX/boiDu72n6in3xhFwB5P2w0sSLplXkCYWFZHC', '安徽光大同创', '{"name": "研发部", "ids": [9, 10, 11, 1, 2]}', 'department', '120', 'csy@qq.com', NULL, true);
INSERT INTO users (username, hashed_password, factory, departments, role, phone, email, avatar, is_active) VALUES ('越南分工厂', '$2b$12$Q/b09qy/8OYHKNas/045ceQYT43exKORvDYaBYBpwUxsLLZuWVX06', NULL, NULL, 'factory', '1455563243', '', NULL, true);
INSERT INTO users (username, hashed_password, factory, departments, role, phone, email, avatar, is_active) VALUES ('深圳环境', '$2b$12$8159ZX5hTOLjwa6Rp2aGjeGLxnFPURpAKgZRTGkG.MOTgqBAg5KWa', '深圳光大', NULL, 'factory', '1455563243', '', NULL, true);
INSERT INTO users (username, hashed_password, factory, departments, role, phone, email, avatar, is_active) VALUES ('光大同创总部', '$2b$12$AxkJ58D9XtYAUIF0Pib/Hu1aducKgOqDO2csTHdW1vACUdrcJuB4e', NULL, NULL, 'headquarter', '15297790365', 'chensy_1213@qq.com', '/static/avatars/user_2.png', true);
INSERT INTO users (username, hashed_password, factory, departments, role, phone, email, avatar, is_active) VALUES ('陈世有333', '$2b$12$FyWh74hcWq4LpqrnDkohMu268PgcbnchEds0QRFi5WbkeriT7s.rq', '安徽光大美科', NULL, 'factory', '15297790365', 'chensy@qq.com', NULL, true);
INSERT INTO users (username, hashed_password, factory, departments, role, phone, email, avatar, is_active) VALUES ('社会定量', '$2b$12$etDPjiX/4a8VWcyN7l68QOI7IMPaBnkGeMjmmH3AhqrPnSWkounVK', '沃普智选', NULL, 'factory', '15297790365', 'chensy_1213@qq.com', NULL, true);
INSERT INTO users (username, hashed_password, factory, departments, role, phone, email, avatar, is_active) VALUES ('安徽治理', '$2b$12$DB6xFUvFdq5WC5K4.nNEOOgDykBjdc3GlESfKbINE4P1zZnTVt8aW', '安徽光大同创', '{"name": "财务部", "ids": [15]}', 'department', '911', '', '/static/avatars/default-avatar.jpg', true);
INSERT INTO users (username, hashed_password, factory, departments, role, phone, email, avatar, is_active) VALUES ('安徽环境组', '$2b$12$IyoG0c0Xbf7T6nFWtPBBVuRKCrOUMMjrOvLyE.bBOC6SA/eYOrB1K', '安徽光大同创', '{"name": "环境管理部", "ids": [1, 2, 3, 4, 5, 6, 7]}', 'department', '120', 'csy@qq.com', '/static/avatars/user_5.png', true);


CREATE TABLE waste (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	epe JSON NOT NULL, 
	plastic_paper JSON NOT NULL, 
	domestic_industrial JSON NOT NULL, 
	hazardous JSON NOT NULL, 
	wastewater JSON NOT NULL, 
	non_hazardous_total DOUBLE PRECISION NOT NULL, 
	recyclable_total DOUBLE PRECISION NOT NULL, 
	total_waste DOUBLE PRECISION NOT NULL, 
	disposal_required_total DOUBLE PRECISION NOT NULL, 
	recycle_rate DOUBLE PRECISION NOT NULL, 
	total_revenue DOUBLE PRECISION NOT NULL, 
	protective_reuse_rate DOUBLE PRECISION NOT NULL, 
	exceed_events INTEGER NOT NULL, 
	hazardous_intensity DOUBLE PRECISION NOT NULL, 
	wastewater_intensity DOUBLE PRECISION NOT NULL, 
	CONSTRAINT waste_pkey PRIMARY KEY (factory)
);

INSERT INTO waste (factory, year, epe, plastic_paper, domestic_industrial, hazardous, wastewater, non_hazardous_total, recyclable_total, total_waste, disposal_required_total, recycle_rate, total_revenue, protective_reuse_rate, exceed_events, hazardous_intensity, wastewater_intensity) VALUES ('安徽光大美科', 2025, '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.16, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.49, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.06, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.21, 0.0, 0.0, 0.0, 0.0]', 0.9, 0.65, 0.96, 0.31, 67.71, 0.0, 0.0, 0, 0.0, 0.0);


CREATE TABLE water (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	industrial JSON NOT NULL, 
	domestic JSON NOT NULL, 
	reclaimed JSON NOT NULL, 
	total JSON NOT NULL, 
	industrial_total DOUBLE PRECISION NOT NULL, 
	industrial_drainage DOUBLE PRECISION NOT NULL, 
	industrial_consumption DOUBLE PRECISION NOT NULL, 
	industrial_recycled DOUBLE PRECISION NOT NULL, 
	domestic_total DOUBLE PRECISION NOT NULL, 
	domestic_drainage DOUBLE PRECISION NOT NULL, 
	domestic_consumption DOUBLE PRECISION NOT NULL, 
	domestic_recycled DOUBLE PRECISION NOT NULL, 
	reclaimed_total DOUBLE PRECISION NOT NULL, 
	total_revenue DOUBLE PRECISION NOT NULL, 
	reclaimed_intensity DOUBLE PRECISION NOT NULL, 
	total_intake DOUBLE PRECISION NOT NULL, 
	total_drainage DOUBLE PRECISION NOT NULL, 
	total_consumption DOUBLE PRECISION NOT NULL, 
	total_recycled DOUBLE PRECISION NOT NULL, 
	water_intensity DOUBLE PRECISION NOT NULL, 
	water_recycle_rate DOUBLE PRECISION NOT NULL, 
	CONSTRAINT water_pkey PRIMARY KEY (factory, year)
);

INSERT INTO water (factory, year, industrial, domestic, reclaimed, total, industrial_total, industrial_drainage, industrial_consumption, industrial_recycled, domestic_total, domestic_drainage, domestic_consumption, domestic_recycled, reclaimed_total, total_revenue, reclaimed_intensity, total_intake, total_drainage, total_consumption, total_recycled, water_intensity, water_recycle_rate) VALUES ('安徽光大美科', 2025, '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
INSERT INTO water (factory, year, industrial, domestic, reclaimed, total, industrial_total, industrial_drainage, industrial_consumption, industrial_recycled, domestic_total, domestic_drainage, domestic_consumption, domestic_recycled, reclaimed_total, total_revenue, reclaimed_intensity, total_intake, total_drainage, total_consumption, total_recycled, water_intensity, water_recycle_rate) VALUES ('安徽光大美科', 2024, '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', 0.0, 0.0, 12.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 12.0, 0.0, 0.0, 0.0);
INSERT INTO water (factory, year, industrial, domestic, reclaimed, total, industrial_total, industrial_drainage, industrial_consumption, industrial_recycled, domestic_total, domestic_drainage, domestic_consumption, domestic_recycled, reclaimed_total, total_revenue, reclaimed_intensity, total_intake, total_drainage, total_consumption, total_recycled, water_intensity, water_recycle_rate) VALUES ('安徽光大同创', 2025, '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]', '[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0]', 10.0, 11.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 10.0, 11.0, 0.0, 0.0, 0.0, 0.0);


CREATE TABLE fields (
	id SERIAL NOT NULL, 
	category INTEGER NOT NULL, 
	set VARCHAR(64) NOT NULL, 
	name_en VARCHAR(64), 
	name_zh VARCHAR(64), 
	step DOUBLE PRECISION, 
	calculation JSON, 
	unit VARCHAR(32), 
	description TEXT, 
	source VARCHAR(32), 
	is_active BOOLEAN DEFAULT true NOT NULL, 
	CONSTRAINT fields_pkey PRIMARY KEY (id), 
	CONSTRAINT fields_category_fkey FOREIGN KEY(category) REFERENCES categories (id)
);

INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (4, '废气排放统计', 'nox_sox_other', '氮氧化物等排放', 0.01, NULL, 'T', '氮氧化物、硫氧化物等其他排放', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (1, '物料进出统计', 'paper_consumption', '纸张消耗量', 0.01, NULL, 'T', '纸张消耗量 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '物料', 'output_total_renewable_material', '出料-可再生料总量', 0.01, NULL, '吨', '报告期内出货料中可再生材料总量', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, '供应商管理', 'supply_chain_negative_environmental_impact_actions', '供应链对环境的负面影响及采取的行动', NULL, NULL, '', '包括以下事项：
开展了环境影响评估的供应商数量；
经确定为具有实际和潜在重大负面环境影响的供应商数量；
经确定的供应链中的实际和潜在重大负面环境影响；
经确定为具有实际和潜在重大负面环境影响，且经评估后同意改进的供应商百分比；
经确定为具有实际和潜在重大负面环境影响，且经评估后决定终止关系的供应商百分比', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, '供应商管理', 'supply_chain_environmental_audit_completion_rate', '供应链环境现场审核完成率', NULL, NULL, '', NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, '供应商管理', 'supplier_management_goals_measures', '供应商管理目标及措施', NULL, NULL, '', '描述促进供应商管理、供应商社会责任意识提升的目标
描述完善供应商选择机制，对供应商开展履约评价等内容', '港交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '水资源', 'water_withdrawal_domestic', '取水量（生活）', 0.01, NULL, '吨', '总取水量，说明取水来源，来自地表、地下或第三方', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, '数字化', 'digital_transformation', '数字转型', NULL, NULL, '', '数字化转型相关实践', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '能源', 'coal_consumption', '煤炭使用量', 0.01, NULL, '吨标准煤', '报告期内使用的煤炭总量', '港交所、GRI、国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '能源', 'energy_consumption_intensity', '能源消耗强度', 0.0001, NULL, '吨标准煤/万元', '报告期内能源使用总量/报告期内营业收入', '港交所、GRI、国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '废弃物', 'hazardous_waste_intensity', '有害废弃物强度', 0.0001, NULL, '吨/万元', '有害废弃物总量/总营收(万元)', '国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (2, '能源统计', 'purchased_power', '外购电量', 1.0, NULL, 'kWh', '外购电量 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (6, '资金投入统计', 'env_invest', '环保投资', 0.01, NULL, '万元', '环保投资 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (5, '废弃物统计', 'epe', 'EPE废弃物', 0.01, NULL, 'T', 'EPE废弃物 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (5, '废弃物统计', 'hazardous', '危险废弃物', 0.01, NULL, 'T', '危险废弃物 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (5, '废弃物统计', 'exceed_events', '超标事件数', 1.0, NULL, '次', '超标事件数', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (5, '废弃物统计', 'plastic_paper', '塑料纸张废弃物', 0.01, NULL, 'T', '塑料纸张废弃物 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (6, '资金投入统计', 'climate_invest', '气候相关投资', 0.01, NULL, '万元', '气候相关投资 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (5, '废弃物统计', 'wastewater', '废水废弃物', 0.01, NULL, 'T', '废水废弃物 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (5, '废弃物统计', 'domestic_industrial', '生活和工业废弃物', 0.01, NULL, 'T', '生活和工业废弃物 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (6, '资金投入统计', 'clean_tech_invest', '清洁技术投资', 0.01, NULL, '万元', '清洁技术投资 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (6, '资金投入统计', 'green_income', '绿色收入', 0.01, NULL, '万元', '绿色收入 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (7, '环境管理统计', 'national_green_factory', '国家级绿色工厂', 1.0, NULL, '个', '国家级绿色工厂 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (7, '环境管理统计', 'provincial_green_factory', '省级绿色工厂', 1.0, NULL, '个', '省级绿色工厂 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, '责任营销', 'truthful_fair_information_contract', '真实公正的信息与合同签订', NULL, NULL, '', '描述公司在产品或服务的宣传过程中，秉承高度责任感，客观、真实的开展营销活动，不夸大其词、隐瞒风险、过度营销。', '港交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (1, '物料进出统计', 'material_consumption', '物料消耗量', 0.01, NULL, 'T', '物料消耗量 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (1, '物料进出统计', 'non_renewable_output', '不可再生出料量', 0.01, NULL, 'T', '不可再生出料量 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (2, '能源统计', 'coal', '煤用量', 0.01, NULL, 'Tce', '煤用量 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (2, '能源统计', 'renewable_power', '再生能源电量', 1.0, NULL, 'kWh', '再生能源电量 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (2, '能源统计', 'diesel', '柴油用量', 0.01, NULL, 'T', '柴油用量 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (2, '能源统计', 'other_energy', '其他能源', 0.01, NULL, 'Tce', '其他能源 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (4, '废气排放统计', 'voc', 'VOC排放', 0.01, NULL, 'T', '挥发性有机物排放', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (4, '温室气体盘查统计', 'category_six', '范畴六排放', 0.01, NULL, 'tCO₂e', '范畴六排放', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (7, '环境管理统计', 'environmental_penalty_intensity', '环境处罚强度', 0.01, NULL, '万元/万元', '环境处罚强度 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (7, '环境管理统计', 'environmental_penalty_amount', '环境处罚金额', 0.01, NULL, '万元', '环境处罚金额 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (7, '环境管理统计', 'environmental_violation', '环境违规次数', 1.0, NULL, '次', '环境违规次数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (9, '教育和培训统计', 'male', '男性受训人次', 1.0, NULL, '人次', '男性受训人次', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (9, '教育和培训统计', 'hours_female', '女性学时', 0.1, NULL, '小时', '女性学时', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (9, '教育和培训统计', 'mgmt', '管理层受训人次', 1.0, NULL, '人次', '管理层受训人次', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (9, '教育和培训统计', 'hours_middle', '中层学时', 0.1, NULL, '小时', '中层学时', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (9, '教育和培训统计', 'hours_total', '培训总学时', 0.1, NULL, '小时', '培训总学时', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (10, '职业健康安全统计', 'training_hours', '培训学时', 0.1, NULL, '小时', '培训学时 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (9, '教育和培训统计', 'general', '普通员工受训人次', 1.0, NULL, '人次', '普通员工受训人次', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (9, '教育和培训统计', 'trained', '受训人数', 1.0, NULL, '人', '受训人数', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (10, '职业健康安全统计', 'lost_workdays', '工伤损失工作日数', 1.0, NULL, '天', '工伤损失工作日数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (10, '职业健康安全统计', 'fatality_count', '工亡人数', 1.0, NULL, '人', '工亡人数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (10, '职业健康安全统计', 'incident_count', '安全事故数量', 1.0, NULL, '次', '安全事故数量 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (9, '教育和培训统计', 'female', '女性受训人次', 1.0, NULL, '人次', '女性受训人次', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (10, '职业健康安全统计', 'training_participants', '培训参与人次', 1.0, NULL, '人次', '培训参与人次 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (9, '教育和培训统计', 'total', '总人数', 1.0, NULL, '人', '总人数', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (9, '教育和培训统计', 'middle', '中层受训人次', 1.0, NULL, '人次', '中层受训人次', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (9, '教育和培训统计', 'hours_male', '男性学时', 0.1, NULL, '小时', '男性学时', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (9, '教育和培训统计', 'hours_mgmt', '管理层学时', 0.1, NULL, '小时', '管理层学时', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (9, '教育和培训统计', 'hours_general', '普通学时', 0.1, NULL, '小时', '普通学时', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (10, '职业健康安全统计', 'injury_count', '工伤数量', 1.0, NULL, '次', '工伤数量 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (10, '职业健康安全统计', 'training_count', '培训次数', 1.0, NULL, '次', '培训次数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (1, '物料进出统计', 'packaging_material', '包装材料消耗量', 0.01, NULL, 'T', '包装材料消耗量 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (3, '水资源统计', 'reclaimed', '再生水', 1.0, NULL, 'm³', '再生水量 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, '供应商管理', 'supply_chain_diversity_policy', '供应链多元化政策', NULL, NULL, '', '为降低供应链断裂风险制定的供应链多元化政策', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, '数据安全与客户隐私保护', 'data_security_management', '数据安全管理', NULL, NULL, '', '保护数据安全而采取的管理措施方针', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, '数据安全与客户隐私保护', 'data_security_privacy_certification_disclosure', '数据安全隐私认证与信披', NULL, NULL, '', '数据安全与隐私方面的制度建设情况', '华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, '供应商管理', 'supplier_management_system', '供应商管理体系', NULL, NULL, '', '描述公司供应商的选取及退出政策、执行状况、监察方法等管理内容', '上交所、港交所、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (3, '水资源统计', 'total', '总用水量', 1.0, NULL, 'm³', '总用水量 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, '绿色金融', 'green_finance_products', '绿色金融产品', NULL, NULL, '', '绿色基金/债券/信贷/投资/保险的开展情况', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '多元化与平等机会', 'promotion_mechanism', '晋升机制', NULL, NULL, NULL, '公司为保障员工职业发展而建立的公平晋升机制与通道', '上交所、港交所、国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '雇佣', 'industry_employee_turnover_rate', '行业员工流失率', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '应急管理', 'emergency_management_system', '应急管理体系', NULL, NULL, NULL, '公司建立的应急管理体系和制度，包括应急管理组织', '港交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '培训', 'annual_training_plan_hours_target_rate', '年度培训计划小时数目标达成率（%%）', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '职业健康与安全', 'hazard_identification_risk_assessment_accident_investigation', '危害识别、风险评估和事故调查', NULL, NULL, NULL, '识别工作相关危害和评估风险的管理流程，以及应用控制层级消除危害并将风险最小化的管理流程', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '雇佣', 'employee_hiring_and_dismissal', '员工聘用及解雇', NULL, NULL, NULL, '员工聘用及解雇的一般标准程序与准则', '上交所、港交所、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (4, '温室气体盘查统计', 'category_one', '范畴一排放', 0.01, NULL, 'tCO₂e', '范畴一排放', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (4, '温室气体盘查统计', 'category_two', '范畴二排放', 0.01, NULL, 'tCO₂e', '范畴二排放', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (2, '能源统计', 'natural_gas', '天然气用量', 0.01, NULL, 'T', '天然气用量 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (3, '水资源统计', 'domestic', '生活用水', 1.0, NULL, 'm³', '生活用水量 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (4, '温室气体盘查统计', 'category_three', '范畴三排放', 0.01, NULL, 'tCO₂e', '范畴三排放', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (3, '水资源统计', 'industrial', '工业用水', 1.0, NULL, 'm³', '工业用水量 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (4, '废气排放统计', 'benzene', '苯排放', 0.01, NULL, 'T', '苯排放', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (2, '能源统计', 'water', '水用量', 1.0, NULL, 'm³', '水用量 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (2, '能源统计', 'gasoline', '汽油用量', 0.01, NULL, 'T', '汽油用量 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '反歧视', 'discrimination_events_and_corrective_actions', '歧视事件及采取的纠正行动', NULL, NULL, NULL, '公司劳动用工的标准，公司在反歧视方面的招聘要求，以及发现违规（违反劳动准则）情况时的处理措施。', '上交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (1, '物料进出统计', 'aluminum', '铝消耗量', 0.01, NULL, 'T', '铝消耗量 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (4, '废气排放统计', 'nmhc', 'NMHC排放', 0.01, NULL, 'T', '非甲烷总烃排放', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (4, '废气排放统计', 'particulate', '颗粒物排放', 0.01, NULL, 'T', '颗粒物排放', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '雇佣', 'guangda_vs_industry_turnover_comparison', '光大同创的员工流失率与行业流失率的对比表', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (4, '温室气体盘查统计', 'category_five', '范畴五排放', 0.01, NULL, 'tCO₂e', '范畴五排放', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '职业健康与安全', 'ohs_participation_consultation_communication', '职业健康安全事务：工作者的参与、意见征询和沟通', NULL, NULL, NULL, '在职业健康安全管理体系的开发、实施和评估中，使工作者参与和协商的流程，以及向工作者提供职业健康安全信息访问权以及沟通信息的流程。', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '职业健康与安全', 'ohs_management_system', '职业健康安全管理体系', NULL, NULL, NULL, '说明是否实施了职业健康安全管理体系，说明职业健康安全管理体系所覆盖的工作者、活动和工作场所范围。', 'GRI、国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '童工', 'child_labor_risk_sites_suppliers', '具有重大童工事件风险的运营点和供应商', NULL, NULL, NULL, '公司如何避免童工及强制劳动，及发现存在童工或强制劳动时的应对措施，还应重视收集并报告具有使用童工、强制劳动重大风险的运营点及供应商', '上交所、港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (4, '温室气体盘查统计', 'category_four', '范畴四排放', 0.01, NULL, 'tCO₂e', '范畴四排放', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (1, '物料进出统计', 'wood_fiber', '木质纤维消耗量', 0.01, NULL, 'T', '木质纤维消耗量 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--年龄组别', 'age18_30', '18-30岁员工', 1.0, NULL, '人', '18-30岁员工数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--员工学历结构', 'edu_junior', '大专及以下学历', 1.0, NULL, '人', '大专及以下学历员工数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--雇佣类型', 'full_time', '全职员工', 1.0, NULL, '人', '全职员工数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--地区划分', 'overseas', '海外员工', 1.0, NULL, '人', '海外员工数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--性别', 'female', '女性员工', 1.0, NULL, '人', '女性员工数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--雇员类别', 'management', '管理人员', 1.0, NULL, '人', '管理人员数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--雇员类别', 'management_female', '女性管理人员', 1.0, NULL, '人', '女性管理人员数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '职业健康与安全', 'ohs_training', '工作者职业健康安全培训', NULL, NULL, NULL, '向工作者提供的任何职业健康安全培训，包括通用培训以及对具体工作相关危害、危害活动或危害情况的培训。', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--地区划分', 'mainland', '大陆员工', 1.0, NULL, '人', '大陆员工数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--员工学历结构', 'edu_bachelor', '本科学历', 1.0, NULL, '人', '本科学历员工数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '员工关爱', 'employee_care', '员工关爱', NULL, NULL, NULL, '公司重视关怀关爱员工，保障工作和生活平衡稳定的举措，包括公司通过帮扶困难员工、员工生育期权益保障(女性员工带薪休假、男性员工护产假保障)', '上交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--五险一金', 'inc_social_fund', '社保公积金增长', 0.01, NULL, '元', '社保公积金增长 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '培训', 'annual_training_plan', '年度培训计划', NULL, NULL, NULL, '为提升员工技能而提供的培训', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '职业健康与安全', 'safety_production_policy', '安全生产政策', NULL, NULL, NULL, '提供安全工作环境及保障雇员避免职业性危害的政策，及其他遵守的相关法律与规定', '上交所、港交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--员工学历结构', 'edu_phd', '博士学历', 1.0, NULL, '人', '博士学历员工数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--年龄组别', 'age46_60', '46-60岁员工', 1.0, NULL, '人', '46-60岁员工数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--雇员类别', 'general', '普通员工', 1.0, NULL, '人', '普通员工数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--雇员类别', 'middle', '中层员工', 1.0, NULL, '人', '中层员工数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--员工学历结构', 'edu_master', '硕士学历', 1.0, NULL, '人', '硕士学历员工数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--新招聘', 'new_hires', '新招聘员工', 1.0, NULL, '人', '新招聘员工数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--雇佣类型', 'part_time', '兼职员工', 1.0, NULL, '人', '兼职员工数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (1, '物料进出统计', 'renewable_input', '可再生进料量', 0.01, NULL, 'T', '可再生进料量 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (1, '物料进出统计', 'non_renewable_input', '不可再生进料量', 0.01, NULL, 'T', '不可再生进料量 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (1, '物料进出统计', 'renewable_output', '可再生出料量', 0.01, NULL, 'T', '可再生出料量 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '废弃物', 'total_non_hazardous_waste', '无害废弃物总量', 0.01, NULL, '吨', '无害废弃物总量', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--五险一金', 'avg_social_fund', '平均社保公积金', 0.01, NULL, '元', '平均社保公积金 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '职业健康与安全', 'ohs_target_measures', '保障职业健康与安全目标措施', NULL, NULL, NULL, '提供安全工作环境、保障员工避免职业性危害的措施和执行情况
公司职业健康与安全工作的措施，包括公司获得职业健康安全管理体系认证证书（如ISO45001、OHSAS18001等）', '上交所、港交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '雇佣', 'salary_management', '薪酬管理', NULL, NULL, NULL, '公司构建薪酬体系的制度及举措
如公司构建包含绩效奖金、岗位津贴、员工持股计划等', '上交所、港交所、MSCI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--年龄组别', 'age31_45', '31-45岁员工', 1.0, NULL, '人', '31-45岁员工数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--性别', 'male', '男性员工', 1.0, NULL, '人', '男性员工数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--年龄组别（离职）', 'quit46_60', '46-60岁离职员工', 1.0, NULL, '人', '46-60岁离职员工数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--雇员类别（离职）', 'quit_general', '普通员工离职', 1.0, NULL, '人', '普通员工离职数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '职业健康与安全', 'occupational_hazard_position_health_check_rate', '职业病危害岗位体检率', 0.01, NULL, '%%', '报告期内职业病危害岗位体检率', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '职业健康与安全', 'safety_emergency_drill_count', '安全应急演练次数', 1.0, NULL, '次', '报告期内安全应急演练次数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '职业健康与安全', 'safety_inspection_hazards_identified_count', '安全检查排查隐患数量', 1.0, NULL, '个', '报告期内安全检查排查隐患数量', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '员工满意度', 'employee_satisfaction', '员工满意度', 0.01, NULL, '%%', '开展员工满意度的调查结果', '港交所、GRI、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '职业健康与安全', 'employee_health_check_participation_rate', '员工体检参与率', 0.01, NULL, '%%', '报告期内员工体检人数/总人数*100%%', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '职业健康与安全', 'employees_health_check_count', '员工体检人数', 1.0, NULL, '人', '报告期内员工体检人数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '职业健康与安全', 'full_time_safety_staff_count', '专职安全管理人员员工数', 1.0, NULL, '人', '报告期内专职安全管理人员数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '产品责任', 'total_customer_complaints', '客户投诉总数', 1.0, NULL, '件', '当年实际客户投诉次数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '产品责任', 'effectively_resolved_complaints_count', '有效处理件数', 1.0, NULL, '件', '有效处理客户投诉次数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '产品责任', 'product_recall_count', '发生产品召回的次数', 1.0, NULL, '次', '当年实际产品召回次数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '产品责任', 'product_safety_quality_issues', '产品安全质量问题', 1.0, NULL, '件', '产品安全质量出现问题的事件次数 ', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '产品责任', 'customer_satisfaction_result', '客户满意度结果', 0.01, NULL, '%%', '当年客户满意度调查报告', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '产品责任', 'customer_complaint_effective_resolution_rate', '客户投诉有效处理率', 0.01, NULL, '%%', '有效处理客户投诉次数/客户投诉总次数*100%%', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '物料', 'aluminum', '铝', 0.01, NULL, '吨', '采购的铝总量', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '产品责任', 'product_recall_percentage', '产品召回百分比', 0.01, NULL, '%%', '实际产品召回次数/总出货次数*100%%', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '供应链管理', 'share_of_procurement_spent_on_local_suppliers', '向当地供应商采购的支出比例', 0.01, NULL, '%%', '向经营所在地的当地供应商支出的用于重要经营位置的采购预算百分比（例如从当地购买的产品 和服务的百分比）', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '维护股东权益', 'investor_communication', '投资者沟通交流', NULL, NULL, '', '描述与投资者沟通交流的情况，包括：
通过业绩说明会、新闻发布会、投资者接待日等方式进行投资者关系活动的情况及在帮助投资者及时全面地了解公司已公开重大信息方面所采取的措施', '上交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, 'ESG治理', 'third_party_assurance', '第三方鉴证', NULL, NULL, '', '如有第三方机构对公司ESG信息进行核查、鉴定、鉴证、评价的，鼓励公司披露相关信息', '国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, 'ESG治理', 'materiality_assessment', '重要性评估', NULL, NULL, '', '对ESG议题的重要性进行评估的情况', '国证 ', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '治理机制', 'communication_of_important_concerns', '重要关切问题的沟通', NULL, NULL, '', 'a.说明是否以及如何向最高管治机构沟通重要关切问题； b. 说明在报告期传达给最高管治机构的重大关切问题的总数和性质。', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, 'ESG治理', 'esg_executive_compensation_link', 'ESG与高管薪酬挂钩', NULL, NULL, '', '描述公司高管薪酬与ESG绩效挂钩的方式，以保障董事会可持续发展决策在公司运营中得到严格落实', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, 'ESG治理', 'highest_governance_body_role_sustainability_report', '最高管治机构在可持续发展报告中的作用', NULL, NULL, '', '说明最高管治机构是否负责审核和批准所报告的信息，包括组织的实质性议题，如果是，说明审核和批准信息的程序', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '治理结构', 'board_of_supervisors', '监事会', NULL, NULL, '', '描述监事及监事会的相关情况，包括：
监事情况。包括监事构成、选举及标准、职责、任期、性别比例、兼职等据以说明监事勤勉履职的相关情况；
监事会情况。包括会议次数、异议、召开的合规性及相关决议执行情况', '上交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '治理机制', 'management_compensation_incentive_system', '管理层薪酬激励制度及执行情况说明', NULL, NULL, '', NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '反腐败', 'anti_bribery_training_implementation', '反贪污和贿赂培训及执行情况说明', NULL, NULL, '', NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '治理结构', 'board_gender_ratio', '董事会性别比例', NULL, NULL, '', NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '维护股东权益', 'protecting_minority_shareholders_rights', '中小股东权益保护', NULL, NULL, '', '保障和保护中小股东方面的努力', '华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '治理结构', 'board_of_directors', '董事会', NULL, NULL, '', '董事会会议情况。包括会议次数、异议、召开的合规性及相关决议执行情况', '上交所、港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '治理机制', 'association_membership', '协会的成员资格', NULL, NULL, '', '说明公司参与并发挥重要作用的行业协会、其他成员制协会、国家或国际倡导组织。', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--年龄组别（离职）', 'quit18_30', '18-30岁离职员工', 1.0, NULL, '人', '18-30岁离职员工数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--性别（离职）', 'quit_male', '男性离职员工', 1.0, NULL, '人', '男性离职员工数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--年龄组别（离职）', 'quit31_45', '31-45岁离职员工', 1.0, NULL, '人', '31-45岁离职员工数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--性别（离职）', 'quit_female', '女性离职员工', 1.0, NULL, '人', '女性离职员工数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--地区类别（离职）', 'quit_overseas', '海外离职员工', 1.0, NULL, '人', '海外离职员工数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--地区类别（离职）', 'quit_mainland', '大陆离职员工', 1.0, NULL, '人', '大陆离职员工数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--雇员类别（离职）', 'quit_middle', '中层员工离职', 1.0, NULL, '人', '中层员工离职数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, '员工雇佣统计--雇员类别（离职）', 'quit_management', '管理人员离职', 1.0, NULL, '人', '管理人员离职数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (12, '供应商统计', 'env_screened', '环境筛选供应商', 1.0, NULL, '个', '环境筛选供应商数量', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (11, '员工满意度调查统计', 'satisfaction', '员工满意度', 0.01, NULL, '分', '员工满意度 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (12, '供应商统计', 'env_penalty_amount', '环境处罚金额', 0.01, NULL, '万元', '环境处罚金额', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (14, '知识产权统计', 'utility_patents', '实用新型专利', 1.0, NULL, '个', '实用新型专利 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (13, '产品责任统计', 'complaints', '客户投诉总数', 1.0, NULL, '次', '客户投诉总数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (12, '供应商统计', 'local_amount', '当地采购金额', 0.01, NULL, '万元', '当地采购金额', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (10, '职业健康安全统计', 'occupational_checks', '职业病体检人数', 1.0, NULL, '人', '职业病体检人数', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (12, '供应商统计', 'cyber_incidents', '数据安全事件', 1.0, NULL, '次', '数据安全事件次数', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (13, '产品责任统计', 'quality_issues', '产品质量问题数', 1.0, NULL, '次', '产品质量问题数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (12, '供应商统计', 'other', '其他地区供应商', 1.0, NULL, '个', '其他地区供应商数量', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (15, '社区参与统计', 'charity_donations', '公益慈善捐赠总额', 0.01, NULL, '万元', '公益慈善捐赠总额 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (13, '产品责任统计', 'cyber_incidents', '网络数据安全事件', 1.0, NULL, '次', '网络数据安全事件 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (13, '产品责任统计', 'customer_satisfaction', '客户满意度', 0.01, NULL, '分', '客户满意度 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (13, '产品责任统计', 'recalls', '产品召回次数', 1.0, NULL, '次', '产品召回次数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (12, '供应商统计', 'south', '华南地区供应商', 1.0, NULL, '个', '华南地区供应商数量', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '税收透明度', 'tax_transparency_policy_implementation', '税收透明度相关政策及执行情况说明', NULL, NULL, '', '', '', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (14, '知识产权统计', 'trademarks', '商标注册', 1.0, NULL, '个', '商标注册 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (13, '产品责任统计', 'handled', '有效处理件数', 1.0, NULL, '次', '有效处理件数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '风险管理', 'risk_management_system_reference_standards', '风险管理体系参照标准', NULL, NULL, '', '风险管理体系参照标准是否基于ISO 31000等标准设置', '国证 ', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '治理机制', 'shared_knowledge_highest_governance_body', '最高管治机构的共同知识', NULL, NULL, '', '说明为提高最高管治机构关于可持续发展的共同知识、技能和经验而采取的措施。', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, 'ESG治理', 'assurance_report_disclosure', '鉴证报告披露', NULL, NULL, '', NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, 'ESG治理', 'assurance_agency_personnel_qualification', '鉴证机构人员资质', NULL, NULL, '', NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '风险管理', 'esg_risk_management', 'ESG风险管理', NULL, NULL, '', 'ESG相关风险的管理情况', '国证 ', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '商业道德', 'guangda_tongchuang_coc_code', '光大同创的CoC行为准则', NULL, NULL, '', NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '反腐败', 'anti_corruption_policy', '反腐败政策', NULL, NULL, '', '描述公司在反对商业贿赂、反腐败、推动廉洁从业、反不正当竞争方面制定的相关规章制度及政策', '港交所、GRI、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '风险管理', 'risk_management_system', '风险管理体系', NULL, NULL, '', '公司委风险管理体系的披露情况', '国证 ', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '商业道德', 'corruption_bribery_two_years', '两年腐败与贿赂事件', NULL, NULL, '', '两年内发生腐败或贿赂事件的次数', '国证 ', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, 'ESG治理', 'assurance_agency_qualification', '鉴证机构资质', NULL, NULL, '', NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '治理结构', 'nomination_selection_highest_governance_body', '最高管治机构的提名与遴选', NULL, NULL, '', 'a. 说明最高管治机构及其委员会的提名和遴选程序； 
b.说明用于提名和遴选最高管治机构成员的标准，包括是否以及如何考虑以下因素： 
i 利益相关方（包括股东）的意见；
ii 多样性；
iii 独立性；
iv 与组织的影响相关的胜任能力', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '反腐败', 'corruption_litigation_events_results', '腐败诉讼事件及结果', NULL, NULL, '', '统计对公司或员工提出并已审结的腐败诉讼案件或不正当竞争诉讼案件数量，说明已审结案件的诉讼结果，包括对公司或公司员工做出的罚款、处罚或制裁', '港交所、GRI、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '治理结构', 'board_independence', '董事会独立性', NULL, NULL, '', '描述独立董事的占比及履职情况', '上交所、港交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '商业道德', 'litigation_exists', '是否有诉讼', NULL, NULL, '', NULL, '华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, 'ESG治理', 'materiality_assessment_results', '重要性评估结果', NULL, NULL, '', '对ESG议题的重要性进行评估的结果', '国证 ', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '水资源', 'annual_reclaimed_water_use_target', '年度中水使用量目标', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '气候变化-公司战略', 'risk_impact', '风险影响', NULL, NULL, NULL, '气候相关风险和机遇对公司的业务、战略的影响
气候相关风险风险和机遇为公司经营、收入或支出带来的重大变化', '港交所、GRI、TCFD', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (10, '职业健康安全统计', 'safety_investment', '安全生产投入', 0.01, NULL, '万元', '安全生产投入 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (10, '职业健康安全统计', 'medical_checks', '员工体检人数', 1.0, NULL, '人', '员工体检人数', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (10, '职业健康安全统计', 'hazards_found', '安全检查排查隐患数', 1.0, NULL, '个', '安全检查排查隐患数', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (14, '知识产权统计', 'software_copyrights', '软件著作权', 1.0, NULL, '个', '软件著作权 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (12, '供应商统计', 'east', '华东地区供应商', 1.0, NULL, '个', '华东地区供应商数量', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'overall_employee_turnover_rate', '员工总流失率', 0.01, NULL, '%%', '年度离职人数/（年度最终在职人数+年度离职人数）*100%%', '港交所、GRI、国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'mainland_china_turnover_rate', '中国大陆离职率', 0.01, NULL, '%%', '中国大陆离职人数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'mainland_china_employees', '中国大陆员工数', 1.0, NULL, '人', '报告期内中国大陆员工数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'general_staff_count', '普通员工数', 1.0, NULL, '人', '报告期内普通员工数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '职业健康与安全', 'work_related_deaths', '工亡人数', 1.0, NULL, '人', '报告期内工亡人数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '教育和培训', 'mid_level_trained_employee_percentage', '中层受训员工百分比', 0.01, NULL, '%%', '报告期内中层员工受训人数/总人数*100%%', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '教育和培训', 'total_trained_employees', '受训总人数', 1.0, NULL, '人次', '报告期内受训人数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'employees_18_30', '18-30岁员工数', 1.0, NULL, '人', '报告期内18-30岁员工数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'mid_level_employees', '中层员工数', 1.0, NULL, '人', '报告期内中层员工数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'female_turnover_rate', '女性离职率', 0.01, NULL, '%%', '女性离职人数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (13, '产品责任统计', 'shipments', '产品出货量', 1.0, NULL, '件', '产品出货量 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (15, '社区参与统计', 'volunteer_hours', '志愿者服务总时长', 0.1, NULL, '小时', '志愿者服务总时长 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (12, '供应商统计', 'soc_screened', '社会标准供应商', 1.0, NULL, '个', '社会标准供应商数量', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '职业健康与安全', 'safety_incidents', '安全事故', 1.0, NULL, '次', '因安全事故导致生产受影响或员工伤亡事件次数（安全事故包含工伤数量）', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'total_leavers', '离职总人数', 1.0, NULL, '人', '年度离职总人数', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '职业健康与安全', 'per_capita_training_hours', '人均受训学时', 0.01, NULL, '小时', '向员工提供的与安全相关的人均受训时长', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '教育和培训', 'mid_level_training_hours', '中层员工受训时数', 0.01, NULL, '小时', '报告期内中层员工受训时数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '教育和培训', 'company_training_coverage_rate', '公司培训覆盖率', 0.01, NULL, '%%', '报告期内受训人数/总人数*100%%', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '教育和培训', 'male_trained_employee_percentage', '男性受训员工百分比', 0.01, NULL, '%%', '报告期内男性受训人数/总人数*100%%', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'male_turnover_rate', '男性离职率', 0.01, NULL, '%%', '男性离职人数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (12, '供应商统计', 'env_penalty_count', '环境处罚次数', 1.0, NULL, '次', '环境处罚次数', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, '知识产权保护', 'intellectual_property_policy', '知识产权保护政策', NULL, NULL, '', '描述与维护及保障知识产权有关的惯例
包含2个方面：对集团自身知识产权的保护，以及避免侵犯外部知识产权的制度和流程。', '上交所、港交所、国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, '产品安全管理', 'product_quality_safety_mechanism', '产品质量与安全机制', NULL, NULL, '', '保证产品质量与安全的机制、执行情况以及应对产品安全事故的措施
保障生产环境安全、生产流程科学的措施及执行情况
其他与产品安全与责任有关的重要信息，如产品质量认证等', '上交所、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, '社区参与', 'community_participation', '社区参与', NULL, NULL, '', '描述公司积极参与社区治理，为提升社区教育、环境、就业、文化、体育等水平方面制定的办法、采取的措施及亮点实践等', '上交所、港交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, '供应商管理', 'supply_chain_environmental_audit_improvement', '供应链环境现场审核改进情况说明', NULL, NULL, '', NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, '社区参与', 'stakeholder_community_communication_completion_rate', '利益相关方社区沟通目标计划完成率（%%）', NULL, NULL, '', NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, '供应商管理', 'supplier_integrity_requirements', '供应商廉洁要求', NULL, NULL, '', '描述公司对供应商在遵守国家相关法律法规要求、合规经营方面的要求', '上交所、港交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, '供应商管理', 'supply_chain_environmental_management_goals', '供应链环境管理目标', NULL, NULL, '', NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, '社区参与', 'stakeholder_community_communication_goals_plan', '利益相关方社区沟通目标计划', NULL, NULL, '', NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, '供应商管理', 'green_supply_chain', '绿色供应链', NULL, NULL, '', '描述在拣选供应商时促使多用环保产品及服务的措施，以及相关执行及监察方法', '上交所、港交所、国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, '知识产权保护', 'intellectual_property_practices', '维护及保障知识产权有关的惯例', NULL, NULL, '', '描述与维护及保障知识产权有关的目标
描述与维护及保障知识产权有关的措施，包括增加知识产权意识、完善创新机制、严格依法申请知识产权、坚决打击侵权等行为', '港交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, '供应商管理', 'supplier_identification', '供应商识别', NULL, NULL, '', '描述有关识别供应链每个环节的环境及社会风险的政策、措施，以及相关执行及监察方法', '港交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, '数据安全与客户隐私保护', 'customer_privacy_protection', '客户隐私保护', NULL, NULL, '', '描述客户资料、数据保障及私隐的相关执行及监察方法，包括信息安全的制度及执行情况、维护消费者数据安全及隐私等。', '上交所、港交所、国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, '数据安全与客户隐私保护', 'information_security_management_system_certification', '信息安全管理体系认证', NULL, NULL, '', '信息安全管理体系认证ISO 27001的获得情况', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, '社区参与', 'local_community_participation_assessment_development', '有当地社区参与、影响评估和发展计划的运营点', NULL, NULL, '', '参与运营地社区发展建设，披露包括但不限于：环境影响评估和持续监测；公开披露环境和社会影响评估结果；基于当地社区需求的当地社区发展计划', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, '供应商管理', 'supply_chain_negative_social_impact_actions', '供应链对社会的负面影响及采取的行动', NULL, NULL, '', '包括以下事项：
开展了社会影响评估的供应商数量；
经确定为具有实际和潜在重大负面社会影响的供应商数量；
经确定的供应链中的实际和潜在重大负面社会影响；
经确定为具有实际和潜在重大负面社会影响，且经评估后同意改进的供应商百分比；
经确定为具有实际和潜在重大负面社会影响，且经评估后决定终止关系的供应商百分比', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, '供应商管理', 'supply_chain_environmental_commitment_rate', '供应链环境承诺书签署率', NULL, NULL, '', NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '职业健康与安全', 'work_related_fatality_rate', '因工死亡率', 0.01, NULL, '%%', '报告期内因工死亡人数/总人数*100%%', '港交所、GRI、国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'non_mainland_china_turnover_rate', '中国大陆以外离职率', 0.01, NULL, '%%', '中国大陆以外离职人数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (14, '知识产权统计', 'inv_patents', '发明专利', 1.0, NULL, '个', '发明专利 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (14, '知识产权统计', 'granted_patents', '被授权专利', 1.0, NULL, '个', '被授权专利 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '教育和培训', 'total_training_hours', '培训总学时(未分类统计)', 0.01, NULL, '小时', '报告期内培训总时数，单次培训学时*参与人数之和', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '教育和培训', 'management_training_hours', '管理层受训时数', 0.01, NULL, '小时', '报告期内管理层受训时数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (15, '社区参与统计', 'community_investment', '社区发展投入金额', 0.01, NULL, '万元', '社区发展投入金额 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '教育和培训', 'female_trained_employee_percentage', '女性受训员工百分比', 0.01, NULL, '%%', '报告期内女性受训人数/总人数*100%%', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '职业健康与安全', 'employee_safety_training_sessions', '员工安全培训次数', 1.0, NULL, '次', '提高安全监管检察人员、生产经营单位从业人员和从事安全生产工作的相关人员的安全素质为目的的教育培训活动。', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'social_insurance_and_housing_fund', '五险一金', 0.01, NULL, '元', '人均五险一金增加额', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'turnover_rate_18_30', '18-30岁离职率', 0.01, NULL, '%%', '18-30岁离职人数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'employees_31_45', '31-45岁员工数', 1.0, NULL, '人', '报告期内31-45岁员工数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'employee_education_structure', '员工学历结构', 0.01, NULL, '%%', '博士及以上、硕士、本科、专科及以下员工比例', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'full_time_employees', '全职员工数', 1.0, NULL, '人', '报告期内全职员工数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '教育和培训', 'male_trained_employees', '男性受训人数', 1.0, NULL, '人次', '报告期内男性受训人数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '职业健康与安全', 'safety_investment', '安全生产投入', 0.01, NULL, '万元', '报告期内安全生产投入金额', '港交所、GRI、国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '教育和培训', 'management_trained_employee_percentage', '管理层受训员工百分比', 0.01, NULL, '%%', '报告期内管理层受训人数/总人数*100%%', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'part_time_employees', '兼职员工数', 1.0, NULL, '人', '报告期内兼职员工数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '教育和培训', 'average_training_hours_per_employee', '人均受训学时', 0.01, NULL, '小时', '培训总学时/受训总人数', '港交所、GRI、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'mid_level_turnover_rate', '中层员工离职率', 0.01, NULL, '%%', '中层员工离职人数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (15, '社区参与统计', 'volunteer_participants', '志愿者活动参与人次', 1.0, NULL, '人次', '志愿者活动参与人次 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'turnover_rate_31_45', '31-45岁离职率', 0.01, NULL, '%%', '31-45岁离职人数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'total_employees', '员工总数（人）', 1.0, NULL, '人', '报告期内员工总数', '港交所、GRI、国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'management_count', '管理层人数', 1.0, NULL, '人', '报告期内管理层人数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'management_turnover_rate', '管理层离职率', 0.01, NULL, '%%', '管理层离职人数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'employees_46_60', '46-60岁员工数', 1.0, NULL, '人', '报告期内46-60岁员工数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '教育和培训', 'female_training_hours', '女性受训时数', 0.01, NULL, '小时', '报告期内女性受训时数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '教育和培训', 'male_training_hours', '男性受训时数', 0.01, NULL, '小时', '报告期内男性受训时数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'overseas_employees', '海外员工数', 1.0, NULL, '人', '报告期内海外员工数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'turnover_rate_46_60_plus', '46-60岁以上离职率', 0.01, NULL, '%%', '46-60岁以上离职人数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (14, '知识产权统计', 'patents', '专利总数', 1.0, NULL, '个', '专利总数 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (14, '知识产权统计', 'inv_applications', '发明专利申请', 1.0, NULL, '个', '发明专利申请 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '职业健康与安全', 'lost_work_days_due_to_injuries', '因工伤损失工作日数', 1.0, NULL, '天', '报告期内因工伤损失工作日数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (14, '知识产权统计', 'design_patents', '外观设计专利', 1.0, NULL, '个', '外观设计专利 (按月)', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '水资源', 'total_reclaimed_water_use', '总中水用水量', 0.01, NULL, '吨', '总中水(处理后的废水，可以在非饮用领域再次使用的水)用水量  循环水放在中水的统计数据里面', '华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '物料', 'input_renewable_material_weight_or_volume', '进料-可再生料的重量或体积', 0.01, NULL, '吨', '用于生产和包装公司产品的进料的总重量：可再生材料', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '水资源', 'total_water_withdrawal', '取水总量', 0.01, NULL, '吨', '总取水量，说明取水来源，来自地表、地下或第三方', '国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '物料', 'paper', '纸张', 0.01, NULL, '吨', '总(办公)纸张消耗量', '国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '资金投入', 'clean_technology_r_and_d_investment', '清洁技术研发投入', 0.01, NULL, '万元', '公司在产品、技术、材料、工艺、标准的研究、开发过程中发生的各项费用，需剔除各种财政科技经费补助', 'MSCI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '物料', 'total_output', '出料总量', 0.01, NULL, '吨', '报告期内售出的产品总量', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '废弃物', 'wastewater_discharge_intensity', '废水排放强度', 0.0001, NULL, '吨/万元', '废水排放量/总营收(万元)', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '物料', 'packaging_material_consumption_intensity', '包装材料消耗强度', 0.0001, NULL, '吨/万元', '总包装材料消耗量/总营收（万元）', '国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (10, '职业健康安全统计', 'safety_managers', '专职安全管理人员', 1.0, NULL, '人', '专职安全管理人员', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (10, '职业健康安全统计', 'emergency_drills', '安全应急演练次数', 1.0, NULL, '次', '安全应急演练次数', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '废弃物', 'protective_product_waste_comprehensive_utilization_rate', '防护类产品废弃物综合利用率', 0.01, NULL, '%%', '防护类产品废弃物中回收利用的部分/防护类产品废弃物总量', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '物料', 'input_non_renewable_material_weight_or_volume', '进料-不可再生料的重量或体积', 0.01, NULL, '吨', '用于生产和包装公司产品的进料的总重量：不可再生材料', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '排放', 'greenhouse_gas_emission_intensity', '温室气体排放强度', 0.01, NULL, '吨二氧化碳当量/万元', '温室气体排放总量（吨二氧化碳当量）/营业收入（万元）', '国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '排放', 'benzene_compounds', '苯类（苯、甲苯、二甲苯）', 0.01, NULL, '吨', '重大气体排放：NOx、SOx、持久性有机污染物（POP）、挥发性有机化合物（VOC）、危害性空气污染物（HAP）、颗粒物质（PM）、相关法规中确定的气体排放的其他标准类别', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '物料', 'share_of_renewable_output', '可再生出料占比', 0.01, NULL, '%%', '可回收再利用的产品及其包装材料/报告期内售出的产品总量', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '能源', 'total_energy_consumption', '综合能耗 ', 0.01, NULL, '吨标准煤', '报告期内能源使用总量，折合为标准煤', '港交所、GRI、国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '物料', 'material_consumption', '物料消耗量', 0.01, NULL, '吨', '物料消耗量是进料总量的一部分', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '水资源', 'effluent_discharge_volume', '排水量', 0.01, NULL, '吨', '总排水量，说明去向，如地表、地下或第三方', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '水资源', 'recycled_water_resource_recovery_volume', '循环水量/水资源回收利用量', 0.01, NULL, '吨', '经处理后回收循环使用的水量', 'GRI、国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '水资源', 'water_withdrawal_industrial', '取水量（工业）', 0.01, NULL, '吨', '总取水量，说明取水来源，来自地表、地下或第三方', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '能源', 'renewable_energy_consumption', '可再生能源使用量', 0.01, NULL, '千瓦时', '报告期内使用的可再生能源产生的电量', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '排放', 'non_methane_total_hydrocarbons', '碳氢化合物（非甲烷总烃）', 0.01, NULL, '吨', '重大气体排放：NOx、SOx、持久性有机污染物（POP）、挥发性有机化合物（VOC）、危害性空气污染物（HAP）、颗粒物质（PM）、相关法规中确定的气体排放的其他标准类别', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '废弃物', 'improper_three_wastes_disposal_incidents', '三废处置不当事件', 1.0, NULL, '次', '废水、废气、废弃物受到监管处罚的事件次数', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '物料', 'wood_fiber', '木纤维', 0.01, NULL, '吨', '采购的木纤维总量', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '水资源', 'water_use_intensity', '用水强度', 0.0001, NULL, '吨/万元', '总取水量/营业收入', '国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '能源', 'diesel_consumption', '柴油使用量', 0.01, NULL, '吨', '报告期内使用的柴油总量', '国证 ', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '能源', 'natural_gas_consumption', '天然气使用量', 0.01, NULL, '吨', '报告期内使用的天然气总量', '国证 ', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '水资源', 'water_consumption', '耗水量', 0.01, NULL, '吨', '总取水量-总排水量', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '废弃物', 'total_hazardous_waste', '有害废弃物总量', 0.01, NULL, '吨', '有害废弃物总量', '港交所、GRI、国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '资金投入', 'environmental_investment_intensity', '环保投入强度', 0.01, NULL, '%%', '环境保护方面的总投入/公司总营收', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '排放', 'nox_sox_and_other_major_gas_emissions', '氮氧化物（NOx）、硫氧化物（SOx）和其他重大气体排放', 0.01, NULL, '吨', '重大气体排放：NOx、SOx、持久性有机污染物（POP）、挥发性有机化合物（VOC）、危害性空气污染物（HAP）、颗粒物质（PM）、相关法规中确定的气体排放的其他标准类别', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '资金投入', 'climate_change_r_and_d_expenditure', '气候变化的研发金额', 0.01, NULL, '万元', '针对气候变化问题投入的研发金额', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '资金投入', 'share_of_green_revenue', '绿色收入占比', 0.01, NULL, '%%', '绿色收入(通过销售环保产品、提供环保服务或实施绿色项目、绿色转绿所获得的收入)/总收入', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '排放', 'greenhouse_gas_direct_emissions', '温室气体直接排放量(范围一）', 0.01, NULL, '吨二氧化碳当量', '温室气体盘查报告（范围1）', '港交所、GRI、国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '资金投入', 'environmental_protection_investment', '环保资金投入', 0.01, NULL, '万元', '包括环保设施建设费、环保设施运行和维护费用、建设项目环评费用、清洁生产审核费用、废弃物处置费用、环境监测费、排污费和污水处理费、环保培训费等', '上交所、国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '环境管理', 'provincial_level_green_factory', '省级绿色工厂', 1.0, NULL, '个', '绿色工厂总数(需要有明确的认证)', '华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '物料', 'total_input_material', '进料总量', 0.01, NULL, '吨', '用于生产和包装公司产品的进料的总重量', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '商业道德', 'external_penalties', '外部处分', NULL, NULL, '', '高管及股东被证监会、交易所等实施处罚的违法违规情况，追溯三年', '华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '治理结构', 'activities_value_chain_other_business_relationships', '活动、价值链和其他业务关系', NULL, NULL, '', 'a.说明其运营所在的行业； 
b.说明组织的价值链，包括： 
i 组织的活动、产品、服务 ，以及所服务的市场；
ii 组织的供应链； 
iii 组织的下游实体及其活动
c.说明其他相关业务关系', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, 'ESG治理', 'stakeholder_opposition', '利益相关者的反对', NULL, NULL, '', '描述报告期内公司经营活动中引发利益相关者反对的重要事项
包括利益相关者的影响范围、诉求以及公司处理上述事项的流程和具体情况', '上交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '商业道德', 'financial_fraud_two_years', '两年财务造假事件', NULL, NULL, '', '两年内利用欺诈手段虚报会计事项的次数', '国证 ', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, 'ESG治理', 'esg_strategy_goal_management', 'ESG战略与目标管理', NULL, NULL, '', '描述公司制定ESG战略目标、战略规划和战略实施等相关内容', '港交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '商业道德', 'business_ethics_code_disclosure', '商业道德行为准则与信披', NULL, NULL, '', '为规范员工的商业道德行为而制定的准则', '国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '反腐败', 'anti_corruption_training', '反腐败培训', NULL, NULL, '', '描述开展的反腐败培训关键内容及反馈结果等；
描述有关培训的范围、对象（例如董事、员工、业务伙伴）及方式，以及进行培训后公司企业文化／员工行为有否任何可计量或显著变化的陈述；
统计相关数据，例如培训课程数目／时数、参加培训的董事／雇员人数及百分比、各部门参加培训的人数', '港交所、GRI、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '商业道德', 'stakeholder_notification_completion_rate', '利益相关方公示告知及达成率（%%）', NULL, NULL, '', NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '治理机制', 'delegated_responsibility_for_managing_impacts', '为管理影响的责任授权', NULL, NULL, '', 'a.说明最高管治机构如何进行责任授权，管理组织对经济、环境和人的影响，包括： i 是否任命了任何高管负责管理影响；ii 是否将管理影响的责任授权给其他员工；
b.在管理组织对经济、环境和人的影响方面，说明高管或其他员工向最高管治机构汇报的程序和频率', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '治理结构', 'regulatory_framework_composition', '管制架构和组成', NULL, NULL, '', 'a.说明其管治架构，包括最高管治机构的委员会，如员会的人员构成、分工和执行情况,以及内部审计部门员工具备的知识、技能和经验，及其向审计委员会报告的简要情况
b.说明最高管治机构及其委员会的组成，按照：执行成员和非执行成员、独立性、管治机构成员的任期、性别、专业背景', '上交所、港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '治理机制', 'accountability_mechanism', '追责机制', NULL, NULL, '', '描述内部违规责任追究制度的建立与执行情况，披露对有关责任人采取的问责措施及处理结果', '上交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '员工满意度', 'employee_satisfaction_survey_coverage', '员工满意度调查覆盖率/覆盖情况', NULL, NULL, NULL, '', '', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '环境管理', 'environmental_penalty_intensity', '环境处罚强度', 0.01, NULL, '%%', '环境相关处罚总额（单位万元）与总营收（单位百万元）之比', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '环境管理', 'environmental_penalty_amount', '环境处罚额', 0.01, NULL, '万元', '环境相关处罚总额', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '废弃物', 'waste_sent_for_disposal', '进入处置的废弃物', 0.01, NULL, '吨', '焚烧、填埋或交由第三方处置的废弃物总量', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '环境管理', 'environmental_violations', '环境违规', 1.0, NULL, '次', '违反环保规定或受到环境监管机构处罚的次数', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '能源', 'other_energy_consumption', '其他能源消耗量', 0.01, NULL, '吨标准煤', '报告期内使用的其他能源总量，包括天然气、蒸汽、煤油、燃料油、液化石油气等。', '港交所、GRI、国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '能源', 'purchased_electricity', '外购电量', 0.01, NULL, '千瓦时', '报告期内使用的外购电量', '港交所、GRI、国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '物料', 'packaging_materials', '包装材料', 0.01, NULL, '吨', '总包装（用于包装、保护、运输和展示产品的各种材料）材料消耗量', '国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '员工满意度', 'employee_satisfaction_project_ranking', '员工满意度项目排名', NULL, NULL, NULL, '', '', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '员工满意度', 'employee_satisfaction_survey_plan', '员工满意度调查计划', NULL, NULL, NULL, '', '', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '排放', 'value_chain_indirect_emissions_scope_3', '价值链上下游各项活动的间接排放数据（范围三）', 0.01, NULL, '吨二氧化碳当量', '温室气体盘查报告（范围3）', '港交所、GRI、国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '反腐败', 'anti_corruption_prevention_measures', '反腐败防范措施', NULL, NULL, '', '描述企业有关防止贪污、腐败、贿赂、勒索、欺诈、洗黑钱、垄断及不正当竞争等违法行为的措施、举报程序、相关执行及监察方法，如宣传活动、宣传标识、开设举报渠道等', '港交所、GRI、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '商业道德', 'embezzlement_misappropriation_two_years', '两年职务侵占与挪用事件', NULL, NULL, '', '两年内发生将公共财务或公司财务非法据为己有的事件次数', '国证 ', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, 'ESG治理', 'social_responsibility_awards_honors', '社会责任奖项及荣誉', NULL, NULL, '', '获得社会责任相关奖项或荣誉的情况', '国证 ', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '商业道德', 'negative_executive_events_two_years', '两年高管负面事件', NULL, NULL, '', '两年内管理层发生的负面事件次数', '国证 ', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '反腐败', 'anti_bribery_training_completion_rate', '反贪污和贿赂培训及达成率（%%）', NULL, NULL, '', NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '治理机制', 'senior_management_stability', '高层管理人员稳定性', NULL, NULL, '', NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '治理结构', 'shareholders_meeting', '股东大会', NULL, NULL, '', '召开的股东大会的执行情况，统计会议届次、会议决议及相关执行情况', '上交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '商业道德', 'disclosure_violations_two_years', '两年信披违规事件', NULL, NULL, '', '两年内未履行信息披露义务的事件次数', '国证 ', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '商业道德', 'litigation_amount_within_one_year', '1年以内的诉讼涉案金额', NULL, NULL, '', '在法律诉讼方面的风险暴露情况', '华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '商业道德', 'case_investigation', '立案调查', NULL, NULL, '', '是否被立案调查', '华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '治理结构', 'number_of_committees', '委员会数目', NULL, NULL, '', '公司内控制度，完善治理架构', '华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, 'ESG治理', 'stakeholder_communication_management', '利益相关方沟通管理', NULL, NULL, '', '描述公司开展的识别和回应利益相关方诉求的沟通活动', '港交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '治理机制', 'internal_control', '内部控制', NULL, NULL, '', '描述内部控制制度的建立、健全及有效运作情况，需重点说明相关内部控制缺陷及整改情况', '上交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '治理机制', 'oversight_highest_governance_body', '在管理影响方面，最高管治机构的监督作用', NULL, NULL, '', 'a.说明最高管治机构和高管在制定、批准和更新组织的宗旨、价值观或使命陈述、战略、政策以及可持续发展相关目标方面的作用；
b.说明在为识别和管理组织对经济、环境和人的影响而采取的尽职调查和其他程序方面，最高管治机构的监督作用，包括：
i 最高管治机构是否以及如何与利益相关方沟通，以支持这些流程；ii 最高管治机构如何考虑这些流程的结果', 'GRI、国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, 'ESG治理', 'board_esg_committee_setup', '董事会ESG委员会的设置', NULL, NULL, '', '董事会设置管理ESG相关问题的委员会情况', '国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, '风险管理', 'board_oversight_risk_management', '董事会监督风险管理', NULL, NULL, '', '董事会对风险管理的情况', '国证 ', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '应急管理', 'safety_emergency_measures', '安全应急措施', NULL, NULL, NULL, '公司安全应急工作的措施，包括规范应急处理流程、制定应急预案、开展应急演练等内容', '港交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '强迫或强制劳动', 'forced_labor_risk_sites_suppliers', '具有强迫或强制劳动事件重大风险的运营点和供应商', NULL, NULL, NULL, '为促进消除一切形式的强迫或强制劳动而采取的措施', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '民主权益', 'democratic_management', '民主管理', NULL, NULL, NULL, '公司结社自由与集体协商的管理方法，并描述公司依照法律规定实行民主管理的制度和方式，包括公司通过职工代表大会实行民主决策、民主参与、民主监督的管理制度和管理方式', '上交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '员工关爱', 'full_time_employee_benefits', '提供给全职员工（不包括临时或兼职员工）的福利', NULL, NULL, NULL, '对组织的全职员工提供，但不对临时或兼职员工提供的标准福利。包括：人寿保险、医疗保险、育儿假、退休金、股权（ESOP）、其他', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '职业健康与安全', 'promote_worker_health', '促进工作者健康', NULL, NULL, NULL, '为应对与工作无关的重大健康风险，组织向工作者提供的任何自愿参与的健康促进服务和计划，包括解决的具体健康风险，以及组织如何促进工作者使用这些服务和计划。', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '培训', 'annual_training_plan_completion_rate', '年度培训计划达成率（%%）', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '职业健康与安全', 'ohs_target', '保障职业健康与安全目标', NULL, NULL, NULL, '公司职业健康与安全工作的目标', 'MSCI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '多元化与平等机会', 'diversity_and_equal_opportunity', '多元化和机会平等', NULL, NULL, NULL, '公司坚持平等原则构建多元化的人才体系的措施，公平公正对待不同国籍、种族、性别、宗教信仰和文化背景的员工，提供平等发展机会等举措', '港交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, '培训', 'annual_training_plan_hours_target', '年度培训计划小时数目标', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '排放', 'volatile_organic_compounds', '挥发性有机物（VOC）', 0.01, NULL, '吨', '重大气体排放：NOx、SOx、持久性有机污染物（POP）、挥发性有机化合物（VOC）、危害性空气污染物（HAP）、颗粒物质（PM）、相关法规中确定的气体排放的其他标准类别', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '废弃物', 'recycled_epe_material', '回收料EPE', 0.01, NULL, '吨', '无害废弃物分类统计', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '水资源', 'water_resource_recovery_rate', '水资源回收利用率', 0.01, NULL, '%%', '处理后可以再次用于生产的水量/总取水量', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '废弃物', 'municipal_industrial_waste', '生活/工业垃圾', 0.01, NULL, '吨', '无害废弃物分类统计', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '废弃物', 'emission_exceedance_incidents', '排放超标事件', 1.0, NULL, '次', '工业污染物浓度超过最高允许排放标准的次数', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '排放', 'particulate_matter', '颗粒物', 0.01, NULL, '吨', '重大气体排放：NOx、SOx、持久性有机污染物（POP）、挥发性有机化合物（VOC）、危害性空气污染物（HAP）、颗粒物质（PM）、相关法规中确定的气体排放的其他标准类别', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '废弃物', 'waste_recycling_rate', '废弃物回收率', 0.01, NULL, '%%', '回收率=回收的废弃物总量/废弃物总量', 'GRI、国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '物料', 'paper_consumption_intensity', '纸张消耗强度', 0.0001, NULL, '吨/万元', '(办公)用纸量/总营收（万元）', '国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '能源', 'gasoline_consumption', '汽油使用量', 0.01, NULL, '吨', '报告期内使用的汽油总量', '港交所、GRI、国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '排放', 'total_greenhouse_gas_emissions', '温室气体排放总量', 0.01, NULL, '吨二氧化碳当量', '范围1+范围2+范围3', '港交所、GRI、国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '废弃物', 'recycled_waste', '回收的废弃物', 0.01, NULL, '吨', '可回收或再生的废弃物总量', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '排放', 'greenhouse_gas_indirect_emissions', '温室气体间接排放量（范围二）', 0.01, NULL, '吨二氧化碳当量', '温室气体盘查报告（范围2）', '港交所、GRI、国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '废弃物', 'recycled_blister_paper_plastic_materials', '回收料吸塑/纸塑', 0.01, NULL, '吨', '无害废弃物分类统计', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '废弃物', 'total_waste_generated', '废弃物总量', 0.01, NULL, '吨', '有害及无害废弃物总量', '港交所、GRI、国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '废弃物', 'wastewater_discharge_volume', '废水排放量', 0.01, NULL, '吨', '排放的废水量(企业在生产过程中产生的未经处理或经过处理后的污水)', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '物料', 'share_of_renewable_input_materials', '可再生进料占比', 0.01, NULL, '%%', '报告期内所使用的回收再利用的物料总量/报告期内使用的物料总量', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '环境管理', 'national_level_green_factory', '国家级绿色工厂', 1.0, NULL, '个', '绿色工厂总数(需要有明确的认证)', '国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, '水资源', 'total_reclaimed_water_use_intensity', '总中水用水强度', 0.01, NULL, '吨', '单位营业收入实际消耗的中水量', '华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'new_hires', '新进员工', 1.0, NULL, '人', '新进员工人数', '国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '教育和培训', 'management_trained_employees', '管理层受训人数', 1.0, NULL, '人次', '报告期内管理层受训人数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '教育和培训', 'mid_level_trained_employees', '中层员工受训人数', 1.0, NULL, '人次', '报告期内中层员工受训人数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'female_employees', '女性员工数', 1.0, NULL, '人', '报告期内女性员工数', '港交所、GRI、国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '职业健康与安全', 'work_injuries_count', '工伤数量', 1.0, NULL, '次', '工伤数量，包括受伤或死亡人数和事件次数，其中包括员工以及合同工', '国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'male_employees', '男性员工数', 1.0, NULL, '人', '报告期内男性员工数', '港交所、GRI、国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '教育和培训', 'female_trained_employees', '女性受训人数', 1.0, NULL, '人次', '报告期内女性受训人数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '教育和培训', 'staff_trained_employee_percentage', '普通受训员工百分比', 0.01, NULL, '%%', '报告期内普通员工受训人数/总人数*100%%', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '教育和培训', 'staff_trained_employees', '普通员工受训人数', 1.0, NULL, '人次', '报告期内普通员工受训人数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'staff_turnover_rate', '普通员工离职率', 0.01, NULL, '%%', '普通员工离职人数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '职业健康与安全', 'employee_safety_training_hours', '员工安全培训学时', 0.01, NULL, '小时', '向员工提供的与安全相关的培训时长', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '教育和培训', 'staff_training_hours', '普通员工受训时数', 0.01, NULL, '小时', '报告期内普通员工受训时数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, '雇佣', 'management_female_ratio', '管理层女性占比', 0.01, NULL, '%%', '高级和中级管理层女性人数与总人数之比', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '供应链管理', 'east_china_supplier_count', '华东地区供应商数', 1.0, NULL, '家', '当年实际华东地区供应商数', '港交所、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '供应链管理', 'south_china_supplier_count', '华南地区供应商数', 1.0, NULL, '家', '当年实际华南地区供应商数', '港交所、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '供应链管理', 'other_regions_supplier_count', '其他地区供应商数', 1.0, NULL, '家', '当年实际其他地区供应商数', '港交所、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '供应链管理', 'total_suppliers', '供应商总数', 1.0, NULL, '家', '供应商总数', '港交所、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '供应链管理', 'new_suppliers_screened_by_environmental_evaluation_dimension', '使用环境评价维度筛选的新供应商', 1.0, NULL, '家', '说明供应商评价使用的环境评价标准，使用环境评价维度筛选的供应商百分比', 'GRI、国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '供应链管理', 'new_suppliers_screened_by_social_standards', '使用社会标准筛选的新供应商', 1.0, NULL, '家', '对供应商针对社会影响开展尽职调查后，选定或签约的供应商百分比', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '供应链管理', 'supplier_environmental_penalty_count', '供应商环境处罚次数', 1.0, NULL, '次', '供应商受到的环境相关处罚次数', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '供应链管理', 'supplier_network_data_security_incidents', '供应商网络数据安全事件', 1.0, NULL, '起', '供应商发生网络数据安全事件的次数', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '供应链管理', 'suppliers_conducting_social_impact_assessment', '开展社会影响评估的供应商数量', 1.0, NULL, '家', '开展环境及社会影响评价的供应商', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '供应链管理', 'suppliers_conducting_environmental_impact_assessment', '开展环境影响评估的供应商数量', 1.0, NULL, '家', '开展环境及社会影响评价的供应商', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '产品责任', 'network_data_security_incidents', '网络数据安全事件', 1.0, NULL, '起', '网络安全风险及隐患的事件次数', '国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '知识产权保护', 'total_patents_acquired', '累计获得专利数量', 1.0, NULL, '项', '当年实际专利数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '知识产权保护', 'total_invention_patents', '累计发明专利数量', 1.0, NULL, '项', '当年实际发明专利数', '港交所、GRI、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '知识产权保护', 'invention_patent_applications', '发明专利申请数量', 1.0, NULL, '项', '向‌国家知识产权局提交的专利申请', '华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '知识产权保护', 'total_utility_model_patents', '累计实用新型专利数量', 1.0, NULL, '项', '当年实际实用新型专利数', '港交所、GRI、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '知识产权保护', 'total_design_patents', '累计外观设计专利数量', 1.0, NULL, '项', '当年实际外观设计专利数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '知识产权保护', 'total_granted_patents', '累计被授权专利数', 1.0, NULL, '项', '当年实际专利数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '知识产权保护', 'patents_added_this_year', '本年新增专利数量', 1.0, NULL, '项', '当年实际新增专利数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '知识产权保护', 'total_software_copyrights', '累计软件著作权数量', 1.0, NULL, '件', '当年实际软件著作权数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '知识产权保护', 'total_trademark_registrations', '累计商标注册数量', 1.0, NULL, '件', '当年实际商标注册数', '港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '志愿活动', 'volunteer_activity_participation_count', '志愿者活动参与人次', 1.0, NULL, '人次', '统计公司志愿者参与活动人次，包括公司组织的志愿服务活动、员工自发组织的志愿服务活动等', '上交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '社区参与', 'community_development_investment_amount', '社区发展投入金额', 0.01, NULL, '元', '为提升社区教育、环境、就业、文化、体育等水平方面投入的资金', 'GRI、上交所、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '志愿活动', 'total_volunteer_service_hours', '志愿者服务总时长', 0.01, NULL, '小时', '统计志愿者活动服务时长
包括上述提到的所有志愿活动的总时长', '上交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '供应链管理', 'procurement_spending_to_local_suppliers', '向当地供应商支出的采购金额', 0.01, NULL, '元', '向经营所在地的当地供应商支出', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '供应链管理', 'total_procurement_amount', '采购总金额', 0.01, NULL, '元', '总采购额', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '社区参与', 'total_charitable_and_external_donations', '公益慈善捐赠总额/对外捐赠总额', 0.01, NULL, '元', '描述公司在公益事业方面做出的贡献，分类列示在提升社会教育、环境、就业、文化、体育等方面的投入，包括公司直接、间接提供的财务支出、实物的货币价值', 'GRI、上交所、国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, '供应链管理', 'supplier_environmental_penalty_total_amount', '供应商环境处罚总额', 0.01, NULL, '元', '供应商受到的环境相关处罚总额', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '碳排放', 'greenhouse_gas_verification_system', '是否有温室气体核查体系', NULL, NULL, NULL, NULL, '华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '碳排放', 'carbon_neutrality_target_year', '碳中和目标年份', NULL, NULL, NULL, '碳中和具体目标情况', '华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '气候变化-公司战略', 'climate_risk_disclosure', '气候风险应对披露', NULL, NULL, NULL, '气候变化产生的风险与机遇的应对措施。', '华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '碳排放', 'carbon_neutrality_plan', '碳中和计划', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '碳排放', 'carbon_neutrality_target_scheme', '碳中和目标方案', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '气候变化-创新技术', 'carbon_capture_rate', '碳捕捉计划目标达成率（%%）', NULL, NULL, NULL, '', '', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '物料消耗', 'chemical_inventory', '化学品清单', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '环境机遇', 'clean_technology_practice', '清洁技术实践', NULL, NULL, NULL, '公司参与科技创新的目标及达成目标所采取的具体行动举措。包括但不限于设立科研中心/研发机构、培育新产业新业态新模式', '上交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '水资源', 'water_saving_target_rate', '水资源减排目标达成率（%%）', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '环境管理', 'environmental_emergency_plan', '环境应急预案办法', NULL, NULL, NULL, '公司为防范和应对突发环境事故方面制定的内部管理办法和应急方案，如：《环境风险防范管理制度》《突发环境事件综合应急预案》', '上交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '水资源', 'annual_reclaimed_water_use_target_rate', '年度中水使用量目标达成率（%%）', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '环境管理', 'hazardous_waste_emission_target', '有害废弃物排放总量目标', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '气候变化-公司治理', 'board_supervision', '董事会监管', NULL, NULL, NULL, '董事会对气候相关风险与机遇的监管情况', '港交所、TCFD', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '气候变化-公司战略', 'risk_opportunity_identification', '风险与机遇识别以及应对措施', NULL, NULL, NULL, '公司所识别的短、中、长期气候相关风险和机遇。
以及对气候变化产生的风险与机遇的应对措施。', 'TCFD、国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '气候变化-公司战略', 'environment_strategy', '环境战略', NULL, NULL, NULL, '公司的环境方针、发展战略等', '港交所、TCFD', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '气候变化-公司治理', 'management_responsibility', '管理层职责', NULL, NULL, NULL, '管理层在评估和管理气候相关风险和机遇方面的角色与职责', '港交所、TCFD', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '气候变化-公司战略', 'risk_matrix', '物理风险、转型风险、短期风险、长期风险矩阵', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '环境管理', 'hazardous_waste_emission_target_rate', '有害废弃物排放总量目标达成率（%%）', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '物料消耗', 'annual_packaging_material_target', '年度包装材料消耗目标', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '环境管理', 'green_office', '绿色办公', NULL, NULL, NULL, '办公活动的相关环保行动或规程，如无纸化办公', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '环境管理', 'green_factory_policy', '绿色工厂政策以及目标计划', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '气候变化-风险管理', 'business_strategy', '纳入业务策略', NULL, NULL, NULL, '气候变化相关风险的识别、评估和管理流程如何与机构的整体风险管理制度相结合', 'TCFD', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '气候变化-公司战略', 'resilience', '能力韧性', NULL, NULL, NULL, '公司的气候风险的战略适应力，并考虑不同气候相关情景', 'TCFD', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '气候变化-温室气体排放目标', 'ghg_reduction_action', '温室气体排放物减排行动', NULL, NULL, NULL, '公司为实现温室气体排放物减排目标而采取的措施', 'TCFD、港交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '气候变化-温室气体排放目标', 'ghg_reduction_rate', '温室气体减排目标达成率（%%）', NULL, NULL, NULL, '公司制定的温室气体减排目标的完成率', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '环境管理', 'environmental_resource_policy', '环境/资源使用政策', NULL, NULL, NULL, '公司自身生产经营过程中需遵守的与环境保护相关的法律、法规、部门规章、行业标准等情况，以及其他与环境保护相关的内部制度。
公司制定的在生产中有效使用资源的政策，包括原材料、能源、水等
如：《资源使用监督管理制度》', '上交所、港交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '环境管理', 'waste_product_recycling', '废旧产品回收项目', NULL, NULL, NULL, '产品整体或部件及包装的回收利用项目', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '气候变化-创新技术', 'carbon_capture_target', '碳捕捉计划目标', NULL, NULL, NULL, '', '', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '水资源', 'water_saving_action', '节水行动', NULL, NULL, NULL, '公司为了实现节水目标所采用的水资源效率提升措施', '上交所、港交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '废弃物', 'waste_reduction_action', '废弃物减排行动', NULL, NULL, NULL, '公司为了实现减废目标而采取的措施', '港交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '水资源', 'water_saving_target', '节水目标/水资源减排目标', NULL, NULL, NULL, '公司订立的节约水资源目标，同时说明减排的基准和目标年份', '港交所、国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '生物多样性保护', 'biodiversity_impact', '生物多样性影响', NULL, NULL, NULL, '组织在位于或邻近保护区和保护区外的生物多样性丰富区域拥有、租赁、管理的运营点；
活动、产品和服务对生物多样性的重大影响，报告公司对生物多样性的重大直接和间接影响，包括厂房建设造成的土地占用、污染、栖息地影响等', 'GRI、国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '气候变化-风险管理', 'risk_management_process', '管理风险流程', NULL, NULL, NULL, '公司管理气候相关风险的流程，并提供董事会（最高管理者）在这其中的角色和作用', 'TCFD', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '环境管理', 'environmental_management_system', '环境管理体系认证与披露', NULL, NULL, NULL, '环境管理体系认证情况，如ISO 14001', '国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '碳排放', 'joined_sbti', '是否加入科学碳目标SBTi', NULL, NULL, NULL, NULL, '华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '环境机遇', 'clean_technology_strategy', '清洁技术战略', NULL, NULL, NULL, '公司支持清洁技术创新的战略规划、专项制度、行动方案', '上交所、MSCI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '水资源', 'water_risk_management', '水资源风险管理', NULL, NULL, NULL, '如何管理水资源风险以及减少风险的措施', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '水资源', 'water_management_policy', '水资源管理政策', NULL, NULL, NULL, '说明污水排放质量的最低标准，对于在没有地方性排放要求的地点运营的设施，如何确定标准；任何内部制定的水质标准或准则', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '废弃物', 'waste_reduction_target', '废弃物减排目标', NULL, NULL, NULL, '公司制定的减废目标', '港交所、国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '环境管理', 'environmental_committee', '环保委员会或工作组的设置', NULL, NULL, NULL, '环境保护的委员会或工作小组的设置', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '碳排放', 'cdp_disclosure', 'CDP收据披露及说明', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '能源消耗', 'energy_saving_action_results', '能源节约行动与成果', NULL, NULL, NULL, '公司能源节约使用措施和成果，所售产品和服务的能源需求下降：通过**（新技术）实现能源消耗减少**（计量数据）', '上交所、港交所、GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '环境事故管理', 'environmental_penalty', '环境处罚', NULL, NULL, NULL, '公司收到环境保护部门行政处罚的情况，包括但不限于处罚原因、违规情形、处罚金额、对上市公司生产经营的影响以及公司的整改措施', '上交所、国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '碳排放', 'product_carbon_footprint', '产品碳足迹', NULL, NULL, NULL, '碳足迹等的披露程度/碳足迹证书ISO14067/PAS2050 ', '华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '能源消耗', 'renewable_energy_use_development', '可再生能源利用及开发', NULL, NULL, NULL, '可再生能源的开发及利用情况', '上交所、GRI、国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '水资源', 'annual_water_use_target_rate', '年度用水量目标达成率（%%）', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '生物多样性保护', 'ecological_restoration', '生态修复', NULL, NULL, NULL, '受保护或经修复的栖息地，采取的生态修复措施，如：
所有受保护或经修复的栖息地区域的规模和位置，以及修复措施的成功是否得到或得到过独立外部专业人士的认可；是否与第三方存在合作关系，以保护或修复不同于组织已监督并实施修复或保护措施的栖息地区域', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '气候变化-温室气体排放目标', 'ghg_reduction_target', '温室气体排放物减排目标', NULL, NULL, NULL, '公司制定的温室气体排放物减排目标', 'TCFD、港交所、国证 ', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '环境事故管理', 'environmental_accident', '环境事故', NULL, NULL, NULL, '公司发生环境事故的具体信息，包括：
事故发生日期、地点和持续时间；
超标或违规排放的情况。包括但不限于污染物名称和污染源分布情况，超标或违规排放次数、排放总量、最高排放浓度或强度等；
超标或违规排放对环境、社会及其他利益相关者造成的影响和损失；
超标或违规排放的原因，公司环境监测方案和风险管理措施是否存在重大缺陷；事故处理方式和处理结果，受到的处罚情况（如有），以及对公司后续生产经营的影响', '上交所', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '水资源', 'annual_water_use_target', '年度用水量目标', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '碳排放', 'carbon_neutrality_plan_rate', '碳中和计划达成率（%%）', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '物料消耗', 'annual_office_paper_target_rate', '年度办公用纸消耗量目标达成率（%%）', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '物料消耗', 'packaging_material_reduction_target', '包装材料资源降低目标', NULL, NULL, NULL, '使用产品所消耗的包装材料的节约目标以及基准、目标年份', '华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '能源消耗', 'renewable_energy_target', '可再生能源目标', NULL, NULL, NULL, '可再生能源使用目标', 'GRI', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '环境管理', 'sustainable_product_certification', '可持续产品认证与信披', NULL, NULL, NULL, '可持续产品认证情况，如FSC', '华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '碳排放', 'carbon_inventory_report_verification', '碳盘查报告验证', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '碳排放', 'carbon_inventory_disclosure', '碳盘查数据披露', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '物料消耗', 'material_reduction_target', '减少物料消耗目标', NULL, NULL, NULL, '有时间线的减少物料消耗的目标', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '碳排放', 'carbon_reduction_target', '碳减排目标', NULL, NULL, NULL, '碳减排具体目标情况，以及基准/目标年份', '华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '环境管理', 'key_pollution_unit', '列入重点排污单位', NULL, NULL, NULL, '是否被国家生态环境部门列入重点排污单位', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '物料消耗', 'chemical_management', '化学品管理', NULL, NULL, NULL, '化学品管理的流程以及化学品的仓储、运输等。', NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '物料消耗', 'annual_packaging_material_target_rate', '年度包装材料消耗目标达成率（%%）', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '气候变化-风险管理', 'risk_process', '识别、评估风险流程', NULL, NULL, NULL, '公司识别、评估气候相关风险的流程', 'TCFD', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '能源消耗', 'energy_management_system', '能源管理体系认证与信披', NULL, NULL, NULL, '是否取得ISO 50001能源管理体系认证', '国证、华证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '碳排放', 'product_carbon_footprint_plan', '产品碳足迹计划及执行情况说明', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '能源消耗', 'energy_reduction_target', '减少能源消耗目标', NULL, NULL, NULL, '有时间线的减少能源消耗的目标', '国证', true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '物料消耗', 'annual_office_paper_target', '年度办公用纸消耗量目标', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '物料消耗', 'packaging_material_reduction_target_rate', '包装材料资源降低目标达成率（%%）', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, '物料消耗', 'product_lifecycle_management', '产品生命周期管理', NULL, NULL, NULL, '减少包装（指光大同创生产的产品）在整个生命周期中对环境影响的措施', NULL, true);

