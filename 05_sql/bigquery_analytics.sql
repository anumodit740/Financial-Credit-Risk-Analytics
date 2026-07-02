
-- ===========================================================
-- BIGQUERY FINANCIAL ANALYTICS PIPELINE
-- Project: financial-dashboard-500409
-- Dataset: financial_dashboard
-- Table: raw_financial_data
-- ===========================================================


-- ===========================================================
-- 1. DATA QUALITY CHECK
-- ===========================================================

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT Customer_ID) AS unique_customers,
    COUNTIF(Annual_Income IS NULL) AS missing_annual_income,
    COUNTIF(Interest_Rate IS NULL) AS missing_interest_rate,
    COUNTIF(Outstanding_Debt IS NULL) AS missing_outstanding_debt,
    COUNTIF(Credit_Utilization_Ratio IS NULL) AS missing_credit_utilization
FROM
`financial-dashboard-500409.financial_dashboard.raw_financial_data`;



-- ===========================================================
-- 2. CREDIT MIX ANALYSIS
-- ===========================================================

SELECT
    Credit_Mix,
    COUNT(*) AS Total_Customers,
    ROUND(AVG(SAFE_CAST(Interest_Rate AS FLOAT64)),2) AS Avg_Interest_Rate,
    ROUND(AVG(SAFE_CAST(Outstanding_Debt AS FLOAT64)),2) AS Avg_Outstanding_Debt
FROM
`financial-dashboard-500409.financial_dashboard.raw_financial_data`
GROUP BY Credit_Mix
ORDER BY Total_Customers DESC;



-- ===========================================================
-- 3. MONTHLY BUSINESS KPI
-- ===========================================================

SELECT
    Month,
    COUNT(*) AS Total_Records,
    ROUND(AVG(SAFE_CAST(Annual_Income AS FLOAT64)),2) AS Avg_Annual_Income,
    ROUND(AVG(SAFE_CAST(Monthly_Balance AS FLOAT64)),2) AS Avg_Monthly_Balance,
    ROUND(AVG(SAFE_CAST(Outstanding_Debt AS FLOAT64)),2) AS Avg_Outstanding_Debt,
    ROUND(AVG(SAFE_CAST(Interest_Rate AS FLOAT64)),2) AS Avg_Interest_Rate
FROM
`financial-dashboard-500409.financial_dashboard.raw_financial_data`
GROUP BY Month
ORDER BY Month;



-- ===========================================================
-- 4. TOP CUSTOMERS BY OUTSTANDING DEBT
-- ===========================================================

SELECT
    Customer_ID,
    Name,
    Occupation,
    SAFE_CAST(Outstanding_Debt AS FLOAT64) AS Outstanding_Debt,
    SAFE_CAST(Interest_Rate AS FLOAT64) AS Interest_Rate
FROM
`financial-dashboard-500409.financial_dashboard.raw_financial_data`
ORDER BY Outstanding_Debt DESC
LIMIT 20;



-- ===========================================================
-- 5. WINDOW FUNCTION ANALYSIS
-- ===========================================================

SELECT
    Customer_ID,
    Month,
    SAFE_CAST(Outstanding_Debt AS FLOAT64) AS Outstanding_Debt,

    RANK() OVER(
        PARTITION BY Customer_ID
        ORDER BY SAFE_CAST(Outstanding_Debt AS FLOAT64) DESC
    ) AS Debt_Rank

FROM
`financial-dashboard-500409.financial_dashboard.raw_financial_data`;



-- ===========================================================
-- 6. CUSTOMER LEVEL SUMMARY (CTE)
-- ===========================================================

WITH customer_summary AS
(
SELECT
    Customer_ID,

    AVG(SAFE_CAST(Annual_Income AS FLOAT64)) AS Avg_Annual_Income,

    AVG(SAFE_CAST(Interest_Rate AS FLOAT64)) AS Avg_Interest_Rate,

    AVG(SAFE_CAST(Credit_Utilization_Ratio AS FLOAT64))
        AS Avg_Credit_Utilization,

    SUM(SAFE_CAST(Outstanding_Debt AS FLOAT64))
        AS Total_Outstanding_Debt,

    AVG(SAFE_CAST(Monthly_Balance AS FLOAT64))
        AS Avg_Monthly_Balance,

    COUNT(*) AS Total_Records

FROM
`financial-dashboard-500409.financial_dashboard.raw_financial_data`

GROUP BY Customer_ID
)

SELECT *
FROM customer_summary
ORDER BY Total_Outstanding_Debt DESC
LIMIT 20;



-- ===========================================================
-- 7. CREATE ANALYTICS TABLE
-- ===========================================================

CREATE OR REPLACE TABLE
`financial-dashboard-500409.financial_dashboard.customer_summary`
AS

SELECT

    Customer_ID,

    AVG(SAFE_CAST(Annual_Income AS FLOAT64))
        AS Avg_Annual_Income,

    AVG(SAFE_CAST(Interest_Rate AS FLOAT64))
        AS Avg_Interest_Rate,

    AVG(SAFE_CAST(Credit_Utilization_Ratio AS FLOAT64))
        AS Avg_Credit_Utilization,

    AVG(SAFE_CAST(Monthly_Balance AS FLOAT64))
        AS Avg_Monthly_Balance,

    SUM(SAFE_CAST(Outstanding_Debt AS FLOAT64))
        AS Total_Outstanding_Debt,

    AVG(SAFE_CAST(Changed_Credit_Limit AS FLOAT64))
        AS Avg_Credit_Limit,

    AVG(SAFE_CAST(Total_EMI_per_month AS FLOAT64))
        AS Avg_EMI,

    AVG(SAFE_CAST(Amount_invested_monthly AS FLOAT64))
        AS Avg_Monthly_Investment,

    AVG(SAFE_CAST(Monthly_Inhand_Salary AS FLOAT64))
        AS Avg_Monthly_Salary,

    AVG(SAFE_CAST(Delay_from_due_date AS FLOAT64))
        AS Avg_Delay,

    AVG(SAFE_CAST(Num_Bank_Accounts AS FLOAT64))
        AS Avg_Bank_Accounts,

    AVG(SAFE_CAST(Num_Credit_Card AS FLOAT64))
        AS Avg_Credit_Cards,

    AVG(SAFE_CAST(Num_Credit_Inquiries AS FLOAT64))
        AS Avg_Credit_Inquiries,

    AVG(SAFE_CAST(Num_of_Loan AS FLOAT64))
        AS Avg_Number_of_Loans,

    COUNT(*) AS Total_Records

FROM
`financial-dashboard-500409.financial_dashboard.raw_financial_data`

GROUP BY Customer_ID;



-- ===========================================================
-- 8. VERIFY ANALYTICS TABLE
-- ===========================================================

SELECT *
FROM
`financial-dashboard-500409.financial_dashboard.customer_summary`
LIMIT 20;