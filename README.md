# 📊 Retail Sales & Customer Insights

An end-to-end **Retail Sales & Customer Insights** analytics project focused on analyzing transactional retail data to understand **sales performance, profitability, customer behavior, regional performance, and product trends**.

The project combines **SQL Server (T-SQL), Power Query, Power BI, and DAX** to transform raw transactional data into interactive business intelligence dashboards.

The solution is designed to support **KPI monitoring, performance analysis, customer insights, and data-driven decision-making**.

---

## 📌 Problem Statement

Retail businesses often have large volumes of transactional data but lack a centralized and interactive way to monitor:

- Sales performance
- Profitability trends
- Regional performance
- Product and category performance
- Customer purchasing behavior
- New vs. repeat customer activity
- Discount impact on profitability

Manual reporting can also make it difficult for business users to access updated information quickly.

This project addresses these challenges by building an end-to-end analytics solution that transforms raw retail transaction data into actionable insights through SQL analysis and Power BI dashboards.

---

## 🎯 Project Objectives

- Analyze retail sales and profitability trends
- Monitor key business KPIs
- Compare current-year and previous-year performance
- Analyze customer purchasing behavior
- Identify high-value and repeat customers
- Compare regional and category-level performance
- Analyze the impact of discounts on profitability
- Build interactive Power BI dashboards for business users
- Reduce dependency on manual reporting

---

## 📦 Dataset Overview

The dataset contains **millions of transactional-level retail records** covering:

- Order and delivery timelines
- Customer information
- Customer segments
- Geographic information
- Product categories
- Product sub-categories
- Sales
- Profit
- Discounts
- Quantity
- Shipping modes
- Order fulfillment information

The transactional structure allows analysis at multiple levels:

**Transaction → Customer → Product → Category → Region → Time**

---

## 🎯 Key KPIs Tracked

| KPI | Description |
|---|---|
| **Total Sales** | Total revenue generated from retail transactions |
| **Total Profit** | Total profit generated across transactions |
| **Profit Margin (%)** | Profit as a percentage of sales |
| **Average Order Value (AOV)** | Average sales value generated per order |
| **Running Total Sales** | Cumulative sales over time |
| **Orders per Customer** | Average number of orders placed per customer |
| **YoY Sales Growth (%)** | Sales growth compared with the previous year |
| **Average Profit per Order** | Average profit generated per order |

---

## 📈 Project-Level Performance

The analysis covered **$20M+ in retail sales data** and identified a **46.9% YoY sales growth trend**.

The Power BI solution also helped reduce recurring manual reporting effort by approximately **3–4 hours per day** by providing business users with centralized and interactive reporting.

---

## 🛠 Tools & Technologies

### SQL Server / T-SQL

Used for:

- Data extraction
- Data filtering
- Joins
- Aggregations
- CTEs
- Window functions
- Business logic
- Data validation
- Pre-aggregation and transformation

### Power Query

Used for:

- Data cleaning
- Data type standardization
- Missing-value handling
- Data transformation
- Data preparation
- Source integration

### Power BI

Used for:

- Data modeling
- Interactive dashboards
- KPI reporting
- Drill-down analysis
- Slicers and filters
- Business reporting

### DAX

Used for:

- KPI calculations
- Time-intelligence analysis
- YoY calculations
- MoM calculations
- Running totals
- Dynamic business metrics

Key DAX functions included:

`CALCULATE`, `SUM`, `DIVIDE`, `DISTINCTCOUNT`, `PREVIOUSMONTH`, `SAMEPERIODLASTYEAR`

---

# 🏗️ Data Preparation & Modeling

The project follows a structured analytics workflow:

```text
Raw Transaction Data
        ↓
SQL Server
        ↓
Data Extraction & Transformation
        ↓
Power Query
        ↓
Data Cleaning & Validation
        ↓
Star Schema Data Model
        ↓
DAX Measures
        ↓
Power BI Dashboards
        ↓
Business Insights
```

---

## ⭐ Data Model

A **Star Schema** was used to create a clean and scalable Power BI data model.

### Fact Table

The central fact table contains transactional information such as:

- Order ID
- Customer ID
- Product ID
- Order Date
- Quantity
- Sales
- Profit
- Discount
- Shipping information

### Dimension Tables

Supporting dimension tables include:

- **Dim Date**
- **Dim Customer**
- **Dim Product**
- **Dim Category**
- **Dim Geography**
- **Dim Shipping**

This structure helps maintain clean relationships and improves the usability and performance of DAX calculations.

---

# 📊 Dashboard Analysis

## 🔹 1. Sales & Profit Analysis

The Sales & Profit dashboard provides an executive-level view of business performance.

Key analysis includes:

- Total Sales
- Total Profit
- Profit Margin
- Average Order Value
- YoY Sales Growth
- Monthly sales trends
- Running total sales
- Regional performance
- Category performance
- Segment performance

### Key Project Metric

**$20M+ Total Sales**

The dashboard also identified a:

**46.9% YoY Sales Growth Trend**

---

## 🔹 2. Customer Insights Analysis

The Customer Insights dashboard focuses on understanding customer purchasing behavior.

Analysis includes:

- Customer segmentation
- Customer sales contribution
- Order frequency
- New vs. repeat customers
- High-value customers
- Customer revenue by region
- Customer revenue by category
- Orders per customer

This analysis helps identify customer groups that contribute significantly to revenue and provides visibility into purchasing behavior.

---

## 🔹 3. Regional & Product Performance

The regional and product analysis focuses on identifying performance differences across:

- Regions
- Categories
- Sub-categories
- Products
- Customer segments

This enables business users to identify:

- Strong-performing regions
- Underperforming regions
- High-revenue categories
- Low-profit products
- High-value customer segments

---

# 📈 Time Intelligence Analysis

Time-based analysis was implemented using a dedicated Date dimension.

### Month-over-Month Analysis

`PREVIOUSMONTH` was used to compare current-period performance with the previous month.

### Year-over-Year Analysis

`SAMEPERIODLASTYEAR` was used to compare current-year sales against the corresponding previous-year period.

This enabled identification of the project's:

**46.9% YoY Sales Growth Trend**

---

# 💡 Key Business Insights

## 🛍️ Sales Insights

- Sales performance varied across regions and product categories.
- Time-based analysis highlighted changes in sales performance across reporting periods.
- YoY analysis identified a **46.9% sales growth trend**.
- Regional and category-level analysis helped identify areas of stronger and weaker performance.

## 💰 Profitability Insights

- Profitability varied across product categories and customer segments.
- Discount levels had an impact on profitability and margins.
- High sales volume did not always translate into proportionally high profit.
- Product-level analysis helped identify potential profitability risks.

## 👥 Customer Insights

- Customer behavior varied across different segments.
- Repeat customers contributed significantly to overall sales.
- High-value customers demonstrated stronger purchasing contribution.
- Customer segmentation enabled more focused analysis of purchasing behavior.

## 🌎 Regional Insights

- Sales performance differed across regions.
- Regional analysis helped identify high-performing and underperforming markets.
- Business users can drill down from regional performance into categories, products, and customers.

---

# ⚡ Reporting Improvement

Before the dashboard implementation, recurring reporting required manual data pulls and analysis.

The Power BI solution centralized key KPIs and provided interactive self-service reporting.

### Result

Approximately:

**3–4 hours of manual reporting effort saved per day**

Business users could independently access updated KPIs and drill down into:

```text
Region
   ↓
Category
   ↓
Product
   ↓
Customer Segment
```

without depending on separate manual reports.

---

# 🔍 Data Validation

Dashboard outputs were validated against the source data to ensure accuracy.

Validation included:

- Sales total reconciliation
- Profit total reconciliation
- Record-count checks
- Duplicate checks
- Missing-value checks
- Category-level validation
- Region-level validation
- Customer-level validation
- KPI reconciliation between SQL and Power BI

This ensured that dashboard metrics remained consistent with the underlying transactional data.

---

# 📸 Dashboard Preview

### Executive Sales & Profit Dashboard

![Retail Sales & Customer Insights Dashboard](dashboards/sales-performance.png)

### Customer Insights Dashboard

![Customer Insights Dashboard](dashboards/customer-insights.png)

### Regional & Product Performance Dashboard

![Regional & Product Performance Dashboard](dashboards/regional-product-performance.png)

---

# 📂 Repository Structure

```text
retail-sales-customer-insights/
│
├── retail-sales-customer-insights.pbix
│
├── dataset/
│   └── retail_transactions.csv
│
├── dashboards/
│   ├── sales-performance.png
│   ├── customer-insights.png
│   └── regional-product-performance.png
│
├── sql/
│   ├── data-extraction.sql
│   ├── data-validation.sql
│   └── business-analysis.sql
│
└── README.md
```

---

# 🚀 Key Skills Demonstrated

- SQL Server
- T-SQL
- Advanced SQL
- CTEs
- Window Functions
- Data Extraction
- Data Cleaning
- Data Transformation
- Data Validation
- Power Query
- Power BI
- DAX
- Time Intelligence
- Star Schema
- Data Modeling
- KPI Development
- Business Intelligence
- Customer Segmentation
- Sales Analysis
- Profitability Analysis
- Regional Analysis
- Dashboard Development

---

# 📌 Project Highlights

| Area | Outcome |
|---|---|
| **Sales Analysis** | Analyzed **$20M+** retail sales data |
| **Growth Analysis** | Identified **46.9% YoY sales growth trend** |
| **Data Volume** | Worked with **millions of transaction records** |
| **Reporting** | Reduced manual reporting effort by **3–4 hours/day** |
| **Data Modeling** | Implemented Star Schema |
| **Data Preparation** | SQL + Power Query |
| **Analytics** | DAX + Power BI |
| **Customer Analysis** | Segmentation, repeat-customer and high-value customer analysis |
| **Business Analysis** | Regional, category and product performance |

---


# 🔐 Data Privacy & Project File Availability

The **Power BI `.pbix` file and underlying transactional dataset are not included in this public repository** due to data privacy and confidentiality considerations.

The project contains business-related transactional data, and sharing the complete Power BI file or raw dataset publicly could expose sensitive business information.

Therefore:

- The original **`.pbix` file is not publicly uploaded**.
- The raw transactional dataset is **not publicly shared**.
- Sensitive source data has not been uploaded to any public repository.
- The repository contains the project documentation, analytical approach, dashboard previews, and technical implementation details that can be safely shared.

The dashboards and project description are provided for **portfolio and demonstration purposes**, while protecting the confidentiality of the underlying business data.

> **Note:** The absence of the `.pbix` file is intentional and is due to data privacy/confidentiality requirements, not because the Power BI development file is unavailable.

---

# 📬 Contact

If you'd like to discuss this project or collaborate:

📧 **Email:** dubeyavinash157@gmail.com

💼 **LinkedIn:** https://www.linkedin.com/in/avinash7007/

🌐 **Portfolio:** https://avinash7007.github.io/avinash-portfolio/
