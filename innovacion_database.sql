
-- ==============================================================
-- Enumerados para tipos específicos
CREATE TYPE SEXO_ENUM AS ENUM ('Masculino', 'Femenino', 'Intersexual');
CREATE TYPE GENERO_ENUM AS ENUM ('Hombre', 'Mujer', 'No binario', 'Género fluido', 'Agénero', 'Prefiero no decirlo', 'Otro');
CREATE TYPE TIPO_DOCUMENTO_PERSONA_ENUM AS ENUM ('Cédula de Ciudadanía (CC)', 'Tarjeta de Identidad (TI)', 'Cédula de Extranjería (CE)', 'Pasaporte (P)', 'Registro Civil (RC)', 'NIT (Número de Identificación Tributaria)', 'Documento Nacional de Identidad (DNI)', 'Permiso Especial de Permanencia (PEP)');
CREATE TYPE ESTRATO_SOCIOECONOMICO_ENUM AS ENUM ('Estrato 1 (Bajo-bajo)', 'Estrato 2 (Bajo)', 'Estrato 3 (Medio-bajo)', 'Estrato 4 (Medio)', 'Estrato 5 (Medio-alto)', 'Estrato 6 (Alto)');

CREATE TYPE CATEGORIA_EMPRESA_ENUM AS ENUM ('Microempresa', 'Pequeña empresa', 'Mediana empresa', 'Gran empresa');
CREATE TYPE ZONA_EMPRESA_ENUM AS ENUM ('Urbana', 'Rural', 'Periurbana');
CREATE TYPE SECTOR_EMPRESA_ENUM AS ENUM ('Tecnología', 'Comercio', 'Servicios', 'Industria', 'Agricultura');
CREATE TYPE TIPO_EMPRESA_ENUM AS ENUM ('Tecnología', 'Comercio', 'Servicios', 'Industria', 'Agricultura', 'Institución educativa');
CREATE TYPE ROL_ENUM AS ENUM ('Empleado', 'Gerente', 'Socio', 'Fundador', 'Inversionista');
CREATE TYPE MAGNITUD_EMPRESA_ENUM AS ENUM ('Grande', 'Mediana', 'Pequeña');

CREATE TYPE TIPO_UNIDAD_ACADEMICA_ENUM AS ENUM ( ' Facultad ' , ' Escuela ' , ' Instituto ' , ' Corporación ' );
CREATE TYPE TIPO_UBICACION_UNIDAD_IE_ENUM AS ENUM ('Campus', 'Sede', 'Sede única');
CREATE TYPE NIVEL_PROGRAMA_ACADEMICO_ENUM AS ENUM ('Técnica profesional', 'Tecnológico', 'Profesional', 'Especialización', 'Maestría', 'Doctorado');
CREATE TYPE AREA_PROGRAMA_ACADEMICO_ENUM AS ENUM ('Ingeniería', 'Ciencias Sociales', 'Ciencias Naturales', 'Artes', 'Humanidades');
CREATE TYPE ESTADO_ACADEMICO_ENUM AS ENUM ('En curso', 'Graduado', 'Retirado');
CREATE TYPE TIPO_EMPLEO_ENUM AS ENUM ('Temporal', 'Fijo', 'Mixto');
CREATE TYPE ESTADO_DESARROLLO_EMPREN_ENUM AS ENUM ('En incubación', 'Consolidado', 'En pausa', 'Finalizado');

CREATE TYPE ETADO_PROGRAMA_ENUM AS ENUM ('Activo', 'Inactivo', 'En desarrollo', 'Finalizado');
CREATE TYPE PRIORIDAD_PROGRAMA_ENUM AS ENUM ('Alta', 'Media', 'Baja');
CREATE TYPE ETAPA_PROGRAMA_ENUM AS ENUM ('Planificación', 'Ejecución', 'Cierre', 'Post-cierre');

CREATE TYPE ESTADO_PROYECTO_ENUM AS ENUM ('Pendiente', 'En ejecución', 'Finalizado', 'Cancelado');
CREATE TYPE PRIORIDAD_PROYECTO_ENUM AS ENUM ('Alta', 'Media', 'Baja');
CREATE TYPE ETAPA_PROYECTO_ENUM AS ENUM ('Planificación', 'Ejecución', 'Cierre', 'Post-cierre');
CREATE TYPE TIPO_APORTE_ENUM AS ENUM ('Gubernamental', 'Privado', 'Internacional', 'Mixto');
CREATE TYPE ESTADO_FINANCIACION_ENUM AS ENUM ('Aprobado', 'Pendiente', 'Rechazado', 'Finalizado');

CREATE TYPE MODALIDAD_ACTIVIDAD_ENUM AS ENUM ('Virtual', 'Presencial', 'Híbrido');
CREATE TYPE TIPO_ACTIVIDAD_ENUM AS ENUM ('Evento', 'Actividad', 'Curso');

CREATE TYPE TIPO_OPERACION_LOG AS ENUM ('INSERT', 'UPDATE', 'DELETE');

-- ===========================================================================
-- Jerarquía geográfica 
CREATE TABLE pais (
    id_pais                   SERIAL PRIMARY KEY,
    nombre_pais               VARCHAR(100) NOT NULL,
    url_polygon_pais          TEXT,
    codigo_pais               VARCHAR(50)
);

CREATE TABLE departamento (
    id_departamento           SERIAL PRIMARY KEY,
    url_polygon_departamento  TEXT,
    nombre_departamento       VARCHAR(100) NOT NULL,
    id_pais                   INT NOT NULL,

    FOREIGN KEY (id_pais) REFERENCES pais (id_pais) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE region (
    id_region                 SERIAL PRIMARY KEY,
    url_polygon_region        TEXT,
    nombre_region             VARCHAR(100) NOT NULL,
    id_departamento           INT NOT NULL,

    FOREIGN KEY (id_departamento) REFERENCES departamento (id_departamento) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE ciudad (
    id_ciudad                 SERIAL PRIMARY KEY,
    url_polygon_ciudad        TEXT,
    nombre_ciudad             VARCHAR(100) NOT NULL,
    id_region                 INT NOT NULL,
    
    FOREIGN KEY (id_region) REFERENCES region (id_region) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE comuna (
    id_comuna                 SERIAL PRIMARY KEY,
    url_polygon_comuna        TEXT,
    nombre_comuna             VARCHAR(100) NOT NULL,
    id_ciudad                 INT NOT NULL,
    
    FOREIGN KEY (id_ciudad) REFERENCES ciudad (id_ciudad) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE barrio (
    id_barrio                 SERIAL PRIMARY KEY,
    url_polygon_barrio        TEXT,
    nombre_barrio             VARCHAR(100) NOT NULL,
    id_comuna                 INT NOT NULL,
    
    FOREIGN KEY (id_comuna) REFERENCES comuna (id_comuna) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE direccion (
    id_direccion              SERIAL PRIMARY KEY,
    direccion_textual         VARCHAR(200) NOT NULL,
    codigo_postal             CHAR(10),
    id_barrio                 INT NOT NULL,

    FOREIGN KEY (id_barrio) REFERENCES barrio (id_barrio) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ==============================================================
-- Tabla persona
CREATE TABLE persona (
    id_persona                   SERIAL PRIMARY KEY,
    nombres_persona              VARCHAR(100) NOT NULL,
    apellidos_persona            VARCHAR(100) NOT NULL,
    tipo_documento_persona       TIPO_DOCUMENTO_PERSONA_ENUM NOT NULL,
    numero_documento_persona     VARCHAR(50) UNIQUE NOT NULL,
    sexo_biologico               SEXO_ENUM NOT NULL,
    genero                       GENERO_ENUM NOT NULL,
    telefono_celular             VARCHAR(20),
    correo_electronico           VARCHAR(100) UNIQUE NOT NULL,
    estrato_socioeconomico       ESTRATO_SOCIOECONOMICO_ENUM,
    fecha_nacimiento_persona     DATE NOT NULL,
    es_emprendedor               BOOLEAN DEFAULT FALSE,   
    foto_persona_url             TEXT,              
    fecha_creacion_registro      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_ultima_actualizacion   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla empresa
CREATE TABLE empresa (
    id_empresa                        SERIAL PRIMARY KEY,
    nombre_empresa                    VARCHAR(100) NOT NULL UNIQUE,
    categoria_empresa                 CATEGORIA_EMPRESA_ENUM NOT NULL,
    zona_empresa                      ZONA_EMPRESA_ENUM NOT NULL,
    sector_empresa                    SECTOR_EMPRESA_ENUM NOT NULL,
    tipo_empresa                      TIPO_EMPRESA_ENUM NOT NULL,
    magnitud_empresa                  MAGNITUD_EMPRESA_ENUM,  
    naturaleza_juridica               VARCHAR(100),
    telefono_empresa                  VARCHAR(20),
    correo_empresa                    VARCHAR(100) UNIQUE NOT NULL,
    logo_empresa_url                  TEXT,
    es_emprendimiento                 BOOLEAN DEFAULT FALSE,
    pertenece_parque                  BOOLEAN DEFAULT FALSE,
    fecha_fundacion_empresa           DATE,
    fecha_creacion_empresa            TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ultima_actualizacion              TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_direccion                      INT,

    FOREIGN KEY (id_direccion) REFERENCES direccion (id_direccion) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla cargos
CREATE TABLE cargo (
    id_cargo                SERIAL PRIMARY KEY,
    nombre_cargo            VARCHAR(100),
    responsabilidades       TEXT
);

-- Tabla relacion_empresa_persona
CREATE TABLE relacion_empresa_persona (
    id_rel_empresa_persona   SERIAL PRIMARY KEY,
    id_persona               INT NOT NULL,
    id_empresa               INT NOT NULL,
    rol                      ROL_ENUM NOT NULL,
    id_cargo                 INT,   

    FOREIGN KEY (id_cargo) REFERENCES cargo (id_cargo) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_persona) REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_empresa) REFERENCES empresa (id_empresa) ON DELETE CASCADE ON UPDATE CASCADE
);


-- ==============================================================
-- Tabla unidad_administrativa
CREATE TABLE unidad_administrativa (
    id_unidad_administrativa         SERIAL PRIMARY KEY,
    nombre_unidad_administrativa     VARCHAR(100) NOT NULL,
    tipo_ubicacion                   TIPO_UBICACION_UNIDAD_IE_ENUM NOT NULL,
    id_direccion                     INT,
    id_empresa                       INT NOT NULL,

    FOREIGN KEY (id_empresa) REFERENCES empresa (id_empresa) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_direccion) REFERENCES direccion (id_direccion) ON DELETE CASCADE ON UPDATE CASCADE
);


-- Tabla subunidad_administrativa
CREATE TABLE subunidad_administrativa (
    id_subunidad_administrativa      SERIAL PRIMARY KEY,
    nombre_subunidad                 VARCHAR(100) NOT NULL,
    id_unidad_administrativa         INT NOT NULL,

    FOREIGN KEY (id_unidad_administrativa) REFERENCES unidad_administrativa (id_unidad_administrativa) ON DELETE CASCADE ON UPDATE CASCADE
);


-- Tabla unidad_academica
CREATE TABLE unidad_academica (
    id_unidad_academica         SERIAL PRIMARY KEY,
    tipo_unidad_academica       TIPO_UNIDAD_ACADEMICA_ENUM NOT NULL,
    nombre_unidad_academica     VARCHAR(100) NOT NULL,
    tipo_ubicacion              TIPO_UBICACION_UNIDAD_IE_ENUM NOT NULL,
    id_direccion                INT,
    id_empresa                  INT NOT NULL,

    FOREIGN KEY (id_empresa) REFERENCES empresa (id_empresa) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_direccion) REFERENCES direccion (id_direccion) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla programa_academico
CREATE TABLE programa_academico (
    id_programa_academico       SERIAL PRIMARY KEY,
    titulo_programa_academico   VARCHAR(100) NOT NULL,
    nivel_programa_academico    NIVEL_PROGRAMA_ACADEMICO_ENUM NOT NULL,
    area_programa_academico     AREA_PROGRAMA_ACADEMICO_ENUM NOT NULL,
    id_unidad_academica         INT NOT NULL,

    FOREIGN KEY (id_unidad_academica) REFERENCES unidad_academica (id_unidad_academica) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla grupo_investigacion
CREATE TABLE grupo_investigacion (
    id_grupo_investigacion       SERIAL PRIMARY KEY,
    nombre_grupo_investigacion   VARCHAR(100) NOT NULL,
    id_unidad_academica          INT NOT NULL,

    FOREIGN KEY (id_unidad_academica) REFERENCES unidad_academica (id_unidad_academica) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla programa_academico_persona
CREATE TABLE programa_academico_persona (
    id_programa_academico_persona  SERIAL PRIMARY KEY,
    id_programa_academico          INT NOT NULL,
    id_persona                     INT NOT NULL,
    fecha_inicio                   DATE,
    fecha_finalizacion             DATE,
    estado_academico               ESTADO_ACADEMICO_ENUM NOT NULL,
    certificado_url                TEXT,

    FOREIGN KEY (id_programa_academico) REFERENCES programa_academico (id_programa_academico) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_persona) REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ===========================================================================
-- Tabla profesion
CREATE TABLE profesion (
    id_profesion       SERIAL PRIMARY KEY,
    titulo_profesion   VARCHAR(100) NOT NULL,
    area_profesion     VARCHAR(100),
    codigo_profesion   VARCHAR(50)
);

-- Tabla profesion_persona 
CREATE TABLE profesion_persona (
    id_persona_profesion  SERIAL PRIMARY KEY,
    id_profesion          INT NOT NULL,
    id_persona            INT NOT NULL,
    anios_experiencia     INT,

    FOREIGN KEY (id_profesion) REFERENCES profesion (id_profesion) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_persona) REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla red_social_persona
CREATE TABLE red_social_persona (
    id_red_social_persona  SERIAL PRIMARY KEY,
    nombre_plataforma      VARCHAR(50) NOT NULL,
    url_perfil             TEXT,
    id_persona             INT NOT NULL,
    FOREIGN KEY (id_persona) REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla red_social_empresa
CREATE TABLE red_social_empresa (
    id_red_social_empresa  SERIAL PRIMARY KEY,
    nombre_plataforma      VARCHAR(50) NOT NULL,
    url_perfil             TEXT,
    id_empresa             INT NOT NULL,

    FOREIGN KEY (id_empresa) REFERENCES empresa (id_empresa) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla emprendimiento
CREATE TABLE emprendimiento (
    id_emprendimiento                SERIAL PRIMARY KEY,
    id_empresa                       INT,
    surgimiento_emprendimiento       VARCHAR(255), 
    estado_desarrollo_emprendimiento ESTADO_DESARROLLO_EMPREN_ENUM NOT NULL,
    cantidad_clientes_promedio_mes   INT,
    tiene_camara_comercio            BOOLEAN DEFAULT FALSE,      
    genera_ingresos                  BOOLEAN,     
    genera_empleo                    BOOLEAN,
    tipo_empleo                      TIPO_EMPLEO_ENUM,
    cantidad_empleados               INT,
    realiza_comercio_internacional   BOOLEAN,

    FOREIGN KEY (id_empresa) REFERENCES empresa (id_empresa) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ===========================================================================
-- Tabla programa
CREATE TABLE programa (
    id_programa                         SERIAL PRIMARY KEY, -- id_programa
    nombre_programa                     VARCHAR(255) NOT NULL, -- Nombre
    responsable_articulacion_programa   VARCHAR(255), -- Nombre del responsable de articular el programa
    nombre_corto_programa               VARCHAR(255), -- Nombre corto - form
    nombre_corto_alt_programa           VARCHAR(255), -- Nombre corto del programa
    objetivo_programa                   TEXT, -- Objetivo general del programa
    tipo_programa                       VARCHAR(100), -- Tipo de programa
    estado_programa                     VARCHAR(100), -- Estado del programa
    unidad_administrativa_programa      VARCHAR(255), -- Unidad académica o administrativa, o entidad externa de distribución del dinero
    anio_programa                       INT, -- Año
    valor_programa                      NUMERIC(15,2), -- Valor
    asuntos_trabajo_programa            TEXT, -- Asuntos de Trabajo del Asunto de Gestión ó Proceso Ejecutable_DI-AP-FO-007
    gestion_procesos_programa           TEXT, -- AG y PE - Asuntos de Gestión y Procesos Ejecutables
    lider_programa                      VARCHAR(255), -- Líder / Coordinador
    cronograma_real_programa            TEXT, -- Cronograma real
    equipo_programa                     TEXT, -- Equipo principal
    roles_funciones_programa            TEXT, -- Roles y funciones
    talento_programa                    TEXT, -- Talento humano
    id_usuarios_programa                INT, -- ID usuarios
    contratos_naturales_programa        TEXT, -- Contratos persona natural
    correo_programa                     VARCHAR(255), -- Correo electrónico
    telefono_programa                   VARCHAR(20), -- Número de teléfono
    estado_rag_programa                 VARCHAR(100), -- Estado del programa (RAG)
    prioridad_programa                  VARCHAR(100), -- Prioridad
    etapa_programa                      VARCHAR(100), -- Etapa
    cronograma_inicio_programa          DATE, -- Cronograma planificado - Start
    cronograma_fin_programa             DATE, -- Cronograma planificado - End
    resumen_estado_programa             TEXT, -- Resumen del estado del proyecto
    objetivo_secundario_programa        TEXT, -- Objetivo general del programa2
    link_mapas_conocimiento_programa    TEXT, -- link a Procesos mapas de conocimientos
    equipo_principal3                   TEXT, -- Euipo principal3
    tipo_programa_texto                 TEXT -- Tipo de programa texto
);


-- Tabla proyecto
CREATE TABLE proyecto (
    id_proyecto                        SERIAL PRIMARY KEY, -- id_proyecto
    estado_proyecto                    VARCHAR(100),   -- estado_proyecto
    prioridad_proyecto                  VARCHAR(100),   -- prioridad
    etapa_proyecto                      VARCHAR(100),   -- etapa
    fecha_inicio_proyecto               DATE,           -- fecha_inicio
    fecha_finalizacion_proyecto         DATE,           -- fecha_finalizacion
    numero_contrato_proyecto            VARCHAR(50),    -- numero_contrato
    objeto_proyecto                     TEXT,           -- objeto_proyecto
    tipo_ingreso_proyecto               VARCHAR(100),   -- tipo_ingreso
    tipo_primario_proyecto              VARCHAR(100),   -- tipo_primario_proyecto
    figura_contractual_proyecto         VARCHAR(100),   -- figura_contractual
    fuente_recurso_proyecto             VARCHAR(255),   -- Fuente_recurso
    alcance_proyecto                    TEXT,           -- alcance
    contribucion_udea_proyecto          NUMERIC(15,2),  -- contribucion_UdeA
    excepcion_contribucion_proyecto     TEXT,           -- excepcion_contribución
    contribucion_division_innovacion    NUMERIC(15,2),  -- contribucion_division_innovacion
    fuente_primaria_financiacion        VARCHAR(255),   -- fuente_primaria_financiacion
    contratante_proyecto                VARCHAR(255),   -- contratante
    valor_proyecto                      NUMERIC(15,2),  -- valor
    moneda_proyecto                     VARCHAR(50),    -- moneda
    aporte_aliado_efectivo_proyecto     NUMERIC(15,2),  -- aporte_aliado_efectivo
    aporte_otros_aliados_especie        NUMERIC(15,2),  -- aporte_otros_aliados_especie
    aporte_otros_aliados_efectivo       NUMERIC(15,2),  -- aporte_otros_aliados_efectivo
    aporte_udea_especie_proyecto        NUMERIC(15,2),  -- aporte_UdeA_especie
    lider_proyecto                      VARCHAR(255),   -- Líder
    adjunto_propuesta_proyecto          TEXT,           -- adjunto_propuesta_proyecto
    adjunto_presupuesto_proyecto        TEXT,           -- adjunto_presupuesto
    adjunto_contrato_proyecto           TEXT,           -- adjunto_contrato
    adjunto_acta_inicio_proyecto        TEXT,           -- adjunto_acta_inicio
    adjunto_polizas_proyecto            TEXT,           -- adjunto_polizas
    adjunto_acta_finalizacion_proyecto  TEXT,           -- adjunto_acta_finalización
    id_programa                         INT,            -- id_programa

    FOREIGN KEY (id_programa) REFERENCES programa(id_programa) ON DELETE SET NULL
);


CREATE TABLE ag_o_pe (
    id_ag_o_pe                           SERIAL PRIMARY KEY, -- id_ag_o_pe
    nombre_ag_o_pe                       VARCHAR(255),   -- nombre_ag_o_pe
    personas_ag_o_pe                      TEXT,           -- Personas
    tipo_ag_pe                            VARCHAR(100),   -- TIPO AG-PE
    procesos_ag_pe                        TEXT,           -- AG y PE - Procesos
    macroproceso_ag_pe                    TEXT,           -- AG y PE - Macroproceso
    proceso_ejecutable_gestion            TEXT,           -- Proceso ejecutable o Asunto de gestión
    marco_proceso_ag_pe                   TEXT,           -- Marco proceso
    sigla_larga_ag_pe                     VARCHAR(100),   -- Sigla larga
    sigla_corta_ag_pe                     VARCHAR(50),    -- Sigla corta
    objetivo_ag_pe                        TEXT,           -- Objetivo
    link_requerimientos_contratos         TEXT,           -- link to Requerimientos de contratos
    conectar_tableros_ag_pe               TEXT,           -- Conectar tableros
    link_asuntos_trabajo_ag_pe            TEXT,           -- link to AG y PE - Asuntos de Trabajo
    componente_descriptivo_ag_pe          TEXT,           -- 2. Componente descriptivo
    reflejo_ag_pe                         TEXT,           -- Reflejo
    link_bitacora_innovacion              TEXT,           -- link to Bitácora_Relacionamiento División de Innovación 2024
    link_talento_humano_ag_pe             TEXT,           -- link to Talento Humano
    link_duplicado_formulario_eventos     TEXT,           -- link to Duplicado de Formulario para el cargue de eventos del ecosistema
    link_subelementos_tactico             TEXT,           -- link to Subelementos de Táctico-Asuntos de Gestión y Procesos Ejecutables
    link_roles_funciones_ag_pe            TEXT            -- link to Roles y funciones
);


CREATE TABLE asunto_de_trabajo_tipo_emprendimiento (
    id_asunto_trabajo                      SERIAL PRIMARY KEY, -- id_asunto_de_trabajo
    nombre_asunto_trabajo                   VARCHAR(255),   -- Nombre asunto de trabajo
    descripcion_asunto_trabajo               TEXT,           -- Objetivo, definición y descripción del Asunto de Trabajo
    ultima_actualizacion_asunto_trabajo      TIMESTAMP,      -- Última actualización
    responsable_asunto_trabajo               VARCHAR(255),   -- Responsable del Asunto de Trabajo
    talento_humano_asunto_trabajo            TEXT,           -- Talento Humano
    perfil_monday_asunto_trabajo             TEXT,           -- Perfil Monday
    procesos_gestion_asunto_trabajo          TEXT,           -- AG y PE - Asuntos de Gestión y Procesos Ejecutables
    proceso_asunto_trabajo                   TEXT,           -- AG y PE - Proceso
    macroproceso_asunto_trabajo              TEXT,           -- AG y PE - Macro Proceso
    nombre_responsable_ag_pe                 VARCHAR(255),   -- Nombre responsable AG-PE
    cuenta_responsable_ag_pe                 VARCHAR(255),   -- Cuenta responsable AG-PE
    link_proyectos_principal                 TEXT,           -- link to Proyectos_PRINCIPAL
    link_programas_principal                 TEXT,           -- link to Programas_PRINCIPAL
    link_nivel_nano                          TEXT,           -- link to Nivel Nano (Acciones, Actividades, Tareas, Sprint’s)
    link_nivel_meso                          TEXT,           -- link to Nivel Meso (Táctico Objetivos por Asuntos de Gestión y Procesos Ejecutables)
    link_bitacora_innovacion                 TEXT,           -- link to Bitácora_Relacionamiento División de Innovación 2024
    link_operacion_asuntos_trabajo           TEXT,           -- link to Operación-Asuntos de trabajo
    agrupacion_asunto_trabajo                TEXT,           -- Agrupación
    link_bitacora_actividades_personal       TEXT,           -- link to Bitacora_Actividades-Personal Contratado 2025
    link_roles_funciones_asunto_trabajo      TEXT,           -- link to Roles y funciones
    link_portafolio_servicios                TEXT,           -- link to Portafolio de servicios
    id_ag_o_pe                               INT,            -- id_ag_o_pe

    FOREIGN KEY (id_ag_o_pe) REFERENCES ag_o_pe(id_ag_o_pe) ON DELETE SET NULL
);


CREATE TABLE documentacion_procedimiento (
    id_documentacion_procedimiento            SERIAL PRIMARY KEY,
    id_asunto_trabajo                         INT,
    id_proyecto                               INT,

    FOREIGN KEY (id_asunto_trabajo) REFERENCES asunto_de_trabajo_tipo_emprendimiento (id_asunto_trabajo) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_proyecto) REFERENCES proyecto (id_proyecto) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE actividad_momento (
    id_actividad                          SERIAL PRIMARY KEY,
    fecha_actividad_evento_momento_interaccion TIMESTAMP,
    nombre_actividad_evento_momento_interaccion VARCHAR(255),
    descripcion_actividad_evento_momento_interaccion TEXT,
    hora_inicio_actividad_evento_momento_interaccion TIME,
    hora_finalizacion_actividad_evento_momento_interaccion TIME,
    tematica_actividad_evento_momento_interaccion VARCHAR(255),
    modalidad_actividad_evento_momento_interaccion VARCHAR(100),
    tipo_actividad_evento_momento_interaccion VARCHAR(100),
    materiales_actividad_evento            TEXT,
    alimentacion_actividad_evento          BOOLEAN,
    duracion_actividad                     INTERVAL,
    facilitador_actividad                  VARCHAR(255),
    ag_o_pe                                VARCHAR(255),
    como_se_entro_convocatoria             VARCHAR(255),
    autorizacion_datos                     BOOLEAN,
    habeas_data                           BOOLEAN,
    fase_actividad                         VARCHAR(100),
    semestre_ejecucion_fase                VARCHAR(100),
    observaciones_actividad                TEXT,
    fecha_registro_actividad_producto      TIMESTAMP,
    id_persona_emprendedor                 INT,
    id_proyecto                            INT,
    id_asunto_trabajo                      INT,

    FOREIGN KEY (id_persona_emprendedor) REFERENCES persona (id_persona) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (id_proyecto) REFERENCES proyecto (id_proyecto) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_asunto_trabajo) REFERENCES asunto_de_trabajo_tipo_emprendimiento (id_asunto_trabajo) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE dimension_emprendimiento (
    id_dimension_emprendimiento           SERIAL PRIMARY KEY,
    nombre_dimension_emprendimiento       VARCHAR(255),
    descripcion_dimension_emprendimiento  TEXT,
    responsable_dimension_emprendimiento  VARCHAR(255)
);

CREATE TABLE subactividad_producto (
    id_subactividad                       SERIAL PRIMARY KEY,
    nombre_subactividad_producto          VARCHAR(255),
    tipo_subactividad_producto            VARCHAR(100),
    fecha_subactividad_producto           DATE,
    descripcion_subactividad_producto     TEXT,
    hora_inicio_subactividad              TIME,
    hora_finalizacion_subactividad        TIME,
    tematica_subactividad                 VARCHAR(255),
    modalidad_subactividad                VARCHAR(100),
    materiales_subactividad_evento        TEXT,
    alimentacion_subactividad_evento      BOOLEAN,
    duracion_subactividad                 INTERVAL,
    facilitador_subactividad              VARCHAR(255),
    observaciones_subactividad            TEXT,
    autorizacion_datos                    BOOLEAN,
    fecha_registro                        TIMESTAMP,
    id_actividad                          INT,
    id_direccion                          INT,
    id_dimension_emprendimiento           INT,

    FOREIGN KEY (id_actividad) REFERENCES actividad_momento (id_actividad) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_direccion) REFERENCES direccion (id_direccion) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (id_dimension_emprendimiento) REFERENCES dimension_emprendimiento (id_dimension_emprendimiento) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE relacion_actividad_persona (
    id_relacion_actividad_persona         SERIAL PRIMARY KEY,
    id_persona                            INT NOT NULL,
    id_subactividad                       INT NOT NULL,

    FOREIGN KEY (id_persona) REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_subactividad) REFERENCES subactividad_producto (id_subactividad) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE mapa_conocimiento_proceso (
    id_mapa_conocimiento                  SERIAL          PRIMARY KEY, -- id_mapa_conocimiento
    nombre_proceso                         VARCHAR(255),   -- Nombre proceso
    vista_proceso                          TEXT,           -- Vista proceso
    responsable_proceso                    VARCHAR(255),   -- Responsable
    prioridad_proceso                      VARCHAR(100),   -- Prioridad
    estado_documentacion_proceso           VARCHAR(100),   -- Estado de documentación
    cronograma_inicio_proceso              DATE,           -- Cronograma - Start
    cronograma_fin_proceso                 DATE,           -- Cronograma - End
    depende_de_proceso                     TEXT,           -- Depende de
    duracion_proceso                       INT,            -- Duración (en días)
    fecha_inicio_proceso                   DATE,           -- Fecha inicio
    fecha_finalizacion_proceso             DATE,           -- Fecha finalización
    esfuerzo_planificado_proceso           INT,            -- Esfuerzo planificado (en horas)
    esfuerzo_real_proceso                  INT,            -- Esfuerzo real (en horas)
    presupuesto_proceso                    NUMERIC(15,2),  -- Presupuesto
    tipo_proyecto_proceso                  VARCHAR(100),   -- Tipo proyecto
    cartera_programas_proceso              TEXT,           -- Cartera programas
    cartera_proyectos_proceso              TEXT,           -- Cartera proyectos
    texto_ag_o_pe                          TEXT,           -- Texto AG O PE
    programa_tipo_proyecto                 VARCHAR(255),   -- Programa_tipoproyecto
    ag_o_pe_unico                          TEXT,           -- AG O PE Unico
    ag_pe_tipo_proyecto                    TEXT,           -- AG_PE_tipoproyecto
    ag_o_pe_u                              TEXT,           -- AG O PE U
    link_nueva_cartera                     TEXT,           -- link to Nueva cartera
    link_mapas_conocimientos_bpmn          TEXT,           -- link to Mapas de Conocimientos - Diagramas de flujo _BPMN 2.0
    asuntos_trabajo_gestion_proceso        TEXT,           -- Asuntos de Trabajo del Asunto de Gestión ó Proceso Ejecutable_DI-AP-FO-007
    ag_o_pe_id                             INT,            -- AG o PE
    FOREIGN KEY (ag_o_pe_id) REFERENCES ag_o_pe(id_ag_o_pe) ON DELETE SET NULL
);

-- ==============================================================
-- Tabla de logs
CREATE TABLE log_cambios (
    id_log                  SERIAL PRIMARY KEY,
    nombre_tabla            VARCHAR(100) NOT NULL, 
    tipo_operacion          TIPO_OPERACION_LOG NOT NULL,  -- 'INSERT', 'UPDATE', 'DELETE' Hacer ENUM
    id_registro_afectado    INT NOT NULL,         
    datos_anteriores        JSONB,                -- Datos antes del cambio (solo para UPDATE/DELETE)
    datos_nuevos            JSONB,                -- Datos después del cambio (solo para INSERT/UPDATE)
    id_usuario_modificacion INT,         
    fecha_cambio            TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 

    FOREIGN KEY (id_usuario_modificacion) REFERENCES persona (id_persona) ON DELETE RESTRICT ON UPDATE CASCADE

);

-- ==============================================================
-- Índices compuestos para optimizar consultas
CREATE INDEX idx_relacion_persona_empresa ON relacion_empresa_persona (id_persona, id_empresa);
CREATE INDEX idx_correo_persona ON persona (correo_electronico);
CREATE INDEX idx_nombre_empresa ON empresa (nombre_empresa);
