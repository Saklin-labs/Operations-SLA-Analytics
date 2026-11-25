# Data Validation & QA Evidence Report — Project 2

**Source File:** `data/raw/support_tickets_raw.csv`  
**Output File:** `data/processed/support_tickets_clean.csv`

## Automated Quality Audit Summary
| Check ID | Validation Rule | Records Flagged | Action Taken | Status |
| :--- | :--- | :---: | :--- | :---: |
| **DQ-01** | Unique `ticket_id` check | 22 | Dropped exact duplicates (kept first) | PASS |
| **DQ-02** | Positive `resolution_hrs > 0` | 14 | Filtered clock-sync negative durations | PASS |
| **DQ-03** | Non-null `root_cause` | 35 | Imputed as `'Unclassified'` | PASS |
| **DQ-04** | Optional `csat_score` nulls | 18 | Preserved as NULL (excluded from CSAT mean) | PASS |

- **Raw Ticket Count:** 3,022
- **Validated Ticket Count:** 2,986
- **Cross-Tool Reconciliation:** 100% match across Python, SQL (`vw_support_tickets_clean`), and Excel (`COUNTIF`/`AVERAGE`).
