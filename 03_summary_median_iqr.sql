-- =====================================================================
-- ANALYSIS: 03_summary_median_iqr.sql
-- Purpose: since each country has 10 sampled programs, summarize
--          across them with MEDIAN and IQR (25th-75th percentile)
--          rather than a single average, per country x occupation.
--
-- Uses Databricks SQL's built-in MEDIAN() and percentile_cont()
-- aggregate functions (no manual array/IF-formula workaround needed
-- like the Excel version required).
-- =====================================================================

CREATE OR REPLACE VIEW roi_summary AS
SELECT
    country,
    occupation,

    ROUND(MEDIAN(basic_payback_years), 2)                                                  AS basic_payback_median,
    ROUND(percentile_cont(0.25) WITHIN GROUP (ORDER BY basic_payback_years), 2)             AS basic_payback_iqr_low,
    ROUND(percentile_cont(0.75) WITHIN GROUP (ORDER BY basic_payback_years), 2)             AS basic_payback_iqr_high,

    ROUND(MEDIAN(realistic_payback_years), 2)                                               AS realistic_payback_median,
    ROUND(percentile_cont(0.25) WITHIN GROUP (ORDER BY realistic_payback_years), 2)         AS realistic_payback_iqr_low,
    ROUND(percentile_cont(0.75) WITHIN GROUP (ORDER BY realistic_payback_years), 2)         AS realistic_payback_iqr_high,

    ROUND(MEDIAN(roi_5yr_pct), 1)                                                           AS roi_5yr_median,
    ROUND(percentile_cont(0.25) WITHIN GROUP (ORDER BY roi_5yr_pct), 1)                     AS roi_5yr_iqr_low,
    ROUND(percentile_cont(0.75) WITHIN GROUP (ORDER BY roi_5yr_pct), 1)                     AS roi_5yr_iqr_high,

    ROUND(MEDIAN(roi_10yr_pct), 1)                                                          AS roi_10yr_median,
    ROUND(percentile_cont(0.25) WITHIN GROUP (ORDER BY roi_10yr_pct), 1)                    AS roi_10yr_iqr_low,
    ROUND(percentile_cont(0.75) WITHIN GROUP (ORDER BY roi_10yr_pct), 1)                    AS roi_10yr_iqr_high

FROM roi_calculations
GROUP BY country, occupation;


-- View the full summary table, best country first (fastest realistic payback)
SELECT *
FROM roi_summary
ORDER BY realistic_payback_median ASC;
