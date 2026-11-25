# Requirements & KPI Specification — Project 2: Operations SLA Analytics

## 1. Stakeholder & Business Context
- **Primary Stakeholder:** Head of Customer Operations & Support Team Leads
- **Business Decision Enabled:** Identify which support queues, priority tiers, and systemic root causes drive SLA breaches so leadership can rebalance staffing and fix recurring technical failures.
- **SLA Policy Thresholds:**
  - `P1 - Critical`: 4 hours
  - `P2 - High`: 12 hours
  - `P3 - Medium`: 24 hours
  - `P4 - Low`: 48 hours

## 2. Formal KPI Dictionary
| KPI | Formula / Definition | Operational Target |
| :--- | :--- | :---: |
| **SLA Compliance Rate (%)** | `(Tickets Resolved <= SLA Target / Total Tickets) * 100` | ≥ 85.0% |
| **Mean Time to Resolution (MTTR)** | `AVG(resolution_hrs)` across validated tickets | Minimize by priority |
| **First Response Time (FRT)** | `AVG(first_response_hrs)` | < 2.0 hrs (P1/P2) |
| **CSAT Impact Delta** | `Avg CSAT (SLA Met) - Avg CSAT (SLA Breached)` | Track customer pain |
