-- ============================================================================
-- 04_create_dim_credit_mix.sql
-- Dimension: Credit Mix
-- Grain    : One row per distinct Credit_Mix value
-- ============================================================================
-- WHY Credit_Mix_Sort LIVES HERE (not in the fact table):
--   Credit_Mix_Sort is a 1:1 helper attribute of Credit_Mix (it exists purely
--   to give Power BI a numeric sort order for an otherwise-unordered category
--   like "Good/Standard/Bad"). It has no independent meaning outside of
--   Credit_Mix and is never aggregated, so it belongs in the dimension
--   alongside the attribute it sorts - not as a fact measure.
-- ============================================================================

CREATE OR REPLACE TABLE
  `financial-dashboard-500409.financial_dashboard.dim_credit_mix`
AS

SELECT
  ROW_NUMBER() OVER (ORDER BY Credit_Mix_Sort) AS credit_mix_key,
  Credit_Mix,
  Credit_Mix_Sort
FROM (
  SELECT DISTINCT Credit_Mix, Credit_Mix_Sort
  FROM `financial-dashboard-500409.financial_dashboard.cleaned_financial_data`
);
