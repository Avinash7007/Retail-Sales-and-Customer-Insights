/*
    Retail Sales & Customer Insights
    SQL Server / T-SQL
    File: data-cleaning.sql

    Purpose:
    - Standardize source values before analytical modeling.
    - Identify and handle common data-quality issues.
    - Keep business calculations out of the cleaning layer.

    Assumed source table:
        dbo.RetailTransactions
*/

USE RetailSalesDB;
GO

-- 1. Check for duplicate transaction IDs
SELECT
    OrderID,
    COUNT(*) AS RowCount
FROM dbo.RetailTransactions
GROUP BY OrderID
HAVING COUNT(*) > 1
ORDER BY RowCount DESC;
GO

-- 2. Check mandatory fields for NULL values
SELECT
    SUM(CASE WHEN OrderID IS NULL THEN 1 ELSE 0 END) AS NullOrderID,
    SUM(CASE WHEN OrderDate IS NULL THEN 1 ELSE 0 END) AS NullOrderDate,
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS NullCustomerID,
    SUM(CASE WHEN ProductID IS NULL THEN 1 ELSE 0 END) AS NullProductID,
    SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS NullSales,
    SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END) AS NullProfit
FROM dbo.RetailTransactions;
GO

-- 3. Check invalid numeric values
SELECT
    COUNT(*) AS InvalidRows
FROM dbo.RetailTransactions
WHERE Quantity < 0
   OR Sales < 0
   OR Discount < 0
   OR Discount > 1;
GO

-- 4. Check date consistency
SELECT
    COUNT(*) AS InvalidDateRows
FROM dbo.RetailTransactions
WHERE ShipDate IS NOT NULL
  AND OrderDate IS NOT NULL
  AND ShipDate < OrderDate;
GO

-- 5. Standardized analytical view
-- This view keeps the source table unchanged and exposes cleaned fields.
CREATE OR ALTER VIEW dbo.vw_RetailTransactions_Clean
AS
SELECT
    LTRIM(RTRIM(OrderID)) AS OrderID,
    CAST(OrderDate AS date) AS OrderDate,
    CAST(ShipDate AS date) AS ShipDate,
    LTRIM(RTRIM(CustomerID)) AS CustomerID,
    NULLIF(LTRIM(RTRIM(CustomerName)), '') AS CustomerName,
    NULLIF(LTRIM(RTRIM(Segment)), '') AS Segment,
    LTRIM(RTRIM(ProductID)) AS ProductID,
    NULLIF(LTRIM(RTRIM(ProductName)), '') AS ProductName,
    NULLIF(LTRIM(RTRIM(Category)), '') AS Category,
    NULLIF(LTRIM(RTRIM(SubCategory)), '') AS SubCategory,
    NULLIF(LTRIM(RTRIM(Region)), '') AS Region,
    NULLIF(LTRIM(RTRIM(State)), '') AS State,
    NULLIF(LTRIM(RTRIM(City)), '') AS City,
    NULLIF(LTRIM(RTRIM(ShipMode)), '') AS ShipMode,
    TRY_CONVERT(int, Quantity) AS Quantity,
    TRY_CONVERT(decimal(18,2), Sales) AS Sales,
    TRY_CONVERT(decimal(18,2), Profit) AS Profit,
    TRY_CONVERT(decimal(10,4), Discount) AS Discount
FROM dbo.RetailTransactions
WHERE OrderID IS NOT NULL
  AND OrderDate IS NOT NULL
  AND CustomerID IS NOT NULL
  AND ProductID IS NOT NULL;
GO

-- 6. Validate the cleaned view
SELECT TOP (100) *
FROM dbo.vw_RetailTransactions_Clean
ORDER BY OrderDate DESC;
GO
