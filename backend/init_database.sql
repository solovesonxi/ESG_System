CREATE TABLE material (
    id SERIAL PRIMARY KEY,
    factory VARCHAR(100) NOT NULL DEFAULT '未命名工厂',
    year INTEGER NOT NULL CHECK (year BETWEEN 1949 AND EXTRACT(YEAR FROM CURRENT_DATE)),

    -- 进料数据
    renewable_input NUMERIC(10,2) NOT NULL CHECK (renewable_input >= 0),
    non_renewable_input NUMERIC(10,2) NOT NULL CHECK (non_renewable_input >= 0),
    total_input NUMERIC(10,2) NOT NULL CHECK (total_input >= 0),

    -- 出料数据
    renewable_output NUMERIC(10,2) NOT NULL CHECK (renewable_output >= 0),
    non_renewable_output NUMERIC(10,2) NOT NULL CHECK (non_renewable_output >= 0),
    total_output NUMERIC(10,2) NOT NULL CHECK (total_output >= 0),

    -- 消耗数据
    material_consumption NUMERIC(10,2) NOT NULL CHECK (material_consumption >= 0),
    packaging_material NUMERIC(10,2) NOT NULL CHECK (packaging_material >= 0),
    paper_consumption NUMERIC(10,2) NOT NULL CHECK (paper_consumption >= 0),
    total_revenue NUMERIC(10,2) NOT NULL CHECK (total_revenue >= 0),

    -- 占比与强度指标
    renewable_input_ratio NUMERIC(5,2) NOT NULL CHECK (renewable_input_ratio BETWEEN 0 AND 100),
    renewable_output_ratio NUMERIC(5,2) NOT NULL CHECK (renewable_output_ratio BETWEEN 0 AND 100),
    packaging_intensity NUMERIC(8,2) NOT NULL CHECK (packaging_intensity >= 0),
    paper_intensity NUMERIC(8,2) NOT NULL CHECK (paper_intensity >= 0)
);

CREATE TABLE energy (
    id SERIAL PRIMARY KEY,
    factory VARCHAR(100) NOT NULL,
    year INTEGER NOT NULL,

    -- 月度数据 (JSON格式存储12个月数据)
    purchased_power JSONB NOT NULL,
    renewable_power JSONB NOT NULL,
    gasoline JSONB NOT NULL,
    diesel JSONB NOT NULL,
    natural_gas JSONB NOT NULL,
    other_energy JSONB NOT NULL,

    -- 年度汇总
    total_purchased_power DOUBLE PRECISION,
    total_renewable_power DOUBLE PRECISION,
    total_gasoline DOUBLE PRECISION,
    total_diesel DOUBLE PRECISION,
    total_natural_gas DOUBLE PRECISION,
    total_other_energy DOUBLE PRECISION,

    -- 能源消耗
    water_consumption DOUBLE PRECISION,
    power_consumption DOUBLE PRECISION,
    gasoline_consumption DOUBLE PRECISION,
    diesel_consumption DOUBLE PRECISION,
    natural_gas_consumption DOUBLE PRECISION,
    total_energy_consumption DOUBLE PRECISION,
    turnover DOUBLE PRECISION,
    energy_consumption_intensity DOUBLE PRECISION
);

CREATE TABLE water (
    id SERIAL PRIMARY KEY,
    factory VARCHAR(100) NOT NULL,
    year INTEGER NOT NULL,

    -- 月度数据 (JSON格式)
    industrial JSON NOT NULL,
    domestic JSON NOT NULL,
    reclaimed JSON NOT NULL,
    total JSON NOT NULL,

    -- 工业用水指标
    industrial_total FLOAT NOT NULL,
    industrial_drainage FLOAT NOT NULL,
    industrial_consumption FLOAT NOT NULL,
    industrial_recycled FLOAT NOT NULL,

    -- 生活用水指标
    domestic_total FLOAT NOT NULL,
    domestic_drainage FLOAT NOT NULL,
    domestic_consumption FLOAT NOT NULL,
    domestic_recycled FLOAT NOT NULL,

    -- 中水指标
    reclaimed_total FLOAT NOT NULL,
    total_revenue FLOAT NOT NULL,
    reclaimed_intensity FLOAT NOT NULL,

    -- 汇总指标
    total_intake FLOAT NOT NULL,
    total_drainage FLOAT NOT NULL,
    total_consumption FLOAT NOT NULL,
    total_recycled FLOAT NOT NULL,
    water_intensity FLOAT NOT NULL,
    water_recycle_rate FLOAT NOT NULL
);

CREATE TABLE emission (
    id SERIAL PRIMARY KEY,
    factory VARCHAR(100) NOT NULL,
    year INTEGER NOT NULL,

    -- 温室气体排放字段
    category_one FLOAT NOT NULL,
    category_two FLOAT NOT NULL,
    category_three FLOAT NOT NULL,
    category_four FLOAT NOT NULL,
    category_five FLOAT NOT NULL,
    category_six FLOAT NOT NULL,
    revenue FLOAT NOT NULL,

    -- 计算指标
    category_three_total FLOAT NOT NULL,
    total_emission FLOAT NOT NULL,
    emission_intensity FLOAT NOT NULL,

    -- 废气排放字段
    voc FLOAT NOT NULL,
    nmhc FLOAT NOT NULL,
    benzene FLOAT NOT NULL,
    particulate FLOAT NOT NULL,
    custom_emissions JSONB NOT NULL,
    waste_gas_total FLOAT NOT NULL
);


-- 新增：废弃物总表（多工厂年度矩阵）
CREATE TABLE waste (
    id SERIAL PRIMARY KEY,
    year INTEGER NOT NULL,
    factory VARCHAR(100) NOT NULL,

    -- 月度数据 (JSON数组)
    epe JSONB NOT NULL,
    plastic_paper JSONB NOT NULL,
    domestic_industrial JSONB NOT NULL,
    hazardous JSONB NOT NULL,
    wastewater JSONB NOT NULL,

    -- 计算指标
    epe_total FLOAT NOT NULL,
    plastic_paper_total FLOAT NOT NULL,
    domestic_industrial_total FLOAT NOT NULL,
    hazardous_total FLOAT NOT NULL,
    wastewater_total FLOAT NOT NULL,
    non_hazardous_total FLOAT NOT NULL,
    recyclable_total FLOAT NOT NULL,
    total_waste FLOAT NOT NULL,
    disposal_required_total FLOAT NOT NULL,
    recycle_rate FLOAT NOT NULL,

    -- 经营与合规
    revenue FLOAT NOT NULL,
    protective_reuse_rate FLOAT NOT NULL,
    exceed_events INTEGER NOT NULL,

    -- 强度指标
    hazardous_intensity FLOAT NOT NULL,
    wastewater_intensity FLOAT NOT NULL
);



CREATE TABLE investment (
    id SERIAL PRIMARY KEY,
    year INTEGER NOT NULL,
    factory VARCHAR(100) NOT NULL,

    -- 月度数据 (JSONB格式存储数组)
    env_invest JSONB NOT NULL,
    clean_tech_invest JSONB NOT NULL,
    climate_invest JSONB NOT NULL,
    green_income JSONB NOT NULL,

    -- 计算指标
    env_invest_total FLOAT NOT NULL,
    clean_tech_invest_total FLOAT NOT NULL,
    climate_invest_total FLOAT NOT NULL,
    green_income_total FLOAT NOT NULL,
    total_investment FLOAT NOT NULL,
    green_income_ratio FLOAT NOT NULL
);

CREATE TABLE employment (
    id SERIAL PRIMARY KEY,
    factory VARCHAR(100) NOT NULL,
    year INTEGER NOT NULL,

    -- 员工构成数据
    full_time INTEGER DEFAULT 0 NOT NULL,
    part_time INTEGER DEFAULT 0 NOT NULL,
    male INTEGER DEFAULT 0 NOT NULL,
    female INTEGER DEFAULT 0 NOT NULL,
    management INTEGER DEFAULT 0 NOT NULL,
    management_female INTEGER DEFAULT 0 NOT NULL,
    middle INTEGER DEFAULT 0 NOT NULL,
    general INTEGER DEFAULT 0 NOT NULL,
    mainland INTEGER DEFAULT 0 NOT NULL,
    overseas INTEGER DEFAULT 0 NOT NULL,
    edu_phd INTEGER DEFAULT 0 NOT NULL,
    edu_master INTEGER DEFAULT 0 NOT NULL,
    edu_bachelor INTEGER DEFAULT 0 NOT NULL,
    edu_junior INTEGER DEFAULT 0 NOT NULL,

    -- 五险一金数据
    avg_social_fund NUMERIC(10, 2) DEFAULT 0.00 NOT NULL,
    inc_social_fund NUMERIC(10, 2) DEFAULT 0.00 NOT NULL,

    -- 年龄分布
    age18_30 INTEGER DEFAULT 0 NOT NULL,
    age31_45 INTEGER DEFAULT 0 NOT NULL,
    age46_60 INTEGER DEFAULT 0 NOT NULL,

    -- 新员工与离职数据
    new_hires INTEGER DEFAULT 0 NOT NULL,
    quit_male INTEGER DEFAULT 0 NOT NULL,
    quit_female INTEGER DEFAULT 0 NOT NULL,
    quit_mainland INTEGER DEFAULT 0 NOT NULL,
    quit_overseas INTEGER DEFAULT 0 NOT NULL,
    quit18_30 INTEGER DEFAULT 0 NOT NULL,
    quit31_45 INTEGER DEFAULT 0 NOT NULL,
    quit46_60 INTEGER DEFAULT 0 NOT NULL,
    quit_management INTEGER DEFAULT 0 NOT NULL,
    quit_middle INTEGER DEFAULT 0 NOT NULL,
    quit_general INTEGER DEFAULT 0 NOT NULL,

    -- 计算指标
    total_employees INTEGER DEFAULT 0 NOT NULL,
    quit_total INTEGER DEFAULT 0 NOT NULL,
    turnover_rate NUMERIC(5, 2) DEFAULT 0.00 NOT NULL,
    male_turnover_rate NUMERIC(5, 2) DEFAULT 0.00 NOT NULL,
    female_turnover_rate NUMERIC(5, 2) DEFAULT 0.00 NOT NULL,
    mainland_turnover_rate NUMERIC(5, 2) DEFAULT 0.00 NOT NULL,
    overseas_t极简风格over_rate NUMERIC(5, 2) DEFAULT 0.00 NOT NULL,
    age18_30_turnover_rate NUMERIC(5, 2) DEFAULT 0.00 NOT NULL,
    age31_45_turnover_rate NUMERIC(5, 2) DEFAULT 0.00 NOT NULL,
    age46_60_turnover_rate NUMERIC(5, 2) DEFAULT 0.00 NOT NULL,
    management_turnover_rate NUMERIC(5, 2) DEFAULT 0.00 NOT NULL,
    middle_turnover_rate NUMERIC(5, 2) DEFAULT 0.00 NOT NULL,
    general_turnover_rate NUMERIC(5, 2) DEFAULT 0.00 NOT NULL,

    -- 唯一约束：同工厂同一年份只能有一条记录
    CONSTRAINT uq_factory_year UNIQUE (factory, year)
);


CREATE TABLE training (
    id SERIAL PRIMARY KEY,
    factory VARCHAR(100) NOT NULL,
    year INTEGER NOT NULL,

    -- 基础数据
    total INTEGER DEFAULT 0 NOT NULL,
    trained INTEGER DEFAULT 0 NOT NULL,
    male INTEGER DEFAULT 0 NOT NULL,
    female INTEGER DEFAULT 0 NOT NULL,
    mgmt INTEGER DEFAULT 0 NOT NULL,
    middle INTEGER DEFAULT 0 NOT NULL,
    general INTEGER DEFAULT 0 NOT NULL,
    hours_total NUMERIC(10, 1) DEFAULT 0.0 NOT NULL,
    hours_male NUMERIC(10, 1) DEFAULT 0.0 NOT NULL,
    hours_female NUMERIC(10, 1) DEFAULT 0.0 NOT NULL,
    hours_mgmt NUMERIC(10, 1) DEFAULT 0.0 NOT NULL,
    hours_middle NUMERIC(10, 1) DEFAULT 0.0 NOT NULL,
    hours_general NUMERIC(10, 1) DEFAULT 0.0 NOT NULL,

    -- 计算指标
    coverage_rate NUMERIC(5, 2) DEFAULT 0.00 NOT NULL,
    male_rate NUMERIC(5, 2) DEFAULT 0.00 NOT NULL,
    female_rate NUMERIC(5, 2) DEFAULT 0.00 NOT NULL,
    mgmt_rate NUMERIC(5, 2) DEFAULT 0.00 NOT NULL,
    middle_rate NUMERIC(5, 2) DEFAULT 0.00 NOT NULL,
    general_rate NUMERIC(5, 2) DEFAULT 0.00 NOT NULL,

    -- 唯一约束
    CONSTRAINT uq_training_factory_year UNIQUE (factory, year)
);


-- 添加索引
CREATE INDEX IF NOT EXISTS idx_factory_year ON material (factory, year);
CREATE INDEX IF NOT EXISTS idx_factory ON material(factory);
CREATE INDEX IF NOT EXISTS idx_energy_factory ON energy(factory);
CREATE INDEX IF NOT EXISTS idx_energy_year ON energy(year);
CREATE INDEX IF NOT EXISTS idx_energy_factory_year ON energy(factory, year);
CREATE INDEX IF NOT EXISTS idx_water_data_factory ON water(factory);
CREATE INDEX IF NOT EXISTS idx_water_data_year ON water(year);
CREATE INDEX IF NOT EXISTS idx_water_data_factory_year ON water(factory, year);
CREATE INDEX IF NOT EXISTS idx_emission_factory ON emission(factory);
CREATE INDEX IF NOT EXISTS idx_emission_year ON emission(year);
CREATE INDEX IF NOT EXISTS idx_emission_factory_year ON emission(factory, year);
CREATE INDEX idx_waste_factory_year ON waste(factory, year);
CREATE INDEX idx_waste_year ON waste(year);
CREATE INDEX idx_investment_factory_year ON investment(factory, year);
CREATE INDEX idx_investment_year ON investment(year);
CREATE INDEX idx_employment_factory_year ON employment(factory, year);
CREATE INDEX idx_employment_year ON employment(year);
CREATE INDEX idx_training_factory_year ON training(factory, year);
CREATE INDEX idx_training_year ON training(year);


-- 新增：职业健康与安全（OHS）
CREATE TABLE IF NOT EXISTS ohs (
    id SERIAL PRIMARY KEY,
    year INTEGER NOT NULL,
    factories JSONB NOT NULL,

    training_count JSONB NOT NULL,
    training_participants JSONB NOT NULL,
    training_hours JSONB NOT NULL,
    injury_count JSONB NOT NULL,
    incident_count JSONB NOT NULL,
    fatality_count JSONB NOT NULL,
    lost_workdays JSONB NOT NULL,
    safety_investment JSONB NOT NULL,

    training_count_totals JSONB NOT NULL,
    training_participants_totals JSONB NOT NULL,
    training_hours_totals JSONB NOT NULL,
    injury_count_totals JSONB NOT NULL,
    incident_count_totals JSONB NOT NULL,
    fatality_count_totals JSONB NOT NULL,
    lost_workdays_totals JSONB NOT NULL,
    safety_investment_totals JSONB NOT NULL,

    summary JSONB NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_ohs_year ON ohs(year);
CREATE INDEX IF NOT EXISTS idx_satisfaction_year ON satisfaction(year);

CREATE TABLE satisfaction (
    id SERIAL PRIMARY KEY,
    factory VARCHAR(100) NOT NULL,
    year INTEGER NOT NULL,
    satisfaction JSONB NOT NULL,  -- 存储12个月份的满意度数据
    annual_average NUMERIC(5,2) DEFAULT 0.00 NOT NULL, -- 年度平均值
    CONSTRAINT uq_satisfaction_factory_year UNIQUE (factory, year)
);


CREATE TABLE supply (
    id SERIAL PRIMARY KEY,
    factory VARCHAR(100) NOT NULL,
    year INTEGER NOT NULL,

    -- 供应商分布
    east INTEGER DEFAULT 0,
    south INTEGER DEFAULT 0,
    other INTEGER DEFAULT 0,
    total_suppliers INTEGER DEFAULT 0,

    -- 供应商筛选
    env_screened INTEGER DEFAULT 0,
    soc_screened INTEGER DEFAULT 0,

    -- 采购金额
    local_amount NUMERIC(12, 2) DEFAULT 0.00,
    total_amount NUMERIC(12, 2) DEFAULT 0.00,

    -- 供应商问题
    env_penalty_count INTEGER DEFAULT 0,
    env_penalty_amount NUMERIC(12, 2) DEFAULT 0.00,
    cyber_incidents INTEGER DEFAULT 0,

    -- 计算指标
    env_ratio NUMERIC(5, 2) DEFAULT 0.00,
    soc_ratio NUMERIC(5, 2) DEFAULT 0.00,
    local_purchase_ratio NUMERIC(5, 2) DEFAULT 0.00,

    -- 唯一约束
    CONSTRAINT uq_supply_factory_year UNIQUE (factory, year)
);

CREATE INDEX IF NOT EXISTS idx_supply_year ON supply(year);