"""Missing values analysis utilities."""

from __future__ import annotations

import pandas as pd


def missing_values_report(data: pd.DataFrame) -> pd.DataFrame:
    """
    Generate a report with missing value counts and percentages by column.

    Args:
        data: DataFrame to analyze.

    Returns:
        DataFrame containing only columns with missing values, sorted by percentage descending.
    """
    if data.empty:
        return pd.DataFrame(columns=["missing_count", "missing_percentage"])

    missing_count = data.isna().sum()
    missing_percentage = (missing_count / len(data)) * 100

    report = pd.DataFrame(
        {
            "missing_count": missing_count,
            "missing_percentage": missing_percentage,
        }
    )

    return (
        report[report["missing_count"] > 0]
        .sort_values(by="missing_percentage", ascending=False)
        .round(2)
    )