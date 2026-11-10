"""Print/display which variables a fitted model used and how much weight it gave each.

The notion of "weight" is model-specific:
- Linear scikit-learn models (`LogisticRegression`, ...): the fitted coefficient.
- `statsmodels` GLM results (`sm.GLM(...).fit()`): the fitted coefficient and its
  p-value.
- `statsmodels` GAM results (`GLMGam(...).fit()`): the fitted coefficient (and
  p-value) for linear/dummy terms, and the sum of absolute spline-basis
  coefficients per smooth term as an aggregate importance measure (a GAM smooth
  term has several coefficients, one per basis function, not a single slope).
- Tree ensembles (`RandomForestClassifier`, ...): `feature_importances_`
  (mean impurity decrease).
"""

from __future__ import annotations

from collections.abc import Sequence

import numpy as np
import pandas as pd
from IPython.display import Markdown, display

# Interpretacion multiplicativa de exp(coeficiente) segun la funcion de enlace.
# Solo el enlace logit produce un "odds ratio" en sentido estricto. El enlace
# c-loglog (complementary log-log) es el enlace canonico de un modelo de
# riesgos proporcionales en tiempo discreto: exp(coeficiente) se interpreta
# como una razon de riesgos (hazard ratio), no como un odds ratio. El enlace
# probit no tiene una interpretacion multiplicativa simple y cerrada de sus
# coeficientes (se reporta exp(coeficiente) solo como referencia, sin nombre
# de "odds ratio" ni "hazard ratio").
_ETIQUETA_EXP_COEF = {
    "logit": "odds_ratio",
    "cloglog": "razon_riesgo",
    "probit": "exp_coeficiente",
}

_NOTA_EXP_COEF = {
    "logit": "`odds_ratio = exp(coeficiente)`: cuanto se multiplican los momios (odds) de paralizacion por cada unidad de la variable, manteniendo lo demas constante.",
    "cloglog": "`razon_riesgo = exp(coeficiente)`: bajo el enlace c-loglog (modelo de riesgos proporcionales en tiempo discreto), es la razon de riesgos (hazard ratio) de paralizacion por cada unidad de la variable.",
    "probit": "el enlace probit no tiene una interpretacion multiplicativa cerrada tipo odds/hazard ratio; `exp_coeficiente` se reporta solo como referencia. Para probit se suele interpretar el signo/magnitud relativa del coeficiente, o efectos marginales sobre la probabilidad.",
}


def importancia_lineal_sklearn(model, feature_names: Sequence[str], nombre_modelo: str = "modelo") -> pd.DataFrame:
    """Coefficient (+ odds ratio, assumes a logit link) table for a fitted linear scikit-learn classifier."""
    coeficientes = np.ravel(model.coef_)
    tabla = pd.DataFrame({
        "variable": list(feature_names),
        "coeficiente": coeficientes,
    })
    tabla["odds_ratio"] = np.exp(tabla["coeficiente"])
    tabla["abs_coeficiente"] = tabla["coeficiente"].abs()
    tabla = tabla.sort_values("abs_coeficiente", ascending=False).reset_index(drop=True)

    display(Markdown(f"**Variables, coeficientes y odds ratios - {nombre_modelo}**"))
    display(Markdown(_NOTA_EXP_COEF["logit"]))
    display(Markdown(tabla.round(4).to_markdown(index=False)))
    return tabla


def importancia_glm_statsmodels(
    result,
    feature_names: Sequence[str],
    nombre_modelo: str = "modelo",
    incluye_constante: bool = True,
    enlace: str | None = None,
) -> pd.DataFrame:
    """Coefficient + p-value (+ exp(coeficiente), labeled per link) table for a `statsmodels` GLM result.

    `feature_names` must match the column order of the design matrix used to
    fit `result` (excluding the constant, which is added automatically when
    `incluye_constante=True`, matching `sm.add_constant(..., has_constant="add")`
    placing the constant first). `enlace` (one of "logit", "cloglog", "probit")
    controls how `exp(coeficiente)` is labeled/interpreted; if omitted, no
    exponentiated column is added.
    """
    nombres = (["const"] if incluye_constante else []) + list(feature_names)

    tabla = pd.DataFrame({
        "variable": nombres,
        "coeficiente": np.asarray(result.params),
        "p_valor": np.asarray(result.pvalues),
    })
    if enlace is not None:
        etiqueta = _ETIQUETA_EXP_COEF.get(enlace, "exp_coeficiente")
        tabla[etiqueta] = np.exp(tabla["coeficiente"])
    tabla["abs_coeficiente"] = tabla["coeficiente"].abs()
    tabla = tabla.sort_values("abs_coeficiente", ascending=False).reset_index(drop=True)

    display(Markdown(f"**Variables, coeficientes y p-valores - {nombre_modelo}**"))
    if enlace is not None:
        display(Markdown(_NOTA_EXP_COEF.get(enlace, "")))
    display(Markdown(tabla.round(4).to_markdown(index=False)))
    return tabla


def importancia_gam_statsmodels(
    result,
    columnas_lineales: Sequence[str],
    columnas_suaves: Sequence[str],
    smoother,
    nombre_modelo: str = "modelo",
    enlace: str | None = None,
) -> pd.DataFrame:
    """Coefficient/aggregate-importance table for a fitted `GLMGam` result.

    `GLMGam.params` is ordered as: the linear part passed as `exog` (constant
    first, then `columnas_lineales`), followed by the spline-basis
    coefficients concatenated in the order of `smoother.smoothers` (which
    matches `columnas_suaves`). Linear/dummy terms get a direct coefficient,
    p-value and (if `enlace` is given) `exp(coeficiente)` labeled per link,
    same as `importancia_glm_statsmodels`; each smooth term gets an aggregate
    importance (sum of the absolute value of its spline-basis coefficients)
    since it has no single slope, so no exp(coeficiente) is reported for it.
    """
    params = np.asarray(result.params)
    pvalues = np.asarray(result.pvalues)
    etiqueta = _ETIQUETA_EXP_COEF.get(enlace, "exp_coeficiente") if enlace is not None else None

    n_lineal = 1 + len(columnas_lineales)  # +1 = constante
    filas = []

    for nombre, coef, pval in zip(["const"] + list(columnas_lineales), params[:n_lineal], pvalues[:n_lineal]):
        fila = {"variable": nombre, "tipo": "lineal", "peso": coef, "p_valor": pval}
        if etiqueta is not None:
            fila[etiqueta] = np.exp(coef)
        filas.append(fila)

    offset = n_lineal
    for nombre, smoother_termino in zip(columnas_suaves, smoother.smoothers):
        dim = smoother_termino.dim_basis
        bloque = params[offset:offset + dim]
        fila = {"variable": nombre, "tipo": "suave (spline)", "peso": float(np.abs(bloque).sum()), "p_valor": np.nan}
        if etiqueta is not None:
            fila[etiqueta] = np.nan  # no aplica: un termino suave no tiene un unico coeficiente
        filas.append(fila)
        offset += dim

    tabla = pd.DataFrame(filas)
    tabla["abs_peso"] = tabla["peso"].abs()
    tabla = tabla.sort_values("abs_peso", ascending=False).reset_index(drop=True)

    display(Markdown(
        f"**Variables y peso - {nombre_modelo}** "
        "(`peso` = coeficiente para variables lineales/dummy; "
        "suma de |coeficientes de la base de splines| para variables suaves)"
    ))
    if etiqueta is not None:
        display(Markdown(_NOTA_EXP_COEF.get(enlace, "") + " No aplica a los terminos suaves (spline)."))
    display(Markdown(tabla.round(4).to_markdown(index=False)))
    return tabla


def importancia_arbol(model, feature_names: Sequence[str], nombre_modelo: str = "modelo") -> pd.DataFrame:
    """Feature-importance table for a fitted tree-ensemble scikit-learn model."""
    tabla = pd.DataFrame({
        "variable": list(feature_names),
        "importancia": model.feature_importances_,
    }).sort_values("importancia", ascending=False).reset_index(drop=True)

    display(Markdown(f"**Variables e importancia (impureza) - {nombre_modelo}**"))
    display(Markdown(tabla.round(4).to_markdown(index=False)))
    return tabla
