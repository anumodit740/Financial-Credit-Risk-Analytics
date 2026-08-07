# Data Dictionary

This file documents the primary datasets used in the project. Populate these tables with real field names and descriptions when you add production data.

## fact_transactions
Primary transaction-level facts. One row per transaction/report line.

Columns (example):
- transaction_id (STRING / INTEGER) — Primary key
- transaction_date (DATE / TIMESTAMP) — Date of the transaction
- customer_id (STRING / INTEGER) — FK to dim_customer
- product_id (STRING / INTEGER) — FK to dim_product
- region_id (STRING / INTEGER) — FK to dim_region
- revenue (NUMERIC) — Revenue amount for the row
- cost (NUMERIC) — Cost / COGS
- quantity (INTEGER) — Units sold
- currency (STRING) — Currency code (e.g., USD)
- source_file (STRING) — Original filename / source
- load_timestamp (TIMESTAMP) — Ingest time

## dim_date
Date dimension used for time analysis.

Columns (example):
- date_id (STRING / INTEGER) — Primary key (YYYYMMDD)
- date (DATE)
- year (INTEGER)
- quarter (STRING)
- month (INTEGER)
- month_name (STRING)
- day (INTEGER)
- is_weekend (BOOLEAN)

## dim_customer
Customer dimension for reporting.

Columns (example):
- customer_id (STRING / INTEGER) — PK
- customer_name (STRING)
- segment (STRING)
- industry (STRING)
- region_id (STRING / INTEGER)
- country (STRING)

## dim_product
Product / SKU dimension.

Columns (example):
- product_id (STRING / INTEGER) — PK
- product_name (STRING)
- category (STRING)
- sub_category (STRING)
- price (NUMERIC)

## dim_region
Geographic dimension.

Columns (example):
- region_id (STRING / INTEGER) — PK
- region_name (STRING)
- country (STRING)
- territory (STRING)

---

Notes
- These are example schemas to get you started. Adapt column names and types to match your source reports and BigQuery tables.
- Keep the `source_file` and `load_timestamp` columns in the fact table for traceability and debugging of automated ingestion flows.
- Consider adding partitioning (by transaction_date) and clustering columns in BigQuery for performance.
