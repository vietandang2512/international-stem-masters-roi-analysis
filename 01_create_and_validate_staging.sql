-- =====================================================================
-- STAGING: 01_create_and_validate_staging.sql
-- Purpose: confirm the raw uploaded tables (tuition_data, salary_data)
--          are clean before anything downstream joins against them.
--
-- HOW TO RUN THIS IN DATABRICKS:
-- 1. In your workspace, go to Catalog > your catalog > your schema
-- 2. Click "Create table" > "Upload file" and upload tuition_data.csv
--    (from the /data folder). Name the table: tuition_data
-- 3. Repeat for salary_data.csv, naming the table: salary_data
-- 4. Open a new SQL Query, paste this file's contents, and run it.
-- =====================================================================

-- Sanity check 1: row counts should be 60 (tuition) and 12 (salary)
SELECT 'tuition_data' AS table_name, COUNT(*) AS row_count FROM tuition_data
UNION ALL
SELECT 'salary_data' AS table_name, COUNT(*) AS row_count FROM salary_data;


-- Sanity check 2: every country in tuition_data should have exactly
-- 10 program ROWS. NOTE: we count rows, not DISTINCT program names --
-- several universities across different countries share generic
-- program titles like "Master of Data Science", so COUNT(DISTINCT
-- program) alone would undercount even when the data is correct.
-- university is included to sanity-check that each row is a genuinely
-- distinct program (same title, different school is fine).
SELECT
    t.country,
    COUNT(*)                                        AS total_program_rows,
    COUNT(DISTINCT t.program || '|' || t.university) AS distinct_program_university_pairs
FROM tuition_data t
GROUP BY t.country
ORDER BY t.country;

-- Separately confirm every country has both occupations in salary_data
SELECT
    country,
    COUNT(DISTINCT occupation) AS occupation_count
FROM salary_data
GROUP BY country
ORDER BY country;


-- Sanity check 3: catch any country name mismatch between the two
-- tables (e.g. "United States" vs "USA") that would silently break
-- the join later. This should return ZERO rows.
SELECT DISTINCT t.country
FROM tuition_data t
LEFT JOIN salary_data s ON t.country = s.country
WHERE s.country IS NULL;


-- Sanity check 4: no negative or null values in key numeric columns
SELECT *
FROM tuition_data
WHERE total_tuition_usd < 0
   OR total_direct_cost_usd < 0
   OR duration_months IS NULL;
