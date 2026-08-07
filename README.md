# 📊 Enterprise Financial Analytics Platform

<div align="center">

![Financial Analytics](https://img.shields.io/badge/Financial%20Analytics-Cloud%20BI-blue?style=flat-square)
![Power Automate](https://img.shields.io/badge/Power%20Automate-Workflow%20Automation-purple?style=flat-square)
![Google BigQuery](https://img.shields.io/badge/Google%20BigQuery-Data%20Warehouse-red?style=flat-square)
![Power BI](https://img.shields.io/badge/Power%20BI-Business%20Intelligence-yellow?style=flat-square)

**An end-to-End Automated Financial Reporting & Business Intelligence Solution** that simulates a real-world enterprise data pipeline using Microsoft Outlook, Power Automate, Google Drive, Google BigQuery and Power BI.

[Live Demo (Power BI)](https://app.powerbi.com/groups/me/reports/feade1b7-637e-40bb-a4e0-32b5701f9470/tt01risksummary01?experience=power-bi) • [Dashboard Preview](#dashboard-preview) • [Architecture](#solution-architecture)

</div>

---

## 🚀 Project Overview

Organizations traditionally receive financial reports periodically via email from different departments, branches or business units. Manual report preparation is time-consuming, error-prone and delays decision-making.

This repository demonstrates how to fully automate a financial reporting pipeline — from ingesting emailed reports into centralized cloud storage, loading and transforming them in BigQuery, and building interactive Power BI dashboards.

### 🎯 Key Achievement
The full workflow — receiving reports in Outlook, extracting attachments via Power Automate, storing files in Google Drive, loading into BigQuery, transforming with Power Query, and visualizing in Power BI — has been automated to eliminate manual steps and enable near real-time analytics.

---

## 🏢 Business Problem

Organizations often face challenges that slow reporting and increase risk:

| Challenge | Impact |
|-----------|--------|
| Manual downloading of financial reports from emails | Time-consuming & prone to errors |
| Maintaining multiple monthly files | Difficult version control & organization |
| Repetitive data cleaning | Inconsistent data quality |
| Delayed reporting | Slow decision-making |
| Inconsistent KPI calculations | Unreliable metrics |
| Lack of centralized reporting | Siloed information |
| High manual effort | Reduced productivity |

**Solution**: Automate the reporting lifecycle and provide a scalable BI platform as a single source of truth.

---

## 🏗️ Solution Architecture

```
ENTERPRISE DATA PIPELINE

Finance Department → Email Attachments (Outlook) → Power Automate → Google Drive → BigQuery → Power Query (ETL) → Power BI (Reports)
```

Key components:
- Microsoft Outlook — email reporting source
- Microsoft Power Automate — automation flow to detect emails and save attachments
- Google Drive — centralized file storage
- Google BigQuery — data warehouse for analytics
- Power Query — ETL and data cleanup
- Power BI — dashboards and visualizations

---

## ✨ Key Features

### 📩 Automated Data Ingestion
A Power Automate flow monitors Outlook, extracts attachments (Excel/CSV/PDF) and saves them to Google Drive with timestamps and audit logs.

### ☁️ Cloud Storage Layer
Google Drive acts as the centralized repository for raw files, enabling version history and collaboration.

### 🗄️ Cloud Data Warehouse
BigQuery stores cleansed and transformed datasets for fast analytical queries.

### 🔄 Data Transformation (ETL)
Power Query cleans, deduplicates, standardizes and appends monthly datasets before loading into the star schema in BigQuery/Power BI.

Transformation steps include:
1. Remove duplicates and handle incomplete records
2. Handle missing values appropriately
3. Data type conversion and date parsing
4. Append multiple monthly datasets
5. Standardize column names and formats
6. Add derived columns (profit, margin %)
7. Build Date dimension for time-based analysis

### 📐 Data Modeling
A star schema is used (fact_transactions + date/customer/product/region dimensions) to optimize performance and simplify reporting logic.

---

## 📊 Dashboard Pages (Power BI)

- Executive Summary — executive KPI cards, trends and drill-throughs
- Financial Performance — revenue/expense trends and comparisons
- Profitability Analysis — margin and product-level profit insights
- Regional Analysis — geographic revenue and profit comparison
- Product Performance — product and category analysis
- Customer Insights — top customers and segmentation

Dashboard screenshots are available in the repository under `powerbi/screenshots/`.

---

## 📂 Repository Structure (current)

```
Financial-Credit-Risk-Analytics/

├── data/                    # Raw & sample data
├── docs/                    # Documentation and architecture notes
├── notebooks/               # Analytical notebooks
├── powerbi/                 # Power BI project and screenshots
│   ├── Financial_Dashboard_Project.pbix
│   └── screenshots/
├── sql/                     # SQL scripts (BigQuery setup & transformations)
├── financial.ipynb          # Jupyter notebook (optional)
├── .gitignore
├── LICENSE
├── README.md
└── CONTRIBUTING.md
```

Notes:
- The earlier numbered folders (01_data, 02_docs, etc.) were adjusted to match this repository's current folder names.
- If you prefer numbered folders (01_, 02_), we can rename or re-organize consistently — tell me if you'd like that.

---

## 🚀 Getting Started

### Prerequisites
- Microsoft 365 account (Outlook)
- Google Cloud account (Drive, BigQuery)
- Power BI Desktop
- Power Query (Excel or Power BI)
- Basic SQL knowledge

### Quick setup
1. Configure the Power Automate flow to save attachments from your Outlook mailbox into Google Drive.
2. Create a Google Cloud Project and enable BigQuery. Create dataset `financial_analytics` and required tables (fact_transactions, dim_date, dim_customer, dim_product, dim_region).
3. Load sample data (located in `data/` if present) to validate the pipeline.
4. Open `powerbi/Financial_Dashboard_Project.pbix` in Power BI Desktop to explore the reports and measures.

Clone the repo:

```bash
git clone https://github.com/anumodit740/Financial-Credit-Risk-Analytics.git
cd Financial-Credit-Risk-Analytics
```

---

## 📷 Dashboard Preview

Live interactive report: [Open Live Dashboard in Power BI](https://app.powerbi.com/groups/me/reports/feade1b7-637e-40bb-a4e0-32b5701f9470/tt01risksummary01?experience=power-bi)

Screenshot previews are in `powerbi/screenshots/`.

---

## 🔮 Future Enhancements

- Incremental Refresh (near real-time updates)
- Row-Level Security (RLS)
- CI/CD deployment for PBIX and SQL
- Forecasting & predictive analytics
- Automated alerting and thresholds
- Microsoft Fabric / additional connector integrations

---

## 📊 Project Statistics

| Metric | Value |
|--------|-------|
| Data Sources | 5+ |
| Dimensions | 5 |
| Fact Tables | 1 |
| DAX Measures | 12+ |
| Dashboard Pages | 6 |
| Visualizations | 30+ |

---

## 🤝 Contributing

Contributions welcome — please open a PR. For small edits, use the GitHub web editor or fork + branch + PR workflow.

---

## 📝 License

This project is licensed under the MIT License — see [LICENSE](./LICENSE).

---

## 📞 Support & Contact

- Email: anumodit740@email.com
- LinkedIn: [Anushka Modit](https://linkedin.com/in/anumodit740)
- GitHub: [@anumodit740](https://github.com/anumodit740)
- Portfolio: https://your-portfolio.com

---

<div align="center">

**If you found this project helpful, consider giving it a star!**

![Stars](https://img.shields.io/github/stars/anumodit740/Financial-Credit-Risk-Analytics?style=social)

---

**Last Updated:** August 7, 2026 | **Version:** 1.0.0

</div>
