CREATE TABLE material (
    id SERIAL PRIMARY KEY,
    factory_name VARCHAR(100) NOT NULL DEFAULT '未命名工厂',
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

-- 添加索引优化查询性能
CREATE INDEX IF NOT EXISTS idx_factory_year ON material (factory_name, year);
CREATE INDEX IF NOT EXISTS idx_energy_factory ON energy(factory);
CREATE INDEX IF NOT EXISTS idx_energy_year ON energy(year);
CREATE INDEX IF NOT EXISTS idx_energy_factory_year ON energy(factory, year);
CREATE INDEX IF NOT EXISTS idx_water_data_factory ON water(factory);
CREATE INDEX IF NOT EXISTS idx_water_data_year ON water(year);
CREATE INDEX IF NOT EXISTS idx_water_data_factory_year ON water(factory, year);
CREATE INDEX IF NOT EXISTS idx_emission_factory ON emission(factory);
CREATE INDEX IF NOT EXISTS idx_emission_year ON emission(year);
CREATE INDEX IF NOT EXISTS idx_emission_factory_year ON emission(factory, year);

-- 新增：废弃物总表（多工厂年度矩阵）
CREATE TABLE IF NOT EXISTS waste (
    id SERIAL PRIMARY KEY,
    year INTEGER NOT NULL,

    -- 工厂清单
    factories JSONB NOT NULL,

    -- 月度矩阵 [工厂][12]
    epe JSONB NOT NULL,
    plastic_paper JSONB NOT NULL,
    domestic_industrial JSONB NOT NULL,
    hazardous JSONB NOT NULL,
    wastewater JSONB NOT NULL,

    -- 行合计
    epe_totals JSONB NOT NULL,
    plastic_paper_totals JSONB NOT NULL,
    domestic_industrial_totals JSONB NOT NULL,
    hazardous_totals JSONB NOT NULL,
    wastewater_totals JSONB NOT NULL,

    -- 推导指标
    non_hazardous_totals JSONB NOT NULL,
    recyclable_totals JSONB NOT NULL,
    total_waste JSONB NOT NULL,
    disposal_required_totals JSONB NOT NULL,
    recycle_rate JSONB NOT NULL,

    -- 经营与合规
    revenue JSONB NOT NULL,
    protective_reuse_rate JSONB NOT NULL,
    exceed_events JSONB NOT NULL,

    -- 总览
    overall JSONB NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_waste_year ON waste(year);

-- 新增：资金投入（年度多工厂矩阵）
CREATE TABLE IF NOT EXISTS investment (
    id SERIAL PRIMARY KEY,
    year INTEGER NOT NULL,
    factories JSONB NOT NULL,

    env_invest JSONB NOT NULL,
    clean_tech_invest JSONB NOT NULL,
    climate_invest JSONB NOT NULL,
    green_income JSONB NOT NULL,

    env_invest_totals JSONB NOT NULL,
    clean_tech_invest_totals JSONB NOT NULL,
    climate_invest_totals JSONB NOT NULL,
    green_income_totals JSONB NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_investment_year ON investment(year);

-- 新增：雇佣（总部统计）
CREATE TABLE IF NOT EXISTS employment (
    id SERIAL PRIMARY KEY,
    year INTEGER NOT NULL,
    records JSONB NOT NULL,
    summary JSONB NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_employment_year ON employment(year);

-- 新增：教育与培训（总部统计）
CREATE TABLE IF NOT EXISTS training (
    id SERIAL PRIMARY KEY,
    year INTEGER NOT NULL,
    records JSONB NOT NULL,
    summary JSONB NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_training_year ON training(year);

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

-- 新增：员工满意度
CREATE TABLE IF NOT EXISTS satisfaction (
    id SERIAL PRIMARY KEY,
    year INTEGER NOT NULL,
    factories JSONB NOT NULL,
    satisfaction JSONB NOT NULL,
    row_averages JSONB NOT NULL,
    monthly_averages JSONB NOT NULL,
    overall_average DOUBLE PRECISION NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_satisfaction_year ON satisfaction(year);

-- 新增：供应链管理（供应商统计）
CREATE TABLE IF NOT EXISTS supply (
    id SERIAL PRIMARY KEY,
    year INTEGER NOT NULL,
    records JSONB NOT NULL,
    summary JSONB NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_supply_year ON supply(year);