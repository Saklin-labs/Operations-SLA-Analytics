-- ============================================================================
-- Project 2: Operations SLA Analytics
-- File: 02_sla_root_cause_analytics.sql
-- Purpose: SLA Compliance, MTTR, Team Breach Leaderboard & Root-Cause Pareto
-- ============================================================================

-- 1. Overall SLA Health & CSAT Impact
SELECT
    COUNT(*) AS total_tickets,
    SUM(sla_breached) AS total_breaches,
    ROUND(100.0 * (1 - AVG(sla_breached)), 2) AS sla_compliance_pct,
    ROUND(AVG(resolution_hrs), 2) AS mttr_hrs,
    ROUND(AVG(first_response_hrs), 2) AS avg_first_response_hrs,
    ROUND(AVG(csat_score), 2) AS overall_csat,
    ROUND(AVG(CASE WHEN sla_breached = 0 THEN csat_score END), 2) AS csat_when_sla_met,
    ROUND(AVG(CASE WHEN sla_breached = 1 THEN csat_score END), 2) AS csat_when_sla_breached
FROM vw_support_tickets_clean;

-- 2. Support Team SLA Breach Leaderboard
SELECT
    support_team,
    COUNT(*) AS total_tickets,
    SUM(sla_breached) AS breached_tickets,
    ROUND(100.0 * AVG(sla_breached), 2) AS breach_rate_pct,
    ROUND(AVG(resolution_hrs), 2) AS mttr_hrs,
    ROUND(AVG(csat_score), 2) AS avg_csat
FROM vw_support_tickets_clean
GROUP BY support_team
ORDER BY breach_rate_pct DESC;

-- 3. Root-Cause Pareto for Breached Tickets (Cumulative Share)
WITH rc_counts AS (
    SELECT
        root_cause,
        COUNT(*) AS breached_tickets,
        ROUND(AVG(breach_excess_hrs), 2) AS avg_excess_hrs
    FROM vw_support_tickets_clean
    WHERE sla_breached = 1
    GROUP BY root_cause
)
SELECT
    root_cause,
    breached_tickets,
    avg_excess_hrs,
    ROUND(100.0 * breached_tickets / SUM(breached_tickets) OVER (), 2) AS breach_share_pct,
    ROUND(100.0 * SUM(breached_tickets) OVER (ORDER BY breached_tickets DESC) / SUM(breached_tickets) OVER (), 2) AS cumulative_share_pct
FROM rc_counts
ORDER BY breached_tickets DESC;
