-- ============================================================================
-- 06_create_dim_loan.sql
-- Dimension: Loan (Volume Tier)
-- Grain    : One row per distinct Loan_Tier bucket
-- ============================================================================
-- IMPORTANT DESIGN NOTE:
--   Type_of_Loan does NOT exist in cleaned_financial_data - it was correctly
--   dropped during the earlier Power-Query-to-BigQuery cleaning step (the
--   original M code removes it right after deriving Num_of_Loan from it).
--   A true "loan type" dimension (Auto Loan / Personal Loan / etc.) is
--   therefore not buildable from the current cleaned table without
--   re-including Type_of_Loan upstream.
--
--   To still deliver a meaningful, non-trivial dim_loan (rather than skip it
--   or fake it), this dimension buckets customers into LOAN VOLUME TIERS
--   based on Num_of_Loan. This gives Power BI a clean slicer for "loan
--   burden" on the Loan Analysis page, while the precise Num_of_Loan integer
--   still lives in the fact table as a numeric measure for exact aggregation.
--
--   See "Possible Improvements" for how to properly rebuild this as a
--   Type_of_Loan dimension + bridge table if Type_of_Loan is restored
--   upstream.
-- ============================================================================

CREATE OR REPLACE TABLE
  `financial-dashboard-500409.financial_dashboard.dim_loan`
AS

WITH loan_tiers AS (
  SELECT DISTINCT
    CASE
      WHEN Num_of_Loan = 0                THEN 'No Loan'
      WHEN Num_of_Loan BETWEEN 1 AND 2    THEN 'Low (1-2)'
      WHEN Num_of_Loan BETWEEN 3 AND 5    THEN 'Moderate (3-5)'
      WHEN Num_of_Loan BETWEEN 6 AND 8    THEN 'High (6-8)'
      ELSE 'Very High (9+)'
    END AS Loan_Tier,
    CASE
      WHEN Num_of_Loan = 0                THEN 1
      WHEN Num_of_Loan BETWEEN 1 AND 2    THEN 2
      WHEN Num_of_Loan BETWEEN 3 AND 5    THEN 3
      WHEN Num_of_Loan BETWEEN 6 AND 8    THEN 4
      ELSE 5
    END AS Loan_Tier_Sort
  FROM `financial-dashboard-500409.financial_dashboard.cleaned_financial_data`
)

SELECT
  ROW_NUMBER() OVER (ORDER BY Loan_Tier_Sort) AS loan_key,
  Loan_Tier,
  Loan_Tier_Sort
FROM loan_tiers;
