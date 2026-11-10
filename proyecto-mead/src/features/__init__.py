"""Feature engineering utilities."""

from src.features.design_matrix import columnas_sin_colinealidad, seleccionar_columnas_por_grupo
from src.features.encoders import BayesianTargetEncoder, WOEEncoder
from src.features.preprocessing import (
    build_categorical_pipeline,
    build_numeric_pipeline,
    build_preprocessor,
    build_target_encoding_pipeline,
    build_winsor_log_pipeline,
    build_woe_pipeline,
)
from src.features.ratios import RatioSpec, add_ratio_features, safe_divide
from src.features.transformers import WinsorLogTransformer

__all__ = [
    "BayesianTargetEncoder",
    "RatioSpec",
    "WOEEncoder",
    "WinsorLogTransformer",
    "add_ratio_features",
    "build_categorical_pipeline",
    "build_numeric_pipeline",
    "build_preprocessor",
    "build_target_encoding_pipeline",
    "build_winsor_log_pipeline",
    "build_woe_pipeline",
    "columnas_sin_colinealidad",
    "safe_divide",
    "seleccionar_columnas_por_grupo",
]
