"""Supervised categorical encoders (Bayesian target encoding, WOE)."""

from __future__ import annotations

import numpy as np
import pandas as pd
from sklearn.base import BaseEstimator, TransformerMixin
from sklearn.utils.validation import check_is_fitted

_MISSING_TOKEN = "__missing__"


class BayesianTargetEncoder(BaseEstimator, TransformerMixin):
    """Target encoding with Bayesian (credibility) smoothing toward the global mean.

    For each category ``c`` the encoded value is a weighted average between the
    category's observed target mean and the global target mean::

        weight_c = n_c / (n_c + smoothing)
        encoded_c = weight_c * mean_c + (1 - weight_c) * global_mean

    ``smoothing`` is the number of "virtual" observations of the global mean
    added to every category: larger values shrink low-frequency categories
    harder toward the global mean, which limits overfitting on rare categories.
    Categories unseen at transform time fall back to the global mean.
    """

    def __init__(self, smoothing: float = 20.0):
        self.smoothing = smoothing

    def fit(self, X, y):
        """Fit per-category smoothed target means using training data only."""
        X = self._to_dataframe(X)
        y = pd.Series(np.asarray(y), index=X.index)

        self.feature_names_in_ = np.array(X.columns, dtype=object)
        self.global_mean_ = float(y.mean())
        self.mappings_ = {}

        for col in X.columns:
            valores = X[col].astype("object").fillna(_MISSING_TOKEN)
            stats = y.groupby(valores).agg(["mean", "count"])
            weight = stats["count"] / (stats["count"] + self.smoothing)
            encoded = weight * stats["mean"] + (1 - weight) * self.global_mean_
            self.mappings_[col] = encoded.to_dict()

        return self

    def transform(self, X):
        """Map categories to their smoothed target-encoded value."""
        check_is_fitted(self, "mappings_")
        X = self._to_dataframe(X)

        encoded = pd.DataFrame(index=X.index)
        for col in self.feature_names_in_:
            mapping = self.mappings_[col]
            encoded[col] = (
                X[col]
                .astype("object")
                .fillna(_MISSING_TOKEN)
                .map(mapping)
                .fillna(self.global_mean_)
                .astype(float)
            )

        return encoded.to_numpy()

    def get_feature_names_out(self, input_features=None):
        """Return output feature names for sklearn pipelines."""
        check_is_fitted(self, "mappings_")
        names = input_features if input_features is not None else self.feature_names_in_
        return np.asarray([f"{name}_target_enc" for name in names], dtype=object)

    @staticmethod
    def _to_dataframe(X) -> pd.DataFrame:
        return X if isinstance(X, pd.DataFrame) else pd.DataFrame(X)


class WOEEncoder(BaseEstimator, TransformerMixin):
    """Weight of Evidence encoding with credibility-based smoothing.

    Assumes a binary target where ``1`` is the event of interest (in this
    project: obra paralizada). For each category ``c``, using counts observed
    in the training fold::

        dist_event_c = (n_event_c + eps) / (n_event_total + eps * n_categorias)
        dist_nonevent_c = (n_nonevent_c + eps) / (n_nonevent_total + eps * n_categorias)
        raw_woe_c = ln(dist_event_c / dist_nonevent_c)

    ``eps`` is a Laplace/additive correction that avoids ``log(0)`` for
    categories with zero events or zero non-events, while keeping each
    distribution summing to ~1 across categories.

    The raw WOE is then shrunk toward 0 (the WOE of an "average" category)
    using the same credibility-weight formula as :class:`BayesianTargetEncoder`,
    so both encoders share the same smoothing semantics::

        weight_c = n_c / (n_c + smoothing)
        woe_c = weight_c * raw_woe_c

    Categories unseen at transform time get the neutral WOE value (0).

    The Information Value per fitted column is stored in ``iv_``, a standard
    diagnostic of how predictive a categorical variable is on its own
    (rule of thumb: <0.02 not predictive, 0.02-0.1 weak, 0.1-0.3 medium,
    0.3-0.5 strong, >0.5 suspiciously strong / possible leakage)::

        IV = sum_c (dist_event_c - dist_nonevent_c) * raw_woe_c
    """

    def __init__(self, smoothing: float = 20.0, eps: float = 0.5):
        self.smoothing = smoothing
        self.eps = eps

    def fit(self, X, y):
        """Fit per-category smoothed WOE values and Information Value using training data only."""
        X = self._to_dataframe(X)
        y = pd.Series(np.asarray(y), index=X.index).astype(int)

        self.feature_names_in_ = np.array(X.columns, dtype=object)
        self.mappings_ = {}
        self.iv_ = {}

        n_event_total = float((y == 1).sum())
        n_nonevent_total = float((y == 0).sum())

        for col in X.columns:
            categorias = X[col].astype("object").fillna(_MISSING_TOKEN)
            n_categorias = categorias.nunique()

            resumen = pd.DataFrame({"categoria": categorias.to_numpy(), "target": y.to_numpy()})
            conteos = resumen.groupby("categoria")["target"].agg(n_event="sum", n="count")
            conteos["n_nonevent"] = conteos["n"] - conteos["n_event"]

            dist_event = (conteos["n_event"] + self.eps) / (n_event_total + self.eps * n_categorias)
            dist_nonevent = (conteos["n_nonevent"] + self.eps) / (n_nonevent_total + self.eps * n_categorias)

            raw_woe = np.log(dist_event / dist_nonevent)
            weight = conteos["n"] / (conteos["n"] + self.smoothing)
            woe_suavizado = weight * raw_woe

            self.mappings_[col] = woe_suavizado.to_dict()
            self.iv_[col] = float(((dist_event - dist_nonevent) * raw_woe).sum())

        return self

    def transform(self, X):
        """Map categories to their smoothed WOE value (0 for unseen categories)."""
        check_is_fitted(self, "mappings_")
        X = self._to_dataframe(X)

        encoded = pd.DataFrame(index=X.index)
        for col in self.feature_names_in_:
            mapping = self.mappings_[col]
            encoded[col] = (
                X[col]
                .astype("object")
                .fillna(_MISSING_TOKEN)
                .map(mapping)
                .fillna(0.0)
                .astype(float)
            )

        return encoded.to_numpy()

    def get_feature_names_out(self, input_features=None):
        """Return output feature names for sklearn pipelines."""
        check_is_fitted(self, "mappings_")
        names = input_features if input_features is not None else self.feature_names_in_
        return np.asarray([f"{name}_woe" for name in names], dtype=object)

    @staticmethod
    def _to_dataframe(X) -> pd.DataFrame:
        return X if isinstance(X, pd.DataFrame) else pd.DataFrame(X)
