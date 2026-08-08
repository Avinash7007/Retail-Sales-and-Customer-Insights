/*
    Retail Sales & Customer Insights
    SQL Server / T-SQL
    File: data-extraction.sql

    Purpose:
    - Extract the transaction-level data required for Power BI.
    - Keep the extraction layer focused on required columns and business filters.

    Assumed source table:
        dbo.RetailTransactions

    Expected columns:
        OrderID, OrderDate, CustomerID, CustomerName, Segment,
        ProductID, ProductName, Category, SubCategory,
        Region, State, City, Quantity, Sales, Profit,
        Discount, ShipDate, ShipMode
*/

USE RetailSalesDB;
GO

-- 1. Inspect the source structure before extraction
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME = 'RetailTransactions'
ORDER BY ORDINAL_POSITION;
GO

-- 2. Extract the transaction-level fields required for analytics
SELECT
    OrderID,
    CAST(OrderDate AS date) AS OrderDate,
    CAST(ShipDate AS date) AS ShipDate,
    CustomerID,
    CustomerName,
    Segment,
    ProductID,
    ProductName,
    Category,
    SubCategory,
    Region,
    State,
    City,
    ShipMode,
    Quantity,
    Sales,
    Profit,
    Discount
FROM dbo.RetailTransactions
WHERE OrderDate IS NOT NULL;
GO

-- 3. Current-year extraction used by the executive dashboard
SELECT
    OrderID,
    CAST(OrderDate AS date) AS OrderDate,
    CustomerID,
    CustomerName,
    Segment,
    ProductID,
    ProductName,
    Category,
    SubCategory,
    Region,
    State,
    City,
    Quantity,
    Sales,
    Profit,
    Discount
FROM dbo.RetailTransactions
WHERE OrderDate >= '2025-01-01'
  AND OrderDate <  '2026-01-01';
GO

-- 4. Basic aggregation for a quick extraction-level reconciliation
SELECT
    COUNT_BIG(*) AS TransactionRows,
    COUNT(DISTINCT OrderID) AS DistinctOrders,
    COUNT(DISTINCT CustomerID) AS DistinctCustomers,
    SUM(Sales) AS TotalSales,
    SUM(Profit) AS TotalProfit
FROM dbo.RetailTransactions
WHERE OrderDate IS NOT NULL;
GO
