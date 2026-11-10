"""Reusable evaluation helpers for binary classification with class imbalance.

Shared by the modeling notebooks (`03_feature_engineering.ipynb`,
`04_modeling.ipynb`) so metric/plot logic is defined once.
"""

from __future__ import annotations

from typing import Any

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from IPython.display import Markdown, display
from sklearn.calibration import calibration_curve
from sklearn.metrics import (
    ConfusionMatrixDisplay,
    PrecisionRecallDisplay,
    RocCurveDisplay,
    average_precision_score,
    brier_score_loss,
    classification_report,
    f1_score,
    fbeta_score,
    precision_score,
    recall_score,
    roc_auc_score,
)

DISPLAY_LABELS = ["No paralizada", "Paralizada"]


def calcular_metricas_binarias(y_true, y_pred, y_proba) -> dict[str, float]:
    """Metricas de clasificacion binaria: discriminacion (ROC/PR AUC, Gini),
    calibracion (Brier score) y decision a un umbral fijo (precision/recall/F1/F2).

    El objetivo de este proyecto es estimar una probabilidad de riesgo
    (`P(Y=1|X)`), no solo clasificar, por lo que el Brier score (menor es
    mejor: error cuadratico medio entre la probabilidad predicha y el
    resultado observado) se reporta junto a las metricas de discriminacion
    y decision, no como algo secundario: dos modelos con AUC similar pueden
    tener probabilidades muy distintas de confiables.
    """
    roc_auc = roc_auc_score(y_true, y_proba)
    return {
        "roc_auc": roc_auc,
        "pr_auc": average_precision_score(y_true, y_proba),
        "gini": 2 * roc_auc - 1,
        "brier_score": brier_score_loss(y_true, y_proba),
        "precision": precision_score(y_true, y_pred, zero_division=0),
        "recall": recall_score(y_true, y_pred, zero_division=0),
        "f1": f1_score(y_true, y_pred, zero_division=0),
        "f2": fbeta_score(y_true, y_pred, beta=2, zero_division=0),
    }


def graficar_curvas_roc_pr(y_true, y_proba, nombre_modelo: str = "modelo") -> None:
    """Plot ROC, Precision-Recall and calibration curves side by side for one model."""
    fig, axes = plt.subplots(1, 3, figsize=(15.5, 4.5))

    RocCurveDisplay.from_predictions(y_true, y_proba, ax=axes[0], name=nombre_modelo)
    axes[0].plot([0, 1], [0, 1], linestyle="--", color="grey", label="Azar")
    axes[0].set_title("Curva ROC (discriminacion)")
    axes[0].legend()

    PrecisionRecallDisplay.from_predictions(y_true, y_proba, ax=axes[1], name=nombre_modelo)
    tasa_positiva = np.mean(y_true)
    axes[1].axhline(tasa_positiva, linestyle="--", color="grey", label=f"Azar ({tasa_positiva:.2%})")
    axes[1].set_title("Curva Precision-Recall (discriminacion)")
    axes[1].legend()

    prob_true, prob_pred = calibration_curve(y_true, y_proba, n_bins=10, strategy="quantile")
    axes[2].plot(prob_pred, prob_true, marker="o", label=nombre_modelo)
    axes[2].plot([0, 1], [0, 1], linestyle="--", color="grey", label="Calibracion perfecta")
    axes[2].set_xlabel("Probabilidad predicha (promedio por bin)")
    axes[2].set_ylabel("Frecuencia observada")
    axes[2].set_title("Curva de calibracion")
    axes[2].legend()

    plt.tight_layout()
    plt.show()


def graficar_calibracion_comparativa(
    y_true,
    probas_por_modelo: dict[str, np.ndarray],
    n_bins: int = 10,
) -> None:
    """Overlay calibration curves for several models on one plot, for direct comparison.

    `probas_por_modelo` maps a model label to its predicted probabilities on
    the same `y_true`. Useful to see which model's probabilities are closest
    to the diagonal (well calibrated) regardless of how well it discriminates.
    """
    fig, ax = plt.subplots(figsize=(6.5, 6))
    ax.plot([0, 1], [0, 1], linestyle="--", color="grey", label="Calibracion perfecta")

    for nombre, y_proba in probas_por_modelo.items():
        prob_true, prob_pred = calibration_curve(y_true, y_proba, n_bins=n_bins, strategy="quantile")
        ax.plot(prob_pred, prob_true, marker="o", label=nombre)

    ax.set_xlabel("Probabilidad predicha (promedio por bin)")
    ax.set_ylabel("Frecuencia observada")
    ax.set_title("Comparacion de calibracion entre modelos")
    ax.legend(fontsize=8)
    plt.tight_layout()
    plt.show()


def reporte_evaluacion(y_true, y_pred, y_proba, nombre_modelo: str = "modelo") -> dict[str, float]:
    """Imprime metricas (incl. Brier), reporte de clasificacion, matriz de confusion y curvas ROC/PR/calibracion."""
    metricas = calcular_metricas_binarias(y_true, y_pred, y_proba)
    display(Markdown(f"**Metricas globales - {nombre_modelo}**"))
    display(Markdown(pd.Series(metricas, name="valor").to_frame().round(4).to_markdown()))

    reporte = classification_report(y_true, y_pred, output_dict=True, zero_division=0)
    display(Markdown(f"**Reporte de clasificacion - {nombre_modelo}**"))
    display(Markdown(pd.DataFrame(reporte).T.round(3).to_markdown()))

    fig, ax = plt.subplots(figsize=(4.5, 4))
    ConfusionMatrixDisplay.from_predictions(
        y_true, y_pred,
        display_labels=DISPLAY_LABELS,
        cmap="Blues", colorbar=False, ax=ax,
    )
    ax.set_title(f"Matriz de confusion - {nombre_modelo}")
    plt.tight_layout()
    plt.show()

    graficar_curvas_roc_pr(y_true, y_proba, nombre_modelo=nombre_modelo)

    return metricas


def analizar_umbrales(y_true, y_proba, umbrales: np.ndarray | None = None) -> pd.DataFrame:
    """Calcula precision/recall/F1/F2 para una grilla de umbrales de decision."""
    if umbrales is None:
        umbrales = np.arange(0.05, 0.96, 0.01)

    filas: list[dict[str, Any]] = []
    for u in umbrales:
        y_pred_u = (np.asarray(y_proba) >= u).astype(int)
        filas.append({
            "umbral": u,
            "precision": precision_score(y_true, y_pred_u, zero_division=0),
            "recall": recall_score(y_true, y_pred_u, zero_division=0),
            "f1": f1_score(y_true, y_pred_u, zero_division=0),
            "f2": fbeta_score(y_true, y_pred_u, beta=2, zero_division=0),
        })
    return pd.DataFrame(filas)


def graficar_umbrales(df_umbrales: pd.DataFrame, nombre_modelo: str = "modelo") -> tuple[pd.Series, pd.Series]:
    """Grafica las metricas vs. el umbral y marca el mejor umbral segun F1 y F2."""
    fig, ax = plt.subplots(figsize=(8, 5))
    for metrica in ["precision", "recall", "f1", "f2"]:
        ax.plot(df_umbrales["umbral"], df_umbrales[metrica], label=metrica)

    mejor_f1 = df_umbrales.loc[df_umbrales["f1"].idxmax()]
    mejor_f2 = df_umbrales.loc[df_umbrales["f2"].idxmax()]

    ax.axvline(mejor_f1["umbral"], linestyle="--", color="tab:orange", alpha=0.7,
               label=f"Mejor F1 @ {mejor_f1['umbral']:.2f}")
    ax.axvline(mejor_f2["umbral"], linestyle="--", color="tab:red", alpha=0.7,
               label=f"Mejor F2 @ {mejor_f2['umbral']:.2f}")
    ax.axvline(0.5, linestyle=":", color="grey", alpha=0.7, label="Umbral por defecto (0.5)")

    ax.set_xlabel("Umbral de decision")
    ax.set_ylabel("Score")
    ax.set_ylim(0, 1)
    ax.set_title(f"Metricas vs. umbral de decision - {nombre_modelo}")
    ax.legend()
    plt.tight_layout()
    plt.show()

    return mejor_f1, mejor_f2
