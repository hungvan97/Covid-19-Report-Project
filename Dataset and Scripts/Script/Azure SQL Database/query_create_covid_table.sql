CREATE SCHEMA covid_reporting
GO

CREATE TABLE covid_reporting.cases_and_deaths
(
    country                 VARCHAR(100),
    country_code_2_digit    VARCHAR(2),
    country_code_3_digit    VARCHAR(3),
    population              BIGINT,
    cases_count             BIGINT,
    deaths_count            BIGINT,
    reported_date           DATE,
    source                  VARCHAR(500)
)
GO

CREATE TABLE covid_reporting.hospital_admissions_daily
(
    country                 VARCHAR(100),
    country_code_2_digit    VARCHAR(2),
    country_code_3_digit    VARCHAR(3),
    population              BIGINT,
    reported_date           DATE,
    hospital_occupancy_count BIGINT,
    icu_occupancy_count      BIGINT,
    source                  VARCHAR(500)
)
GO

CREATE TABLE covid_reporting.age_group_case
(
    country                 VARCHAR(100),
    country_code_2_digit    VARCHAR(2),
    country_code_3_digit    VARCHAR(3),
    population              BIGINT,
    age_group_0_14          FLOAT,
    age_group_15_24         FLOAT,
    age_group_25_49         FLOAT,
    age_group_50_64         FLOAT,
    age_group_65_79         FLOAT,
	age_group_80_max        FLOAT
)
GO