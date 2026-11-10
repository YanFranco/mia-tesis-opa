# CLAUDE.md

This is a master's thesis project (UNI, MIA): predicting contract breach (incumplimiento contractual) in Peruvian public works (OPA / obras públicas, Infobras). Code, comments and docs are in Spanish; keep new content in Spanish.

## Layout
- `src/`: a reusable Python package that notebooks import as `from src.<module> import ...`. Notebooks add the project root to `sys.path`; there is no `setup.py`.
  - `db/connection.py`: `PostgresConnection` (psycopg). Config comes from `configs/database.ini` or YAML.
  - `eda/`: `missing_values_report` and `analyze_categorical_vs_target` (re-exported in `src/eda/__init__.py`).
  - `features/`: sklearn pipelines (`preprocessing.build_preprocessor`, winsor+log, numeric, categorical), custom encoders (`BayesianTargetEncoder`, `WOEEncoder`), `WinsorLogTransformer`, ratio features (`RatioSpec`, `safe_divide`) and collinearity helpers (`design_matrix`).
  - `evaluation/`: binary-classification metrics, ROC/PR, calibration and threshold analysis (`metrics.py`). Also variable importance for sklearn linear models, statsmodels GLM/GAM and trees (`importance.py`).
  - `experiments/tracking.py`: `create_experiment_run` / `find_latest_experiment_run`. These persist config, metrics, models and CSVs under `artifacts/experiments/<timestamp>_<slug>/` relative to the CWD, so runs from `notebooks/` end up in `notebooks/artifacts/`.
- `notebooks/`: the main pipeline, numbered in order:
  - `01_etl_igeip_inco_integration`: merges IGEIP + INCO into `data/gold/ds_op_inco_igeip.csv`
  - `02_eda`
  - `03_0x_feature_engineering*`
  - `04_modeling`

  `* copy*.ipynb` and `old/` are scratch versions.
- `data/`: `raw/igeip/*.xlsx`, `raw/inco/inco-2024.xlsx` and `gold/`. Gitignored.
- `docs/data_dictionary.md`: dataset dictionary.
- `mead_project/`: final project for the MEAD course (statistical modeling: GLM with cloglog, GAM, nested CV). It holds:
  - notebooks `proyecto_final_modelado*.ipynb`
  - a Typst report (`informe/Informe_Final_MIES.typ` + `.bib`)
  - Typst slides (`presentacion/main.typ`)
  - requirements in `instrucciones.md`
- `proyecto-mead/`: a standalone copy of `src/` + dataset + notebook for delivering the MEAD project. `src/` is currently identical to `proyecto-mead/src/`, so change both if needed.
- `tesis/`: thesis plan in Typst (`plan/main.typ`, `ref.bib`) and the university formatting rules (`formato/*.md`).

## Key conventions
- Main target: `flg_opa_incumplimiento_contractual` (binary, imbalanced). Use a temporal train/test split.
- Reproducibility: fixed seeds; preprocessing goes inside sklearn `Pipeline`/`ColumnTransformer`, so target/WOE encoders are fit on train only.
- Function names mix Spanish (`calcular_metricas_binarias`) and English (`build_preprocessor`). Follow the style of the module you edit.

## Environment
- Python 3.13 venv in `.venv/`. Install with `pip install -r requirement.txt` (note: singular file name).
- There are no tests, linter or build. Work is run interactively in Jupyter.
- Typst documents compile with `typst compile <file>.typ`. The `typst` CLI is not on PATH, so it is likely compiled through the VS Code extension.
- `.gitignore` excludes data, CSV/XLSX/joblib files and `artifacts/*`. `configs/database.ini` contains local credentials: do not commit them.
