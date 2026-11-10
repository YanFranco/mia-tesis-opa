import argparse
import logging
import shutil
import urllib.error
import urllib.request
from pathlib import Path
from typing import Iterator, Tuple

# Configuración del logger de ejecución
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
logger = logging.getLogger(__name__)

# Ruta de salida por defecto solicitada
DEFAULT_OUTPUT_DIR = Path(r"c:\ws\formacion\uni-mia\mia-tesis-opa\data\raw\cgr")

BASE_URL_TEMPLATE = (
    "https://infobras.contraloria.gob.pe/InfobrasWeb/Archivo/DownloadFile"
    "?filename=DataSet-Obras-Publicas%20{fecha}"
    "&name=DataSet-Obras-Publicas%20{fecha}"
    "&contentType=application%2Fvnd.openxmlformats-officedocument.spreadsheetml.sheet"
    "&extension=.xlsx"
)


def _iterar_periodos(mes_inicial: int, mes_final: int) -> Iterator[Tuple[int, int]]:
    """
    Genera tuplas (anio, mes) desde mes_inicial hasta mes_final (formato YYYYMM).
    Soporta cambios de año (ej. 202411 a 202502).
    """
    if mes_inicial > mes_final:
        raise ValueError(
            f"El mes inicial ({mes_inicial}) no puede ser mayor que el mes final ({mes_final})."
        )

    anio_ini, mes_ini = divmod(mes_inicial, 100)
    anio_fin, mes_fin = divmod(mes_final, 100)

    if not (1 <= mes_ini <= 12) or not (1 <= mes_fin <= 12):
        raise ValueError("Los meses deben estar entre 01 y 12 en formato YYYYMM (ej. 202501).")

    anio_actual, mes_actual = anio_ini, mes_ini
    while (anio_actual, mes_actual) <= (anio_fin, mes_fin):
        yield anio_actual, mes_actual
        if mes_actual == 12:
            anio_actual += 1
            mes_actual = 1
        else:
            mes_actual += 1


def descargar_infobras(
    mes_inicial: int,
    mes_final: int,
    dia: int = 1,
    output_dir: str | Path = DEFAULT_OUTPUT_DIR,
) -> list[Path]:
    """
    Descarga los archivos de Obras Públicas de INFOBRAS (CGR) para un rango de meses.

    Parámetros:
        mes_inicial (int): Mes de inicio en formato YYYYMM (ej. 202501).
        mes_final (int): Mes de fin en formato YYYYMM (ej. 202508).
        dia (int): Día del mes a descargar (ej. 1 -> '01-MM-YYYY').
        output_dir (str | Path): Carpeta destino donde se guardarán los archivos .xlsx.

    Retorna:
        list[Path]: Lista de rutas de los archivos descargados exitosamente.
    """
    if not (1 <= dia <= 31):
        raise ValueError(f"El día debe estar entre 1 y 31 (recibido: {dia}).")

    destino_dir = Path(output_dir)
    destino_dir.mkdir(parents=True, exist_ok=True)

    archivos_descargados: list[Path] = []
    headers = {
        "User-Agent": (
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
            "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"
        )
    }

    for anio, mes in _iterar_periodos(mes_inicial, mes_final):
        fecha_str = f"{dia:02d}-{mes:02d}-{anio:04d}"
        url = BASE_URL_TEMPLATE.format(fecha=fecha_str)
        nombre_archivo = f"DataSet-Obras-Publicas {fecha_str}.xlsx"
        ruta_archivo = destino_dir / nombre_archivo

        # Escribir la URL en el log de ejecución para verificación
        logger.info("Descargando fecha %s | URL: %s", fecha_str, url)

        req = urllib.request.Request(url, headers=headers)
        try:
            with urllib.request.urlopen(req, timeout=120) as response:
                if response.status != 200:
                    logger.warning(
                        "Respuesta inesperada (HTTP %s) para la fecha %s",
                        response.status,
                        fecha_str,
                    )
                    continue

                with open(ruta_archivo, "wb") as out_file:
                    shutil.copyfileobj(response, out_file)

            tamano_kb = ruta_archivo.stat().st_size / 1024
            logger.info(
                "Archivo guardado exitosamente: %s (%.2f KB)",
                ruta_archivo,
                tamano_kb,
            )
            archivos_descargados.append(ruta_archivo)

        except urllib.error.HTTPError as e:
            logger.error(
                "Error HTTP %s al descargar fecha %s desde URL: %s",
                e.code,
                fecha_str,
                url,
            )
        except urllib.error.URLError as e:
            logger.error(
                "Error de conexión (%s) al descargar fecha %s desde URL: %s",
                e.reason,
                fecha_str,
                url,
            )
        except Exception as e:
            logger.error(
                "Error inesperado (%s) al descargar fecha %s desde URL: %s",
                e,
                fecha_str,
                url,
            )

    return archivos_descargados


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Descarga datasets mensuales de Obras Públicas desde INFOBRAS (CGR)."
    )
    parser.add_argument(
        "mes_inicial",
        type=int,
        nargs="?",
        default=202501,
        help="Mes inicial en formato YYYYMM (por defecto: 202501)",
    )
    parser.add_argument(
        "mes_final",
        type=int,
        nargs="?",
        default=202508,
        help="Mes final en formato YYYYMM (por defecto: 202508)",
    )
    parser.add_argument(
        "dia",
        type=int,
        nargs="?",
        default=1,
        help="Día del mes a descargar (por defecto: 1)",
    )
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=DEFAULT_OUTPUT_DIR,
        help=f"Directorio de descarga (por defecto: {DEFAULT_OUTPUT_DIR})",
    )

    args = parser.parse_args()
    descargar_infobras(args.mes_inicial, args.mes_final, args.dia, args.output_dir)

