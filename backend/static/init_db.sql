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

INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ($dump$material$dump$, $dump$物料$dump$, $dump$MaterialData$dump$, $dump$环境$dump$, $dump$month$dump$, true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ($dump$energy$dump$, $dump$能源$dump$, $dump$EnergyData$dump$, $dump$环境$dump$, $dump$month$dump$, true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ($dump$water$dump$, $dump$水资源$dump$, $dump$WaterData$dump$, $dump$环境$dump$, $dump$month$dump$, true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ($dump$emission$dump$, $dump$排放$dump$, $dump$EmissionData$dump$, $dump$环境$dump$, $dump$month$dump$, true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ($dump$waste$dump$, $dump$废弃物$dump$, $dump$WasteData$dump$, $dump$环境$dump$, $dump$month$dump$, true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ($dump$investment$dump$, $dump$资金投入$dump$, $dump$InvestmentData$dump$, $dump$环境$dump$, $dump$month$dump$, true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ($dump$management$dump$, $dump$环境管理$dump$, $dump$ManagementData$dump$, $dump$环境$dump$, $dump$month$dump$, true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ($dump$employment$dump$, $dump$雇佣$dump$, $dump$EmploymentData$dump$, $dump$社会$dump$, $dump$month$dump$, true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ($dump$training$dump$, $dump$教育与培训$dump$, $dump$TrainingData$dump$, $dump$社会$dump$, $dump$month$dump$, true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ($dump$ohs$dump$, $dump$职健与安全$dump$, $dump$OHSData$dump$, $dump$社会$dump$, $dump$month$dump$, true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ($dump$satisfaction$dump$, $dump$员工满意度$dump$, $dump$SatisfactionData$dump$, $dump$社会$dump$, $dump$month$dump$, true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ($dump$supply$dump$, $dump$供应链$dump$, $dump$SupplyData$dump$, $dump$社会$dump$, $dump$month$dump$, true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ($dump$responsibility$dump$, $dump$产品责任$dump$, $dump$ResponsibilityData$dump$, $dump$社会$dump$, $dump$month$dump$, true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ($dump$ip$dump$, $dump$知识产权$dump$, $dump$IPData$dump$, $dump$社会$dump$, $dump$month$dump$, true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ($dump$community$dump$, $dump$社区参与与志愿活动$dump$, $dump$CommunityData$dump$, $dump$社会$dump$, $dump$month$dump$, true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ($dump$env_quant$dump$, $dump$定量$dump$, $dump$EnvQuantData$dump$, $dump$环境$dump$, $dump$year$dump$, true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ($dump$env_qual$dump$, $dump$定性$dump$, $dump$EnvQualData$dump$, $dump$环境$dump$, $dump$year$dump$, true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ($dump$social_quant_labor$dump$, $dump$定量-劳工$dump$, $dump$SocialQuantLaborData$dump$, $dump$社会$dump$, $dump$year$dump$, true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ($dump$social_qual_labor$dump$, $dump$定性-劳工$dump$, $dump$SocialQualLaborData$dump$, $dump$社会$dump$, $dump$year$dump$, true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ($dump$social_quant_other$dump$, $dump$定量-其他$dump$, $dump$SocialQuantOtherData$dump$, $dump$社会$dump$, $dump$year$dump$, true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ($dump$social_qual_other$dump$, $dump$定性-其他$dump$, $dump$SocialQualOtherData$dump$, $dump$社会$dump$, $dump$year$dump$, true);
INSERT INTO categories (name_en, name_zh, model_class, domain, period_type, is_active) VALUES ($dump$governance$dump$, $dump$定性$dump$, $dump$GovernanceData$dump$, $dump$治理$dump$, $dump$year$dump$, true);


CREATE TABLE community (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	charity_donations JSON, 
	community_investment JSON, 
	volunteer_participants JSON, 
	volunteer_hours JSON, 
	CONSTRAINT community_pkey PRIMARY KEY (factory, year)
);


CREATE TABLE emission (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	category_one JSON NOT NULL, 
	category_two JSON NOT NULL, 
	category_three JSON NOT NULL, 
	category_four JSON NOT NULL, 
	category_five JSON NOT NULL, 
	category_six JSON NOT NULL, 
	CONSTRAINT emission_pkey PRIMARY KEY (factory, year)
);


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
	CONSTRAINT employment_pkey PRIMARY KEY (factory, year)
);


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
	CONSTRAINT energy_pkey PRIMARY KEY (factory, year)
);


CREATE TABLE env_qual (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	indicator VARCHAR(100) NOT NULL, 
	current_text TEXT, 
	comparison_text TEXT, 
	reason TEXT, 
	CONSTRAINT env_qual_pkey PRIMARY KEY (factory, year, indicator)
);

INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$climate_risk_disclosure$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$risk_matrix$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$risk_impact$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$resilience$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$risk_process$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$risk_management_process$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$business_strategy$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$ghg_reduction_target$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$ghg_reduction_rate$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$ghg_reduction_action$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$carbon_capture_target$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$carbon_capture_rate$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$waste_reduction_target$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$waste_reduction_action$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$annual_water_use_target$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$annual_water_use_target_rate$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$annual_reclaimed_water_use_target$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$annual_reclaimed_water_use_target_rate$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$water_saving_target$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$water_saving_target_rate$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$water_management_policy$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$water_risk_management$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$water_saving_action$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$clean_technology_strategy$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$clean_technology_practice$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$biodiversity_impact$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$ecological_restoration$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$environmental_accident$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$environmental_penalty$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$environmental_management_system$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$environmental_resource_policy$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$environmental_emergency_plan$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$green_office$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$green_factory_policy$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$environmental_committee$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$key_pollution_unit$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$waste_product_recycling$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$hazardous_waste_emission_target$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$hazardous_waste_emission_target_rate$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$sustainable_product_certification$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$material_reduction_target$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$annual_packaging_material_target$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$annual_packaging_material_target_rate$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$packaging_material_reduction_target$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$packaging_material_reduction_target_rate$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$product_lifecycle_management$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$annual_office_paper_target$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$annual_office_paper_target_rate$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$chemical_management$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$chemical_inventory$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$energy_reduction_target$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$renewable_energy_target$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$renewable_energy_use_development$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$energy_saving_action_results$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$energy_management_system$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$product_carbon_footprint$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$product_carbon_footprint_plan$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$carbon_neutrality_target_year$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$carbon_neutrality_plan$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$carbon_neutrality_target_scheme$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$carbon_neutrality_plan_rate$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$carbon_reduction_target$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$joined_sbti$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$cdp_disclosure$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$carbon_inventory_disclosure$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$carbon_inventory_report_verification$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$greenhouse_gas_verification_system$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$board_supervision$dump$, $dump$$dump$, $dump$$dump$, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$environment_strategy$dump$, $dump$$dump$, $dump$$dump$, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$management_responsibility$dump$, $dump$$dump$, $dump$$dump$, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$risk_opportunity_identification$dump$, $dump$$dump$, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$climate_risk_disclosure$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$risk_matrix$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$risk_impact$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$resilience$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$risk_process$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$risk_management_process$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$business_strategy$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$ghg_reduction_target$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$ghg_reduction_rate$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$ghg_reduction_action$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$carbon_capture_target$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$carbon_capture_rate$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$waste_reduction_target$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$waste_reduction_action$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$annual_water_use_target$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$annual_water_use_target_rate$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$annual_reclaimed_water_use_target$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$annual_reclaimed_water_use_target_rate$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$water_saving_target$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$water_saving_target_rate$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$water_management_policy$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$water_risk_management$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$board_supervision$dump$, $dump$无$dump$, $dump$$dump$, $dump$$dump$);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$management_responsibility$dump$, $dump$无$dump$, $dump$$dump$, $dump$$dump$);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$environment_strategy$dump$, $dump$环境管理手册--环境方针$dump$, $dump$$dump$, $dump$$dump$);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$water_saving_action$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$clean_technology_strategy$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$clean_technology_practice$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$biodiversity_impact$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$ecological_restoration$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$environmental_accident$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$environmental_penalty$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$environmental_management_system$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$environmental_resource_policy$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$environmental_emergency_plan$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$green_office$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$green_factory_policy$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$environmental_committee$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$key_pollution_unit$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$waste_product_recycling$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$hazardous_waste_emission_target$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$hazardous_waste_emission_target_rate$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$sustainable_product_certification$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$material_reduction_target$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$annual_packaging_material_target$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$annual_packaging_material_target_rate$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$packaging_material_reduction_target$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$packaging_material_reduction_target_rate$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$product_lifecycle_management$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$annual_office_paper_target$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$annual_office_paper_target_rate$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$chemical_management$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$chemical_inventory$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$energy_reduction_target$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$renewable_energy_target$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$renewable_energy_use_development$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$energy_saving_action_results$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$energy_management_system$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$product_carbon_footprint$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$product_carbon_footprint_plan$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$carbon_neutrality_target_year$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$carbon_neutrality_plan$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$carbon_neutrality_target_scheme$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$carbon_neutrality_plan_rate$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$carbon_reduction_target$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$joined_sbti$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$cdp_disclosure$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$carbon_inventory_disclosure$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$carbon_inventory_report_verification$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$greenhouse_gas_verification_system$dump$, NULL, NULL, NULL);
INSERT INTO env_qual (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$risk_opportunity_identification$dump$, $dump$《风险和机遇控制程序》-【风险和机遇识别应对措施表】$dump$, $dump$$dump$, $dump$$dump$);


CREATE TABLE env_quant (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	indicator VARCHAR(200) NOT NULL, 
	value DOUBLE PRECISION, 
	reason TEXT, 
	CONSTRAINT env_quant_pkey PRIMARY KEY (factory, year, indicator)
);

INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$input_renewable_material_weight_or_volume$dump$, 22.0, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$input_non_renewable_material_weight_or_volume$dump$, 12.0, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$total_input_material$dump$, 34.0, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$material_consumption$dump$, 21.0, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$share_of_renewable_input_materials$dump$, 0.65, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$output_total_renewable_material$dump$, 122.0, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$total_output$dump$, 154.0, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$share_of_renewable_output$dump$, 0.79, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$packaging_materials$dump$, 32.0, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$paper$dump$, 132.0, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$packaging_material_consumption_intensity$dump$, 32.0, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$paper_consumption_intensity$dump$, 132.0, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$wood_fiber$dump$, 126.0, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$aluminum$dump$, 45.0, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$purchased_electricity$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$renewable_energy_consumption$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$coal_consumption$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$gasoline_consumption$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$diesel_consumption$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$natural_gas_consumption$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$other_energy_consumption$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$total_energy_consumption$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$energy_consumption_intensity$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$water_withdrawal_industrial$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$water_withdrawal_domestic$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$total_water_withdrawal$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$water_use_intensity$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$effluent_discharge_volume$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$water_consumption$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$recycled_water_resource_recovery_volume$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$water_resource_recovery_rate$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$total_reclaimed_water_use_intensity$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$total_reclaimed_water_use$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$total_greenhouse_gas_emissions$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$greenhouse_gas_emission_intensity$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$greenhouse_gas_direct_emissions$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$greenhouse_gas_indirect_emissions$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$value_chain_indirect_emissions_scope_3$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$volatile_organic_compounds$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$non_methane_total_hydrocarbons$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$benzene_compounds$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$particulate_matter$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$nox_sox_and_other_major_gas_emissions$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$total_hazardous_waste$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$hazardous_waste_intensity$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$recycled_epe_material$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$recycled_blister_paper_plastic_materials$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$municipal_industrial_waste$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$total_non_hazardous_waste$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$total_waste_generated$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$recycled_waste$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$waste_recycling_rate$dump$, 40.0, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$protective_product_waste_comprehensive_utilization_rate$dump$, 89.0, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$waste_sent_for_disposal$dump$, 30.0, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$wastewater_discharge_volume$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$wastewater_discharge_intensity$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$emission_exceedance_incidents$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$improper_three_wastes_disposal_incidents$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$environmental_protection_investment$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$environmental_investment_intensity$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$share_of_green_revenue$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$climate_change_r_and_d_expenditure$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$clean_technology_r_and_d_investment$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$national_level_green_factory$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$provincial_level_green_factory$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$environmental_penalty_intensity$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$environmental_penalty_amount$dump$, NULL, $dump$$dump$);
INSERT INTO env_quant (factory, year, indicator, value, reason) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$environmental_violations$dump$, NULL, $dump$$dump$);


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

INSERT INTO factories (name, address, phone, email, is_active) VALUES ($dump$安徽光大美科$dump$, NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ($dump$安徽光大同创$dump$, NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ($dump$昆山一$dump$, NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ($dump$昆山二$dump$, NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ($dump$成都厂$dump$, NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ($dump$惠阳厂$dump$, NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ($dump$厦门奔方$dump$, NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ($dump$武汉厂$dump$, NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ($dump$南昌厂$dump$, NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ($dump$越南$dump$, NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ($dump$墨西哥$dump$, NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ($dump$深圳光大$dump$, NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ($dump$沃普智选$dump$, NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ($dump$青岛音诺$dump$, NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ($dump$天津茂创$dump$, NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ($dump$合肥山秀$dump$, NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ($dump$苏州领新$dump$, NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ($dump$东莞美科同创$dump$, NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ($dump$重庆致贯$dump$, NULL, NULL, NULL, true);
INSERT INTO factories (name, address, phone, email, is_active) VALUES ($dump$苏州致贯$dump$, NULL, NULL, NULL, true);


CREATE TABLE governance (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	indicator VARCHAR(200) NOT NULL, 
	current_text TEXT, 
	comparison_text TEXT, 
	reason TEXT, 
	CONSTRAINT governance_pkey PRIMARY KEY (factory, year, indicator)
);

INSERT INTO governance (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$活动、价值链和其他业务关系$dump$, $dump$方针$dump$, $dump$to24$dump$, $dump$原因$dump$);
INSERT INTO governance (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$最高管治机构的提名与遴选$dump$, $dump$文件$dump$, $dump$$dump$, $dump$$dump$);
INSERT INTO governance (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$委员会数目$dump$, $dump$记录$dump$, $dump$$dump$, $dump$$dump$);
INSERT INTO governance (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2025, $dump$管制架构和组成$dump$, $dump$政策$dump$, $dump$to$dump$, $dump$$dump$);
INSERT INTO governance (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2021, $dump$活动、价值链和其他业务关系$dump$, $dump$$dump$, $dump$$dump$, $dump$也要$dump$);
INSERT INTO governance (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$昆山二$dump$, 2025, $dump$活动、价值链和其他业务关系$dump$, $dump$$dump$, $dump$对比$dump$, $dump$$dump$);
INSERT INTO governance (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2024, $dump$活动、价值链和其他业务关系$dump$, $dump$$dump$, $dump$$dump$, $dump$对比$dump$);
INSERT INTO governance (factory, year, indicator, current_text, comparison_text, reason) VALUES ($dump$安徽光大美科$dump$, 2020, $dump$活动、价值链和其他业务关系$dump$, $dump$$dump$, $dump$$dump$, $dump$原因$dump$);


CREATE TABLE investment (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	env_invest JSON NOT NULL, 
	clean_tech_invest JSON NOT NULL, 
	climate_invest JSON NOT NULL, 
	green_income JSON NOT NULL, 
	CONSTRAINT investment_pkey PRIMARY KEY (factory, year)
);


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
	CONSTRAINT ip_pkey PRIMARY KEY (factory, year)
);


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
	CONSTRAINT material_pkey PRIMARY KEY (factory, year)
);

INSERT INTO material (factory, year, renewable_input, non_renewable_input, renewable_output, non_renewable_output, material_consumption, wood_fiber, aluminum, packaging_material, paper_consumption) VALUES ($dump$深圳光大$dump$, 2025, $dump$[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1234, 0]$dump$::jsonb, $dump$[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 762, 0]$dump$::jsonb, $dump$[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 452, 0]$dump$::jsonb, $dump$[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 68, 0]$dump$::jsonb, $dump$[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 78, 0]$dump$::jsonb, $dump$[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 88, 0]$dump$::jsonb, $dump$[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 645, 0]$dump$::jsonb, $dump$[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 346, 0]$dump$::jsonb, $dump$[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 21, 0]$dump$::jsonb);
INSERT INTO material (factory, year, renewable_input, non_renewable_input, renewable_output, non_renewable_output, material_consumption, wood_fiber, aluminum, packaging_material, paper_consumption) VALUES ($dump$安徽光大同创$dump$, 2025, $dump$[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22, 55]$dump$::jsonb, $dump$[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 12, 0]$dump$::jsonb, $dump$[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 122, 0]$dump$::jsonb, $dump$[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32, 0]$dump$::jsonb, $dump$[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 21, 0]$dump$::jsonb, $dump$[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 126, 0]$dump$::jsonb, $dump$[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 45, 0]$dump$::jsonb, $dump$[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32, 0]$dump$::jsonb, $dump$[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 132, 0]$dump$::jsonb);


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

INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大美科2025年9月的物料数据$dump$, $dump$安徽环境组于2025-09-20 05:46:44提交了安徽光大美科2025年9月的物料数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大美科$dump$, $dump$material$dump$, $dump$factory$dump$, $dump$安徽光大美科$dump$, NULL, '2025-09-20 05:46:44.541819', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$审核$dump$, $dump$审核通过了安徽光大美科2025年9月的物料数据$dump$, $dump$陈世有于2025-09-20 06:18:29审核通过了安徽光大美科2025年9月的物料数据$dump$, $dump$factory$dump$, NULL, NULL, $dump$factory$dump$, $dump$安徽光大美科$dump$, NULL, '2025-09-20 06:18:29.107122', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$审核$dump$, $dump$驳回了安徽光大美科2025年9月的物料数据$dump$, $dump$光大同创总部于2025-09-20 07:04:00驳回了安徽光大美科2025年9月的物料数据$dump$, $dump$headquarter$dump$, NULL, NULL, $dump$factory$dump$, $dump$安徽光大美科$dump$, NULL, '2025-09-20 07:04:00.364208', true);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$审核$dump$, $dump$驳回了安徽光大美科2025年9月的物料数据$dump$, $dump$光大同创总部于2025-09-20 07:04:00驳回了安徽光大美科2025年9月的物料数据$dump$, $dump$headquarter$dump$, NULL, NULL, $dump$department$dump$, $dump$安徽光大美科$dump$, $dump$material$dump$, '2025-09-20 07:04:00.386820', true);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大美科2025年9月的物料数据$dump$, $dump$安徽环境组于2025-09-20 07:05:32提交了安徽光大美科2025年9月的物料数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大美科$dump$, $dump$material$dump$, $dump$factory$dump$, $dump$安徽光大美科$dump$, NULL, '2025-09-20 07:05:32.023924', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大美科2025年9月的物料数据$dump$, $dump$安徽环境组于2025-09-20 07:24:28提交了安徽光大美科2025年9月的物料数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大美科$dump$, $dump$material$dump$, $dump$factory$dump$, $dump$安徽光大美科$dump$, NULL, '2025-09-20 07:24:28.127094', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$审核$dump$, $dump$审核通过了安徽光大美科2025年9月的物料数据$dump$, $dump$陈世有于2025-09-20 07:24:44审核通过了安徽光大美科2025年9月的物料数据，请悉知。$dump$, $dump$factory$dump$, NULL, NULL, $dump$department$dump$, $dump$安徽光大美科$dump$, $dump$material$dump$, '2025-09-20 07:24:44.076642', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$审核$dump$, $dump$审核通过了安徽光大美科2025年9月的物料数据$dump$, $dump$陈世有于2025-09-20 07:24:44审核通过了安徽光大美科2025年9月的物料数据，请总部审核。$dump$, $dump$factory$dump$, NULL, NULL, $dump$headquarter$dump$, NULL, NULL, '2025-09-20 07:24:44.082137', true);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$审核$dump$, $dump$审核通过了安徽光大美科2025年9月的物料数据$dump$, $dump$管理员于2025-09-20 07:24:59审核通过了安徽光大美科2025年9月的物料数据$dump$, $dump$admin$dump$, NULL, NULL, $dump$factory$dump$, $dump$安徽光大美科$dump$, NULL, '2025-09-20 07:24:59.254540', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$审核$dump$, $dump$审核通过了安徽光大美科2025年9月的物料数据$dump$, $dump$管理员于2025-09-20 07:24:59审核通过了安徽光大美科2025年9月的物料数据$dump$, $dump$admin$dump$, NULL, NULL, $dump$department$dump$, $dump$安徽光大美科$dump$, $dump$material$dump$, '2025-09-20 07:24:59.260090', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$年报$dump$, $dump$提交了安徽光大美科工厂2025年的环境定量数据$dump$, $dump$陈世有于2025-09-20 15:36:43提交了安徽光大美科工厂2025年的环境定量数据，请管理员和总部及时审核。$dump$, $dump$factory$dump$, $dump$安徽光大美科$dump$, NULL, $dump$headquarter$dump$, NULL, NULL, '2025-09-20 15:36:43.960627', true);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$审核$dump$, $dump$审核通过了安徽光大美科2025年的环境定量数据$dump$, $dump$陈世有于2025-09-20 15:36:49审核通过了安徽光大美科2025年的环境定量数据$dump$, $dump$factory$dump$, NULL, NULL, $dump$factory$dump$, $dump$安徽光大美科$dump$, NULL, '2025-09-20 15:36:49.426821', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大美科2025年1月的物料数据$dump$, $dump$安徽环境组于2025-09-20 17:39:16提交了安徽光大美科2025年1月的物料数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大美科$dump$, $dump$material$dump$, $dump$factory$dump$, $dump$安徽光大美科$dump$, NULL, '2025-09-20 17:39:16.915785', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大美科2025年2月的物料数据$dump$, $dump$安徽环境组于2025-09-20 17:39:25提交了安徽光大美科2025年2月的物料数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大美科$dump$, $dump$material$dump$, $dump$factory$dump$, $dump$安徽光大美科$dump$, NULL, '2025-09-20 17:39:25.865084', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$审核$dump$, $dump$驳回了安徽光大美科2025年1月的物料数据$dump$, $dump$陈世有于2025-09-20 17:45:07驳回了安徽光大美科2025年1月的物料数据，请悉知。$dump$, $dump$factory$dump$, NULL, NULL, $dump$department$dump$, $dump$安徽光大美科$dump$, $dump$material$dump$, '2025-09-20 17:45:07.489544', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$审核$dump$, $dump$驳回了安徽光大美科2025年2月的物料数据$dump$, $dump$管理员于2025-09-22 04:06:33驳回了安徽光大美科2025年2月的物料数据$dump$, $dump$admin$dump$, NULL, NULL, $dump$factory$dump$, $dump$安徽光大美科$dump$, NULL, '2025-09-22 04:06:33.192050', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$审核$dump$, $dump$驳回了安徽光大美科2025年2月的物料数据$dump$, $dump$管理员于2025-09-22 04:06:33驳回了安徽光大美科2025年2月的物料数据$dump$, $dump$admin$dump$, NULL, NULL, $dump$department$dump$, $dump$安徽光大美科$dump$, $dump$material$dump$, '2025-09-22 04:06:33.250916', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年2月的水资源数据$dump$, $dump$安徽环境组于2025-09-24 02:46:13提交了安徽光大同创2025年2月的水资源数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$water$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-09-24 02:46:13.420640', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年1月的水资源数据$dump$, $dump$安徽环境组于2025-09-24 02:46:17提交了安徽光大同创2025年1月的水资源数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$water$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-09-24 02:46:17.025909', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年3月的水资源数据$dump$, $dump$安徽环境组于2025-09-24 02:46:21提交了安徽光大同创2025年3月的水资源数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$water$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-09-24 02:46:21.040681', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年9月的水资源数据$dump$, $dump$安徽环境组于2025-09-24 02:46:29提交了安徽光大同创2025年9月的水资源数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$water$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-09-24 02:46:29.718078', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年2月的知识产权数据$dump$, $dump$安徽环境组于2025-09-24 02:46:48提交了安徽光大同创2025年2月的知识产权数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$ip$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-09-24 02:46:48.073954', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年1月的知识产权数据$dump$, $dump$安徽环境组于2025-09-24 02:46:58提交了安徽光大同创2025年1月的知识产权数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$ip$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-09-24 02:46:58.686868', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年6月的知识产权数据$dump$, $dump$安徽环境组于2025-09-24 02:47:12提交了安徽光大同创2025年6月的知识产权数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$ip$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-09-24 02:47:12.527561', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年5月的知识产权数据$dump$, $dump$安徽环境组于2025-09-24 02:47:38提交了安徽光大同创2025年5月的知识产权数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$ip$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-09-24 02:47:38.491303', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年5月的社区参与与志愿活动数据$dump$, $dump$安徽环境组于2025-09-24 02:47:51提交了安徽光大同创2025年5月的社区参与与志愿活动数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$community$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-09-24 02:47:51.422104', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年3月的社区参与与志愿活动数据$dump$, $dump$安徽环境组于2025-09-24 02:48:02提交了安徽光大同创2025年3月的社区参与与志愿活动数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$community$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-09-24 02:48:02.983039', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年9月的教育与培训数据$dump$, $dump$安徽环境组于2025-09-24 02:48:53提交了安徽光大同创2025年9月的教育与培训数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$training$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-09-24 02:48:53.343295', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年3月的教育与培训数据$dump$, $dump$安徽环境组于2025-09-24 02:49:01提交了安徽光大同创2025年3月的教育与培训数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$training$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-09-24 02:49:01.985474', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年3月的知识产权数据$dump$, $dump$安徽环境组于2025-09-24 02:49:15提交了安徽光大同创2025年3月的知识产权数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$ip$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-09-24 02:49:15.525041', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年7月的知识产权数据$dump$, $dump$安徽环境组于2025-09-24 02:49:31提交了安徽光大同创2025年7月的知识产权数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$ip$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-09-24 02:49:31.040195', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$审核$dump$, $dump$审核通过了安徽光大同创2025年7月的知识产权数据$dump$, $dump$管理员于2025-10-16 19:56:43审核通过了安徽光大同创2025年7月的知识产权数据$dump$, $dump$admin$dump$, NULL, NULL, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-16 19:56:43.935044', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年10月的物料数据$dump$, $dump$安徽环境组于2025-10-17 23:49:56提交了安徽光大同创2025年10月的物料数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$material$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-17 23:49:56.201147', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年1月的物料数据$dump$, $dump$安徽环境组于2025-10-18 00:07:00提交了安徽光大同创2025年1月的物料数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$material$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-18 00:07:00.635193', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$审核$dump$, $dump$审核通过了安徽光大美科2025年1月的物料数据$dump$, $dump$光大同创总部于2025-10-18 00:08:06审核通过了安徽光大美科2025年1月的物料数据$dump$, $dump$headquarter$dump$, NULL, NULL, $dump$factory$dump$, $dump$安徽光大美科$dump$, NULL, '2025-10-18 00:08:06.925772', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$审核$dump$, $dump$审核通过了安徽光大美科2025年1月的物料数据$dump$, $dump$光大同创总部于2025-10-18 00:08:06审核通过了安徽光大美科2025年1月的物料数据$dump$, $dump$headquarter$dump$, NULL, NULL, $dump$department$dump$, $dump$安徽光大美科$dump$, $dump$material$dump$, '2025-10-18 00:08:06.930846', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年3月的物料数据$dump$, $dump$安徽环境组于2025-10-22 12:10:52提交了安徽光大同创2025年3月的物料数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$material$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-22 12:10:52.915399', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$年报$dump$, $dump$提交了安徽光大美科2024年的定性数据$dump$, $dump$陈世有于2025-10-25 01:08:51提交了安徽光大美科2024年的定性数据，请总部及时审核。$dump$, $dump$factory$dump$, $dump$安徽光大美科$dump$, NULL, $dump$headquarter$dump$, NULL, NULL, '2025-10-25 01:08:51.509904', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$年报$dump$, $dump$提交了安徽光大美科2024年的定性数据$dump$, $dump$陈世有于2025-10-25 01:08:51提交了安徽光大美科2024年的定性数据，请总部及时审核。$dump$, $dump$factory$dump$, $dump$安徽光大美科$dump$, NULL, $dump$admin$dump$, NULL, NULL, '2025-10-25 01:08:51.511293', true);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年10月的物料数据$dump$, $dump$安徽环境组于2025-10-25 01:13:25提交了安徽光大同创2025年10月的物料数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$material$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-25 01:13:25.078920', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年3月的物料数据$dump$, $dump$安徽环境组于2025-10-25 01:13:35提交了安徽光大同创2025年3月的物料数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$material$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-25 01:13:35.582899', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年1月的物料数据$dump$, $dump$安徽环境组于2025-10-25 01:33:16提交了安徽光大同创2025年1月的物料数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$material$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-25 01:33:16.091028', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年2月的物料数据$dump$, $dump$安徽环境组于2025-10-25 01:33:25提交了安徽光大同创2025年2月的物料数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$material$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-25 01:33:25.019282', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年4月的物料数据$dump$, $dump$安徽环境组于2025-10-25 01:36:35提交了安徽光大同创2025年4月的物料数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$material$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-25 01:36:35.074208', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年10月的能源数据$dump$, $dump$安徽环境组于2025-10-25 01:38:02提交了安徽光大同创2025年10月的能源数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$energy$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-25 01:38:02.370918', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年1月的能源数据$dump$, $dump$安徽环境组于2025-10-25 01:38:36提交了安徽光大同创2025年1月的能源数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$energy$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-25 01:38:36.615132', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年2月的能源数据$dump$, $dump$安徽环境组于2025-10-25 01:38:48提交了安徽光大同创2025年2月的能源数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$energy$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-25 01:38:48.766388', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年5月的物料数据$dump$, $dump$安徽环境组于2025-10-25 01:40:29提交了安徽光大同创2025年5月的物料数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$material$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-25 01:40:29.797519', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年6月的物料数据$dump$, $dump$安徽环境组于2025-10-25 01:40:33提交了安徽光大同创2025年6月的物料数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$material$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-25 01:40:33.441962', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年7月的物料数据$dump$, $dump$安徽环境组于2025-10-25 01:40:36提交了安徽光大同创2025年7月的物料数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$material$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-25 01:40:36.755638', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年8月的物料数据$dump$, $dump$安徽环境组于2025-10-25 01:40:40提交了安徽光大同创2025年8月的物料数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$material$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-25 01:40:40.421344', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年9月的物料数据$dump$, $dump$安徽环境组于2025-10-25 01:40:43提交了安徽光大同创2025年9月的物料数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$material$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-25 01:40:43.149613', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年11月的物料数据$dump$, $dump$安徽环境组于2025-10-25 01:40:47提交了安徽光大同创2025年11月的物料数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$material$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-25 01:40:47.461938', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年12月的物料数据$dump$, $dump$安徽环境组于2025-10-25 01:40:49提交了安徽光大同创2025年12月的物料数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$material$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-25 01:40:49.726071', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年3月的能源数据$dump$, $dump$安徽环境组于2025-10-25 01:41:05提交了安徽光大同创2025年3月的能源数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$energy$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-25 01:41:05.574785', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年4月的能源数据$dump$, $dump$安徽环境组于2025-10-25 01:41:07提交了安徽光大同创2025年4月的能源数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$energy$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-25 01:41:07.918953', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年5月的能源数据$dump$, $dump$安徽环境组于2025-10-25 01:41:11提交了安徽光大同创2025年5月的能源数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$energy$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-25 01:41:11.173953', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年6月的能源数据$dump$, $dump$安徽环境组于2025-10-25 01:41:21提交了安徽光大同创2025年6月的能源数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$energy$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-25 01:41:21.528320', true);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年7月的能源数据$dump$, $dump$安徽环境组于2025-10-25 01:41:25提交了安徽光大同创2025年7月的能源数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$energy$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-25 01:41:25.380479', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年8月的能源数据$dump$, $dump$安徽环境组于2025-10-25 01:41:28提交了安徽光大同创2025年8月的能源数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$energy$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-25 01:41:28.567257', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年9月的能源数据$dump$, $dump$安徽环境组于2025-10-25 01:41:31提交了安徽光大同创2025年9月的能源数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$energy$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-25 01:41:31.312160', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年11月的能源数据$dump$, $dump$安徽环境组于2025-10-25 01:41:41提交了安徽光大同创2025年11月的能源数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$energy$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-25 01:41:41.291157', false);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年5月的物料数据$dump$, $dump$安徽环境组于2025-10-27 13:25:26提交了安徽光大同创2025年5月的物料数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$material$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-27 13:25:26.103241', true);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了安徽光大同创2025年6月的物料数据$dump$, $dump$安徽环境组于2025-10-27 13:26:02提交了安徽光大同创2025年6月的物料数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$安徽光大同创$dump$, $dump$material$dump$, $dump$factory$dump$, $dump$安徽光大同创$dump$, NULL, '2025-10-27 13:26:02.981389', true);
INSERT INTO messages (type, title, content, sender_role, sender_factory, sender_department, receiver_role, receiver_factory, receiver_department, created_at, is_read) VALUES ($dump$月报$dump$, $dump$提交了深圳光大2025年11月的物料数据$dump$, $dump$深圳环境于2025-11-03 23:09:37提交了深圳光大2025年11月的物料数据，请工厂及时审核。$dump$, $dump$department$dump$, $dump$深圳光大$dump$, $dump$material$dump$, $dump$factory$dump$, $dump$深圳光大$dump$, NULL, '2025-11-03 23:09:37.881021', false);


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
	CONSTRAINT ohs_pkey PRIMARY KEY (factory, year)
);


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
	CONSTRAINT responsibility_pkey PRIMARY KEY (factory, year)
);


CREATE TABLE revenues (
	id SERIAL NOT NULL, 
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	amount DOUBLE PRECISION NOT NULL, 
	CONSTRAINT revenues_pkey PRIMARY KEY (id), 
	CONSTRAINT revenues_factory_key UNIQUE NULLS DISTINCT (factory)
);

INSERT INTO revenues (factory, year, amount) VALUES ($dump$安徽光大同创$dump$, 2025, 1211.75);


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

INSERT INTO review_records (factory, category, year, month, is_submitted, level1_status, level1_comment, level1_reviewer, level1_review_time, level2_status, level2_comment, level2_reviewer, level2_review_time) VALUES ($dump$安徽光大美科$dump$, 17, 2025, NULL, false, NULL, NULL, NULL, NULL, $dump$pending$dump$, NULL, NULL, NULL);
INSERT INTO review_records (factory, category, year, month, is_submitted, level1_status, level1_comment, level1_reviewer, level1_review_time, level2_status, level2_comment, level2_reviewer, level2_review_time) VALUES ($dump$安徽光大美科$dump$, 17, 2024, NULL, true, NULL, NULL, NULL, NULL, $dump$pending$dump$, NULL, NULL, NULL);
INSERT INTO review_records (factory, category, year, month, is_submitted, level1_status, level1_comment, level1_reviewer, level1_review_time, level2_status, level2_comment, level2_reviewer, level2_review_time) VALUES ($dump$安徽光大同创$dump$, 1, 2025, 10, true, $dump$pending$dump$, NULL, NULL, NULL, $dump$pending$dump$, NULL, NULL, NULL);
INSERT INTO review_records (factory, category, year, month, is_submitted, level1_status, level1_comment, level1_reviewer, level1_review_time, level2_status, level2_comment, level2_reviewer, level2_review_time) VALUES ($dump$安徽光大同创$dump$, 1, 2025, 3, true, $dump$pending$dump$, NULL, NULL, NULL, $dump$pending$dump$, NULL, NULL, NULL);
INSERT INTO review_records (factory, category, year, month, is_submitted, level1_status, level1_comment, level1_reviewer, level1_review_time, level2_status, level2_comment, level2_reviewer, level2_review_time) VALUES ($dump$安徽光大同创$dump$, 1, 2025, 1, true, $dump$pending$dump$, NULL, NULL, NULL, $dump$pending$dump$, NULL, NULL, NULL);
INSERT INTO review_records (factory, category, year, month, is_submitted, level1_status, level1_comment, level1_reviewer, level1_review_time, level2_status, level2_comment, level2_reviewer, level2_review_time) VALUES ($dump$安徽光大同创$dump$, 1, 2025, 2, true, $dump$pending$dump$, NULL, NULL, NULL, $dump$pending$dump$, NULL, NULL, NULL);
INSERT INTO review_records (factory, category, year, month, is_submitted, level1_status, level1_comment, level1_reviewer, level1_review_time, level2_status, level2_comment, level2_reviewer, level2_review_time) VALUES ($dump$安徽光大同创$dump$, 1, 2025, 4, true, $dump$pending$dump$, NULL, NULL, NULL, $dump$pending$dump$, NULL, NULL, NULL);
INSERT INTO review_records (factory, category, year, month, is_submitted, level1_status, level1_comment, level1_reviewer, level1_review_time, level2_status, level2_comment, level2_reviewer, level2_review_time) VALUES ($dump$安徽光大同创$dump$, 2, 2025, 10, true, $dump$pending$dump$, NULL, NULL, NULL, $dump$pending$dump$, NULL, NULL, NULL);
INSERT INTO review_records (factory, category, year, month, is_submitted, level1_status, level1_comment, level1_reviewer, level1_review_time, level2_status, level2_comment, level2_reviewer, level2_review_time) VALUES ($dump$安徽光大同创$dump$, 2, 2025, 1, true, $dump$pending$dump$, NULL, NULL, NULL, $dump$pending$dump$, NULL, NULL, NULL);
INSERT INTO review_records (factory, category, year, month, is_submitted, level1_status, level1_comment, level1_reviewer, level1_review_time, level2_status, level2_comment, level2_reviewer, level2_review_time) VALUES ($dump$安徽光大同创$dump$, 2, 2025, 2, true, $dump$pending$dump$, NULL, NULL, NULL, $dump$pending$dump$, NULL, NULL, NULL);
INSERT INTO review_records (factory, category, year, month, is_submitted, level1_status, level1_comment, level1_reviewer, level1_review_time, level2_status, level2_comment, level2_reviewer, level2_review_time) VALUES ($dump$安徽光大同创$dump$, 1, 2025, 5, true, $dump$pending$dump$, NULL, NULL, NULL, $dump$pending$dump$, NULL, NULL, NULL);
INSERT INTO review_records (factory, category, year, month, is_submitted, level1_status, level1_comment, level1_reviewer, level1_review_time, level2_status, level2_comment, level2_reviewer, level2_review_time) VALUES ($dump$安徽光大同创$dump$, 1, 2025, 6, true, $dump$pending$dump$, NULL, NULL, NULL, $dump$pending$dump$, NULL, NULL, NULL);
INSERT INTO review_records (factory, category, year, month, is_submitted, level1_status, level1_comment, level1_reviewer, level1_review_time, level2_status, level2_comment, level2_reviewer, level2_review_time) VALUES ($dump$安徽光大同创$dump$, 16, 2025, NULL, false, NULL, NULL, NULL, NULL, $dump$pending$dump$, NULL, NULL, NULL);
INSERT INTO review_records (factory, category, year, month, is_submitted, level1_status, level1_comment, level1_reviewer, level1_review_time, level2_status, level2_comment, level2_reviewer, level2_review_time) VALUES ($dump$安徽光大同创$dump$, 1, 2025, 11, false, $dump$pending$dump$, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO review_records (factory, category, year, month, is_submitted, level1_status, level1_comment, level1_reviewer, level1_review_time, level2_status, level2_comment, level2_reviewer, level2_review_time) VALUES ($dump$深圳光大$dump$, 1, 2025, 11, true, $dump$pending$dump$, NULL, NULL, NULL, $dump$pending$dump$, NULL, NULL, NULL);


CREATE TABLE satisfaction (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	satisfaction JSON NOT NULL, 
	CONSTRAINT satisfaction_pkey PRIMARY KEY (factory, year)
);


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
	value DOUBLE PRECISION, 
	reason TEXT, 
	CONSTRAINT social_quant_labor_pkey PRIMARY KEY (factory, year, indicator)
);


CREATE TABLE social_quant_other (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	indicator VARCHAR(100) NOT NULL, 
	value DOUBLE PRECISION, 
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

INSERT INTO users (username, hashed_password, factory, departments, role, phone, email, avatar, is_active) VALUES ($dump$管理员$dump$, $dump$$2b$12$/u6SzCo4X.yoU8WErKtlU.vn18YKp7kmVNAsaBweSqfStlxgt80ta$dump$, NULL, NULL, $dump$admin$dump$, NULL, $dump$2172449563@qq.com$dump$, $dump$/static/avatars/user_1.jpg$dump$, true);
INSERT INTO users (username, hashed_password, factory, departments, role, phone, email, avatar, is_active) VALUES ($dump$光大同创总部$dump$, $dump$$2b$12$AxkJ58D9XtYAUIF0Pib/Hu1aducKgOqDO2csTHdW1vACUdrcJuB4e$dump$, NULL, NULL, $dump$headquarter$dump$, $dump$15297790365$dump$, $dump$chensy_1213@qq.com$dump$, $dump$/static/avatars/user_2.png$dump$, true);
INSERT INTO users (username, hashed_password, factory, departments, role, phone, email, avatar, is_active) VALUES ($dump$陈世有$dump$, $dump$$2b$12$ZFWETyp24/u21lZARUvbfej5ZHvZr2oVM5u/T9Qjq0x0usIV3mKQi$dump$, $dump$深圳光大$dump$, NULL, $dump$factory$dump$, $dump$15297790365$dump$, $dump$chensy_1213@qq.com$dump$, $dump$/static/avatars/user_3.jpg$dump$, true);
INSERT INTO users (username, hashed_password, factory, departments, role, phone, email, avatar, is_active) VALUES ($dump$安徽环境组$dump$, $dump$$2b$12$IyoG0c0Xbf7T6nFWtPBBVuRKCrOUMMjrOvLyE.bBOC6SA/eYOrB1K$dump$, $dump$安徽光大同创$dump$, $dump${"name": "环境管理部", "ids": [1, 2, 3, 4, 5, 6, 7]}$dump$::jsonb, $dump$department$dump$, $dump$120$dump$, $dump$csy@qq.com$dump$, $dump$/static/avatars/user_5.png$dump$, true);
INSERT INTO users (username, hashed_password, factory, departments, role, phone, email, avatar, is_active) VALUES ($dump$安徽光大同创$dump$, $dump$$2b$12$M2RDl5WbaKsvjiU0tBWLuev1s9pjulrL2I8DUf68wQ0iZkFZIDntC$dump$, $dump$安徽光大同创$dump$, NULL, $dump$factory$dump$, $dump$120$dump$, $dump$csy@qq.com$dump$, $dump$/static/avatars/user_35.png$dump$, true);
INSERT INTO users (username, hashed_password, factory, departments, role, phone, email, avatar, is_active) VALUES ($dump$陈世有333$dump$, $dump$$2b$12$FyWh74hcWq4LpqrnDkohMu268PgcbnchEds0QRFi5WbkeriT7s.rq$dump$, $dump$安徽光大美科$dump$, NULL, $dump$factory$dump$, $dump$15297790365$dump$, $dump$chensy@qq.com$dump$, NULL, true);
INSERT INTO users (username, hashed_password, factory, departments, role, phone, email, avatar, is_active) VALUES ($dump$社会定量$dump$, $dump$$2b$12$etDPjiX/4a8VWcyN7l68QOI7IMPaBnkGeMjmmH3AhqrPnSWkounVK$dump$, $dump$沃普智选$dump$, NULL, $dump$factory$dump$, $dump$15297790365$dump$, $dump$chensy_1213@qq.com$dump$, NULL, true);
INSERT INTO users (username, hashed_password, factory, departments, role, phone, email, avatar, is_active) VALUES ($dump$深圳环境$dump$, $dump$$2b$12$.jp/JeCK9amm5JZYCX3xje7BNT1CwDE9TpSwznSzW.dKTjoudTDCm$dump$, $dump$深圳光大$dump$, $dump${"name": "科技金融部", "ids": [1, 2, 3, 4, 5]}$dump$::jsonb, $dump$department$dump$, $dump$1455563243$dump$, $dump$$dump$, NULL, true);
INSERT INTO users (username, hashed_password, factory, departments, role, phone, email, avatar, is_active) VALUES ($dump$安徽环境组2$dump$, $dump$$2b$12$/upBRdnX1SLn7TQX/boiDu72n6in3xhFwB5P2w0sSLplXkCYWFZHC$dump$, $dump$安徽光大同创$dump$, $dump${"name": "研发部", "ids": [9, 10, 1]}$dump$::jsonb, $dump$department$dump$, $dump$120$dump$, $dump$csy@qq.com$dump$, NULL, true);
INSERT INTO users (username, hashed_password, factory, departments, role, phone, email, avatar, is_active) VALUES ($dump$越南分工厂$dump$, $dump$$2b$12$Q/b09qy/8OYHKNas/045ceQYT43exKORvDYaBYBpwUxsLLZuWVX06$dump$, NULL, NULL, $dump$factory$dump$, $dump$1455563243$dump$, $dump$$dump$, NULL, true);
INSERT INTO users (username, hashed_password, factory, departments, role, phone, email, avatar, is_active) VALUES ($dump$安徽治理$dump$, $dump$$2b$12$DB6xFUvFdq5WC5K4.nNEOOgDykBjdc3GlESfKbINE4P1zZnTVt8aW$dump$, $dump$安徽光大同创$dump$, $dump${"name": "财务部", "ids": [15, 1, 2, 3]}$dump$::jsonb, $dump$department$dump$, $dump$911$dump$, $dump$$dump$, $dump$/static/avatars/default-avatar.jpg$dump$, true);


CREATE TABLE waste (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	epe JSON NOT NULL, 
	plastic_paper JSON NOT NULL, 
	domestic_industrial JSON NOT NULL, 
	hazardous JSON NOT NULL, 
	wastewater JSON NOT NULL, 
	exceed_events JSON NOT NULL, 
	recycled_waste JSON NOT NULL, 
	disposal_waste JSON NOT NULL, 
	three_wastes_incidents JSON NOT NULL, 
	CONSTRAINT waste_pkey PRIMARY KEY (factory)
);


CREATE TABLE water (
	factory VARCHAR(100) NOT NULL, 
	year INTEGER NOT NULL, 
	industrial_water_intake JSON NOT NULL, 
	domestic_water_intake JSON NOT NULL, 
	industrial_water_discharge JSON NOT NULL, 
	domestic_water_discharge JSON NOT NULL, 
	industrial_water_consumption JSON NOT NULL, 
	domestic_water_consumption JSON NOT NULL, 
	industrial_water_recycling JSON NOT NULL, 
	domestic_water_recycling JSON NOT NULL, 
	reclaimed_water_use JSON NOT NULL, 
	CONSTRAINT water_pkey PRIMARY KEY (factory, year)
);


CREATE TABLE fields (
	id SERIAL NOT NULL, 
	category INTEGER NOT NULL, 
	set VARCHAR(64) NOT NULL, 
	name_en VARCHAR(64) NOT NULL, 
	name_zh VARCHAR(64) NOT NULL, 
	step DOUBLE PRECISION, 
	calculation JSON, 
	unit VARCHAR(32), 
	description TEXT, 
	source VARCHAR(32), 
	is_active BOOLEAN NOT NULL, 
	CONSTRAINT fields_pkey PRIMARY KEY (id), 
	CONSTRAINT fields_category_fkey FOREIGN KEY(category) REFERENCES categories (id)
);

INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (1, $dump$物料进出统计$dump$, $dump$renewable_input$dump$, $dump$可再生进料量$dump$, 0.01, NULL, $dump$T$dump$, $dump$可再生进料量 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (1, $dump$物料进出统计$dump$, $dump$non_renewable_input$dump$, $dump$不可再生进料量$dump$, 0.01, NULL, $dump$T$dump$, $dump$不可再生进料量 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (1, $dump$物料进出统计$dump$, $dump$renewable_output$dump$, $dump$可再生出料量$dump$, 0.01, NULL, $dump$T$dump$, $dump$可再生出料量 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (1, $dump$物料进出统计$dump$, $dump$non_renewable_output$dump$, $dump$不可再生出料量$dump$, 0.01, NULL, $dump$T$dump$, $dump$不可再生出料量 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (1, $dump$物料进出统计$dump$, $dump$material_consumption$dump$, $dump$物料消耗量$dump$, 0.01, NULL, $dump$T$dump$, $dump$物料消耗量 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (1, $dump$物料进出统计$dump$, $dump$wood_fiber$dump$, $dump$木质纤维消耗量$dump$, 0.01, NULL, $dump$T$dump$, $dump$木质纤维消耗量 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (1, $dump$物料进出统计$dump$, $dump$aluminum$dump$, $dump$铝消耗量$dump$, 0.01, NULL, $dump$T$dump$, $dump$铝消耗量 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (1, $dump$物料进出统计$dump$, $dump$packaging_material$dump$, $dump$包装材料消耗量$dump$, 0.01, NULL, $dump$T$dump$, $dump$包装材料消耗量 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (1, $dump$物料进出统计$dump$, $dump$paper_consumption$dump$, $dump$纸张消耗量$dump$, 0.01, NULL, $dump$T$dump$, $dump$纸张消耗量 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (2, $dump$能源统计$dump$, $dump$purchased_power$dump$, $dump$外购电量$dump$, 0.01, NULL, $dump$kWh$dump$, $dump$外购电量 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (2, $dump$能源统计$dump$, $dump$renewable_power$dump$, $dump$再生能源电量$dump$, 0.01, NULL, $dump$kWh$dump$, $dump$再生能源电量 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (2, $dump$能源统计$dump$, $dump$gasoline$dump$, $dump$汽油用量$dump$, 0.01, NULL, $dump$T$dump$, $dump$汽油用量 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (2, $dump$能源统计$dump$, $dump$diesel$dump$, $dump$柴油用量$dump$, 0.01, NULL, $dump$T$dump$, $dump$柴油用量 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (2, $dump$能源统计$dump$, $dump$natural_gas$dump$, $dump$天然气用量$dump$, 0.01, NULL, $dump$T$dump$, $dump$天然气用量 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (2, $dump$能源统计$dump$, $dump$other_energy$dump$, $dump$其他能源$dump$, 0.01, NULL, $dump$Tce$dump$, $dump$其他能源 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (2, $dump$能源统计$dump$, $dump$water$dump$, $dump$水用量$dump$, 0.01, NULL, $dump$m³$dump$, $dump$水用量 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (2, $dump$能源统计$dump$, $dump$coal$dump$, $dump$煤用量$dump$, 0.01, NULL, $dump$Tce$dump$, $dump$煤用量 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (3, $dump$水资源统计$dump$, $dump$industrial_water_intake$dump$, $dump$工业取水量$dump$, 0.01, NULL, $dump$m³$dump$, $dump$工业取水量$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (3, $dump$水资源统计$dump$, $dump$domestic_water_intake$dump$, $dump$生活取水量$dump$, 0.01, NULL, $dump$m³$dump$, $dump$生活取水量$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (3, $dump$水资源统计$dump$, $dump$industrial_water_discharge$dump$, $dump$工业排水量$dump$, 0.01, NULL, $dump$m³$dump$, $dump$工业排水量$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (3, $dump$水资源统计$dump$, $dump$domestic_water_discharge$dump$, $dump$生活排水量$dump$, 0.01, NULL, $dump$m³$dump$, $dump$生活排水量$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (3, $dump$水资源统计$dump$, $dump$industrial_water_consumption$dump$, $dump$工业耗水量$dump$, 0.01, NULL, $dump$m³$dump$, $dump$工业耗水量$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (3, $dump$水资源统计$dump$, $dump$domestic_water_consumption$dump$, $dump$生活耗水量$dump$, 0.01, NULL, $dump$m³$dump$, $dump$生活耗水量$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (3, $dump$水资源统计$dump$, $dump$industrial_water_recycling$dump$, $dump$工业循环用水量$dump$, 0.01, NULL, $dump$m³$dump$, $dump$工业循环用水量$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (3, $dump$水资源统计$dump$, $dump$domestic_water_recycling$dump$, $dump$生活循环用水量$dump$, 0.01, NULL, $dump$m³$dump$, $dump$生活循环用水量$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (3, $dump$水资源统计$dump$, $dump$reclaimed_water_use$dump$, $dump$中水用水量$dump$, 0.01, NULL, $dump$m³$dump$, $dump$中水用水量$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (4, $dump$温室气体盘查统计$dump$, $dump$category_one$dump$, $dump$范畴一排放$dump$, 0.01, NULL, $dump$tCO₂e$dump$, $dump$范畴一排放$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (4, $dump$温室气体盘查统计$dump$, $dump$category_two$dump$, $dump$范畴二排放$dump$, 0.01, NULL, $dump$tCO₂e$dump$, $dump$范畴二排放$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (4, $dump$温室气体盘查统计$dump$, $dump$category_three$dump$, $dump$范畴三排放-类别三$dump$, 0.01, NULL, $dump$tCO₂e$dump$, $dump$范畴三排放$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (4, $dump$温室气体盘查统计$dump$, $dump$category_four$dump$, $dump$范畴三排放-类别四$dump$, 0.01, NULL, $dump$tCO₂e$dump$, $dump$范畴四排放$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (4, $dump$温室气体盘查统计$dump$, $dump$category_five$dump$, $dump$范畴三排放-类别五$dump$, 0.01, NULL, $dump$tCO₂e$dump$, $dump$范畴五排放$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (4, $dump$温室气体盘查统计$dump$, $dump$category_six$dump$, $dump$范畴三排放-类别六$dump$, 0.01, NULL, $dump$tCO₂e$dump$, $dump$范畴六排放$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (4, $dump$废气排放统计$dump$, $dump$voc$dump$, $dump$VOC排放$dump$, 0.01, NULL, $dump$T$dump$, $dump$挥发性有机物排放$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (4, $dump$废气排放统计$dump$, $dump$nmhc$dump$, $dump$NMHC排放$dump$, 0.01, NULL, $dump$T$dump$, $dump$非甲烷总烃排放$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (4, $dump$废气排放统计$dump$, $dump$benzene$dump$, $dump$苯排放$dump$, 0.01, NULL, $dump$T$dump$, $dump$苯排放$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (4, $dump$废气排放统计$dump$, $dump$particulate$dump$, $dump$颗粒物排放$dump$, 0.01, NULL, $dump$T$dump$, $dump$颗粒物排放$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (4, $dump$废气排放统计$dump$, $dump$nox_sox_other$dump$, $dump$氮氧化物等排放$dump$, 0.01, NULL, $dump$T$dump$, $dump$氮氧化物、硫氧化物等其他排放$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (5, $dump$废弃物统计$dump$, $dump$epe$dump$, $dump$EPE废弃物$dump$, 0.01, NULL, $dump$T$dump$, $dump$EPE废弃物 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (5, $dump$废弃物统计$dump$, $dump$plastic_paper$dump$, $dump$塑料纸张废弃物$dump$, 0.01, NULL, $dump$T$dump$, $dump$塑料纸张废弃物 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (5, $dump$废弃物统计$dump$, $dump$domestic_industrial$dump$, $dump$生活和工业废弃物$dump$, 0.01, NULL, $dump$T$dump$, $dump$生活和工业废弃物 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (5, $dump$废弃物统计$dump$, $dump$hazardous$dump$, $dump$危险废弃物$dump$, 0.01, NULL, $dump$T$dump$, $dump$危险废弃物 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (5, $dump$废弃物统计$dump$, $dump$wastewater$dump$, $dump$废水废弃物$dump$, 0.01, NULL, $dump$T$dump$, $dump$废水废弃物 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (5, $dump$废弃物统计$dump$, $dump$exceed_events$dump$, $dump$超标事件数$dump$, 1.0, NULL, $dump$次$dump$, $dump$超标事件数$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (5, $dump$废弃物统计$dump$, $dump$recycled_waste$dump$, $dump$回收废弃物$dump$, 0.01, NULL, $dump$T$dump$, $dump$可回收或再生的废弃物总量$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (5, $dump$废弃物统计$dump$, $dump$disposal_waste$dump$, $dump$处置废弃物$dump$, 0.01, NULL, $dump$T$dump$, $dump$焚烧、填埋或交由第三方处置的废弃物总量$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (5, $dump$废弃物统计$dump$, $dump$three_wastes_incidents$dump$, $dump$三废处置不当事件数$dump$, 1.0, NULL, $dump$次$dump$, $dump$废水、废气、废弃物受到监管处罚的事件次数$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (6, $dump$资金投入统计$dump$, $dump$env_invest$dump$, $dump$环保投资$dump$, 0.01, NULL, $dump$万元$dump$, $dump$环保投资 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (6, $dump$资金投入统计$dump$, $dump$clean_tech_invest$dump$, $dump$清洁技术投资$dump$, 0.01, NULL, $dump$万元$dump$, $dump$清洁技术投资 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (6, $dump$资金投入统计$dump$, $dump$climate_invest$dump$, $dump$气候相关投资$dump$, 0.01, NULL, $dump$万元$dump$, $dump$气候相关投资 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (6, $dump$资金投入统计$dump$, $dump$green_income$dump$, $dump$绿色收入$dump$, 0.01, NULL, $dump$万元$dump$, $dump$绿色收入 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (7, $dump$环境管理统计$dump$, $dump$national_green_factory$dump$, $dump$国家级绿色工厂$dump$, 1.0, NULL, $dump$个$dump$, $dump$国家级绿色工厂 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (7, $dump$环境管理统计$dump$, $dump$provincial_green_factory$dump$, $dump$省级绿色工厂$dump$, 1.0, NULL, $dump$个$dump$, $dump$省级绿色工厂 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (7, $dump$环境管理统计$dump$, $dump$environmental_penalty_amount$dump$, $dump$环境处罚金额$dump$, 0.01, NULL, $dump$万元$dump$, $dump$环境处罚金额 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (7, $dump$环境管理统计$dump$, $dump$environmental_violation$dump$, $dump$环境违规次数$dump$, 1.0, NULL, $dump$次$dump$, $dump$环境违规次数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--雇佣类型$dump$, $dump$full_time$dump$, $dump$全职员工$dump$, 1.0, NULL, $dump$人$dump$, $dump$全职员工数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--雇佣类型$dump$, $dump$part_time$dump$, $dump$兼职员工$dump$, 1.0, NULL, $dump$人$dump$, $dump$兼职员工数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--性别$dump$, $dump$male$dump$, $dump$男性员工$dump$, 1.0, NULL, $dump$人$dump$, $dump$男性员工数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--性别$dump$, $dump$female$dump$, $dump$女性员工$dump$, 1.0, NULL, $dump$人$dump$, $dump$女性员工数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--雇员类别$dump$, $dump$management$dump$, $dump$管理人员$dump$, 1.0, NULL, $dump$人$dump$, $dump$管理人员数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--雇员类别$dump$, $dump$management_female$dump$, $dump$女性管理人员$dump$, 1.0, NULL, $dump$人$dump$, $dump$女性管理人员数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--雇员类别$dump$, $dump$middle$dump$, $dump$中层员工$dump$, 1.0, NULL, $dump$人$dump$, $dump$中层员工数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--雇员类别$dump$, $dump$general$dump$, $dump$普通员工$dump$, 1.0, NULL, $dump$人$dump$, $dump$普通员工数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--地区划分$dump$, $dump$mainland$dump$, $dump$大陆员工$dump$, 1.0, NULL, $dump$人$dump$, $dump$大陆员工数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--地区划分$dump$, $dump$overseas$dump$, $dump$海外员工$dump$, 1.0, NULL, $dump$人$dump$, $dump$海外员工数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--员工学历结构$dump$, $dump$edu_phd$dump$, $dump$博士学历$dump$, 1.0, NULL, $dump$人$dump$, $dump$博士学历员工数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--员工学历结构$dump$, $dump$edu_master$dump$, $dump$硕士学历$dump$, 1.0, NULL, $dump$人$dump$, $dump$硕士学历员工数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--员工学历结构$dump$, $dump$edu_bachelor$dump$, $dump$本科学历$dump$, 1.0, NULL, $dump$人$dump$, $dump$本科学历员工数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--员工学历结构$dump$, $dump$edu_junior$dump$, $dump$大专及以下学历$dump$, 1.0, NULL, $dump$人$dump$, $dump$大专及以下学历员工数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--五险一金$dump$, $dump$avg_social_fund$dump$, $dump$平均社保公积金$dump$, 0.01, NULL, $dump$元$dump$, $dump$平均社保公积金 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--五险一金$dump$, $dump$inc_social_fund$dump$, $dump$社保公积金增长$dump$, 0.01, NULL, $dump$元$dump$, $dump$社保公积金增长 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--年龄组别$dump$, $dump$age18_30$dump$, $dump$18-30岁员工$dump$, 1.0, NULL, $dump$人$dump$, $dump$18-30岁员工数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--年龄组别$dump$, $dump$age31_45$dump$, $dump$31-45岁员工$dump$, 1.0, NULL, $dump$人$dump$, $dump$31-45岁员工数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--年龄组别$dump$, $dump$age46_60$dump$, $dump$46-60岁员工$dump$, 1.0, NULL, $dump$人$dump$, $dump$46-60岁员工数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--新招聘$dump$, $dump$new_hires$dump$, $dump$新招聘员工$dump$, 1.0, NULL, $dump$人$dump$, $dump$新招聘员工数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--性别（离职）$dump$, $dump$quit_male$dump$, $dump$男性离职员工$dump$, 1.0, NULL, $dump$人$dump$, $dump$男性离职员工数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--性别（离职）$dump$, $dump$quit_female$dump$, $dump$女性离职员工$dump$, 1.0, NULL, $dump$人$dump$, $dump$女性离职员工数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--地区类别（离职）$dump$, $dump$quit_mainland$dump$, $dump$大陆离职员工$dump$, 1.0, NULL, $dump$人$dump$, $dump$大陆离职员工数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--地区类别（离职）$dump$, $dump$quit_overseas$dump$, $dump$海外离职员工$dump$, 1.0, NULL, $dump$人$dump$, $dump$海外离职员工数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--年龄组别（离职）$dump$, $dump$quit18_30$dump$, $dump$18-30岁离职员工$dump$, 1.0, NULL, $dump$人$dump$, $dump$18-30岁离职员工数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--年龄组别（离职）$dump$, $dump$quit31_45$dump$, $dump$31-45岁离职员工$dump$, 1.0, NULL, $dump$人$dump$, $dump$31-45岁离职员工数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--年龄组别（离职）$dump$, $dump$quit46_60$dump$, $dump$46-60岁离职员工$dump$, 1.0, NULL, $dump$人$dump$, $dump$46-60岁离职员工数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--雇员类别（离职）$dump$, $dump$quit_management$dump$, $dump$管理人员离职$dump$, 1.0, NULL, $dump$人$dump$, $dump$管理人员离职数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--雇员类别（离职）$dump$, $dump$quit_middle$dump$, $dump$中层员工离职$dump$, 1.0, NULL, $dump$人$dump$, $dump$中层员工离职数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (8, $dump$员工雇佣统计--雇员类别（离职）$dump$, $dump$quit_general$dump$, $dump$普通员工离职$dump$, 1.0, NULL, $dump$人$dump$, $dump$普通员工离职数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (9, $dump$教育和培训统计$dump$, $dump$total$dump$, $dump$总人数$dump$, 1.0, NULL, $dump$人$dump$, $dump$总人数$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (9, $dump$教育和培训统计$dump$, $dump$trained$dump$, $dump$受训人数$dump$, 1.0, NULL, $dump$人$dump$, $dump$受训人数$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (9, $dump$教育和培训统计$dump$, $dump$male$dump$, $dump$男性受训人次$dump$, 1.0, NULL, $dump$人次$dump$, $dump$男性受训人次$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (9, $dump$教育和培训统计$dump$, $dump$female$dump$, $dump$女性受训人次$dump$, 1.0, NULL, $dump$人次$dump$, $dump$女性受训人次$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (9, $dump$教育和培训统计$dump$, $dump$mgmt$dump$, $dump$管理层受训人次$dump$, 1.0, NULL, $dump$人次$dump$, $dump$管理层受训人次$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (9, $dump$教育和培训统计$dump$, $dump$middle$dump$, $dump$中层受训人次$dump$, 1.0, NULL, $dump$人次$dump$, $dump$中层受训人次$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (9, $dump$教育和培训统计$dump$, $dump$general$dump$, $dump$普通员工受训人次$dump$, 1.0, NULL, $dump$人次$dump$, $dump$普通员工受训人次$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (9, $dump$教育和培训统计$dump$, $dump$hours_total$dump$, $dump$培训总学时$dump$, 0.1, NULL, $dump$小时$dump$, $dump$培训总学时$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (9, $dump$教育和培训统计$dump$, $dump$hours_male$dump$, $dump$男性学时$dump$, 0.1, NULL, $dump$小时$dump$, $dump$男性学时$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (9, $dump$教育和培训统计$dump$, $dump$hours_female$dump$, $dump$女性学时$dump$, 0.1, NULL, $dump$小时$dump$, $dump$女性学时$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (9, $dump$教育和培训统计$dump$, $dump$hours_mgmt$dump$, $dump$管理层学时$dump$, 0.1, NULL, $dump$小时$dump$, $dump$管理层学时$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (9, $dump$教育和培训统计$dump$, $dump$hours_middle$dump$, $dump$中层学时$dump$, 0.1, NULL, $dump$小时$dump$, $dump$中层学时$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (9, $dump$教育和培训统计$dump$, $dump$hours_general$dump$, $dump$普通学时$dump$, 0.1, NULL, $dump$小时$dump$, $dump$普通学时$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (10, $dump$职业健康安全统计$dump$, $dump$training_count$dump$, $dump$培训次数$dump$, 1.0, NULL, $dump$次$dump$, $dump$培训次数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (10, $dump$职业健康安全统计$dump$, $dump$training_participants$dump$, $dump$培训参与人次$dump$, 1.0, NULL, $dump$人次$dump$, $dump$培训参与人次 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (10, $dump$职业健康安全统计$dump$, $dump$training_hours$dump$, $dump$培训学时$dump$, 0.1, NULL, $dump$小时$dump$, $dump$培训学时 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (10, $dump$职业健康安全统计$dump$, $dump$injury_count$dump$, $dump$工伤数量$dump$, 1.0, NULL, $dump$次$dump$, $dump$工伤数量 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (10, $dump$职业健康安全统计$dump$, $dump$incident_count$dump$, $dump$安全事故数量$dump$, 1.0, NULL, $dump$次$dump$, $dump$安全事故数量 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (10, $dump$职业健康安全统计$dump$, $dump$fatality_count$dump$, $dump$工亡人数$dump$, 1.0, NULL, $dump$人$dump$, $dump$工亡人数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (10, $dump$职业健康安全统计$dump$, $dump$lost_workdays$dump$, $dump$工伤损失工作日数$dump$, 1.0, NULL, $dump$天$dump$, $dump$工伤损失工作日数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (10, $dump$职业健康安全统计$dump$, $dump$safety_investment$dump$, $dump$安全生产投入$dump$, 0.01, NULL, $dump$万元$dump$, $dump$安全生产投入 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (10, $dump$职业健康安全统计$dump$, $dump$safety_managers$dump$, $dump$专职安全管理人员$dump$, 1.0, NULL, $dump$人$dump$, $dump$专职安全管理人员$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (10, $dump$职业健康安全统计$dump$, $dump$medical_checks$dump$, $dump$员工体检人数$dump$, 1.0, NULL, $dump$人$dump$, $dump$员工体检人数$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (10, $dump$职业健康安全统计$dump$, $dump$emergency_drills$dump$, $dump$安全应急演练次数$dump$, 1.0, NULL, $dump$次$dump$, $dump$安全应急演练次数$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (10, $dump$职业健康安全统计$dump$, $dump$hazards_found$dump$, $dump$安全检查排查隐患数$dump$, 1.0, NULL, $dump$个$dump$, $dump$安全检查排查隐患数$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (10, $dump$职业健康安全统计$dump$, $dump$occupational_checks$dump$, $dump$职业病体检人数$dump$, 1.0, NULL, $dump$人$dump$, $dump$职业病体检人数$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (11, $dump$员工满意度调查统计$dump$, $dump$satisfaction$dump$, $dump$员工满意度$dump$, 0.01, NULL, $dump$分$dump$, $dump$员工满意度 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (12, $dump$供应商统计$dump$, $dump$east$dump$, $dump$华东地区供应商$dump$, 1.0, NULL, $dump$个$dump$, $dump$华东地区供应商数量$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (12, $dump$供应商统计$dump$, $dump$south$dump$, $dump$华南地区供应商$dump$, 1.0, NULL, $dump$个$dump$, $dump$华南地区供应商数量$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (12, $dump$供应商统计$dump$, $dump$other$dump$, $dump$其他地区供应商$dump$, 1.0, NULL, $dump$个$dump$, $dump$其他地区供应商数量$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (12, $dump$供应商统计$dump$, $dump$env_screened$dump$, $dump$环境筛选供应商$dump$, 1.0, NULL, $dump$个$dump$, $dump$环境筛选供应商数量$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (12, $dump$供应商统计$dump$, $dump$soc_screened$dump$, $dump$社会标准供应商$dump$, 1.0, NULL, $dump$个$dump$, $dump$社会标准供应商数量$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (12, $dump$供应商统计$dump$, $dump$local_amount$dump$, $dump$当地采购金额$dump$, 0.01, NULL, $dump$万元$dump$, $dump$当地采购金额$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (12, $dump$供应商统计$dump$, $dump$total_amount$dump$, $dump$各地采购金额$dump$, 0.01, NULL, $dump$万元$dump$, $dump$各地采购金额$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (12, $dump$供应商统计$dump$, $dump$env_penalty_count$dump$, $dump$环境处罚次数$dump$, 1.0, NULL, $dump$次$dump$, $dump$环境处罚次数$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (12, $dump$供应商统计$dump$, $dump$env_penalty_amount$dump$, $dump$环境处罚金额$dump$, 0.01, NULL, $dump$万元$dump$, $dump$环境处罚金额$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (12, $dump$供应商统计$dump$, $dump$cyber_incidents$dump$, $dump$数据安全事件$dump$, 1.0, NULL, $dump$次$dump$, $dump$数据安全事件次数$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (13, $dump$产品责任统计$dump$, $dump$complaints$dump$, $dump$客户投诉总数$dump$, 1.0, NULL, $dump$次$dump$, $dump$客户投诉总数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (13, $dump$产品责任统计$dump$, $dump$handled$dump$, $dump$有效处理件数$dump$, 1.0, NULL, $dump$次$dump$, $dump$有效处理件数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (13, $dump$产品责任统计$dump$, $dump$quality_issues$dump$, $dump$产品质量问题数$dump$, 1.0, NULL, $dump$次$dump$, $dump$产品质量问题数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (13, $dump$产品责任统计$dump$, $dump$recalls$dump$, $dump$产品召回次数$dump$, 1.0, NULL, $dump$次$dump$, $dump$产品召回次数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (13, $dump$产品责任统计$dump$, $dump$shipments$dump$, $dump$产品出货量$dump$, 1.0, NULL, $dump$件$dump$, $dump$产品出货量 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (13, $dump$产品责任统计$dump$, $dump$customer_satisfaction$dump$, $dump$客户满意度$dump$, 0.01, NULL, $dump$分$dump$, $dump$客户满意度 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (13, $dump$产品责任统计$dump$, $dump$cyber_incidents$dump$, $dump$网络数据安全事件$dump$, 1.0, NULL, $dump$次$dump$, $dump$网络数据安全事件 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (14, $dump$知识产权统计$dump$, $dump$patents$dump$, $dump$专利总数$dump$, 1.0, NULL, $dump$个$dump$, $dump$专利总数 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (14, $dump$知识产权统计$dump$, $dump$inv_patents$dump$, $dump$发明专利$dump$, 1.0, NULL, $dump$个$dump$, $dump$发明专利 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (14, $dump$知识产权统计$dump$, $dump$inv_applications$dump$, $dump$发明专利申请$dump$, 1.0, NULL, $dump$个$dump$, $dump$发明专利申请 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (14, $dump$知识产权统计$dump$, $dump$utility_patents$dump$, $dump$实用新型专利$dump$, 1.0, NULL, $dump$个$dump$, $dump$实用新型专利 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (14, $dump$知识产权统计$dump$, $dump$design_patents$dump$, $dump$外观设计专利$dump$, 1.0, NULL, $dump$个$dump$, $dump$外观设计专利 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (14, $dump$知识产权统计$dump$, $dump$granted_patents$dump$, $dump$被授权专利$dump$, 1.0, NULL, $dump$个$dump$, $dump$被授权专利 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (14, $dump$知识产权统计$dump$, $dump$software_copyrights$dump$, $dump$软件著作权$dump$, 1.0, NULL, $dump$个$dump$, $dump$软件著作权 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (14, $dump$知识产权统计$dump$, $dump$trademarks$dump$, $dump$商标注册$dump$, 1.0, NULL, $dump$个$dump$, $dump$商标注册 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (15, $dump$社区参与统计$dump$, $dump$charity_donations$dump$, $dump$公益慈善捐赠总额$dump$, 0.01, NULL, $dump$万元$dump$, $dump$公益慈善捐赠总额 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (15, $dump$社区参与统计$dump$, $dump$community_investment$dump$, $dump$社区发展投入金额$dump$, 0.01, NULL, $dump$万元$dump$, $dump$社区发展投入金额 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (15, $dump$社区参与统计$dump$, $dump$volunteer_participants$dump$, $dump$志愿者活动参与人次$dump$, 1.0, NULL, $dump$人次$dump$, $dump$志愿者活动参与人次 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (15, $dump$社区参与统计$dump$, $dump$volunteer_hours$dump$, $dump$志愿者服务总时长$dump$, 0.1, NULL, $dump$小时$dump$, $dump$志愿者服务总时长 (按月)$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$物料$dump$, $dump$input_renewable_material_weight_or_volume$dump$, $dump$进料-可再生料的重量或体积$dump$, 0.01, $dump${"fields": [1], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$用于生产和包装公司产品的进料的总重量：可再生材料$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$物料$dump$, $dump$input_non_renewable_material_weight_or_volume$dump$, $dump$进料-不可再生料的重量或体积$dump$, 0.01, $dump${"fields": [2], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$用于生产和包装公司产品的进料的总重量：不可再生材料$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$物料$dump$, $dump$total_input_material$dump$, $dump$进料总量$dump$, 0.01, $dump${"fields": [1, 2], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$用于生产和包装公司产品的进料的总重量$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$物料$dump$, $dump$material_consumption$dump$, $dump$物料消耗量$dump$, 0.01, $dump${"fields": [5], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$物料消耗量是进料总量的一部分$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$物料$dump$, $dump$share_of_renewable_input_materials$dump$, $dump$可再生进料占比$dump$, 0.01, $dump${"fields": [1, 143], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$报告期内所使用的回收再利用的物料总量/报告期内使用的物料总量$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$物料$dump$, $dump$output_total_renewable_material$dump$, $dump$出料-可再生料总量$dump$, 0.01, $dump${"fields": [3], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$报告期内出货料中可再生材料总量$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$物料$dump$, $dump$total_output$dump$, $dump$出料总量$dump$, 0.01, $dump${"fields": [3, 4], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$报告期内售出的产品总量$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$物料$dump$, $dump$share_of_renewable_output$dump$, $dump$可再生出料占比$dump$, 0.01, $dump${"fields": [3, 147], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$可回收再利用的产品及其包装材料/报告期内售出的产品总量$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$物料$dump$, $dump$packaging_materials$dump$, $dump$包装材料$dump$, 0.01, $dump${"fields": [8], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$总包装（用于包装、保护、运输和展示产品的各种材料）材料消耗量$dump$, $dump$国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$物料$dump$, $dump$paper$dump$, $dump$纸张$dump$, 0.01, $dump${"fields": [9], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$总(办公)纸张消耗量$dump$, $dump$国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$物料$dump$, $dump$packaging_material_consumption_intensity$dump$, $dump$包装材料消耗强度$dump$, 0.0001, $dump${"fields": [8], "operation": "强度"}$dump$::jsonb, $dump$吨/万元$dump$, $dump$总包装材料消耗量/总营收（万元）$dump$, $dump$国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$物料$dump$, $dump$paper_consumption_intensity$dump$, $dump$纸张消耗强度$dump$, 0.0001, $dump${"fields": [9], "operation": "强度"}$dump$::jsonb, $dump$吨/万元$dump$, $dump$(办公)用纸量/总营收（万元）$dump$, $dump$国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$物料$dump$, $dump$wood_fiber$dump$, $dump$木纤维$dump$, 0.01, $dump${"fields": [6], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$采购的木纤维总量$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$物料$dump$, $dump$aluminum$dump$, $dump$铝$dump$, 0.01, $dump${"fields": [7], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$采购的铝总量$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$能源$dump$, $dump$purchased_electricity$dump$, $dump$外购电量$dump$, 0.01, $dump${"fields": [10], "operation": "总和"}$dump$::jsonb, $dump$千瓦时$dump$, $dump$报告期内使用的外购电量$dump$, $dump$港交所、GRI、国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$能源$dump$, $dump$renewable_energy_consumption$dump$, $dump$可再生能源使用量$dump$, 0.01, $dump${"fields": [11], "operation": "总和"}$dump$::jsonb, $dump$千瓦时$dump$, $dump$报告期内使用的可再生能源产生的电量$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$能源$dump$, $dump$coal_consumption$dump$, $dump$煤炭使用量$dump$, 0.01, $dump${"fields": [17], "operation": "总和"}$dump$::jsonb, $dump$吨标准煤$dump$, $dump$报告期内使用的煤炭总量$dump$, $dump$港交所、GRI、国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$能源$dump$, $dump$gasoline_consumption$dump$, $dump$汽油使用量$dump$, 0.01, $dump${"fields": [12], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$报告期内使用的汽油总量$dump$, $dump$港交所、GRI、国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$能源$dump$, $dump$diesel_consumption$dump$, $dump$柴油使用量$dump$, 0.01, $dump${"fields": [13], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$报告期内使用的柴油总量$dump$, $dump$国证 $dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$能源$dump$, $dump$natural_gas_consumption$dump$, $dump$天然气使用量$dump$, 0.01, $dump${"fields": [14], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$报告期内使用的天然气总量$dump$, $dump$国证 $dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$能源$dump$, $dump$other_energy_consumption$dump$, $dump$其他能源消耗量$dump$, 0.01, $dump${"fields": [15], "operation": "总和"}$dump$::jsonb, $dump$吨标准煤$dump$, $dump$报告期内使用的其他能源总量，包括天然气、蒸汽、煤油、燃料油、液化石油气等。$dump$, $dump$港交所、GRI、国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$能源$dump$, $dump$total_energy_consumption$dump$, $dump$综合能耗 $dump$, 0.01, $dump${"fields": [10, 11, 12, 13, 14, 15, 16, 17], "operation": "总和", "coefficient ": [0.00032, 0.00032, 1.4717, 1.4571, 1.33, 1, 8.57e-05, 1]}$dump$::jsonb, $dump$吨标准煤$dump$, $dump$报告期内能源使用总量，折合为标准煤$dump$, $dump$港交所、GRI、国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$能源$dump$, $dump$energy_consumption_intensity$dump$, $dump$能源消耗强度$dump$, 0.0001, $dump${"fields": [162], "operation": "强度"}$dump$::jsonb, $dump$吨标准煤/万元$dump$, $dump$报告期内能源使用总量/报告期内营业收入$dump$, $dump$港交所、GRI、国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$水资源$dump$, $dump$water_withdrawal_industrial$dump$, $dump$取水量（工业）$dump$, 0.01, $dump${"fields": [18], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$总取水量，说明取水来源，来自地表、地下或第三方$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$水资源$dump$, $dump$water_withdrawal_domestic$dump$, $dump$取水量（生活）$dump$, 0.01, $dump${"fields": [19], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$总取水量，说明取水来源，来自地表、地下或第三方$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$水资源$dump$, $dump$total_water_withdrawal$dump$, $dump$取水总量$dump$, 0.01, $dump${"fields": [18, 19], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$总取水量，说明取水来源，来自地表、地下或第三方$dump$, $dump$国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$水资源$dump$, $dump$water_use_intensity$dump$, $dump$用水强度$dump$, 0.0001, $dump${"fields": [166], "operation": "强度"}$dump$::jsonb, $dump$吨/万元$dump$, $dump$总取水量/营业收入$dump$, $dump$国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$水资源$dump$, $dump$effluent_discharge_volume$dump$, $dump$排水量$dump$, 0.01, $dump${"fields": [20, 21], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$总排水量，说明去向，如地表、地下或第三方$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$水资源$dump$, $dump$water_consumption$dump$, $dump$耗水量$dump$, 0.01, $dump${"fields": [22, 23], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$总取水量-总排水量$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$水资源$dump$, $dump$recycled_water_resource_recovery_volume$dump$, $dump$循环水量/水资源回收利用量$dump$, 0.01, $dump${"fields": [24, 25], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$经处理后回收循环使用的水量$dump$, $dump$GRI、国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$水资源$dump$, $dump$water_resource_recovery_rate$dump$, $dump$水资源回收利用率$dump$, 0.01, $dump${"fields": [170, 166], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$处理后可以再次用于生产的水量/总取水量$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$水资源$dump$, $dump$total_reclaimed_water_use_intensity$dump$, $dump$总中水用水强度$dump$, 0.0001, $dump${"fields": [26], "operation": "强度"}$dump$::jsonb, $dump$吨$dump$, $dump$单位营业收入实际消耗的中水量$dump$, $dump$华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$水资源$dump$, $dump$total_reclaimed_water_use$dump$, $dump$总中水用水量$dump$, 0.01, $dump${"fields": [26], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$总中水(处理后的废水，可以在非饮用领域再次使用的水)用水量  循环水放在中水的统计数据里面$dump$, $dump$华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$排放$dump$, $dump$total_greenhouse_gas_emissions$dump$, $dump$温室气体排放总量$dump$, 0.01, $dump${"fields": [27, 28, 29, 30, 31, 32], "operation": "总和"}$dump$::jsonb, $dump$吨二氧化碳当量$dump$, $dump$范围1+范围2+范围3$dump$, $dump$港交所、GRI、国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$排放$dump$, $dump$greenhouse_gas_emission_intensity$dump$, $dump$温室气体排放强度$dump$, 0.0001, $dump${"fields": [174], "operation": "强度"}$dump$::jsonb, $dump$吨二氧化碳当量/万元$dump$, $dump$温室气体排放总量（吨二氧化碳当量）/营业收入（万元）$dump$, $dump$国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$排放$dump$, $dump$greenhouse_gas_direct_emissions$dump$, $dump$温室气体直接排放量(范围一）$dump$, 0.01, $dump${"fields": [27], "operation": "总和"}$dump$::jsonb, $dump$吨二氧化碳当量$dump$, $dump$温室气体盘查报告（范围1）$dump$, $dump$港交所、GRI、国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$排放$dump$, $dump$greenhouse_gas_indirect_emissions$dump$, $dump$温室气体间接排放量（范围二）$dump$, 0.01, $dump${"fields": [28], "operation": "总和"}$dump$::jsonb, $dump$吨二氧化碳当量$dump$, $dump$温室气体盘查报告（范围2）$dump$, $dump$港交所、GRI、国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$排放$dump$, $dump$value_chain_indirect_emissions_scope_3$dump$, $dump$价值链上下游各项活动的间接排放数据（范围三）$dump$, 0.01, $dump${"fields": [29, 30, 31, 32], "operation": "总和"}$dump$::jsonb, $dump$吨二氧化碳当量$dump$, $dump$温室气体盘查报告（范围3）$dump$, $dump$港交所、GRI、国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$排放$dump$, $dump$volatile_organic_compounds$dump$, $dump$挥发性有机物（VOC）$dump$, 0.01, $dump${"fields": [33], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$重大气体排放：NOx、SOx、持久性有机污染物（POP）、挥发性有机化合物（VOC）、危害性空气污染物（HAP）、颗粒物质（PM）、相关法规中确定的气体排放的其他标准类别$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$排放$dump$, $dump$non_methane_total_hydrocarbons$dump$, $dump$碳氢化合物（非甲烷总烃）$dump$, 0.01, $dump${"fields": [34], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$重大气体排放：NOx、SOx、持久性有机污染物（POP）、挥发性有机化合物（VOC）、危害性空气污染物（HAP）、颗粒物质（PM）、相关法规中确定的气体排放的其他标准类别$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$排放$dump$, $dump$benzene_compounds$dump$, $dump$苯类（苯、甲苯、二甲苯）$dump$, 0.01, $dump${"fields": [35], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$重大气体排放：NOx、SOx、持久性有机污染物（POP）、挥发性有机化合物（VOC）、危害性空气污染物（HAP）、颗粒物质（PM）、相关法规中确定的气体排放的其他标准类别$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$排放$dump$, $dump$particulate_matter$dump$, $dump$颗粒物$dump$, 0.01, $dump${"fields": [36], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$重大气体排放：NOx、SOx、持久性有机污染物（POP）、挥发性有机化合物（VOC）、危害性空气污染物（HAP）、颗粒物质（PM）、相关法规中确定的气体排放的其他标准类别$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$排放$dump$, $dump$nox_sox_and_other_major_gas_emissions$dump$, $dump$氮氧化物（NOx）、硫氧化物（SOx）和其他重大气体排放$dump$, 0.01, $dump${"fields": [37], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$重大气体排放：NOx、SOx、持久性有机污染物（POP）、挥发性有机化合物（VOC）、危害性空气污染物（HAP）、颗粒物质（PM）、相关法规中确定的气体排放的其他标准类别$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$废弃物$dump$, $dump$total_hazardous_waste$dump$, $dump$有害废弃物总量$dump$, 0.01, $dump${"fields": [41], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$有害废弃物总量$dump$, $dump$港交所、GRI、国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$废弃物$dump$, $dump$hazardous_waste_intensity$dump$, $dump$有害废弃物强度$dump$, 0.0001, $dump${"fields": [41], "operation": "强度"}$dump$::jsonb, $dump$吨/万元$dump$, $dump$有害废弃物总量/总营收(万元)$dump$, $dump$国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$废弃物$dump$, $dump$recycled_epe_material$dump$, $dump$回收料EPE$dump$, 0.01, $dump${"fields": [38], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$无害废弃物分类统计$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$废弃物$dump$, $dump$recycled_blister_paper_plastic_materials$dump$, $dump$回收料吸塑/纸塑$dump$, 0.01, $dump${"fields": [39], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$无害废弃物分类统计$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$废弃物$dump$, $dump$municipal_industrial_waste$dump$, $dump$生活/工业垃圾$dump$, 0.01, $dump${"fields": [40], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$无害废弃物分类统计$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$废弃物$dump$, $dump$total_non_hazardous_waste$dump$, $dump$无害废弃物总量$dump$, 0.01, $dump${"fields": [38, 39, 40], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$无害废弃物总量$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$废弃物$dump$, $dump$total_waste_generated$dump$, $dump$废弃物总量$dump$, 0.01, $dump${"fields": [38, 39, 40, 41], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$有害及无害废弃物总量$dump$, $dump$港交所、GRI、国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$废弃物$dump$, $dump$recycled_waste$dump$, $dump$回收的废弃物$dump$, 0.01, $dump${"fields": [44], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$可回收或再生的废弃物总量$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$废弃物$dump$, $dump$waste_recycling_rate$dump$, $dump$废弃物回收率$dump$, 0.01, $dump${"fields": [44, 190], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$回收率=回收的废弃物总量/废弃物总量$dump$, $dump$GRI、国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$废弃物$dump$, $dump$protective_product_waste_comprehensive_utilization_rate$dump$, $dump$防护类产品废弃物综合利用率$dump$, 0.01, NULL, $dump$%$dump$, $dump$防护类产品废弃物中回收利用的部分/防护类产品废弃物总量$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$废弃物$dump$, $dump$waste_sent_for_disposal$dump$, $dump$进入处置的废弃物$dump$, 0.01, $dump${"fields": [45], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$焚烧、填埋或交由第三方处置的废弃物总量$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$废弃物$dump$, $dump$wastewater_discharge_volume$dump$, $dump$废水排放量$dump$, 0.01, $dump${"fields": [42], "operation": "总和"}$dump$::jsonb, $dump$吨$dump$, $dump$排放的废水量(企业在生产过程中产生的未经处理或经过处理后的污水)$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$废弃物$dump$, $dump$wastewater_discharge_intensity$dump$, $dump$废水排放强度$dump$, 0.0001, $dump${"fields": [195], "operation": "强度"}$dump$::jsonb, $dump$吨/万元$dump$, $dump$废水排放量/总营收(万元)$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$废弃物$dump$, $dump$emission_exceedance_incidents$dump$, $dump$排放超标事件$dump$, 1.0, $dump${"fields": [43], "operation": "总和"}$dump$::jsonb, $dump$次$dump$, $dump$工业污染物浓度超过最高允许排放标准的次数$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$废弃物$dump$, $dump$improper_three_wastes_disposal_incidents$dump$, $dump$三废处置不当事件$dump$, 1.0, $dump${"fields": [46], "operation": "总和"}$dump$::jsonb, $dump$次$dump$, $dump$废水、废气、废弃物受到监管处罚的事件次数$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$资金投入$dump$, $dump$environmental_protection_investment$dump$, $dump$环保资金投入$dump$, 0.01, $dump${"fields": [47], "operation": "总和"}$dump$::jsonb, $dump$万元$dump$, $dump$包括环保设施建设费、环保设施运行和维护费用、建设项目环评费用、清洁生产审核费用、废弃物处置费用、环境监测费、排污费和污水处理费、环保培训费等$dump$, $dump$上交所、国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$资金投入$dump$, $dump$environmental_investment_intensity$dump$, $dump$环保投入强度$dump$, 0.0001, $dump${"fields": [199], "operation": "强度"}$dump$::jsonb, $dump$%$dump$, $dump$环境保护方面的总投入/公司总营收$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$资金投入$dump$, $dump$share_of_green_revenue$dump$, $dump$绿色收入占比$dump$, 0.01, $dump${"fields": [50], "operation": "强度"}$dump$::jsonb, $dump$%$dump$, $dump$绿色收入(通过销售环保产品、提供环保服务或实施绿色项目、绿色转绿所获得的收入)/总收入$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$资金投入$dump$, $dump$climate_change_r_and_d_expenditure$dump$, $dump$气候变化的研发金额$dump$, 0.01, $dump${"fields": [49], "operation": "总和"}$dump$::jsonb, $dump$万元$dump$, $dump$针对气候变化问题投入的研发金额$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$资金投入$dump$, $dump$clean_technology_r_and_d_investment$dump$, $dump$清洁技术研发投入$dump$, 0.01, $dump${"fields": [48], "operation": "总和"}$dump$::jsonb, $dump$万元$dump$, $dump$公司在产品、技术、材料、工艺、标准的研究、开发过程中发生的各项费用，需剔除各种财政科技经费补助$dump$, $dump$MSCI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$环境管理$dump$, $dump$national_level_green_factory$dump$, $dump$国家级绿色工厂$dump$, 1.0, $dump${"fields": [51], "operation": "总和"}$dump$::jsonb, $dump$个$dump$, $dump$绿色工厂总数(需要有明确的认证)$dump$, $dump$国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$环境管理$dump$, $dump$provincial_level_green_factory$dump$, $dump$省级绿色工厂$dump$, 1.0, $dump${"fields": [52], "operation": "总和"}$dump$::jsonb, $dump$个$dump$, $dump$绿色工厂总数(需要有明确的认证)$dump$, $dump$华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$环境管理$dump$, $dump$environmental_penalty_intensity$dump$, $dump$环境处罚强度$dump$, 0.0001, $dump${"fields": [53], "operation": "强度"}$dump$::jsonb, $dump$%$dump$, $dump$环境相关处罚总额（单位万元）与总营收（单位百万元）之比$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$环境管理$dump$, $dump$environmental_penalty_amount$dump$, $dump$环境处罚额$dump$, 0.01, $dump${"fields": [53], "operation": "总和"}$dump$::jsonb, $dump$万元$dump$, $dump$环境相关处罚总额$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (16, $dump$环境管理$dump$, $dump$environmental_violations$dump$, $dump$环境违规$dump$, 1.0, $dump${"fields": [54], "operation": "总和"}$dump$::jsonb, $dump$次$dump$, $dump$违反环保规定或受到环境监管机构处罚的次数$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$气候变化-公司治理$dump$, $dump$board_supervision$dump$, $dump$董事会监管$dump$, NULL, NULL, NULL, $dump$董事会对气候相关风险与机遇的监管情况$dump$, $dump$港交所、TCFD$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$气候变化-公司治理$dump$, $dump$management_responsibility$dump$, $dump$管理层职责$dump$, NULL, NULL, NULL, $dump$管理层在评估和管理气候相关风险和机遇方面的角色与职责$dump$, $dump$港交所、TCFD$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$气候变化-公司战略$dump$, $dump$environment_strategy$dump$, $dump$环境战略$dump$, NULL, NULL, NULL, $dump$公司的环境方针、发展战略等$dump$, $dump$港交所、TCFD$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$气候变化-公司战略$dump$, $dump$risk_opportunity_identification$dump$, $dump$风险与机遇识别以及应对措施$dump$, NULL, NULL, NULL, $dump$公司所识别的短、中、长期气候相关风险和机遇。以及对气候变化产生的风险与机遇的应对措施。$dump$, $dump$TCFD、国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$气候变化-公司战略$dump$, $dump$climate_risk_disclosure$dump$, $dump$气候风险应对披露$dump$, NULL, NULL, NULL, $dump$气候变化产生的风险与机遇的应对措施。$dump$, $dump$华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$气候变化-公司战略$dump$, $dump$risk_matrix$dump$, $dump$物理风险、转型风险、短期风险、长期风险矩阵$dump$, NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$气候变化-公司战略$dump$, $dump$risk_impact$dump$, $dump$风险影响$dump$, NULL, NULL, NULL, $dump$气候相关风险和机遇对公司的业务、战略的影响气候相关风险风险和机遇为公司经营、收入或支出带来的重大变化$dump$, $dump$港交所、GRI、TCFD$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$气候变化-公司战略$dump$, $dump$resilience$dump$, $dump$能力韧性$dump$, NULL, NULL, NULL, $dump$公司的气候风险的战略适应力，并考虑不同气候相关情景$dump$, $dump$TCFD$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$气候变化-风险管理$dump$, $dump$risk_process$dump$, $dump$识别、评估风险流程$dump$, NULL, NULL, NULL, $dump$公司识别、评估气候相关风险的流程$dump$, $dump$TCFD$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$气候变化-风险管理$dump$, $dump$risk_management_process$dump$, $dump$管理风险流程$dump$, NULL, NULL, NULL, $dump$公司管理气候相关风险的流程，并提供董事会（最高管理者）在这其中的角色和作用$dump$, $dump$TCFD$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$气候变化-风险管理$dump$, $dump$business_strategy$dump$, $dump$纳入业务策略$dump$, NULL, NULL, NULL, $dump$气候变化相关风险的识别、评估和管理流程如何与机构的整体风险管理制度相结合$dump$, $dump$TCFD$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$气候变化-温室气体排放目标$dump$, $dump$ghg_reduction_target$dump$, $dump$温室气体排放物减排目标$dump$, NULL, NULL, NULL, $dump$公司制定的温室气体排放物减排目标$dump$, $dump$TCFD、港交所、国证 $dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$气候变化-温室气体排放目标$dump$, $dump$ghg_reduction_rate$dump$, $dump$温室气体减排目标达成率（%）$dump$, NULL, NULL, NULL, $dump$公司制定的温室气体减排目标的完成率$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$气候变化-温室气体排放目标$dump$, $dump$ghg_reduction_action$dump$, $dump$温室气体排放物减排行动$dump$, NULL, NULL, NULL, $dump$公司为实现温室气体排放物减排目标而采取的措施$dump$, $dump$TCFD、港交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$气候变化-创新技术$dump$, $dump$carbon_capture_target$dump$, $dump$碳捕捉计划目标$dump$, NULL, NULL, NULL, $dump$$dump$, $dump$$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$气候变化-创新技术$dump$, $dump$carbon_capture_rate$dump$, $dump$碳捕捉计划目标达成率（%）$dump$, NULL, NULL, NULL, $dump$$dump$, $dump$$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$废弃物$dump$, $dump$waste_reduction_target$dump$, $dump$废弃物减排目标$dump$, NULL, NULL, NULL, $dump$公司制定的减废目标$dump$, $dump$港交所、国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$废弃物$dump$, $dump$waste_reduction_action$dump$, $dump$废弃物减排行动$dump$, NULL, NULL, NULL, $dump$公司为了实现减废目标而采取的措施$dump$, $dump$港交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$水资源$dump$, $dump$annual_water_use_target$dump$, $dump$年度用水量目标$dump$, NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$水资源$dump$, $dump$annual_water_use_target_rate$dump$, $dump$年度用水量目标达成率（%）$dump$, NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$水资源$dump$, $dump$annual_reclaimed_water_use_target$dump$, $dump$年度中水使用量目标$dump$, NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$水资源$dump$, $dump$annual_reclaimed_water_use_target_rate$dump$, $dump$年度中水使用量目标达成率（%）$dump$, NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$水资源$dump$, $dump$water_saving_target$dump$, $dump$节水目标/水资源减排目标$dump$, NULL, NULL, NULL, $dump$公司订立的节约水资源目标，同时说明减排的基准和目标年份$dump$, $dump$港交所、国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$水资源$dump$, $dump$water_saving_target_rate$dump$, $dump$水资源减排目标达成率（%）$dump$, NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$水资源$dump$, $dump$water_management_policy$dump$, $dump$水资源管理政策$dump$, NULL, NULL, NULL, $dump$说明污水排放质量的最低标准，对于在没有地方性排放要求的地点运营的设施，如何确定标准；任何内部制定的水质标准或准则$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$水资源$dump$, $dump$water_risk_management$dump$, $dump$水资源风险管理$dump$, NULL, NULL, NULL, $dump$如何管理水资源风险以及减少风险的措施$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$水资源$dump$, $dump$water_saving_action$dump$, $dump$节水行动$dump$, NULL, NULL, NULL, $dump$公司为了实现节水目标所采用的水资源效率提升措施$dump$, $dump$上交所、港交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$环境机遇$dump$, $dump$clean_technology_strategy$dump$, $dump$清洁技术战略$dump$, NULL, NULL, NULL, $dump$公司支持清洁技术创新的战略规划、专项制度、行动方案$dump$, $dump$上交所、MSCI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$环境机遇$dump$, $dump$clean_technology_practice$dump$, $dump$清洁技术实践$dump$, NULL, NULL, NULL, $dump$公司参与科技创新的目标及达成目标所采取的具体行动举措。包括但不限于设立科研中心/研发机构、培育新产业新业态新模式$dump$, $dump$上交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$生物多样性保护$dump$, $dump$biodiversity_impact$dump$, $dump$生物多样性影响$dump$, NULL, NULL, NULL, $dump$组织在位于或邻近保护区和保护区外的生物多样性丰富区域拥有、租赁、管理的运营点；活动、产品和服务对生物多样性的重大影响，报告公司对生物多样性的重大直接和间接影响，包括厂房建设造成的土地占用、污染、栖息地影响等$dump$, $dump$GRI、国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$生物多样性保护$dump$, $dump$ecological_restoration$dump$, $dump$生态修复$dump$, NULL, NULL, NULL, $dump$受保护或经修复的栖息地，采取的生态修复措施，如：所有受保护或经修复的栖息地区域的规模和位置，以及修复措施的成功是否得到或得到过独立外部专业人士的认可；是否与第三方存在合作关系，以保护或修复不同于组织已监督并实施修复或保护措施的栖息地区域$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$环境事故管理$dump$, $dump$environmental_accident$dump$, $dump$环境事故$dump$, NULL, NULL, NULL, $dump$公司发生环境事故的具体信息，包括：事故发生日期、地点和持续时间超标或违规排放的情况。包括但不限于污染物名称和污染源分布情况，超标或违规排放次数、排放总量、最高排放浓度或强度等；超标或违规排放对环境、社会及其他利益相关者造成的影响和损失；超标或违规排放的原因，公司环境监测方案和风险管理措施是否存在重大缺陷；事故处理方式和处理结果，受到的处罚情况（如有），以及对公司后续生产经营的影响$dump$, $dump$上交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$环境事故管理$dump$, $dump$environmental_penalty$dump$, $dump$环境处罚$dump$, NULL, NULL, NULL, $dump$公司收到环境保护部门行政处罚的情况，包括但不限于处罚原因、违规情形、处罚金额、对上市公司生产经营的影响以及公司的整改措施$dump$, $dump$上交所、国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$环境管理$dump$, $dump$environmental_management_system$dump$, $dump$环境管理体系认证与披露$dump$, NULL, NULL, NULL, $dump$环境管理体系认证情况，如ISO 14001$dump$, $dump$国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$环境管理$dump$, $dump$environmental_resource_policy$dump$, $dump$环境/资源使用政策$dump$, NULL, NULL, NULL, $dump$公司自身生产经营过程中需遵守的与环境保护相关的法律、法规、部门规章、行业标准等情况，以及其他与环境保护相关的内部制度。公司制定的在生产中有效使用资源的政策，包括原材料、能源、水等如：《资源使用监督管理制度》$dump$, $dump$上交所、港交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$环境管理$dump$, $dump$environmental_emergency_plan$dump$, $dump$环境应急预案办法$dump$, NULL, NULL, NULL, $dump$公司为防范和应对突发环境事故方面制定的内部管理办法和应急方案，如：《环境风险防范管理制度》《突发环境事件综合应急预案》$dump$, $dump$上交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$环境管理$dump$, $dump$green_office$dump$, $dump$绿色办公$dump$, NULL, NULL, NULL, $dump$办公活动的相关环保行动或规程，如无纸化办公$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$环境管理$dump$, $dump$green_factory_policy$dump$, $dump$绿色工厂政策以及目标计划$dump$, NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$环境管理$dump$, $dump$environmental_committee$dump$, $dump$环保委员会或工作组的设置$dump$, NULL, NULL, NULL, $dump$环境保护的委员会或工作小组的设置$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$环境管理$dump$, $dump$key_pollution_unit$dump$, $dump$列入重点排污单位$dump$, NULL, NULL, NULL, $dump$是否被国家生态环境部门列入重点排污单位$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$环境管理$dump$, $dump$waste_product_recycling$dump$, $dump$废旧产品回收项目$dump$, NULL, NULL, NULL, $dump$产品整体或部件及包装的回收利用项目$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$环境管理$dump$, $dump$hazardous_waste_emission_target$dump$, $dump$有害废弃物排放总量目标$dump$, NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$环境管理$dump$, $dump$hazardous_waste_emission_target_rate$dump$, $dump$有害废弃物排放总量目标达成率（%）$dump$, NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$环境管理$dump$, $dump$sustainable_product_certification$dump$, $dump$可持续产品认证与信披$dump$, NULL, NULL, NULL, $dump$可持续产品认证情况，如FSC$dump$, $dump$华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$物料消耗$dump$, $dump$material_reduction_target$dump$, $dump$减少物料消耗目标$dump$, NULL, NULL, NULL, $dump$有时间线的减少物料消耗的目标$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$物料消耗$dump$, $dump$annual_packaging_material_target$dump$, $dump$年度包装材料消耗目标$dump$, NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$物料消耗$dump$, $dump$annual_packaging_material_target_rate$dump$, $dump$年度包装材料消耗目标达成率（%）$dump$, NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$物料消耗$dump$, $dump$packaging_material_reduction_target$dump$, $dump$包装材料资源降低目标$dump$, NULL, NULL, NULL, $dump$使用产品所消耗的包装材料的节约目标以及基准、目标年份$dump$, $dump$华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$物料消耗$dump$, $dump$packaging_material_reduction_target_rate$dump$, $dump$包装材料资源降低目标达成率（%）$dump$, NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$物料消耗$dump$, $dump$product_lifecycle_management$dump$, $dump$产品生命周期管理$dump$, NULL, NULL, NULL, $dump$减少包装（指光大同创生产的产品）在整个生命周期中对环境影响的措施$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$物料消耗$dump$, $dump$annual_office_paper_target$dump$, $dump$年度办公用纸消耗量目标$dump$, NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$物料消耗$dump$, $dump$annual_office_paper_target_rate$dump$, $dump$年度办公用纸消耗量目标达成率（%）$dump$, NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$物料消耗$dump$, $dump$chemical_management$dump$, $dump$化学品管理$dump$, NULL, NULL, NULL, $dump$化学品管理的流程以及化学品的仓储、运输等。$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$物料消耗$dump$, $dump$chemical_inventory$dump$, $dump$化学品清单$dump$, NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$能源消耗$dump$, $dump$energy_reduction_target$dump$, $dump$减少能源消耗目标$dump$, NULL, NULL, NULL, $dump$有时间线的减少能源消耗的目标$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$能源消耗$dump$, $dump$renewable_energy_target$dump$, $dump$可再生能源目标$dump$, NULL, NULL, NULL, $dump$可再生能源使用目标$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$能源消耗$dump$, $dump$renewable_energy_use_development$dump$, $dump$可再生能源利用及开发$dump$, NULL, NULL, NULL, $dump$可再生能源的开发及利用情况$dump$, $dump$上交所、GRI、国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$能源消耗$dump$, $dump$energy_saving_action_results$dump$, $dump$能源节约行动与成果$dump$, NULL, NULL, NULL, $dump$公司能源节约使用措施和成果，所售产品和服务的能源需求下降：通过**（新技术）实现能源消耗减少**（计量数据）$dump$, $dump$上交所、港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$能源消耗$dump$, $dump$energy_management_system$dump$, $dump$能源管理体系认证与信披$dump$, NULL, NULL, NULL, $dump$是否取得ISO 50001能源管理体系认证$dump$, $dump$国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$碳排放$dump$, $dump$product_carbon_footprint$dump$, $dump$产品碳足迹$dump$, NULL, NULL, NULL, $dump$碳足迹等的披露程度/碳足迹证书ISO14067/PAS2050 $dump$, $dump$华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$碳排放$dump$, $dump$product_carbon_footprint_plan$dump$, $dump$产品碳足迹计划及执行情况说明$dump$, NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$碳排放$dump$, $dump$carbon_neutrality_target_year$dump$, $dump$碳中和目标年份$dump$, NULL, NULL, NULL, $dump$碳中和具体目标情况$dump$, $dump$华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$碳排放$dump$, $dump$carbon_neutrality_plan$dump$, $dump$碳中和计划$dump$, NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$碳排放$dump$, $dump$carbon_neutrality_target_scheme$dump$, $dump$碳中和目标方案$dump$, NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$碳排放$dump$, $dump$carbon_neutrality_plan_rate$dump$, $dump$碳中和计划达成率（%）$dump$, NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$碳排放$dump$, $dump$carbon_reduction_target$dump$, $dump$碳减排目标$dump$, NULL, NULL, NULL, $dump$碳减排具体目标情况，以及基准/目标年份$dump$, $dump$华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$碳排放$dump$, $dump$joined_sbti$dump$, $dump$是否加入科学碳目标SBTi$dump$, NULL, NULL, NULL, NULL, $dump$华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$碳排放$dump$, $dump$cdp_disclosure$dump$, $dump$CDP收据披露及说明$dump$, NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$碳排放$dump$, $dump$carbon_inventory_disclosure$dump$, $dump$碳盘查数据披露$dump$, NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$碳排放$dump$, $dump$carbon_inventory_report_verification$dump$, $dump$碳盘查报告验证$dump$, NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (17, $dump$碳排放$dump$, $dump$greenhouse_gas_verification_system$dump$, $dump$是否有温室气体核查体系$dump$, NULL, NULL, NULL, NULL, $dump$华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$total_employees$dump$, $dump$员工总数（人）$dump$, 1.0, $dump${"fields": [55, 56], "operation": "总和"}$dump$::jsonb, $dump$人$dump$, $dump$报告期内员工总数$dump$, $dump$港交所、GRI、国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$full_time_employees$dump$, $dump$全职员工数$dump$, 1.0, $dump${"fields": [55], "operation": "总和"}$dump$::jsonb, $dump$人$dump$, $dump$报告期内全职员工数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$part_time_employees$dump$, $dump$兼职员工数$dump$, 1.0, $dump${"fields": [56], "operation": "总和"}$dump$::jsonb, $dump$人$dump$, $dump$报告期内兼职员工数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$male_employees$dump$, $dump$男性员工数$dump$, 1.0, $dump${"fields": [57], "operation": "总和"}$dump$::jsonb, $dump$人$dump$, $dump$报告期内男性员工数$dump$, $dump$港交所、GRI、国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$female_employees$dump$, $dump$女性员工数$dump$, 1.0, $dump${"fields": [58], "operation": "总和"}$dump$::jsonb, $dump$人$dump$, $dump$报告期内女性员工数$dump$, $dump$港交所、GRI、国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$management_count$dump$, $dump$管理层人数$dump$, 1.0, $dump${"fields": [59], "operation": "总和"}$dump$::jsonb, $dump$人$dump$, $dump$报告期内管理层人数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$mid_level_employees$dump$, $dump$中层员工数$dump$, 1.0, $dump${"fields": [61], "operation": "总和"}$dump$::jsonb, $dump$人$dump$, $dump$报告期内中层员工数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$general_staff_count$dump$, $dump$普通员工数$dump$, 1.0, $dump${"fields": [62], "operation": "总和"}$dump$::jsonb, $dump$人$dump$, $dump$报告期内普通员工数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$mainland_china_employees$dump$, $dump$中国大陆员工数$dump$, 1.0, $dump${"fields": [63], "operation": "总和"}$dump$::jsonb, $dump$人$dump$, $dump$报告期内中国大陆员工数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$overseas_employees$dump$, $dump$海外员工数$dump$, 1.0, $dump${"fields": [64], "operation": "总和"}$dump$::jsonb, $dump$人$dump$, $dump$报告期内海外员工数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$employees_18_30$dump$, $dump$18-30岁员工数$dump$, 1.0, $dump${"fields": [71], "operation": "总和"}$dump$::jsonb, $dump$人$dump$, $dump$报告期内18-30岁员工数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$employees_31_45$dump$, $dump$31-45岁员工数$dump$, 1.0, $dump${"fields": [72], "operation": "总和"}$dump$::jsonb, $dump$人$dump$, $dump$报告期内31-45岁员工数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$employees_46_60$dump$, $dump$46-60岁员工数$dump$, 1.0, $dump${"fields": [73], "operation": "总和"}$dump$::jsonb, $dump$人$dump$, $dump$报告期内46-60岁员工数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$management_female_ratio$dump$, $dump$管理层女性占比$dump$, 0.01, $dump${"fields": [60, 59], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$高级和中级管理层女性人数与总人数之比$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$total_leavers$dump$, $dump$离职总人数$dump$, 1.0, $dump${"fields": [75, 76], "operation": "总和"}$dump$::jsonb, $dump$人$dump$, $dump$年度离职总人数$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$new_hires$dump$, $dump$新进员工$dump$, 1.0, $dump${"fields": [74], "operation": "总和"}$dump$::jsonb, $dump$人$dump$, $dump$新进员工人数$dump$, $dump$国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$social_insurance_and_housing_fund$dump$, $dump$五险一金$dump$, 0.01, $dump${"fields": [69], "operation": "总和"}$dump$::jsonb, $dump$元$dump$, $dump$人均五险一金增加额$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$proportion_of_PhD$dump$, $dump$博士及以上员工比例$dump$, 0.01, $dump${"fields": [65, 280], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$博士及以上员工比例$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$proportion_of_master$dump$, $dump$硕士员工比例$dump$, 0.01, $dump${"fields": [66, 280], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$硕士员工比例$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$proportion_of_bachelor$dump$, $dump$本科员工比例$dump$, 0.01, $dump${"fields": [67, 280], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$本科员工比例$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$proportion_of_college_diploma$dump$, $dump$专科及以下员工比例$dump$, 0.01, $dump${"fields": [68, 280], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$专科及以下员工比例$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$overall_employee_turnover_rate$dump$, $dump$员工总流失率$dump$, 0.01, $dump${"fields": [294, 280], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$年度离职人数/（年度最终在职人数+年度离职人数）*100%$dump$, $dump$港交所、GRI、国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$male_turnover_rate$dump$, $dump$男性离职率$dump$, 0.01, $dump${"fields": [75, 280], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$男性离职人数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$female_turnover_rate$dump$, $dump$女性离职率$dump$, 0.01, $dump${"fields": [76, 280], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$女性离职人数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$mainland_china_turnover_rate$dump$, $dump$中国大陆离职率$dump$, 0.01, $dump${"fields": [77, 280], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$中国大陆离职人数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$non_mainland_china_turnover_rate$dump$, $dump$中国大陆以外离职率$dump$, 0.01, $dump${"fields": [78, 280], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$中国大陆以外离职人数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$turnover_rate_18_30$dump$, $dump$18-30岁离职率$dump$, 0.01, $dump${"fields": [79, 280], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$18-30岁离职人数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$turnover_rate_31_45$dump$, $dump$31-45岁离职率$dump$, 0.01, $dump${"fields": [80, 280], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$31-45岁离职人数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$turnover_rate_46_60_plus$dump$, $dump$46-60岁以上离职率$dump$, 0.01, $dump${"fields": [81, 280], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$46-60岁以上离职人数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$management_turnover_rate$dump$, $dump$管理层离职率$dump$, 0.01, $dump${"fields": [82, 280], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$管理层离职人数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$mid_level_turnover_rate$dump$, $dump$中层员工离职率$dump$, 0.01, $dump${"fields": [83, 280], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$中层员工离职人数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$雇佣$dump$, $dump$staff_turnover_rate$dump$, $dump$普通员工离职率$dump$, 0.01, $dump${"fields": [84, 280], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$普通员工离职人数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$教育和培训$dump$, $dump$total_trained_employees$dump$, $dump$受训总人数$dump$, 1.0, $dump${"fields": [85], "operation": "最终有效值"}$dump$::jsonb, $dump$人次$dump$, $dump$报告期内受训人数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$教育和培训$dump$, $dump$company_training_coverage_rate$dump$, $dump$公司培训覆盖率$dump$, 0.01, $dump${"fields": [86, 85], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$报告期内受训人数/总人数*100%$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$教育和培训$dump$, $dump$male_trained_employees$dump$, $dump$男性受训人数$dump$, 1.0, $dump${"fields": [87], "operation": "最终有效值"}$dump$::jsonb, $dump$人次$dump$, $dump$报告期内男性受训人数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$教育和培训$dump$, $dump$female_trained_employees$dump$, $dump$女性受训人数$dump$, 1.0, $dump${"fields": [88], "operation": "最终有效值"}$dump$::jsonb, $dump$人次$dump$, $dump$报告期内女性受训人数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$教育和培训$dump$, $dump$male_trained_employee_percentage$dump$, $dump$男性受训员工百分比$dump$, 0.01, $dump${"fields": [87, 57], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$报告期内男性受训人数/总人数*100%$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$教育和培训$dump$, $dump$female_trained_employee_percentage$dump$, $dump$女性受训员工百分比$dump$, 0.01, $dump${"fields": [88, 58], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$报告期内女性受训人数/总人数*100%$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$教育和培训$dump$, $dump$management_trained_employees$dump$, $dump$管理层受训人数$dump$, 1.0, $dump${"fields": [89], "operation": "最终有效值"}$dump$::jsonb, $dump$人次$dump$, $dump$报告期内管理层受训人数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$教育和培训$dump$, $dump$mid_level_trained_employees$dump$, $dump$中层员工受训人数$dump$, 1.0, $dump${"fields": [90], "operation": "最终有效值"}$dump$::jsonb, $dump$人次$dump$, $dump$报告期内中层员工受训人数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$教育和培训$dump$, $dump$staff_trained_employees$dump$, $dump$普通员工受训人数$dump$, 1.0, $dump${"fields": [91], "operation": "最终有效值"}$dump$::jsonb, $dump$人次$dump$, $dump$报告期内普通员工受训人数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$教育和培训$dump$, $dump$management_trained_employee_percentage$dump$, $dump$管理层受训员工百分比$dump$, 0.01, $dump${"fields": [89, 59], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$报告期内管理层受训人数/总人数*100%$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$教育和培训$dump$, $dump$mid_level_trained_employee_percentage$dump$, $dump$中层受训员工百分比$dump$, 0.01, $dump${"fields": [90, 61], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$报告期内中层员工受训人数/总人数*100%$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$教育和培训$dump$, $dump$staff_trained_employee_percentage$dump$, $dump$普通受训员工百分比$dump$, 0.01, $dump${"fields": [91, 62], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$报告期内普通员工受训人数/总人数*100%$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$教育和培训$dump$, $dump$total_training_hours$dump$, $dump$培训总学时(未分类统计)$dump$, 0.01, $dump${"fields": [92], "operation": "总和"}$dump$::jsonb, $dump$小时$dump$, $dump$报告期内培训总时数，单次培训学时*参与人数之和$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$教育和培训$dump$, $dump$average_training_hours_per_employee$dump$, $dump$人均受训学时$dump$, 0.01, $dump${"fields": [92, 312], "operation": "占比"}$dump$::jsonb, $dump$小时$dump$, $dump$培训总学时/受训总人数$dump$, $dump$港交所、GRI、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$教育和培训$dump$, $dump$male_training_hours$dump$, $dump$男性受训时数$dump$, 0.01, $dump${"fields": [93], "operation": "总和"}$dump$::jsonb, $dump$小时$dump$, $dump$报告期内男性受训时数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$教育和培训$dump$, $dump$female_training_hours$dump$, $dump$女性受训时数$dump$, 0.01, $dump${"fields": [94], "operation": "总和"}$dump$::jsonb, $dump$小时$dump$, $dump$报告期内女性受训时数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$教育和培训$dump$, $dump$management_training_hours$dump$, $dump$管理层受训时数$dump$, 0.01, $dump${"fields": [95], "operation": "总和"}$dump$::jsonb, $dump$小时$dump$, $dump$报告期内管理层受训时数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$教育和培训$dump$, $dump$mid_level_training_hours$dump$, $dump$中层员工受训时数$dump$, 0.01, $dump${"fields": [96], "operation": "总和"}$dump$::jsonb, $dump$小时$dump$, $dump$报告期内中层员工受训时数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$教育和培训$dump$, $dump$staff_training_hours$dump$, $dump$普通员工受训时数$dump$, 0.01, $dump${"fields": [97], "operation": "总和"}$dump$::jsonb, $dump$小时$dump$, $dump$报告期内普通员工受训时数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$职业健康与安全$dump$, $dump$employee_safety_training_sessions$dump$, $dump$员工安全培训次数$dump$, 1.0, $dump${"fields": [98], "operation": "总和"}$dump$::jsonb, $dump$次$dump$, $dump$提高安全监管检察人员、生产经营单位从业人员和从事安全生产工作的相关人员的安全素质为目的的教育培训活动。$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$职业健康与安全$dump$, $dump$employee_safety_training_hours$dump$, $dump$员工安全培训学时$dump$, 0.01, $dump${"fields": [100], "operation": "总和"}$dump$::jsonb, $dump$小时$dump$, $dump$向员工提供的与安全相关的培训时长$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$职业健康与安全$dump$, $dump$per_capita_training_hours$dump$, $dump$人均受训学时$dump$, 0.01, $dump${"fields": [100, 99], "operation": "占比"}$dump$::jsonb, $dump$小时$dump$, $dump$向员工提供的与安全相关的人均受训时长$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$职业健康与安全$dump$, $dump$work_related_deaths$dump$, $dump$工亡人数$dump$, 1.0, $dump${"fields": [103], "operation": "总和"}$dump$::jsonb, $dump$人$dump$, $dump$报告期内工亡人数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$职业健康与安全$dump$, $dump$work_related_fatality_rate$dump$, $dump$因工死亡率$dump$, 0.01, $dump${"fields": [103, 280], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$报告期内因工死亡人数/总人数*100%$dump$, $dump$港交所、GRI、国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$职业健康与安全$dump$, $dump$work_injuries_count$dump$, $dump$工伤数量$dump$, 1.0, $dump${"fields": [101], "operation": "总和"}$dump$::jsonb, $dump$次$dump$, $dump$工伤数量，包括受伤或死亡人数和事件次数，其中包括员工以及合同工$dump$, $dump$国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$职业健康与安全$dump$, $dump$safety_incidents$dump$, $dump$安全事故$dump$, 1.0, $dump${"fields": [102], "operation": "总和"}$dump$::jsonb, $dump$次$dump$, $dump$因安全事故导致生产受影响或员工伤亡事件次数（安全事故包含工伤数量）$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$职业健康与安全$dump$, $dump$lost_work_days_due_to_injuries$dump$, $dump$因工伤损失工作日数$dump$, 1.0, $dump${"fields": [104], "operation": "总和"}$dump$::jsonb, $dump$天$dump$, $dump$报告期内因工伤损失工作日数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$职业健康与安全$dump$, $dump$safety_investment$dump$, $dump$安全生产投入$dump$, 0.01, $dump${"fields": [105], "operation": "总和"}$dump$::jsonb, $dump$万元$dump$, $dump$报告期内安全生产投入金额$dump$, $dump$港交所、GRI、国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$职业健康与安全$dump$, $dump$full_time_safety_staff_count$dump$, $dump$专职安全管理人员员工数$dump$, 1.0, $dump${"fields": [106], "operation": "总和"}$dump$::jsonb, $dump$人$dump$, $dump$报告期内专职安全管理人员数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$职业健康与安全$dump$, $dump$employees_health_check_count$dump$, $dump$员工体检人数$dump$, 1.0, $dump${"fields": [107], "operation": "总和"}$dump$::jsonb, $dump$人$dump$, $dump$报告期内员工体检人数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$职业健康与安全$dump$, $dump$employee_health_check_participation_rate$dump$, $dump$员工体检参与率$dump$, 0.01, $dump${"fields": [107, 280], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$报告期内员工体检人数/总人数*100%$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$职业健康与安全$dump$, $dump$occupational_hazard_position_health_check_rate$dump$, $dump$职业病危害岗位体检率$dump$, 0.01, $dump${"fields": [110, 280], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$报告期内职业病危害岗位体检率$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$职业健康与安全$dump$, $dump$safety_emergency_drill_count$dump$, $dump$安全应急演练次数$dump$, 1.0, $dump${"fields": [108], "operation": "总和"}$dump$::jsonb, $dump$次$dump$, $dump$报告期内安全应急演练次数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$职业健康与安全$dump$, $dump$safety_inspection_hazards_identified_count$dump$, $dump$安全检查排查隐患数量$dump$, 1.0, $dump${"fields": [109], "operation": "总和"}$dump$::jsonb, $dump$个$dump$, $dump$报告期内安全检查排查隐患数量$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (18, $dump$员工满意度$dump$, $dump$employee_satisfaction$dump$, $dump$员工满意度$dump$, 0.01, $dump${"fields": [111], "operation": "平均"}$dump$::jsonb, $dump$%$dump$, $dump$开展员工满意度的调查结果$dump$, $dump$港交所、GRI、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$雇佣$dump$, $dump$employee_hiring_and_dismissal$dump$, $dump$员工聘用及解雇$dump$, NULL, NULL, NULL, $dump$员工聘用及解雇的一般标准程序与准则$dump$, $dump$上交所、港交所、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$雇佣$dump$, $dump$industry_employee_turnover_rate$dump$, $dump$行业员工流失率$dump$, NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$雇佣$dump$, $dump$guangda_vs_industry_turnover_comparison$dump$, $dump$光大同创的员工流失率与行业流失率的对比表$dump$, NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$雇佣$dump$, $dump$salary_management$dump$, $dump$薪酬管理$dump$, NULL, NULL, NULL, $dump$公司构建薪酬体系的制度及举措如公司构建包含绩效奖金、岗位津贴、员工持股计划等$dump$, $dump$上交所、港交所、MSCI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$职业健康与安全$dump$, $dump$ohs_management_system$dump$, $dump$职业健康安全管理体系$dump$, NULL, NULL, NULL, $dump$说明是否实施了职业健康安全管理体系，说明职业健康安全管理体系所覆盖的工作者、活动和工作场所范围。$dump$, $dump$GRI、国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$职业健康与安全$dump$, $dump$safety_production_policy$dump$, $dump$安全生产政策$dump$, NULL, NULL, NULL, $dump$提供安全工作环境及保障雇员避免职业性危害的政策，及其他遵守的相关法律与规定$dump$, $dump$上交所、港交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$职业健康与安全$dump$, $dump$ohs_target$dump$, $dump$保障职业健康与安全目标$dump$, NULL, NULL, NULL, $dump$公司职业健康与安全工作的目标$dump$, $dump$MSCI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$职业健康与安全$dump$, $dump$ohs_target_measures$dump$, $dump$保障职业健康与安全目标措施$dump$, NULL, NULL, NULL, $dump$提供安全工作环境、保障员工避免职业性危害的措施和执行情况公司职业健康与安全工作的措施，包括公司获得职业健康安全管理体系认证证书（如ISO45001、OHSAS18001等）$dump$, $dump$上交所、港交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$职业健康与安全$dump$, $dump$hazard_identification_risk_assessment_accident_investigation$dump$, $dump$危害识别、风险评估和事故调查$dump$, NULL, NULL, NULL, $dump$识别工作相关危害和评估风险的管理流程，以及应用控制层级消除危害并将风险最小化的管理流程$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$职业健康与安全$dump$, $dump$ohs_participation_consultation_communication$dump$, $dump$职业健康安全事务：工作者的参与、意见征询和沟通$dump$, NULL, NULL, NULL, $dump$在职业健康安全管理体系的开发、实施和评估中，使工作者参与和协商的流程，以及向工作者提供职业健康安全信息访问权以及沟通信息的流程。$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$职业健康与安全$dump$, $dump$ohs_training$dump$, $dump$工作者职业健康安全培训$dump$, NULL, NULL, NULL, $dump$向工作者提供的任何职业健康安全培训，包括通用培训以及对具体工作相关危害、危害活动或危害情况的培训。$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$职业健康与安全$dump$, $dump$promote_worker_health$dump$, $dump$促进工作者健康$dump$, NULL, NULL, NULL, $dump$为应对与工作无关的重大健康风险，组织向工作者提供的任何自愿参与的健康促进服务和计划，包括解决的具体健康风险，以及组织如何促进工作者使用这些服务和计划。$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$员工满意度$dump$, $dump$employee_satisfaction_survey_plan$dump$, $dump$员工满意度调查计划$dump$, NULL, NULL, NULL, $dump$$dump$, $dump$$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$员工满意度$dump$, $dump$employee_satisfaction_survey_coverage$dump$, $dump$员工满意度调查覆盖率/覆盖情况$dump$, NULL, NULL, NULL, $dump$$dump$, $dump$$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$员工满意度$dump$, $dump$employee_satisfaction_project_ranking$dump$, $dump$员工满意度项目排名$dump$, NULL, NULL, NULL, $dump$$dump$, $dump$$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$员工关爱$dump$, $dump$full_time_employee_benefits$dump$, $dump$提供给全职员工（不包括临时或兼职员工）的福利$dump$, NULL, NULL, NULL, $dump$对组织的全职员工提供，但不对临时或兼职员工提供的标准福利。包括：人寿保险、医疗保险、育儿假、退休金、股权（ESOP）、其他$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$员工关爱$dump$, $dump$employee_care$dump$, $dump$员工关爱$dump$, NULL, NULL, NULL, $dump$公司重视关怀关爱员工，保障工作和生活平衡稳定的举措，包括公司通过帮扶困难员工、员工生育期权益保障(女性员工带薪休假、男性员工护产假保障)$dump$, $dump$上交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$培训$dump$, $dump$annual_training_plan_hours_target$dump$, $dump$年度培训计划小时数目标$dump$, NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$培训$dump$, $dump$annual_training_plan_hours_target_rate$dump$, $dump$年度培训计划小时数目标达成率（%）$dump$, NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$培训$dump$, $dump$annual_training_plan$dump$, $dump$年度培训计划$dump$, NULL, NULL, NULL, $dump$为提升员工技能而提供的培训$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$培训$dump$, $dump$annual_training_plan_completion_rate$dump$, $dump$年度培训计划达成率（%）$dump$, NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$多元化与平等机会$dump$, $dump$diversity_and_equal_opportunity$dump$, $dump$多元化和机会平等$dump$, NULL, NULL, NULL, $dump$公司坚持平等原则构建多元化的人才体系的措施，公平公正对待不同国籍、种族、性别、宗教信仰和文化背景的员工，提供平等发展机会等举措$dump$, $dump$港交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$多元化与平等机会$dump$, $dump$promotion_mechanism$dump$, $dump$晋升机制$dump$, NULL, NULL, NULL, $dump$公司为保障员工职业发展而建立的公平晋升机制与通道$dump$, $dump$上交所、港交所、国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$反歧视$dump$, $dump$discrimination_events_and_corrective_actions$dump$, $dump$歧视事件及采取的纠正行动$dump$, NULL, NULL, NULL, $dump$公司劳动用工的标准，公司在反歧视方面的招聘要求，以及发现违规（违反劳动准则）情况时的处理措施。$dump$, $dump$上交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$童工$dump$, $dump$child_labor_risk_sites_suppliers$dump$, $dump$具有重大童工事件风险的运营点和供应商$dump$, NULL, NULL, NULL, $dump$公司如何避免童工及强制劳动，及发现存在童工或强制劳动时的应对措施，还应重视收集并报告具有使用童工、强制劳动重大风险的运营点及供应商$dump$, $dump$上交所、港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$强迫或强制劳动$dump$, $dump$forced_labor_risk_sites_suppliers$dump$, $dump$具有强迫或强制劳动事件重大风险的运营点和供应商$dump$, NULL, NULL, NULL, $dump$为促进消除一切形式的强迫或强制劳动而采取的措施$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$民主权益$dump$, $dump$democratic_management$dump$, $dump$民主管理$dump$, NULL, NULL, NULL, $dump$公司结社自由与集体协商的管理方法，并描述公司依照法律规定实行民主管理的制度和方式，包括公司通过职工代表大会实行民主决策、民主参与、民主监督的管理制度和管理方式$dump$, $dump$上交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$应急管理$dump$, $dump$emergency_management_system$dump$, $dump$应急管理体系$dump$, NULL, NULL, NULL, $dump$公司建立的应急管理体系和制度，包括应急管理组织$dump$, $dump$港交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (19, $dump$应急管理$dump$, $dump$safety_emergency_measures$dump$, $dump$安全应急措施$dump$, NULL, NULL, NULL, $dump$公司安全应急工作的措施，包括规范应急处理流程、制定应急预案、开展应急演练等内容$dump$, $dump$港交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$供应链管理$dump$, $dump$east_china_supplier_count$dump$, $dump$华东地区供应商数$dump$, 1.0, $dump${"fields": [112], "operation": "总和"}$dump$::jsonb, $dump$家$dump$, $dump$当年实际华东地区供应商数$dump$, $dump$港交所、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$供应链管理$dump$, $dump$south_china_supplier_count$dump$, $dump$华南地区供应商数$dump$, 1.0, $dump${"fields": [113], "operation": "总和"}$dump$::jsonb, $dump$家$dump$, $dump$当年实际华南地区供应商数$dump$, $dump$港交所、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$供应链管理$dump$, $dump$other_regions_supplier_count$dump$, $dump$其他地区供应商数$dump$, 1.0, $dump${"fields": [114], "operation": "总和"}$dump$::jsonb, $dump$家$dump$, $dump$当年实际其他地区供应商数$dump$, $dump$港交所、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$供应链管理$dump$, $dump$total_suppliers$dump$, $dump$供应商总数$dump$, 1.0, $dump${"fields": [112, 113, 114], "operation": "总和"}$dump$::jsonb, $dump$家$dump$, $dump$供应商总数$dump$, $dump$港交所、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$供应链管理$dump$, $dump$new_suppliers_screened_by_environmental_evaluation_dimension$dump$, $dump$使用环境评价维度筛选的新供应商$dump$, 1.0, $dump${"fields": [115], "operation": "总和"}$dump$::jsonb, $dump$家$dump$, $dump$说明供应商评价使用的环境评价标准，使用环境评价维度筛选的供应商百分比$dump$, $dump$GRI、国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$供应链管理$dump$, $dump$new_suppliers_screened_by_social_standards$dump$, $dump$使用社会标准筛选的新供应商$dump$, 1.0, $dump${"fields": [116], "operation": "总和"}$dump$::jsonb, $dump$家$dump$, $dump$对供应商针对社会影响开展尽职调查后，选定或签约的供应商百分比$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$供应链管理$dump$, $dump$suppliers_conducting_environmental_impact_assessment$dump$, $dump$开展环境影响评估的供应商数量$dump$, 1.0, NULL, $dump$家$dump$, $dump$开展环境及社会影响评价的供应商$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$供应链管理$dump$, $dump$suppliers_conducting_social_impact_assessment$dump$, $dump$开展社会影响评估的供应商数量$dump$, 1.0, NULL, $dump$家$dump$, $dump$开展环境及社会影响评价的供应商$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$供应链管理$dump$, $dump$supplier_environmental_penalty_count$dump$, $dump$供应商环境处罚次数$dump$, 1.0, $dump${"fields": [119], "operation": "总和"}$dump$::jsonb, $dump$次$dump$, $dump$供应商受到的环境相关处罚次数$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$供应链管理$dump$, $dump$supplier_environmental_penalty_total_amount$dump$, $dump$供应商环境处罚总额$dump$, 0.01, $dump${"fields": [120], "operation": "总和"}$dump$::jsonb, $dump$万元$dump$, $dump$供应商受到的环境相关处罚总额$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$供应链管理$dump$, $dump$supplier_network_data_security_incidents$dump$, $dump$供应商网络数据安全事件$dump$, 1.0, $dump${"fields": [121], "operation": "总和"}$dump$::jsonb, $dump$起$dump$, $dump$供应商发生网络数据安全事件的次数$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$供应链管理$dump$, $dump$procurement_spending_to_local_suppliers$dump$, $dump$向当地供应商支出的采购金额$dump$, 0.01, $dump${"fields": [117], "operation": "总和"}$dump$::jsonb, $dump$万元$dump$, $dump$向经营所在地的当地供应商支出$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$供应链管理$dump$, $dump$total_procurement_amount$dump$, $dump$采购总金额$dump$, 0.01, $dump${"fields": [118], "operation": "总和"}$dump$::jsonb, $dump$万元$dump$, $dump$总采购额$dump$, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$供应链管理$dump$, $dump$share_of_procurement_spent_on_local_suppliers$dump$, $dump$向当地供应商采购的支出比例$dump$, 0.01, $dump${"fields": [117, 118], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$向经营所在地的当地供应商支出的用于重要经营位置的采购预算百分比（例如从当地购买的产品 和服务的百分比）$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$产品责任$dump$, $dump$total_customer_complaints$dump$, $dump$客户投诉总数$dump$, 1.0, $dump${"fields": [122], "operation": "总和"}$dump$::jsonb, $dump$件$dump$, $dump$当年实际客户投诉次数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$产品责任$dump$, $dump$effectively_resolved_complaints_count$dump$, $dump$有效处理件数$dump$, 1.0, $dump${"fields": [123], "operation": "总和"}$dump$::jsonb, $dump$件$dump$, $dump$有效处理客户投诉次数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$产品责任$dump$, $dump$customer_complaint_effective_resolution_rate$dump$, $dump$客户投诉有效处理率$dump$, 0.01, $dump${"fields": [123, 122], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$有效处理客户投诉次数/客户投诉总次数*100%$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$产品责任$dump$, $dump$customer_satisfaction_result$dump$, $dump$客户满意度结果$dump$, 0.01, $dump${"fields": [127], "operation": "平均"}$dump$::jsonb, $dump$%$dump$, $dump$当年客户满意度调查报告$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$产品责任$dump$, $dump$product_recall_count$dump$, $dump$发生产品召回的次数$dump$, 1.0, $dump${"fields": [125], "operation": "总和"}$dump$::jsonb, $dump$次$dump$, $dump$当年实际产品召回次数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$产品责任$dump$, $dump$product_recall_percentage$dump$, $dump$产品召回百分比$dump$, 0.01, $dump${"fields": [125, 126], "operation": "占比"}$dump$::jsonb, $dump$%$dump$, $dump$实际产品召回次数/总出货次数*100%$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$产品责任$dump$, $dump$product_safety_quality_issues$dump$, $dump$产品安全质量问题$dump$, 1.0, $dump${"fields": [124], "operation": "总和"}$dump$::jsonb, $dump$件$dump$, $dump$产品安全质量出现问题的事件次数 $dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$产品责任$dump$, $dump$network_data_security_incidents$dump$, $dump$网络数据安全事件$dump$, 1.0, $dump${"fields": [128], "operation": "总和"}$dump$::jsonb, $dump$起$dump$, $dump$网络安全风险及隐患的事件次数$dump$, $dump$国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$知识产权保护$dump$, $dump$total_patents_acquired$dump$, $dump$累计获得专利数量$dump$, 1.0, $dump${"fields": [130, 132, 133], "operation": "总和"}$dump$::jsonb, $dump$项$dump$, $dump$当年实际专利数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$知识产权保护$dump$, $dump$total_invention_patents$dump$, $dump$累计发明专利数量$dump$, 1.0, $dump${"fields": [130], "operation": "总和"}$dump$::jsonb, $dump$项$dump$, $dump$当年实际发明专利数$dump$, $dump$港交所、GRI、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$知识产权保护$dump$, $dump$invention_patent_applications$dump$, $dump$发明专利申请数量$dump$, 1.0, $dump${"fields": [131], "operation": "总和"}$dump$::jsonb, $dump$项$dump$, $dump$向‌国家知识产权局提交的专利申请$dump$, $dump$华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$知识产权保护$dump$, $dump$total_utility_model_patents$dump$, $dump$累计实用新型专利数量$dump$, 1.0, $dump${"fields": [132], "operation": "总和"}$dump$::jsonb, $dump$项$dump$, $dump$当年实际实用新型专利数$dump$, $dump$港交所、GRI、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$知识产权保护$dump$, $dump$total_design_patents$dump$, $dump$累计外观设计专利数量$dump$, 1.0, $dump${"fields": [133], "operation": "总和"}$dump$::jsonb, $dump$项$dump$, $dump$当年实际外观设计专利数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$知识产权保护$dump$, $dump$total_granted_patents$dump$, $dump$累计被授权专利数$dump$, 1.0, $dump${"fields": [134], "operation": "总和"}$dump$::jsonb, $dump$项$dump$, $dump$当年实际专利数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$知识产权保护$dump$, $dump$patents_added_this_year$dump$, $dump$本年新增专利数量$dump$, 1.0, $dump${"fields": [134], "operation": "对比去年"}$dump$::jsonb, $dump$项$dump$, $dump$当年实际新增专利数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$知识产权保护$dump$, $dump$total_software_copyrights$dump$, $dump$累计软件著作权数量$dump$, 1.0, $dump${"fields": [135], "operation": "总和"}$dump$::jsonb, $dump$件$dump$, $dump$当年实际软件著作权数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$知识产权保护$dump$, $dump$total_trademark_registrations$dump$, $dump$累计商标注册数量$dump$, 1.0, $dump${"fields": [136], "operation": "总和"}$dump$::jsonb, $dump$件$dump$, $dump$当年实际商标注册数$dump$, $dump$港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$社区参与$dump$, $dump$total_charitable_and_external_donations$dump$, $dump$公益慈善捐赠总额/对外捐赠总额$dump$, 0.01, $dump${"fields": [137], "operation": "总和"}$dump$::jsonb, $dump$元$dump$, $dump$描述公司在公益事业方面做出的贡献，分类列示在提升社会教育、环境、就业、文化、体育等方面的投入，包括公司直接、间接提供的财务支出、实物的货币价值$dump$, $dump$GRI、上交所、国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$社区参与$dump$, $dump$community_development_investment_amount$dump$, $dump$社区发展投入金额$dump$, 0.01, $dump${"fields": [138], "operation": "总和"}$dump$::jsonb, $dump$元$dump$, $dump$为提升社区教育、环境、就业、文化、体育等水平方面投入的资金$dump$, $dump$GRI、上交所、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$志愿活动$dump$, $dump$volunteer_activity_participation_count$dump$, $dump$志愿者活动参与人次$dump$, 1.0, $dump${"fields": [139], "operation": "总和"}$dump$::jsonb, $dump$人次$dump$, $dump$统计公司志愿者参与活动人次，包括公司组织的志愿服务活动、员工自发组织的志愿服务活动等$dump$, $dump$上交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (20, $dump$志愿活动$dump$, $dump$total_volunteer_service_hours$dump$, $dump$志愿者服务总时长$dump$, 0.01, $dump${"fields": [140], "operation": "总和"}$dump$::jsonb, $dump$小时$dump$, $dump$统计志愿者活动服务时长包括上述提到的所有志愿活动的总时长$dump$, $dump$上交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, $dump$供应商管理$dump$, $dump$supplier_management_system$dump$, $dump$供应商管理体系$dump$, NULL, NULL, $dump$$dump$, $dump$描述公司供应商的选取及退出政策、执行状况、监察方法等管理内容$dump$, $dump$上交所、港交所、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, $dump$供应商管理$dump$, $dump$supplier_integrity_requirements$dump$, $dump$供应商廉洁要求$dump$, NULL, NULL, $dump$$dump$, $dump$描述公司对供应商在遵守国家相关法律法规要求、合规经营方面的要求$dump$, $dump$上交所、港交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, $dump$供应商管理$dump$, $dump$supplier_management_goals_measures$dump$, $dump$供应商管理目标及措施$dump$, NULL, NULL, $dump$$dump$, $dump$描述促进供应商管理、供应商社会责任意识提升的目标描述完善供应商选择机制，对供应商开展履约评价等内容$dump$, $dump$港交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, $dump$供应商管理$dump$, $dump$supplier_identification$dump$, $dump$供应商识别$dump$, NULL, NULL, $dump$$dump$, $dump$描述有关识别供应链每个环节的环境及社会风险的政策、措施，以及相关执行及监察方法$dump$, $dump$港交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, $dump$供应商管理$dump$, $dump$green_supply_chain$dump$, $dump$绿色供应链$dump$, NULL, NULL, $dump$$dump$, $dump$描述在拣选供应商时促使多用环保产品及服务的措施，以及相关执行及监察方法$dump$, $dump$上交所、港交所、国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, $dump$供应商管理$dump$, $dump$supply_chain_diversity_policy$dump$, $dump$供应链多元化政策$dump$, NULL, NULL, $dump$$dump$, $dump$为降低供应链断裂风险制定的供应链多元化政策$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, $dump$供应商管理$dump$, $dump$supply_chain_negative_environmental_impact_actions$dump$, $dump$供应链对环境的负面影响及采取的行动$dump$, NULL, NULL, $dump$$dump$, $dump$包括以下事项：开展了环境影响评估的供应商数量；经确定为具有实际和潜在重大负面环境影响的供应商数量；经确定的供应链中的实际和潜在重大负面环境影响；经确定为具有实际和潜在重大负面环境影响，且经评估后同意改进的供应商百分比；经确定为具有实际和潜在重大负面环境影响，且经评估后决定终止关系的供应商百分比$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, $dump$供应商管理$dump$, $dump$supply_chain_negative_social_impact_actions$dump$, $dump$供应链对社会的负面影响及采取的行动$dump$, NULL, NULL, $dump$$dump$, $dump$包括以下事项：开展了社会影响评估的供应商数量；经确定为具有实际和潜在重大负面社会影响的供应商数量；经确定的供应链中的实际和潜在重大负面社会影响；经确定为具有实际和潜在重大负面社会影响，且经评估后同意改进的供应商百分比；经确定为具有实际和潜在重大负面社会影响，且经评估后决定终止关系的供应商百分比$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, $dump$供应商管理$dump$, $dump$supply_chain_environmental_commitment_rate$dump$, $dump$供应链环境承诺书签署率$dump$, NULL, NULL, $dump$$dump$, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, $dump$供应商管理$dump$, $dump$supply_chain_environmental_audit_completion_rate$dump$, $dump$供应链环境现场审核完成率$dump$, NULL, NULL, $dump$$dump$, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, $dump$供应商管理$dump$, $dump$supply_chain_environmental_audit_improvement$dump$, $dump$供应链环境现场审核改进情况说明$dump$, NULL, NULL, $dump$$dump$, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, $dump$供应商管理$dump$, $dump$supply_chain_environmental_management_goals$dump$, $dump$供应链环境管理目标$dump$, NULL, NULL, $dump$$dump$, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, $dump$产品安全管理$dump$, $dump$product_quality_safety_mechanism$dump$, $dump$产品质量与安全机制$dump$, NULL, NULL, $dump$$dump$, $dump$保证产品质量与安全的机制、执行情况以及应对产品安全事故的措施保障生产环境安全、生产流程科学的措施及执行情况其他与产品安全与责任有关的重要信息，如产品质量认证等$dump$, $dump$上交所、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, $dump$责任营销$dump$, $dump$truthful_fair_information_contract$dump$, $dump$真实公正的信息与合同签订$dump$, NULL, NULL, $dump$$dump$, $dump$描述公司在产品或服务的宣传过程中，秉承高度责任感，客观、真实的开展营销活动，不夸大其词、隐瞒风险、过度营销。$dump$, $dump$港交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, $dump$知识产权保护$dump$, $dump$intellectual_property_policy$dump$, $dump$知识产权保护政策$dump$, NULL, NULL, $dump$$dump$, $dump$描述与维护及保障知识产权有关的惯例包含2个方面：对集团自身知识产权的保护，以及避免侵犯外部知识产权的制度和流程。$dump$, $dump$上交所、港交所、国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, $dump$知识产权保护$dump$, $dump$intellectual_property_practices$dump$, $dump$维护及保障知识产权有关的惯例$dump$, NULL, NULL, $dump$$dump$, $dump$描述与维护及保障知识产权有关的目标描述与维护及保障知识产权有关的措施，包括增加知识产权意识、完善创新机制、严格依法申请知识产权、坚决打击侵权等行为$dump$, $dump$港交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, $dump$数据安全与客户隐私保护$dump$, $dump$customer_privacy_protection$dump$, $dump$客户隐私保护$dump$, NULL, NULL, $dump$$dump$, $dump$描述客户资料、数据保障及私隐的相关执行及监察方法，包括信息安全的制度及执行情况、维护消费者数据安全及隐私等。$dump$, $dump$上交所、港交所、国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, $dump$数据安全与客户隐私保护$dump$, $dump$data_security_management$dump$, $dump$数据安全管理$dump$, NULL, NULL, $dump$$dump$, $dump$保护数据安全而采取的管理措施方针$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, $dump$数据安全与客户隐私保护$dump$, $dump$data_security_privacy_certification_disclosure$dump$, $dump$数据安全隐私认证与信披$dump$, NULL, NULL, $dump$$dump$, $dump$数据安全与隐私方面的制度建设情况$dump$, $dump$华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, $dump$数据安全与客户隐私保护$dump$, $dump$information_security_management_system_certification$dump$, $dump$信息安全管理体系认证$dump$, NULL, NULL, $dump$$dump$, $dump$信息安全管理体系认证ISO 27001的获得情况$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, $dump$社区参与$dump$, $dump$community_participation$dump$, $dump$社区参与$dump$, NULL, NULL, $dump$$dump$, $dump$描述公司积极参与社区治理，为提升社区教育、环境、就业、文化、体育等水平方面制定的办法、采取的措施及亮点实践等$dump$, $dump$上交所、港交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, $dump$社区参与$dump$, $dump$stakeholder_community_communication_goals_plan$dump$, $dump$利益相关方社区沟通目标计划$dump$, NULL, NULL, $dump$$dump$, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, $dump$社区参与$dump$, $dump$stakeholder_community_communication_completion_rate$dump$, $dump$利益相关方社区沟通目标计划完成率（%）$dump$, NULL, NULL, $dump$$dump$, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, $dump$社区参与$dump$, $dump$local_community_participation_assessment_development$dump$, $dump$有当地社区参与、影响评估和发展计划的运营点$dump$, NULL, NULL, $dump$$dump$, $dump$参与运营地社区发展建设，披露包括但不限于：环境影响评估和持续监测；公开披露环境和社会影响评估结果；基于当地社区需求的当地社区发展计划$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, $dump$绿色金融$dump$, $dump$green_finance_products$dump$, $dump$绿色金融产品$dump$, NULL, NULL, $dump$$dump$, $dump$绿色基金/债券/信贷/投资/保险的开展情况$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (21, $dump$数字化$dump$, $dump$digital_transformation$dump$, $dump$数字转型$dump$, NULL, NULL, $dump$$dump$, $dump$数字化转型相关实践$dump$, $dump$国证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$治理结构$dump$, $dump$activities_value_chain_other_business_relationships$dump$, $dump$活动、价值链和其他业务关系$dump$, NULL, NULL, $dump$$dump$, $dump$a.说明其运营所在的行业； b.说明组织的价值链，包括： i 组织的活动、产品、服务 ，以及所服务的市场；ii 组织的供应链； iii 组织的下游实体及其活动c.说明其他相关业务关系$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$治理结构$dump$, $dump$regulatory_framework_composition$dump$, $dump$管制架构和组成$dump$, NULL, NULL, $dump$$dump$, $dump$a.说明其管治架构，包括最高管治机构的委员会，如员会的人员构成、分工和执行情况,以及内部审计部门员工具备的知识、技能和经验，及其向审计委员会报告的简要情况b.说明最高管治机构及其委员会的组成，按照：执行成员和非执行成员、独立性、管治机构成员的任期、性别、专业背景$dump$, $dump$上交所、港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$治理结构$dump$, $dump$nomination_selection_highest_governance_body$dump$, $dump$最高管治机构的提名与遴选$dump$, NULL, NULL, $dump$$dump$, $dump$a. 说明最高管治机构及其委员会的提名和遴选程序； b.说明用于提名和遴选最高管治机构成员的标准，包括是否以及如何考虑以下因素： i 利益相关方（包括股东）的意见；ii 多样性；iii 独立性；iv 与组织的影响相关的胜任能力$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$治理结构$dump$, $dump$number_of_committees$dump$, $dump$委员会数目$dump$, NULL, NULL, $dump$$dump$, $dump$公司内控制度，完善治理架构$dump$, $dump$华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$治理结构$dump$, $dump$board_of_directors$dump$, $dump$董事会$dump$, NULL, NULL, $dump$$dump$, $dump$董事会会议情况。包括会议次数、异议、召开的合规性及相关决议执行情况$dump$, $dump$上交所、港交所、GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$治理结构$dump$, $dump$board_independence$dump$, $dump$董事会独立性$dump$, NULL, NULL, $dump$$dump$, $dump$描述独立董事的占比及履职情况$dump$, $dump$上交所、港交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$治理结构$dump$, $dump$board_gender_ratio$dump$, $dump$董事会性别比例$dump$, NULL, NULL, $dump$$dump$, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$治理结构$dump$, $dump$board_of_supervisors$dump$, $dump$监事会$dump$, NULL, NULL, $dump$$dump$, $dump$描述监事及监事会的相关情况，包括：监事情况。包括监事构成、选举及标准、职责、任期、性别比例、兼职等据以说明监事勤勉履职的相关情况；监事会情况。包括会议次数、异议、召开的合规性及相关决议执行情况$dump$, $dump$上交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$治理结构$dump$, $dump$shareholders_meeting$dump$, $dump$股东大会$dump$, NULL, NULL, $dump$$dump$, $dump$召开的股东大会的执行情况，统计会议届次、会议决议及相关执行情况$dump$, $dump$上交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$治理机制$dump$, $dump$delegated_responsibility_for_managing_impacts$dump$, $dump$为管理影响的责任授权$dump$, NULL, NULL, $dump$$dump$, $dump$a.说明最高管治机构如何进行责任授权，管理组织对经济、环境和人的影响，包括： i 是否任命了任何高管负责管理影响；ii 是否将管理影响的责任授权给其他员工；b.在管理组织对经济、环境和人的影响方面，说明高管或其他员工向最高管治机构汇报的程序和频率$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$治理机制$dump$, $dump$management_compensation_incentive_system$dump$, $dump$管理层薪酬激励制度及执行情况说明$dump$, NULL, NULL, $dump$$dump$, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$治理机制$dump$, $dump$senior_management_stability$dump$, $dump$高层管理人员稳定性$dump$, NULL, NULL, $dump$$dump$, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$治理机制$dump$, $dump$communication_of_important_concerns$dump$, $dump$重要关切问题的沟通$dump$, NULL, NULL, $dump$$dump$, $dump$a.说明是否以及如何向最高管治机构沟通重要关切问题； b. 说明在报告期传达给最高管治机构的重大关切问题的总数和性质。$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$治理机制$dump$, $dump$shared_knowledge_highest_governance_body$dump$, $dump$最高管治机构的共同知识$dump$, NULL, NULL, $dump$$dump$, $dump$说明为提高最高管治机构关于可持续发展的共同知识、技能和经验而采取的措施。$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$治理机制$dump$, $dump$oversight_highest_governance_body$dump$, $dump$在管理影响方面，最高管治机构的监督作用$dump$, NULL, NULL, $dump$$dump$, $dump$a.说明最高管治机构和高管在制定、批准和更新组织的宗旨、价值观或使命陈述、战略、政策以及可持续发展相关目标方面的作用；b.说明在为识别和管理组织对经济、环境和人的影响而采取的尽职调查和其他程序方面，最高管治机构的监督作用，包括：i 最高管治机构是否以及如何与利益相关方沟通，以支持这些流程；ii 最高管治机构如何考虑这些流程的结果$dump$, $dump$GRI、国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$治理机制$dump$, $dump$association_membership$dump$, $dump$协会的成员资格$dump$, NULL, NULL, $dump$$dump$, $dump$说明公司参与并发挥重要作用的行业协会、其他成员制协会、国家或国际倡导组织。$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$治理机制$dump$, $dump$internal_control$dump$, $dump$内部控制$dump$, NULL, NULL, $dump$$dump$, $dump$描述内部控制制度的建立、健全及有效运作情况，需重点说明相关内部控制缺陷及整改情况$dump$, $dump$上交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$治理机制$dump$, $dump$accountability_mechanism$dump$, $dump$追责机制$dump$, NULL, NULL, $dump$$dump$, $dump$描述内部违规责任追究制度的建立与执行情况，披露对有关责任人采取的问责措施及处理结果$dump$, $dump$上交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$维护股东权益$dump$, $dump$protecting_minority_shareholders_rights$dump$, $dump$中小股东权益保护$dump$, NULL, NULL, $dump$$dump$, $dump$保障和保护中小股东方面的努力$dump$, $dump$华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$维护股东权益$dump$, $dump$investor_communication$dump$, $dump$投资者沟通交流$dump$, NULL, NULL, $dump$$dump$, $dump$描述与投资者沟通交流的情况，包括：通过业绩说明会、新闻发布会、投资者接待日等方式进行投资者关系活动的情况及在帮助投资者及时全面地了解公司已公开重大信息方面所采取的措施$dump$, $dump$上交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$ESG治理$dump$, $dump$esg_strategy_goal_management$dump$, $dump$ESG战略与目标管理$dump$, NULL, NULL, $dump$$dump$, $dump$描述公司制定ESG战略目标、战略规划和战略实施等相关内容$dump$, $dump$港交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$ESG治理$dump$, $dump$stakeholder_communication_management$dump$, $dump$利益相关方沟通管理$dump$, NULL, NULL, $dump$$dump$, $dump$描述公司开展的识别和回应利益相关方诉求的沟通活动$dump$, $dump$港交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$ESG治理$dump$, $dump$stakeholder_opposition$dump$, $dump$利益相关者的反对$dump$, NULL, NULL, $dump$$dump$, $dump$描述报告期内公司经营活动中引发利益相关者反对的重要事项包括利益相关者的影响范围、诉求以及公司处理上述事项的流程和具体情况$dump$, $dump$上交所$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$ESG治理$dump$, $dump$esg_executive_compensation_link$dump$, $dump$ESG与高管薪酬挂钩$dump$, NULL, NULL, $dump$$dump$, $dump$描述公司高管薪酬与ESG绩效挂钩的方式，以保障董事会可持续发展决策在公司运营中得到严格落实$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$ESG治理$dump$, $dump$third_party_assurance$dump$, $dump$第三方鉴证$dump$, NULL, NULL, $dump$$dump$, $dump$如有第三方机构对公司ESG信息进行核查、鉴定、鉴证、评价的，鼓励公司披露相关信息$dump$, $dump$国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$ESG治理$dump$, $dump$assurance_report_disclosure$dump$, $dump$鉴证报告披露$dump$, NULL, NULL, $dump$$dump$, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$ESG治理$dump$, $dump$assurance_agency_personnel_qualification$dump$, $dump$鉴证机构人员资质$dump$, NULL, NULL, $dump$$dump$, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$ESG治理$dump$, $dump$assurance_agency_qualification$dump$, $dump$鉴证机构资质$dump$, NULL, NULL, $dump$$dump$, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$ESG治理$dump$, $dump$board_esg_committee_setup$dump$, $dump$董事会ESG委员会的设置$dump$, NULL, NULL, $dump$$dump$, $dump$董事会设置管理ESG相关问题的委员会情况$dump$, $dump$国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$ESG治理$dump$, $dump$highest_governance_body_role_sustainability_report$dump$, $dump$最高管治机构在可持续发展报告中的作用$dump$, NULL, NULL, $dump$$dump$, $dump$说明最高管治机构是否负责审核和批准所报告的信息，包括组织的实质性议题，如果是，说明审核和批准信息的程序$dump$, $dump$GRI$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$ESG治理$dump$, $dump$materiality_assessment$dump$, $dump$重要性评估$dump$, NULL, NULL, $dump$$dump$, $dump$对ESG议题的重要性进行评估的情况$dump$, $dump$国证 $dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$ESG治理$dump$, $dump$materiality_assessment_results$dump$, $dump$重要性评估结果$dump$, NULL, NULL, $dump$$dump$, $dump$对ESG议题的重要性进行评估的结果$dump$, $dump$国证 $dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$ESG治理$dump$, $dump$social_responsibility_awards_honors$dump$, $dump$社会责任奖项及荣誉$dump$, NULL, NULL, $dump$$dump$, $dump$获得社会责任相关奖项或荣誉的情况$dump$, $dump$国证 $dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$反腐败$dump$, $dump$anti_corruption_policy$dump$, $dump$反腐败政策$dump$, NULL, NULL, $dump$$dump$, $dump$描述公司在反对商业贿赂、反腐败、推动廉洁从业、反不正当竞争方面制定的相关规章制度及政策$dump$, $dump$港交所、GRI、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$反腐败$dump$, $dump$corruption_litigation_events_results$dump$, $dump$腐败诉讼事件及结果$dump$, NULL, NULL, $dump$$dump$, $dump$统计对公司或员工提出并已审结的腐败诉讼案件或不正当竞争诉讼案件数量，说明已审结案件的诉讼结果，包括对公司或公司员工做出的罚款、处罚或制裁$dump$, $dump$港交所、GRI、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$反腐败$dump$, $dump$anti_corruption_prevention_measures$dump$, $dump$反腐败防范措施$dump$, NULL, NULL, $dump$$dump$, $dump$描述企业有关防止贪污、腐败、贿赂、勒索、欺诈、洗黑钱、垄断及不正当竞争等违法行为的措施、举报程序、相关执行及监察方法，如宣传活动、宣传标识、开设举报渠道等$dump$, $dump$港交所、GRI、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$反腐败$dump$, $dump$anti_corruption_training$dump$, $dump$反腐败培训$dump$, NULL, NULL, $dump$$dump$, $dump$描述开展的反腐败培训关键内容及反馈结果等；描述有关培训的范围、对象（例如董事、员工、业务伙伴）及方式，以及进行培训后公司企业文化／员工行为有否任何可计量或显著变化的陈述；统计相关数据，例如培训课程数目／时数、参加培训的董事／雇员人数及百分比、各部门参加培训的人数$dump$, $dump$港交所、GRI、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$反腐败$dump$, $dump$anti_bribery_training_completion_rate$dump$, $dump$反贪污和贿赂培训及达成率（%）$dump$, NULL, NULL, $dump$$dump$, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$反腐败$dump$, $dump$anti_bribery_training_implementation$dump$, $dump$反贪污和贿赂培训及执行情况说明$dump$, NULL, NULL, $dump$$dump$, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$商业道德$dump$, $dump$business_ethics_code_disclosure$dump$, $dump$商业道德行为准则与信披$dump$, NULL, NULL, $dump$$dump$, $dump$为规范员工的商业道德行为而制定的准则$dump$, $dump$国证、华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$商业道德$dump$, $dump$stakeholder_notification_completion_rate$dump$, $dump$利益相关方公示告知及达成率（%）$dump$, NULL, NULL, $dump$$dump$, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$商业道德$dump$, $dump$guangda_tongchuang_coc_code$dump$, $dump$光大同创的CoC行为准则$dump$, NULL, NULL, $dump$$dump$, NULL, NULL, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$商业道德$dump$, $dump$negative_executive_events_two_years$dump$, $dump$两年高管负面事件$dump$, NULL, NULL, $dump$$dump$, $dump$两年内管理层发生的负面事件次数$dump$, $dump$国证 $dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$商业道德$dump$, $dump$disclosure_violations_two_years$dump$, $dump$两年信披违规事件$dump$, NULL, NULL, $dump$$dump$, $dump$两年内未履行信息披露义务的事件次数$dump$, $dump$国证 $dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$商业道德$dump$, $dump$financial_fraud_two_years$dump$, $dump$两年财务造假事件$dump$, NULL, NULL, $dump$$dump$, $dump$两年内利用欺诈手段虚报会计事项的次数$dump$, $dump$国证 $dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$商业道德$dump$, $dump$corruption_bribery_two_years$dump$, $dump$两年腐败与贿赂事件$dump$, NULL, NULL, $dump$$dump$, $dump$两年内发生腐败或贿赂事件的次数$dump$, $dump$国证 $dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$商业道德$dump$, $dump$embezzlement_misappropriation_two_years$dump$, $dump$两年职务侵占与挪用事件$dump$, NULL, NULL, $dump$$dump$, $dump$两年内发生将公共财务或公司财务非法据为己有的事件次数$dump$, $dump$国证 $dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$商业道德$dump$, $dump$litigation_amount_within_one_year$dump$, $dump$1年以内的诉讼涉案金额$dump$, NULL, NULL, $dump$$dump$, $dump$在法律诉讼方面的风险暴露情况$dump$, $dump$华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$商业道德$dump$, $dump$litigation_exists$dump$, $dump$是否有诉讼$dump$, NULL, NULL, $dump$$dump$, NULL, $dump$华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$商业道德$dump$, $dump$external_penalties$dump$, $dump$外部处分$dump$, NULL, NULL, $dump$$dump$, $dump$高管及股东被证监会、交易所等实施处罚的违法违规情况，追溯三年$dump$, $dump$华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$商业道德$dump$, $dump$case_investigation$dump$, $dump$立案调查$dump$, NULL, NULL, $dump$$dump$, $dump$是否被立案调查$dump$, $dump$华证$dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$风险管理$dump$, $dump$risk_management_system$dump$, $dump$风险管理体系$dump$, NULL, NULL, $dump$$dump$, $dump$公司委风险管理体系的披露情况$dump$, $dump$国证 $dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$风险管理$dump$, $dump$esg_risk_management$dump$, $dump$ESG风险管理$dump$, NULL, NULL, $dump$$dump$, $dump$ESG相关风险的管理情况$dump$, $dump$国证 $dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$风险管理$dump$, $dump$board_oversight_risk_management$dump$, $dump$董事会监督风险管理$dump$, NULL, NULL, $dump$$dump$, $dump$董事会对风险管理的情况$dump$, $dump$国证 $dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$风险管理$dump$, $dump$risk_management_system_reference_standards$dump$, $dump$风险管理体系参照标准$dump$, NULL, NULL, $dump$$dump$, $dump$风险管理体系参照标准是否基于ISO 31000等标准设置$dump$, $dump$国证 $dump$, true);
INSERT INTO fields (category, set, name_en, name_zh, step, calculation, unit, description, source, is_active) VALUES (22, $dump$税收透明度$dump$, $dump$tax_transparency_policy_implementation$dump$, $dump$税收透明度相关政策及执行情况说明$dump$, NULL, NULL, $dump$$dump$, $dump$$dump$, $dump$$dump$, true);

