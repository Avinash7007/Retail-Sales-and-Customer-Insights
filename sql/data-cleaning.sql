/* Retail Sales & Customer Insights | data-cleaning.sql
   SQL Server / T-SQL
   Cleaning layer for FactSales + project dimensions.
*/

USE RetailSalesDB;
GO

/* 1. Duplicate transaction check */
SELECT
    OrderID,
    COUNT(*) AS TransactionRows
FROM dbo.FactSales
GROUP BY OrderID
HAVING COUNT(*) > 1
ORDER BY TransactionRows DESC;
GO

/* 2. Mandatory-field quality check */
SELECT
    SUM(CASE WHEN OrderID IS NULL THEN 1 ELSE 0 END) AS NullOrderID,
    SUM(CASE WHEN OrderDate IS NULL THEN 1 ELSE 0 END) AS NullOrderDate,
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS NullCustomerID,
    SUM(CASE WHEN ProductID IS NULL THEN 1 ELSE 0 END) AS NullProductID,
    SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS NullSales,
    SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END) AS NullProfit
FROM dbo.FactSales;
GO

/* 3. Numeric/business-rule checks */
SELECT
    SUM(CASE WHEN Quantity <= 0 THEN 1 ELSE 0 END) AS InvalidQuantityRows,
    SUM(CASE WHEN Sales < 0 THEN 1 ELSE 0 END) AS NegativeSalesRows,
    SUM(CASE WHEN Discount < 0 OR Discount > 1 THEN 1 ELSE 0 END) AS InvalidDiscountRows,
    SUM(CASE WHEN ShipDate < OrderDate THEN 1 ELSE 0 END) AS InvalidShippingDateRows
FROM dbo.FactSales;
GO

/* 4. Clean analytical view used by downstream analysis */
CREATE OR ALTER VIEW dbo.vw_FactSales_Clean
AS
SELECT
    f.OrderID,
    CAST(f.OrderDate AS date) AS OrderDate,
    CAST(f.ShipDate AS date) AS ShipDate,
    f.CustomerID,
    f.ProductID,
    f.GeographyID,
    f.ShippingID,
    TRY_CONVERT(int, f.Quantity) AS Quantity,
    TRY_CONVERT(decimal(18,2), f.Sales) AS Sales,
    TRY_CONVERT(decimal(18,2), f.Profit) AS Profit,
    TRY_CONVERT(decimal(10,4), f.Discount) AS Discount
FROM dbo.FactSales AS f
WHERE f.OrderID IS NOT NULL
  AND f.OrderDate IS NOT NULL
  AND f.CustomerID IS NOT NULL
  AND f.ProductID IS NOT NULL;
GO

/* 5. Join cleaned fact with descriptive dimensions */
SELECT TOP (100)
    f.OrderID,
    f.OrderDate,
    dc.CustomerName,
    dc.Segment,
    dp.ProductName,
    dp.Category,
    dp.SubCategory,
    dg.Region,
    dg.State,
    dg.City,
    f.Quantity,
    f.Sales,
    f.Profit,
    f.Discount
FROM dbo.vw_FactSales_Clean AS f
LEFT JOIN dbo.DimCustomer AS dc ON f.CustomerID = dc.CustomerID
LEFT JOIN dbo.DimProduct AS dp ON f.ProductID = dp.ProductID
LEFT JOIN dbo.DimGeography AS dg ON f.GeographyID = dg.GeographyID
ORDER BY f.OrderDate DESC;
GO
