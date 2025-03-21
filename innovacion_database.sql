-- Creación de la base de datos
CREATE DATABASE innovacion;

-- Conexión a la base de datos
\c innovacion;

-- ==============================================================
-- Enumerados para tipos específicos
CREATE TYPE SEXO_ENUM AS ENUM ('Masculino', 'Femenino', 'Intersexual');
CREATE TYPE GENERO_ENUM AS ENUM ('Hombre', 'Mujer', 'No binario', 'Género fluido', 'Agénero', 'Prefiero no decirlo', 'Otro');
CREATE TYPE TIPO_DOCUMENTO_PERSONA_ENUM AS ENUM ('Cédula de Ciudadanía (CC)', 'Tarjeta de Identidad (TI)', 'Cédula de Extranjería (CE)', , 'Pasaporte (P)', , 'Registro Civil (RC)', 'NIT (Número de Identificación Tributaria)', 'Documento Nacional de Identidad (DNI)', 'Permiso Especial de Permanencia (PEP)');
CREATE TYPE ESTRATO_SOCIOECONOMICO_ENUM AS ENUM ('Estrato 1 (Bajo-bajo)', 'Estrato 2 (Bajo)', 'Estrato 3 (Medio-bajo)', 'Estrato 4 (Medio)', 'Estrato 5 (Medio-alto)', 'Estrato 6 (Alto)')

CREATE TYPE CATEGORIA_EMPRESA_ENUM AS ENUM ('Microempresa', 'Pequeña empresa', 'Mediana empresa', 'Gran empresa');
CREATE TYPE ZONA_EMPRESA_ENUM AS ENUM ('Urbana', 'Rural', 'Periurbana');
CREATE TYPE SECTOR_EMPRESA_ENUM AS ENUM ('Tecnología', 'Comercio', 'Servicios', 'Industria', 'Agricultura');
CREATE TYPE TIPO_EMPRESA_ENUM AS ENUM ('Tecnología', 'Comercio', 'Servicios', 'Industria', 'Agricultura', 'Institución educativa');
CREATE TYPE ROL_ENUM AS ENUM ('Empleado', 'Gerente', 'Socio', 'Fundador', 'Inversionista');
CREATE TYPE MAGNITUD_EMPRESA_ENUM AS ENUM ('Grande', 'Mediana', 'Pequeña');

CREATE TYPE TIPO_VINCULO_UNIDAD_IE_ENUM AS ENUM ('Facultad', 'Instituto', 'Escuela', 'Centro de Investigación');
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

-- Tabla relacion_empresa_persona
CREATE TABLE relacion_empresa_persona (
    id_rel_empresa_persona   SERIAL PRIMARY KEY,
    id_persona               INT NOT NULL,
    id_empresa               INT NOT NULL,
    rol                      ROL_ENUM NOT NULL,
    id_cargo                 CARGO_ENUM,   

    FOREIGN KEY (id_cargo) REFERENCES cargo (id_cargo) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_persona) REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_empresa) REFERENCES empresa (id_empresa) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla cargos
CREATE TABLE cargo (
    id_cargo                SERIAL PRIMARY KEY,
    nombre_cargo            VARCHAR(100),
    responsabilidades       TEXT
);

-- ==============================================================
-- Tabla unidad_ie (Unidad de Institución Educativa)
CREATE TABLE unidad_ie (
    id_unidad_ie            SERIAL PRIMARY KEY,
    tipo_vinculo_ie         TIPO_VINCULO_UNIDAD_IE_ENUM NOT NULL,
    nombre_unidad           VARCHAR(100) NOT NULL,
    tipo_ubicacion          TIPO_UBICACION_UNIDAD_IE_ENUM NOT NULL,
    id_empresa              INT NOT NULL,

    FOREIGN KEY (id_empresa) REFERENCES empresa (id_empresa) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla subunidad_administrativa
CREATE TABLE subunidad_administrativa (
    id_subunidad_administrativa  SERIAL PRIMARY KEY,
    nombre_subunidad             VARCHAR(100) NOT NULL,
    id_unidad_ie                 INT NOT NULL,

    FOREIGN KEY (id_unidad_ie) REFERENCES unidad_ie (id_unidad_ie) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla programa_academico
CREATE TABLE programa_academico (
    id_programa_academico       SERIAL PRIMARY KEY,
    titulo_programa_academico   VARCHAR(100) NOT NULL,
    nivel_programa_academico    NIVEL_PROGRAMA_ACADEMICO_ENUM NOT NULL,
    area_programa_academico     AREA_PROGRAMA_ACADEMICO_ENUM NOT NULL,
    id_unidad_ie                INT NOT NULL,

    FOREIGN KEY (id_unidad_ie) REFERENCES unidad_ie (id_unidad_ie) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla grupo_investigacion
CREATE TABLE grupo_investigacion (
    id_grupo_investigacion       SERIAL PRIMARY KEY,
    nombre_grupo_investigacion   VARCHAR(100) NOT NULL,
    id_unidad_ie                 INT NOT NULL,

    FOREIGN KEY (id_unidad_ie) REFERENCES unidad_ie (id_unidad_ie) ON DELETE CASCADE ON UPDATE CASCADE
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
    nivel_profesion    NIVEL_PROFESION_ENUM NOT NULL, 
    area_profesion     VARCHAR(100),
    codigo_profesion   VARCHAR(50),
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
    id_programa                     SERIAL PRIMARY KEY,
    nombre_programa                 VARCHAR(255) NOT NULL,
    objetivo_general_programa       TEXT,
    id_responsable_articulacion     VARCHAR(255),
    id_lider_coordinador            VARCHAR(255),
    tipo_programa                   TIPO_PROGRAMA_ENUM,
    estado_programa                 ESTADO_PROGRAMA_ENUM DEFAULT 'Activo',
    unidad_academica_administrativa VARCHAR(255),
    equipo_principal                TEXT,
    contratos_persona_natural       TEXT,
    correo_electronico              VARCHAR(255),
    numero_telefono                 VARCHAR(20),
    prioridad_programa              PRIORIDAD_PROGRAMA_ENUM,
    etapa_programa                  ETAPA_PROGRAMA_ENUM,
    resumen_estado_proyecto         TEXT,
    id_mapa_proceso                 TEXT
);

-- Tabla proyecto
CREATE TABLE proyecto (
    id_proyecto                   SERIAL PRIMARY KEY,
    id_programa                   INT,
    id_lider_proyecto             INT,
    id_responsable_proyecto       INT,
    estado_proyecto               ESTADO_PROYECTO_ENUM,
    propuesta_proyecto            TEXT,
    prioridad_proyecto            PRIORIDAD_PROYECTO_ENUM,
    fecha_inicio_proyecto         DATE,
    fecha_finalizacion_proyecto   DATE,
    numero_contrato               VARCHAR(50),
    tipo_primario_proyecto        VARCHAR(100),
    figura_contractual            VARCHAR(100),
    alcance_proyecto              TEXT,
    presupuesto_proyecto          DECIMAL,
    moneda_proyecto               VARCHAR(10)
    url_propuesta_proyecto        TEXT,
    url_presupuesto               TEXT,
    url_contrato                  TEXT,
    url_acta_inicio               TEXT,
    url_polizas                   TEXT,
    url_acta_finalizacion         TEXT,

    FOREIGN KEY (id_programa) REFERENCES programa (id_programa) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_lider_proyecto) REFERENCES persona (id_persona) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (id_responsable_proyecto) REFERENCES persona (id_persona) ON DELETE SET NULL ON UPDATE CASCADE,
);

-- Tabla proceso de financiacion
CREATE TABLE proceso_financiacion (
    id_proceso_financiacion         SERIAL PRIMARY KEY,
    id_proyecto                     INT NOT NULL,
    tipo_aporte                     TIPO_APORTE_ENUM
    moneda                          VARCHAR(50) NOT NULL,
    excepcion_contribucion          BOOLEAN DEFAULT FALSE,
    fuente_financiacion_primaria    VARCHAR(255), 
    id_contratante                  INT, 
    id_empresa                      INT, 
    id_persona_encargada            INT, 
    porcentaje_financiacion         DECIMAL(5, 2),
    valor_financiacion              DECIMAL, 
    fecha_inicio_financiacion       DATE, 
    fecha_finalizacion_financiacion DATE, 
    estado_financiacion             VARCHAR(100), 

    FOREIGN KEY (id_proyecto) REFERENCES proyecto (id_proyecto) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_contratante) REFERENCES persona (id_persona) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (id_empresa) REFERENCES empresa (id_empresa) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (id_persona_encargada) REFERENCES persona (id_persona) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE seguimiento_proyecto (
    id_seguimiento_proyecto         SERIAL PRIMARY KEY,
    id_proyecto                     INT
    porcentaje_realizacion_proyecto DECIMAL(5, 2),
    etapa_proyecto                  ETAPA_PROYECTO_ENUM,
    fecha_reporte                   DATE   


    FOREIGN KEY (id_proyecto) REFERENCES proyecto (id_proyecto) ON DELETE CASCADE ON UPDATE CASCADE
               
);

CREATE TABLE mapa_conocimiento_proceso (
    id_mapa_conocimiento                  SERIAL PRIMARY KEY,
    estado_mapa
    url_mapa
    nombre_proceso                        VARCHAR(255),
    vista_proceso                         VARCHAR(255),
    responsable_proceso                   VARCHAR(255),
    prioridad_proceso                     VARCHAR(100),
    estado_documentacion                  VARCHAR(100),
    cronograma_start                      DATE,
    cronograma_end                        DATE,
    depende_de                            VARCHAR(255),
    duracion_proceso                      INTERVAL,
    fecha_inicio_proceso                  DATE,
    fecha_finalizacion_proceso            DATE,
    esfuerzo_planificado                  DECIMAL,
    esfuerzo_real                         DECIMAL,
    presupuesto_proceso                   DECIMAL,
    tipo_proyecto                         VARCHAR(100),
    cartera_programas                     TEXT,
    cartera_proyectos                     TEXT,
    texto_ag_pe                           VARCHAR(255),
    programa_tipoproyecto                 VARCHAR(255),
    ag_pe_unico                           VARCHAR(255),
    ag_pe_u                               VARCHAR(255),
    link_nueva_cartera                    TEXT,
    link_mapas_conocimientos_diagramas_flujo_bpmn_2_0 TEXT,
    asuntos_trabajo_proceso_ejecutable_di_ap TEXT,
    ag_o_pe                               VARCHAR(255)
);

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

CREATE TABLE direccion (
    id_direccion              SERIAL PRIMARY KEY,
    direccion_textual         VARCHAR(200) NOT NULL,
    codigo_postal             CHAR(10),
    id_ciudad                 INT NOT NULL,

    FOREIGN KEY (id_ciudad) REFERENCES ciudad (id_ciudad) ON DELETE RESTRICT ON UPDATE CASCADE
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
    id_usuario_modificacion VARCHAR(100),         
    fecha_cambio            TIMESTAMP DEFAULT CURRENT_TIMESTAMP 

    FOREIGN KEY (id_usuario_modificacion) REFERENCES persona (id_persona) ON DELETE RESTRICT ON UPDATE CASCADE

);

-- ==============================================================
-- Índices compuestos para optimizar consultas
CREATE INDEX idx_relacion_persona_empresa ON relacion_empresa_persona (id_persona, id_empresa);
CREATE INDEX idx_correo_persona ON persona (correo_electronico);
CREATE INDEX idx_nombre_empresa ON empresa (nombre_empresa);
