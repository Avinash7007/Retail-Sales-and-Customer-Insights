/* Retail Sales & Customer Insights | data-extraction.sql
   SQL Server / T-SQL

   Project source model:
   dbo.FactSales + DimCustomer + DimProduct + DimDate + DimGeography + DimShipping

   The public repository does not contain the confidential source dataset.
   These queries document the actual extraction layer used by the project.
*/

USE RetailSalesDB;
GO

/* 1. Source row structure */
SELECT
    c.TABLE_SCHEMA,
    c.TABLE_NAME,
    c.COLUMN_NAME,
    c.DATA_TYPE,
    c.IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS AS c
WHERE c.TABLE_SCHEMA = 'dbo'
  AND c.TABLE_NAME IN
      ('FactSales','DimCustomer','DimProduct','DimDate','DimGeography','DimShipping')
ORDER BY c.TABLE_NAME, c.ORDINAL_POSITION;
GO

/* 2. Transaction-level extraction for Power BI */
SELECT
    f.OrderID,
    f.OrderDate,
    f.ShipDate,
    f.CustomerID,
    dc.CustomerName,
    dc.Segment,
    f.ProductID,
    dp.ProductName,
    dp.Category,
    dp.SubCategory,
    dg.Region,
    dg.State,
    dg.City,
    ds.ShipMode,
    f.Quantity,
    f.Sales,
    f.Profit,
    f.Discount
FROM dbo.FactSales AS f
LEFT JOIN dbo.DimCustomer AS dc
    ON f.CustomerID = dc.CustomerID
LEFT JOIN dbo.DimProduct AS dp
    ON f.ProductID = dp.ProductID
LEFT JOIN dbo.DimGeography AS dg
    ON f.GeographyID = dg.GeographyID
LEFT JOIN dbo.DimShipping AS ds
    ON f.ShippingID = ds.ShippingID
WHERE f.OrderDate IS NOT NULL;
GO

/* 3. 2025 dataset used by the dashboard */
SELECT
    f.OrderID,
    f.OrderDate,
    f.CustomerID,
    f.ProductID,
    dg.Region,
    dc.Segment,
    dp.Category,
    dp.SubCategory,
    f.Quantity,
    f.Sales,
    f.Profit,
    f.Discount
FROM dbo.FactSales AS f
LEFT JOIN dbo.DimCustomer AS dc ON f.CustomerID = dc.CustomerID
LEFT JOIN dbo.DimProduct AS dp ON f.ProductID = dp.ProductID
LEFT JOIN dbo.DimGeography AS dg ON f.GeographyID = dg.GeographyID
WHERE f.OrderDate >= '2025-01-01'
  AND f.OrderDate <  '2026-01-01';
GO

/* 4. Extraction-level KPI check against the dashboard */
SELECT
    COUNT(DISTINCT f.OrderID) AS TotalOrders,
    COUNT(DISTINCT f.CustomerID) AS TotalCustomers,
    SUM(f.Sales) AS TotalSales,
    SUM(f.Profit) AS TotalProfit,
    SUM(f.Profit) / NULLIF(SUM(f.Sales),0) AS ProfitMargin,
    SUM(f.Sales) / NULLIF(COUNT(DISTINCT f.OrderID),0) AS AverageOrderValue,
    SUM(f.Profit) / NULLIF(COUNT(DISTINCT f.OrderID),0) AS AverageProfitPerOrder
FROM dbo.FactSales AS f
WHERE f.OrderDate >= '2025-01-01'
  AND f.OrderDate <  '2026-01-01';
GO

/* Dashboard reference values:
   Sales              = 20,400,000 approx.
   Profit             = 2,580,000 approx.
   Profit Margin      = 12.6%
   YoY Sales Growth   = 46.9%
   Orders             = 48,620
   Customers          = 12,840
   AOV                = $419.55
   Avg Profit/Order   = $53.07
*/
