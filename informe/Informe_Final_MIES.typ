#set document(
  title: "Estimación del riesgo de paralización de obras públicas en el Perú: Un análisis comparativo de modelos estadísticos",
  author: "Yan Franco Calderon Felix",
)

#set page(
  paper: "a4",
  margin: (x: 2.2cm, y: 2.5cm),
)

#set text(
  font: "New Computer Modern",
  size: 10pt,
  lang: "es",
)

#set par(
  justify: true,
  leading: 0.65em,
)

#show heading.where(level: 1): it => {
  v(1.2em)
  text(weight: "bold", size: 12pt, it.body)
  v(0.45em)
}

#align(center)[
  #text(size: 16pt, weight: "bold")[Estimación del riesgo de paralización de obras públicas en el Perú: Un análisis comparativo de modelos estadísticos]

  #v(0.8em)
  Yan Franco Calderon Felix#super[1]

  #v(0.4em)
  #super[1]Maestría en Ingeniería Estadística, Lima \
  #emph[Correo:] ycalderonf
]

#v(1.2em)

#block[
  #text(weight: "bold")[Resumen] \
  La paralización de obras públicas por incumplimiento contractual constituye un problema persistente en la gestión de inversiones en el Perú, con un impacto económico y social considerable. El presente trabajo desarrolla y compara ocho modelos estadísticos de clasificación binaria para estimar la probabilidad de paralización de una obra pública del Gobierno Nacional a partir de información disponible al inicio de su ejecución, entendiendo dicha probabilidad como una medida cuantitativa de riesgo. Sobre un conjunto de datos de 2,627 obras (65 % train / 35 % test, particionado temporalmente para simular el uso prospectivo del modelo), se ajustaron una regresión logística sin penalizar ni ponderar como línea base, una regresión logística penalizada (Elastic Net) y un Random Forest -ambos seleccionados y afinados mediante validación cruzada anidada-, dos modelos lineales generalizados (GLM) binomiales con enlaces complementary log-log y probit, y tres modelos aditivos generalizados (GAM) con enlaces logit, complementary log-log y probit, todos ellos ponderados por clase para atender el fuerte desbalance de la variable objetivo (7-8 % de casos positivos). La comparación se realizó bajo cuatro dimensiones -discriminación (ROC AUC, PR AUC), calibración (Brier score, curvas de calibración), decisión a un umbral operativo (precisión, recall, F2-score) e interpretabilidad (odds ratio, razón de riesgo, importancia por permutación)-, en lugar de restringirse a una única métrica de clasificación. Los resultados muestran que ponderar por clase mejora sustancialmente el recall y el F2-score de los modelos lineales y GLM, pero degrada su calibración, mientras que los modelos aditivos ponderados retienen una calibración notablemente mejor sin sacrificar discriminación. El modelo GLM con enlace complementary log-log ponderado obtuvo el mejor equilibrio entre capacidad de detección (F2 = 0.353, recall = 0.610) e interpretabilidad de sus coeficientes como razones de riesgo, identificando el historial de incumplimiento de la entidad ejecutora, el monto aprobado y la ubicación geográfica como los factores más asociados al riesgo de paralización.
]

#v(0.8em)

#text(weight: "bold")[Palabras clave:] paralización de obras públicas, modelo probabilistico de estimación de riesgo, modelos lineales generalizados, modelos aditivos generalizados, calibración probabilística, desbalance de clases, aprendizaje estadístico

#line(length: 100%, stroke: 0.6pt)

= Introducción

En el contexto socioeconómico del Perú, la inversión pública juega un papel fundamental como motor de desarrollo y progreso del país. A través de ella, el Estado peruano busca mejorar la calidad de vida de sus ciudadanos, impulsando la infraestructura, los servicios básicos y la productividad nacional. Un proyecto de inversión corresponde a intervenciones temporales que se financian total o parcialmente con recursos públicos, destinadas a la formación de capital físico, humano, institucional, intelectual o natural, que tenga como propósito crear, ampliar, mejorar o recuperar la capacidad de producción de bienes o servicios. Una obra pública se define como las inversiones con componente de infraestructura, incluyendo la construcción, reconstrucción, remodelación, demolición, renovación, mantenimiento, habilitación y rehabilitación de bienes inmuebles, tales como edificaciones, estructuras, excavaciones, perforaciones, carreteras, puentes, entre otros, que requieren dirección técnica, expediente técnico, mano de obra, materiales y/o equipos, cuya ejecución, operación o mantenimiento implique la participación del Estado @contraloria_general_de_la_republica_del_peru_informe_2025. La @representacion-obra-publica muestra un esquema de la obra pública en el Perú.

#figure(
  image("./assets/figures/imagen1.png", width: 80%),
  caption: [Representación de una obra pública en el Perú],
)<representacion-obra-publica>

La paralización de una obra pública se entiende como la interrupción indefinida o prolongada de su ejecución física, lo que impide su conclusión y puesta en funcionamiento. Según el _Informe de Obras Paralizadas en el Territorio Nacional a diciembre de 2024_, se registraron 2,476 obras paralizadas en todo el Perú, con un costo total de 43,118 millones de soles. Esta problemática afecta el cumplimiento de metas de cierre de brechas de infraestructura, genera pérdida de recursos públicos e impide el acceso oportuno de la población a la infraestructura y los servicios básicos, afectando la calidad de vida de la población y el desarrollo del país.

El impacto para el país de las obras paralizadas se genera a nivel económico, financiero, social y de infraestructura.

*Impacto Económico y Financiero*
- Fondos públicos sancionados: dinero invertido por el Estado que queda congelado sin generar ningún retorno social o financiero.
- Sobrecostos por deterioro: mayor gasto futuro para reponer estructuras dañadas por el clima, el abandono y la falta de mantenimiento.
- Litigios arbitrales: millones de soles gastados por el Estado en arbitrajes y disputas legales con contratistas y constructoras.
- Mayor gasto operativo: incremento del presupuesto necesario para elaborar nuevos expedientes técnicos de saldos de obra.

*Impacto Social y de Infraestructura*
- Servicios esenciales detenidos: poblaciones vulnerables que siguen sin acceso a agua potable, desagüe, hospitales modernos o colegios seguros.
- Aislamiento geográfico: carreteras y puentes inconclusos que frenan la conectividad y el comercio entre comunidades del interior del país.
- Riesgos de accidentes: estructuras a medio construir abandonadas que se convierten en focos de delincuencia o peligro para los transeúntes.
- Desconfianza ciudadana: aumento del descontento y pérdida de credibilidad en la capacidad de gestión de los tres niveles de gobierno.

Entre las principales causas de paralización reportadas se encuentran el incumplimiento de contrato (25.4 %), la falta de recursos financieros y liquidez (21.2 %) y la deficiencia en el expediente técnico (10.9 %). En particular, el incumplimiento contractual afectó a 628 obras, representando un monto proporcional del 36.9 % del total paralizado, equivalente a S/ 15,913 millones @contraloria_general_de_la_republica_del_peru_informe_2025. Esta causal, por su magnitud económica y su relación directa con decisiones y comportamientos observables durante la ejecución contractual, es la que se selecciona como variable objetivo del presente estudio.

#figure(
  image("./assets/figures/img_grafo_causales_paralizacion_obras.png", width: 60%),
  caption: [Grafo de causales de paralización de obras públicas en el Perú],
)<grafo-causales-paralizacion-obras>

La respuesta del Estado frente a las paralizaciones suele ser reactiva: las auditorías, informes de control o intervenciones correctivas se ejecutan una vez que el contrato ya ha sido resuelto o los plazos vencidos, cuando el margen de maniobra preventivo ya se ha perdido. Estudios previos han mostrado que algoritmos de aprendizaje automático basados en árboles (Random Forest, XGBoost, LightGBM, CatBoost) suelen superar a un modelo lineal base en la predicción de retrasos y paralizaciones en proyectos de construcción @gondia_machine_2020 @alsulamy_predicting_2025 @nnaemeka_egwim_applied_2021, aunque dicha superioridad en métricas de clasificación no garantiza por sí sola que las probabilidades entregadas por el modelo sean una estimación confiable del riesgo real, ni que sus resultados sean interpretables para los tomadores de decisión @santini_data_2024. Por ello, con un efoque basado en modelos estadísticos, este trabajo aborda una familia de modelos estadísticos clásicos como los modelos lineales generalizados (GLM) con distintas funciones de enlace y modelos aditivos generalizados (GAM) frente a algoritmos de aprendizaje automático de caja negra, incorporando un modelo de árboles (Random Forest) únicamente como referencia de contraste (_benchmark_), y evaluando explícitamente no solo la capacidad discriminativa de cada modelo sino también la calibración de las probabilidades que produce y la interpretabilidad de sus parámetros.

El objetivo de este informe es: por un lado, describir el desarrollo de un modelo estadístico capaz de estimar la probabilidad de paralización de una obra pública por incumplimiento contractual a partir de información disponible al inicio de su ejecución; por otro, realizar un análisis comparativo riguroso entre ocho especificaciones estadísticas: una regresión logística base, una regresión logística penalizada, un Random Forest, dos GLM y tres GAM. El resto del documento se organiza de la siguiente manera: la sección "Descripción de los datos" detalla el origen, la estructura y las particularidades del conjunto de datos utilizado; la sección "Marco Teórico" presenta la formulación de cada modelo y las métricas empleadas para compararlos; la sección "Metodología" describe el esquema experimental, el tratamiento del desbalance de clases y las decisiones de ingeniería de características; la sección "Resultados" expone de forma objetiva las métricas y parámetros obtenidos; la sección "Discusión de resultados" interpreta sustantivamente dichos hallazgos; y, finalmente, las "Conclusiones" sintetizan cuál modelo resulta más adecuado según el criterio de decisión que se priorice, junto con las limitaciones del estudio y las líneas de trabajo futuro.

== Problema de estudio

La falta de una estimación cuantitativa del riesgo de paralización de obras públicas en el Perú limita la capacidad de los gestores públicos para identificar proyectos con alto riesgo de paralización, manejar una lista ordenada por valor de riesgo que permita priorizar recursos y tomar medidas preventivas. Por lo tanto, el objetivo principal de este estudio es desarrollar y comparar diferentes modelos estadísticos que permitan estimar el riesgo de paralización de obras públicas en el Perú, utilizando un conjunto de datos representativo y relevante.

=== Representación del problema

La cuantificación del riesgo asociado a que una obra (individuo) se paralice se puede estimar tomando en cuenta un conjunto de factores (cuantitativos o cualitativos) relacionados con el ciclo de vida de la obra pública. Desde un enfoque de aprendizaje estadístico, este fenómeno se representa como un evento dicotómico donde la variable dependiente $Y$ toma valores binarios ($Y=1$ si la obra se paralizó por incumplimiento contractual, $Y=0$ en caso contrario); el modelo estima $P(Y=1 | X = x)$, y bajo cierto umbral de decisión $c$ se clasifica a la obra en una de las dos clases mediante $hat(Y) = I(hat(p) >= c)$. La probabilidad estimada $hat(p)$ es, en sí misma, la cuantificación del riesgo de paralización. El conjunto de datos está conformado por la variable dependiente y un conjunto de factores de riesgo asociados que serán candidatos a conformar los predictores del modelo; cada punto de datos representa el estado de una obra pública y sus atributos institucionales, geográficos, presupuestales, contractuales y de historial de ejecución.

La probabilidad estimada en nuevos proyectos de inversión permitirá obtener una lista ordenada por propensión a la paralización; esta lista podrá ser usada como una medida de apoyo para priorizar y ejecutar acciones preventivas, brindando soporte a las áreas técnicas, legales, administrativas y a los diferentes interesados del negocio.

= Descripción de los datos

== Modelo de datos del negocio

En @modelo_datos_obra_publica se muestra el diagrama entidad relación del negocio de ejecución de obras asociadas a una inversión pública, se nombra las diferentes entidades, relaciones y atributos relevantes para el contexto.

#figure(
  image("./assets/figures/img_modelo_datos_obra_publica.png", width: 80%),
  caption: [Diagrama E-R de las principales entidades de datos del negocio],
)<modelo_datos_obra_publica>

A continuación se describen conceptos de negocio importantes para la investigación:

- Inversión pública: La inversión pública es la aplicación de recursos públicos destinada a la creación, ampliación, mejoramiento o recuperación de la capacidad productora de bienes y servicios, orientada al cierre de brechas de infraestructura o de acceso a servicios públicos.(Ministerio de Economía y Finanzas, Invierte.pe).
- Proyecto de inversión: El proyecto de inversión es una intervención temporal que utiliza recursos públicos para crear, ampliar, mejorar o recuperar la capacidad de producción de bienes o servicios públicos, cuyos beneficios se generan durante su vida útil. (Ministerio de Economía y Finanzas, Invierte.pe).
- Obra pública: Se considera obra pública a toda construcción, reconstrucción, remodelación, demolición o mantenimiento ejecutado con recursos públicos, destinada a la prestación de servicios públicos o al cumplimiento de fines del Estado. (Contraloría General de la República).
- Ejecución contractual: La ejecución contractual es la etapa del proceso de contratación que se inicia con la suscripción del contrato y culmina con su liquidación, en la cual las partes cumplen las obligaciones y prestaciones pactadas. (Ley N.° 32069 – Ley General de Contrataciones Públicas).
- Incumplimiento contractual: Se configura el incumplimiento contractual cuando el contratista no ejecuta, total o parcialmente, las obligaciones asumidas en el contrato, conforme a las condiciones, plazos y especificaciones establecidas. (Reglamento de la Ley N.° 32069, D.S. N.° 009-2025-EF).
- Resolución de contrato: La resolución del contrato es el acto mediante el cual la entidad o el contratista pone fin al vínculo contractual por la ocurrencia de causales expresamente previstas en la normativa vigente. (Reglamento de la Ley N.° 32069, D.S. N.° 009-2025-EF).
- Paralización de obra: Se entiende por obra pública paralizada aquella que ha interrumpido su ejecución física por un periodo determinado, debido a causas técnicas, contractuales, legales, económicas o administrativas. (Contraloría General de la República).
- Expediente técnico: El expediente técnico es el conjunto de documentos que contienen la descripción técnica, económica y financiera necesaria para la ejecución de una obra pública.(Ministerio de Economía y Finanzas / Invierte.pe).
- Avance físico: El avance físico representa el porcentaje de ejecución de una obra respecto al total programado, medido en función de las partidas ejecutadas. (Contraloría General de la República – Infobras).
- Avance financiero: El avance financiero corresponde al nivel de ejecución del gasto asociado a una obra pública en relación con el presupuesto asignado. (Contraloría General de la República – Infobras).

== Conjunto de datos

El conjunto de datos utilizado proviene de una capa integrada ("gold") que enriquece la tabla de obras públicas de INFObras (Contraloría General de la República) con dos fuentes adicionales: el Índice de Corrupción (INCO 2024) de la entidad ejecutora y el Índice de Gestión de Inversión Pública (IGEIP) del sector, ambos trabajados en un proceso de integración.

// 2. Definición de la tabla dentro de la figura
#figure(
  table(
    columns: 4,
    [ *Fuente* ], [ *Institución* ],[*Descripción*],[*formato*],
    [Banco de inversiones], [MEF],[Base de proyectos de inversión publica], [csv],
    [INFObras], [CGR],[Base de obras publicas], [xls],
    [INCO], [CGR],[Indice de corrupcion], [xls],
    [IGEIP], [MEF],[Indice gestión de la inversión Pública], [html],
  ),
  // Añades el nombre o título de la tabla aquí
  caption: [Fuentes de datos utilizadas en el estudio],
) <datos-clientes> // <-- Esta es la etiqueta (label) para enlazar la tabla

La tabla que integra la información de del banco de inversiones y la base de INFObras se filtra por modalidad de ejecución de obra "por contrata", esta tabla contiene 69,952 registros y 128 columnas.

=== Filtros primarios (funcionales) para la obtención del conjunto de datos:
+ Se excluirán de la base inicial las obras que no hayan iniciado su ejecución, es decir no se considerarán obras con estado “sin ejecución”.
+ Se considerará obras públicas que tengan registrada una fecha de inicio de obra (fecha_inicio_obra).
+ Debido a que el alcance del trabajo está enmarcado en el dominio de la inversión pública (Iniverte.pe) solo se considerarán las obras publicas que estén asociados a un código de inversión existente en el banco de inversiones del MEF.
+ Se contempla trabajar el universo de obras públicas cuya modalidad de ejecución de obra es por Contrata.
+ Con respecto al causal de paralización se ha realizado una categorización de este concepto y se considerarán como las causales de paralización relacionadas a motivos contractuales, por lo tanto se considera incumplimientos del contrato ya sea por la entidad o el contratista, La @tabla-causales-paralizacion muestra las causales de paralización consideradas para la clase positiva.
+ Se consideran obras publicas ejecutadas por el gobierno nacional (Gobierno Nacional) `nivel_gobierno = 'GOBIERNO NACIONAL'` y `marco = 'INVIERTE'`; para trabajar sobre un universo homogéneo de proyectos ejecutados por el Gobierno Nacional bajo el marco normativo vigente de inversión pública (Invierte.pe)

#figure(
  table(
    columns: (1fr, auto),
    align: (left + horizon, left + horizon),
    
    // Encabezados
    table.header(
      [*Causal de paralización*], [*Categoría*]
    ),
    
    // Filas de datos
    [Incumplimiento de contrato], [CONTRACTUAL],
    [Proceso arbitral], [CONTRACTUAL],
    [Resolución de contrato], [CONTRACTUAL],
    [Discrepancias controversias y arbitraje], [CONTRACTUAL],
    [Resolución del contrato de supervisión de obra], [CONTRACTUAL],
    [Obra Judicializada por la Entidad], [CONTRACTUAL],
    [Incumplimiento del pago de valorizaciones u otros], [CONTRACTUAL /\ FINANCIERA]
  ),
  caption: [Causales de paralización consideradas para la clase positiva],
) <tabla-causales-paralizacion>

#figure(
  image("./assets/figures/img_eda_opa_nivel_gobierno.png", width: 100%),
  caption: [Distribución de las clases aperturado por nivel de gobierno],
)<eda_opa_nivel_gobierno>

#figure(
  image("./assets/figures/img_eda_opa_marco.png", width: 100%),
  caption: [Distribución de las clases aperturado por marco],
)<eda_opa_marco>

Tras estos filtros, el conjunto de trabajo queda conformado por 2,646 observaciones. La variable objetivo, `flg_opa_incumplimiento_contractual`, es binaria: toma el valor 1 cuando la obra se paralizó por una causal clasificada como incumplimiento contractual y 0 en caso contrario. Antes de cualquier partición, la variable objetivo presenta un marcado desbalance de clases: 92.6 % de obras no paralizadas frente a 7.4 % de obras paralizadas por esta causal.


== Análisis exploratorio de los datos

Luego de realizar una revisión por jucio de experto y constrastar con la literatura se pre-seleccionaron las siguientes variables candidatas a ser predictores del riesgo de paralización: 

#figure(
  table(
    columns: (auto, auto, auto), 
    align: (left + horizon, left + horizon, left + horizon),
    
    // Encabezados
    table.header(
      [*Dominio*], [*Columna*], [*Tipo de dato*]
    ),
    
    // Filas de datos
    [entidad], [`codigo_entidad`], [varchar],
    [entidad], [`nivel_gobierno`], [varchar],
    [entidad], [`sector_entidad`], [varchar],
    [Proyecto], [`marco`], [varchar],
    [Proyecto], [`codigo_unico`], [varchar],
    [Proyecto], [`tipo_formato`], [varchar],
    [Proyecto], [`n_obras_relacionadas_proyecto`], [numeric],
    [obra], [`codigo_infobras`], [varchar],
    [obra], [`modalidad_ejecucion_obra`], [varchar],
    [obra], [`estado_ejecucion`], [varchar],
    [obra], [`naturaleza_obra`], [varchar],
    [obra], [`tipo_obra_nivel_1`], [varchar],
    [obra], [`tipo_obra_nivel_2`], [varchar],
    [obra], [`tipo_obra_nivel_3`], [varchar],
    [obra], [`fecha_inicio_obra`], [date],
    [ubigeo], [`departamento`], [varchar],
    [ubigeo], [`provincia`], [varchar],
    [ubigeo], [`distrito`], [varchar],
    [ET], [`fecha_aprobacion_expediente`], [date],
    [ET], [`monto_aprobacion_et`], [numeric],
    [ET], [`monto_aprobado_soles`], [numeric],
    [personal], [`colegiatura_1`], [varchar],
    [personal], [`colegiatura_2`], [varchar],
    [], [`indice_igeip`], [numeric],
    [], [`indice_inco`], [numeric],
    [], [`indice_iri`], [numeric]
  ),
  caption: [Variables candidatas a ser predictores del riesgo de paralización de obras públicas en el Perú],
) <tabla-covariables-candidatas>

=== Análisis de valores faltantes

El análisis de valores faltantes @img_correlacion_valores_nulos y @img_valores_nulos_inicial, descarta a `colegiatura_1` (colegio profesional al que pertenece el supervisor de obra), también revela que las columnas `igeip_sector` e `igeip_sector_ejecucion` presentan la mayor proporción de nulos (19.3 % cada una), consistente con que el índice IGEIP solo cubre un subconjunto de sectores del Estado; `tipo_formato` presenta 3.6 % de nulos, y `monto_aprobado_soles`/`monto_aprobacion_et` 0.7 % cada una, siendo el resto de columnas prácticamente completas. El índice `inco_2024_entidad` se distribuye en una escala propia (entre 8.5 y 86.2 en la muestra, no acotada a [0, 1]), mientras que `igeip_sector` e `igeip_sector_ejecucion` sí están acotados a [0, 1], con una dispersión reducida (desviación estándar de 0.035 y 0.041, respectivamente) que sugiere un aporte discriminante limitado, dado que la mayoría de entidades comparten valores similares del índice.

#figure(
  image("./assets/figures/img_correlacion_valores_nulos.png", width: 90%),
  caption: [Correlación valores nulos - EDA Inicial],
)<img_correlacion_valores_nulos>

#figure(
  image("./assets/figures/img_valores_nulos_inicial.png", width: 90%),
  caption: [Distribución valores nulos - EDA Inicial],
)<img_valores_nulos_inicial>

=== Limpieza de datos

La limpieza de datos se concentró en la variable `monto_aprobado_soles`, dada su relevancia como predictor y la presencia de valores inválidos: se eliminaron 18 registros con monto nulo (afectando únicamente a la clase mayoritaria, sin distorsionar el desbalance), se corrigieron 22 registros con monto igual a cero reemplazándolo por el monto del expediente técnico aprobado (`monto_aprobacion_et`), y se descartó 1 registro con monto igual a uno (un valor residual inválido). El conjunto final de trabajo, luego de esta limpieza, queda conformado por 2,627 observaciones.

#figure(
  image("./assets/figures/img_monto_soles_analisis.png", width: 100%),
  caption: [Monto soles distribución logaritmica y boxplot por clase de paralización],
)<img_monto_soles_analisis>

La variable presupuestal `monto_aprobado_soles` revela una pronunciada asimetría positiva en su escala natural, con montos extremos que alcanzan cientos de millones de soles. Para regularizar la dispersión, la aplicación de una escala logarítmica estabiliza la distribución, permitiendo además detectar y subsanar inconsistencias críticas en el registro administrativo, tales como valores en cero o un sol correspondientes a errores de carga @img_monto_soles_analisis. Tras depurar estas anomalías y sustituirlas mediante el valor del expediente técnico, la variable adopta una morfología unimodal y continua. Sobre este soporte corregido se evidencia el severo desbalance de clases del fenómeno, donde las obras paralizadas constituyen una reducida minoría @img_monto_soles_analisis_limpio. Las obras con incumplimiento contractual presentan medianas presupuestales sistemáticamente más elevadas, lo que confirma que una mayor envergadura económica incrementa la vulnerabilidad y el riesgo de paralización.

#figure(
  image("./assets/figures/img_monto_soles_analisis_limpio.png", width: 100%),
  caption: [Monto soles distribución logaritmica y boxplot por clase de paralización luego de la limpieza],
)<img_monto_soles_analisis_limpio>

=== Descripción de variables relevantes

En cuanto a las variables explicativas, el estudio distingue tres naturalezas:

- *Variables categóricas*: Donde las mas relevantes son`tipo_obra_nivel_1`, `tipo_obra_nivel_2`, `tipo_obra_nivel_3`, `departamento`, `provincia`, `codigo_entidad`, `sector_entidad`, `naturaleza_obra` y `tipo_formato`, de cardinalidad muy heterogénea (desde 2-3 categorías hasta más de cien), En las figuras @img_analisis_categotico_colegiatura_2 al @img_analisis_categotico_tipo_obra_1 se puede observar su distribución respectiva.
- *Variables numéricas continuas*: `monto_aprobado_soles` (fuertemente asimétrica, por lo que se trabaja en escala logarítmica), `n_obras_relacionadas_proyecto`, y los índices `inco_2024_entidad`, `igeip_sector` e `igeip_sector_ejecucion`.
- *Una variable numérica derivada*: `tasa_historica_movil_entidad`, una tasa histórica móvil (media expandida) de paralización por entidad ejecutora, construida específicamente para este estudio (ver sección de Metodología).

#figure(
  image("./assets/figures/img_analisis_categotico_colegiatura_2.png", width: 80%),
  caption: [Análisis categórico de la tasa de paralización por colegiatura 2],
)<img_analisis_categotico_colegiatura_2>

#figure(
  image("./assets/figures/img_analisis_categotico_departamento.png", width: 80%),
  caption: [Análisis categórico de la tasa de paralización por departamento],
)<img_analisis_categotico_departamento>

#figure(
  image("./assets/figures/img_analisis_categotico_des_tipo_formato.png", width: 80%),
  caption: [Análisis categórico de la tasa de paralización por tipo de formato],
)<img_analisis_categotico_des_tipo_formato>

#figure(
  image("./assets/figures/img_analisis_categotico_naturaleza_obra.png", width: 80%),
  caption: [Análisis categórico de la tasa de paralización por naturaleza de la obra],
)<img_analisis_categotico_naturaleza_obra>

#figure(
  image("./assets/figures/img_analisis_categotico_sector.png", width: 80%),
  caption: [Análisis categórico de la tasa de paralización por sector],
)<img_analisis_categotico_sector>

#figure(
  image("./assets/figures/img_analisis_categotico_tipo_obra_1.png", width: 80%),
  caption: [Análisis categórico de la tasa de paralización por tipo de obra],
)<img_analisis_categotico_tipo_obra_1>



Un análisis descriptivo preliminar de la tasa de paralización cruda por departamento muestra heterogeneidad territorial relevante: departamentos como Callao (18.2 %), Tumbes (15.3 %) y Madre de Dios (13.8 %) presentan tasas muy superiores al promedio nacional, mientras que otros se mantienen cerca o por debajo de la tasa general, lo que sustenta la inclusión de variables geográficas como predictores. Adicionalmente, se examinó la matriz de correlación de Pearson entre las variables numéricas continuas y la variable objetivo (tratando esta última como una correlación punto-biserial), con el propósito de detectar colinealidad severa entre predictores antes del modelamiento; no se identificaron pares de variables numéricas con una correlación que sugiriera redundancia crítica, por lo que se optó por no descartar ninguna variable numérica en esta etapa.

= Marco Teórico

El problema se formula como una tarea de clasificación binaria supervisada. Sea $D = {(x_i, y_i)}_(i=1)^N$ un conjunto de datos donde $x_i in RR^p$ representa el vector de $p$ características de la $i$-ésima obra pública, $y_i in {0,1}$ indica si la obra se paralizó por incumplimiento contractual, y $N$ es el número de observaciones. El objetivo es estimar una función $f: RR^p arrow.r [0,1]$ tal que $hat(p)_i = f(x_i) = P(y_i = 1 | x_i)$, entendida como el riesgo cuantitativo de paralización. Se compararon ocho especificaciones estadísticas de $f$, agrupadas en cuatro familias.

== Regresión logística (M0 y M2)

La regresión logística modela la probabilidad mediante el enlace canónico *logit* de la familia binomial:
$ log(p / (1-p)) = beta_0 + sum_(j=1)^k beta_j X_j $
de modo que $p = 1 / (1 + exp(-(beta_0 + X^top beta)))$. Bajo este enlace, $exp(beta_j)$ se interpreta directamente como un *odds ratio*: el factor por el cual se multiplican los momios (_odds_) de paralización ante un incremento unitario de $X_j$, manteniendo lo demás constante.

Se ajustaron dos variantes: `M0`, una regresión logística estimada por máxima verosimilitud sin ponderar por clase ni penalizar los coeficientes (la especificación "clásica" de libro de texto), utilizada como línea base; y `M2`, una regresión logística con penalización *Elastic Net* -que combina las penalizaciones Ridge ($ell_2$) y Lasso ($ell_1$) mediante un parámetro de mezcla $alpha$- y ponderación de clase, cuyos hiperparámetros ($C$, inverso de la fuerza de regularización, y `l1_ratio` $= alpha$) se seleccionaron mediante validación cruzada.

== Modelos Lineales Generalizados con enlaces alternativos (M4 y M5)

Un Modelo Lineal Generalizado (GLM) extiende la regresión lineal permitiendo que la media de la variable respuesta se relacione con el predictor lineal a través de una función de enlace $g$ no necesariamente identidad: $g(p_i) = X_i^top beta$. Además del enlace logit, este estudio incorpora dos enlaces adicionales de la familia binomial:

- *Complementary log-log (c-loglog)* (`M4`): $g(p) = log(-log(1-p))$, de donde $p = 1 - exp(-exp(X^top beta))$. Este enlace es asimétrico -a diferencia del logit y el probit, que son simétricos alrededor de $p=0.5$- y es el enlace canónico de los modelos de riesgos proporcionales en tiempo discreto, por lo que $exp(beta_j)$ se interpreta como una *razón de riesgos* (_hazard ratio_) y no como un odds ratio.
- *Probit* (`M5`): $g(p) = Phi^(-1)(p)$, la inversa de la función de distribución acumulada normal estándar. Es también simétrico, pero sus coeficientes no admiten una interpretación multiplicativa cerrada como el odds ratio del logit; se interpretan mejor a través del signo y de comparaciones de probabilidades predichas entre escenarios.

== Modelos Aditivos Generalizados (M6, M7 y M8)

Un Modelo Aditivo Generalizado (GAM) relaja el supuesto de linealidad del predictor de un GLM, reemplazando el término lineal de cada variable continua por una función suave estimada a partir de los datos:
$ g(p) = beta_0 + sum_j f_j (X_j) + X_"cat"^top beta $
donde $f_j$ se representa mediante una base de splines (en este estudio, B-splines cúbicos) y se penaliza su rugosidad mediante un parámetro de suavizado $alpha$, para evitar el sobreajuste. Se ajustaron tres GAM, uno por cada función de enlace considerada (`M6`: logit, `M7`: c-loglog, `M8`: probit), donde las variables categóricas entran como términos lineales (dummies) y las variables continuas como términos suaves. A diferencia de un GLM lineal, el efecto de una variable suave no se resume en un único coeficiente: se interpreta comparando la probabilidad predicha entre dos valores concretos de la variable (por ejemplo, su percentil 10 y su percentil 90), manteniendo el resto de variables constante.

== Random Forest como referencia de contraste

Como benchmark de aprendizaje automático no paramétrico, se incluyó un Random Forest (`RF`), un ensamble de árboles de decisión entrenados sobre remuestreos _bootstrap_ de los datos (_bagging_) y promediados para producir la probabilidad de la clase positiva. A diferencia de los modelos anteriores, no existe un vector de coeficientes $beta$ interpretable; su importancia se documenta mediante la reducción de impureza durante el entrenamiento y, de forma más confiable, mediante importancia por permutación fuera de muestra.

== Criterios e indicadores de comparación

Dado que el producto de interés no es solo una etiqueta sino una probabilidad de riesgo, los modelos se compararon bajo cuatro dimensiones, y no únicamente por su capacidad de clasificación a un umbral fijo:

+ *Discriminación*: el Área Bajo la Curva ROC (ROC AUC) y el Área Bajo la Curva Precisión-Recall (PR AUC), esta última más informativa que la primera bajo fuerte desbalance de clases, puesto que la curva PR es sensible a la escasez de la clase positiva mientras que la ROC no lo es. Se reporta también el coeficiente de Gini ($= 2 dot "ROC AUC" - 1$), de uso habitual en modelos de scoring de riesgo.
+ *Calibración*: el *Brier score*, $B S = (1\/n) sum_i (hat(p)_i - y_i)^2$ (menor es mejor), que mide si la probabilidad predicha es, en promedio, una buena estimación de la frecuencia observada, y la *curva de calibración*, que compara gráficamente la probabilidad predicha promedio por bin contra la frecuencia observada en ese bin, siendo la diagonal la calibración perfecta. Dos modelos con AUC similar pueden tener probabilidades muy distintas de confiables; esta dimensión es la que distingue un modelo de clasificación de un modelo de estimación de riesgo.
+ *Decisión a un umbral operativo*: precisión, recall, F1 y F2-score. Se prioriza el $F_beta$ con $beta=2$, que pondera el recall el doble que la precisión, dado que en este problema el costo de no detectar una obra que sí se paralizará (falso negativo) se considera mayor que el costo de investigar una obra que finalmente no se paraliza (falso positivo).
+ *Interpretabilidad*: la posibilidad de traducir los parámetros del modelo en afirmaciones sustantivas sobre el fenómeno (odds ratio, razón de riesgo, comparación de escenarios, importancia de variables), un criterio cualitativo pero relevante para la adopción institucional del modelo.

Adicionalmente, para los modelos GLM y GAM se reportan el Criterio de Información de Akaike (AIC $= 2k - 2 hat(ell)$) y el Criterio de Información Bayesiano (BIC $= k ln(n) - 2 hat(ell)$, con $hat(ell)$ la log-verosimilitud maximizada y $k$ el número de parámetros), que permiten comparar la bondad de ajuste de especificaciones anidadas o alternativas penalizando la complejidad del modelo, aunque no son comparables entre esta familia y `M0`/`M2`/`RF` por no compartir la misma forma de verosimilitud o parametrización.

#figure(
  image("./assets/figures/img_metricas_clasificacion_desbalanceada.png", width: 100%),
  caption: [Taxonomia de metricas para clasificacion desbalanceada @brownlee2020imbalanced],
)<img_particion_temporal_train_test>

= Metodología

== Esquema experimental y partición de datos

Se utilizó una partición *temporal* (no aleatoria) de los datos: las observaciones se ordenaron por `fecha_inicio_obra` y se asignó el 62 % más antiguo a entrenamiento y el 38 % restante a prueba. Esta decisión reproduce el escenario de uso real del modelo -entrenar con la historia de ejecuciones pasadas para estimar el riesgo de obras que todavía no han sido observadas- y evita que una partición aleatoria filtre información del futuro hacia el pasado. El conjunto de entrenamiento quedó conformado por 1,628 obras (periodo 2010-12-18 a 2022-10-22, con una tasa de paralización de 8.48 %) y el conjunto de prueba por 999 obras (periodo 2022-10-22 a 2025-12-20, con una tasa de paralización de 5.91 %); esta diferencia en la tasa base entre ambos periodos es, en sí misma, evidencia adicional de la naturaleza no estacionaria del fenómeno y refuerza la pertinencia de una validación temporal frente a una aleatoria.

#figure(
  image("./assets/figures/img_particion_temporal_train_test.png", width: 60%),
  caption: [Particion temporal de los datos en entrenamiento y prueba],
)<img_particion_temporal_train_test>


Para la selección de modelo y de hiperparámetros de las dos familias compatibles con `scikit-learn` (`M2` y `RF`), se aplicó *validación cruzada anidada*: un bucle externo (`TimeSeriesSplit`, 5 particiones) que respeta el orden temporal para estimar el desempeño de cada familia, y un bucle interno (`TimeSeriesSplit`, 3 particiones) que realiza la búsqueda de hiperparámetros (`GridSearchCV`, optimizando PR-AUC) dentro de cada partición externa, de modo que ninguna observación usada para elegir hiperparámetros en un pliegue se utiliza también para evaluar ese mismo pliegue. Los modelos `M4`, `M5`, `M6`, `M7` y `M8`, al depender de `statsmodels` -que no expone una interfaz de hiperparámetros compatible con `scikit-learn`-, no participan de esta búsqueda automatizada; se tratan como especificaciones teóricas alternativas (distinta función de enlace, término lineal o aditivo) que se comparan directamente por su desempeño en prueba y por AIC/BIC.

== Ingeniería de características

El vector de características se construyó combinando tres estrategias de codificación, según la naturaleza de cada variable categórica:

- *Target encoding con suavizado bayesiano* para variables de cardinalidad media/alta (`tipo_obra_nivel_2`, `tipo_obra_nivel_3`, `departamento`, `provincia`): cada categoría se reemplaza por una media ponderada entre su tasa de paralización observada en entrenamiento y la tasa global, con un peso $n_c \/ (n_c + s)$ que da más crédito a categorías con más observaciones ($s=20$).
- *Weight of Evidence (WOE)* con el mismo esquema de suavizado, para `codigo_entidad` y `sector_entidad`, variables de muy alta cardinalidad donde interesa además cuantificar su poder predictivo mediante el Information Value.
- *One-hot encoding* para variables de baja cardinalidad (`naturaleza_obra`, `tipo_formato`, `tipo_obra_nivel_1`).

Ambos encoders supervisados (target encoding y WOE) se ajustan exclusivamente con el conjunto de entrenamiento -dentro de un mismo `Pipeline` de `scikit-learn` para `M2` y `RF`, de modo que se reajustan de forma independiente en cada partición de la validación cruzada- para evitar fuga de información del conjunto de prueba hacia el ajuste del modelo. La variable `monto_aprobado_soles` se trata mediante winsorización al percentil 99 seguida de una transformación logarítmica y estandarización, ajustadas también solo con entrenamiento, dada su fuerte asimetría.

Como característica adicional de naturaleza temporal, se construyó `tasa_historica_movil_entidad`: una media expandida (_expanding mean_) de la tasa de paralización de la entidad ejecutora, calculada únicameente con las obras *anteriores en el tiempo* de esa misma entidad (mediante un desfase de un periodo que excluye la observación actual). Esta variable es el análogo, para datos de panel con una única observación por proyecto, de un rezago o media móvil en series de tiempo, y es estrictamente causal -no utiliza información futura- por lo que puede calcularse sobre el conjunto completo antes de la partición train/test sin incurrir en fuga de datos. Las variables `inco_2024_entidad`, `igeip_sector` e `igeip_sector_ejecucion` se incorporan como variables numéricas continuas, con imputación de valores faltantes por la *mediana* (calculada también solo sobre entrenamiento), una estrategia robusta frente a valores atípicos y adecuada dada la elevada proporción de nulos de las dos últimas.

== Tratamiento del desbalance de clases

Dado que la clase positiva representa entre el 6 % y el 9 % de las observaciones según el periodo, se optó deliberadamente por no aplicar técnicas de sobre/sub-muestreo (SMOTE, _undersampling_, etc.). Alterar artificialmente la proporción de clases en el conjunto de entrenamiento distorsiona la probabilidad base que un GLM/GAM estima por máxima verosimilitud esto por que el intercepto dejaría de reflejar el log-odds o log-riesgo real de la población, lo cual es incompatible con el objetivo de mantener la interpretación de los coeficientes como odds ratio u odds ratio (razón de riesgo). En su lugar, se utilizaron *pesos de caso*: cada observación pondera su contribución a la log-verosimilitud según el inverso de la frecuencia de su clase ($w_c = n \/ (2 dot n_c)$, la misma fórmula que emplea `class_weight="balanced"` de `scikit-learn`), lo que constituye una forma de aprendizaje costo-sensible que preserva el tamaño de muestra observado y la validez de la estimación de máxima verosimilitud, a diferencia del remuestreo. Se aplicó a `M2`, `RF`, `M4`, `M5`, `M6`, `M7` y `M8`; únicamente `M0` se dejó sin ponderar.

Durante la implementación se identificó que el ajuste ponderado de `M4`-`M8` mediante los algoritmos iterativos por defecto de `statsmodels` (IRLS para GLM, PIRLS para GAM) podía divergir bajo el enlace c-loglog, produciendo coeficientes de magnitud extrema y log-verosimilitudes numéricamente inconsistentes; asimismo, la estimación por máxima verosimilitud no ponderada de `M0` no convergía con el método de Newton-Raphson por defecto, un síntoma de cuasi-separación dado el número de variables dummy de baja frecuencia relativas al tamaño de la muestra. En ambos casos se optó por reemplazar el optimizador por defecto por *BFGS* (un método quasi-Newton de propósito general que maximiza directamente la log-verosimilitud ponderada), lo cual estabilizó el ajuste de los ocho modelos.

== Reproducibilidad

Todos los estimadores con componente aleatoria (`RandomForestClassifier`, el solver `saga` de la regresión logística) se fijaron con una semilla única (`RANDOM_STATE = 42`). Las particiones de validación cruzada temporal (`TimeSeriesSplit`) son deterministas por construcción, sin mezcla aleatoria. Todo el preprocesamiento (winsorización, estandarización, imputación por mediana, target encoding, WOE, one-hot) se encapsuló en un único `Pipeline`/`ColumnTransformer` de `scikit-learn`, reutilizable y ajustado exclusivamente con datos de entrenamiento, lo que garantiza que el flujo completo de ajuste y predicción sea reproducible.

= Resultados

La @tabla-comparativa-final presenta las métricas de desempeño de los ocho modelos sobre el conjunto de prueba, evaluadas a un umbral de decisión fijo de 0.5 para comparar en igualdad de condiciones.

#figure(
  table(
    columns: 9,
    align: (left, right, right, right, right, right, right, right, right),
    [*Modelo*], [*ROC AUC*], [*PR AUC*], [*Gini*], [*Brier*], [*Precisión*], [*Recall*], [*F1*], [*F2*],
    [M0 – Logística base], [0.689], [0.180], [0.378], [0.061], [0.192], [0.085], [0.118], [0.095],
    [M2 – Logística Elastic Net], [0.661], [0.150], [0.322], [0.205], [0.106], [0.559], [0.179], [0.302],
    [RF – Random Forest], [0.633], [0.139], [0.267], [0.135], [0.141], [0.441], [0.213], [0.309],
    [M4 – GLM c-loglog], [0.686], [0.169], [0.372], [0.187], [0.131], [0.610], [0.216], [*0.353*],
    [M5 – GLM probit], [0.669], [0.154], [0.338], [0.203], [0.124], [0.627], [0.207], [0.346],
    [M6 – GAM logit], [0.659], [0.163], [0.318], [*0.066*], [0.176], [0.102], [0.129], [0.111],
    [M7 – GAM c-loglog], [0.660], [0.169], [0.321], [0.067], [0.167], [0.102], [0.126], [0.110],
    [M8 – GAM probit], [0.653], [0.156], [0.305], [0.067], [0.121], [0.068], [0.087], [0.074],
  ),
  caption: [Comparativa final de métricas de desempeño (conjunto de prueba, umbral = 0.5).],
) <tabla-comparativa-final>

Todos los modelos ponderados (`M2`, `M4`, `M5`) y el Random Forest muestran mejoras notorias en recall frente a `M0`, a costa de una precisión reducida. `M4` alcanza el mayor F2-score (0.353) y un recall de 0.610, seguido de cerca por `M5` (F2 = 0.346, recall = 0.627). Los tres GAM ponderados (`M6`-`M8`) obtienen, en cambio, el mejor Brier score del conjunto (0.066-0.067), muy por debajo del resto de modelos ponderados, y comparable al de `M0` (0.061), pese a estar igualmente ponderados por clase.

La @tabla-nested-cv resume la validación cruzada anidada utilizada para comparar y seleccionar entre `M2` y `RF`.

#figure(
  table(
    columns: 4,
    align: (left, right, right, right),
    [*Familia*], [*ROC AUC (media ± de)*], [*PR AUC (media ± de)*], [*F2 (media ± de)*],
    [M2 – Logística Elastic Net], [0.683 ± 0.106], [0.236 ± 0.097], [0.326 ± 0.133],
    [RF – Random Forest], [0.716 ± 0.100], [0.269 ± 0.145], [0.177 ± 0.140],
  ),
  caption: [Validación cruzada anidada (5 particiones externas × 3 internas, sobre entrenamiento) para la selección entre `M2` y `RF`.],
) <tabla-nested-cv>

`RF` resultó con mejor PR-AUC promedio en la validación cruzada anidada (0.269 frente a 0.236 de `M2`), por lo que fue seleccionado como familia recomendada de ese subconjunto; sus hiperparámetros finales, obtenidos por búsqueda en grilla sobre todo el entrenamiento, fueron `n_estimators = 200`, `max_depth = 6` y `min_samples_leaf = 5` (PR-AUC de validación cruzada interna = 0.246), frente a `C = 0.01` y `l1_ratio = 0` (equivalente a una penalización Ridge pura) para `M2` (PR-AUC = 0.205).

La @tabla-aic-bic reporta el AIC, BIC y la log-verosimilitud de los cinco modelos ajustados por máxima verosimilitud ponderada.

#figure(
  table(
    columns: 4,
    align: (left, right, right, right),
    [*Modelo*], [*AIC*], [*BIC*], [*Log-verosimilitud*],
    [M4 – GLM c-loglog], [1302.08], [1474.73], [-619.04],
    [M5 – GLM probit], [1308.89], [1481.53], [-622.44],
    [M6 – GAM logit], [690.66], [1057.53], [-277.33],
    [M7 – GAM c-loglog], [682.61], [1049.47], [-273.30],
    [M8 – GAM probit], [683.31], [1050.18], [-273.66],
  ),
  caption: [AIC, BIC y log-verosimilitud de los modelos GLM y GAM. No son comparables directamente con `M0`, `M2` ni `RF`, que no comparten la misma parametrización o forma de verosimilitud.],
) <tabla-aic-bic>

Los tres GAM alcanzan una log-verosimilitud sustancialmente mayor (menos negativa) que los dos GLM lineales, y su menor AIC así lo confirma; su BIC, en cambio, es mayor que el de los GLM debido al número mucho más alto de parámetros efectivos que introduce la base de splines, lo que penaliza su complejidad adicional.

En cuanto a la interpretabilidad, la tabla de razones de momios (_odds ratio_) de `M0` identifica como estadísticamente significativas (p < 0.05) cuatro variables: `woe__codigo_entidad_woe` ($beta = 1.428$, OR = 4.17), `target_encoded__provincia_target_enc` ($beta = 0.916$, OR = 2.50), el logaritmo winsorizado del monto aprobado ($beta = 0.714$, OR = 2.04), todas con efecto positivo sobre el riesgo, y la categoría `naturaleza_obra = Instalación` ($beta = -3.05$, OR = 0.047), con un efecto protector marcado. El mismo patrón -mayor riesgo asociado al historial de la entidad (WOE), a la ubicación geográfica (target encoding de provincia) y al monto del proyecto- se repite en `M2` (regresión logística penalizada) y en `M4` (razón de riesgo bajo c-loglog), y coincide con las tres primeras variables de la importancia por impureza de `RF` (`codigo_entidad` (WOE), monto y provincia). La importancia por permutación fuera de muestra de `RF` (@tabla-permutacion) ubica en cambio a `naturaleza_obra`, `tipo_formato` y `monto_aprobado_soles` como las variables cuya permutación más deteriora el PR-AUC en prueba.

#figure(
  table(
    columns: 3,
    align: (left, right, right),
    [*Variable*], [*Importancia media*], [*Desv. estándar*],
    [naturaleza\_obra], [0.0398], [0.0049],
    [tipo\_formato], [0.0202], [0.0156],
    [monto\_aprobado\_soles], [0.0181], [0.0203],
    [codigo\_entidad], [0.0169], [0.0178],
    [departamento], [0.0041], [0.0085],
  ),
  caption: [Cinco variables con mayor importancia por permutación (PR-AUC, conjunto de prueba) para `RF`.],
) <tabla-permutacion>

= Discusión de resultados

El hallazgo más relevante de la comparación es el contraste entre ponderar por clase y mantener una buena calibración. Los tres modelos con mejor recall y F2-score (`M2`, `M4`, `M5`) son también los de peor Brier score (0.19-0.21), mientras que `M0` -el único modelo no ponderado- exhibe el mejor Brier score (0.061) junto con un recall casi nulo al umbral de 0.5. Esto no es una contradicción sino la manifestación directa de lo que se discutió en la sección de Metodología: ponderar por clase desplaza artificialmente el intercepto del modelo para compensar el desbalance, lo que mejora la sensibilidad de la regla de decisión pero hace que las probabilidades predichas dejen de reflejar fielmente la frecuencia real observada. Es decir, `M0` responde con precisión a la pregunta "¿qué tan probable es, en términos absolutos, que esta obra se paralice?", mientras que `M2`, `M4` y `M5` responden mejor a la pregunta "¿esta obra pertenece al grupo de mayor riesgo relativo?".

Los tres GAM ponderados (`M6`-`M8`) no reproducen esta degradación de calibración: su Brier score (0.066-0.067) es casi idéntico al de `M0` pese a estar igualmente ponderados por clase. Una explicación plausible es que la flexibilidad de los términos suaves permite absorber parte de la distorsión que la ponderación introduce en un modelo puramente lineal, recalibrando implícitamente la forma de la función de enlace en distintas regiones del espacio de predictores. Esta observación sugiere que, en problemas con fuerte desbalance donde se busca preservar tanto recall como calibración, un GAM ponderado puede ser preferible a un GLM lineal ponderado equivalente -aunque en este estudio dicha ganancia de calibración tuvo como contrapartida un recall mucho menor (0.07-0.10), por lo que el punto de operación de estos modelos aún requeriría desplazar el umbral de decisión por debajo de 0.5 para resultar operativamente útil.

El desempeño de `RF` refleja la disyuntiva discutida en el Marco Teórico: aunque en la validación cruzada anidada sobre entrenamiento `RF` superó a `M2` en PR-AUC promedio (0.269 frente a 0.236), en el conjunto de prueba su discriminación (ROC AUC = 0.633, PR AUC = 0.139) resultó inferior a la de varios GLM/GAM, y su Brier score (0.135) fue intermedio -mejor que el de los GLM lineales ponderados, pero notoriamente peor que el de `M0` y los GAM ponderados-. A esto se suma que `RF` no ofrece coeficientes interpretables como odds ratio o razón de riesgo, solo una importancia agregada sin signo. En consecuencia, la superioridad de `RF` observada únicamente en la validación cruzada de entrenamiento no se sostuvo de forma consistente en la evaluación final fuera de muestra, lo cual es en sí mismo un recordatorio metodológico relevante: la elección de un modelo no debe basarse en el desempeño de una sola instancia de validación, y menos aún cuando se trata de familias con capacidades de generalización muy distintas.

En términos de interpretación sustantiva, la consistencia del patrón encontrado en `M0`, `M2`, `M4` y en la importancia de `RF` -mayor riesgo asociado al historial de incumplimiento de la propia entidad ejecutora (codificado vía WOE), a la ubicación geográfica del proyecto (codificada vía target encoding de provincia) y al monto aprobado de la obra- es consistente con la intuición de negocio y con la literatura de gestión de riesgos contractuales, que señala el desempeño histórico de los actores involucrados como uno de los predictores más robustos del comportamiento futuro. El coeficiente negativo y significativo de la categoría `naturaleza_obra = Instalación` en `M0` y `M4` (razón de riesgo de 0.14-0.15) sugiere que, controlando por las demás variables, este tipo de intervención -típicamente de menor complejidad técnica que una construcción o reconstrucción completa- conlleva un riesgo de paralización sustancialmente menor. Cabe señalar, sin embargo, que la mayoría de las categorías de `tipo_obra_nivel_1` y varias de `naturaleza_obra` no resultaron estadísticamente significativas en ningún modelo GLM, con errores estándar muy amplios en algunas de ellas (síntoma de cuasi-separación dado el tamaño de muestra relativamente reducido, 1,628 observaciones de entrenamiento, frente al número de categorías); esto es una limitación relevante que se retoma en las Conclusiones.

= Conclusiones

+ El desarrollo de ocho modelos estadísticos permitió confirmar que existen factores observables en los registros administrativos, el historial de incumplimiento de la entidad ejecutora, la ubicación geográfica del proyecto y el monto aprobado, asociados de forma consistente al riesgo de paralización de obras públicas por incumplimiento contractual, independientemente de la especificación estadística utilizada.
+ No existe un único "mejor modelo" cuando el objetivo es estimar una probabilidad de riesgo y no solo clasificar: si el criterio de selección es el F2-score (mayor peso al recall), `M4` (GLM binomial c-loglog ponderado) resulta el más adecuado, con F2 = 0.353 y recall = 0.610; si el criterio de selección es la calibración (Brier score), `M0` (regresión logística sin ponderar) y los tres GAM ponderados (`M6`-`M8`) son claramente superiores. Dado que el propósito último del estudio es producir una medida cuantitativa de riesgo, se recomienda `M4` como el mejor compromiso operativo entre capacidad de detección, calibración razonable e interpretabilidad de sus coeficientes como razones de riesgo, con la salvedad explícita de que sus probabilidades deben leerse como una medida de riesgo relativo y no como una frecuencia esperada literal, dada la distorsión de calibración que introduce la ponderación por clase.
+ Ponderar por clase para atender el desbalance mejora sustancialmente el recall de los modelos lineales (GLM) a costa de su calibración, mientras que esta misma estrategia aplicada sobre modelos aditivos (GAM) preserva una calibración mucho mejor, aunque con un recall considerablemente menor bajo el umbral de decisión por defecto. Esta disyuntiva debería ser un criterio explícito de diseño en cualquier extensión futura de este trabajo, y no un efecto secundario no documentado.
+ El benchmark de Machine Learning (Random Forest) no ofreció, en el conjunto de prueba, una ventaja consistente frente a los modelos estadísticos más simples, pese a haber mostrado el mejor PR-AUC en la validación cruzada de entrenamiento; esto refuerza el valor de mantener modelos estadísticos interpretables como referencia, incluso cuando existen algoritmos de aprendizaje automático más flexibles disponibles.
+ El estudio presenta limitaciones que deben considerarse en la interpretación de sus resultados. Primero, el tamaño de muestra disponible tras los filtros funcionales (2,627 observaciones, con solo 138-190 casos positivos según el periodo) es reducido en relación con el número de categorías de algunas variables (p. ej. `provincia`, `tipo_obra_nivel_3`), lo que se manifestó en problemas de convergencia y cuasi-separación en la regresión logística no penalizada y en amplios intervalos de confianza para varias categorías dummy. Segundo, los índices `igeip_sector` e `igeip_sector_ejecucion` presentan una proporción considerable de valores faltantes (19.3 %) y una dispersión reducida entre entidades, lo que limitó su aporte discriminante observado en este estudio; una cobertura más amplia de este índice podría revelar un poder predictivo mayor, el indice IGEIP tambien puede calcularse a nivel de entidad ejecutora sin embarggo el acceso a este dato no se encuentra diponible en la pagina web del MEF. Tercero, la inestabilidad numérica detectada en el ajuste ponderado por máxima verosimilitud bajo el enlace c-loglog (y, en menor medida, en el AIC/BIC nativo de los GAM penalizados) obligó a sustituir el optimizador por defecto de `statsmodels`, lo que sugiere que estos resultados deberían replicarse con otras implementaciones de software antes de adoptarse en un entorno de producción. Es pertinente enriquecer los datos de las variables predictoras investigando información del contratista, para ello se debe explorar los datos que disponibiliza el OECE, datos como la tasa de arbitrajes o obras paralizadas por parte de los proveedores tendrian un efecto positivo en la capacidad predictiva del modelo @solis-villanueva_tecnicas_2018.
+ Como líneas de trabajo futuro, se recomienda: (i) explorar técnicas de recalibración post-hoc (por ejemplo, escalado de Platt o regresión isotónica) sobre los modelos ponderados que mostraron mejor recall, para intentar recuperar parte de la calibración perdida sin sacrificar sensibilidad; (ii) ampliar la cobertura temporal y el tamaño de muestra disponible, en particular para estabilizar la estimación de las categorías de menor frecuencia; (iii) evaluar el desempeño del modelo bajo un esquema de validación cruzada temporal de origen móvil (_rolling origin_), en lugar de una única partición train/test, para estimar con mayor precisión su estabilidad ante cambios de contexto; y (iv) incorporar técnicas de interpretabilidad complementarias (por ejemplo, valores SHAP) si en el futuro se optara por priorizar un modelo de aprendizaje automático de mayor capacidad sobre la familia de modelos estadísticos trabajados en el presente informe.

= Anexo

El desarrollo completo del análisis -carga de datos, limpieza, ingeniería de características, ajuste de los ocho modelos, validación cruzada anidada y comparación final- se encuentra documentado y es reproducible en el notebook `mead_project/proyecto_final_modelado.ipynb`, que hace uso de utilidades reutilizables definidas en los módulos `src/features/` (transformadores de codificación y construcción del preprocesador) y `src/evaluation/` (métricas, curvas de calibración y tablas de importancia/interpretabilidad) del repositorio del proyecto. La fuente de datos integrada utilizada corresponde al archivo `data/gold/ds_op_inco_igeip.csv`.

#pagebreak()

#bibliography("mia-tesis-opa.bib", title: "Bibliografía")
