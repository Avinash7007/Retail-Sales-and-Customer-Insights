# Dataset & Data Privacy

## Dataset status

The underlying retail transaction dataset is **not included in this public repository** because the source data is confidential and cannot be redistributed publicly.

The project documentation and SQL scripts describe the analytical workflow without exposing raw business data.

## Expected transaction fields

| Field | Purpose |
|---|---|
| `OrderID` | Transaction/order identifier |
| `OrderDate` | Order date used for time analysis |
| `ShipDate` | Fulfillment/shipping date |
| `CustomerID` | Customer key |
| `CustomerName` | Customer descriptive attribute |
| `Segment` | Customer segment |
| `ProductID` | Product key |
| `ProductName` | Product descriptive attribute |
| `Category` | Product category |
| `SubCategory` | Product sub-category |
| `Region` | Sales region |
| `State` | Geographic attribute |
| `City` | Geographic attribute |
| `ShipMode` | Shipping mode |
| `Quantity` | Units sold |
| `Sales` | Revenue amount |
| `Profit` | Profit amount |
| `Discount` | Discount rate |

## Analytical grain

The analytical fact table is transaction-line level. Dimensions are used to provide reusable descriptive context for Power BI analysis.

## Privacy rule

Do not upload the original CSV, database extract, customer-level confidential records, credentials, connection strings, or the private Power BI `.pbix` file to this public repository.
