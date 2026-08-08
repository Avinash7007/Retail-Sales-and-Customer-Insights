# Data & Dashboard Validation

The dashboard metrics are validated at multiple stages before publication.

## Master KPI values used by the portfolio dashboards

| KPI | Approved value |
|---|---:|
| Total Sales | $20.40M |
| Total Profit | $2.58M |
| Profit Margin | 12.6% |
| YoY Sales Growth | 46.9% |
| Total Orders | 48,620 |
| Total Customers | 12,840 |
| Average Order Value | $419.55 |
| Average Profit per Order | $53.07 |
| Revenue per Customer | $1,589 |

## Reconciliation checks

### Sales

Regional, category, customer-segment and time-based sales views should reconcile to the $20.40M project total.

### Profit

Regional, category and monthly/quarterly profit views should reconcile to approximately $2.58M.

### Customer and order metrics

The unique customer KPI is 12,840 and the total order KPI is 48,620. Monthly returning-customer activity is treated as activity, not as a sum of unique customers.

### YoY

The approved current-year sales value is $20.40M and the comparison-year sales value is approximately $13.89M, producing approximately 46.9% YoY growth.

## SQL validation coverage

The `sql/data-validation.sql` script checks:

- row counts
- distinct orders/customers/products
- duplicate records
- NULLs
- invalid quantities
- invalid discounts
- invalid shipping dates
- sales/profit totals
- profit margin
- AOV
- monthly reconciliation
- regional reconciliation

## Important limitation

The public repository does not contain the confidential source dataset. Therefore, SQL scripts are designed for execution against the private source environment and the dashboard figures represent the approved portfolio project outputs.
