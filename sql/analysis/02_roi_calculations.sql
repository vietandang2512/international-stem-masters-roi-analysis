-- =====================================================================
-- ANALYSIS: 02_roi_calculations.sql
-- Purpose: join every program to both occupations' salary data, and
--          compute payback period + cumulative ROI% for each.
--
-- This creates a VIEW (not a table) so it always reflects the latest
-- data in tuition_data / salary_data without needing to be re-run
-- manually after an update.
--
-- Grain: one row per (program x occupation) = 60 programs x 2
--        occupations = 120 rows.
-- =====================================================================

CREATE OR REPLACE VIEW roi_calculations AS
SELECT
    t.country,
    t.program,
    t.university,
    s.occupation,
    t.total_tuition_usd,
    t.total_living_cost_usd,
    t.total_direct_cost_usd,
    s.net_salary_usd,

    -- PAYBACK PERIOD (years)
    -- Basic: tuition only. Realistic: tuition + living costs.
    ROUND(t.total_tuition_usd      / s.net_salary_usd, 2) AS basic_payback_years,
    ROUND(t.total_direct_cost_usd  / s.net_salary_usd, 2) AS realistic_payback_years,

    -- CUMULATIVE ROI (%) at 5 and 10 years post-graduation
    -- Formula: ((N * net_salary) - total_investment) / total_investment * 100
    ROUND(((5  * s.net_salary_usd) - t.total_direct_cost_usd) * 100.0 / t.total_direct_cost_usd, 1) AS roi_5yr_pct,
    ROUND(((10 * s.net_salary_usd) - t.total_direct_cost_usd) * 100.0 / t.total_direct_cost_usd, 1) AS roi_10yr_pct

FROM tuition_data t
INNER JOIN salary_data s
    ON t.country = s.country;


-- Quick check after creating the view: confirm we get 120 rows
SELECT COUNT(*) AS total_rows FROM roi_calculations;

-- Preview a sample
SELECT * FROM roi_calculations LIMIT 10;
