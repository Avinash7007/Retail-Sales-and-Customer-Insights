/*
    Retail Sales & Customer Insights
    SQL Server / T-SQL
    File: business-analysis.sql

    Purpose:
    - Produce business-ready analysis for the Power BI dashboards.
    - Cover sales, profitability, customers, products and regional performance.
*/

USE RetailSalesDB;
GO

/* ================================================================
   1. Executive KPI Summary
   ================================================================ */
SELECT
    SUM(Sales) AS TotalSales,
    SUM(Profit) AS TotalProfit,
    SUM(Profit) * 1.0 / NULLIF(SUM(Sales), 0) AS ProfitMargin,
    COUNT(DISTINCT OrderID) AS TotalOrders,
    COUNT(DISTINCT CustomerID) AS TotalCustomers,
    SUM(Sales) * 1.0 / NULLIF(COUNT(DISTINCT OrderID), 0) AS AverageOrderValue,
    SUM(Profit) * 1.0 / NULLIF(COUNT(DISTINCT OrderID), 0) AS AverageProfitPerOrder
FROM dbo.vw_RetailTransactions_Clean;
GO

/* ================================================================
   2. Monthly Sales & Profit Trend
   ================================================================ */
SELECT
    YEAR(OrderDate) AS SalesYear,
    MONTH(OrderDate) AS SalesMonth,
    DATENAME(MONTH, OrderDate) AS MonthName,
    SUM(Sales) AS Sales,
    SUM(Profit) AS Profit,
    SUM(Profit) * 1.0 / NULLIF(SUM(Sales), 0) AS ProfitMargin
FROM dbo.vw_RetailTransactions_Clean
GROUP BY YEAR(OrderDate), MONTH(OrderDate), DATENAME(MONTH, OrderDate)
ORDER BY SalesYear, SalesMonth;
GO

/* ================================================================
   3. Year-over-Year Sales Growth
   ================================================================ */
WITH YearlySales AS
(
    SELECT
        YEAR(OrderDate) AS SalesYear,
        SUM(Sales) AS Sales
    FROM dbo.vw_RetailTransactions_Clean
    GROUP BY YEAR(OrderDate)
),
YoY AS
(
    SELECT
        SalesYear,
        Sales,
        LAG(Sales) OVER (ORDER BY SalesYear) AS PreviousYearSales
    FROM YearlySales
)
SELECT
    SalesYear,
    Sales,
    PreviousYearSales,
    (Sales - PreviousYearSales) * 1.0 / NULLIF(PreviousYearSales, 0) AS YoYSalesGrowth
FROM YoY
ORDER BY SalesYear;
GO

/* ================================================================
   4. Quarterly Sales Comparison
   ================================================================ */
SELECT
    YEAR(OrderDate) AS SalesYear,
    DATEPART(QUARTER, OrderDate) AS QuarterNumber,
    SUM(Sales) AS Sales,
    SUM(Profit) AS Profit
FROM dbo.vw_RetailTransactions_Clean
GROUP BY YEAR(OrderDate), DATEPART(QUARTER, OrderDate)
ORDER BY SalesYear, QuarterNumber;
GO

/* ================================================================
   5. Sales & Profit by Region
   ================================================================ */
SELECT
    Region,
    SUM(Sales) AS Sales,
    SUM(Profit) AS Profit,
    SUM(Profit) * 1.0 / NULLIF(SUM(Sales), 0) AS ProfitMargin,
    COUNT(DISTINCT OrderID) AS Orders,
    COUNT(DISTINCT CustomerID) AS Customers
FROM dbo.vw_RetailTransactions_Clean
GROUP BY Region
ORDER BY Sales DESC;
GO

/* ================================================================
   6. Category Performance
   ================================================================ */
SELECT
    Category,
    SUM(Sales) AS Sales,
    SUM(Profit) AS Profit,
    SUM(Profit) * 1.0 / NULLIF(SUM(Sales), 0) AS ProfitMargin,
    SUM(Quantity) AS UnitsSold
FROM dbo.vw_RetailTransactions_Clean
GROUP BY Category
ORDER BY Sales DESC;
GO

/* ================================================================
   7. Top 10 Products by Sales
   ================================================================ */
SELECT TOP (10)
    ProductName,
    Category,
    SubCategory,
    SUM(Sales) AS Sales,
    SUM(Profit) AS Profit,
    SUM(Quantity) AS UnitsSold
FROM dbo.vw_RetailTransactions_Clean
GROUP BY ProductName, Category, SubCategory
ORDER BY Sales DESC;
GO

/* ================================================================
   8. Bottom 10 Products by Profit
   ================================================================ */
SELECT TOP (10)
    ProductName,
    Category,
    SubCategory,
    SUM(Sales) AS Sales,
    SUM(Profit) AS Profit,
    SUM(Profit) * 1.0 / NULLIF(SUM(Sales), 0) AS ProfitMargin
FROM dbo.vw_RetailTransactions_Clean
GROUP BY ProductName, Category, SubCategory
ORDER BY Profit ASC;
GO

/* ================================================================
   9. Customer Segment Performance
   ================================================================ */
SELECT
    Segment,
    COUNT(DISTINCT CustomerID) AS Customers,
    COUNT(DISTINCT OrderID) AS Orders,
    SUM(Sales) AS Revenue,
    SUM(Profit) AS Profit,
    SUM(Sales) * 1.0 / NULLIF(COUNT(DISTINCT CustomerID), 0) AS RevenuePerCustomer
FROM dbo.vw_RetailTransactions_Clean
GROUP BY Segment
ORDER BY Revenue DESC;
GO

/* ================================================================
   10. Top 10 Customers by Sales
   ================================================================ */
SELECT TOP (10)
    CustomerID,
    CustomerName,
    Segment,
    COUNT(DISTINCT OrderID) AS Orders,
    SUM(Sales) AS Sales,
    SUM(Profit) AS Profit
FROM dbo.vw_RetailTransactions_Clean
GROUP BY CustomerID, CustomerName, Segment
ORDER BY Sales DESC;
GO

/* ================================================================
   11. Repeat Customer Analysis
   ================================================================ */
WITH CustomerOrders AS
(
    SELECT
        CustomerID,
        COUNT(DISTINCT OrderID) AS OrderCount
    FROM dbo.vw_RetailTransactions_Clean
    GROUP BY CustomerID
)
SELECT
    CASE
        WHEN OrderCount = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS CustomerType,
    COUNT(*) AS Customers
FROM CustomerOrders
GROUP BY
    CASE
        WHEN OrderCount = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END;
GO

/* ================================================================
   12. Customer Revenue Contribution
   ================================================================ */
SELECT
    Segment,
    SUM(Sales) AS Revenue,
    SUM(Sales) * 100.0 / NULLIF(SUM(SUM(Sales)) OVER (), 0) AS RevenueContributionPct
FROM dbo.vw_RetailTransactions_Clean
GROUP BY Segment
ORDER BY Revenue DESC;
GO
