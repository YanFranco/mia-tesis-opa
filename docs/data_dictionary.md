## ds_obras_publicas_infobras

### Columnas validas

| dominio               | columna_excel v1                                 | columna_db                                 | tipo_dato  | cambia_en_el_tiempo |
|-----------------------|--------------------------------------------------|--------------------------------------------|------------|---------------------|
| entidad               | codigo Entidad                                   | codigo_entidad                             | varchar    | 0                   |
| entidad               | Entidad Pública                                  | entidad_publica                            | varchar    | 0                   |
| obra                  | Código INFOBRAS                                  | codigo_infobras                            | varchar    | 0                   |
| obra                  | Nombre de obra                                   | nombre_obra                                | varchar    | 0                   |
| obra                  | Modalidad de ejecución de la obra                | modalidad_ejecucion_obra                   | varchar    | 0                   |
| obra                  | ¿Corresponde a un saldo de Obra?                 | flg_corresponde_saldo_obra                 | boolean    |                     |
| obra                  | Código INFOBRAS de obra inicial                  | codigo_infobras_obra_inicial               | varchar    |                     |
| obra                  | Naturaleza de la obra                            | naturaleza_obra                            | varchar    | 0                   |
| obra                  | Tipo de obra - Clasificador Nivel 1              | tipo_obra_nivel_1                          | varchar    | 0                   |
| obra                  | Tipo de obra - Clasificador Nivel 2              | tipo_obra_nivel_2                          | varchar    | 0                   |
| obra                  | Tipo de obra - Clasificador Nivel 3              | tipo_obra_nivel_3                          | varchar    | 0                   |
| inversion             | Estado de ejecución                              | estado_ejecucion                           | varchar    | 1                   |
|                       | Marca Reconstrucción con Cambios (Si/No)         | flg_reconstruccion_con_cambios             | boolean    |                     |
|                       | Marca Reactivación Economicas (Si/No)            | flg_reactivacion_economica                 | boolean    |                     |
|                       | N° Informes de control                           | n_informes_control                         | numeric    |                     |
|                       | N° Comentarios ciudadanos                        | n_comentarios_ciudadanos                   | numeric    |                     |
|                       | Nivel de gobierno                                | nivel_gobierno                             | varchar    | 0                   |
|                       | Sector de la Entidad                             | sector_entidad                             | varchar    | 0                   |
|                       | Codigo unico de inversión                        | codigo_unico                               | varchar(7) | 0                   |
|                       | Código SNIP                                      | codigo_snip                                | integer    | 0                   |
|                       | Nombre proyecto                                  | nombre_proyecto                            | varchar    | 0                   |
|                       | Estado del proyecto                              | estado_proyecto                            | varchar    | 1                   |
|                       | Tipo Formato                                     | tipo_formato                               | varchar    | 0                   |
| Proyecto de inversion | Monto Viable/Aprobado                            | monto_viable_aprobado                      | numeric    |                     |
|                       | Fecha de aprobación                              | fecha_aprobacion                           | date       |                     |
| registro avance       | Fecha de actualización                           | fecha_actualizacion                        | date       |                     |
|                       | N° obras relacionadas al proyecto                | n_obras_relacionadas_proyecto              | smallint   | 1                   |
| ubigeo                | Departamento                                     | departamento                               | varchar    | 0                   |
| ubigeo                | Provincia                                        | provincia                                  | varchar    | 0                   |
| ubigeo                | Distrito                                         | distrito                                   | varchar    | 0                   |
| ubigeo                | Dirección o información de referencia            | direccion_informacion_referencia           | varchar    | 0                   |
| ubigeo                | Tipo de ubicación (exacta/referencial)           | tipo_ubicacion                             | varchar    | 0                   |
| Expediente Tecnico    | Fecha de aprobación del expediente               | fecha_aprobacion_expediente                | date       |                     |
| Expediente Tecnico    | Monto de aprobación de expediente técnico        | monto_aprobacion_et                        | numeric    |                     |
| Expediente Tecnico    | Moneda                                           | moneda                                     | varchar    |                     |
| Expediente Tecnico    | Tasa de cambio                                   | tasa_cambio                                | float      |                     |
| Expediente Tecnico    | Monto aprobado en soles                          | monto_aprobado_soles                       | numeric    | 0                   |
| Expediente Tecnico    | Documento de aprobación de expediente            | documento_aprobacion_expediente            | varchar    |                     |
| contratista           | RUC                                              | ruc_1                                      | varchar    | 1                   |
| contratista           | Nombre o razón social de la empresa o consorcio  | razon_social_empresa_consorcio_1           | varchar    | 0                   |
| contratista           | Monto del contrato  en soles                     | monto_contrato_soles_1                     | numeric    | 0                   |
| contratista           | RUC                                              | ruc_2                                      | varchar    | 1                   |
| contratista           | Nombre o razón social de la empresa o consorcio: | razon_social_empresa_consorcio_2           | varchar    | 0                   |
| contratista           | Monto del contrato  en soles                     | monto_contrato_soles_2                     | numeric    | 0                   |
| personal              | Tipo de documento de identidad                   | tipo_documento_identidad                   | varchar    |                     |
| personal              | Número de documento                              | numero_documento_identidad                 | varchar    |                     |
| personal              | Nombres Apellidos                                | nombres_apellidos                          | varchar    |                     |
| personal              | Colegiatura                                      | colegiatura_1                              | varchar    |                     |
| personal              | Número de colegiatura                            | numero_colegiatura                         | varchar    |                     |
| personal              | Fecha inicio supervision                         | fecha_inicio_supervision                   | date       |                     |
| personal              | Fecha fin supervision                            | fecha_fin_supervision                      | date       |                     |
| personal              | Tipo de documento de identidad                   | tipo_documento_identidad_2                 | varchar    |                     |
| personal              | Número de documento                              | numero_documento_identidad_2               | varchar    |                     |
| personal              | Nombres Apellidos                                | nombres_apellidos_2                        | varchar    |                     |
| personal              | Colegiatura                                      | colegiatura_2                              | varchar    |                     |
| personal              | Número de colegiatura                            | numero_colegiatura_2                       | varchar    |                     |
| personal              | Fecha inicio de labores                          | fecha_inicio_labores                       | date       |                     |
| personal              | Fecha fin  de labores                            | fecha_fin_labores                          | date       |                     |
| obra                  | Fecha de inicio de obra                          | fecha_inicio_obra                          | date       | 0                   |
|                       | Fecha finalización programada de obra            | fecha_fin_programada_obra                  | date       | 1                   |
|                       | Plazo de ejecución (en dias)                     | plazo_ejecucion_dias                       | numeric    | 1                   |
|                       | Tipo de entrega                                  | tipo_entrega                               | varchar    | 0                   |
|                       | Porcentaje de terreno entregado                  | porcentaje_terreno_entregado               | numeric    | 1                   |
|                       | Fecha de entrega del terreno                     | fecha_entrega_terreno                      | date       | 1                   |
| registro avance       | Año de avance                                    | ano_avance                                 | smallint   | 1                   |
| registro avance       | Mes de avance                                    | mes_avance                                 | smallint   | 1                   |
| registro avance       | Fecha de registro de avance                      | fecha_registro_avance                      | date       | 1                   |
| registro avance       | Avance Físico Programado Acumulado (%)           | avance_fisico_programado_acumulado         | numeric    | 1                   |
| registro avance       | Avance Físico Real Acumulado (%)                 | avance_fisico_real_acumulado               | numeric    | 1                   |
| registro avance       | Monto de valorización Programado Acumulado       | monto_valorizacion_programado_acum         | numeric    | 1                   |
| registro avance       | Monto de valorización Ejecutado Acumulado        | monto_valorizacion_ejecutado_acum          | numeric    | 1                   |
| registro avance       | Porcentaje de ejecución financiera               | porcentaje_ejecucion_financiera            | numeric    | 1                   |
| registro avance       | Monto de ejecución financiera de la obra         | monto_ejecucion_financiera_obra            | numeric    | 1                   |
| paralizacion          | Causal de paralización                           | causal_paralizacion                        | varchar    | 1                   |
| paralizacion          | Fecha de paralización                            | fecha_paralizacion                         | date       | 1                   |
| paralizacion          | Número de dias paralizado                        | numero_dias_paralizado                     | integer    | 1                   |
| paralizacion          | Comentarios                                      | comentarios                                | text       | 1                   |
| registro avance       | Estado de actualización de registro de avance    | estado_actualizacion_registro_avance       | varchar    |                     |
| paralizacion          | Existe Paralización                              | flg_existe_paralizacion                    | boolean    | 1                   |
|                       | Número del CIPRIL /CIPGN                         | numero_cipril_cipgn                        | varchar    | 0                   |
|                       | Fecha del CIPRIL / CIPGN                         | fech_cipril_cipgn                          | date       | 0                   |
|                       | Monto CIPRIL / CIPGN                             | monto_cipril_cipgn                         | numeric    | 0                   |
|                       | N° de modificaciones                             | n_modificaciones                           | integer    | 1                   |
|                       | N° días de modificaciones de plazo               | n_dias_modificaciones_plazo                |            | 1                   |
|                       | Nuevo Plazo de ejecución (en dias)               | nuevo_plazo_ejecucion_dias                 |            | 1                   |
| obra                  | Fecha finalización reprogramada de obra          | fecha_finalizacion_reprogramada_obra       |            | 1                   |
|                       | N° de controversias                              | n_controversias                            |            | 1                   |
|                       | N° de adicionales de obra                        | n_adicionales_obra                         |            | 1                   |
|                       | Monto de adicionales de obra en soles            | monto_adicionales_obra_soles               | numeric    | 1                   |
|                       | N° de adicionales de supervisión                 | n_adicionales_supervision                  |            | 1                   |
|                       | Monto de adicionales de supervisión en soles     | monto_adicionales_supervision_soles        | numeric    | 1                   |
|                       | N° de deductivos de obra                         | n_deductivos_obra                          |            | 1                   |
|                       | Monto de deductivos de obra en soles             | monto_deductivo_obra_soles                 | numeric    | 1                   |
|                       | N° de deductivos de supervisión                  | n_deductivo_supervision                    |            | 1                   |
|                       | Monto de deductivos de supervisión en soles      | monto_deductivos_supervision_soles         | numeric    | 1                   |
| obra                  | Fecha de finalización real                       | fecha_finalizacion_real                    | date       | 0                   |
|                       | Motivo en caso no se llegue al 100%              | motivo_caso_no_llegue_100_porciento        | varchar    | 1                   |
|                       | ¿Tiene recepción total?                          | flg_tiene_recepcion_total                  | boolean    | 0                   |
| obra                  | Fecha de recepción                               | fecha_recepcion                            | date       | 0                   |
|                       | ¿Tiene liquidación de obra?                      | flg_tiene_liquidacion_obra                 | boolean    | 0                   |
| obra                  | Fecha de aprobación de liquidación de obra       | fecha_aprobacion_liquidacion_obra          | date       | 0                   |
|                       | Costo de la obra en soles                        | costo_obra_soles                           | numeric    | 1                   |
|                       | ¿Corresponde la transferencia  a otra entidad?   | flg_corresponde_transferencia_otra_entidad | boolean    | 0                   |
| obra                  | Fecha de transferencia                           | fecha_transferencia                        | date       | 1                   |
|                       | Tipo de entidad que recepciona la obra           | tipo_entidad_recepciona_obra               | varchar    | 0                   |
|                       | Año de primer devengado                          | ano_primer_devengado                       | smallint   | 0                   |
|                       | Monto Total devengado del proyecto               | monto_total_devengado_proyecto             | numeric    | 1                   |
| etl                   | Fecha de corte del dataset infobras              | fecha_foto                                 |            |                     |

## Columnas RELEVANTES

| fuente de dato | Dominio  | columna                       | tipo de dato | descripcion                                                                                                                                                                                                                           |
|----------------|----------|-------------------------------|--------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| infobras       | entidad  | codigo_entidad                | varchar      | Codigo de la Entidad Publica                                                                                                                                                                                                          |
| infobras       | entidad  | nivel_gobierno                | varchar      | Nivel de gobierno al que pertenece la entidad publica: Nacional, Regional o Local                                                                                                                                                     |
| infobras       | entidad  | sector_entidad                | varchar      | Sector del nivel de Gobierno                                                                                                                                                                                                          |
| BI             | Proyecto | marco                         | varchar      | Indica si el proyecto de inversión se ejecuta bajo SNIP o la nueva norma de Invierte                                                                                                                                                  |
| infobras       | Proyecto | codigo_unico                  | varchar      | Codigo del proyecto de inversión publica                                                                                                                                                                                              |
| infobras       | Proyecto | tipo_formato                  | varchar      | Tipo de formato de la inversion: IRI, IOAR, PIP SNIP, PROYECTO DE INVERSION                                                                                                                                                           |
| infobras       | Proyecto | n_obras_relacionadas_proyecto | numeric      | Numero de obras relacionadas al proyecto de inversión                                                                                                                                                                                 |
| infobras       | obra     | codigo_infobras               | varchar      | Codigo de la Obra Publica                                                                                                                                                                                                             |
| infobras       | obra     | modalidad_ejecucion_obra      | varchar      | Modalidad de ejecución de la obra Publica: Administración directa, Contrata, Asociacion Pública Privada APP, Por núcleo ejecutor, Obras por impuestos, Con organismo internacional, Por convenio entre entidades, Gobierno a Gobierno |
| infobras       | obra     | estado_ejecucion              | varchar      | Estado de ejecución de la obra: Sin Ejecución, En Ejecución, Paralizada, Paralizada                                                                                                                                                   |
| infobras       | obra     | naturaleza_obra               | varchar      | Naturaleza de intervención de la obra: Mejoramiento, Rehabilitacion, Creación, Instalacion, Reconstruccion                                                                                                                            |
| infobras       | obra     | tipo_obra_nivel_1             | varchar      | Sector economico donde se ejecuta la obra                                                                                                                                                                                             |
| infobras       | obra     | tipo_obra_nivel_2             | varchar      | Sub sector economico donde se ejecuta la obra                                                                                                                                                                                         |
| infobras       | obra     | tipo_obra_nivel_3             | varchar      | Clasificación mas granular de la intervención de la obra                                                                                                                                                                              |
| infobras       | obra     | fecha_inicio_obra             | date         | Fecha de inicio de la obra                                                                                                                                                                                                            |
|                | ubigeo   | departamento                  | varchar      | Departamento                                                                                                                                                                                                                          |
|                | ubigeo   | provincia                     | varchar      | Provincia                                                                                                                                                                                                                             |
|                | ubigeo   | distrito                      | varchar      | Distrito                                                                                                                                                                                                                              |
|                | ET       | fecha_aprobacion_expediente   | date         | Fecha en la que se aprueba el Expediente Tenico                                                                                                                                                                                       |
|                | ET       | monto_aprobacion_et           | numeric      | Costo de la obra según Expediente técnico                                                                                                                                                                                             |
|                | ET       | monto_aprobado_soles          | numeric      | Costo de la obra (en soles) según Expediente técnico                                                                                                                                                                                  |
|                | personal | colegiatura_1                 | varchar      | Colegio de profesionales del supervisor de obra                                                                                                                                                                                       |
|                | personal | colegiatura_2                 | varchar      | Colegio de profesionales del residente de obra                                                                                                                                                                                        |
| infobras       | obra     | fecha_paralizacion            | date         | Fecha de paralizacion de la obra                                                                                                                                                                                                      |
| infobras       | obra     | fecha_finalizacion_real       | date         | Fecha de finalizacion de la obra                                                                                                                                                                                                      |
