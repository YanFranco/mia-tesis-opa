# Silver layer

## sa_dataset_obras_publicas to hub_obra_publica

### codigo_infobras duplicados por fecha foto

1. Para los casos de `codigo_infobras` duplicados en una misma fecha_foto en sa_dataset_obras_publicas se deberá considera el registro con `fecha_registro_avance` mas reciente.

### Inconsistencias en campos de paralización

2. A partir de la foto 2023-07-11 el dataset ya incluye el camp`o flg_existe_paralizaci`on con solo 2 valores (true, false).

3. Para el caso de los campos `flg_existe_paralizacion` y `causal_paralizacion`, se debera aplicar la siguiente consideracion:
    - Si `flg_existe_paralizacion` es `true` y `causal_paralizacion` es `null`, se considera como una paralizacion y se deberá poner `null` como causal_paralizacion.
    - Si `flg_existe_paralizacion` es `false` y `causal_paralizacion` es `not null`, No se considera como un paralización de obra.

### Respecto a end_date

4. Para un correcto manejo y operación con fechas, la ultima version del registro en el satelite debe tener `end_date = NULL` (que significa la versión actual o más vigente del registro), evitando distorsiones en cálculos de duración (`end_date - start_date`).

5. Para el caso de obras que dejan de aparecer en fotos posteriores se debe dejar `end_date = NULL` (abierto) y en `fecha_foto` registrar la última `fecha_foto` en la que apareció la obra.

### Reglas de actualización en hub_obra_publica (SCD Tipo 1)

6. `hub_obra_publica` almacena un único registro por `codigo_infobras` con los 7 atributos estructurales y de ciclo de vida del dominio `obra` (`modalidad_ejecucion_obra`, `naturaleza_obra`, `tipo_obra_nivel_1`, `tipo_obra_nivel_2`, `tipo_obra_nivel_3`, `fecha_inicio_obra`, `fecha_finalizacion_real`), actualizados foto a foto mediante `COALESCE(nuevo_valor, valor_actual)` para completar fechas que nacen en `NULL` sin perder valores previos, además de `first_seen_date` y `fecha_foto` (última foto en que apareció la obra).

### Reglas de entidades Link (SCD Tipo 2)

7. Las relaciones con otras entidades se modelan en tres tablas Link independientes con vigencia temporal (`start_date`, `end_date`, `fecha_foto`), registrando filas únicamente cuando la clave foránea es válida (`IS NOT NULL AND trim(...) <> ''`):
    - `link_obra_entidad`: enlaza `codigo_infobras` con `codigo_entidad`.
    - `link_obra_proyecto`: enlaza `codigo_infobras` con `codigo_unico` (`trim(codigo_unico) NOT IN ('', '0')`).
    - `link_obra_contratista`: unifica la contratación de ejecución (`ruc_1`) y supervisión (`ruc_2`) en una misma entidad Link con clave de seguimiento `(codigo_infobras, rol)` y campo `rol IN ('EJECUCION', 'SUPERVISION')`.

### Regla de categorización de causales de paralización

8. En `sat_obra_paralizacion`, el atributo `categoria_paralizacion` se resuelve de forma externa mediante el archivo de configuración `configs/categoria_paralizacion.yaml` (evitando codificación rígida en SQL o código):
    - Cuando `flg_existe_paralizacion = FALSE`, `categoria_paralizacion` debe tomar valor `NULL` (Regla 3).
    - Cuando `flg_existe_paralizacion = TRUE`, se normaliza `lower(trim(causal_paralizacion))` y se busca en `mapping` del YAML; cualquier causal nula, vacía o no contemplada en el mapeo se asigna a `default_category` (`'NO_CLASIFICADO'`).

### Reglas de ampliación del modelo Data Vault 2.0 (13 tablas)

9. Además de `hub_obra_publica`, los tres Links y `sat_obra_paralizacion` / `sat_obra_estado_ejecucion`, la capa Silver incluye:
    - **Hubs de entidades relacionadas (SCD Tipo 1 con `COALESCE(nuevo, actual)`)**: `hub_entidad` (`codigo_entidad`, `nivel_gobierno`, `sector_entidad`), `hub_proyecto` (`codigo_unico`, `tipo_formato`) y `hub_contratista` (`ruc`, `razon_social_empresa_consorcio` unificando `ruc_1` y `ruc_2`).
    - **Satélites adicionales**: `sat_obra_ubigeo` (SCD Tipo 1: `departamento`, `provincia`, `distrito`), `sat_obra_expediente_tecnico` (SCD Tipo 2: `fecha_aprobacion_expediente`, `monto_aprobacion_et`, `monto_aprobado_soles`), `sat_proyecto` (SCD Tipo 2 por `codigo_unico`: `n_obras_relacionadas_proyecto`) y `sat_link_obra_contratista` (SCD Tipo 2 sobre el Link por `(codigo_infobras, rol, ruc)`: `monto_contrato_soles`).

