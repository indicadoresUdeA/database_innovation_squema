-- ==============================================================
-- MODELO DE BASE DE DATOS - SISTEMA DE GESTIÓN DE EMPRENDIMIENTO
-- Versión: Beta
-- Fecha: 2025
-- Descripción: Sistema integral para gestión de emprendimiento,
--              empresas, instituciones educativas y programas
-- ==============================================================

BEGIN;


CREATE TYPE SEXO_ENUM AS ENUM ('Masculino', 'Femenino', 'Intersexual');
CREATE TYPE GENERO_ENUM AS ENUM ('Hombre', 'Mujer', 'No binario', 'Género fluido', 'Agénero', 'Prefiero no decirlo', 'Otro');
CREATE TYPE TIPO_DOCUMENTO_PERSONA_ENUM AS ENUM ('Cédula de Ciudadanía (CC)', 'Tarjeta de Identidad (TI)', 'Cédula de Extranjería (CE)', 'Pasaporte (P)', 'Registro Civil (RC)', 'NIT (Número de Identificación Tributaria)', 'Documento Nacional de Identidad (DNI)', 'Permiso Especial de Permanencia (PEP)', 'Permiso por Protección Temporal (PPT)');
CREATE TYPE ESTRATO_SOCIOECONOMICO_ENUM AS ENUM ('Estrato 1 (Bajo-bajo)', 'Estrato 2 (Bajo)', 'Estrato 3 (Medio-bajo)', 'Estrato 4 (Medio)', 'Estrato 5 (Medio-alto)', 'Estrato 6 (Alto)');
CREATE TYPE ETNIA_EMPRENDEDOR_ENUM AS ENUM ('Blanco', 'Mestizo', 'Afrocolombiano', 'Indígena', 'Raizal', 'Palenquero', 'Rom o Gitano', 'Prefiero no decir', 'Ninguno de los anteriores');
CREATE TYPE ESTADO_CIVIL_EMPRENDEDOR_ENUM AS ENUM ('Soltero', 'Casado','Unión libre', 'Separado', 'Divorciado', 'Viudo', 'Otro');
CREATE TYPE CATEGORIA_EMPRESA_ENUM AS ENUM ('Microempresa', 'Pequeña empresa', 'Mediana empresa', 'Gran empresa');
CREATE TYPE ZONA_EMPRESA_ENUM AS ENUM ('Urbana', 'Rural','Periurbana');
CREATE TYPE TIPO_EMPRESA_ENUM AS ENUM ('Tecnología', 'Comercio', 'Servicios', 'Industria', 'Agricultura', 'Institución educativa');
CREATE TYPE MACROSECTOR_EMPRENDIMIENTO_ENUM AS ENUM ('Tecnología', 'Comercio', 'Servicios', 'Industria', 'Agricultura');
CREATE TYPE SUBSECTOR_EMPRENDIMIENTO_ENUM AS ENUM ('Agricultura', 'Ganadería', 'Alimentos y bebidas', 'Textiles, confecciones, cuero y calzado', 'Productos químicos y farmacéuticos', 'Plásticos y caucho', 'Minerales no metálicos', 'Metalmecánica', 'Automotriz', 'Electrónica y electrodomésticos','Software y desarrollo','Servicios financieros','Salud','Educación','Turismo','Logística y transporte','Construcción','Energía y recursos','Telecomunicaciones','Comercio al por menor','Comercio al por mayor');
CREATE TYPE ESTADO_DESARROLLO_EMPREN_ENUM AS ENUM ('En incubación','Consolidado', 'En pausa', 'Finalizado');
CREATE TYPE TIPO_EMPLEO_ENUM AS ENUM ('Temporal', 'Fijo', 'Mixto');
CREATE TYPE TIPO_UNIDAD_ACADEMICA_ENUM AS ENUM ('Facultad', 'Escuela', 'Instituto', 'Corporación');
CREATE TYPE TIPO_UBICACION_UNIDAD_IE_ENUM AS ENUM ('Campus principal', 'Sede', 'Sede regional', 'Sede única');
CREATE TYPE NIVEL_PROGRAMA_ACADEMICO_ENUM AS ENUM ('Técnica profesional', 'Tecnológico', 'Profesional','Especialización','Maestría', 'Doctorado');
CREATE TYPE AREA_PROGRAMA_ACADEMICO_ENUM AS ENUM ('Ingeniería', 'Ciencias Sociales', 'Ciencias Naturales', 'Artes', 'Humanidades','Ciencias de la Salud','Ciencias Económicas y Administrativas','Ciencias Agrarias','Educación');
CREATE TYPE ESTADO_PROGRAMA_ENUM AS ENUM ('Activo', 'Inactivo','En desarrollo', 'Finalizado', 'Suspendido');
CREATE TYPE ESTADO_PROYECTO_ENUM AS ENUM ('Pendiente','En ejecución','Finalizado', 'Cancelado','Suspendido');
CREATE TYPE PRIORIDAD_ENUM AS ENUM ('Alta','Media','Baja');
CREATE TYPE ETAPA_ENUM AS ENUM ('Planificación','Ejecución','Cierre', 'Post-cierre');
CREATE TYPE MODALIDAD_ACTIVIDAD_ENUM AS ENUM ('Virtual', 'Presencial', 'Híbrido');
CREATE TYPE TIPO_ACTIVIDAD_ENUM AS ENUM ('Evento','Actividad', 'Curso','Taller', 'Conferencia','Seminario');
CREATE TYPE TIPO_OPERACION_LOG AS ENUM ('INSERT','UPDATE','DELETE');
CREATE TYPE AMBITO_ROL_ENUM AS ENUM ('ACADEMICO', 'ADMINISTRATIVO', 'PROYECTO', 'PROGRAMA', 'EMPRESA', 'INVESTIGACION', 'ACTIVIDAD', 'EMPRENDIMIENTO', 'PROCESO','GENERAL');
CREATE TYPE TIPO_ENTIDAD_ROL_ENUM AS ENUM ('EMPRESA','SEDE_CAMPUS','UNIDAD_ACADEMICA','UNIDAD_ADMINISTRATIVA','SUBUNIDAD_ADMINISTRATIVA','PROGRAMA_ACADEMICO','GRUPO_INVESTIGACION','PROGRAMA','PROYECTO','AG_O_PE','ASUNTO_TRABAJO','MAPA_CONOCIMIENTO','ACTIVIDAD','SUBACTIVIDAD','ETAPA_ASUNTO_TRABAJO','EMPRENDIMIENTO','DIMENSION_EMPRENDIMIENTO', 'PROFESION');

-- ==============================================================
-- JERARQUÍA GEOGRÁFICA
-- Estructura: País > Departamento > Región > Ciudad > Comuna > Barrio > Dirección
-- ==============================================================

CREATE TABLE pais (
    id_pais                   SERIAL PRIMARY KEY,                    -- ID único del país
    nombre_pais               VARCHAR(100) NOT NULL UNIQUE,          -- Nombre oficial del país
    codigo_iso2               CHAR(2) UNIQUE,                        -- Código ISO 3166-1 alpha-2 (ej: CO)
    codigo_iso3               CHAR(3) UNIQUE,                        -- Código ISO 3166-1 alpha-3 (ej: COL)
    codigo_numerico           VARCHAR(3),                            -- Código ISO numérico (ej: 170)
    url_polygon_pais          TEXT                                  -- URL a archivo GeoJSON con polígono del país
);

CREATE TABLE departamento (
    id_departamento           SERIAL PRIMARY KEY,                    -- ID único del departamento/estado
    nombre_departamento       VARCHAR(100) NOT NULL,                 -- Nombre del departamento
    codigo_departamento       VARCHAR(10),                           -- Código oficial del departamento
    url_polygon_departamento  TEXT,                                  -- URL a archivo GeoJSON con polígono
    id_pais                   INTEGER NOT NULL,                          -- FK al país al que pertenece
    
    FOREIGN KEY (id_pais) REFERENCES pais (id_pais) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE(nombre_departamento, id_pais)  -- No puede haber departamentos duplicados en un país
);

CREATE TABLE region (
    id_region                 SERIAL PRIMARY KEY,                    -- ID único de la región
    nombre_region             VARCHAR(100) NOT NULL,                 -- Nombre de la región/provincia
    codigo_region             VARCHAR(10),                           -- Código oficial de la región
    url_polygon_region        TEXT,                                  -- URL a archivo GeoJSON
    id_departamento           INTEGER NOT NULL,                          -- FK al departamento
    
    FOREIGN KEY (id_departamento) REFERENCES departamento (id_departamento) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE(nombre_region, id_departamento)  -- No puede haber regiones duplicadas en un departamento
);

CREATE TABLE ciudad (
    id_ciudad                 SERIAL PRIMARY KEY,                    -- ID único de la ciudad
    nombre_ciudad             VARCHAR(100) NOT NULL,                 -- Nombre de la ciudad/municipio
    codigo_ciudad             VARCHAR(10),                           -- Código DANE o similar
    url_polygon_ciudad        TEXT,                                  -- URL a archivo GeoJSON
    id_region                 INTEGER NOT NULL,                          -- FK a la región
    
    FOREIGN KEY (id_region) REFERENCES region (id_region) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE(nombre_ciudad, id_region)  -- No puede haber ciudades duplicadas en una región
);

CREATE TABLE comuna (
    id_comuna                 SERIAL PRIMARY KEY,                    -- ID único de la comuna
    nombre_comuna             VARCHAR(100) NOT NULL,                 -- Nombre/número de la comuna
    codigo_comuna             VARCHAR(10),                           -- Código oficial de la comuna
    url_polygon_comuna        TEXT,                                  -- URL a archivo GeoJSON
    id_ciudad                 INTEGER NOT NULL,                          -- FK a la ciudad
    
    FOREIGN KEY (id_ciudad) REFERENCES ciudad (id_ciudad) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE(nombre_comuna, id_ciudad)  -- No puede haber comunas duplicadas en una ciudad
);

CREATE TABLE barrio (
    id_barrio                 SERIAL PRIMARY KEY,                    -- ID único del barrio
    nombre_barrio             VARCHAR(100) NOT NULL,                 -- Nombre del barrio
    codigo_barrio             VARCHAR(10),                           -- Código catastral o similar
    url_polygon_barrio        TEXT,                                  -- URL a archivo GeoJSON
    id_comuna                 INTEGER NOT NULL,                          -- FK a la comuna
    
    FOREIGN KEY (id_comuna) REFERENCES comuna (id_comuna) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE(nombre_barrio, id_comuna)  -- No puede haber barrios duplicados en una comuna
);

CREATE TABLE direccion (
    id_direccion              SERIAL PRIMARY KEY,                    -- ID único de la dirección
    direccion_textual         VARCHAR(200) NOT NULL,                 -- Dirección completa (Calle 123 #45-67)
    codigo_postal             VARCHAR(10),                           -- Código postal
    latitud                   DECIMAL(10, 8),                        -- Coordenada GPS latitud
    longitud                  DECIMAL(11, 8),                        -- Coordenada GPS longitud
    id_barrio                 INTEGER NOT NULL,                          -- FK al barrio

    FOREIGN KEY (id_barrio) REFERENCES barrio (id_barrio) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ==============================================================
-- PERSONAS Y EMPRESAS
-- Entidades principales del sistema
-- ==============================================================

CREATE TABLE persona (
    id_persona                   SERIAL PRIMARY KEY,                    -- ID único de la persona
    primer_nombre_personas        VARCHAR(100) NOT NULL,                 -- Nombres completos
    segundo_nombre_persona       VARCHAR(100),                           -- Nombres completos
    primer_apellido_persona      VARCHAR(100) NOT NULL,                 -- Nombres completos
    segundo_apellido_persona     VARCHAR(100) NOT NULL,                 -- Nombres completos
    tipo_documento_persona       TIPO_DOCUMENTO_PERSONA_ENUM NOT NULL, -- Tipo de documento de identidad
    numero_documento_persona     VARCHAR(50) UNIQUE NOT NULL,          -- Número del documento (único)
    sexo_biologico               SEXO_ENUM NOT NULL,                   -- Sexo biológico al nacer
    genero                       GENERO_ENUM NOT NULL,                 -- Identidad de género
    telefono_celular             VARCHAR(20),                           -- Teléfono móvil principal
    telefono_fijo                VARCHAR(20),                           -- Teléfono fijo/alternativo
    correo_electronico_personal  VARCHAR(100) UNIQUE NOT NULL,         -- Email principal (único)
    correo_alternativo           VARCHAR(100),                          -- Email secundario
    estrato_socioeconomico       ESTRATO_SOCIOECONOMICO_ENUM,         -- Estrato socioeconómico (Colombia)
    fecha_nacimiento_persona     DATE NOT NULL,                         -- Fecha de nacimiento
    foto_persona_url             TEXT,                                  -- URL a foto de perfil
    id_direccion                 INT,                                   -- FK a dirección de residencia
    activo                       BOOLEAN DEFAULT TRUE,                  -- Soft delete
    fecha_creacion               TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Fecha de registro
    fecha_actualizacion          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Última actualización
    
    FOREIGN KEY (id_direccion) REFERENCES direccion (id_direccion) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT check_fecha_nacimiento CHECK (fecha_nacimiento_persona <= CURRENT_DATE)
);

CREATE TABLE empresa (
    id_empresa                        SERIAL PRIMARY KEY,                    -- ID único de la empresa
    nombre_empresa                    VARCHAR(100) NOT NULL UNIQUE,         -- Razón social (única)
    nit_empresa                       VARCHAR(20) UNIQUE,                   -- NIT o equivalente (único)
    categoria_empresa                 CATEGORIA_EMPRESA_ENUM NOT NULL,      -- Tamaño según empleados
    zona_empresa                      ZONA_EMPRESA_ENUM NOT NULL,           -- Ubicación urbana/rural
    tipo_empresa                      TIPO_EMPRESA_ENUM NOT NULL,           -- Sector económico
    macrosector_emprendimiento        MACROSECTOR_EMPRENDIMIENTO_ENUM NOT NULL, -- Sector principal
    subsector_emprendimiento          SUBSECTOR_EMPRENDIMIENTO_ENUM NOT NULL,   -- Subsector específico
    naturaleza_juridica               VARCHAR(100),                          -- SAS, LTDA, SA, etc.
    telefono                          VARCHAR(20),                           -- Teléfono principal
    correo_empresa                    VARCHAR(100) UNIQUE NOT NULL,         -- Email corporativo (único)
    sitio_web_url                     TEXT,                                 -- URL del sitio web
    logo_empresa_url                  TEXT,                                  -- URL al logo
    descripcion_empresa               TEXT,                                  -- Descripción de la empresa
    pertenece_parque                  BOOLEAN DEFAULT FALSE,                 -- Pertenece a parque tecnológico
    fecha_fundacion                   DATE,                                  -- Fecha de fundación
    numero_empleados                  INT,                                   -- Cantidad de empleados
    activo                           BOOLEAN DEFAULT TRUE,                  -- Soft delete
    fecha_creacion                   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Fecha de registro
    fecha_actualizacion              TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Última actualización
    
    CONSTRAINT check_correo_empresa CHECK (correo_empresa ~* '^[^@\s]+@[^@\s]+\.[A-Za-z]{2,}$'),  -- Validación email
    CONSTRAINT check_fecha_fundacion CHECK (fecha_fundacion <= CURRENT_DATE),  -- No puede fundarse en el futuro
    CONSTRAINT check_numero_empleados CHECK (numero_empleados >= 0)  -- No puede tener empleados negativos
);

CREATE TABLE tipo_rol (
    id_tipo_rol              SERIAL PRIMARY KEY,
    nombre_rol               VARCHAR(100) NOT NULL,
    descripcion_rol          TEXT NOT NULL,
    ambito_rol               AMBITO_ROL_ENUM NOT NULL,
    activo                   BOOLEAN DEFAULT TRUE NOT NULL 
);

-- Tabla para sede o campus (con dirección)
CREATE TABLE sede_campus (
    id_sede_campus         SERIAL PRIMARY KEY,                    -- ID único de la sede
    nombre_sede_campus     VARCHAR(100) NOT NULL,                 -- Nombre de la sede
    tipo_ubicacion         TIPO_UBICACION_UNIDAD_IE_ENUM NOT NULL, -- Tipo de sede
    es_sede_principal      BOOLEAN DEFAULT FALSE,                 -- Indica si es la sede principal
    telefono_sede          VARCHAR(20),                           -- Teléfono de la sede
    correo_sede            VARCHAR(100),                          -- Email de la sede
    id_empresa             INTEGER NOT NULL,                          -- FK a la empresa propietaria
    id_direccion           INTEGER NOT NULL,                          -- FK a la dirección física
    activo                 BOOLEAN DEFAULT TRUE,                  -- Soft delete
    
    FOREIGN KEY (id_empresa) REFERENCES empresa (id_empresa) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_direccion) REFERENCES direccion (id_direccion) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE(nombre_sede_campus, id_empresa)  -- No puede haber sedes con el mismo nombre en una empresa
);


-- ==============================================================
-- ESTRUCTURA ACADÉMICA
-- Para instituciones educativas
-- ==============================================================

-- Unidad administrativa (depende de sede_campus)
CREATE TABLE unidad_administrativa (
    id_unidad_administrativa         SERIAL PRIMARY KEY,                    -- ID único
    nombre_unidad_administrativa     VARCHAR(100) NOT NULL,                 -- Nombre de la unidad
    descripcion                      TEXT,                                  -- Descripción de funciones
    id_sede_campus                   INTEGER NOT NULL,                          -- FK a la sede donde está ubicada
    activo                          BOOLEAN DEFAULT TRUE,                  -- Soft delete
    
    FOREIGN KEY (id_sede_campus) REFERENCES sede_campus (id_sede_campus) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE(nombre_unidad_administrativa, id_sede_campus)  -- No duplicados en la misma sede
);

-- Subunidad administrativa
CREATE TABLE subunidad_administrativa (
    id_subunidad_administrativa      SERIAL PRIMARY KEY,                    -- ID único
    nombre_subunidad                 VARCHAR(100) NOT NULL,                 -- Nombre de la subunidad
    descripcion                      TEXT,                                  -- Descripción
    id_unidad_administrativa         INTEGER NOT NULL,                          -- FK a unidad padre
    activo                          BOOLEAN DEFAULT TRUE,                  -- Soft delete
    
    FOREIGN KEY (id_unidad_administrativa) REFERENCES unidad_administrativa (id_unidad_administrativa) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE(nombre_subunidad, id_unidad_administrativa)  -- No duplicados en la misma unidad
);

-- Unidad académica (depende de sede_campus)
CREATE TABLE unidad_academica (
    id_unidad_academica         SERIAL PRIMARY KEY,                    -- ID único
    tipo_unidad_academica       TIPO_UNIDAD_ACADEMICA_ENUM NOT NULL,   -- Tipo (Facultad, Escuela, etc.)
    nombre_unidad_academica     VARCHAR(100) NOT NULL,                 -- Nombre de la unidad
    descripcion                 TEXT,                                  -- Descripción
    id_sede_campus              INTEGER NOT NULL,                          -- FK a la sede
    activo                      BOOLEAN DEFAULT TRUE,                  -- Soft delete
    
    FOREIGN KEY (id_sede_campus) REFERENCES sede_campus (id_sede_campus) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE(nombre_unidad_academica, id_sede_campus)  -- No duplicados en la misma sede
);

-- Programa académico
CREATE TABLE programa_academico (
    id_programa_academico       SERIAL PRIMARY KEY,                    -- ID único
    titulo_programa_academico   VARCHAR(100) NOT NULL,                 -- Título que otorga
    codigo_snies                VARCHAR(20),                           -- Código SNIES (Colombia)
    nivel_programa_academico    NIVEL_PROGRAMA_ACADEMICO_ENUM NOT NULL, -- Nivel educativo
    area_programa_academico     AREA_PROGRAMA_ACADEMICO_ENUM NOT NULL,  -- Área del conocimiento
    id_unidad_academica         INTEGER NOT NULL,                          -- FK a unidad académica
    activo                      BOOLEAN DEFAULT TRUE,                  -- Soft delete
    
    FOREIGN KEY (id_unidad_academica) REFERENCES unidad_academica (id_unidad_academica) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Grupo de investigación
CREATE TABLE grupo_investigacion (
    id_grupo_investigacion       SERIAL PRIMARY KEY,                    -- ID único
    nombre_grupo_investigacion   VARCHAR(100) NOT NULL,                 -- Nombre del grupo
    codigo_colciencias           VARCHAR(50),                           -- Código Minciencias/Colciencias
    categoria_colciencias        VARCHAR(10),                           -- Categoría (A1, A, B, C)
    lineas_investigacion         TEXT,                                  -- Líneas de investigación
    id_unidad_academica          INTEGER NOT NULL,                          -- FK a unidad académica
    activo                       BOOLEAN DEFAULT TRUE,                  -- Soft delete
    
    FOREIGN KEY (id_unidad_academica) REFERENCES unidad_academica (id_unidad_academica) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE(nombre_grupo_investigacion, id_unidad_academica)  -- No duplicados en la misma unidad
);


-- ==============================================================
-- PROFESIONES Y REDES SOCIALES
-- ==============================================================

CREATE TABLE profesion (
    id_profesion       SERIAL PRIMARY KEY,                    -- ID único
    titulo_profesion   VARCHAR(100) NOT NULL UNIQUE,          -- Título profesional
    area_profesion     VARCHAR(100),                          -- Área del conocimiento
    codigo_profesion   VARCHAR(50),                           -- Código clasificación ocupacional
    activo             BOOLEAN DEFAULT TRUE                  -- Soft delete
);


CREATE TABLE red_social_persona_empresa (
    id_red_social_persona_empresa  SERIAL PRIMARY KEY,                    -- ID único
    nombre_plataforma              VARCHAR(50) NOT NULL,                  -- LinkedIn, Twitter, etc.
    url_perfil                     TEXT NOT NULL,                         -- URL al perfil
    tipo_cuenta                    VARCHAR(50),                           -- Personal, Corporativa, etc.
    id_persona                     INT,                                   -- FK a persona (NULL si es empresa)
    id_empresa                     INT,                                   -- FK a empresa (NULL si es persona)
    activo                         BOOLEAN DEFAULT TRUE,                  -- Soft delete
    
    FOREIGN KEY (id_persona) REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_empresa) REFERENCES empresa (id_empresa) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT check_red_social_entidad CHECK ((id_persona IS NOT NULL AND id_empresa IS NULL) OR (id_persona IS NULL AND id_empresa IS NOT NULL))  -- Debe estar asociado a persona O empresa, no ambos ni ninguno
);

-- ==============================================================
-- EMPRENDIMIENTO Y EMPRENDEDOR
-- ==============================================================

CREATE TABLE emprendimiento (
    id_emprendimiento                  SERIAL PRIMARY KEY,                    -- ID único
    id_empresa                         INTEGER NOT NULL,                          -- FK a empresa (1:1)
    surgimiento_emprendimiento         VARCHAR(255),                          -- Cómo surgió la idea
    idea_negocio                       TEXT,                                  -- Descripción de la idea
    estado_desarrollo_emprendimiento   ESTADO_DESARROLLO_EMPREN_ENUM NOT NULL, -- Estado actual
    cantidad_empleados                 INTEGER DEFAULT 0,                         -- Número de empleados
    esta_formalizada                   BOOLEAN DEFAULT FALSE,                 -- Tiene registro mercantil
    importacion                        BOOLEAN DEFAULT FALSE,                 -- Importa productos
    exportacion                        BOOLEAN DEFAULT FALSE,                 -- Exporta productos
    esta_asociada_red                  BOOLEAN DEFAULT FALSE,                 -- Pertenece a red de emprendimiento
    esta_asociada_upa                  BOOLEAN DEFAULT FALSE,                 -- Asociada a UPA (Unidad Productiva Asociativa)
    pertenece_cluster                  BOOLEAN DEFAULT FALSE,                 -- Pertenece a clúster empresarial
    genera_ingresos                    BOOLEAN DEFAULT FALSE,                 -- Ya genera ingresos
    genera_empleo                      BOOLEAN DEFAULT FALSE,                 -- Genera empleo formal
    tipo_empleo                        TIPO_EMPLEO_ENUM,                      -- Tipo de empleos que genera
    tiene_camara_comercio              BOOLEAN DEFAULT FALSE,                 -- Registrado en Cámara de Comercio
    ventas_promedio_anual              NUMERIC(15,2),                         -- Ventas anuales en pesos
    cantidad_clientes_promedio_mes     INT,                                   -- Clientes mensuales promedio
    realiza_comercio_internacional     BOOLEAN DEFAULT FALSE,                 -- Comercio internacional
    activo                             BOOLEAN DEFAULT TRUE,                  -- Soft delete
    fecha_creacion                     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Fecha de registro
    fecha_actualizacion                TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Última actualización
    
    FOREIGN KEY (id_empresa) REFERENCES empresa (id_empresa) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT check_empleados CHECK (cantidad_empleados >= 0),
    CONSTRAINT check_ventas CHECK (ventas_promedio_anual IS NULL OR ventas_promedio_anual >= 0),
    CONSTRAINT check_clientes CHECK (cantidad_clientes_promedio_mes IS NULL OR cantidad_clientes_promedio_mes >= 0)
);

CREATE TABLE emprendedor (
    id_emprendedor                    SERIAL PRIMARY KEY,                    -- ID único
    id_persona                        INTEGER NOT NULL,                                  -- enlace con persona
    etnia_emprendedor                 ETNIA_EMPRENDEDOR_ENUM NOT NULL,      -- Autoidentificación étnica
    discapacidad_emprendedor          BOOLEAN DEFAULT FALSE,                 -- Tiene alguna discapacidad
    victima_emprendedor               BOOLEAN DEFAULT FALSE,                 -- Víctima del conflicto armado
    poblacion_campesina_emprendedor   BOOLEAN DEFAULT FALSE,                 -- Población campesina
    estado_civil_emprendedor          ESTADO_CIVIL_EMPRENDEDOR_ENUM NOT NULL, -- Estado civil
    cabeza_hogar_emprendedor          BOOLEAN DEFAULT FALSE,                 -- Es cabeza de hogar
    numero_personas_a_cargo           INTEGER DEFAULT 0,                         -- Número de personas a cargo
    nivel_educativo_maximo            NIVEL_PROGRAMA_ACADEMICO_ENUM,        -- Máximo nivel educativo alcanzado
    activo                            BOOLEAN DEFAULT TRUE,                  -- Soft delete
    fecha_creacion                    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Fecha de registro
    fecha_actualizacion               TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Última actualización

FOREIGN KEY (id_persona) REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE    
);

-- ==============================================================
-- PROGRAMAS Y PROYECTOS
-- ==============================================================

CREATE TABLE programa (
    id_programa                         SERIAL PRIMARY KEY,                    -- ID único
    nombre_programa                     VARCHAR(255) NOT NULL,                 -- Nombre completo del programa
    nombre_corto_programa               VARCHAR(100),                          -- Nombre abreviado
    objetivo_programa                   TEXT,                                  -- Objetivo general
    tipo_programa                       VARCHAR(100),                          -- Tipo de programa
    estado_programa                     ESTADO_PROGRAMA_ENUM NOT NULL DEFAULT 'En desarrollo', -- Estado actual
    prioridad_programa                  PRIORIDAD_ENUM DEFAULT 'Media',       -- Nivel de prioridad
    etapa_programa                      ETAPA_ENUM DEFAULT 'Planificación',   -- Etapa actual
    valor_programa                      NUMERIC(15,2),                         -- Presupuesto total
    cronograma_inicio_programa          DATE,                                  -- Fecha de inicio planeada
    cronograma_fin_programa             DATE,                                  -- Fecha de fin planeada
    correo_programa                     VARCHAR(255),                          -- Email de contacto
    telefono_programa                   VARCHAR(20),                           -- Teléfono de contacto
    roles_funciones_programa            TEXT,                                  -- Roles y responsabilidades
    resumen_estado_programa             TEXT,                                  -- Resumen ejecutivo del estado
    activo                             BOOLEAN DEFAULT TRUE,                  -- Soft delete
    fecha_creacion                     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Fecha de registro
    fecha_actualizacion                TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Última actualización
    
    CONSTRAINT check_valor_programa CHECK (valor_programa IS NULL OR valor_programa >= 0),
    CONSTRAINT check_fechas_programa CHECK (cronograma_fin_programa IS NULL OR cronograma_fin_programa >= cronograma_inicio_programa),
    CONSTRAINT check_correo_programa CHECK (correo_programa IS NULL OR correo_programa ~* '^[^@\s]+@[^@\s]+\.[A-Za-z]{2,}$')
);

CREATE TABLE proyecto (
    id_proyecto                        SERIAL PRIMARY KEY,                    -- ID único
    id_programa                        INT,                                   -- FK a programa (puede ser NULL)
    nombre_proyecto                    VARCHAR(255) NOT NULL,                 -- Nombre del proyecto
    estado_proyecto                    ESTADO_PROYECTO_ENUM NOT NULL DEFAULT 'Pendiente', -- Estado actual
    prioridad_proyecto                 PRIORIDAD_ENUM DEFAULT 'Media',       -- Nivel de prioridad
    etapa_proyecto                     ETAPA_ENUM DEFAULT 'Planificación',   -- Etapa actual
    fecha_inicio_proyecto              DATE,                                  -- Fecha de inicio real
    fecha_finalizacion_proyecto        DATE,                                  -- Fecha de finalización real
    numero_contrato_proyecto           VARCHAR(50),                           -- Número de contrato
    objeto_proyecto                    TEXT,                                  -- Objeto/descripción del proyecto
    tipo_ingreso_proyecto              VARCHAR(100),                          -- Tipo de ingreso generado
    figura_contractual_proyecto        VARCHAR(100),                          -- Tipo de contrato
    fuente_recurso_proyecto            VARCHAR(255),                          -- Origen de los recursos
    alcance_proyecto                   TEXT,                                  -- Alcance detallado
    valor_proyecto                     NUMERIC(15,2),                         -- Valor total del proyecto
    moneda_proyecto                    VARCHAR(10) DEFAULT 'COP',            -- Moneda (COP, USD, EUR, etc.)
    activo                            BOOLEAN DEFAULT TRUE,                  -- Soft delete
    fecha_creacion                    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Fecha de registro
    fecha_actualizacion               TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Última actualización
    
    FOREIGN KEY (id_programa) REFERENCES programa(id_programa) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT check_valor_proyecto CHECK (valor_proyecto IS NULL OR valor_proyecto >= 0),
    CONSTRAINT check_fechas_proyecto CHECK (fecha_finalizacion_proyecto IS NULL OR fecha_finalizacion_proyecto >= fecha_inicio_proyecto)
);

-- ==============================================================
-- ASUNTOS DE GESTIÓN Y PROCESOS EJECUTABLES
-- ==============================================================

CREATE TABLE ag_o_pe (
    id_ag_o_pe                           SERIAL PRIMARY KEY,                    -- ID único
    nombre_ag_o_pe                       VARCHAR(255) NOT NULL,                 -- Nombre del asunto/proceso
    tipo_ag_pe                           VARCHAR(100),                          -- Tipo (Asunto de Gestión o Proceso Ejecutable)
    sigla_corta_ag_pe                    VARCHAR(50),                           -- Sigla corta
    sigla_larga_ag_pe                    VARCHAR(100),                          -- Sigla larga
    objetivo_ag_pe                       TEXT,                                  -- Objetivo del asunto/proceso
    procesos_ag_pe                       TEXT,                                  -- Procesos relacionados
    macroproceso_ag_pe                   TEXT,                                  -- Macroproceso al que pertenece
    activo                              BOOLEAN DEFAULT TRUE                  -- Soft delete
);

CREATE TABLE asunto_de_trabajo_tipo_emprendimiento (
    id_asunto_de_trabajo_tipo_emprendimiento                    SERIAL PRIMARY KEY,                    -- ID único
    id_ag_o_pe                                                  INT,                                   -- FK a ag_o_pe
    nombre_asunto_trabajo                                       VARCHAR(255) NOT NULL,                 -- Nombre del asunto
    descripcion_asunto_trabajo                                  TEXT,                                  -- Descripción detallada
    talento_humano_asunto_trabajo                               TEXT,                                  -- Equipo de trabajo
    agrupacion_asunto_trabajo                                   TEXT,                                  -- Agrupación/categoría
    activo                                                      BOOLEAN DEFAULT TRUE,                  -- Soft delete
    
    FOREIGN KEY (id_ag_o_pe) REFERENCES ag_o_pe(id_ag_o_pe) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE mapa_conocimiento_proceso (
    id_mapa_conocimiento_proceso                                        SERIAL PRIMARY KEY,                    -- ID único
    id_asunto_de_trabajo_tipo_emprendimiento                    INT,                                   -- FK a asunto de trabajo
    nombre_proceso                                              VARCHAR(255) NOT NULL,                 -- Nombre del proceso
    prioridad_proceso                                           PRIORIDAD_ENUM DEFAULT 'Media',       -- Prioridad
    estado_documentacion_proceso                                VARCHAR(100),                          -- Estado de la documentación
    cronograma_inicio_proceso                                   DATE,                                  -- Fecha inicio planeada
    cronograma_fin_proceso                                      DATE,                                  -- Fecha fin planeada
    duracion_dias                                               INT,                                   -- Duración en días
    esfuerzo_planificado_horas                                  INT,                                   -- Horas estimadas
    esfuerzo_real_horas                                         INT,                                   -- Horas reales ejecutadas
    presupuesto_proceso                                         NUMERIC(15,2),                         -- Presupuesto asignado
    tipo_proyecto_proceso                                       VARCHAR(100),                          -- Tipo de proyecto
    activo                                                      BOOLEAN DEFAULT TRUE,                  -- Soft delete
    
    FOREIGN KEY (id_asunto_de_trabajo_tipo_emprendimiento) REFERENCES asunto_de_trabajo_tipo_emprendimiento (id_asunto_de_trabajo_tipo_emprendimiento) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT check_duracion_proceso CHECK (duracion_dias IS NULL OR duracion_dias > 0),
    CONSTRAINT check_esfuerzo CHECK (esfuerzo_planificado_horas IS NULL OR esfuerzo_planificado_horas > 0),
    CONSTRAINT check_presupuesto_proceso CHECK (presupuesto_proceso IS NULL OR presupuesto_proceso >= 0),
    CONSTRAINT check_fechas_proceso CHECK (cronograma_fin_proceso IS NULL OR cronograma_fin_proceso >= cronograma_inicio_proceso)
);

-- ==============================================================
-- ACTIVIDADES Y EVENTOS
-- ==============================================================

CREATE TABLE etapa_asunto_trabajo_proyecto_actividad (
    id_etapa_asunto_trabajo_proyecto_actividad               SERIAL PRIMARY KEY,  -- ID único
    nombre_etapa_asunto_trabajo_proyecto_actividad           VARCHAR(255) NOT NULL, -- Nombre de la etapa
    descripcion_etapa_asunto_trabajo_proyecto_actividad      TEXT,                -- Descripción
    orden_etapa                                              INT,                  -- Orden de ejecución
    id_asunto_de_trabajo_tipo_emprendimiento                    INTEGER NOT NULL,                  -- FK a asunto de trabajo
    id_proyecto                                              INTEGER NOT NULL,                  -- FK a proyecto

    FOREIGN KEY (id_asunto_de_trabajo_tipo_emprendimiento) REFERENCES asunto_de_trabajo_tipo_emprendimiento (id_asunto_de_trabajo_tipo_emprendimiento) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_proyecto) REFERENCES proyecto (id_proyecto) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE dimension_emprendimiento (
    id_dimension_emprendimiento           SERIAL PRIMARY KEY,                    -- ID único
    nombre_dimension_emprendimiento       VARCHAR(255) NOT NULL UNIQUE,         -- Nombre de la dimensión
    descripcion_dimension_emprendimiento  TEXT,                                  -- Descripción
    activo                                BOOLEAN DEFAULT TRUE                  -- Soft delete
);

CREATE TABLE actividad_momento (
    id_actividad_momento                        SERIAL PRIMARY KEY,                    -- ID único
    id_etapa_asunto_trabajo_proyecto_actividad  INT,                                    -- FK a etapa
    fecha_actividad                             DATE NOT NULL,                         -- Fecha de la actividad
    nombre_actividad                            VARCHAR(255) NOT NULL,                 -- Nombre de la actividad
    descripcion_actividad                       TEXT,                                  -- Descripción
    hora_inicio_actividad                       TIME,                                  -- Hora de inicio
    hora_finalizacion_actividad                 TIME,                                  -- Hora de fin
    tematica_actividad                          VARCHAR(255),                          -- Temática principal
    modalidad_actividad                         MODALIDAD_ACTIVIDAD_ENUM DEFAULT 'Presencial', -- Modalidad
    tipo_actividad                              TIPO_ACTIVIDAD_ENUM DEFAULT 'Actividad', -- Tipo
    materiales_actividad                        TEXT,                                  -- Materiales necesarios
    alimentacion_actividad                      BOOLEAN DEFAULT FALSE,                 -- Incluye alimentación
    fase_actividad                              VARCHAR(100),                          -- Fase del proceso
    semestre_ejecucion_fase                     VARCHAR(100),                          -- Semestre de ejecución
    observaciones_actividad                     TEXT,                                  -- Observaciones
    
    FOREIGN KEY (id_etapa_asunto_trabajo_proyecto_actividad) REFERENCES etapa_asunto_trabajo_proyecto_actividad (id_etapa_asunto_trabajo_proyecto_actividad) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT check_horas_actividad CHECK (hora_finalizacion_actividad IS NULL OR hora_finalizacion_actividad >= hora_inicio_actividad)
);

CREATE TABLE subactividad_producto (
    id_subactividad_producto              SERIAL PRIMARY KEY,                    -- ID único
    id_actividad_momento                  INTEGER NOT NULL,                          -- FK a actividad principal
    id_dimension_emprendimiento           INT,                                   -- FK a dimensión
    nombre_subactividad_producto          VARCHAR(255) NOT NULL,                 -- Nombre
    tipo_subactividad_producto            VARCHAR(100),                          -- Tipo
    fecha_subactividad_producto           DATE NOT NULL,                         -- Fecha
    descripcion_subactividad_producto     TEXT,                                  -- Descripción
    hora_inicio_subactividad              TIME,                                  -- Hora inicio
    hora_finalizacion_subactividad        TIME,                                  -- Hora fin
    tematica_subactividad                 VARCHAR(255),                          -- Temática
    modalidad_subactividad                MODALIDAD_ACTIVIDAD_ENUM DEFAULT 'Presencial', -- Modalidad
    materiales_subactividad               TEXT,                                  -- Materiales
    alimentacion_subactividad             BOOLEAN DEFAULT FALSE,                 -- Incluye alimentación
    facilitador_subactividad              VARCHAR(255),                          -- Facilitador
    observaciones_subactividad            TEXT,                                  -- Observaciones
    
    FOREIGN KEY (id_actividad_momento) REFERENCES actividad_momento (id_actividad_momento) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_dimension_emprendimiento) REFERENCES dimension_emprendimiento (id_dimension_emprendimiento) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT check_horas_subactividad CHECK (hora_finalizacion_subactividad IS NULL OR hora_finalizacion_subactividad >= hora_inicio_subactividad)
);

CREATE TABLE relacion_actividad_persona (
    id_relacion_actividad_persona         SERIAL PRIMARY KEY,                    -- ID único
    id_persona                            INTEGER NOT NULL,                          -- FK a persona (asistente)
    id_subactividad_producto              INTEGER NOT NULL,                          -- FK a subactividad
    asistio                               BOOLEAN DEFAULT TRUE,                  -- Confirmación de asistencia
    calificacion                          INT,                                   -- Calificación (1-5)
    comentarios                           TEXT,                                  -- Comentarios/feedback
    rol                                   VARCHAR(255),                          -- Tipo de rol en actividad 
    
    FOREIGN KEY (id_persona) REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_subactividad_producto) REFERENCES subactividad_producto (id_subactividad_producto) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT check_calificacion CHECK (calificacion IS NULL OR (calificacion >= 1 AND calificacion <= 5)),
    UNIQUE(id_persona, id_subactividad_producto)  -- Una persona no puede estar dos veces en la misma subactividad
);

CREATE TABLE asignacion_rol_persona (
    id_asignacion                                       SERIAL PRIMARY KEY,
    id_persona                                          INTEGER NOT NULL,
    id_tipo_rol                                         INTEGER NOT NULL,
    entidad                                             TIPO_ENTIDAD_ROL_ENUM NOT NULL,
    fecha_vigencia_desde                                DATE NOT NULL DEFAULT CURRENT_DATE,
    fecha_vigencia_hasta                                DATE,
    id_empresa                                          INTEGER,
    id_sede_campus                                      INTEGER,
    id_unidad_academica                                 INTEGER,
    id_unidad_administrativa                            INTEGER,
    id_subunidad_administrativa                         INTEGER,
    id_programa_academico                               INTEGER,
    id_grupo_investigacion                              INTEGER,
    id_programa                                         INTEGER,
    id_proyecto                                         INTEGER,
    id_ag_o_pe                                          INTEGER,
    id_asunto_de_trabajo_tipo_emprendimiento            INTEGER,
    id_mapa_conocimiento_proceso                        INTEGER,
    id_actividad_momento                                INTEGER,
    id_subactividad_producto                            INTEGER,
    id_emprendimiento                                   INTEGER,
    id_dimension_emprendimiento                         INTEGER,
    id_profesion                                        INTEGER,
    activo                                              BOOLEAN NOT NULL DEFAULT TRUE,


    -- EXACTAMENTE UNA entidad con valor
    CONSTRAINT chk_una_sola_entidad CHECK (
          (CASE WHEN id_empresa                                                 IS NOT NULL THEN 1 ELSE 0 END)
        + (CASE WHEN id_sede_campus                                             IS NOT NULL THEN 1 ELSE 0 END)
        + (CASE WHEN id_unidad_academica                                        IS NOT NULL THEN 1 ELSE 0 END)
        + (CASE WHEN id_unidad_administrativa                                   IS NOT NULL THEN 1 ELSE 0 END)
        + (CASE WHEN id_subunidad_administrativa                                IS NOT NULL THEN 1 ELSE 0 END)
        + (CASE WHEN id_programa_academico                                      IS NOT NULL THEN 1 ELSE 0 END)
        + (CASE WHEN id_grupo_investigacion                                     IS NOT NULL THEN 1 ELSE 0 END)
        + (CASE WHEN id_programa                                                IS NOT NULL THEN 1 ELSE 0 END)
        + (CASE WHEN id_proyecto                                                IS NOT NULL THEN 1 ELSE 0 END)
        + (CASE WHEN id_ag_o_pe                                                 IS NOT NULL THEN 1 ELSE 0 END)
        + (CASE WHEN id_asunto_de_trabajo_tipo_emprendimiento                   IS NOT NULL THEN 1 ELSE 0 END)
        + (CASE WHEN id_mapa_conocimiento_proceso                               IS NOT NULL THEN 1 ELSE 0 END)
        + (CASE WHEN id_actividad_momento                                       IS NOT NULL THEN 1 ELSE 0 END)
        + (CASE WHEN id_subactividad_producto                                   IS NOT NULL THEN 1 ELSE 0 END)
        + (CASE WHEN id_emprendimiento                                          IS NOT NULL THEN 1 ELSE 0 END)
        + (CASE WHEN id_dimension_emprendimiento                                IS NOT NULL THEN 1 ELSE 0 END)
        + (CASE WHEN id_profesion                                               IS NOT NULL THEN 1 ELSE 0 END)
        = 1
    ),

    -- La entidad declarada debe corresponder a la FK usada
    CONSTRAINT chk_entidad_coincide_con_fk CHECK (
           (entidad = 'EMPRESA'                  AND id_empresa                                 IS NOT NULL) OR
           (entidad = 'SEDE_CAMPUS'              AND id_sede_campus                             IS NOT NULL) OR
           (entidad = 'UNIDAD_ACADEMICA'         AND id_unidad_academica                        IS NOT NULL) OR
           (entidad = 'UNIDAD_ADMINISTRATIVA'    AND id_unidad_administrativa                   IS NOT NULL) OR
           (entidad = 'SUBUNIDAD_ADMINISTRATIVA' AND id_subunidad_administrativa                IS NOT NULL) OR
           (entidad = 'PROGRAMA_ACADEMICO'       AND id_programa_academico                      IS NOT NULL) OR
           (entidad = 'GRUPO_INVESTIGACION'      AND id_grupo_investigacion                     IS NOT NULL) OR
           (entidad = 'PROGRAMA'                 AND id_programa                                IS NOT NULL) OR
           (entidad = 'PROYECTO'                 AND id_proyecto                                IS NOT NULL) OR
           (entidad = 'AG_O_PE'                  AND id_ag_o_pe                                 IS NOT NULL) OR
           (entidad = 'ASUNTO_TRABAJO'           AND id_asunto_de_trabajo_tipo_emprendimiento   IS NOT NULL) OR
           (entidad = 'MAPA_CONOCIMIENTO'        AND id_mapa_conocimiento_proceso               IS NOT NULL) OR
           (entidad = 'ACTIVIDAD'                AND id_actividad_momento                       IS NOT NULL) OR
           (entidad = 'SUBACTIVIDAD'             AND id_subactividad_producto                   IS NOT NULL) OR
           (entidad = 'EMPRENDIMIENTO'           AND id_emprendimiento                          IS NOT NULL) OR
           (entidad = 'DIMENSION_EMPRENDIMIENTO' AND id_dimension_emprendimiento                IS NOT NULL) OR
           (entidad = 'PROFESION'                AND id_profesion                               IS NOT NULL)
    ),

    FOREIGN KEY (id_persona)                                        REFERENCES persona                                          (id_persona)                                        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_tipo_rol)                                       REFERENCES tipo_rol                                         (id_tipo_rol)                                       ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_empresa)                                        REFERENCES empresa                                          (id_empresa)                                        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_sede_campus)                                    REFERENCES sede_campus                                      (id_sede_campus)                                    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_unidad_academica)                               REFERENCES unidad_academica                                 (id_unidad_academica)                               ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_unidad_administrativa)                          REFERENCES unidad_administrativa                            (id_unidad_administrativa)                          ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_subunidad_administrativa)                       REFERENCES subunidad_administrativa                         (id_subunidad_administrativa)                       ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_programa_academico)                             REFERENCES programa_academico                               (id_programa_academico)                             ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_grupo_investigacion)                            REFERENCES grupo_investigacion                              (id_grupo_investigacion)                            ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_programa)                                       REFERENCES programa                                         (id_programa)                                       ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_proyecto)                                       REFERENCES proyecto                                         (id_proyecto)                                       ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_ag_o_pe)                                        REFERENCES ag_o_pe                                          (id_ag_o_pe)                                        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_asunto_de_trabajo_tipo_emprendimiento)          REFERENCES asunto_de_trabajo_tipo_emprendimiento            (id_asunto_de_trabajo_tipo_emprendimiento)          ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_mapa_conocimiento_proceso)                      REFERENCES mapa_conocimiento_proceso                        (id_mapa_conocimiento_proceso)                      ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_actividad_momento)                              REFERENCES actividad_momento                                (id_actividad_momento)                              ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_subactividad_producto)                          REFERENCES subactividad_producto                                (id_subactividad_producto)                          ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_emprendimiento)                                 REFERENCES emprendimiento                                   (id_emprendimiento)                                 ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_dimension_emprendimiento)                       REFERENCES dimension_emprendimiento                         (id_dimension_emprendimiento)                       ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_profesion)                                      REFERENCES profesion                                        (id_profesion)                                      ON DELETE CASCADE ON UPDATE CASCADE
);

-- ==============================================================
-- SISTEMA DE LOGS Y AUDITORÍA
-- ==============================================================

CREATE TABLE log_cambios (
    id_log                  SERIAL PRIMARY KEY,                    -- ID único del log
    nombre_tabla            VARCHAR(100) NOT NULL,                 -- Tabla afectada
    tipo_operacion          TIPO_OPERACION_LOG NOT NULL,          -- INSERT, UPDATE o DELETE
    id_registro_afectado    INTEGER NOT NULL,                          -- ID del registro modificado
    datos_anteriores        JSONB,                                 -- Valores antes del cambio (UPDATE/DELETE)
    datos_nuevos            JSONB,                                 -- Valores después del cambio (INSERT/UPDATE)
    usuario_accion          VARCHAR(100),                          -- Usuario que realizó la acción
    ip_origen               INET,                                  -- Dirección IP del origen
    fecha_cambio            TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Fecha/hora del cambio
    id_persona              INT,                                   -- FK a persona que hizo el cambio                                   -- FK a empresa relacionada
    
    FOREIGN KEY (id_persona) REFERENCES persona (id_persona) ON DELETE SET NULL ON UPDATE CASCADE
);

-- ==============================================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- ==============================================================

-- Índices para jerarquía geográfica
CREATE INDEX idx_departamento_pais ON departamento(id_pais);
CREATE INDEX idx_region_departamento ON region(id_departamento);
CREATE INDEX idx_ciudad_region ON ciudad(id_region);
CREATE INDEX idx_comuna_ciudad ON comuna(id_ciudad);
CREATE INDEX idx_barrio_comuna ON barrio(id_comuna);
CREATE INDEX idx_direccion_barrio ON direccion(id_barrio);

-- Índices para estructura académica
CREATE INDEX idx_sede_empresa ON sede_campus(id_empresa);
CREATE INDEX idx_unidad_admin_sede ON unidad_administrativa(id_sede_campus);
CREATE INDEX idx_unidad_acad_sede ON unidad_academica(id_sede_campus);
CREATE INDEX idx_programa_unidad ON programa_academico(id_unidad_academica);
CREATE INDEX idx_grupo_unidad ON grupo_investigacion(id_unidad_academica);

-- Índices para actividades y eventos
CREATE INDEX idx_actividad_fecha ON actividad_momento(fecha_actividad);
CREATE INDEX idx_actividad_tipo ON actividad_momento(tipo_actividad);
CREATE INDEX idx_subactividad_fecha ON subactividad_producto(fecha_subactividad_producto);

-- Índices para emprendimiento
CREATE INDEX idx_emprendimiento_empresa ON emprendimiento(id_empresa);
CREATE INDEX idx_emprendimiento_estado ON emprendimiento(estado_desarrollo_emprendimiento);

-- Índices para proyectos y programas
CREATE INDEX idx_proyecto_programa ON proyecto(id_programa);
CREATE INDEX idx_proyecto_estado ON proyecto(estado_proyecto);
CREATE INDEX idx_proyecto_fechas ON proyecto(fecha_inicio_proyecto, fecha_finalizacion_proyecto);
CREATE INDEX idx_programa_estado ON programa(estado_programa);

-- Índices para logs (con índices JSONB para búsquedas eficientes)
CREATE INDEX idx_log_tabla ON log_cambios(nombre_tabla);
CREATE INDEX idx_log_fecha ON log_cambios(fecha_cambio);
CREATE INDEX idx_log_operacion ON log_cambios(tipo_operacion);
CREATE INDEX idx_log_datos_anteriores_gin ON log_cambios USING GIN (datos_anteriores);
CREATE INDEX idx_log_datos_nuevos_gin ON log_cambios USING GIN (datos_nuevos);

CREATE INDEX idx_asigrol_persona ON asignacion_rol_persona(id_persona);
CREATE INDEX idx_asigrol_tipo    ON asignacion_rol_persona(id_tipo_rol);
CREATE INDEX idx_asigrol_entidad ON asignacion_rol_persona(entidad);

CREATE INDEX idx_subunidad_admin_unidad ON subunidad_administrativa(id_unidad_administrativa);
CREATE INDEX idx_persona_direccion      ON persona(id_direccion);
CREATE INDEX idx_sede_direccion         ON sede_campus(id_direccion);
CREATE INDEX idx_rel_act_subactividad   ON relacion_actividad_persona(id_subactividad_producto);

CREATE INDEX idx_log_usuario ON log_cambios(usuario_accion);

-- ==============================================================
-- COMENTARIOS EN TABLA
-- ==============================================================

COMMENT ON TABLE pais IS 'Catálogo de países. Nivel superior de la jerarquía geográfica.';

COMMENT ON TABLE departamento IS 'Departamentos/estados de un país. Depende de pais.';
COMMENT ON TABLE region IS 'Regiones/provincias dentro de un departamento. Depende de departamento.';
COMMENT ON TABLE ciudad IS 'Ciudades/municipios dentro de una región. Depende de region.';
COMMENT ON TABLE comuna IS 'Comunas/localidades dentro de una ciudad. Depende de ciudad.';
COMMENT ON TABLE barrio IS 'Barrios/sectores dentro de una comuna. Depende de comuna.';
COMMENT ON TABLE direccion IS 'Direcciones físicas con georreferenciación (lat/long). Depende de barrio.';

COMMENT ON TABLE persona IS 'Personas del sistema: identificación, contacto y ubicación (soft delete).';
COMMENT ON TABLE empresa IS 'Empresas e instituciones (incluye educativas). Información corporativa y contacto.';
COMMENT ON TABLE tipo_rol IS 'Catálogo de tipos de rol (ámbito/área) aplicables a distintas entidades.';

COMMENT ON TABLE sede_campus IS 'Sedes/campus de una empresa o institución, con dirección física.';
COMMENT ON TABLE unidad_administrativa IS 'Unidades administrativas pertenecientes a una sede/campus.';
COMMENT ON TABLE subunidad_administrativa IS 'Subunidades administrativas dependientes de una unidad administrativa.';
COMMENT ON TABLE unidad_academica IS 'Unidades académicas (Facultad/Escuela/Instituto/Corporación) por sede.';
COMMENT ON TABLE programa_academico IS 'Programas académicos (SNIES/nivel/área) vinculados a una unidad académica.';
COMMENT ON TABLE grupo_investigacion IS 'Grupos de investigación asociados a una unidad académica.';

COMMENT ON TABLE profesion IS 'Catálogo de profesiones/títulos con área y código ocupacional.';
COMMENT ON TABLE red_social_persona_empresa IS 'Perfiles de redes sociales asociados a una persona o a una empresa (exclusivo).';

COMMENT ON TABLE emprendimiento IS 'Ficha del emprendimiento asociada a una empresa: estado, sector, métricas y formalización.';
COMMENT ON TABLE emprendedor IS 'Atributos socio-demográficos del emprendedor enlazado a una persona.';
COMMENT ON TABLE programa IS 'Programas (no académicos) de gestión: estado, prioridad, etapa, cronograma y presupuesto.';
COMMENT ON TABLE proyecto IS 'Proyectos asociados (opcionalmente) a un programa: estado, fechas, contrato y valor.';

COMMENT ON TABLE ag_o_pe IS 'Catálogo de Asuntos de Gestión o Procesos Ejecutables (AG/PE) y su metadata.';
COMMENT ON TABLE asunto_de_trabajo_tipo_emprendimiento IS 'Asuntos de trabajo por tipo de emprendimiento, vinculados a AG/PE.';
COMMENT ON TABLE mapa_conocimiento_proceso IS 'Mapa/proceso con planificación, esfuerzo y presupuesto sobre un asunto de trabajo.';
COMMENT ON TABLE etapa_asunto_trabajo_proyecto_actividad IS 'Etapas que conectan asuntos de trabajo y proyectos (workflow de alto nivel).';
COMMENT ON TABLE dimension_emprendimiento IS 'Dimensiones/ámbitos de trabajo del emprendimiento (catálogo).';
COMMENT ON TABLE actividad_momento IS 'Actividades programadas dentro de una etapa (fecha, modalidad, tipo, observaciones).';
COMMENT ON TABLE subactividad_producto IS 'Subactividades/productos derivados de una actividad y su dimensión asociada.';
COMMENT ON TABLE relacion_actividad_persona IS 'Asistencia/participación de personas en subactividades (única por persona-subactividad).';

COMMENT ON TABLE asignacion_rol_persona IS 'Asignación polimórfica de roles de personas sobre múltiples entidades (1 sola FK activa, coherente con TIPO_ENTIDAD_ROL_ENUM).';
COMMENT ON TABLE log_cambios IS 'Bitácora de auditoría por tabla/operación con datos antes/después, usuario, IP y referencia a persona.';


COMMIT;


-- ==============================================================
-- FIN DEL MODELO DE BASE DE DATOS
-- ==============================================================


-- Mensaje final
DO $$
DECLARE
    v_schema          text := current_schema();
    v_tablas          int;
    v_enums           int;
    v_indices         int;
    v_constraints     int;
    v_fks             int;
    v_funcs           int;
    v_views           int;
    v_roles_enum      int;
BEGIN
    -- Conteo de tablas base
    SELECT count(*) INTO v_tablas
    FROM information_schema.tables
    WHERE table_schema = v_schema
      AND table_type = 'BASE TABLE';

    -- Conteo de tipos ENUM del esquema
    SELECT count(*) INTO v_enums
    FROM pg_type t
    JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE n.nspname = v_schema
      AND t.typtype = 'e';

    -- Conteo de índices (incluye PK/UK)
    SELECT count(*) INTO v_indices
    FROM pg_indexes
    WHERE schemaname = v_schema;

    -- Conteo de constraints totales y FKs
    SELECT count(*) INTO v_constraints
    FROM information_schema.table_constraints
    WHERE constraint_schema = v_schema;

    SELECT count(*) INTO v_fks
    FROM information_schema.table_constraints
    WHERE constraint_schema = v_schema
      AND constraint_type = 'FOREIGN KEY';

    -- Funciones / Procedimientos del esquema
    SELECT count(*) INTO v_funcs
    FROM information_schema.routines
    WHERE routine_schema = v_schema
      AND routine_type IN ('FUNCTION','PROCEDURE');

    -- Vistas del esquema
    SELECT count(*) INTO v_views
    FROM information_schema.views
    WHERE table_schema = v_schema;

    -- Cantidad de valores del ENUM de polimorfismo de roles
    SELECT count(*) INTO v_roles_enum
    FROM pg_enum e
    JOIN pg_type t ON t.oid = e.enumtypid
    JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE n.nspname = v_schema
      AND t.typname = 'tipo_entidad_rol_enum';

    -- Mensaje final veraz
    RAISE NOTICE E'\n';
    RAISE NOTICE '╔════════════════════════════════════════════════════════════╗';
    RAISE NOTICE '║   BASE DE DATOS DE EMPRENDIMIENTO INSTALADA  (Esquema: %)  ║', v_schema;
    RAISE NOTICE '╠════════════════════════════════════════════════════════════╣';
    RAISE NOTICE '║  ✅ Tablas: %                                              ║', v_tablas;
    RAISE NOTICE '║  ✅ Tipos ENUM: %                                          ║', v_enums;
    RAISE NOTICE '║  ✅ Índices (incluye PK/UK): %                             ║', v_indices;
    RAISE NOTICE '║  ✅ Constraints totales: %                                 ║', v_constraints;
    RAISE NOTICE '║     └─ Foreign Keys: %                                     ║', v_fks;
    RAISE NOTICE '║  ✅ Vistas: %                                              ║', v_views;
    RAISE NOTICE '║  ✅ Funciones/Procedimientos: %                            ║', v_funcs;
    RAISE NOTICE '║  ✅ Polimorfismo de roles (TIPO_ENTIDAD_ROL_ENUM): %       ║', v_roles_enum;
    RAISE NOTICE '╚════════════════════════════════════════════════════════════╝';
END $$;


