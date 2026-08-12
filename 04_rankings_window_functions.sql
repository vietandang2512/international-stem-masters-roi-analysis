-- =====================================================================
-- ANALYSIS: 04_rankings_window_functions.sql
-- Purpose: rank countries against each other using SQL window
--          functions. This is the piece that actually demonstrates
--          "real" SQL skill beyond basic joins/aggregation -- it lets
--          you answer questions like "where does Canada rank?" in a
--          single query instead of eyeballing a sorted table.
-- =====================================================================

-- Rank every country within each occupation, by realistic payback
-- period (fastest payback = rank 1). PARTITION BY occupation means
-- Data Analyst and Data Scientist are ranked separately, not blended.
SELECT
    occupation,
    country,
    realistic_payback_median,
    RANK() OVER (
        PARTITION BY occupation
        ORDER BY realistic_payback_median ASC
    ) AS payback_rank,

    roi_10yr_median,
    RANK() OVER (
        PARTITION BY occupation
        ORDER BY roi_10yr_median DESC
    ) AS roi_10yr_rank

FROM roi_summary
ORDER BY occupation, payback_rank;


-- A second useful window-function query: for each country, how far
-- is its payback period from the best (fastest) country in the same
-- occupation group? Uses MIN() as a window function.
SELECT
    occupation,
    country,
    realistic_payback_median,
    MIN(realistic_payback_median) OVER (PARTITION BY occupation) AS best_in_group,
    ROUND(
        realistic_payback_median - MIN(realistic_payback_median) OVER (PARTITION BY occupation),
        2
    ) AS years_slower_than_best
FROM roi_summary
ORDER BY occupation, years_slower_than_best;
