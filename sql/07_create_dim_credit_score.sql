-- ============================================================================
-- 07_create_dim_credit_score.sql
-- Dimension: Credit Score (Classification)
-- Grain    : One row per distinct Credit_Score category
-- ============================================================================
-- BACKGROUND:
--   Credit_Score was originally dropped by the source Power Query M code
--   (Removed Columns11). It was restored into cleaned_financial_data per
--   user confirmation - but it was initially assumed to be NUMERIC. Live
--   querying against raw_financial_data confirmed it is actually a
--   CATEGORICAL classification with exactly 3 known values ("Poor",
--   "Standard", "Good") plus a large share of NULLs (~38% of rows),
--   imputed to 'Data Missing' during cleaning for consistency with how
--   every other categorical gap in this project has been handled
--   (Name -> "No information", SSN -> "Data Missing", Occupation ->
--   "Civil Servants", Payment_Behaviour -> "Missing Data").
--
-- WHY THIS IS ITS OWN DIMENSION (not a degenerate flag like
-- Payment_of_Min_Amount):
--   Credit_Score is very likely the primary risk-classification target for
--   this entire project - it deserves the same first-class treatment as
--   Credit_Mix, including an ordinal sort order for correct display order
--   in Power BI (Poor -> Standard -> Good, rather than alphabetical).
-- ============================================================================

CREATE OR REPLACE TABLE
  `financial-dashboard-500409.financial_dashboard.dim_credit_score`
AS

SELECT
  ROW_NUMBER() OVER (ORDER BY Credit_Score_Sort) AS credit_score_key,
  Credit_Score,
  Credit_Score_Sort
FROM (
  SELECT DISTINCT
    Credit_Score,
    CASE
      WHEN Credit_Score = 'Poor' THEN 1
      WHEN Credit_Score = 'Standard' THEN 2
      WHEN Credit_Score = 'Good' THEN 3
      ELSE 4  -- 'Data Missing'
    END AS Credit_Score_Sort
  FROM
    `financial-dashboard-500409.financial_dashboard.cleaned_financial_data`
);
