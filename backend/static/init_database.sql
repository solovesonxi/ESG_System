DROP TABLE IF EXISTS "material" CASCADE;
DROP TABLE IF EXISTS "energy" CASCADE;
DROP TABLE IF EXISTS "water" CASCADE;
DROP TABLE IF EXISTS "emission" CASCADE;
DROP TABLE IF EXISTS "waste" CASCADE;
DROP TABLE IF EXISTS "investment" CASCADE;
DROP TABLE IF EXISTS "employment" CASCADE;
DROP TABLE IF EXISTS "training" CASCADE;
DROP TABLE IF EXISTS "ohs" CASCADE;
DROP TABLE IF EXISTS "satisfaction" CASCADE;
DROP TABLE IF EXISTS "env_quant" CASCADE;
DROP TABLE IF EXISTS "env_qual" CASCADE;
DROP TABLE IF EXISTS "labor_reasons" CASCADE;
DROP TABLE IF EXISTS "product_responsibility" CASCADE;
DROP TABLE IF EXISTS "ipr" CASCADE;
DROP TABLE IF EXISTS "community" CASCADE;
DROP TABLE IF EXISTS "volunteer" CASCADE;
DROP TABLE IF EXISTS "other_reasons" CASCADE;
DROP TABLE IF EXISTS "labor_qualitative" CASCADE;
DROP TABLE IF EXISTS "other_qualitative" CASCADE;
DROP TABLE IF EXISTS "supply" CASCADE;


CREATE TABLE material
(
    factory                VARCHAR(100)   NOT NULL DEFAULT '未命名工厂',
    year                   INTEGER        NOT NULL CHECK (year BETWEEN 1949 AND EXTRACT(YEAR FROM CURRENT_DATE)),
    PRIMARY KEY (factory, year),
    -- 进料数据
    renewable_input        NUMERIC(10, 2) NOT NULL CHECK (renewable_input >= 0),
    non_renewable_input    NUMERIC(10, 2) NOT NULL CHECK (non_renewable_input >= 0),
    total_input            NUMERIC(10, 2) NOT NULL CHECK (total_input >= 0),

    -- 出料数据
    renewable_output       NUMERIC(10, 2) NOT NULL CHECK (renewable_output >= 0),
    non_renewable_output   NUMERIC(10, 2) NOT NULL CHECK (non_renewable_output >= 0),
    total_output           NUMERIC(10, 2) NOT NULL CHECK (total_output >= 0),

    -- 消耗数据
    material_consumption   NUMERIC(10, 2) NOT NULL CHECK (material_consumption >= 0),
    packaging_material     NUMERIC(10, 2) NOT NULL CHECK (packaging_material >= 0),
    paper_consumption      NUMERIC(10, 2) NOT NULL CHECK (paper_consumption >= 0),
    total_revenue          NUMERIC(10, 2) NOT NULL CHECK (total_revenue >= 0),

    -- 占比与强度指标
    renewable_input_ratio  NUMERIC(5, 2)  NOT NULL CHECK (renewable_input_ratio BETWEEN 0 AND 100),
    renewable_output_ratio NUMERIC(5, 2)  NOT NULL CHECK (renewable_output_ratio BETWEEN 0 AND 100),
    packaging_intensity    NUMERIC(8, 2)  NOT NULL CHECK (packaging_intensity >= 0),
    paper_intensity        NUMERIC(8, 2)  NOT NULL CHECK (paper_intensity >= 0)
);

CREATE TABLE energy
(
    factory                      VARCHAR(100) NOT NULL,
    year                         INTEGER      NOT NULL,
    PRIMARY KEY (factory, year),

    -- 月度数据 (JSON格式存储12个月数据)
    purchased_power              JSONB        NOT NULL,
    renewable_power              JSONB        NOT NULL,
    gasoline                     JSONB        NOT NULL,
    diesel                       JSONB        NOT NULL,
    natural_gas                  JSONB        NOT NULL,
    other_energy                 JSONB        NOT NULL,

    -- 年度汇总
    total_purchased_power        DOUBLE PRECISION,
    total_renewable_power        DOUBLE PRECISION,
    total_gasoline               DOUBLE PRECISION,
    total_diesel                 DOUBLE PRECISION,
    total_natural_gas            DOUBLE PRECISION,
    total_other_energy           DOUBLE PRECISION,

    -- 能源消耗
    water_consumption            DOUBLE PRECISION,
    power_consumption            DOUBLE PRECISION,
    gasoline_consumption         DOUBLE PRECISION,
    diesel_consumption           DOUBLE PRECISION,
    natural_gas_consumption      DOUBLE PRECISION,
    total_energy_consumption     DOUBLE PRECISION,
    turnover                     DOUBLE PRECISION,
    energy_consumption_intensity DOUBLE PRECISION
);

CREATE TABLE water
(
    factory                VARCHAR(100) NOT NULL,
    year                   INTEGER      NOT NULL,
    PRIMARY KEY (factory, year),

    -- 月度数据 (JSON格式)
    industrial             JSON         NOT NULL,
    domestic               JSON         NOT NULL,
    reclaimed              JSON         NOT NULL,
    total                  JSON         NOT NULL,

    -- 工业用水指标
    industrial_total       FLOAT        NOT NULL,
    industrial_drainage    FLOAT        NOT NULL,
    industrial_consumption FLOAT        NOT NULL,
    industrial_recycled    FLOAT        NOT NULL,

    -- 生活用水指标
    domestic_total         FLOAT        NOT NULL,
    domestic_drainage      FLOAT        NOT NULL,
    domestic_consumption   FLOAT        NOT NULL,
    domestic_recycled      FLOAT        NOT NULL,

    -- 中水指标
    reclaimed_total        FLOAT        NOT NULL,
    total_revenue          FLOAT        NOT NULL,
    reclaimed_intensity    FLOAT        NOT NULL,

    -- 汇总指标
    total_intake           FLOAT        NOT NULL,
    total_drainage         FLOAT        NOT NULL,
    total_consumption      FLOAT        NOT NULL,
    total_recycled         FLOAT        NOT NULL,
    water_intensity        FLOAT        NOT NULL,
    water_recycle_rate     FLOAT        NOT NULL
);

CREATE TABLE emission
(
    factory              VARCHAR(100) NOT NULL,
    year                 INTEGER      NOT NULL,
    PRIMARY KEY (factory, year),

    -- 温室气体排放字段
    category_one         FLOAT        NOT NULL,
    category_two         FLOAT        NOT NULL,
    category_three       FLOAT        NOT NULL,
    category_four        FLOAT        NOT NULL,
    category_five        FLOAT        NOT NULL,
    category_six         FLOAT        NOT NULL,
    revenue              FLOAT        NOT NULL,

    -- 计算指标
    category_three_total FLOAT        NOT NULL,
    total_emission       FLOAT        NOT NULL,
    emission_intensity   FLOAT        NOT NULL,

    -- 废气排放字段
    voc                  FLOAT        NOT NULL,
    nmhc                 FLOAT        NOT NULL,
    benzene              FLOAT        NOT NULL,
    particulate          FLOAT        NOT NULL,
    custom_emissions     JSONB        NOT NULL,
    waste_gas_total      FLOAT        NOT NULL
);


-- 新增：废弃物总表（多工厂年度矩阵）
CREATE TABLE waste
(
    year                      INTEGER      NOT NULL,
    PRIMARY KEY (factory, year),
    factory                   VARCHAR(100) NOT NULL,

    -- 月度数据 (JSON数组)
    epe                       JSONB        NOT NULL,
    plastic_paper             JSONB        NOT NULL,
    domestic_industrial       JSONB        NOT NULL,
    hazardous                 JSONB        NOT NULL,
    wastewater                JSONB        NOT NULL,

    -- 计算指标
    epe_total                 FLOAT        NOT NULL,
    plastic_paper_total       FLOAT        NOT NULL,
    domestic_industrial_total FLOAT        NOT NULL,
    hazardous_total           FLOAT        NOT NULL,
    wastewater_total          FLOAT        NOT NULL,
    non_hazardous_total       FLOAT        NOT NULL,
    recyclable_total          FLOAT        NOT NULL,
    total_waste               FLOAT        NOT NULL,
    disposal_required_total   FLOAT        NOT NULL,
    recycle_rate              FLOAT        NOT NULL,

    -- 经营与合规
    revenue                   FLOAT        NOT NULL,
    protective_reuse_rate     FLOAT        NOT NULL,
    exceed_events             INTEGER      NOT NULL,

    -- 强度指标
    hazardous_intensity       FLOAT        NOT NULL,
    wastewater_intensity      FLOAT        NOT NULL
);


CREATE TABLE investment
(
    year                    INTEGER      NOT NULL,
    factory                 VARCHAR(100) NOT NULL,
    PRIMARY KEY (factory, year),

    -- 月度数据 (JSONB格式存储数组)
    env_invest              JSONB        NOT NULL,
    clean_tech_invest       JSONB        NOT NULL,
    climate_invest          JSONB        NOT NULL,
    green_income            JSONB        NOT NULL,

    -- 计算指标
    env_invest_total        FLOAT        NOT NULL,
    clean_tech_invest_total FLOAT        NOT NULL,
    climate_invest_total    FLOAT        NOT NULL,
    green_income_total      FLOAT        NOT NULL,
    total_investment        FLOAT        NOT NULL,
    green_income_ratio      FLOAT        NOT NULL
);


CREATE TABLE employment
(
    factory                     VARCHAR(100)                NOT NULL,
    year                        INTEGER                     NOT NULL,
    PRIMARY KEY (factory, year),

    -- 员工构成数据
    full_time                   INTEGER        DEFAULT 0    NOT NULL,
    part_time                   INTEGER        DEFAULT 0    NOT NULL,
    male                        INTEGER        DEFAULT 0    NOT NULL,
    female                      INTEGER        DEFAULT 0    NOT NULL,
    management                  INTEGER        DEFAULT 0    NOT NULL,
    management_female           INTEGER        DEFAULT 0    NOT NULL,
    middle                      INTEGER        DEFAULT 0    NOT NULL,
    general                     INTEGER        DEFAULT 0    NOT NULL,
    mainland                    INTEGER        DEFAULT 0    NOT NULL,
    overseas                    INTEGER        DEFAULT 0    NOT NULL,
    edu_phd                     INTEGER        DEFAULT 0    NOT NULL,
    edu_master                  INTEGER        DEFAULT 0    NOT NULL,
    edu_bachelor                INTEGER        DEFAULT 0    NOT NULL,
    edu_junior                  INTEGER        DEFAULT 0    NOT NULL,

    -- 五险一金数据
    avg_social_fund             NUMERIC(10, 2) DEFAULT 0.00 NOT NULL,
    inc_social_fund             NUMERIC(10, 2) DEFAULT 0.00 NOT NULL,

    -- 年龄分布
    age18_30                    INTEGER        DEFAULT 0    NOT NULL,
    age31_45                    INTEGER        DEFAULT 0    NOT NULL,
    age46_60                    INTEGER        DEFAULT 0    NOT NULL,

    -- 新员工与离职数据
    new_hires                   INTEGER        DEFAULT 0    NOT NULL,
    quit_male                   INTEGER        DEFAULT 0    NOT NULL,
    quit_female                 INTEGER        DEFAULT 0    NOT NULL,
    quit_mainland               INTEGER        DEFAULT 0    NOT NULL,
    quit_overseas               INTEGER        DEFAULT 0    NOT NULL,
    quit18_30                   INTEGER        DEFAULT 0    NOT NULL,
    quit31_45                   INTEGER        DEFAULT 0    NOT NULL,
    quit46_60                   INTEGER        DEFAULT 0    NOT NULL,
    quit_management             INTEGER        DEFAULT 0    NOT NULL,
    quit_middle                 INTEGER        DEFAULT 0    NOT NULL,
    quit_general                INTEGER        DEFAULT 0    NOT NULL,

    -- 计算指标
    total_employees             INTEGER        DEFAULT 0    NOT NULL,
    quit_total                  INTEGER        DEFAULT 0    NOT NULL,
    turnover_rate               NUMERIC(5, 2)  DEFAULT 0.00 NOT NULL,
    male_turnover_rate          NUMERIC(5, 2)  DEFAULT 0.00 NOT NULL,
    female_turnover_rate        NUMERIC(5, 2)  DEFAULT 0.00 NOT NULL,
    mainland_turnover_rate      NUMERIC(5, 2)  DEFAULT 0.00 NOT NULL,
    overseas_t极简风格over_rate NUMERIC(5, 2)  DEFAULT 0.00 NOT NULL,
    age18_30_turnover_rate      NUMERIC(5, 2)  DEFAULT 0.00 NOT NULL,
    age31_45_turnover_rate      NUMERIC(5, 2)  DEFAULT 0.00 NOT NULL,
    age46_60_turnover_rate      NUMERIC(5, 2)  DEFAULT 0.00 NOT NULL,
    management_turnover_rate    NUMERIC(5, 2)  DEFAULT 0.00 NOT NULL,
    middle_turnover_rate        NUMERIC(5, 2)  DEFAULT 0.00 NOT NULL,
    general_turnover_rate       NUMERIC(5, 2)  DEFAULT 0.00 NOT NULL
);


CREATE TABLE training
(
    factory       VARCHAR(100)                NOT NULL,
    year          INTEGER                     NOT NULL,
    PRIMARY KEY (factory, year),

    -- 基础数据
    total         INTEGER        DEFAULT 0    NOT NULL,
    trained       INTEGER        DEFAULT 0    NOT NULL,
    male          INTEGER        DEFAULT 0    NOT NULL,
    female        INTEGER        DEFAULT 0    NOT NULL,
    mgmt          INTEGER        DEFAULT 0    NOT NULL,
    middle        INTEGER        DEFAULT 0    NOT NULL,
    general       INTEGER        DEFAULT 0    NOT NULL,
    hours_total   NUMERIC(10, 1) DEFAULT 0.0  NOT NULL,
    hours_male    NUMERIC(10, 1) DEFAULT 0.0  NOT NULL,
    hours_female  NUMERIC(10, 1) DEFAULT 0.0  NOT NULL,
    hours_mgmt    NUMERIC(10, 1) DEFAULT 0.0  NOT NULL,
    hours_middle  NUMERIC(10, 1) DEFAULT 0.0  NOT NULL,
    hours_general NUMERIC(10, 1) DEFAULT 0.0  NOT NULL,

    -- 计算指标
    coverage_rate NUMERIC(5, 2)  DEFAULT 0.00 NOT NULL,
    male_rate     NUMERIC(5, 2)  DEFAULT 0.00 NOT NULL,
    female_rate   NUMERIC(5, 2)  DEFAULT 0.00 NOT NULL,
    mgmt_rate     NUMERIC(5, 2)  DEFAULT 0.00 NOT NULL,
    middle_rate   NUMERIC(5, 2)  DEFAULT 0.00 NOT NULL,
    general_rate  NUMERIC(5, 2)  DEFAULT 0.00 NOT NULL
);


CREATE TABLE ohs
(
    factory                     VARCHAR(100) NOT NULL,
    year                        INTEGER      NOT NULL,
    PRIMARY KEY (factory, year),
    training_count              JSONB        NOT NULL,
    training_participants       JSONB        NOT NULL,
    training_hours              JSONB        NOT NULL,
    injury_count                JSONB        NOT NULL,
    incident_count              JSONB        NOT NULL,
    fatality_count              JSONB        NOT NULL,
    lost_workdays               JSONB        NOT NULL,
    safety_investment           JSONB        NOT NULL,
    training_count_total        INTEGER        DEFAULT 0,
    training_participants_total INTEGER        DEFAULT 0,
    training_hours_total        NUMERIC(10, 1) DEFAULT 0.0,
    injury_count_total          INTEGER        DEFAULT 0,
    incident_count_total        INTEGER        DEFAULT 0,
    fatality_count_total        INTEGER        DEFAULT 0,
    lost_workdays_total         INTEGER        DEFAULT 0,
    safety_investment_total     NUMERIC(10, 2) DEFAULT 0.0,
    safety_managers             INTEGER        DEFAULT 0,
    medical_checks              INTEGER        DEFAULT 0,
    coverage_rate               NUMERIC(5, 2)  DEFAULT 0.00,
    emergency_drills            INTEGER        DEFAULT 0,
    hazards_found               INTEGER        DEFAULT 0,
    occupational_checks         INTEGER        DEFAULT 0
);


CREATE TABLE satisfaction
(
    factory        VARCHAR(100)               NOT NULL,
    year           INTEGER                    NOT NULL,
    PRIMARY KEY (factory, year),
    satisfaction   JSONB                      NOT NULL, -- 存储12个月份的满意度数据
    annual_average NUMERIC(5, 2) DEFAULT 0.00 NOT NULL
);


CREATE TABLE supply
(
    factory              VARCHAR(100) NOT NULL,
    year                 INTEGER      NOT NULL,
    PRIMARY KEY (factory, year),

    -- 供应商分布
    east                 INTEGER        DEFAULT 0,
    south                INTEGER        DEFAULT 0,
    other                INTEGER        DEFAULT 0,
    total_suppliers      INTEGER        DEFAULT 0,

    -- 供应商筛选
    env_screened         INTEGER        DEFAULT 0,
    soc_screened         INTEGER        DEFAULT 0,

    -- 采购金额
    local_amount         NUMERIC(12, 2) DEFAULT 0.00,
    total_amount         NUMERIC(12, 2) DEFAULT 0.00,

    -- 供应商问题
    env_penalty_count    INTEGER        DEFAULT 0,
    env_penalty_amount   NUMERIC(12, 2) DEFAULT 0.00,
    cyber_incidents      INTEGER        DEFAULT 0,

    -- 计算指标
    env_ratio            NUMERIC(5, 2)  DEFAULT 0.00,
    soc_ratio            NUMERIC(5, 2)  DEFAULT 0.00,
    local_purchase_ratio NUMERIC(5, 2)  DEFAULT 0.00
);


-- 添加索引
CREATE INDEX IF NOT EXISTS idx_factory_year ON material (factory, year);
CREATE INDEX IF NOT EXISTS idx_factory ON material (factory);
CREATE INDEX IF NOT EXISTS idx_year ON material (year);
CREATE INDEX IF NOT EXISTS idx_energy_factory_year ON energy (factory, year);
CREATE INDEX IF NOT EXISTS idx_energy_factory ON energy (factory);
CREATE INDEX IF NOT EXISTS idx_energy_year ON energy (year);
CREATE INDEX IF NOT EXISTS idx_water_data_factory_year ON water (factory, year);
CREATE INDEX IF NOT EXISTS idx_water_data_factory ON water (factory);
CREATE INDEX IF NOT EXISTS idx_water_data_year ON water (year);
CREATE INDEX IF NOT EXISTS idx_emission_factory_year ON emission (factory, year);
CREATE INDEX IF NOT EXISTS idx_emission_factory ON emission (factory);
CREATE INDEX IF NOT EXISTS idx_emission_year ON emission (year);
CREATE INDEX IF NOT EXISTS idx_waste_factory_year ON waste (factory, year);
CREATE INDEX IF NOT EXISTS idx_waste_factory ON waste (factory);
CREATE INDEX IF NOT EXISTS idx_waste_year ON waste (year);
CREATE INDEX IF NOT EXISTS idx_investment_factory_year ON investment (factory, year);
CREATE INDEX IF NOT EXISTS idx_investment_factory ON investment (factory);
CREATE INDEX IF NOT EXISTS idx_investment_year ON investment (year);
CREATE INDEX IF NOT EXISTS idx_employment_factory_year ON employment (factory, year);
CREATE INDEX IF NOT EXISTS idx_employment_factory ON employment (factory);
CREATE INDEX IF NOT EXISTS idx_employment_year ON employment (year);
CREATE INDEX IF NOT EXISTS idx_training_factory_year ON training (factory, year);
CREATE INDEX IF NOT EXISTS idx_training_factory ON training (factory);
CREATE INDEX IF NOT EXISTS idx_training_year ON training (year);
CREATE INDEX IF NOT EXISTS idx_ohs_factory_year ON ohs (factory, year);
CREATE INDEX IF NOT EXISTS idx_ohs_factory ON ohs (factory);
CREATE INDEX IF NOT EXISTS idx_ohs_year ON ohs (year);
CREATE INDEX IF NOT EXISTS idx_satisfaction_factory_year ON satisfaction (factory, year);
CREATE INDEX IF NOT EXISTS idx_satisfaction_factory ON satisfaction (factory);
CREATE INDEX IF NOT EXISTS idx_satisfaction_year ON satisfaction (year);
CREATE INDEX IF NOT EXISTS idx_supply_factory_year ON supply (factory, year);
CREATE INDEX IF NOT EXISTS idx_supply_factory ON supply (factory);
CREATE INDEX IF NOT EXISTS idx_supply_year ON supply (year);


-- 劳动定量原因说明表
CREATE TABLE IF NOT EXISTS labor_reasons
(
    factory   VARCHAR(100) NOT NULL,
    year      INTEGER      NOT NULL,
    indicator VARCHAR(200) NOT NULL,
    PRIMARY KEY (factory, year, indicator),
    reason    TEXT
);


-- 产品责任
CREATE TABLE IF NOT EXISTS product_responsibility
(
    factory                VARCHAR(100) NOT NULL,
    year                   INTEGER      NOT NULL,
    PRIMARY KEY (factory, year),
    complaints_total       INTEGER       DEFAULT 0,
    complaints_handled     INTEGER       DEFAULT 0,
    complaints_handle_rate NUMERIC(5, 2) DEFAULT 0.00,
    customer_satisfaction  NUMERIC(5, 2) DEFAULT 0.00,
    recall_count           INTEGER       DEFAULT 0,
    recall_percent         NUMERIC(6, 2) DEFAULT 0.00,
    product_quality_issues INTEGER       DEFAULT 0,
    cyber_incidents        INTEGER       DEFAULT 0
);

-- 知识产权保护
CREATE TABLE IF NOT EXISTS ipr
(
    factory                  VARCHAR(100) NOT NULL,
    year                     INTEGER      NOT NULL,
    PRIMARY KEY (factory, year),
    patents_total            INTEGER DEFAULT 0,
    invention_total          INTEGER DEFAULT 0,
    invention_applications   INTEGER DEFAULT 0,
    utility_model_total      INTEGER DEFAULT 0,
    design_total             INTEGER DEFAULT 0,
    authorized_total         INTEGER DEFAULT 0,
    new_patents_year         INTEGER DEFAULT 0,
    software_copyright_total INTEGER DEFAULT 0,
    trademarks_total         INTEGER DEFAULT 0
);

-- 社区参与
CREATE TABLE IF NOT EXISTS community
(
    factory              VARCHAR(100) NOT NULL,
    year                 INTEGER      NOT NULL,
    PRIMARY KEY (factory, year),
    donation_total       NUMERIC(12, 2) DEFAULT 0.00,
    community_investment NUMERIC(12, 2) DEFAULT 0.00
);

-- 志愿活动
CREATE TABLE IF NOT EXISTS volunteer
(
    factory      VARCHAR(100) NOT NULL,
    year         INTEGER      NOT NULL,
    PRIMARY KEY (factory, year),
    participants INTEGER        DEFAULT 0,
    hours_total  NUMERIC(12, 2) DEFAULT 0.00
);

-- 其他定量原因说明表
CREATE TABLE IF NOT EXISTS other_reasons
(
    factory   VARCHAR(100) NOT NULL,
    year      INTEGER      NOT NULL,
    indicator VARCHAR(200) NOT NULL,
    PRIMARY KEY (factory, year, indicator),
    reason    TEXT
);

-- 劳动定性数据表
CREATE TABLE IF NOT EXISTS labor_qualitative
(
    factory         VARCHAR(100) NOT NULL,
    year            INTEGER      NOT NULL,
    indicator       VARCHAR(200) NOT NULL,
    PRIMARY KEY (factory, year, indicator),
    current_text    TEXT,
    last_text       TEXT,
    comparison_text TEXT,
    reason          TEXT
);

-- 其他定性数据表
CREATE TABLE IF NOT EXISTS other_qualitative
(
    factory         VARCHAR(100) NOT NULL,
    year            INTEGER      NOT NULL,
    indicator       VARCHAR(200) NOT NULL,
    PRIMARY KEY (factory, year, indicator),
    current_text    TEXT,
    last_text       TEXT,
    comparison_text TEXT,
    reason          TEXT
);
