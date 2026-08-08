# Power BI Implementation

## Report pages

### 01 — Sales Performance

Executive KPI monitoring:

- Total Sales
- Total Profit
- Profit Margin
- YoY Sales Growth
- Total Orders
- Total Customers
- Average Order Value
- Monthly Sales & Profit
- Regional Sales Contribution

### 02 — Customer Insights

- Customer segmentation
- Revenue by segment
- Customers by region
- Revenue by region
- New vs returning customer activity
- Monthly customer orders
- Top customers
- Category contribution

### 03 — Regional & Product Performance

- Sales by region
- Profit by region
- Quarterly sales/profit
- Sales by category
- Profit by category
- Profit margin by category
- Top 10 products by sales
- Bottom 10 products by profit
- Monthly sales trend

## Data model

The report follows a Star Schema approach with a transaction-level fact table and reusable dimensions for Date, Customer, Product, Geography and Shipping.

## DAX focus

The report uses measures for dynamic KPI calculations and time intelligence, including:

- `CALCULATE`
- `SUM`
- `DIVIDE`
- `DISTINCTCOUNT`
- `PREVIOUSMONTH`
- `SAMEPERIODLASTYEAR`

## Private file policy

The original `.pbix` file is intentionally not published because the underlying source data is confidential. This repository documents the implementation and provides safe portfolio artifacts instead.
