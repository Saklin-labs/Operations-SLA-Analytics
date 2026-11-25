"""
Operations SLA Analytics — Automated Ticket Validation & SLA Scoring Pipeline
Author: Data Analytics Intern (Arrowstack 1-Month Internship)
"""
import numpy as np
import pandas as pd

RAW_PATH = "data/raw/support_tickets_raw.csv"
CLEAN_PATH = "data/processed/support_tickets_clean.csv"

def run_sla_pipeline():
    df = pd.read_csv(RAW_PATH, parse_dates=["created_at", "resolved_at"])
    raw_rows = len(df)

    # 1. Deduplicate ticket IDs
    dups = df.duplicated(subset=["ticket_id"]).sum()
    df = df.drop_duplicates(subset=["ticket_id"], keep="first").copy()

    # 2. Remove negative/zero resolution duration anomalies (timestamp sync bugs)
    bad_dur = (df["resolution_hrs"] <= 0).sum()
    df = df[df["resolution_hrs"] > 0].copy()

    # 3. Impute missing root causes
    null_rc = df["root_cause"].isna().sum()
    df["root_cause"] = df["root_cause"].fillna("Unclassified")

    # 4. Score SLA Compliance
    df["sla_breached"] = (df["resolution_hrs"] > df["sla_target_hrs"]).astype(int)
    df["sla_status"] = np.where(df["sla_breached"] == 1, "Breached", "Met")
    df["breach_excess_hrs"] = np.maximum(0, df["resolution_hrs"] - df["sla_target_hrs"]).round(2)
    df["ticket_month"] = df["created_at"].dt.to_period("M").astype(str)

    df.to_csv(CLEAN_PATH, index=False)
    print(f"SLA Pipeline Complete | Raw: {raw_rows} | Clean: {len(df)} | Dups: {dups} | Bad Duration: {bad_dur} | Null Root Cause Imputed: {null_rc}")

if __name__ == "__main__":
    run_sla_pipeline()
