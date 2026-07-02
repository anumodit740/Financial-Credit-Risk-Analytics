# 📊 Enterprise Financial Analytics Platform

<div align="center">

![Financial Analytics](https://img.shields.io/badge/Financial%20Analytics-Cloud%20BI-blue?style=flat-square)
![Power Automate](https://img.shields.io/badge/Power%20Automate-Workflow%20Automation-purple?style=flat-square)
![Google BigQuery](https://img.shields.io/badge/Google%20BigQuery-Data%20Warehouse-red?style=flat-square)
![Power BI](https://img.shields.io/badge/Power%20BI-Business%20Intelligence-yellow?style=flat-square)

**An end-to-End Automated Financial Reporting & Business Intelligence Solution** that simulates a real-world enterprise data pipeline using **Microsoft Outlook, Power Automate, Google Drive, Google BigQuery, and Power BI**

[Live Demo](#-dashboard-preview) • [Architecture](#-solution-architecture) • [Features](#-key-features) • [Getting Started](#-getting-started)

</div>

---

## 🚀 Project Overview

Traditional organizations receive financial reports periodically through emails from different departments, branches, or business units. Preparing reports manually is **time-consuming, error-prone, and inefficient**.

This project replicates **how modern enterprises automate their financial reporting pipeline**, eliminating manual data entry and enabling real-time analytics.

### 🎯 Key Achievement
Instead of manually downloading files and importing them into Power BI, the **entire workflow has been automated**—from receiving financial reports via Outlook to generating interactive executive dashboards.

The solution integrates **Microsoft Outlook, Power Automate, Google Drive, Google BigQuery, and Power BI**, demonstrating an **enterprise-grade cloud analytics architecture**.

---

## 🏢 Business Problem

Organizations often face critical challenges:

| Challenge | Impact |
|-----------|--------|
| 📥 Manual downloading of financial reports from emails | Time-consuming & prone to errors |
| 📁 Maintaining multiple monthly files | Difficult version control & organization |
| 🧹 Repetitive data cleaning | Inconsistent data quality |
| ⏳ Delayed reporting | Slow decision-making |
| 📊 Inconsistent KPI calculations | Unreliable metrics |
| 🔗 Lack of centralized reporting | Siloed information |
| 👥 High manual effort | Reduced productivity |

**Solution**: Automate the complete reporting lifecycle while creating a scalable Business Intelligence platform for financial analytics.

---

## 🎯 Solution Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                    ENTERPRISE DATA PIPELINE                          │
└─────────────────────────────────────────────────────────────────────┘

Finance Department
        │
        ▼
    📧 Monthly Financial Reports (Email Attachments)
        │
        ▼
┌─────────────────────────────────────────────────────────────────┐
│           MICROSOFT OUTLOOK                                      │
│  ✓ Monitor Inbox  ✓ Detect Email  ✓ Parse Attachments         │
└──────────────────────────────────────────────────────────────���──┘
        │
        ▼
┌─────────────────────────────────────────────────────────────────┐
│        MICROSOFT POWER AUTOMATE (Cloud Workflow)                 │
│  ✓ Email Detection ✓ File Extraction ✓ Automated Trigger       │
└─────────────────────────────────────────────────────────────────┘
        │
        ▼
┌─────────────────────────────────────────────────────────────────┐
│           GOOGLE DRIVE (Cloud Storage)                           │
│  ✓ Centralized Repository ✓ Version Management ✓ Access Control│
└─────────────────────────────────────────────────────────────────┘
        │
        ▼
┌─────────────────────────────────────────────────────────────────┐
│        GOOGLE BIGQUERY (Data Warehouse)                          │
│  ✓ Data Loading ✓ Validation ✓ Transformation ✓ Schema Mgmt    │
└─────────────────────────────────────────────────────────────────┘
        │
        ▼
┌─────────────────────────────────────────────────────────────────┐
│     POWER QUERY (ETL & Data Transformation)                      │
│  ✓ Cleaning ✓ Deduplication ✓ Type Conversion ✓ Standardization│
└─────────────────────────────────────────────────────────────────┘
        │
        ▼
┌─────────────────────────────────────────────────────────────────┐
│       POWER BI (Analytics & Visualization)                       │
│  ✓ Star Schema ✓ DAX Measures ✓ Interactive Reports            │
└─────────────────────────────────────────────────────────────────┘
        │
        ▼
    📊 Executive Dashboard | KPI Cards | Trend Analysis
```

---

## ✨ Key Features

### 📩 **Automated Data Ingestion**

Developed an automated workflow using **Microsoft Power Automate** that continuously monitors Microsoft Outlook for incoming financial reports.

**Workflow Actions:**
- ✓ Detects incoming email automatically
- ✓ Extracts report attachments (Excel, CSV, PDF)
- ✓ Saves files to Google Drive with timestamp
- ✓ Eliminates manual downloading
- ✓ Enables scalable, repeatable workflow
- ✓ Logs all activities for audit trail

---

### ☁️ **Cloud Storage Layer**

Integrated **Google Drive** as the centralized cloud repository for financial datasets.

**Benefits:**
- 🔐 Centralized storage with access controls
- 📝 Version management & change history
- 👥 Easy collaboration across teams
- 📈 Scalable file management
- 🔗 Seamless integration with cloud analytics tools
- ⚡ High availability & redundancy

---

### 🗄️ **Cloud Data Warehouse**

Used **Google BigQuery** as the enterprise-grade cloud data warehouse to process and manage financial data at scale.

**Operations:**
- 📥 Loading financial datasets (CSV, Excel, JSON)
- ✅ Data validation & quality checks
- 📐 Schema consistency verification
- 🧹 Data cleansing & anomaly detection
- 🔄 Transformation & aggregation
- 💾 Centralized storage for analytics

---

### 🔄 **Data Transformation (ETL)**

Performed comprehensive ETL using **Power Query** to ensure data quality and consistency.

**Transformation Steps:**
1. Remove duplicates & handle incomplete records
2. Handle missing values with appropriate strategies
3. Data type conversion (text → number, date formatting)
4. Append multiple monthly datasets
5. Standardize column names & formats
6. Create derived columns (profit, margin %)
7. Build Date dimension for time-based analysis

---

### 📐 **Data Modeling**

Designed an optimized **Star Schema** for efficient analytical queries:

```
                          ⭐ Fact Table
                    Financial Transactions
                              │
                ┌─────────────┼─────────────┐
                ▼             ▼             ▼
           Date Dim      Customer Dim   Product Dim
         • Date_ID       • Cust_ID      • Prod_ID
         • Month         • Name         • Category
         • Quarter       • Segment      • Sub_Category
         • Year          • Region       • Price
                
                ▼
           Region Dim     Category Dim
         • Region_ID    • Cat_ID
         • Country      • Name
         • Territory    • Type
```

**Benefits:**
- ⚡ Optimized query performance
- 🔍 Simplified reporting logic
- 📊 Support for scalable analytical queries
- 🎯 Reduced data redundancy

---

### 📊 **Business Intelligence Layer**

Developed an interactive **Power BI solution** with multiple analytical perspectives:

- 📌 **Executive Dashboard** - High-level KPI overview
- 💰 **Financial Performance** - Revenue, expenses, profitability trends
- 📈 **Profitability Analysis** - Margin analysis & cost breakdown
- 🌍 **Regional Analysis** - Geographic performance comparison
- 🏷️ **Product Performance** - Category-wise metrics
- 👥 **Customer Insights** - Segmentation & contribution analysis

---

### 📈 **KPI Development**

Created **reusable DAX measures** for consistent business metrics:

| Metric | Formula Type | Use Case |
|--------|-------------|----------|
| **Total Revenue** | SUM | Overall business performance |
| **Total Expenses** | SUM | Cost tracking |
| **Net Profit** | Revenue - Expenses | Bottom-line profitability |
| **Gross Profit** | Revenue - COGS | Product profitability |
| **Gross Margin %** | (Gross Profit / Revenue) × 100 | Product efficiency |
| **Profit Margin %** | (Net Profit / Revenue) × 100 | Overall efficiency |
| **Revenue Growth %** | ((Current - Previous) / Previous) × 100 | Growth analysis |
| **YoY Growth** | Year-over-Year comparison | Annual trends |
| **Budget Variance** | Actual vs. Budget | Performance tracking |
| **Average Order Value** | Total Revenue / Order Count | Customer value |
| **Running Total** | Cumulative sum | Trend visualization |
| **YTD Revenue** | Year-to-Date aggregation | Period comparison |

---

## 📊 Dashboard Pages

### 📌 **Executive Summary**
Provides an overview of overall business performance using:
- Executive KPI cards (Revenue, Profit, Growth %)
- Financial trends over time
- Key metrics at a glance
- Drill-through capabilities

![Executive Dashboard Preview](./04_images/dashboards/01_executive_dashboard.png)

---

### 📌 **Financial Performance**
In-depth analysis of financial metrics:
- Revenue trends by month
- Expense categorization
- Profit analysis
- Monthly comparison charts
- Growth trends visualization

![Financial Performance](./04_images/dashboards/02_financial_performance.png)

---

### 📌 **Profitability Analysis**
Detailed profitability insights:
- Gross Profit vs. Net Profit
- Margin analysis & trends
- Expense distribution
- Product profitability breakdown
- Contribution to overall profit

![Profitability Analysis](./04_images/dashboards/03_profitability_analysis.png)

---

### 📌 **Regional Analysis**
Geographic performance metrics:
- Region-wise Revenue distribution
- Region-wise Profit comparison
- Geographic market contribution
- Regional growth rates
- Territory performance cards

![Regional Analysis](./04_images/dashboards/04_regional_analysis.png)

---

### 📌 **Product Performance**
Product-level insights:
- Top performing products
- Category-wise analysis
- Revenue distribution by product
- Profit contribution analysis
- Product trend analysis

![Product Performance](./04_images/dashboards/05_product_performance.png)

---

### 📌 **Customer Insights**
Customer-focused analytics:
- Customer contribution analysis
- Customer segmentation
- Top customers ranking
- Customer lifetime value
- Repeat purchase analysis

![Customer Insights](./04_images/dashboards/06_customer_insights.png)

---

## 💼 Business Value

The automated analytics platform delivers:

| Benefit | Impact |
|---------|--------|
| 🤖 **Automated Processes** | Eliminates 80-90% of manual file handling |
| ⏱️ **Faster Reporting** | Reduces report preparation from days to minutes |
| 📊 **Centralized Data** | Single source of truth for all financial data |
| 📈 **Consistency** | Standardized KPI calculations across organization |
| 🎯 **Better Decisions** | Real-time insights for executive decision-making |
| 💡 **Scalability** | Easily add new data sources & metrics |
| 📉 **Cost Reduction** | Reduced manual effort & operational overhead |
| ✅ **Compliance** | Audit trail & data governance |

---

## 🛠️ Technology Stack

| Category | Technology | Purpose |
|----------|-----------|---------|
| **Email Service** | Microsoft Outlook | Email monitoring & document delivery |
| **Automation** | Microsoft Power Automate | Workflow orchestration & task automation |
| **Cloud Storage** | Google Drive | Centralized file repository |
| **Data Warehouse** | Google BigQuery | Scalable analytics database |
| **ETL** | Power Query | Data transformation & cleaning |
| **Data Modeling** | Star Schema | Dimensional data design |
| **Analytics** | DAX | Measure calculations & logic |
| **BI Platform** | Power BI | Dashboards & visualizations |
| **Version Control** | Git & GitHub | Code & document management |

---

## 🧠 Skills Demonstrated

```
📊 Data & Analytics          🔧 Technical                🎯 Business
├── Financial Analytics      ├── Power Automate          ├── Business Intelligence
├── Data Modeling            ├── Microsoft Outlook       ├── Business Storytelling
├── Data Cleaning            ├── Google Drive            ├── KPI Development
├── ETL Pipeline Dev         ├── Google BigQuery         ├── Executive Reporting
├── Cloud Data Eng           ├── Power Query             ├── Workflow Design
├── DAX                      ├── SQL                     └── Analytics Strategy
└── Star Schema Design       └── Git & GitHub
```

---

## 📂 Repository Structure

```
Financial-Credit-Risk-Analytics/
│
├── 📁 01_data/
│   ├── monthly_reports/          # Raw financial data files
│   │   ├── 2024_Jan_Report.xlsx
│   │   ├── 2024_Feb_Report.xlsx
│   │   └── ...
│   ├── sample_datasets/          # Sample data for testing
│   │   ├── transactions.csv
│   │   ├── customers.csv
│   │   └── products.csv
│   └── README.md
│
├── 📁 02_docs/
│   ├── architecture/             # Technical documentation
│   │   ├── data_pipeline.md
│   │   ├── schema_design.md
│   │   └── architecture_diagram.png
│   ├── workflows/                # Power Automate flow details
│   │   ├── email_automation_flow.md
│   │   └── flow_screenshots/
│   ├── bigquery/                 # BigQuery setup docs
│   │   ├── dataset_setup.md
│   │   └── initial_load.md
│   └── README.md
│
├── 📁 03_powerbi/
│   ├── Financial_Dashboard.pbix  # Main Power BI file
│   ├── themes/                   # Custom Power BI themes
│   │   └── corporate_theme.json
│   ├── reports/                  # Individual report exports
│   │   ├── Executive_Summary.pbix
│   │   ├── Financial_Performance.pbix
│   │   └── ...
│   └── README.md
│
├── 📁 04_images/
│   ├── dashboards/               # Dashboard screenshots
│   │   ├── 01_executive_dashboard.png
│   │   ├── 02_financial_performance.png
│   │   ├── 03_profitability_analysis.png
│   │   ├── 04_regional_analysis.png
│   │   ├── 05_product_performance.png
│   │   └── 06_customer_insights.png
│   ├── architecture/             # Architecture diagrams
│   │   ├── data_pipeline.png
│   │   ├── star_schema.png
│   │   └── system_integration.png
│   ├── workflows/                # Power Automate workflow visuals
│   │   ├── email_automation.png
│   │   └── flow_logic.png
│   └── README.md
│
├── 📁 05_sql/
│   ├── bigquery_setup.sql        # BigQuery table creation
│   ├── data_validation.sql       # Data quality checks
│   ├── transformations.sql       # Data transformation queries
│   ├── dax_measures.sql          # DAX measure definitions
│   └── README.md
│
├── .gitignore                    # Git ignore file
├── LICENSE                       # Project license (MIT)
├── README.md                     # Main documentation (this file)
└── CONTRIBUTING.md              # Contribution guidelines

```

---

## 🚀 Getting Started

### Prerequisites
- ✅ Microsoft Office 365 account (Outlook)
- ✅ Google Cloud account (Drive, BigQuery)
- ✅ Power BI Desktop
- ✅ Power Query (Excel or Power BI)
- ✅ Basic SQL knowledge

### Installation Steps

#### 1️⃣ **Setup Power Automate Workflow**
```
1. Log in to Power Automate (https://flow.microsoft.com)
2. Create new automated cloud flow
3. Set trigger: "When a new email arrives in Outlook"
4. Add action: "Get attachment(s)"
5. Add action: "Create file in Google Drive"
6. Test the flow
```

#### 2️⃣ **Setup Google BigQuery**
```
1. Create Google Cloud Project
2. Enable BigQuery API
3. Create dataset: "financial_analytics"
4. Create tables:
   - fact_transactions
   - dim_date
   - dim_customer
   - dim_product
   - dim_region
5. Load sample data
```

#### 3️⃣ **Create Power BI Dashboard**
```
1. Open Power BI Desktop
2. Connect to Google BigQuery
3. Import dimension & fact tables
4. Create Star Schema relationships
5. Build visualizations
6. Create measures (DAX)
7. Publish to Power BI Service
```

#### 4️⃣ **Load Sample Data**
```
git clone https://github.com/anumodit740/Financial-Credit-Risk-Analytics.git
cd Financial-Credit-Risk-Analytics
# Follow the setup guide in 02_docs/
```

---

## 📷 Dashboard Preview

### Sample Dashboard Images

```
📊 Executive Dashboard
├── KPI Cards (Revenue, Profit, Growth %)
├── Trend Line Chart (Monthly Revenue)
├── Revenue vs Expenses (Combo Chart)
└── Key Metrics Overview

💰 Financial Performance
├── Revenue by Month (Column Chart)
├── Expense Breakdown (Pie Chart)
├── Profit Trend (Line Chart)
└── YoY Growth Rate

📈 Profitability Analysis
├── Gross vs Net Profit (Area Chart)
├── Margin % Trend (Line Chart)
├── Top Expense Categories (Bar Chart)
└── Profit by Product (Scatter Chart)

🌍 Regional Analysis
├── Revenue by Region (Map Visual)
├── Regional Profit Comparison (Bar Chart)
├── Market Share (Pie Chart)
└── Territory Performance Cards

🏷️ Product Performance
├── Top 10 Products (Bar Chart)
├── Category Performance (Clustered Chart)
├── Revenue Distribution (Donut Chart)
└── Product Trend Analysis (Line Chart)

👥 Customer Insights
├── Top 20 Customers (Table)
├── Customer Segmentation (Scatter)
├── Customer Lifetime Value (Bar Chart)
└── Repeat Purchase Rate (KPI Card)
```

**👉 [See Live Dashboard Screenshots in `04_images/dashboards/`](./04_images/dashboards/)**

---

## 🔮 Future Enhancements

- [ ] **Incremental Refresh** - Real-time data updates
- [ ] **Row-Level Security (RLS)** - User-based data filtering
- [ ] **Real-Time Dashboard Refresh** - Live KPI updates
- [ ] **Budget vs Actual Analysis** - Performance tracking
- [ ] **Forecasting Models** - Predictive analytics
- [ ] **CI/CD Deployment** - Automated deployments
- [ ] **Microsoft Fabric Integration** - Advanced analytics
- [ ] **Automated Alerting** - Threshold-based notifications
- [ ] **Predictive Analytics** - ML-based insights
- [ ] **Mobile Dashboard** - Mobile Power BI app
- [ ] **Advanced Data Quality** - Automated validation rules
- [ ] **Custom Connectors** - Additional data sources

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
| Time to Setup | 4-6 hours |
| Automation ROI | 80-90% time savings |

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please see [CONTRIBUTING.md](./CONTRIBUTING.md) for more details.

---

## 📝 License

This project is licensed under the **MIT License** - see [LICENSE](./LICENSE) file for details.

---

## 📞 Support & Contact

- 📧 Email: anumodit740@email.com
- 💼 LinkedIn: [Anushka Modit](https://linkedin.com/in/anumodit740)
- 🐙 GitHub: [@anumodit740](https://github.com/anumodit740)
- 🌐 Portfolio: [Your Portfolio](https://your-portfolio.com)

---

## 📚 Resources

### Documentation
- [Power Automate Documentation](https://docs.microsoft.com/en-us/power-automate/)
- [Google BigQuery Guide](https://cloud.google.com/bigquery/docs)
- [Power BI Learning](https://docs.microsoft.com/en-us/power-bi/)
- [DAX Function Reference](https://dax.guide/)

### Tutorials
- [Building ETL Pipelines](https://www.youtube.com/results?search_query=etl+pipeline+tutorial)
- [Power BI Dashboard Design](https://www.microsoft.com/en-us/learning/course.aspx?cID=55991)
- [BigQuery Best Practices](https://cloud.google.com/bigquery/docs/best-practices)

---

<div align="center">

### ⭐ If you found this project helpful, consider giving it a star! ⭐

**Show your support by starring this repository!**

![Stars](https://img.shields.io/github/stars/anumodit740/Financial-Credit-Risk-Analytics?style=social)
![Forks](https://img.shields.io/github/forks/anumodit740/Financial-Credit-Risk-Analytics?style=social)

---

**Last Updated:** July 2, 2026 | **Version:** 1.0.0

</div>
