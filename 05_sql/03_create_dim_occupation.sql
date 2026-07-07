-- ============================================================================
-- 03_create_dim_occupation.sql
-- Dimension: Occupation
-- Grain    : One row per distinct Occupation
-- ============================================================================
-- WHY THIS IS ITS OWN DIMENSION:
--   Occupation is a low-cardinality, purely descriptive categorical attribute
--   shared across many customers. Pulling it out avoids repeating the same
--   text string across every fact row and gives Power BI a clean slicer/
--   filter dimension for the "Customer Demographics" page.
-- ============================================================================

CREATE OR REPLACE TABLE
  `financial-dashboard-500409.financial_dashboard.dim_occupation`
AS

SELECT
  ROW_NUMBER() OVER (ORDER BY Occupation) AS occupation_key,
  Occupation
FROM (
  SELECT DISTINCT Occupation
  FROM `financial-dashboard-500409.financial_dashboard.cleaned_financial_data`
);
