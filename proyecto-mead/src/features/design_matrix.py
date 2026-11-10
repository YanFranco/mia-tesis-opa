"""Helpers to select/shape already-encoded feature matrices for modeling.

These operate on feature names produced by a `ColumnTransformer` built with
`verbose_feature_names_out=True` (names of the form ``"<grupo>__<columna>"``),
such as the one built by `src.features.preprocessing.build_preprocessor`.
"""

from __future__ import annotations

from collections.abc import Sequence


def seleccionar_columnas_por_grupo(
    feature_names: Sequence[str],
    grupos_activos: Sequence[str],
) -> list[str]:
    """Keep only feature names whose ColumnTransformer group prefix is active.

    `grupos_activos` are ColumnTransformer transformer names (the prefix
    before ``"__"``), e.g. ``["amount_log", "target_encoded", "woe"]``.
    """
    grupos_activos = set(grupos_activos)
    return [name for name in feature_names if name.split("__", 1)[0] in grupos_activos]


def columnas_sin_colinealidad(
    feature_names: Sequence[str],
    columnas_categoricas: Sequence[str],
    prefijo: str = "categorical__",
) -> list[str]:
    """Drop one dummy column per one-hot-encoded original column.

    Models that add an explicit intercept (GLM/GAM fit with `statsmodels`)
    become rank-deficient if every one-hot level is kept alongside a constant
    term, since the dummies of each encoded column always sum to 1. This
    drops the first dummy found per original categorical column (used as the
    reference/baseline category) and leaves every other feature untouched.
    """
    grupos_vistos: set[str] = set()
    resultado: list[str] = []

    for name in feature_names:
        if not name.startswith(prefijo):
            resultado.append(name)
            continue

        resto = name[len(prefijo):]
        grupo = next((col for col in columnas_categoricas if resto.startswith(col)), None)

        if grupo is None:
            resultado.append(name)
        elif grupo in grupos_vistos:
            resultado.append(name)
        else:
            grupos_vistos.add(grupo)  # se descarta esta (categoria de referencia)

    return resultado
