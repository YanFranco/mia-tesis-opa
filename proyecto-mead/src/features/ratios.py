"""Utilities for row-level ratio features."""

from __future__ import annotations

from dataclasses import dataclass

import numpy as np
import pandas as pd


@dataclass(frozen=True)
class RatioSpec:
    """Definition of a ratio feature."""

    numerator: str
    denominator: str
    output_column: str
    fill_value: float = 0.0


def safe_divide(
    numerator: pd.Series,
    denominator: pd.Series,
    fill_value: float = 0.0,
) -> pd.Series:
    """Divide two series and replace invalid values with a fallback value."""
    result = numerator.astype(float).div(denominator.astype(float).replace(0, np.nan))
    return result.replace([np.inf, -np.inf], np.nan).fillna(fill_value)


def add_ratio_features(data: pd.DataFrame, ratio_specs: list[RatioSpec]) -> pd.DataFrame:
    """Return a copy of the DataFrame with row-level ratio features added."""
    transformed_data = data.copy()

    for spec in ratio_specs:
        transformed_data[spec.output_column] = safe_divide(
            numerator=transformed_data[spec.numerator],
            denominator=transformed_data[spec.denominator],
            fill_value=spec.fill_value,
        )

    return transformed_data
