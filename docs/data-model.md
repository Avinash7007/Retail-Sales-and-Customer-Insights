# Data Model

## Architecture

The Power BI solution follows a **Star Schema** pattern.

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

## Fact table — FactSales

Transaction-level measures and foreign keys:

- OrderID
- OrderDateKey
- CustomerKey
- ProductKey
- GeographyKey
- ShippingKey
- Quantity
- SalesAmount
- ProfitAmount
- Discount

## Dimensions

### DimDate

- DateKey
- Date
- Year
- Quarter
- MonthNumber
- MonthName

### DimCustomer

- CustomerKey
- CustomerID
- CustomerName
- Segment

### DimProduct

- ProductKey
- ProductID
- ProductName
- Category
- SubCategory

### DimGeography

- GeographyKey
- Region
- State
- City

### DimShipping

- ShippingKey
- ShipMode

## Modeling principles

- One-to-many relationships from dimensions to fact.
- Single-direction filtering where appropriate.
- Dedicated Date dimension for time intelligence.
- Measures preferred over unnecessary calculated columns for report KPIs.
- Business logic is kept centralized and reusable.

## Why Star Schema?

A star schema keeps relationships predictable, reduces repeated descriptive data, and provides a clean filter context for DAX and Power BI visuals. It also makes the semantic model easier to maintain as the reporting scope grows.
