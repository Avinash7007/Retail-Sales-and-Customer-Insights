/* Retail Sales & Customer Insights | business-analysis.sql
   SQL Server / T-SQL
   Business analysis layer for the Power BI dashboards.
*/

USE RetailSalesDB;
GO

/* 1. Executive KPI summary - dashboard headline metrics */
SELECT
    SUM(f.Sales) AS TotalSales,
    SUM(f.Profit) AS TotalProfit,
    CAST(100.0 * SUM(f.Profit) / NULLIF(SUM(f.Sales),0) AS decimal(10,2)) AS ProfitMarginPct,
    COUNT(DISTINCT f.OrderID) AS TotalOrders,
    COUNT(DISTINCT f.CustomerID) AS TotalCustomers,
    CAST(SUM(f.Sales) / NULLIF(COUNT(DISTINCT f.OrderID),0) AS decimal(18,2)) AS AverageOrderValue,
    CAST(SUM(f.Profit) / NULLIF(COUNT(DISTINCT f.OrderID),0) AS decimal(18,2)) AS AverageProfitPerOrder
FROM dbo.vw_FactSales_Clean AS f
WHERE f.OrderDate >= '2025-01-01'
  AND f.OrderDate < '2026-01-01';
GO

/* 2. Monthly Sales & Profit - Sales Performance page */
SELECT
    YEAR(f.OrderDate) AS SalesYear,
    MONTH(f.OrderDate) AS SalesMonth,
    DATENAME(MONTH,f.OrderDate) AS MonthName,
    SUM(f.Sales) AS Sales,
    SUM(f.Profit) AS Profit,
    CAST(100.0 * SUM(f.Profit) / NULLIF(SUM(f.Sales),0) AS decimal(10,2)) AS ProfitMarginPct
FROM dbo.vw_FactSales_Clean AS f
GROUP BY YEAR(f.OrderDate), MONTH(f.OrderDate), DATENAME(MONTH,f.OrderDate)
ORDER BY SalesYear, SalesMonth;
GO

/* 3. YoY growth - dashboard headline target: 46.9% */
WITH YearSales AS
(
    SELECT YEAR(OrderDate) AS SalesYear, SUM(Sales) AS Sales
    FROM dbo.vw_FactSales_Clean
    GROUP BY YEAR(OrderDate)
),
YoY AS
(
    SELECT SalesYear, Sales,
           LAG(Sales) OVER (ORDER BY SalesYear) AS PreviousYearSales
    FROM YearSales
)
SELECT
    SalesYear,
    Sales,
    PreviousYearSales,
    CAST(100.0 * (Sales - PreviousYearSales) /
         NULLIF(PreviousYearSales,0) AS decimal(10,2)) AS YoYSalesGrowthPct
FROM YoY
ORDER BY SalesYear;
GO

/* 4. Quarterly Sales & Profit */
SELECT
    YEAR(f.OrderDate) AS SalesYear,
    DATEPART(QUARTER,f.OrderDate) AS QuarterNumber,
    SUM(f.Sales) AS Sales,
    SUM(f.Profit) AS Profit
FROM dbo.vw_FactSales_Clean AS f
GROUP BY YEAR(f.OrderDate), DATEPART(QUARTER,f.OrderDate)
ORDER BY SalesYear, QuarterNumber;
GO

/* 5. Regional Performance
   Dashboard order: West, East, Central, South */
SELECT
    dg.Region,
    SUM(f.Sales) AS Sales,
    SUM(f.Profit) AS Profit,
    CAST(100.0 * SUM(f.Profit) / NULLIF(SUM(f.Sales),0) AS decimal(10,2)) AS ProfitMarginPct,
    CAST(100.0 * SUM(f.Sales) /
         NULLIF(SUM(SUM(f.Sales)) OVER (),0) AS decimal(10,2)) AS SalesContributionPct
FROM dbo.vw_FactSales_Clean AS f
INNER JOIN dbo.DimGeography AS dg ON f.GeographyID = dg.GeographyID
GROUP BY dg.Region
ORDER BY Sales DESC;
GO

/* 6. Category Performance */
SELECT
    dp.Category,
    SUM(f.Sales) AS Sales,
    SUM(f.Profit) AS Profit,
    CAST(100.0 * SUM(f.Profit) / NULLIF(SUM(f.Sales),0) AS decimal(10,2)) AS ProfitMarginPct,
    SUM(f.Quantity) AS UnitsSold
FROM dbo.vw_FactSales_Clean AS f
INNER JOIN dbo.DimProduct AS dp ON f.ProductID = dp.ProductID
GROUP BY dp.Category
ORDER BY Sales DESC;
GO

/* 7. Top 10 Products by Sales */
SELECT TOP (10)
    dp.ProductName,
    dp.Category,
    dp.SubCategory,
    SUM(f.Sales) AS Sales,
    SUM(f.Profit) AS Profit,
    SUM(f.Quantity) AS UnitsSold
FROM dbo.vw_FactSales_Clean AS f
INNER JOIN dbo.DimProduct AS dp ON f.ProductID = dp.ProductID
GROUP BY dp.ProductName, dp.Category, dp.SubCategory
ORDER BY Sales DESC;
GO

/* 8. Bottom 10 Products by Profit */
SELECT TOP (10)
    dp.ProductName,
    dp.Category,
    dp.SubCategory,
    SUM(f.Sales) AS Sales,
    SUM(f.Profit) AS Profit,
    CAST(100.0 * SUM(f.Profit) / NULLIF(SUM(f.Sales),0) AS decimal(10,2)) AS ProfitMarginPct
FROM dbo.vw_FactSales_Clean AS f
INNER JOIN dbo.DimProduct AS dp ON f.ProductID = dp.ProductID
GROUP BY dp.ProductName, dp.Category, dp.SubCategory
ORDER BY Profit ASC;
GO

/* 9. Customer Segment Performance
   Dashboard: Consumer 53.2%, Corporate 28.6%, Home Office 18.2% of customers/revenue view */
SELECT
    dc.Segment,
    COUNT(DISTINCT f.CustomerID) AS Customers,
    COUNT(DISTINCT f.OrderID) AS Orders,
    SUM(f.Sales) AS Revenue,
    SUM(f.Profit) AS Profit,
    CAST(SUM(f.Sales) / NULLIF(COUNT(DISTINCT f.CustomerID),0) AS decimal(18,2)) AS RevenuePerCustomer
FROM dbo.vw_FactSales_Clean AS f
INNER JOIN dbo.DimCustomer AS dc ON f.CustomerID = dc.CustomerID
GROUP BY dc.Segment
ORDER BY Revenue DESC;
GO

/* 10. Top 5 Customers by Sales - Customer Insights page */
SELECT TOP (5)
    f.CustomerID,
    dc.CustomerName,
    dc.Segment,
    COUNT(DISTINCT f.OrderID) AS Orders,
    SUM(f.Sales) AS Sales,
    SUM(f.Profit) AS Profit
FROM dbo.vw_FactSales_Clean AS f
INNER JOIN dbo.DimCustomer AS dc ON f.CustomerID = dc.CustomerID
GROUP BY f.CustomerID, dc.CustomerName, dc.Segment
ORDER BY Sales DESC;
GO

/* 11. Top 5 Customers by Order Frequency */
SELECT TOP (5)
    f.CustomerID,
    dc.CustomerName,
    COUNT(DISTINCT f.OrderID) AS OrderFrequency
FROM dbo.vw_FactSales_Clean AS f
INNER JOIN dbo.DimCustomer AS dc ON f.CustomerID = dc.CustomerID
GROUP BY f.CustomerID, dc.CustomerName
ORDER BY OrderFrequency DESC;
GO

/* 12. New vs Returning Customer Activity by Month */
WITH CustomerFirstOrder AS
(
    SELECT CustomerID, MIN(OrderDate) AS FirstOrderDate
    FROM dbo.vw_FactSales_Clean
    GROUP BY CustomerID
)
SELECT
    YEAR(f.OrderDate) AS SalesYear,
    MONTH(f.OrderDate) AS SalesMonth,
    COUNT(DISTINCT CASE
        WHEN YEAR(f.OrderDate) = YEAR(c.FirstOrderDate)
         AND MONTH(f.OrderDate) = MONTH(c.FirstOrderDate)
        THEN f.CustomerID END) AS NewCustomers,
    COUNT(DISTINCT CASE
        WHEN f.OrderDate > c.FirstOrderDate
        THEN f.CustomerID END) AS ReturningCustomers
FROM dbo.vw_FactSales_Clean AS f
INNER JOIN CustomerFirstOrder AS c ON f.CustomerID = c.CustomerID
GROUP BY YEAR(f.OrderDate), MONTH(f.OrderDate)
ORDER BY SalesYear, SalesMonth;
GO

/* 13. Customer Revenue Contribution */
SELECT
    dc.Segment,
    SUM(f.Sales) AS Revenue,
    CAST(100.0 * SUM(f.Sales) /
         NULLIF(SUM(SUM(f.Sales)) OVER (),0) AS decimal(10,2)) AS RevenueContributionPct
FROM dbo.vw_FactSales_Clean AS f
INNER JOIN dbo.DimCustomer AS dc ON f.CustomerID = dc.CustomerID
GROUP BY dc.Segment
ORDER BY Revenue DESC;
GO

/* 14. Discount vs Profitability */
SELECT
    CASE
        WHEN f.Discount = 0 THEN '0%'
        WHEN f.Discount < 0.10 THEN '1-9%'
        WHEN f.Discount < 0.20 THEN '10-19%'
        WHEN f.Discount < 0.30 THEN '20-29%'
        ELSE '30%+'
    END AS DiscountBand,
    SUM(f.Sales) AS Sales,
    SUM(f.Profit) AS Profit,
    CAST(100.0 * SUM(f.Profit) / NULLIF(SUM(f.Sales),0) AS decimal(10,2)) AS ProfitMarginPct
FROM dbo.vw_FactSales_Clean AS f
GROUP BY
    CASE
        WHEN f.Discount = 0 THEN '0%'
        WHEN f.Discount < 0.10 THEN '1-9%'
        WHEN f.Discount < 0.20 THEN '10-19%'
        WHEN f.Discount < 0.30 THEN '20-29%'
        ELSE '30%+'
    END
ORDER BY DiscountBand;
GO
