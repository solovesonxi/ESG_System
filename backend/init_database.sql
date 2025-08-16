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

-- 创建索引优化查询性能
CREATE INDEX idx_factory_year ON material (factory_name, report_year);