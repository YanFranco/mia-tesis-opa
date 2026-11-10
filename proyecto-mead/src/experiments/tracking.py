"""Utilities to persist machine learning experiment artifacts."""

from __future__ import annotations

import json
import re
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import Any

import yaml


DEFAULT_EXPERIMENTS_DIR = Path("artifacts") / "experiments"


def _slugify(value: str) -> str:
    """Convert a text value into a filesystem-friendly slug."""
    value = value.strip().lower()
    value = re.sub(r"[^a-z0-9]+", "_", value)
    return value.strip("_") or "experiment"


def _json_default(value: Any) -> Any:
    """Convert common scientific Python scalar values before JSON serialization."""
    if hasattr(value, "item"):
        return value.item()
    if hasattr(value, "tolist"):
        return value.tolist()
    return str(value)


@dataclass(frozen=True)
class ExperimentRun:
    """Represents one experiment run and its output directory."""

    experiment_id: str
    path: Path

    def save_config(self, config: dict[str, Any], filename: str = "config.yaml") -> Path:
        """Save experiment configuration as YAML."""
        output_path = self.path / filename
        output_path.write_text(
            yaml.safe_dump(config, sort_keys=False, allow_unicode=True),
            encoding="utf-8",
        )
        return output_path

    def save_metrics(self, metrics: dict[str, Any], filename: str = "metrics.json") -> Path:
        """Save experiment metrics as JSON."""
        output_path = self.path / filename
        output_path.write_text(
            json.dumps(metrics, indent=2, ensure_ascii=False, default=_json_default),
            encoding="utf-8",
        )
        return output_path

    def save_json(self, data: dict[str, Any], filename: str) -> Path:
        """Save any JSON-serializable dictionary."""
        output_path = self.path / filename
        output_path.write_text(
            json.dumps(data, indent=2, ensure_ascii=False, default=_json_default),
            encoding="utf-8",
        )
        return output_path

    def save_dataframe_csv(self, dataframe: Any, filename: str, index: bool = False) -> Path:
        """Save a pandas DataFrame as CSV."""
        output_path = self.path / filename
        dataframe.to_csv(output_path, index=index)
        return output_path

    def save_dataframe_parquet(self, dataframe: Any, filename: str, index: bool = False) -> Path:
        """Save a pandas DataFrame as Parquet."""
        output_path = self.path / filename
        dataframe.to_parquet(output_path, index=index)
        return output_path

    def save_model(self, model: Any, filename: str = "model.joblib") -> Path:
        """Save a Python model object using joblib."""
        import joblib

        output_path = self.path / filename
        joblib.dump(model, output_path)
        return output_path

    def save_text(self, text: str, filename: str = "notes.md") -> Path:
        """Save free-form experiment notes."""
        output_path = self.path / filename
        output_path.write_text(text, encoding="utf-8")
        return output_path


def create_experiment_run(
    name: str,
    base_dir: str | Path = DEFAULT_EXPERIMENTS_DIR,
    timestamp: datetime | None = None,
) -> ExperimentRun:
    """Create an experiment directory and return an ExperimentRun helper."""
    timestamp = timestamp or datetime.now()
    experiment_id = f"{timestamp:%Y-%m-%d_%H%M%S}_{_slugify(name)}"
    experiment_path = Path(base_dir) / experiment_id
    experiment_path.mkdir(parents=True, exist_ok=False)
    return ExperimentRun(experiment_id=experiment_id, path=experiment_path)


def find_latest_experiment_run(
    name: str,
    base_dir: str | Path = DEFAULT_EXPERIMENTS_DIR,
) -> ExperimentRun:
    """Find the most recent experiment run whose id ends with `name`'s slug.

    Experiment ids are timestamp-prefixed (`create_experiment_run`), so a
    lexicographic sort of matching directory names also sorts them
    chronologically; the last one is the most recent run.
    """
    base_dir = Path(base_dir)
    slug = _slugify(name)
    candidatos = sorted(
        path for path in base_dir.glob(f"*_{slug}") if path.is_dir()
    )

    if not candidatos:
        raise FileNotFoundError(
            f"No se encontro ninguna corrida de experimento para '{name}' en {base_dir}"
        )

    experiment_path = candidatos[-1]
    return ExperimentRun(experiment_id=experiment_path.name, path=experiment_path)
