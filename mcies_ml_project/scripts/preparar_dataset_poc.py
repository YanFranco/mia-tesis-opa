"""Prepara el extracto Parquet compacto y portable para mcies_ml_project.

Proyecta desde data/gold/ds_obras_publicas/part-00000.parquet las 25 columnas
requeridas por P1-YanFrancoCalderonFelix.ipynb (filtros fijos/configurables,
caracteristicas pre-inicio, control de fuga deliberada y target binario general)
y lo guarda comprimido (ZSTD nivel 9) en mcies_ml_project/data/ds_obras_publicas_poc.parquet.
"""

from __future__ import annotations

import shutil
import time
from pathlib import Path

import duckdb

COLUMNAS_POC = [
    "codigo_infobras",
    "codigo_entidad",
    "nivel_gobierno",
    "sector_entidad",
    "codigo_unico",
    "tipo_formato",
    "n_obras_relacionadas_proyecto",
    "modalidad_ejecucion_obra",
    "estado_ejecucion",
    "naturaleza_obra",
    "tipo_obra_nivel_1",
    "tipo_obra_nivel_2",
    "tipo_obra_nivel_3",
    "fecha_inicio_obra",
    "departamento",
    "provincia",
    "distrito",
    "fecha_aprobacion_expediente",
    "monto_aprobacion_et",
    "monto_aprobado_soles",
    "ruc_1",
    "monto_contrato_soles_eje",
    "ruc_2",
    "monto_contrato_soles_sup",
    "flg_existe_paralizacion",
]


def main() -> None:
    proyecto_root = Path(__file__).resolve().parents[2]
    origen = proyecto_root / "data" / "gold" / "ds_obras_publicas" / "part-00000.parquet"
    destino = proyecto_root / "mcies_ml_project" / "data" / "ds_obras_publicas_poc.parquet"
    tmp_destino = destino.with_suffix(".parquet.tmp")

    assert origen.exists(), f"No existe archivo Gold de origen: {origen}"
    destino.parent.mkdir(parents=True, exist_ok=True)

    cols_sql = ", ".join(COLUMNAS_POC)
    t0 = time.time()
    con = duckdb.connect()
    try:
        con.execute(
            f"COPY (SELECT {cols_sql} FROM read_parquet('{origen.as_posix()}') ORDER BY codigo_infobras) "
            f"TO '{tmp_destino.as_posix()}' (FORMAT PARQUET, COMPRESSION ZSTD, COMPRESSION_LEVEL 9)"
        )
        n_total = con.execute(f"SELECT count(*) FROM read_parquet('{tmp_destino.as_posix()}')").fetchone()[0]
        n_cohorte, n_pos = con.execute(f"""
            SELECT
                count(*),
                count(*) FILTER (WHERE flg_existe_paralizacion)
            FROM read_parquet('{tmp_destino.as_posix()}')
            WHERE estado_ejecucion != 'Sin Ejecución'
              AND fecha_inicio_obra IS NOT NULL
              AND codigo_unico IS NOT NULL
              AND COALESCE(NULLIF(monto_aprobado_soles, 0), monto_aprobacion_et) > 1
        """).fetchone()
    finally:
        con.close()

    shutil.move(str(tmp_destino), str(destino))
    tam_mb = destino.stat().st_size / 1024**2
    print(
        f"OK: {destino} | total={n_total:,} filas x {len(COLUMNAS_POC)} cols | "
        f"cohorte_fija={n_cohorte:,} (pos={n_pos:,}, {100*n_pos/n_cohorte:.2f}%) | "
        f"{tam_mb:.2f} MB | {time.time() - t0:.2f} s"
    )


if __name__ == "__main__":
    main()
