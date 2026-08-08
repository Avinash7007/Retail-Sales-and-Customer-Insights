/* Retail Sales & Customer Insights | data-validation.sql
   SQL Server / T-SQL
   Validation targets are the published Power BI dashboard metrics.
*/

USE RetailSalesDB;
GO

/* 1. Base data quality */
SELECT
    COUNT_BIG(*) AS TransactionRows,
    COUNT(DISTINCT OrderID) AS DistinctOrders,
    COUNT(DISTINCT CustomerID) AS DistinctCustomers,
    COUNT(DISTINCT ProductID) AS DistinctProducts
FROM dbo.vw_FactSales_Clean;
GO

/* 2. Duplicate transaction check */
SELECT OrderID, COUNT(*) AS TransactionRows
FROM dbo.vw_FactSales_Clean
GROUP BY OrderID
HAVING COUNT(*) > 1
ORDER BY TransactionRows DESC;
GO

/* 3. Null and invalid-value check */
SELECT
    SUM(CASE WHEN OrderID IS NULL THEN 1 ELSE 0 END) AS NullOrderID,
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS NullCustomerID,
    SUM(CASE WHEN ProductID IS NULL THEN 1 ELSE 0 END) AS NullProductID,
    SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS NullSales,
    SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END) AS NullProfit,
    SUM(CASE WHEN Quantity <= 0 THEN 1 ELSE 0 END) AS InvalidQuantity,
    SUM(CASE WHEN Discount < 0 OR Discount > 1 THEN 1 ELSE 0 END) AS InvalidDiscount
FROM dbo.vw_FactSales_Clean;
GO

/* 4. 2025 KPI reconciliation
   Expected dashboard values:
   Sales ~$20.40M | Profit ~$2.58M | Margin 12.6%
   Orders 48,620 | Customers 12,840 | AOV $419.55 | Profit/Order $53.07
*/
SELECT
    SUM(Sales) AS TotalSales,
    SUM(Profit) AS TotalProfit,
    CAST(100.0 * SUM(Profit) / NULLIF(SUM(Sales),0) AS decimal(10,2)) AS ProfitMarginPct,
    COUNT(DISTINCT OrderID) AS TotalOrders,
    COUNT(DISTINCT CustomerID) AS TotalCustomers,
    CAST(SUM(Sales) / NULLIF(COUNT(DISTINCT OrderID),0) AS decimal(18,2)) AS AverageOrderValue,
    CAST(SUM(Profit) / NULLIF(COUNT(DISTINCT OrderID),0) AS decimal(18,2)) AS AverageProfitPerOrder
FROM dbo.vw_FactSales_Clean
WHERE OrderDate >= '2025-01-01'
  AND OrderDate <  '2026-01-01';
GO

/* 5. Regional validation against dashboard
   West ~$5.95M | East ~$5.60M | Central ~$5.06M | South ~$3.79M
*/
SELECT
    dg.Region,
    SUM(f.Sales) AS Sales,
    SUM(f.Profit) AS Profit,
    CAST(100.0 * SUM(f.Sales) /
         NULLIF(SUM(SUM(f.Sales)) OVER (),0) AS decimal(10,2)) AS SalesContributionPct
FROM dbo.vw_FactSales_Clean AS f
INNER JOIN dbo.DimGeography AS dg
    ON f.GeographyID = dg.GeographyID
WHERE f.OrderDate >= '2025-01-01'
  AND f.OrderDate <  '2026-01-01'
GROUP BY dg.Region
ORDER BY Sales DESC;
GO

/* 6. Category validation
   Technology ~$8.96M sales / ~$1.38M profit
   Office Supplies ~$7.25M / ~$0.73M
   Furniture ~$4.19M / ~$0.47M
*/
SELECT
    dp.Category,
    SUM(f.Sales) AS Sales,
    SUM(f.Profit) AS Profit,
    CAST(100.0 * SUM(f.Profit) / NULLIF(SUM(f.Sales),0) AS decimal(10,2)) AS ProfitMarginPct
FROM dbo.vw_FactSales_Clean AS f
INNER JOIN dbo.DimProduct AS dp
    ON f.ProductID = dp.ProductID
WHERE f.OrderDate >= '2025-01-01'
  AND f.OrderDate <  '2026-01-01'
GROUP BY dp.Category
ORDER BY Sales DESC;
GO

/* 7. Monthly reconciliation used by Sales Performance dashboard */
SELECT
    YEAR(OrderDate) AS SalesYear,
    MONTH(OrderDate) AS SalesMonth,
    SUM(Sales) AS MonthlySales,
    SUM(Profit) AS MonthlyProfit,
    CAST(100.0 * SUM(Profit) / NULLIF(SUM(Sales),0) AS decimal(10,2)) AS MonthlyProfitMarginPct
FROM dbo.vw_FactSales_Clean
WHERE OrderDate >= '2025-01-01'
  AND OrderDate <  '2026-01-01'
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY SalesYear, SalesMonth;
GO

/* 8. YoY validation: dashboard target = 46.9% */
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
