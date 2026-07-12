# Financial Credit Risk Analytics — Business Analytics Possibilities

> Scope: This document analyzes ONLY the business-analytics potential of the existing data model (`fact_customer_credit` + 6 dimensions). No dashboards, layouts, colors, or visuals are recommended here except where Section 8/9 explicitly require naming AI visuals.

---

## SECTION 1 — COMPLETE KPI INVENTORY

### Revenue-Like / Portfolio Exposure KPIs
*(Note: this is a consumer-liability dataset, not a sales dataset — there is no true "revenue." These KPIs treat outstanding debt, interest, and EMI as bank exposure/yield proxies.)*

| KPI Name | Business Meaning | Formula (Plain English) | Executive Importance | Suitable Aggregation |
|---|---|---|---|---|
| Total Outstanding Debt Exposure | Total credit risk the bank is carrying across all customers | Sum of Outstanding_Debt across all rows | High | Sum |
| Average Interest Rate | Average yield the bank earns per customer loan | Average of Interest_Rate | High | Average |
| Total Monthly EMI Base | Total monthly repayment inflow expected from customers | Sum of Total_EMI_per_month | High | Sum |
| Average Amount Invested Monthly | Average customer investment activity (cross-sell signal) | Average of Amount_invested_monthly | Medium | Average |
| Total Credit Limit Expansion | Net change in credit issued across the portfolio | Sum of Changed_Credit_Limit | Medium | Sum |
| Average Monthly Balance | Average liquidity cushion customers maintain | Average of Monthly_Balance | Medium | Average |

### Risk KPIs
| KPI Name | Business Meaning | Formula (Plain English) | Executive Importance | Suitable Aggregation |
|---|---|---|---|---|
| Average Credit Utilization Ratio | How aggressively customers use their available credit | Average of Credit_Utilization_Ratio | High | Average |
| % High Utilization Customers | Share of customers at elevated default risk | Count of customers with Credit_Utilization_Ratio above a risk threshold ÷ total customers | High | Ratio |
| Average Delay from Due Date | Typical lateness in bill/loan payments | Average of Delay_from_due_date | High | Average |
| % Customers with Payment Delays | Share of the base showing delinquent behavior | Count of customers with Delay_from_due_date > 0 ÷ total customers | High | Ratio |
| Average Credit Inquiries | Signal of credit-seeking / financial stress behavior | Average of Num_Credit_Inquiries | Medium | Average |
| % High Inquiry Customers | Share of customers showing aggressive credit-seeking behavior | Count with Num_Credit_Inquiries above threshold ÷ total | Medium | Ratio |
| % Customers in "Bad" Credit Mix | Share of the portfolio in the worst credit-quality bucket | Count where Credit_Mix = "Bad" ÷ total | High | Ratio |
| % Customers in "Very High" Loan Tier | Share of customers with heaviest loan burden | Count where Loan_Tier = "Very High (9+)" ÷ total | High | Ratio |
| Debt-to-Income Ratio | Core underwriting risk metric | Outstanding_Debt ÷ Annual_Income, averaged across customers | High | Ratio / Average |

### Customer KPIs
| KPI Name | Business Meaning | Formula (Plain English) | Executive Importance | Suitable Aggregation |
|---|---|---|---|---|
| Total Distinct Customers | Size of the customer base | Distinct count of Customer_ID | High | Distinct Count |
| Average Customer Age | Demographic profile of the base | Average of Age | Medium | Average |
| Customer Count by Occupation | Workforce composition of the customer base | Count of customers grouped by Occupation | Medium | Count |
| Average Annual Income | Wealth profile of the customer base | Average of Annual_Income | High | Average |
| Average Monthly Inhand Salary | Take-home earning power of customers | Average of Monthly_Inhand_Salary | Medium | Average |
| Bank Account Penetration | How many banking relationships the average customer holds | Average of Num_Bank_Accounts | Low | Average |
| Credit Card Penetration | Credit card product adoption per customer | Average of Num_Credit_Card | Low | Average |

### Credit KPIs
| KPI Name | Business Meaning | Formula (Plain English) | Executive Importance | Suitable Aggregation |
|---|---|---|---|---|
| Average Credit History Age (Months) | Depth/maturity of customer credit relationships | Average of Credit_History_Age_Months | Medium | Average |
| Credit Mix Distribution | Portfolio quality composition | Count of customers grouped by Credit_Mix | High | Count / % |
| Average Changed Credit Limit | Typical credit line adjustment behavior | Average of Changed_Credit_Limit | Low | Average |
| Credit Health Index (composite, hypothetical) | Blended score combining utilization, mix, and inquiries | Weighted combination of Credit_Utilization_Ratio, Credit_Mix_Sort, Num_Credit_Inquiries | High | Ratio (composite) |

### Payment KPIs
| KPI Name | Business Meaning | Formula (Plain English) | Executive Importance | Suitable Aggregation |
|---|---|---|---|---|
| % Minimum-Payment-Only Customers | Share of customers only servicing the minimum due (early-warning risk signal) | Count where Payment_of_Min_Amount = "Yes" ÷ total | High | Ratio |
| Payment Behaviour Distribution | Spend/payment pattern composition of the base | Count of customers grouped by Payment_Behaviour | Medium | Count / % |
| Savings Proxy Ratio | Rough measure of disposable income retained | Monthly_Balance ÷ Monthly_Inhand_Salary, averaged | Medium | Ratio / Average |

### Loan KPIs
| KPI Name | Business Meaning | Formula (Plain English) | Executive Importance | Suitable Aggregation |
|---|---|---|---|---|
| Average Number of Loans | Typical loan burden per customer | Average of Num_of_Loan | High | Average |
| Loan Tier Distribution | Portfolio composition by loan volume risk bucket | Count of customers grouped by Loan_Tier | High | Count / % |
| Debt per Loan | Average debt carried per active loan | Outstanding_Debt ÷ Num_of_Loan, averaged (guard against divide-by-zero at Num_of_Loan = 0) | Medium | Ratio / Average |
| EMI Burden Ratio | Share of income consumed by loan repayments | Total_EMI_per_month ÷ Monthly_Inhand_Salary, averaged | High | Ratio / Average |

### Behavior KPIs
| KPI Name | Business Meaning | Formula (Plain English) | Executive Importance | Suitable Aggregation |
|---|---|---|---|---|
| Investment Rate | Share of income customers choose to invest rather than spend | Amount_invested_monthly ÷ Monthly_Inhand_Salary, averaged | Medium | Ratio / Average |
| Delay Frequency by Occupation | Which professions show the most payment delay risk | Average Delay_from_due_date grouped by Occupation | Medium | Average (grouped) |
| Inquiry-to-Utilization Correlation Signal | Whether credit-seeking behavior aligns with high utilization | Correlation between Num_Credit_Inquiries and Credit_Utilization_Ratio | Medium | Correlation (statistical, not a standard aggregation) |

---

## SECTION 2 — EXECUTIVE QUESTIONS (Top 20, Ranked)

| # | Question | Business Goal | Why Executives Care | Required KPIs | Required Dimensions | Difficulty |
|---|---|---|---|---|---|---|
| 1 | What is our total outstanding debt exposure across the portfolio? | Understand total balance-sheet risk | Direct input to capital reserve and risk provisioning decisions | Total Outstanding Debt Exposure | None (portfolio-wide) | Easy |
| 2 | What percentage of customers are in the "Bad" Credit Mix category? | Quantify portfolio credit quality | Directly informs risk appetite and provisioning strategy | % Customers in "Bad" Credit Mix | dim_credit_mix | Easy |
| 3 | What is our average credit utilization ratio, and how many customers exceed safe thresholds? | Identify default-risk concentration | Utilization is one of the strongest predictors of default in consumer credit | Average Credit Utilization Ratio, % High Utilization Customers | fact measures only | Easy |
| 4 | Which occupations show the highest payment delay and lowest credit mix quality? | Target underwriting policy by segment | Enables occupation-based risk-adjusted pricing or scrutiny | Average Delay from Due Date, Credit Mix Distribution | dim_occupation, dim_credit_mix | Medium |
| 5 | What share of customers are only paying the minimum amount due? | Early-warning indicator of financial distress | Minimum-payment behavior is a classic leading indicator of future default | % Minimum-Payment-Only Customers | fact.Payment_of_Min_Amount | Easy |
| 6 | How is our loan portfolio distributed across loan volume tiers? | Understand concentration of over-leveraged customers | High loan-tier concentration signals systemic portfolio risk | Loan Tier Distribution | dim_loan | Easy |
| 7 | What is the average debt-to-income ratio across our customer base? | Core underwriting health metric | Directly reflects repayment capacity across the book | Debt-to-Income Ratio | fact measures + dim_customer (via Annual_Income) | Medium |
| 8 | What is our average number of credit inquiries, and which customers show unusually high inquiry activity? | Detect financial distress / credit-seeking spikes | Inquiry spikes often precede default or overextension | Average Credit Inquiries, % High Inquiry Customers | fact measures only | Easy |
| 9 | How does credit utilization or delay behavior trend across the available months? | Monitor whether portfolio risk is improving or worsening over time | Executives need trend direction even without full time intelligence | Average Credit Utilization Ratio, Average Delay from Due Date | dim_date | Medium (limited by no-Year constraint) |
| 10 | What is the distribution of payment behaviour categories across the customer base? | Understand spend/repayment personas | Segments customers by financial behavior style for targeted policy | Payment Behaviour Distribution | dim_payment_behaviour | Easy |
| 11 | What is our average EMI burden relative to customer income? | Assess repayment sustainability at the portfolio level | High EMI-to-income ratios signal future repayment stress | EMI Burden Ratio | fact measures + dim_customer | Medium |
| 12 | Which customers combine high utilization AND high delay AND "Bad" credit mix simultaneously? | Identify the highest-risk customer cohort for intervention | This compound-risk cohort is the most actionable list for collections/risk teams | Multiple risk KPIs combined | dim_credit_mix + fact measures | Medium-Hard |
| 13 | What is our average credit history age, and does longer history correlate with better credit mix? | Assess whether tenure reduces risk | Common banking hypothesis worth validating with this exact dataset | Average Credit History Age, Credit Mix Distribution | dim_credit_mix | Medium |
| 14 | How many bank accounts and credit cards does the average customer hold, and does this relate to risk? | Understand product-holding depth vs. risk profile | More products can mean either loyalty or overextension — worth investigating | Bank Account Penetration, Credit Card Penetration, risk KPIs | fact measures only | Medium |
| 15 | What is the average monthly balance customers maintain, and how does it vary by occupation? | Gauge liquidity buffer across segments | Low balances alongside high debt is a stress signal | Average Monthly Balance | dim_occupation | Medium |
| 16 | What is our average investment rate, and which customer segments invest the most relative to income? | Identify cross-sell opportunity for investment products | Investment behavior signals financial sophistication and product opportunity | Investment Rate | dim_occupation, dim_credit_mix | Medium |
| 17 | How does the number of loans held relate to credit utilization and delay behavior? | Test whether loan stacking predicts distress | Directly relevant to loan origination policy | Average Number of Loans, Average Credit Utilization Ratio | dim_loan | Medium |
| 18 | What is the age distribution of our customer base, and does age correlate with financial behavior? | Understand demographic risk skew | Age-based risk patterns inform marketing and underwriting policy | Average Customer Age, behavior KPIs | dim_customer | Medium |
| 19 | Which credit mix category holds the largest share of total outstanding debt? | Understand where financial exposure concentrates | Combines volume and severity into one exposure view | Total Outstanding Debt Exposure, Credit Mix Distribution | dim_credit_mix | Medium |
| 20 | Can we rank customers by a composite risk score combining utilization, delay, inquiries, and credit mix? | Build a prioritized watchlist for risk/collections teams | This is the single most actionable executive ask in a credit risk context | Credit Health Index (composite) | dim_customer, dim_credit_mix, fact measures | Hard |

---

## SECTION 3 — DIMENSION ANALYSIS

### `dim_customer`
- **Business purpose:** Anchors every measure to an individual, deduplicated customer identity.
- **Possible filtering:** Filter by Age band; filter to a specific Customer_ID for account-level review.
- **Possible grouping:** Group by Age band to see risk/behavior patterns by generation.
- **Possible drill-down:** From portfolio-level → segment-level → individual customer.
- **Possible hierarchy:** Age → Age Band (manually constructed; no natural multi-level hierarchy exists otherwise).
- **Business usefulness:** High — every KPI ultimately needs to be traceable back to a customer for account management and collections use cases.

### `dim_date`
- **Business purpose:** Provides a (partial) time axis — Month and Quarter — for tracking behavior across the available snapshot cycle.
- **Possible filtering:** Filter to a specific Month or Quarter.
- **Possible grouping:** Group KPIs by Month or Quarter to observe within-cycle patterns.
- **Possible drill-down:** Quarter → Month.
- **Possible hierarchy:** Quarter → Month (two levels only; no Year above it).
- **Business usefulness:** Medium — useful for within-cycle trend observation, but the missing Year field caps its executive value for true period-over-period reporting.

### `dim_occupation`
- **Business purpose:** Segments customers by profession, a common proxy for income stability and risk profile in banking.
- **Possible filtering:** Filter any KPI to a specific occupation.
- **Possible grouping:** Group all risk/credit/behavior KPIs by occupation.
- **Possible drill-down:** Portfolio → Occupation → Customer.
- **Possible hierarchy:** None natural (flat categorical), unless occupations are manually grouped into broader sectors.
- **Business usefulness:** High — occupation-based segmentation is a standard lever in banking risk and marketing analytics.

### `dim_credit_mix`
- **Business purpose:** Represents the bank's own categorical assessment of a customer's overall credit quality.
- **Possible filtering:** Filter to "Good", "Standard", "Above Standard", or "Bad" customers.
- **Possible grouping:** Group any KPI by Credit_Mix to compare quality tiers.
- **Possible drill-down:** Portfolio → Credit Mix tier → Customer.
- **Possible hierarchy:** None beyond the single categorical level (Credit_Mix_Sort exists purely for ordinal display, not hierarchy).
- **Business usefulness:** Very High — this is arguably the single most important dimension in a credit risk project, since it's the bank's own quality label.

### `dim_payment_behaviour`
- **Business purpose:** Captures behavioral spend/payment personas (e.g., high-spend/low-value payments), a strong proxy for financial discipline.
- **Possible filtering:** Filter to any specific behavior category.
- **Possible grouping:** Group KPIs by Payment_Behaviour to compare behavioral cohorts.
- **Possible drill-down:** Portfolio → Behavior category → Customer.
- **Possible hierarchy:** None natural.
- **Business usefulness:** High — directly supports behavioral segmentation, a core banking analytics use case.

### `dim_loan`
- **Business purpose:** Buckets customers by loan volume burden (No Loan → Very High).
- **Possible filtering:** Filter to a specific loan tier.
- **Possible grouping:** Group KPIs by Loan_Tier to see how loan burden relates to risk/behavior.
- **Possible drill-down:** Portfolio → Loan Tier → Customer.
- **Possible hierarchy:** None beyond the ordinal tier itself (Loan_Tier_Sort is for display order only).
- **Business usefulness:** High for volume-based analysis; **cannot support loan-type-based analysis** (e.g., "how do Auto Loans compare to Personal Loans"), since that data was dropped upstream.

### `Payment_of_Min_Amount` (degenerate dimension, lives in the fact table)
- **Business purpose:** Flags customers who service only their minimum payment due — a classic early-warning behavioral signal.
- **Possible filtering:** Filter to Yes/No/NM.
- **Possible grouping:** Group any KPI by this flag to isolate minimum-payer risk.
- **Possible drill-down:** Portfolio → Flag → Customer.
- **Possible hierarchy:** None (binary/ternary flag).
- **Business usefulness:** High despite its simplicity — this single flag is one of the strongest behavioral risk indicators in the entire dataset.

---

## SECTION 4 — NUMERICAL COLUMN ANALYSIS

| Column | Business Meaning | Aggregatable? | Average Meaningful? | Median Meaningful? | Distribution Analysis? | Trend Analysis? | Outlier Detection? | Variance Useful? | Suitable KPI? |
|---|---|---|---|---|---|---|---|---|---|
| Age | Customer demographic | Yes | Yes | Yes (robust to outliers) | Yes (age bands) | Limited (static per customer) | Yes (already median-imputed for extreme values in cleaning) | Low | Yes — demographic segmentation |
| Annual_Income | Wealth/earning capacity | Yes | Yes | Yes (income is typically right-skewed, median often more representative) | Yes (income bands) | Yes, within available months | Yes (high-income outliers likely) | Medium | Yes — core segmentation and risk driver |
| Monthly_Inhand_Salary | Take-home earning power | Yes | Yes | Yes | Yes | Yes | Yes | Medium | Yes — used in ratio KPIs (EMI burden, savings rate) |
| Num_Bank_Accounts | Banking relationship depth | Yes | Yes | Yes | Yes (low cardinality, near-categorical) | Limited | Yes (already median-imputed for extreme values) | Low | Medium — supportive metric, not primary |
| Num_Credit_Card | Credit product adoption | Yes | Yes | Yes | Yes | Limited | Yes (already median-imputed) | Low | Medium |
| Interest_Rate | Cost of credit to customer / yield to bank | Yes | Yes | Yes | Yes | Yes, across months | Yes (already median-imputed for out-of-range values) | Medium | Yes — core financial KPI |
| Num_of_Loan | Loan burden count | Yes | Yes | Yes | Yes (drives Loan_Tier bucketing) | Limited | Possible (very high counts) | Medium | Yes — feeds Loan Tier and Debt-per-Loan KPIs |
| Delay_from_due_date | Payment lateness in days | Yes | Yes | Yes (likely skewed by chronic late-payers) | Yes | Yes, across months | Yes (extreme delays are highly meaningful, not noise to remove) | High | Yes — core risk KPI |
| Changed_Credit_Limit | Credit line adjustment behavior | Yes | Yes | Yes | Yes | Yes, across months | Yes | Medium | Medium — supportive credit-management KPI |
| Num_Credit_Inquiries | Credit-seeking / distress signal (nullable — see data quality notes) | Yes (excluding nulls) | Yes | Yes | Yes | Yes, across months | Yes (high-inquiry customers are a genuine risk segment, not noise) | Medium | Yes — strong risk KPI |
| Outstanding_Debt | Total customer liability | Yes | Yes | Yes (likely skewed) | Yes | Yes, across months | Yes (large-debt customers are a genuine watch-list, not noise) | High | Yes — top-tier KPI |
| Credit_Utilization_Ratio | Aggressiveness of credit usage | Yes | Yes | Yes | Yes | Yes, across months | Yes (near-100% utilization is a critical risk flag) | High | Yes — top-tier risk KPI |
| Credit_History_Age_Months | Depth of credit relationship | Yes | Yes | Yes | Yes | Limited (mostly static per customer) | Yes (unusually short/long histories) | Low | Yes — tenure-based segmentation |
| Total_EMI_per_month | Monthly repayment obligation | Yes | Yes | Yes | Yes | Yes, across months | Yes | Medium | Yes — feeds EMI Burden Ratio |
| Amount_invested_monthly | Discretionary investment behavior | Yes | Yes | Yes | Yes | Yes, across months | Yes | Medium | Yes — cross-sell/behavior KPI |
| Monthly_Balance | Liquidity buffer | Yes | Yes | Yes | Yes | Yes, across months | Yes (near-zero or negative balances are a critical flag) | High | Yes — liquidity risk KPI |

---

## SECTION 5 — RELATIONSHIP ANALYSIS (Business Perspective)

- **Customer → Credit Mix:** Every customer carries the bank's own quality label. Combined with Customer demographics (Age, Occupation), this is the foundation for understanding *which kinds* of customers land in each credit-quality tier — the single most important relationship in the model for risk segmentation.
- **Customer → Payment Behaviour:** Reveals whether a customer's spend/payment persona (e.g., high-spend/low-value payments) aligns with their credit quality — a customer with "Bad" Credit_Mix and a high-spend behavior pattern is a materially different risk case than one with "Bad" Credit_Mix but conservative spend behavior.
- **Month → Credit Utilization:** Within the available month cycle, this relationship shows whether utilization is rising or falling across the snapshot period — a leading indicator banks watch closely for portfolio deterioration, even without a full multi-year time series.
- **Occupation → Risk (Credit Mix / Delay / Utilization):** Occupation is one of the most actionable segmentation axes in banking — if certain occupations systematically show worse credit mix or higher delay, that directly informs underwriting policy and marketing targeting.
- **Loan → EMI:** The number and tier of loans a customer holds should logically correlate with their Total_EMI_per_month — validating this relationship (or finding it broken, e.g., high loan count but low EMI) surfaces either data-quality issues or genuinely unusual repayment structuring.
- **Credit Mix → Outstanding Debt:** Testing whether "Bad" Credit Mix customers actually carry more debt (as expected) or not is a core validation exercise — if the relationship is weak, it suggests Credit_Mix reflects factors beyond debt load alone (e.g., payment history, inquiry behavior).
- **Payment_of_Min_Amount → Delay_from_due_date:** Minimum-payment behavior and payment delay are two independent behavioral risk signals; examining whether they co-occur (compounding risk) or appear separately helps distinguish "slow payers" from "minimum-only but on-time payers," which are different risk profiles.
- **Age → Financial Behavior:** Testing whether younger vs. older customers show different utilization, investment, or delay patterns supports age-based product and risk strategy.

---

## SECTION 6 — ADVANCED ANALYSIS POSSIBILITIES

| Technique | Possible? | Why |
|---|---|---|
| Segmentation | Yes | Occupation, Credit_Mix, Payment_Behaviour, Loan_Tier, and Age all provide natural, non-overlapping segmentation axes |
| Risk Profiling | Yes | Credit_Utilization_Ratio, Delay_from_due_date, Num_Credit_Inquiries, Credit_Mix, and Payment_of_Min_Amount together form a genuine multi-factor risk profile per customer |
| Behaviour Analysis | Yes | Payment_Behaviour and Payment_of_Min_Amount directly encode behavioral persona; Amount_invested_monthly adds a discretionary-behavior lens |
| Trend Analysis | Partially | Possible within the available month cycle (Month/Quarter), but not across years — trend claims must be scoped as "within-cycle" not "year-over-year" |
| Outlier Detection | Yes | Outstanding_Debt, Credit_Utilization_Ratio, Delay_from_due_date, and Num_Credit_Inquiries all have meaningful, non-noise outliers (i.e., genuine high-risk customers, not data errors, since data-quality outliers were already handled in cleaning) |
| Correlation | Yes | Natural candidate pairs: Utilization vs. Delay, Inquiries vs. Utilization, Income vs. Debt, Age vs. behavior measures |
| Ranking | Yes | Rank customers by Outstanding_Debt, Credit_Utilization_Ratio, or a composite risk score for watchlist generation |
| Pareto | Yes | Test whether a small % of customers hold a disproportionate % of total Outstanding_Debt (classic 80/20 exposure concentration check) |
| ABC Analysis | Yes | Classify customers into A/B/C risk tiers based on Outstanding_Debt or a composite risk measure |
| Contribution Analysis | Yes | Each Occupation's, Credit_Mix tier's, or Loan_Tier's share of total Outstanding_Debt or total customer count |
| Customer Profiling | Yes | Combine Age, Occupation, Credit_Mix, Payment_Behaviour, and Loan_Tier into a multi-dimensional customer profile |
| Payment Pattern Analysis | Yes | Payment_Behaviour + Payment_of_Min_Amount + Delay_from_due_date together describe a rich payment pattern per customer |
| Credit Health Analysis | Yes | Credit_Mix + Credit_Utilization_Ratio + Credit_History_Age_Months + Num_Credit_Inquiries can be combined into a credit health narrative per customer or segment |
| Portfolio Analysis | Yes | Aggregate Outstanding_Debt, Interest_Rate, and Loan_Tier distribution give a genuine portfolio-level exposure and yield view |

---

## SECTION 7 — INTERACTION OPPORTUNITIES

- **Customer drillthrough** — from any aggregated view down to a single Customer_ID's full profile across all available months.
- **Occupation filtering** — isolate any KPI to a single profession for targeted review.
- **Month filtering** — narrow any KPI to a specific snapshot month (within the available cycle).
- **Risk-tier drilldown** — filter or drill from overall portfolio → Credit_Mix tier → Loan_Tier → individual customer.
- **Credit Mix comparison** — side-by-side comparison of KPIs across Good/Standard/Above Standard/Bad segments.
- **Payment Behaviour comparison** — compare risk and financial KPIs across behavioral personas.
- **Customer segmentation interaction** — combine Occupation + Credit_Mix + Loan_Tier as compound filters to isolate specific risk cohorts (e.g., "Engineers in Bad Credit Mix with Very High Loan Tier").
- **Minimum-payment flag toggle** — compare the entire KPI set for Payment_of_Min_Amount = Yes vs. No customers.
- **Age-band interaction** — filter/segment by constructed age bands to view generational patterns.

---

## SECTION 8 — DAX OPPORTUNITIES (Naming Only, No Formulas)

- Running Total (e.g., cumulative Outstanding_Debt across the month cycle)
- Rolling Average (smoothed Credit_Utilization_Ratio or Delay_from_due_date)
- Ranking (customers or segments ranked by risk measures)
- Percentile (e.g., which percentile a customer's Outstanding_Debt falls into)
- Top N / Bottom N (highest-risk or lowest-risk customers/segments)
- Dynamic Titles (reflecting active Occupation/Credit_Mix/Month selection)
- Dynamic KPI (switching the displayed measure via a field parameter)
- Variance (month-to-month variance in Monthly_Balance or Credit_Utilization_Ratio per customer)
- Contribution % (each segment's share of total Outstanding_Debt or customer count)
- Customer Classification (rule-based tagging, e.g., "High Risk" / "Watch" / "Healthy")
- Risk Classification (composite scoring combining multiple risk measures into a single tier)
- Conditional Labels (e.g., labeling customers "Minimum Payer" or "Delinquent" based on flag/measure thresholds)
- Bucket Analysis (grouping continuous measures like Age, Annual_Income, or Outstanding_Debt into bands)
- Dynamic Segmentation (user-adjustable thresholds for what counts as "high utilization" or "high risk," via what-if parameters)
- Calculation Groups (if multiple measures need consistent time/format treatment applied uniformly — moderately appropriate given the limited but real Month/Quarter dimension)

---

## SECTION 9 — AI VISUAL ANALYSIS

| AI Visual | Meaningful? | Why |
|---|---|---|
| Key Influencers | **Yes** | Strong fit — can genuinely analyze what drives "Bad" Credit_Mix or high Delay_from_due_date using Occupation, Age, Payment_Behaviour, and the numeric risk measures as inputs |
| Decomposition Tree | **Yes** | Outstanding_Debt or Credit_Utilization_Ratio can be meaningfully decomposed through Occupation → Credit_Mix → Loan_Tier → Customer |
| Smart Narrative | **Yes** | Works well over any well-defined KPI set; no data-specific obstacle |
| Q&A | **Yes** | Column names (Annual_Income, Outstanding_Debt, Credit_Utilization_Ratio) are natural-language-friendly and should parse well |
| Anomaly Detection | **Yes, with caveats** | Meaningful for measures like Outstanding_Debt or Delay_from_due_date within the available month cycle, but Anomaly Detection in Power BI expects a continuous time series — the missing Year field limits how much genuine "anomaly over time" analysis is possible versus anomaly-across-customers analysis (which works fine) |
| Forecast | **Not meaningful** | Power BI's forecast visual requires a continuous date axis with sufficient historical depth; this dataset has only a month-name cycle with no Year, so forecasting would be statistically unfounded here |

---

## SECTION 10 — REPORT LIMITATIONS (Brutally Honest)

- **No true forecasting** — no Year field means no genuine historical depth exists for projecting forward.
- **No YoY, no true QTD/MTD/YTD** — all standard period-over-period time intelligence is blocked by the missing Year field.
- **No inventory, no product hierarchy** — this is not a retail/product dataset; there is nothing to model here.
- **No geographic analysis** — zero location fields exist anywhere in the data.
- **No seasonality analysis in the traditional sense** — seasonality requires multi-year comparison at the same calendar point; only within-cycle month comparison is possible.
- **No true loan-type analysis** — `Type_of_Loan` was dropped upstream; only loan-volume tiers are available, not loan categories (Auto/Personal/Credit-Builder, etc.).
- **`Credit_Score` is categorical, not a continuous score** — confirmed via live query (Poor/Standard/Good + Data Missing), correcting an earlier assumption in this project. It supports risk-tier classification well (and now has its own `dim_credit_score` dimension), but does not support continuous scoring, banding-by-value, or trending the way a true numeric bureau score (e.g. 300-850) would.
- **No customer lifecycle/tenure-beyond-credit-history** — no acquisition date, no churn flag, no account-opening date exists, so retention/lifetime-value analysis is not supported.
- **No transaction-level detail** — all measures are monthly aggregates/snapshots per customer, so intra-month transaction pattern analysis is not possible.
- **No explicit segment/tier field** — any customer segmentation must be manually constructed from Age, Occupation, Credit_Mix, and Loan_Tier; there's no pre-labeled "Segment" column.

---

## SECTION 11 — FINAL EXECUTIVE SUMMARY

### Top 10 KPIs
1. Total Outstanding Debt Exposure
2. Average Credit Utilization Ratio
3. % Customers in "Bad" Credit Mix
4. Average Delay from Due Date
5. % Minimum-Payment-Only Customers
6. Debt-to-Income Ratio
7. Loan Tier Distribution
8. Average Credit Inquiries
9. EMI Burden Ratio
10. Credit Health Index (composite)

### Top 10 Business Dimensions
1. `dim_credit_mix`
2. `dim_occupation`
3. `dim_payment_behaviour`
4. `dim_loan`
5. `dim_customer` (Age)
6. `dim_date` (Month/Quarter, limited)
7. `Payment_of_Min_Amount` (degenerate)
8. Constructed Age Bands
9. Constructed Income Bands
10. Constructed Composite Risk Tier (hypothetical, built from existing measures)

### Top 20 Executive Questions
See full ranked list in Section 2.

### Top Analytical Strengths
- Rich, genuinely multi-dimensional risk-signal set (utilization, delay, inquiries, mix, minimum-payment behavior) rarely all present together in a single portfolio-style dataset
- Clean star schema foundation with no snowflaking, enabling fast, reliable aggregation
- Strong support for segmentation, ranking, Pareto/ABC analysis, and Key Influencers / Decomposition Tree AI visuals

### Dataset Limitations
- No Year field (blocks true time intelligence and forecasting)
- No geography, no product hierarchy, no transaction-level detail
- `dim_loan` represents volume tiers only, not loan types
- `Credit_Score` is categorical (Poor/Standard/Good), not continuous — good for classification, not for continuous score trending

### Potential Interview Talking Points
- "I initially assumed `Credit_Score` was numeric based on how the request was framed, built the fact table around that assumption, and it silently produced all-NULL values when the cast failed. I caught it by validating against a live `GROUP BY` query rather than trusting the assumption, found it was actually a 3-category classification with ~38% nulls, and rebuilt it as a proper dimension — that's the kind of validation habit that matters in production data work."
- "I identified that Credit_Mix and Credit_Score are two related but distinct risk signals in this model, and structured both as first-class dimensions so they can be cross-analyzed rather than assuming they're redundant."
- "I distinguished between measures that are true KPIs (aggregatable, meaningful across all grains) versus ratio-based derived KPIs that need to be built carefully in DAX to avoid divide-by-zero and Simpson's-paradox-style aggregation errors (e.g., averaging a ratio-of-ratios like Debt-to-Income)."
- "I scoped time intelligence honestly — this dataset supports within-cycle month/quarter comparison, but not YoY or forecasting, and I can explain exactly why, technically (no Year column) and practically (what would be needed to add it)."

### Enterprise BI Maturity Score: **7 / 10**
**Reasoning:** Strong on data modeling fundamentals (proper star schema, clean measures, rich risk-signal breadth, now including a corrected and properly-modeled `Credit_Score` dimension) — this pulls the score above a basic/prototype level. Held back from a higher score by two remaining structural gaps that any Fortune-500 risk analytics team would flag immediately: no true calendar/Year dimension, and no incremental/production-grade load pattern (currently full `CREATE OR REPLACE TABLE` rebuilds only). This reads as a strong portfolio-quality model with clearly identified, explainable gaps — not yet a production enterprise warehouse.
