-- ============================================================================
-- 02_create_dim_date.sql
-- Dimension: Date (Month Cycle)
-- Grain    : One row per distinct Month value found in the data
-- ============================================================================
-- IMPORTANT LIMITATION (call this out in the interview / documentation):
--   The source data contains only a Month NAME (e.g. "January"), with NO
--   YEAR. This is therefore a MONTH-CYCLE dimension, not a true calendar
--   dimension. A real enterprise warehouse would have a full dim_date with
--   Year, Fiscal Period, Day, Holiday flags, etc. If a Year column becomes
--   available upstream, this table should be rebuilt as a proper calendar
--   dimension (see "Possible Improvements" in the accompanying explanation).
--
-- WHY THESE COLUMNS ARE HERE:
--   Month         -> Business key / display label used in Power BI slicers.
--   Month_Number  -> Enables correct chronological sort in Power BI (Month
--                    is text, so without this, "April" would sort before
--                    "January" alphabetically).
--   Quarter       -> Common Power BI drill-down level (Executive Overview).
-- ============================================================================

CREATE OR REPLACE TABLE
  `financial-dashboard-500409.financial_dashboard.dim_date`
AS

WITH distinct_months AS (
  SELECT DISTINCT Month
  FROM `financial-dashboard-500409.financial_dashboard.cleaned_financial_data`
),

month_lookup AS (
  SELECT
    Month,
    CASE Month
      WHEN 'January'   THEN 1
      WHEN 'February'  THEN 2
      WHEN 'March'     THEN 3
      WHEN 'April'     THEN 4
      WHEN 'May'       THEN 5
      WHEN 'June'      THEN 6
      WHEN 'July'      THEN 7
      WHEN 'August'    THEN 8
      WHEN 'September' THEN 9
      WHEN 'October'   THEN 10
      WHEN 'November'  THEN 11
      WHEN 'December'  THEN 12
      ELSE NULL
    END AS Month_Number
  FROM distinct_months
)

SELECT
  -- Surrogate key, ordered chronologically (not alphabetically) so that
  -- date_key itself is naturally sortable as a fallback.
  ROW_NUMBER() OVER (ORDER BY Month_Number) AS date_key,

  Month,
  Month_Number,

  CASE
    WHEN Month_Number IN (1, 2, 3)   THEN 1
    WHEN Month_Number IN (4, 5, 6)   THEN 2
    WHEN Month_Number IN (7, 8, 9)   THEN 3
    WHEN Month_Number IN (10, 11, 12) THEN 4
    ELSE NULL
  END AS Quarter
FROM month_lookup;
