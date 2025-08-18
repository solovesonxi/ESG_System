CREATE TABLE material (
    id SERIAL PRIMARY KEY,
    factory_name VARCHAR(100) NOT NULL DEFAULT '未命名工厂',
    report_year INTEGER NOT NULL CHECK (report_year BETWEEN 1949 AND EXTRACT(YEAR FROM CURRENT_DATE)),

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


CREATE INDEX idx_factory_year ON material (factory_name, report_year);
CREATE INDEX idx_energy_factory ON energy(factory);
CREATE INDEX idx_energy_year ON energy(year);
CREATE INDEX idx_energy_factory_year ON energy(factory, year);