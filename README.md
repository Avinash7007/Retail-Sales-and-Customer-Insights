# Retail Sales & Customer Insights

> **End-to-end Business Intelligence project using SQL Server, Power Query, Power BI and DAX**

A production-style retail analytics solution designed to provide a single, consistent view of **sales, profitability, customer behavior, regional performance and product performance**.

---

## Executive Summary

The project transforms transaction-level retail data into an interactive Power BI reporting solution.

**Business problem:** recurring reporting was manual and stakeholders lacked a centralized view of sales performance, growth, profitability and customer behavior.

**Solution:** extract and validate data with SQL Server, prepare data with Power Query, model the solution using a Star Schema, build reusable DAX measures, and publish three focused Power BI report pages.

**Reported project outcome:** approximately **$20.40M sales**, **$2.58M profit**, **12.6% profit margin**, **46.9% YoY sales growth**, and approximately **3–4 hours/day reduction in recurring manual reporting effort**.

---

## Business Objectives

- Monitor executive sales and profit KPIs.
- Track YoY sales growth and monthly performance.
- Identify regional and category performance differences.
- Identify high-sales and low-profit products.
- Understand customer segmentation and purchasing activity.
- Support drill-down analysis from region → category → product/customer.
- Replace repetitive manual reporting with self-service BI.

---

## Key KPIs

| KPI | Project Value |
|---|---:|
| **Total Sales** | **$20.40M** |
| **Total Profit** | **$2.58M** |
| **Profit Margin** | **12.6%** |
| **YoY Sales Growth** | **46.9%** |
| **Total Orders** | **48,620** |
| **Total Customers** | **12,840** |
| **Average Order Value** | **$419.55** |
| **Average Profit / Order** | **$53.07** |
| **Revenue / Customer** | **$1,589** |

---

## Technology Stack

| Layer | Technology | Purpose |
|---|---|---|
| Data source / database | **SQL Server** | Extraction, validation and business analysis |
| Transformation | **Power Query** | Cleaning, standardization and preparation |
| Semantic model | **Power BI** | Star Schema and report model |
| Analytics | **DAX** | KPIs and time intelligence |
| Documentation | **GitHub** | Version-controlled project artifacts |

### SQL techniques

`CTEs` · `Window Functions` · `Aggregations` · `CASE` · `JOINs` · `LAG` · `GROUP BY` · `Data Validation`

### DAX focus

`CALCULATE` · `SUM` · `DIVIDE` · `DISTINCTCOUNT` · `PREVIOUSMONTH` · `SAMEPERIODLASTYEAR`

---

# Solution Architecture

```text
Confidential Transaction Data
          ↓
      SQL Server
          ↓
Extraction + Data Quality Checks
          ↓
      Power Query
          ↓
Cleaning + Type Standardization
          ↓
      Star Schema
          ↓
    DAX Semantic Layer
          ↓
     Power BI Report
          ↓
 Business Insights / Decisions
```

---

# Data Model

The reporting model follows a **Star Schema** with a transaction-level fact table and reusable dimensions.

```text
                         Dim Date
                            |
                            |
Dim Customer ---- Fact Sales ---- Dim Product
                            |
                     Dim Geography
                            |
                      Dim Shipping
```

### FactSales

Transaction-level measures and keys:

- Order ID
- Order Date Key
- Customer Key
- Product Key
- Geography Key
- Shipping Key
- Quantity
- Sales Amount
- Profit Amount
- Discount

### Dimensions

- **Dim Date** — date, year, quarter, month
- **Dim Customer** — customer, segment
- **Dim Product** — product, category, sub-category
- **Dim Geography** — region, state, city
- **Dim Shipping** — shipping mode

More detail: [`docs/data-model.md`](docs/data-model.md)

---

# Power BI Report

## 01 — Sales Performance

Executive reporting page covering:

- Sales
- Profit
- Profit Margin
- YoY Growth
- Orders
- Customers
- AOV
- Monthly Sales & Profit
- Regional Sales Contribution

## 02 — Customer Insights

Customer behavior and contribution analysis covering:

- Customer segmentation
- Revenue by segment
- Customers by region
- Revenue by region
- New vs Returning Customer Activity
- Monthly customer orders
- Top customers
- Category contribution

## 03 — Regional & Product Performance

Detailed performance analysis covering:

- Sales by region
- Profit by region
- Quarterly sales/profit
- Sales by category
- Profit by category
- Category profit margin
- Top 10 products by sales
- Bottom 10 products by profit
- Monthly sales trend

---

# Regional Performance

The approved project-level regional sales distribution is:

| Region | Sales | Contribution |
|---|---:|---:|
| **West** | **$5.95M** | **29.2%** |
| **East** | **$5.60M** | **27.4%** |
| **Central** | **$5.06M** | **24.8%** |
| **South** | **$3.79M** | **18.6%** |
| **Total** | **$20.40M** | **100%** |

Regional profit is approximately **$2.58M** across the same four markets.

---

# Category Performance

| Category | Sales | Profit |
|---|---:|---:|
| **Technology** | **$8.96M** | **$1.38M** |
| **Office Supplies** | **$7.25M** | **$0.73M** |
| **Furniture** | **$4.19M** | **$0.47M** |
| **Total** | **$20.40M** | **$2.58M** |

Technology is the largest revenue and profit contributor in the portfolio dashboard.

---

# Time Intelligence

The model uses a dedicated Date dimension for time-based analysis.

### YoY Sales Growth

Current-year sales are approximately **$20.40M** versus approximately **$13.89M** for the comparison year, producing **46.9% YoY growth**.

### MoM Analysis

Previous-month comparisons use `PREVIOUSMONTH`-based time intelligence.

### YoY Analysis

Previous-year comparisons use `SAMEPERIODLASTYEAR`-based time intelligence.

---

# Business Insights

### Sales

- West is the largest regional revenue contributor at approximately **29.2%**.
- Technology is the largest category by revenue.
- Sales increased by **46.9% YoY** in the approved project output.

### Profitability

- Profitability differs materially by category and product.
- High sales volume does not automatically imply high profit.
- Product-level analysis highlights low-profit and negative-profit products for investigation.

### Customers

- Consumer customers contribute the largest share of revenue.
- Customer activity can be analyzed by segment, region, order frequency and new/returning behavior.
- High-value customers can be ranked using sales contribution.

### Regional / Product Performance

- Regional differences become visible immediately instead of being hidden inside an aggregate sales figure.
- Product-level rankings help stakeholders focus on revenue leaders and profitability risks.

---

# Reporting Impact

Before the dashboard, recurring reporting required manual data pulls and analysis.

The Power BI solution centralized the KPIs and enabled business users to filter and drill into the data independently.

**Reported impact:** approximately **3–4 hours/day** of recurring manual reporting effort saved.

---

# Data Validation

Validation was designed to reconcile the reporting layer across multiple levels:

- Row counts
- Distinct orders/customers/products
- Duplicate checks
- NULL checks
- Invalid numeric values
- Date consistency
- Sales total
- Profit total
- Profit margin
- AOV
- Monthly reconciliation
- Regional reconciliation
- Category reconciliation

See [`sql/data-validation.sql`](sql/data-validation.sql) and [`docs/validation.md`](docs/validation.md).

---

# SQL Layer

The repository contains four SQL stages:

| Script | Purpose |
|---|---|
| [`data-extraction.sql`](sql/data-extraction.sql) | Source inspection and transaction extraction |
| [`data-cleaning.sql`](sql/data-cleaning.sql) | Data-quality checks and cleaned analytical view |
| [`data-validation.sql`](sql/data-validation.sql) | KPI and data-quality reconciliation |
| [`business-analysis.sql`](sql/business-analysis.sql) | Sales, customer, product, category and regional analysis |

The scripts are written for **SQL Server / T-SQL**.

---

# Repository Structure

```text
Retail-Sales-and-Customer-Insights/
│
├── README.md
├── .gitignore
│
├── dashboards/
│   └── README.md
│
├── dataset/
│   └── README.md
│
├── docs/
│   ├── data-model.md
│   └── validation.md
│
├── powerbi/
│   └── README.md
│
└── sql/
    ├── data-extraction.sql
    ├── data-cleaning.sql
    ├── data-validation.sql
    └── business-analysis.sql
```

---

# Data Privacy & Public Repository Policy

The underlying transactional data and Power BI `.pbix` file are **not publicly uploaded** because the source data is confidential and cannot be redistributed.

This is intentional. The public repository contains safe portfolio artifacts:

- SQL analytical scripts
- Data-model documentation
- Validation methodology
- Dashboard documentation
- Approved project-level metrics

No confidential customer-level records, credentials, connection strings or private source files should be committed to this repository.

See [`dataset/README.md`](dataset/README.md) for the data policy.

---

# Portfolio / Interview Highlights

This project demonstrates practical experience with:

**SQL Server · T-SQL · Power BI · DAX · Power Query · Star Schema · Data Validation · KPI Reporting · Time Intelligence · Customer Analytics · Sales Analytics · Profitability Analysis · Regional Analysis · Product Analytics · Business Intelligence**

---

# Contact

**Avinash Dubey**  
Data Analyst | Power BI | SQL | DAX

- Email: `dubeyavinash157@gmail.com`
- LinkedIn: `https://www.linkedin.com/in/avinash7007/`
- Portfolio: `https://avinash7007.github.io/avinash-portfolio/`

---

## Repository Status

**Portfolio-ready documentation:** Yes  
**Confidential source data:** Intentionally excluded  
**Private PBIX:** Intentionally excluded  
**SQL documentation:** Included  
**Data model documentation:** Included  
**Validation documentation:** Included
