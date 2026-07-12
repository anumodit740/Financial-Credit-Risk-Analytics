# Financial Credit Risk Analytics — Technical Project Summary

> **Note on data-derived statistics:** This document is generated from the actual schema, transformation logic, and SQL scripts built in this project. Fields requiring live query execution against BigQuery (row counts, null counts, unique value counts, duplicate counts) are marked **"Requires live query"** with the exact SQL to obtain them, rather than estimated or assumed.

---

## SECTION 1 — PROJECT OVERVIEW

| Attribute | Value |
|---|---|
| Project Name | Financial Credit Risk Analytics |
| GCP Project ID | `financial-dashboard-500409` |
| BigQuery Dataset | `financial_dashboard` |
| Business Domain | Consumer Banking / Personal Credit Risk |
| Business Goal | Analyze customer financial and credit behavior to support risk classification, credit exposure monitoring, and portfolio-level reporting in Power BI |
| Dataset Source | Single raw table loaded into BigQuery (`raw_financial_data`) — resembles a public consumer credit-score dataset (Kaggle-style: Customer_ID, Month, SSN, Occupation, Credit_Mix, Payment_Behaviour, etc.) |
| Number of source files | 1 (`raw_financial_data`, ingested via `source_file` column, which is dropped during cleaning) |
| Total Rows | **Requires live query** — run: `SELECT COUNT(*) FROM \`financial-dashboard-500409.financial_dashboard.cleaned_financial_data\`` |
| Total Columns (cleaned table) | 26 (see Section 2/4) |
| Data Granularity | **One row per Customer_ID per Month** (repeating monthly snapshot per customer, not one row per customer) |
| Time Period Covered | Month name only (e.g. "January"–"December"), **no Year field present in source data** — cannot determine actual calendar time span |
| Refresh Strategy | Currently manual, full-refresh (`CREATE OR REPLACE TABLE`) batch rebuild — no incremental load or scheduling configured. BigQuery Sandbox mode (no billing account) blocks all DML, which is why every table is built via full `CREATE OR REPLACE TABLE ... AS SELECT` rather than incremental `MERGE`/`UPDATE`/`INSERT` |

---

## SECTION 2 — DATA MODEL

### 2.1 `raw_financial_data` (Source Table)
| Attribute | Detail |
|---|---|
| Purpose | Raw, unprocessed ingestion table; source of all downstream cleaning |
| Primary Key | None enforced (Customer_ID + Month is the natural composite key) |
| Foreign Keys | None (source layer) |
| Row Count | Requires live query |
| Column Count | 28 (26 business columns + `ID` + `source_file`, both dropped in cleaning) |
| Fact or Dimension | Neither — raw/staging layer |
| Data Quality | Contains known dirty-data placeholders: `_` in numeric strings, `#F%$D@*&8` in SSN, `_______` in Occupation, `!@9#%8` in Payment_Behaviour, out-of-range numeric values |

### 2.2 `cleaned_financial_data` (Cleaned/Conformed Table)
| Attribute | Detail |
|---|---|
| Purpose | Fully cleaned, business-rule-applied table; single source of truth for all dimension/fact builds |
| Primary Key | None enforced; natural key = (Customer_ID, Month) |
| Foreign Keys | None (feeds into dimensional model) |
| Row Count | Requires live query |
| Column Count | 25 |
| Fact or Dimension | Neither — this is a cleaned staging/conformed layer, not part of the star schema itself |
| Measures stored | Annual_Income, Monthly_Inhand_Salary, Num_Bank_Accounts, Num_Credit_Card, Interest_Rate, Num_of_Loan, Delay_from_due_date, Changed_Credit_Limit, Num_Credit_Inquiries (STRING type — see Section 14), Outstanding_Debt, Credit_Utilization_Ratio, Credit_History_Age_Months, Total_EMI_per_month, Amount_invested_monthly, Monthly_Balance |
| Hidden Columns | None defined (no BI layer applied yet at this table) |
| Calculated Columns | Age (median-imputed), Monthly_Inhand_Salary (derived when null), Num_of_Loan (derived from Type_of_Loan text), Changed_Credit_Limit (cleaned/rounded), Num_Credit_Inquiries (Data Missing flag logic), Credit_History_Age_Months (parsed from string), Credit_Mix_Sort (manual ordinal mapping) |
| Hierarchy | None built at this layer |
| Display Folder | N/A (staging layer, not report-facing) |
| Data Type Summary | See Section 4 (Column Dictionary) |
| Missing Values Summary | Requires live query — nulls should be minimal since imputation (median/IFNULL) was applied to Age, Monthly_Inhand_Salary, Changed_Credit_Limit, Amount_invested_monthly during cleaning. Num_Credit_Inquiries can still be NULL after SAFE_CAST in downstream fact table (see Section 14) |
| Duplicate Summary | Requires live query — run: `SELECT Customer_ID, Month, COUNT(*) FROM cleaned_financial_data GROUP BY 1,2 HAVING COUNT(*) > 1` |

### 2.3 Star Schema Tables

| Table | Purpose | PK | FK(s) | Fact/Dim | Row Count |
|---|---|---|---|---|---|
| `dim_customer` | Deduplicated customer identity/demographics | `customer_key` (surrogate) | None | Dimension | Requires live query (≈ distinct Customer_ID count) |
| `dim_date` | Month-cycle dimension (no year) | `date_key` (surrogate) | None | Dimension | Distinct Month count (≤12) |
| `dim_occupation` | Distinct occupation categories | `occupation_key` (surrogate) | None | Dimension | Requires live query |
| `dim_credit_mix` | Distinct credit mix categories + sort order | `credit_mix_key` (surrogate) | None | Dimension | Requires live query (expected small, ≤5) |
| `dim_payment_behaviour` | Distinct payment behaviour categories | `payment_behaviour_key` (surrogate) | None | Dimension | Requires live query |
| `dim_loan` | Loan volume tier buckets (NOT loan type — see Section 3) | `loan_key` (surrogate) | None | Dimension | 5 tiers by design (No Loan, Low, Moderate, High, Very High) |
| `dim_credit_score` | Credit score classification (Poor/Standard/Good + Data Missing) | `credit_score_key` (surrogate) | None | Dimension | 4 categories by design |
| `fact_customer_credit` | Central fact table, one row per Customer_ID per Month | `customer_credit_key` (surrogate) | `customer_key`, `date_key`, `occupation_key`, `credit_mix_key`, `payment_behaviour_key`, `loan_key`, `credit_score_key` | Fact | Requires live query — should equal `cleaned_financial_data` row count |

**Hidden Columns (recommended, not yet applied in BigQuery):** All surrogate keys and the `Customer_ID`/`SSN` business keys are candidates for hiding in the Power BI model view — this is a Power BI modeling step, not a BigQuery-level property, and has not been applied anywhere yet.

**Calculated Columns:** None exist as native Power BI calculated columns yet — all "calculated" logic (Age imputation, Loan_Tier bucketing, Credit_Mix_Sort, etc.) was done in BigQuery SQL prior to load, not in Power BI's DAX layer.

**Hierarchies:** None built yet. `dim_date` (Month → Quarter) is structurally capable of a hierarchy but none has been created in a Power BI model.

**Display Folders:** None configured — no Power BI model (.pbix) has been built yet; this project currently exists only as BigQuery SQL/tables.

---

## SECTION 3 — STAR SCHEMA

**Fact Tables:** 1 — `fact_customer_credit`

**Dimension Tables:** 7 — `dim_customer`, `dim_date`, `dim_occupation`, `dim_credit_mix`, `dim_payment_behaviour`, `dim_loan`, `dim_credit_score`

**Relationship Diagram:**

```
dim_customer ──┐
dim_date ──────┤
dim_occupation ┼──> fact_customer_credit
dim_credit_mix ┤
dim_payment_behaviour ┤
dim_loan ──────┤
dim_credit_score ──┘
```

All seven relationships are direct star-schema spokes into the single fact table — no relationship chains through another dimension.

**Cardinality:** All seven relationships are **One (dimension) to Many (fact)** — standard star schema cardinality, no many-to-many relationships currently modeled.

**Cross Filter Direction:** Not yet configured in Power BI (no .pbix exists). Recommended default for all six: **Single direction** (dimension filters fact), consistent with star schema best practice.

**Inactive Relationships:** None exist. There is no role-playing dimension scenario requiring an inactive relationship in this model (see below).

**Snowflake Tables:** None — the model was deliberately designed to avoid snowflaking. `Credit_Mix_Sort` (a sort-helper attribute) was intentionally folded into `dim_credit_mix` rather than split into its own table, specifically to avoid unnecessary normalization.

**Bridge Tables:** None currently exist. A bridge table was identified as a **future improvement**, not a current component — `Type_of_Loan` (multi-valued, comma-separated loan types) was dropped during cleaning and is not currently modeled; if reintroduced, it would require a many-to-many bridge table between `fact_customer_credit` and a true loan-type dimension.

**Role-Playing Dimensions:** None. `dim_date` plays only one role (Month of the snapshot) — there is no separate "transaction date" vs. "due date" scenario in this model, since `Delay_from_due_date` is stored as a numeric measure (a day-count), not a second date reference.

**Date Table:** `dim_date` exists but is **not a true calendar table** — it is a month-name-only lookup with derived Month_Number and Quarter, with **no Year column**, because the source data contains no year value. It should not be marked as an official Power BI "Date Table" in its current form, since Power BI's date table designation expects a genuine contiguous date range.

**Star Schema Best Practices Assessment:**
- ✅ Single fact table, multiple conformed dimensions
- ✅ Surrogate keys used throughout (INT64, generated via `ROW_NUMBER()`)
- ✅ No snowflaking
- ✅ Fact table kept narrow (FKs + measures, with 1 justified degenerate dimension)
- ⚠️ Date dimension is incomplete (no year/calendar continuity)
- ⚠️ `dim_loan` is a workaround (volume tiers, not true loan types) due to an upstream data-cleaning decision that dropped `Type_of_Loan`
- ⚠️ Surrogate keys are regenerated on every full rebuild (`CREATE OR REPLACE TABLE`), which would break historical fact-table key stability if this were a production incremental-load system rather than a portfolio sandbox

---

## SECTION 4 — COLUMN DICTIONARY

### `dim_customer`
| Column | Business Meaning | Datatype | Example Values | Unique Count | Null Count | Categorical/Numerical | Slicer? | Drillthrough? | Hierarchy? |
|---|---|---|---|---|---|---|---|---|---|
| customer_key | Surrogate PK | INT64 | 1, 2, 3... | Requires live query | 0 (generated) | Numerical (key) | No | No | No |
| Customer_ID | Business key (natural customer identifier) | STRING | "CUS_0xd40" (typical format) | Requires live query | Requires live query | Categorical (ID) | No (too high cardinality) | Yes | No |
| Name | Customer name | STRING | "No information" (imputed placeholder) or actual name | Requires live query | 0 (imputed) | Categorical | No | Yes | No |
| SSN | Social Security Number | STRING | "Data Missing" (imputed placeholder) or actual SSN | Requires live query | 0 (imputed) | Categorical | No | No | No |
| Age | Customer age | INT64 | 25, 34, 99 (pre-clean outliers imputed to median) | Requires live query | 0 (imputed) | Numerical | Yes (banded) | Yes | Yes (age bands) |

### `dim_date`
| Column | Business Meaning | Datatype | Example Values | Unique Count | Null Count | Categorical/Numerical | Slicer? | Drillthrough? | Hierarchy? |
|---|---|---|---|---|---|---|---|---|---|
| date_key | Surrogate PK | INT64 | 1–12 | ≤12 | 0 | Numerical (key) | No | No | No |
| Month | Month name | STRING | "January", "August" | ≤12 | 0 | Categorical | Yes | Yes | Yes (Month→Quarter) |
| Month_Number | Chronological sort helper | INT64 | 1–12 | ≤12 | 0 | Numerical | No (sort-by only) | No | Yes (hierarchy level) |
| Quarter | Quarter derived from month | INT64 | 1, 2, 3, 4 | ≤4 | 0 | Categorical/Numerical | Yes | Yes | Yes (top hierarchy level) |

### `dim_occupation`
| Column | Business Meaning | Datatype | Example Values | Unique Count | Null Count | Categorical/Numerical | Slicer? | Drillthrough? | Hierarchy? |
|---|---|---|---|---|---|---|---|---|---|
| occupation_key | Surrogate PK | INT64 | 1, 2, 3... | Requires live query | 0 | Numerical (key) | No | No | No |
| Occupation | Customer's stated occupation | STRING | "Civil Servants" (imputed placeholder), "Engineer", "Lawyer", etc. | Requires live query | 0 (imputed) | Categorical | Yes | Yes | No |

### `dim_credit_mix`
| Column | Business Meaning | Datatype | Example Values | Unique Count | Null Count | Categorical/Numerical | Slicer? | Drillthrough? | Hierarchy? |
|---|---|---|---|---|---|---|---|---|---|
| credit_mix_key | Surrogate PK | INT64 | 1–5 | ≤5 | 0 | Numerical (key) | No | No | No |
| Credit_Mix | Categorical assessment of credit mix quality | STRING | "Good", "Standard", "Bad", "Above Standard" (imputed placeholder) | ≤4–5 | 0 (imputed) | Categorical | Yes | Yes | No |
| Credit_Mix_Sort | Manual sort order for Credit_Mix | INT64 | 1, 2, 3, 4, 5 | ≤5 | 0 | Numerical (sort helper) | No (sort-by only) | No | No |

### `dim_payment_behaviour`
| Column | Business Meaning | Datatype | Example Values | Unique Count | Null Count | Categorical/Numerical | Slicer? | Drillthrough? | Hierarchy? |
|---|---|---|---|---|---|---|---|---|---|
| payment_behaviour_key | Surrogate PK | INT64 | 1, 2, 3... | Requires live query | 0 | Numerical (key) | No | No | No |
| Payment_Behaviour | Behavioral spend/payment classification | STRING | "High_spent_Small_value_payments", "Missing Data" (imputed placeholder) | Requires live query | 0 (imputed) | Categorical | Yes | Yes | No |

### `dim_loan`
| Column | Business Meaning | Datatype | Example Values | Unique Count | Null Count | Categorical/Numerical | Slicer? | Drillthrough? | Hierarchy? |
|---|---|---|---|---|---|---|---|---|---|
| loan_key | Surrogate PK | INT64 | 1–5 | 5 | 0 | Numerical (key) | No | No | No |
| Loan_Tier | Loan volume bucket (NOT loan type) | STRING | "No Loan", "Low (1-2)", "Moderate (3-5)", "High (6-8)", "Very High (9+)" | 5 | 0 | Categorical | Yes | Yes | No |
| Loan_Tier_Sort | Manual sort order for Loan_Tier | INT64 | 1–5 | 5 | 0 | Numerical (sort helper) | No | No | No |

### `dim_credit_score`
| Column | Business Meaning | Datatype | Example Values | Unique Count | Null Count | Categorical/Numerical | Slicer? | Drillthrough? | Hierarchy? |
|---|---|---|---|---|---|---|---|---|---|
| credit_score_key | Surrogate PK | INT64 | 1–4 | 4 | 0 | Numerical (key) | No | No | No |
| Credit_Score | Bank's own credit risk classification (confirmed categorical via live query, NOT numeric — corrects an earlier assumption) | STRING | "Poor", "Standard", "Good", "Data Missing" (imputed, ~38% of source rows were NULL) | 4 | 0 (imputed) | Categorical | Yes | Yes | No |
| Credit_Score_Sort | Ordinal sort order (Poor=1, Standard=2, Good=3, Data Missing=4) | INT64 | 1–4 | 4 | 0 | Numerical (sort helper) | No (sort-by only) | No | No |

### `fact_customer_credit`
| Column | Business Meaning | Datatype | Example Values | Unique Count | Null Count | Categorical/Numerical | Slicer? | Drillthrough? | Hierarchy? |
|---|---|---|---|---|---|---|---|---|---|
| customer_credit_key | Surrogate PK | INT64 | 1, 2, 3... | = row count | 0 | Numerical (key) | No | No | No |
| customer_key | FK → dim_customer | INT64 | — | — | 0 | Numerical (key) | No | No | No |
| date_key | FK → dim_date | INT64 | — | — | 0 | Numerical (key) | No | No | No |
| occupation_key | FK → dim_occupation | INT64 | — | — | 0 | Numerical (key) | No | No | No |
| credit_mix_key | FK → dim_credit_mix | INT64 | — | — | 0 | Numerical (key) | No | No | No |
| payment_behaviour_key | FK → dim_payment_behaviour | INT64 | — | — | 0 | Numerical (key) | No | No | No |
| loan_key | FK → dim_loan | INT64 | — | — | 0 | Numerical (key) | No | No | No |
| credit_score_key | FK → dim_credit_score | INT64 | — | — | 0 | Numerical (key) | No | No | No |
| Payment_of_Min_Amount | Degenerate dimension — whether customer pays only the minimum due | STRING | "Yes", "No", "NM" (typical values in this dataset style) | ≤3 | Requires live query | Categorical | Yes | Yes | No |
| Annual_Income | Customer's annual income | FLOAT64 | 19114.12, 34847.84 | Requires live query | Requires live query | Numerical (measure) | Yes (banded) | Yes | Yes (income bands) |
| Monthly_Inhand_Salary | Monthly take-home salary | FLOAT64 | 1824.84 | Requires live query | Requires live query | Numerical (measure) | Yes (banded) | Yes | No |
| Num_Bank_Accounts | Number of bank accounts held | INT64 | 3, 7 | Requires live query | Requires live query | Numerical (measure) | Yes | Yes | No |
| Num_Credit_Card | Number of credit cards held | INT64 | 4, 6 | Requires live query | Requires live query | Numerical (measure) | Yes | Yes | No |
| Interest_Rate | Interest rate applied | FLOAT64 | 3.0, 17.5 | Requires live query | Requires live query | Numerical (measure) | Yes | Yes | No |
| Num_of_Loan | Number of loans (derived) | INT64 | 0, 2, 4 | Requires live query | Requires live query | Numerical (measure) | Yes | Yes | No |
| Delay_from_due_date | Days delayed past due date | INT64 | 3, 14 | Requires live query | Requires live query | Numerical (measure) | Yes | Yes | No |
| Changed_Credit_Limit | Change in credit limit | FLOAT64 | 11.27, 0.0 | Requires live query | Requires live query | Numerical (measure) | Yes | Yes | No |
| Num_Credit_Inquiries | Number of credit inquiries (NULL if originally flagged "Data Missing") | INT64 (nullable) | 4, NULL | Requires live query | Requires live query — see Section 14 | Numerical (measure) | Yes | Yes | No |
| Outstanding_Debt | Total outstanding debt | FLOAT64 | 1824.84 | Requires live query | Requires live query | Numerical (measure) | Yes (banded) | Yes | No |
| Credit_Utilization_Ratio | % of available credit currently used | FLOAT64 | 29.47 | Requires live query | Requires live query | Numerical (measure) | Yes | Yes | No |
| Credit_History_Age_Months | Length of credit history in months (parsed) | INT64 | 265 | Requires live query | Requires live query | Numerical (measure) | Yes (banded) | Yes | No |
| Total_EMI_per_month | Total EMI obligation per month | FLOAT64 | 49.57 | Requires live query | Requires live query | Numerical (measure) | Yes | Yes | No |
| Amount_invested_monthly | Monthly investment amount | FLOAT64 | 236.64 | Requires live query | Requires live query | Numerical (measure) | Yes | Yes | No |
| Monthly_Balance | End-of-month balance | FLOAT64 | 186.27 | Requires live query | Requires live query | Numerical (measure) | Yes | Yes | No |

**Excluded from the model entirely:** `Type_of_Loan` was present in the raw/original source but is **not available anywhere in the current star schema** (dropped during cleaning, matching the original Power Query logic — see Section 3 for the `dim_loan` workaround). `Credit_Score` was also originally dropped by the Power Query logic but has since been **restored** into the model as `dim_credit_score` (see above) after a live query confirmed it is categorical, not numeric as first assumed.

---

## SECTION 5 — EXISTING MEASURES

**None.** No Power BI (.pbix) file has been created yet, and no DAX measures exist anywhere in this project. All numeric transformation logic currently lives in BigQuery SQL as pre-computed columns (e.g., `Credit_History_Age_Months`, `Loan_Tier`), not as Power BI measures. Measure creation is entirely a downstream task for whoever builds the actual Power BI report.

---

## SECTION 6 — TIME INTELLIGENCE

| Attribute | Detail |
|---|---|
| Available Date Columns | `Month` (text month name) in `cleaned_financial_data` / `dim_date` only |
| Calendar Table | `dim_date` exists but is a **month-cycle table, not a true calendar table** |
| Year | **Not present anywhere in the dataset** |
| Quarter | Present (derived, 1–4) |
| Month | Present (name + numeric) |
| Week | Not present |
| Day | Not present |
| Fiscal Calendar | Not applicable — no fiscal period data exists |
| Missing Dates | N/A — there is no continuous date range to check for gaps; only a cycle of month names |
| Can support YOY | **No** — no Year column exists, so year-over-year comparison is not possible without new source data |
| Can support YTD | **No** — same reason, no year boundary can be established |
| Can support QTD | **Partially** — Quarter exists, but without Year, "QTD" would only be meaningful within a single unlabeled cycle |
| Can support MTD | **No** — MTD requires day-level granularity within a month; only whole-month snapshots exist |
| Can support Rolling 12 Months | **No** — requires a true chronological date axis spanning 12+ distinct calendar months with year context; current data has at most 12 month-name buckets with no year to anchor a rolling window |
| Can support Forecasting | **Limited** — Power BI's forecasting feature requires a continuous date/numeric axis; the month-name-only structure is a significant constraint |
| Can support Seasonality analysis | **Partially** — Month-over-month patterns can be observed within the available month cycle, but without Year, true multi-year seasonality cannot be established |

---

## SECTION 7 — GEOGRAPHY

**No geographic columns exist anywhere in this dataset.**

| Attribute | Present? |
|---|---|
| Country | No |
| Region | No |
| State | No |
| City | No |
| Zip | No |
| Latitude | No |
| Longitude | No |
| Can maps be created? | **No** — there is no location data of any kind in the source, cleaned, or dimensional tables |

---

## SECTION 8 — CUSTOMER INFORMATION

| Attribute | Present? | Location |
|---|---|---|
| Customer ID | Yes | `dim_customer.Customer_ID`, `fact_customer_credit` (via FK) |
| Age | Yes | `dim_customer.Age` |
| Gender | **No** — not present in source data at all |
| Occupation | Yes | `dim_occupation.Occupation` |
| Income | Yes | `fact_customer_credit.Annual_Income`, `Monthly_Inhand_Salary` |
| Segment | **No** — no explicit customer segmentation field exists (Loan_Tier and Credit_Mix could serve as informal behavioral segments, but no dedicated "Segment" column exists) |
| Credit Mix | Yes | `dim_credit_mix.Credit_Mix` |
| Credit Score | Yes — restored after correcting an earlier assumption (confirmed categorical via live query, not numeric) | `dim_credit_score.Credit_Score` |
| Education | **No** — not present in source data |
| Marital Status | **No** — not present in source data |
| Demographic attributes present | Age, Occupation only |
| Behavioural attributes present | Payment_Behaviour, Payment_of_Min_Amount, Credit_Utilization_Ratio, Num_Credit_Inquiries, Delay_from_due_date |

---

## SECTION 9 — PRODUCT INFORMATION

**No product-related columns exist anywhere in this dataset.** This is a customer/credit-risk dataset, not a retail/sales dataset.

| Attribute | Present? |
|---|---|
| Product | No |
| Category | No |
| Subcategory | No |
| Brand | No |
| Price | No |
| Cost | No |
| Discount | No |
| Quantity | No |
| Inventory | No |

---

## SECTION 10 — FINANCIAL INFORMATION

| Attribute | Present? | Location |
|---|---|---|
| Revenue | No | Not applicable to this domain |
| Sales | No | Not applicable to this domain |
| Profit | No | Not applicable to this domain |
| Cost | No | Not applicable to this domain (distinct from Outstanding_Debt / EMI, which are customer-liability measures, not company cost) |
| COGS | No | Not applicable |
| Margin | No | Not applicable |
| Interest | Yes | `fact_customer_credit.Interest_Rate` |
| EMI | Yes | `fact_customer_credit.Total_EMI_per_month` |
| Outstanding Debt | Yes | `fact_customer_credit.Outstanding_Debt` |
| Credit Utilization | Yes | `fact_customer_credit.Credit_Utilization_Ratio` |
| Monthly Balance | Yes | `fact_customer_credit.Monthly_Balance` |
| Investment | Yes | `fact_customer_credit.Amount_invested_monthly` |
| Payment | Yes | `fact_customer_credit.Payment_of_Min_Amount` (behavioral flag, not a payment amount) |
| Loan | Yes | `fact_customer_credit.Num_of_Loan`, `dim_loan.Loan_Tier` |
| Calculated financial fields | `Loan_Tier` (bucketed from Num_of_Loan), `Credit_History_Age_Months` (parsed from a text duration), `Monthly_Inhand_Salary` (imputed from Annual_Income/12 where originally missing) |

---

## SECTION 11 — BUSINESS QUESTIONS SUPPORTED

**Executive**
- What is the overall distribution of customers across credit mix categories?
- How does average outstanding debt and credit utilization trend month over month (within the available month cycle)?
- What proportion of customers fall into each loan volume tier?

**Finance**
- What is the average interest rate and EMI burden across the customer base?
- How does monthly balance and invested amount vary by income level?
- What is the relationship between annual income and credit utilization ratio?

**Customer**
- How does credit behavior differ by occupation?
- What is the age distribution of customers, and how does it relate to credit mix?
- Which customers exhibit high delay-from-due-date patterns?

**Product**
- **Not applicable** — no product data exists in this dataset.

**Geography**
- **Not applicable** — no geographic data exists in this dataset.

**Risk**
- Which customers have "Bad" credit mix and high credit utilization simultaneously?
- What is the relationship between number of credit inquiries and delay from due date?
- Which occupations or loan tiers show the highest concentration of risky payment behaviour?
- **Cannot currently answer:** "What is our overall credit score distribution?" — `Credit_Score` is not present anywhere in the model (see Section 8/16).

**Operations**
- How many bank accounts and credit cards does the average customer hold?
- What is the volume of customers in each payment behaviour category?

**Forecasting**
- **Severely limited** — no Year field and no continuous date axis means traditional time-series forecasting (Power BI's built-in forecast feature) is not meaningfully supported with the current date structure.

---

## SECTION 12 — DAX OPPORTUNITIES

(Possibilities only — no DAX written)

- **Running Total** — cumulative Outstanding_Debt or Amount_invested_monthly across the month cycle
- **Moving Average** — smoothed Credit_Utilization_Ratio or Interest_Rate across months
- **Rolling 12 Months** — not well supported due to missing Year field (see Section 6)
- **YOY** — not supported (no Year field)
- **MTD** — not supported (no day-level granularity)
- **Ranking** — rank customers by Outstanding_Debt, Credit_Utilization_Ratio, or Num_Credit_Inquiries
- **Pareto Analysis** — e.g., what % of customers hold what % of total Outstanding_Debt
- **ABC Analysis** — segment customers into risk tiers by outstanding debt or utilization
- **Top N** — Top N customers by debt, by delay days, by credit inquiries
- **Dynamic Titles** — page titles that reflect selected Month/Occupation/Credit_Mix slicer state
- **Field Parameters** — toggle between viewing Annual_Income vs. Monthly_Inhand_Salary, or between different risk measures, on the same visual
- **Dynamic Measures** — switch the active measure (e.g., Outstanding_Debt vs. Credit_Utilization_Ratio) via a field parameter or disconnected slicer table
- **Variance** — variance in Monthly_Balance or Amount_invested_monthly across months for the same customer
- **Contribution %** — each Occupation's or Loan_Tier's share of total Outstanding_Debt
- **Customer Lifetime Value** — not directly supported (no transaction-level revenue data — this is a liability/risk dataset, not a revenue dataset)
- **Retention** — not supported (no active/churn flag or subscription concept in the data)
- **Forecast** — limited/not well supported (see Section 6 and 11)

---

## SECTION 13 — POWER BI FEATURES SUPPORTED

| Feature | Supported? | Why |
|---|---|---|
| Bookmarks | Yes | Standard feature, works with any model — no data dependency |
| Buttons/Navigation | Yes | No data dependency |
| Sync Slicers | Yes | Multiple categorical dimensions (Occupation, Credit_Mix, Payment_Behaviour, Loan_Tier) make cross-page slicer sync useful |
| Tooltip Pages | Yes | Numeric measures (Outstanding_Debt, Credit_Utilization_Ratio, etc.) support rich hover tooltips |
| Drillthrough | Yes | Customer_ID, Occupation, Credit_Mix, Loan_Tier, Payment_Behaviour are all viable drillthrough targets |
| Drill Down | Yes, limited | Only real hierarchy available is Month → Quarter; no Year level, no product/geography hierarchies exist |
| Hierarchies | Yes, limited | Same constraint — only Date (Month/Quarter) hierarchy is buildable; Age could be manually banded into a hierarchy |
| Conditional Formatting | Yes | Credit_Mix, Payment_Behaviour, Loan_Tier, and numeric risk measures are all strong candidates |
| Field Parameters | Yes | Multiple comparable numeric measures (Outstanding_Debt, Credit_Utilization_Ratio, Interest_Rate, etc.) support a field-parameter measure-switcher |
| What-if Parameters | Yes | Could simulate, e.g., "what if Interest_Rate changed by X%" against Total_EMI_per_month |
| Forecast (built-in) | **No / Not meaningful** | Requires a continuous date axis; only month-name cycle without year exists |
| Decomposition Tree | Yes | Outstanding_Debt or Credit_Utilization_Ratio could be decomposed by Occupation → Credit_Mix → Loan_Tier |
| Key Influencers | Yes | Could analyze what drives "Bad" Credit_Mix or high Delay_from_due_date using the available categorical/numeric fields |
| Smart Narrative | Yes | Works with any aggregated measures — no data dependency |
| Q&A | Yes | Column names are natural-language friendly (Annual_Income, Outstanding_Debt, etc.) |
| Map / Filled Map | **No** | No geographic data exists anywhere in the model (see Section 7) |
| Scatter | Yes | E.g., Annual_Income vs. Outstanding_Debt, or Credit_Utilization_Ratio vs. Delay_from_due_date |
| Waterfall | Yes, limited | Could show contribution of categories (e.g., by Credit_Mix) to a total measure, though no true "beginning/ending balance" bridge exists |
| Treemap | Yes | Good fit for Occupation, Credit_Mix, Payment_Behaviour, or Loan_Tier proportional breakdowns |
| Matrix | Yes | Strong fit — e.g., Occupation × Credit_Mix × average Outstanding_Debt |
| Small Multiples | Yes | E.g., small multiples of a trend by Occupation or Credit_Mix |
| Gauge | Yes, limited | Could show a single KPI like average Credit_Utilization_Ratio against a target, though no explicit target/goal column exists in the data |
| Ribbon | Yes, limited | Could show category rank changes across the month cycle, though limited by lack of true chronological continuity |
| Sankey | Yes, if meaningful | Could show flow between Credit_Mix categories and Loan_Tier or Payment_Behaviour categories, though this is a stretch use case given the data is not naturally flow-based |

---

## SECTION 14 — DATA QUALITY

| Issue | Detail |
|---|---|
| Missing Values | Handled during cleaning for Name, SSN, Occupation, Age, Monthly_Inhand_Salary, Changed_Credit_Limit, Amount_invested_monthly, Credit_History_Age_Months, Payment_Behaviour, Credit_Mix, and **Credit_Score** (~38% of source rows were NULL, imputed to "Data Missing", confirmed via live query against `raw_financial_data`) — all imputed with median/placeholder text. **Not fully resolved:** `Num_Credit_Inquiries` — stored as STRING in `cleaned_financial_data` (can hold literal text "Data Missing"), and when `SAFE_CAST` to INT64 in `fact_customer_credit`, those rows become **NULL**. Requires live query to quantify: `SELECT COUNTIF(Num_Credit_Inquiries IS NULL) FROM fact_customer_credit` |
| Duplicates | Requires live query — potential for duplicate (Customer_ID, Month) combinations in `cleaned_financial_data` was not explicitly tested; run the query in Section 2.2 |
| Outliers | Age outliers (≤0 or ≥99) were already median-imputed during cleaning; Num_Bank_Accounts (outside -1 to 11) and Num_Credit_Card (≥25) and Interest_Rate (outside 0–35) were similarly median-imputed. Remaining outlier risk exists in unbounded measures like Outstanding_Debt, Total_EMI_per_month, Amount_invested_monthly, which have no range-validation/imputation applied |
| Invalid Dates | Not applicable in the traditional sense — no true date type exists, only Month text; however, any Month value outside the 12 recognized names would map to a `NULL` Month_Number/Quarter in `dim_date` (silent data-quality gap worth checking: `SELECT DISTINCT Month FROM cleaned_financial_data WHERE Month NOT IN ('January','February',...,'December')`) |
| Relationship Problems | None identified structurally — all fact-to-dimension joins use LEFT JOIN on values sourced from the same `cleaned_financial_data` table, so keys should align. Not yet verified with a live orphan-check query: `SELECT COUNT(*) FROM fact_customer_credit WHERE customer_key IS NULL` (repeat for each FK) |
| Data Quality Issues (structural) | (1) `Num_Credit_Inquiries` mixed-type-turned-nullable-numeric is a known compromise. (2) `dim_loan` represents volume tiers, not true loan types, because `Type_of_Loan` was dropped upstream. (3) `Credit_Score` — the likely target variable for a credit-risk project — is entirely absent from the model. (4) No Year field exists, constraining nearly all time intelligence. |

---

## SECTION 15 — PERFORMANCE

| Attribute | Detail |
|---|---|
| Large Tables | `cleaned_financial_data` and `fact_customer_credit` are the largest (row count = full dataset volume); all dimension tables are small by design (deduplicated) |
| Unused Columns | `Customer_ID` and `SSN` in `dim_customer` are needed for ETL joins but should be hidden from Power BI report view — not "unused" but not report-facing either |
| Unused Relationships | None yet — no Power BI model exists, so no relationships have been created or left unused |
| Potential Performance Bottlenecks | (1) All 7 build scripts run as full `CREATE OR REPLACE TABLE` — meaning `fact_customer_credit` rebuild costs 6 dimension joins against the full fact grain every time, non-incremental. (2) Surrogate keys via `ROW_NUMBER() OVER ()` with no partitioning on the fact table forces a full single-threaded ordering operation in BigQuery — worth monitoring at larger scale. |
| Optimization Opportunities | (1) Partition/cluster `fact_customer_credit` by `date_key` or `Month` for query performance at scale. (2) Move to incremental `MERGE`-based dimension updates once billing/DML is enabled, rather than full rebuilds. (3) In Power BI, disable auto date/time and rely on the explicit (if incomplete) `dim_date` table. |

---

## SECTION 16 — FINAL SUMMARY

**Business strengths of this dataset**
- Rich set of credit-behavior measures (utilization, delay, inquiries, EMI, debt) well-suited to risk-oriented analysis
- Clean, well-structured star schema with proper surrogate keys and no snowflaking
- Deliberate, documented handling of dirty source data (imputation, placeholder normalization)

**Business weaknesses**
- No Year field — severely limits any genuine time-intelligence (YOY, rolling 12 months, forecasting)
- No geographic or product dimension — restricts the project to a single analytical dimension (customer/credit behavior only)
- `Type_of_Loan` was dropped, so loan-type-level analysis (vs. loan-volume-level) is not currently possible
- `Credit_Score` is categorical (Poor/Standard/Good), not a continuous numeric score — this was an incorrect assumption earlier in the project, corrected via live query. It supports classification-based risk tiering well, but not continuous scoring/trending the way a true numeric bureau score would

**Most valuable dimensions**
- `dim_credit_mix`, `dim_occupation`, `dim_payment_behaviour` — all directly support the "Credit Behaviour" and "Customer Risk" analytical goals stated for this project

**Most valuable measures**
- Outstanding_Debt, Credit_Utilization_Ratio, Delay_from_due_date, Num_Credit_Inquiries — the core risk-signal measures

**Most important KPIs (candidates, not built)**
- Average Credit Utilization Ratio, Total Outstanding Debt, Average Delay from Due Date, % customers in "Bad" Credit Mix, % customers in "Very High" Loan Tier

**Most useful slicers**
- Occupation, Credit_Mix, Payment_Behaviour, Loan_Tier, Month

**Most useful drillthrough paths**
- From any summary visual → Customer_ID-level detail page showing all measures for a selected customer across the available months

**Most suitable report pages (per the stated project goal list)**
- Executive Overview, Customer Demographics, Credit Behaviour, Loan Analysis (as Loan Volume, not Loan Type), Customer Risk — all directly supported. Product Portfolio is **not supported** (no product data exists in this dataset at all, despite being listed as a target dashboard page in the original project goal).

**Important limitations**
1. No Year → time intelligence severely constrained
2. No geography or product data → 2 of the 7 originally stated dashboard pages ("Product Portfolio", and any geographic element of "Executive Overview") are not achievable with current data
3. `dim_loan` is a volume-tier proxy, not a true loan-type dimension
4. `Credit_Score` is categorical, not numeric — supports risk classification/tiering but not continuous score trending
5. Several row/null/duplicate statistics throughout this document require a live BigQuery query to quantify precisely — they are structurally described here but not numerically verified
