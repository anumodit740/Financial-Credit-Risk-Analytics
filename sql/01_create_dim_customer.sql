-- ============================================================================
-- 01_create_dim_customer.sql
-- Dimension: Customer
-- Grain    : One row per Customer_ID (deduplicated across monthly snapshots)
-- ============================================================================
-- WHY THESE COLUMNS ARE HERE:
--   Customer_ID  -> Natural/business key. Needed to join back to the fact table.
--   Name, SSN    -> Pure descriptive identity attributes of a customer.
--   Age          -> A demographic attribute of the customer, not a measure.
--                   It does not get SUMmed or AVERAGEd meaningfully on its own
--                   in most reports (you'd bucket it), so it belongs in the
--                   dimension, not the fact table.
--
-- WHY OCCUPATION IS NOT HERE:
--   Occupation is modeled as its own dimension (dim_occupation) per the
--   project spec, so it is excluded from dim_customer to avoid duplicating
--   the same descriptive text across every customer row (snowflake-lite
--   normalization is intentionally avoided elsewhere, but Occupation was
--   explicitly requested as a separate dimension).
--
-- DEDUPLICATION STRATEGY:
--   cleaned_financial_data has one row per Customer_ID per Month, so the same
--   customer appears multiple times. Minor data-quality drift means Name/Age
--   are not always byte-identical across a customer's rows. Instead of
--   arbitrarily picking the first row, we pick the MOST FREQUENT
--   (Name, SSN, Age) combination per customer - this is more defensible than
--   ANY_VALUE() for a portfolio-quality warehouse.
-- ============================================================================

CREATE OR REPLACE TABLE
  `financial-dashboard-500409.financial_dashboard.dim_customer`
AS

WITH combo_counts AS (
  -- Count how often each (Name, SSN, Age) combination appears per customer
  SELECT
    Customer_ID,
    Name,
    SSN,
    Age,
    COUNT(*) AS occurrence_count
  FROM
    `financial-dashboard-500409.financial_dashboard.cleaned_financial_data`
  GROUP BY
    Customer_ID, Name, SSN, Age
),

ranked AS (
  -- Rank combinations within each customer - most frequent wins
  SELECT
    Customer_ID,
    Name,
    SSN,
    Age,
    ROW_NUMBER() OVER (
      PARTITION BY Customer_ID
      ORDER BY occurrence_count DESC
    ) AS rn
  FROM combo_counts
)

SELECT
  -- Surrogate key: INT64, generated via ROW_NUMBER() - stable join key for
  -- Power BI relationships, decoupled from the business key.
  ROW_NUMBER() OVER (ORDER BY Customer_ID) AS customer_key,

  -- Business / natural key - used only to join fact -> dim during ETL,
  -- not intended to be user-facing in Power BI.
  Customer_ID,

  Name,
  SSN,
  Age
FROM ranked
WHERE rn = 1;
