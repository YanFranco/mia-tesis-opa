"""Custom scikit-learn transformers for feature engineering."""

from __future__ import annotations

import numpy as np
from sklearn.base import BaseEstimator, TransformerMixin
from sklearn.utils.validation import check_array, check_is_fitted


class WinsorLogTransformer(BaseEstimator, TransformerMixin):
    """Winsorize numeric features by upper quantile and apply log1p."""

    def __init__(self, upper_quantile: float = 0.99):
        self.upper_quantile = upper_quantile

    def fit(self, X, y=None):
        """Learn upper bounds from training data."""
        self._validate_parameters()
        values = check_array(X, accept_sparse=False, dtype=float, ensure_all_finite="allow-nan")
        self.upper_bounds_ = np.nanquantile(values, self.upper_quantile, axis=0)
        self.n_features_in_ = values.shape[1]
        return self

    def transform(self, X):
        """Apply learned winsorization bounds and log1p transformation."""
        check_is_fitted(self, "upper_bounds_")
        values = check_array(X, accept_sparse=False, dtype=float, ensure_all_finite="allow-nan")
        clipped_values = np.minimum(values, self.upper_bounds_)
        return np.log1p(clipped_values)

    def get_feature_names_out(self, input_features=None):
        """Return output feature names for sklearn pipelines."""
        check_is_fitted(self, "upper_bounds_")

        if input_features is None:
            input_features = [f"x{i}" for i in range(self.n_features_in_)]

        return np.asarray([f"{feature}_winsor_log" for feature in input_features], dtype=object)

    def _validate_parameters(self) -> None:
        if not 0 < self.upper_quantile <= 1:
            raise ValueError("upper_quantile must be in the interval (0, 1].")
