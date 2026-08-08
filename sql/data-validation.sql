/*
    Retail Sales & Customer Insights
    SQL Server / T-SQL
    File: data-validation.sql

    Purpose:
    - Reconcile source data before Power BI publication.
    - Detect duplicates, NULLs, invalid values and KPI mismatches.
*/

USE RetailSalesDB;
GO

-- 1. Row and key-count validation
SELECT
    COUNT_BIG(*) AS TotalRows,
    COUNT(DISTINCT OrderID) AS DistinctOrders,
    COUNT(DISTINCT CustomerID) AS DistinctCustomers,
    COUNT(DISTINCT ProductID) AS DistinctProducts
FROM dbo.vw_RetailTransactions_Clean;
GO

-- 2. Duplicate order-level check
SELECT
    OrderID,
    COUNT(*) AS TransactionRows
FROM dbo.vw_RetailTransactions_Clean
GROUP BY OrderID
HAVING COUNT(*) > 1
ORDER BY TransactionRows DESC;
GO

-- 3. NULL / conversion validation
SELECT
    SUM(CASE WHEN OrderID IS NULL THEN 1 ELSE 0 END) AS NullOrderID,
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS NullCustomerID,
    SUM(CASE WHEN ProductID IS NULL THEN 1 ELSE 0 END) AS NullProductID,
    SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS NullSales,
    SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END) AS NullProfit
FROM dbo.vw_RetailTransactions_Clean;
GO

-- 4. Business-rule validation
SELECT
    SUM(CASE WHEN Quantity <= 0 THEN 1 ELSE 0 END) AS InvalidQuantityRows,
    SUM(CASE WHEN Sales < 0 THEN 1 ELSE 0 END) AS NegativeSalesRows,
    SUM(CASE WHEN Discount < 0 OR Discount > 1 THEN 1 ELSE 0 END) AS InvalidDiscountRows,
    SUM(CASE WHEN ShipDate < OrderDate THEN 1 ELSE 0 END) AS InvalidShipDateRows
FROM dbo.vw_RetailTransactions_Clean;
GO

-- 5. KPI reconciliation
SELECT
    SUM(Sales) AS TotalSales,
    SUM(Profit) AS TotalProfit,
    CASE
        WHEN SUM(Sales) = 0 THEN 0
        ELSE SUM(Profit) * 1.0 / SUM(Sales)
    END AS ProfitMargin,
    COUNT(DISTINCT OrderID) AS TotalOrders,
    COUNT(DISTINCT CustomerID) AS TotalCustomers,
    CASE
        WHEN COUNT(DISTINCT OrderID) = 0 THEN 0
        ELSE SUM(Sales) * 1.0 / COUNT(DISTINCT OrderID)
    END AS AverageOrderValue
FROM dbo.vw_RetailTransactions_Clean;
GO

-- 6. Monthly reconciliation used to validate Power BI trend visuals
SELECT
    YEAR(OrderDate) AS SalesYear,
    MONTH(OrderDate) AS SalesMonth,
    SUM(Sales) AS MonthlySales,
    SUM(Profit) AS MonthlyProfit,
    COUNT(DISTINCT OrderID) AS MonthlyOrders,
    COUNT(DISTINCT CustomerID) AS MonthlyCustomers
FROM dbo.vw_RetailTransactions_Clean
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY SalesYear, SalesMonth;
GO

-- 7. Regional reconciliation
SELECT
    Region,
    SUM(Sales) AS Sales,
    SUM(Profit) AS Profit,
    COUNT(DISTINCT OrderID) AS Orders,
    COUNT(DISTINCT CustomerID) AS Customers
FROM dbo.vw_RetailTransactions_Clean
GROUP BY Region
ORDER BY Sales DESC;
GO
