"""Reusable sklearn preprocessing pipelines."""

from __future__ import annotations

from collections.abc import Sequence

from sklearn.compose import ColumnTransformer
from sklearn.impute import SimpleImputer
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler

from src.features.encoders import BayesianTargetEncoder, WOEEncoder
from src.features.transformers import WinsorLogTransformer


def build_winsor_log_pipeline(
    imputation_strategy: str = "median",
    upper_quantile: float = 0.99,
    with_mean: bool = True,
    with_std: bool = True,
) -> Pipeline:
    """Build a numeric pipeline for skewed amount-like variables."""
    return Pipeline(
        steps=[
            ("imputer", SimpleImputer(strategy=imputation_strategy)),
            ("winsor_log", WinsorLogTransformer(upper_quantile=upper_quantile)),
            ("scaler", StandardScaler(with_mean=with_mean, with_std=with_std)),
        ]
    )


def build_numeric_pipeline(
    imputation_strategy: str = "median",
    with_mean: bool = True,
    with_std: bool = True,
) -> Pipeline:
    """Build a standard numeric preprocessing pipeline."""
    return Pipeline(
        steps=[
            ("imputer", SimpleImputer(strategy=imputation_strategy)),
            ("scaler", StandardScaler(with_mean=with_mean, with_std=with_std)),
        ]
    )


def build_categorical_pipeline(
    imputation_strategy: str = "most_frequent",
    handle_unknown: str = "infrequent_if_exist",
    min_frequency: int | float | None = 20,
    sparse_output: bool = True,
) -> Pipeline:
    """Build a categorical preprocessing pipeline with one-hot encoding."""
    return Pipeline(
        steps=[
            ("imputer", SimpleImputer(strategy=imputation_strategy)),
            (
                "onehot",
                OneHotEncoder(
                    handle_unknown=handle_unknown,
                    min_frequency=min_frequency,
                    sparse_output=sparse_output,
                ),
            ),
        ]
    )


def build_target_encoding_pipeline(smoothing: float = 20.0) -> Pipeline:
    """Build a pipeline for Bayesian target encoding of categorical columns.

    Missing values are treated as their own category by the encoder itself,
    so no imputer step is needed ahead of it. The encoded output is
    standardized so it sits on a comparable scale to the amount/numeric
    groups: an unscaled encoder output (e.g. raw rates in [0, 1]) would be
    penalized unfairly relative to other features in an L1/L2-penalized
    model, since the penalty acts on raw coefficient magnitude.
    """
    return Pipeline(
        steps=[
            ("target_encoder", BayesianTargetEncoder(smoothing=smoothing)),
            ("scaler", StandardScaler()),
        ]
    )


def build_woe_pipeline(smoothing: float = 20.0, eps: float = 0.5) -> Pipeline:
    """Build a pipeline for Weight-of-Evidence encoding of categorical columns.

    Missing values are treated as their own category by the encoder itself,
    so no imputer step is needed ahead of it. The encoded output is
    standardized for the same reason as `build_target_encoding_pipeline`:
    fair treatment under L1/L2 penalization and comparable coefficient scales.
    """
    return Pipeline(
        steps=[
            ("woe_encoder", WOEEncoder(smoothing=smoothing, eps=eps)),
            ("scaler", StandardScaler()),
        ]
    )


def build_preprocessor(
    amount_log_columns: Sequence[str] | None = None,
    numeric_columns: Sequence[str] | None = None,
    categorical_columns: Sequence[str] | None = None,
    target_encoded_columns: Sequence[str] | None = None,
    woe_columns: Sequence[str] | None = None,
    remainder: str = "drop",
    upper_quantile: float = 0.99,
    min_category_frequency: int | float | None = 20,
    target_encoding_smoothing: float = 20.0,
    woe_smoothing: float = 20.0,
    woe_eps: float = 0.5,
) -> ColumnTransformer:
    """Build a ColumnTransformer for feature engineering and preprocessing.

    `target_encoded_columns` and `woe_columns` are fit using the target `y`
    passed to `ColumnTransformer.fit`/`fit_transform`, so this preprocessor
    must be fit on the training split only (e.g. as the first step of a
    `Pipeline`, or via `fit_transform(X_train, y_train)` directly) to avoid
    target leakage into validation/test data.
    """
    transformers = []

    if amount_log_columns:
        transformers.append(
            (
                "amount_log",
                build_winsor_log_pipeline(upper_quantile=upper_quantile),
                list(amount_log_columns),
            )
        )

    if numeric_columns:
        transformers.append(
            (
                "numeric_standard",
                build_numeric_pipeline(),
                list(numeric_columns),
            )
        )

    if categorical_columns:
        transformers.append(
            (
                "categorical",
                build_categorical_pipeline(min_frequency=min_category_frequency),
                list(categorical_columns),
            )
        )

    if target_encoded_columns:
        transformers.append(
            (
                "target_encoded",
                build_target_encoding_pipeline(smoothing=target_encoding_smoothing),
                list(target_encoded_columns),
            )
        )

    if woe_columns:
        transformers.append(
            (
                "woe",
                build_woe_pipeline(smoothing=woe_smoothing, eps=woe_eps),
                list(woe_columns),
            )
        )

    return ColumnTransformer(
        transformers=transformers,
        remainder=remainder,
        verbose_feature_names_out=True,
    )
