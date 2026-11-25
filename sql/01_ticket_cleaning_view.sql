-- ============================================================================
-- Project 2: Operations SLA Analytics
-- File: 01_ticket_cleaning_view.sql
-- Purpose: Deduplicate tickets, filter clock-sync errors, and flag SLA breaches
-- ============================================================================

CREATE OR REPLACE VIEW vw_support_tickets_clean AS
WITH dedup AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY ticket_id ORDER BY created_at) AS rn
    FROM raw_support_tickets
)
SELECT
    ticket_id,
    CAST(created_at AS TIMESTAMP) AS created_at,
    CAST(resolved_at AS TIMESTAMP) AS resolved_at,
    priority,
    support_team,
    channel,
    COALESCE(NULLIF(TRIM(root_cause), ''), 'Unclassified') AS root_cause,
    sla_target_hrs,
    first_response_hrs,
    resolution_hrs,
    csat_score,
    CASE WHEN resolution_hrs > sla_target_hrs THEN 1 ELSE 0 END AS sla_breached,
    CASE WHEN resolution_hrs > sla_target_hrs THEN 'Breached' ELSE 'Met' END AS sla_status,
    GREATEST(0, ROUND(resolution_hrs - sla_target_hrs, 2)) AS breach_excess_hrs
FROM dedup
WHERE rn = 1
  AND resolution_hrs > 0;
