-- ============================================================================
-- 00_create_cleaned_financial_data.sql
-- Production BigQuery Standard SQL conversion of the Power Query (M) ETL logic
-- Target Table : financial-dashboard-500409.financial_dashboard.cleaned_financial_data
-- Source Table : financial-dashboard-500409.financial_dashboard.raw_financial_data
-- No DML used (no UPDATE/DELETE/MERGE/INSERT/ALTER) - Sandbox-safe
--
-- DEVIATION FROM ORIGINAL POWER QUERY: the original M code drops Credit_Score
-- via Table.RemoveColumns(...,{"Credit_Score"}). Per user confirmation this
-- was not intended - Credit_Score genuinely exists in raw_financial_data and
-- is needed for risk analysis, so it is intentionally KEPT here, passed
-- through untouched (no cleaning logic was ever applied to it in the M code).
-- ============================================================================

CREATE OR REPLACE TABLE
  `financial-dashboard-500409.financial_dashboard.cleaned_financial_data`
AS

WITH

-- ----------------------------------------------------------------------------
-- Base row-level cleaning
-- (ID, source_file are dropped simply by not selecting them - mirrors
--  Table.RemoveColumns(...,{"ID","source_file"}))
-- ----------------------------------------------------------------------------
base AS (
  SELECT
    -- Customer Cleaning
    Customer_ID,
    Month,
    IFNULL(Name, 'No information') AS Name,
    CASE
      WHEN SSN = '#F%$D@*&8' THEN 'Data Missing'
      ELSE SSN
    END AS SSN,
    CASE
      WHEN Occupation = '_______' THEN 'Civil Servants'
      ELSE Occupation
    END AS Occupation,

    -- Age Cleaning (underscore strip + cast, pre-median-filter state,
    -- matching List.Median being evaluated on #"Changed Type"[Age])
    SAFE_CAST(REPLACE(Age, '_', '') AS INT64) AS Age_stripped,

    -- Income Cleaning
    SAFE_CAST(REPLACE(Annual_Income, '_', '') AS FLOAT64) AS Annual_Income,
    Monthly_Inhand_Salary,

    -- Banking / Credit Card Cleaning (raw numeric, pre-median-filter state)
    Num_Bank_Accounts,
    Num_Credit_Card,
    Interest_Rate,

    -- Loan Cleaning
    Type_of_Loan,
    Delay_from_due_date,

    -- Credit Metrics (pre-clean)
    Changed_Credit_Limit,
    Num_Credit_Inquiries,
    CASE
      WHEN Credit_Mix = '_' THEN 'Above Standard'
      ELSE Credit_Mix
    END AS Credit_Mix,
    SAFE_CAST(REPLACE(Outstanding_Debt, '_', '') AS FLOAT64) AS Outstanding_Debt,
    Credit_Utilization_Ratio,
    Credit_History_Age,

    -- Payment Metrics
    Payment_of_Min_Amount,
    Total_EMI_per_month,
    Amount_invested_monthly,
    CASE
      WHEN Payment_Behaviour = '!@9#%8' THEN 'Missing Data'
      ELSE Payment_Behaviour
    END AS Payment_Behaviour,
    Monthly_Balance,
    IFNULL(Credit_Score, 'Data Missing') AS Credit_Score
  FROM
    `financial-dashboard-500409.financial_dashboard.raw_financial_data`
),

-- ----------------------------------------------------------------------------
-- Median calculations (List.Median equivalents - computed on the pre-filter
-- column state, exactly as Power Query evaluates them at that point in the
-- query, before that column's own out-of-range values are replaced)
-- ----------------------------------------------------------------------------
age_median AS (
  SELECT CAST(APPROX_QUANTILES(Age_stripped, 2)[OFFSET(1)] AS INT64) AS median_age
  FROM base
),

bank_median AS (
  SELECT CAST(APPROX_QUANTILES(Num_Bank_Accounts, 2)[OFFSET(1)] AS INT64) AS median_bank
  FROM base
),

card_median AS (
  SELECT CAST(APPROX_QUANTILES(Num_Credit_Card, 2)[OFFSET(1)] AS INT64) AS median_card
  FROM base
),

interest_median AS (
  SELECT APPROX_QUANTILES(SAFE_CAST(Interest_Rate AS FLOAT64), 2)[OFFSET(1)] AS median_interest
  FROM base
),

-- ----------------------------------------------------------------------------
-- Final transformation layer
-- ----------------------------------------------------------------------------
final AS (
  SELECT
    -- Customer Cleaning
    Customer_ID,
    Month,
    Name,
    SSN,
    Occupation,

    -- Age Cleaning
    CASE
      WHEN Age_stripped IS NOT NULL AND Age_stripped > 0 AND Age_stripped < 99
        THEN Age_stripped
      ELSE (SELECT median_age FROM age_median)
    END AS Age,

    -- Income Cleaning
    Annual_Income,
    CASE
      WHEN Monthly_Inhand_Salary IS NOT NULL
        THEN SAFE_CAST(Monthly_Inhand_Salary AS FLOAT64)
      ELSE ROUND(Annual_Income / 12, 2)
    END AS Monthly_Inhand_Salary,

    -- Banking / Credit Card Cleaning
    CAST(
      CASE
        WHEN Num_Bank_Accounts > -1 AND Num_Bank_Accounts < 11
          THEN Num_Bank_Accounts
        ELSE (SELECT median_bank FROM bank_median)
      END AS INT64
    ) AS Num_Bank_Accounts,
    CAST(
      CASE
        WHEN Num_Credit_Card < 25 THEN Num_Credit_Card
        ELSE (SELECT median_card FROM card_median)
      END AS INT64
    ) AS Num_Credit_Card,
    SAFE_CAST(
      CASE
        WHEN Interest_Rate IS NOT NULL AND Interest_Rate >= 0 AND Interest_Rate <= 35
          THEN Interest_Rate
        ELSE (SELECT median_interest FROM interest_median)
      END AS FLOAT64
    ) AS Interest_Rate,

    -- Loan Cleaning
    -- Replicates: split Type_of_Loan on " and " -> "," then split on ",",
    -- trim each piece, drop empty pieces, count remaining pieces
    CAST(
      CASE
        WHEN Type_of_Loan IS NULL THEN 0
        ELSE (
          SELECT COUNT(*)
          FROM UNNEST(SPLIT(REPLACE(Type_of_Loan, ' and ', ','), ',')) AS loan_item
          WHERE TRIM(loan_item) != ''
        )
      END AS INT64
    ) AS Num_of_Loan,
    Delay_from_due_date,

    -- Credit Metrics
    ROUND(
      SAFE_CAST(
        IF(REPLACE(Changed_Credit_Limit, '_', '') = '', '0', REPLACE(Changed_Credit_Limit, '_', ''))
        AS FLOAT64
      ),
      2
    ) AS Changed_Credit_Limit,
    -- Num_Credit_Inquiries is mixed-type in Power Query (numeric OR the text
    -- "Data Missing"). BigQuery requires a single column type, so the whole
    -- column is normalized to STRING here to preserve identical output values.
    CASE
      WHEN Num_Credit_Inquiries IS NULL THEN 'Data Missing'
      WHEN Num_Credit_Inquiries < 0 THEN 'Data Missing'
      WHEN Num_Credit_Inquiries >= 26 THEN 'Data Missing'
      ELSE CAST(Num_Credit_Inquiries AS STRING)
    END AS Num_Credit_Inquiries,
    Credit_Mix,
    Outstanding_Debt,
    ROUND(SAFE_CAST(Credit_Utilization_Ratio AS FLOAT64), 2) AS Credit_Utilization_Ratio,
    CASE
      WHEN Credit_History_Age IS NULL THEN 0
      ELSE
        SAFE_CAST(SPLIT(Credit_History_Age, ' ')[SAFE_OFFSET(0)] AS INT64) * 12
        + SAFE_CAST(SPLIT(Credit_History_Age, ' ')[SAFE_OFFSET(3)] AS INT64)
    END AS Credit_History_Age_Months,

    -- Payment Metrics
    Payment_of_Min_Amount,
    ROUND(SAFE_CAST(Total_EMI_per_month AS FLOAT64), 2) AS Total_EMI_per_month,
    ROUND(
      SAFE_CAST(IFNULL(REPLACE(Amount_invested_monthly, '_', ''), '0') AS FLOAT64),
      2
    ) AS Amount_invested_monthly,
    Payment_Behaviour,
    Monthly_Balance,
    Credit_Score
  FROM base
)

-- ----------------------------------------------------------------------------
-- Output layer: Credit_Mix_Sort is computed on the ALREADY-TRANSFORMED
-- Credit_Mix column, matching the Power Query step order (Added Conditional
-- Column1 runs after Replaced Value7 in the M query).
-- ----------------------------------------------------------------------------
SELECT
  *,
  CASE
    WHEN Credit_Mix = 'Good' THEN 1
    WHEN Credit_Mix = 'Above Standard' THEN 2
    WHEN Credit_Mix = 'Standard' THEN 3
    WHEN Credit_Mix = 'Bad' THEN 4
    ELSE 5
  END AS Credit_Mix_Sort
FROM final;
