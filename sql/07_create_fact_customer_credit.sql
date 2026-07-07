-- ============================================================================
-- 07_create_fact_customer_credit.sql
-- Fact Table: Customer Credit (Monthly Snapshot)
-- Grain     : One row per Customer_ID per Month
-- ============================================================================
-- FACT TABLE RULES APPLIED:
--   - Only foreign keys + numeric measures are included.
--   - Payment_of_Min_Amount and Credit_Score are the two exceptions, kept as
--     DEGENERATE DIMENSIONS directly in the fact table rather than separate
--     dimension tables. Both are 2-3 value flags (e.g. Yes/No/NM,
--     Poor/Standard/Good) - building a full dimension table + join for a
--     handful of fixed values adds a join with no analytical benefit. This
--     is standard Kimball practice for very low-cardinality flags.
--
-- KEY DATA-TYPE FIX:
--   Num_Credit_Inquiries is STRING in cleaned_financial_data (it can hold the
--   literal text 'Data Missing', by design from the Power Query logic). A
--   numeric fact measure can't be STRING, so it is SAFE_CAST to INT64 here -
--   'Data Missing' becomes NULL, which aggregates correctly in Power BI
--   (ignored by SUM/AVG) instead of breaking the column type entirely.
--
-- REFERENTIAL INTEGRITY:
--   All dimension joins use LEFT JOIN so that a row is never silently
--   dropped from the fact table if a dimension lookup were ever to miss
--   (e.g. a genuinely NULL Occupation). Every dimension is built as
--   SELECT DISTINCT off the exact same cleaned_financial_data table, so in
--   practice every join key is guaranteed to match.
-- ============================================================================

CREATE OR REPLACE TABLE
  `financial-dashboard-500409.financial_dashboard.fact_customer_credit`
AS

WITH source AS (
  SELECT
    Customer_ID,
    Month,
    Occupation,
    Credit_Mix,
    Payment_Behaviour,
    Num_of_Loan,

    -- Recompute the same tier logic used in dim_loan so we can join on it.
    CASE
      WHEN Num_of_Loan = 0                THEN 'No Loan'
      WHEN Num_of_Loan BETWEEN 1 AND 2    THEN 'Low (1-2)'
      WHEN Num_of_Loan BETWEEN 3 AND 5    THEN 'Moderate (3-5)'
      WHEN Num_of_Loan BETWEEN 6 AND 8    THEN 'High (6-8)'
      ELSE 'Very High (9+)'
    END AS Loan_Tier,

    -- Degenerate dimensions (kept directly in fact, see header note)
    Payment_of_Min_Amount,
    Credit_Score,

    -- Numeric measures
    Annual_Income,
    Monthly_Inhand_Salary,
    Num_Bank_Accounts,
    Num_Credit_Card,
    Interest_Rate,
    Delay_from_due_date,
    Changed_Credit_Limit,
    SAFE_CAST(Num_Credit_Inquiries AS INT64) AS Num_Credit_Inquiries,
    Outstanding_Debt,
    Credit_Utilization_Ratio,
    Credit_History_Age_Months,
    Total_EMI_per_month,
    Amount_invested_monthly,
    Monthly_Balance
  FROM
    `financial-dashboard-500409.financial_dashboard.cleaned_financial_data`
)

SELECT
  -- Surrogate primary key for the fact table itself
  ROW_NUMBER() OVER () AS customer_credit_key,

  -- Foreign keys to every dimension
  dc.customer_key,
  dd.date_key,
  doc.occupation_key,
  dcm.credit_mix_key,
  dpb.payment_behaviour_key,
  dl.loan_key,

  -- Degenerate dimension flags
  s.Payment_of_Min_Amount,
  s.Credit_Score,

  -- Numeric measures
  s.Annual_Income,
  s.Monthly_Inhand_Salary,
  s.Num_Bank_Accounts,
  s.Num_Credit_Card,
  s.Interest_Rate,
  s.Num_of_Loan,
  s.Delay_from_due_date,
  s.Changed_Credit_Limit,
  s.Num_Credit_Inquiries,
  s.Outstanding_Debt,
  s.Credit_Utilization_Ratio,
  s.Credit_History_Age_Months,
  s.Total_EMI_per_month,
  s.Amount_invested_monthly,
  s.Monthly_Balance

FROM source s
LEFT JOIN `financial-dashboard-500409.financial_dashboard.dim_customer` dc
  ON s.Customer_ID = dc.Customer_ID
LEFT JOIN `financial-dashboard-500409.financial_dashboard.dim_date` dd
  ON s.Month = dd.Month
LEFT JOIN `financial-dashboard-500409.financial_dashboard.dim_occupation` doc
  ON s.Occupation = doc.Occupation
LEFT JOIN `financial-dashboard-500409.financial_dashboard.dim_credit_mix` dcm
  ON s.Credit_Mix = dcm.Credit_Mix
LEFT JOIN `financial-dashboard-500409.financial_dashboard.dim_payment_behaviour` dpb
  ON s.Payment_Behaviour = dpb.Payment_Behaviour
LEFT JOIN `financial-dashboard-500409.financial_dashboard.dim_loan` dl
  ON s.Loan_Tier = dl.Loan_Tier;
