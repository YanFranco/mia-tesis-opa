"""Categorical feature analysis utilities."""

from __future__ import annotations

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns


def summarize_categorical_target_relationship(
    data: pd.DataFrame,
    categorical_column: str,
    target_column: str,
    min_count: int = 20,
    missing_label: str = "MISSING",
) -> pd.DataFrame:
    """
    Summarize the relationship between a categorical column and a binary target.

    Args:
        data: DataFrame containing the categorical and target columns.
        categorical_column: Name of the categorical column to analyze.
        target_column: Name of the binary target column.
        min_count: Minimum number of rows required to avoid marking a category as rare.
        missing_label: Label used to replace missing categorical values.

    Returns:
        DataFrame with count, target rate, lift, sample percentage and rare-category flag.
    """
    analysis_data = data[[categorical_column, target_column]].copy()

    analysis_data[categorical_column] = (
        analysis_data[categorical_column]
        .astype("object")
        .fillna(missing_label)
    )

    analysis_data[target_column] = analysis_data[target_column].astype(int)

    global_target_rate = analysis_data[target_column].mean()

    summary = (
        analysis_data
        .groupby(categorical_column, dropna=False)
        .agg(
            count=(target_column, "size"),
            target_count=(target_column, "sum"),
            target_rate=(target_column, "mean"),
        )
        .reset_index()
    )

    summary["sample_percentage"] = summary["count"] / len(analysis_data)
    summary["lift_vs_global"] = summary["target_rate"] / global_target_rate
    summary["is_rare_category"] = summary["count"] < min_count

    return summary.sort_values(
        by=["is_rare_category", "target_rate", "count"],
        ascending=[True, False, False],
    )


def plot_categorical_target_relationship(
    summary: pd.DataFrame,
    categorical_column: str,
    top_n: int = 20,
    figsize: tuple[int, int] = (16, 6),
) -> None:
    """
    Plot category frequency and target rate for the most frequent categories.

    Args:
        summary: Output from summarize_categorical_target_relationship.
        categorical_column: Name of the categorical column analyzed.
        top_n: Number of most frequent categories to plot.
        figsize: Matplotlib figure size.
    """
    global_target_rate = (
        summary["target_count"].sum() / summary["count"].sum()
    )

    top_categories = (
        summary
        .sort_values("count", ascending=False)
        .head(top_n)[categorical_column]
        .tolist()
    )

    plot_data = summary[summary[categorical_column].isin(top_categories)].copy()
    plot_data = plot_data.sort_values("target_rate", ascending=False)

    fig, axes = plt.subplots(1, 2, figsize=figsize)

    sns.barplot(
        data=plot_data,
        y=categorical_column,
        x="count",
        ax=axes[0],
        color="#4C72B0",
    )
    axes[0].set_title(f"Frequency by category - {categorical_column}")
    axes[0].set_xlabel("Number of records")
    axes[0].set_ylabel("")

    sns.barplot(
        data=plot_data,
        y=categorical_column,
        x="target_rate",
        ax=axes[1],
        color="#DD8452",
    )
    axes[1].axvline(
        global_target_rate,
        color="black",
        linestyle="--",
        label=f"Global rate = {global_target_rate:.3f}",
    )
    axes[1].set_title(f"Target rate by category - {categorical_column}")
    axes[1].set_xlabel("Target rate")
    axes[1].set_ylabel("")
    axes[1].legend()

    plt.tight_layout()
    plt.show()


def analyze_categorical_vs_target(
    data: pd.DataFrame,
    categorical_column: str,
    target_column: str,
    min_count: int = 20,
    top_n: int = 20,
) -> pd.DataFrame:
    """
    Analyze and plot the relationship between a categorical column and a binary target.

    Args:
        data: DataFrame containing the categorical and target columns.
        categorical_column: Name of the categorical column to analyze.
        target_column: Name of the binary target column.
        min_count: Minimum number of rows required to avoid marking a category as rare.
        top_n: Number of most frequent categories to plot.

    Returns:
        Summary DataFrame.
    """
    summary = summarize_categorical_target_relationship(
        data=data,
        categorical_column=categorical_column,
        target_column=target_column,
        min_count=min_count,
    )

    plot_categorical_target_relationship(
        summary=summary,
        categorical_column=categorical_column,
        top_n=top_n,
    )

    return summary
