-- ============================================================================
-- 05_create_dim_payment_behaviour.sql
-- Dimension: Payment Behaviour
-- Grain    : One row per distinct Payment_Behaviour value
-- ============================================================================
-- WHY THIS IS ITS OWN DIMENSION:
--   Payment_Behaviour is a moderate-cardinality categorical attribute
--   (e.g. "High_spent_Small_value_payments") used heavily in the "Credit
--   Behaviour" and "Customer Risk" dashboard pages. Isolating it keeps the
--   fact table narrow and lets Power BI filter/slice on it directly.
-- ============================================================================

CREATE OR REPLACE TABLE
  `financial-dashboard-500409.financial_dashboard.dim_payment_behaviour`
AS

SELECT
  ROW_NUMBER() OVER (ORDER BY Payment_Behaviour) AS payment_behaviour_key,
  Payment_Behaviour
FROM (
  SELECT DISTINCT Payment_Behaviour
  FROM `financial-dashboard-500409.financial_dashboard.cleaned_financial_data`
);
