-- ==============================================================
-- MODELO DE BASE DE DATOS - SISTEMA DE GESTIÓN DE EMPRENDIMIENTO + TALENTO HUMANO
-- Versión: Beta Extendida Integrada
-- Fecha: 2025
-- Descripción: Sistema integral para gestión de emprendimiento,
--              empresas, instituciones educativas, programas y talento humano
--              con integración completa entre módulos
-- ==============================================================

BEGIN;

-- ==============================================================
-- TIPOS ENUM EXISTENTES (SIN CAMBIOS)
-- ==============================================================

CREATE TYPE SEXO_ENUM AS ENUM ('Masculino', 'Femenino', 'Intersexual');
CREATE TYPE GENERO_ENUM AS ENUM ('Hombre', 'Mujer', 'No binario', 'Género fluido', 'Agénero', 'Prefiero no decirlo', 'Otro');
CREATE TYPE TIPO_DOCUMENTO_PERSONA_ENUM AS ENUM ('Cédula de Ciudadanía (CC)', 'Tarjeta de Identidad (TI)', 'Cédula de Extranjería (CE)', 'Pasaporte (P)', 'Registro Civil (RC)', 'NIT (Número de Identificación Tributaria)', 'Documento Nacional de Identidad (DNI)', 'Permiso Especial de Permanencia (PEP)', 'Permiso por Protección Temporal (PPT)');
CREATE TYPE ESTRATO_SOCIOECONOMICO_ENUM AS ENUM ('Estrato 1 (Bajo-bajo)', 'Estrato 2 (Bajo)', 'Estrato 3 (Medio-bajo)', 'Estrato 4 (Medio)', 'Estrato 5 (Medio-alto)', 'Estrato 6 (Alto)');
CREATE TYPE ETNIA_EMPRENDEDOR_ENUM AS ENUM ('Blanco', 'Mestizo', 'Afrocolombiano', 'Indígena', 'Raizal', 'Palenquero', 'Rom o Gitano', 'Prefiero no decir', 'Ninguno de los anteriores');
CREATE TYPE ESTADO_CIVIL_EMPRENDEDOR_ENUM AS ENUM ('Soltero', 'Casado','Unión libre', 'Separado', 'Divorciado', 'Viudo', 'Otro');
CREATE TYPE CATEGORIA_EMPRESA_ENUM AS ENUM ('Microempresa', 'Pequeña empresa', 'Mediana empresa', 'Gran empresa');
CREATE TYPE ZONA_EMPRESA_ENUM AS ENUM ('Urbana', 'Rural','Periurbana');
CREATE TYPE TIPO_EMPRESA_ENUM AS ENUM ('Tecnología', 'Comercio', 'Servicios', 'Industria', 'Agricultura', 'Institución educativa');
CREATE TYPE MACROSECTOR_EMPRESA_ENUM AS ENUM ('Tecnología', 'Comercio', 'Servicios', 'Industria', 'Agricultura');
CREATE TYPE SUBSECTOR_EMPRESA_ENUM AS ENUM ('Agricultura', 'Ganadería', 'Alimentos y bebidas', 'Textiles, confecciones, cuero y calzado', 'Productos químicos y farmacéuticos', 'Plásticos y caucho', 'Minerales no metálicos', 'Metalmecánica', 'Automotriz', 'Electrónica y electrodomésticos','Software y desarrollo','Servicios financieros','Salud','Educación','Turismo','Logística y transporte','Construcción','Energía y recursos','Telecomunicaciones','Comercio al por menor','Comercio al por mayor');
CREATE TYPE ESTADO_DESARROLLO_EMPREN_ENUM AS ENUM ('En incubación','Consolidado', 'En pausa', 'Finalizado');
CREATE TYPE TIPO_UNIDAD_ACADEMICA_ENUM AS ENUM ('Facultad', 'Escuela', 'Instituto', 'Corporación');
CREATE TYPE TIPO_UBICACION_UNIDAD_IE_ENUM AS ENUM ('Campus principal', 'Sede', 'Sede regional', 'Sede única');
CREATE TYPE NIVEL_PROGRAMA_ACADEMICO_ENUM AS ENUM ('Técnica profesional', 'Tecnológico', 'Profesional','Especialización','Maestría', 'Doctorado', 'Básica secundaria', 'Básica primaria', 'Ninguno');
CREATE TYPE AREA_PROGRAMA_ACADEMICO_ENUM AS ENUM ('Ingeniería', 'Ciencias Sociales', 'Ciencias Naturales', 'Artes', 'Humanidades','Ciencias de la Salud','Ciencias Económicas y Administrativas','Ciencias Agrarias','Educación');
CREATE TYPE ESTADO_PROGRAMA_ENUM AS ENUM ('Activo', 'Inactivo','En desarrollo', 'Finalizado', 'Suspendido');
CREATE TYPE ESTADO_PROYECTO_ENUM AS ENUM ('Pendiente','En ejecución','Finalizado', 'Cancelado','Suspendido');
CREATE TYPE PRIORIDAD_ENUM AS ENUM ('Alta','Media','Baja');
CREATE TYPE ETAPA_ENUM AS ENUM ('Planificación','Ejecución','Cierre', 'Post-cierre');
CREATE TYPE MODALIDAD_ACTIVIDAD_ENUM AS ENUM ('Virtual', 'Presencial', 'Híbrido');
CREATE TYPE TIPO_ACTIVIDAD_ENUM AS ENUM ('Evento','Actividad', 'Curso','Taller', 'Conferencia','Seminario');
CREATE TYPE TIPO_OPERACION_LOG AS ENUM ('INSERT','UPDATE','DELETE');
CREATE TYPE AMBITO_ROL_ENUM AS ENUM ('ACADEMICO', 'ADMINISTRATIVO', 'PROYECTO', 'PROGRAMA', 'EMPRESA', 'INVESTIGACION', 'ACTIVIDAD', 'EMPRENDIMIENTO', 'PROCESO','GENERAL');
CREATE TYPE TIPO_ENTIDAD_ROL_ENUM AS ENUM ('EMPRESA','SEDE_CAMPUS','UNIDAD_ACADEMICA','UNIDAD_ADMINISTRATIVA','SUBUNIDAD_ADMINISTRATIVA','PROGRAMA_ACADEMICO','GRUPO_INVESTIGACION','PROGRAMA','PROYECTO','AG_O_PE','ASUNTO_TRABAJO','MAPA_CONOCIMIENTO','ACTIVIDAD','SUBACTIVIDAD','ETAPA_ASUNTO_TRABAJO','EMPRENDIMIENTO','DIMENSION_EMPRENDIMIENTO', 'PROFESION','CONTRATO','PROVEEDOR','INVENTARIO','COMPONENTE','COMPRA');
CREATE TYPE TIPO_PROGRAMA_ENUM AS ENUM ('Formación','Incubación','Aceleración','Preincubación','Investigación','Innovación','Extensión','Fortalecimiento','Convocatoria','Eventos');
CREATE TYPE ALCANCE_PROYECTO_ENUM AS ENUM ('Local','Municipal','Departamental','Regional','Nacional','Internacional');
CREATE TYPE TIPO_AG_PE_ENUM AS ENUM ('Misional', 'Apoyo-Operativo', 'Apoyo-Metodológico');
CREATE TYPE ESTADO_DOCUMENTACION_ENUM AS ENUM ('Sin iniciar','En elaboración','En revisión','Aprobada','Publicada','Obsoleta');
CREATE TYPE FASE_ACTIVIDAD_ENUM AS ENUM ('Planeación','Convocatoria','Ejecución','Seguimiento','Cierre','Evaluación');
CREATE TYPE NATURALEZA_JURIDICA_ENUM AS ENUM ('Persona Natural','SAS','LTDA','SA','S. en C.','SCA','EU','Cooperativa','Fundación','Corporación','Asociación');
CREATE TYPE CATEGORIA_COLCIENCIAS_ENUM AS ENUM ('A1','A','B','C','Reconocido');
CREATE TYPE AREA_PROFESION_ENUM AS ENUM ('Agronomía, veterinaria y afines','Bellas artes','Ciencias de la educación','Ciencias de la salud','Ciencias sociales y humanas','Economía, administración, contaduría y afines','Ingeniería, arquitectura, urbanismo y afines','Matemáticas y ciencias naturales', 'Agricola', 'Servicios', 'Otro');
CREATE TYPE TIPO_CUENTA_RED_SOCIAL_ENUM AS ENUM ('Personal','Corporativa','Institucional','Marca','Proyecto','Comunidad');
CREATE TYPE TIPO_SUBACTIVIDAD_PRODUCTO_ENUM AS ENUM ('Taller','Mentoría','Asesoría','Charla','Capacitación','Networking','Demostración','Diagnóstico','Entrega','Otro');

-- ==============================================================
-- NUEVOS TIPOS ENUM PARA TALENTO HUMANO
-- ==============================================================

-- Para proveedores
CREATE TYPE TIPO_PROVEEDOR_ENUM AS ENUM ('Persona Natural', 'Persona Jurídica', 'Mixto');

-- Para contratos
CREATE TYPE TIPO_CONTRATO_ENUM AS ENUM ('Prestación de Servicios', 'Obra o Labor', 'Consultoría', 'Suministro', 'Mantenimiento', 'Arrendamiento', 'Otros');
CREATE TYPE ESTADO_CONTRATO_ENUM AS ENUM ('Borrador', 'En aprobación', 'Aprobado', 'Activo', 'Suspendido', 'Terminado', 'Liquidado', 'Cancelado');
CREATE TYPE TIPO_VINCULACION_ENUM AS ENUM ('Contrato', 'Convenio', 'Acta', 'Orden de compra', 'Otros');

-- Para inventario (SIMPLIFICADO)
CREATE TYPE ESTADO_INVENTARIO_ENUM AS ENUM ('Disponible', 'Asignado', 'En mantenimiento', 'Dado de baja', 'Perdido', 'En traslado');
CREATE TYPE TIPO_SEGUIMIENTO_INVENTARIO_ENUM AS ENUM ('Traslado', 'Asignación', 'Devolución', 'Baja', 'Mantenimiento', 'Incidencia', 'Revisión');

-- Para oportunidades
CREATE TYPE ESTADO_OPORTUNIDAD_ENUM AS ENUM ('Identificada', 'En análisis', 'En preparación', 'Presentada', 'Aprobada', 'Rechazada', 'En ejecución', 'Finalizada');

-- **NUEVOS** Para componentes y compras
CREATE TYPE TIPO_COMPONENTE_ENUM AS ENUM ('Recursos humanos', 'Equipos', 'Materiales', 'Servicios', 'Infraestructura', 'Tecnología');
CREATE TYPE ESTADO_COMPRA_ENUM AS ENUM ('Solicitada', 'En proceso', 'Aprobada', 'Rechazada', 'Entregada', 'Facturada');

-- ==============================================================
-- JERARQUÍA GEOGRÁFICA (SIN CAMBIOS)
-- ==============================================================

CREATE TABLE pais (
    id_pais                   SERIAL PRIMARY KEY,
    nombre_pais               VARCHAR(100) NOT NULL UNIQUE,
    codigo_iso2               CHAR(2) UNIQUE,
    codigo_iso3               CHAR(3) UNIQUE,
    codigo_numerico           VARCHAR(3),
    url_polygon_pais          TEXT
);

CREATE TABLE departamento (
    id_departamento           SERIAL PRIMARY KEY,
    nombre_departamento       VARCHAR(100) NOT NULL,
    codigo_departamento       VARCHAR(10),
    url_polygon_departamento  TEXT,
    id_pais                   INTEGER NOT NULL,
    
    FOREIGN KEY (id_pais) REFERENCES pais (id_pais) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE(nombre_departamento, id_pais)
);

CREATE TABLE region (
    id_region                 SERIAL PRIMARY KEY,
    nombre_region             VARCHAR(100) NOT NULL,
    codigo_region             VARCHAR(10),
    url_polygon_region        TEXT,
    id_departamento           INTEGER NOT NULL,
    
    FOREIGN KEY (id_departamento) REFERENCES departamento (id_departamento) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE(nombre_region, id_departamento)
);

CREATE TABLE ciudad (
    id_ciudad                 SERIAL PRIMARY KEY,
    nombre_ciudad             VARCHAR(100) NOT NULL,
    codigo_ciudad             VARCHAR(10),
    url_polygon_ciudad        TEXT,
    id_region                 INTEGER NOT NULL,
    
    FOREIGN KEY (id_region) REFERENCES region (id_region) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE(nombre_ciudad, id_region)
);

CREATE TABLE comuna (
    id_comuna                 SERIAL PRIMARY KEY,
    nombre_comuna             VARCHAR(100) NOT NULL,
    codigo_comuna             VARCHAR(10),
    url_polygon_comuna        TEXT,
    id_ciudad                 INTEGER NOT NULL,
    
    FOREIGN KEY (id_ciudad) REFERENCES ciudad (id_ciudad) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE(nombre_comuna, id_ciudad)
);

CREATE TABLE barrio (
    id_barrio                 SERIAL PRIMARY KEY,
    nombre_barrio             VARCHAR(100) NOT NULL,
    codigo_barrio             VARCHAR(10),
    url_polygon_barrio        TEXT,
    id_comuna                 INTEGER NOT NULL,
    
    FOREIGN KEY (id_comuna) REFERENCES comuna (id_comuna) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE(nombre_barrio, id_comuna)
);

CREATE TABLE direccion (
    id_direccion              SERIAL PRIMARY KEY,
    direccion_textual         VARCHAR(200) NOT NULL,
    codigo_postal             VARCHAR(10),
    latitud                   DECIMAL(10, 8),
    longitud                  DECIMAL(11, 8),
    id_barrio                 INTEGER NOT NULL,

    FOREIGN KEY (id_barrio) REFERENCES barrio (id_barrio) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ==============================================================
-- PERSONAS Y EMPRESAS (SIN CAMBIOS)
-- ==============================================================

CREATE TABLE persona (
    id_persona                   SERIAL PRIMARY KEY,
    primer_nombre_persona        VARCHAR(100) NOT NULL,
    segundo_nombre_persona       VARCHAR(100),
    primer_apellido_persona      VARCHAR(100) NOT NULL,
    segundo_apellido_persona     VARCHAR(100),
    tipo_documento_persona       TIPO_DOCUMENTO_PERSONA_ENUM NOT NULL,
    numero_documento_persona     VARCHAR(50) UNIQUE NOT NULL,
    fecha_nacimiento_persona     DATE NOT NULL,
    sexo_biologico               SEXO_ENUM NOT NULL,
    genero                       GENERO_ENUM NOT NULL,
    telefono_celular             VARCHAR(20),
    correo_electronico_personal  VARCHAR(100) UNIQUE NOT NULL,
    correo_alternativo           VARCHAR(100),
    estrato_socioeconomico       ESTRATO_SOCIOECONOMICO_ENUM,
    foto_persona_url             TEXT,
    id_direccion                 INT,
    activo                       BOOLEAN DEFAULT TRUE,
    fecha_creacion               TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_direccion) REFERENCES direccion (id_direccion) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT check_fecha_nacimiento CHECK (fecha_nacimiento_persona <= CURRENT_DATE)
);

CREATE TABLE empresa (
    id_empresa                        SERIAL PRIMARY KEY,
    nombre_empresa                    VARCHAR(100) NOT NULL UNIQUE,
    nit_empresa                       VARCHAR(20) UNIQUE,
    categoria_empresa                 CATEGORIA_EMPRESA_ENUM NOT NULL,
    zona_empresa                      ZONA_EMPRESA_ENUM NOT NULL,
    tipo_empresa                      TIPO_EMPRESA_ENUM NOT NULL,
    macrosector_empresa               MACROSECTOR_EMPRESA_ENUM NOT NULL,
    subsector_empresa                 SUBSECTOR_EMPRESA_ENUM NOT NULL,
    naturaleza_juridica               NATURALEZA_JURIDICA_ENUM,
    telefono_empresa                  VARCHAR(20),
    correo_empresa                    VARCHAR(100) UNIQUE NOT NULL,
    sitio_web_url                     TEXT,
    logo_empresa_url                  TEXT,
    descripcion_empresa               TEXT,
    pertenece_parque                  BOOLEAN DEFAULT FALSE,
    fecha_fundacion                   DATE,
    numero_empleados                  INT,
    es_emprendimiento                 BOOLEAN NOT NULL,
    activo                           BOOLEAN DEFAULT TRUE,
    fecha_creacion                   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion              TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT check_fecha_fundacion CHECK (fecha_fundacion <= CURRENT_DATE),
    CONSTRAINT check_numero_empleados CHECK (numero_empleados >= 0)
);

CREATE TABLE tipo_rol (
    id_tipo_rol              SERIAL PRIMARY KEY,
    nombre_rol               VARCHAR(100) NOT NULL,
    descripcion_rol          TEXT NOT NULL,
    ambito_rol               AMBITO_ROL_ENUM NOT NULL,
    activo                   BOOLEAN DEFAULT TRUE NOT NULL 
);

CREATE TABLE sede_campus (
    id_sede_campus         SERIAL PRIMARY KEY,
    nombre_sede_campus     VARCHAR(100) NOT NULL,
    tipo_ubicacion         TIPO_UBICACION_UNIDAD_IE_ENUM NOT NULL,
    es_sede_principal      BOOLEAN DEFAULT FALSE,
    telefono_sede          VARCHAR(20),
    correo_sede            VARCHAR(100),
    id_empresa             INTEGER NOT NULL,
    id_direccion           INTEGER NOT NULL,
    activo                 BOOLEAN DEFAULT TRUE,
    
    FOREIGN KEY (id_empresa) REFERENCES empresa (id_empresa) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_direccion) REFERENCES direccion (id_direccion) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE(nombre_sede_campus, id_empresa)
);

-- ==============================================================
-- ESTRUCTURA ACADÉMICA (SIN CAMBIOS)
-- ==============================================================

CREATE TABLE unidad_administrativa (
    id_unidad_administrativa         SERIAL PRIMARY KEY,
    nombre_unidad_administrativa     VARCHAR(100) NOT NULL,
    descripcion                      TEXT,
    id_sede_campus                   INTEGER NOT NULL,
    activo                          BOOLEAN DEFAULT TRUE,
    
    FOREIGN KEY (id_sede_campus) REFERENCES sede_campus (id_sede_campus) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE(nombre_unidad_administrativa, id_sede_campus)
);

CREATE TABLE subunidad_administrativa (
    id_subunidad_administrativa      SERIAL PRIMARY KEY,
    nombre_subunidad                 VARCHAR(100) NOT NULL,
    descripcion                      TEXT,
    id_unidad_administrativa         INTEGER NOT NULL,
    activo                          BOOLEAN DEFAULT TRUE,
    
    FOREIGN KEY (id_unidad_administrativa) REFERENCES unidad_administrativa (id_unidad_administrativa) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE(nombre_subunidad, id_unidad_administrativa)
);

CREATE TABLE unidad_academica (
    id_unidad_academica         SERIAL PRIMARY KEY,
    tipo_unidad_academica       TIPO_UNIDAD_ACADEMICA_ENUM NOT NULL,
    nombre_unidad_academica     VARCHAR(100) NOT NULL,
    descripcion                 TEXT,
    id_sede_campus              INTEGER NOT NULL,
    activo                      BOOLEAN DEFAULT TRUE,
    
    FOREIGN KEY (id_sede_campus) REFERENCES sede_campus (id_sede_campus) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE(nombre_unidad_academica, id_sede_campus)
);

CREATE TABLE programa_academico (
    id_programa_academico       SERIAL PRIMARY KEY,
    titulo_programa_academico   VARCHAR(100) NOT NULL,
    codigo_snies                VARCHAR(20),
    nivel_programa_academico    NIVEL_PROGRAMA_ACADEMICO_ENUM NOT NULL,
    area_programa_academico     AREA_PROGRAMA_ACADEMICO_ENUM NOT NULL,
    id_unidad_academica         INTEGER NOT NULL,
    activo                      BOOLEAN DEFAULT TRUE,
    
    FOREIGN KEY (id_unidad_academica) REFERENCES unidad_academica (id_unidad_academica) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE grupo_investigacion (
    id_grupo_investigacion       SERIAL PRIMARY KEY,
    nombre_grupo_investigacion   VARCHAR(100) NOT NULL,
    codigo_colciencias           VARCHAR(50),
    categoria_colciencias        CATEGORIA_COLCIENCIAS_ENUM,
    lineas_investigacion         TEXT,
    id_unidad_academica          INTEGER NOT NULL,
    activo                       BOOLEAN DEFAULT TRUE,
    
    FOREIGN KEY (id_unidad_academica) REFERENCES unidad_academica (id_unidad_academica) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE(nombre_grupo_investigacion, id_unidad_academica)
);

-- ==============================================================
-- PROFESIONES Y REDES SOCIALES (SIN CAMBIOS)
-- ==============================================================

CREATE TABLE profesion (
    id_profesion       SERIAL PRIMARY KEY,
    titulo_profesion   VARCHAR(100) NOT NULL UNIQUE,
    area_profesion     AREA_PROFESION_ENUM NOT  NULL,
    codigo_profesion   VARCHAR(50),
    activo             BOOLEAN DEFAULT TRUE
);

CREATE TABLE red_social_persona_empresa (
    id_red_social_persona_empresa  SERIAL PRIMARY KEY,
    nombre_plataforma              VARCHAR(50) NOT NULL,
    url_perfil                     TEXT NOT NULL,
    tipo_cuenta                    TIPO_CUENTA_RED_SOCIAL_ENUM NOT NULL,
    id_persona                     INT,
    id_empresa                     INT,
    activo                         BOOLEAN DEFAULT TRUE,
    
    FOREIGN KEY (id_persona) REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_empresa) REFERENCES empresa (id_empresa) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT check_red_social_entidad CHECK ((id_persona IS NOT NULL AND id_empresa IS NULL) OR (id_persona IS NULL AND id_empresa IS NOT NULL))
);

-- ==============================================================
-- EMPRENDIMIENTO Y EMPRENDEDOR (SIN CAMBIOS)
-- ==============================================================

CREATE TABLE emprendimiento (
    id_emprendimiento                  SERIAL PRIMARY KEY,
    id_empresa                         INTEGER NOT NULL,
    idea_negocio                       TEXT,
    estado_desarrollo_emprendimiento   ESTADO_DESARROLLO_EMPREN_ENUM NOT NULL,
    esta_formalizada                   BOOLEAN DEFAULT FALSE,
    importacion                        BOOLEAN DEFAULT FALSE,
    exportacion                        BOOLEAN DEFAULT FALSE,
    esta_asociada_red                  BOOLEAN DEFAULT FALSE,
    esta_asociada_upa                  BOOLEAN DEFAULT FALSE,
    pertenece_cluster                  BOOLEAN DEFAULT FALSE,
    tiene_camara_comercio              BOOLEAN DEFAULT FALSE,
    ventas_promedio_anual              NUMERIC(15,2),
    cantidad_clientes_promedio_mes     INT,
    activo                             BOOLEAN DEFAULT TRUE,
    fecha_creacion                     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion                TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_empresa) REFERENCES empresa (id_empresa) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT check_ventas CHECK (ventas_promedio_anual IS NULL OR ventas_promedio_anual >= 0),
    CONSTRAINT check_clientes CHECK (cantidad_clientes_promedio_mes IS NULL OR cantidad_clientes_promedio_mes >= 0)
);

CREATE TABLE emprendedor (
    id_emprendedor                    SERIAL PRIMARY KEY,
    id_persona                        INTEGER NOT NULL,
    etnia_emprendedor                 ETNIA_EMPRENDEDOR_ENUM NOT NULL,
    discapacidad_emprendedor          BOOLEAN DEFAULT FALSE,
    victima_emprendedor               BOOLEAN DEFAULT FALSE,
    poblacion_campesina_emprendedor   BOOLEAN DEFAULT FALSE,
    estado_civil_emprendedor          ESTADO_CIVIL_EMPRENDEDOR_ENUM NOT NULL,
    cabeza_hogar_emprendedor          BOOLEAN DEFAULT FALSE,
    numero_personas_a_cargo           INTEGER DEFAULT 0,
    nivel_educativo_maximo            NIVEL_PROGRAMA_ACADEMICO_ENUM,
    activo                            BOOLEAN DEFAULT TRUE,
    fecha_creacion                    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion               TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_persona) REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE    
);

-- ==============================================================
-- PROGRAMAS Y PROYECTOS (SIN CAMBIOS)
-- ==============================================================

CREATE TABLE programa (
    id_programa                         SERIAL PRIMARY KEY,
    nombre_programa                     VARCHAR(255) NOT NULL,
    nombre_corto_programa               VARCHAR(100),
    objetivo_programa                   TEXT,
    tipo_programa                       TIPO_PROGRAMA_ENUM NOT NULL,
    estado_programa                     ESTADO_PROGRAMA_ENUM NOT NULL DEFAULT 'En desarrollo',
    prioridad_programa                  PRIORIDAD_ENUM DEFAULT 'Media',
    etapa_programa                      ETAPA_ENUM DEFAULT 'Planificación',
    valor_programa                      NUMERIC(15,2),
    cronograma_inicio_programa          DATE,
    cronograma_fin_programa             DATE,
    correo_programa                     VARCHAR(255),
    telefono_programa                   VARCHAR(20),
    roles_funciones_programa            TEXT,
    resumen_estado_programa             TEXT,
    activo                             BOOLEAN DEFAULT TRUE,
    fecha_creacion                     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion                TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT check_valor_programa CHECK (valor_programa IS NULL OR valor_programa >= 0),
    CONSTRAINT check_fechas_programa CHECK (cronograma_fin_programa IS NULL OR cronograma_fin_programa >= cronograma_inicio_programa),
    CONSTRAINT check_correo_programa CHECK (correo_programa IS NULL OR correo_programa ~* '^[^@\s]+@[^@\s]+\.[A-Za-z]{2,}$')
);

CREATE TABLE proyecto (
    id_proyecto                        SERIAL PRIMARY KEY,
    id_programa                        INT,
    nombre_proyecto                    VARCHAR(255) NOT NULL,
    estado_proyecto                    ESTADO_PROYECTO_ENUM NOT NULL DEFAULT 'Pendiente',
    prioridad_proyecto                 PRIORIDAD_ENUM DEFAULT 'Media',
    etapa_proyecto                     ETAPA_ENUM DEFAULT 'Planificación',
    fecha_inicio_proyecto              DATE,
    fecha_finalizacion_proyecto        DATE,
    numero_contrato_proyecto           VARCHAR(50),
    objeto_proyecto                    TEXT,
    tipo_ingreso_proyecto              VARCHAR(100),
    figura_contractual_proyecto        VARCHAR(100),
    fuente_recurso_proyecto            VARCHAR(255),
    alcance_proyecto                   ALCANCE_PROYECTO_ENUM NOT NULL,
    valor_proyecto                     NUMERIC(15,2),
    moneda_proyecto                    VARCHAR(10) DEFAULT 'COP',
    activo                            BOOLEAN DEFAULT TRUE,
    fecha_creacion                    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion               TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_programa) REFERENCES programa(id_programa) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT check_valor_proyecto CHECK (valor_proyecto IS NULL OR valor_proyecto >= 0),
    CONSTRAINT check_fechas_proyecto CHECK (fecha_finalizacion_proyecto IS NULL OR fecha_finalizacion_proyecto >= fecha_inicio_proyecto)
);

-- ==============================================================
-- ASUNTOS DE GESTIÓN Y PROCESOS EJECUTABLES (SIN CAMBIOS)
-- ==============================================================

CREATE TABLE ag_o_pe (
    id_ag_o_pe                           SERIAL PRIMARY KEY,
    nombre_ag_o_pe                       VARCHAR(255) NOT NULL,
    tipo_ag_pe                           TIPO_AG_PE_ENUM NOT NULL,
    sigla_corta_ag_pe                    VARCHAR(50),
    sigla_larga_ag_pe                    VARCHAR(100),
    objetivo_ag_pe                       TEXT,
    procesos_ag_pe                       TEXT,
    macroproceso_ag_pe                   TEXT,
    activo                              BOOLEAN DEFAULT TRUE
);

CREATE TABLE asunto_de_trabajo_tipo_emprendimiento (
    id_asunto_de_trabajo_tipo_emprendimiento                    SERIAL PRIMARY KEY,
    id_ag_o_pe                                                  INT,
    nombre_asunto_trabajo                                       VARCHAR(255) NOT NULL,
    descripcion_asunto_trabajo                                  TEXT,
    talento_humano_asunto_trabajo                               TEXT,
    agrupacion_asunto_trabajo                                   TEXT,
    activo                                                      BOOLEAN DEFAULT TRUE,
    
    FOREIGN KEY (id_ag_o_pe) REFERENCES ag_o_pe(id_ag_o_pe) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE mapa_conocimiento_proceso (
    id_mapa_conocimiento_proceso                                        SERIAL PRIMARY KEY,
    id_asunto_de_trabajo_tipo_emprendimiento                    INT,
    nombre_proceso                                              VARCHAR(255) NOT NULL,
    prioridad_proceso                                           PRIORIDAD_ENUM DEFAULT 'Media',
    estado_documentacion_proceso                                ESTADO_DOCUMENTACION_ENUM NOT NULL,
    cronograma_inicio_proceso                                   DATE,
    cronograma_fin_proceso                                      DATE,
    duracion_dias                                               INT,
    esfuerzo_planificado_horas                                  INT,
    esfuerzo_real_horas                                         INT,
    presupuesto_proceso                                         NUMERIC(15,2),
    tipo_proyecto_proceso                                       VARCHAR(100),
    activo                                                      BOOLEAN DEFAULT TRUE,
    
    FOREIGN KEY (id_asunto_de_trabajo_tipo_emprendimiento) REFERENCES asunto_de_trabajo_tipo_emprendimiento (id_asunto_de_trabajo_tipo_emprendimiento) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT check_duracion_proceso CHECK (duracion_dias IS NULL OR duracion_dias > 0),
    CONSTRAINT check_esfuerzo CHECK (esfuerzo_planificado_horas IS NULL OR esfuerzo_planificado_horas > 0),
    CONSTRAINT check_presupuesto_proceso CHECK (presupuesto_proceso IS NULL OR presupuesto_proceso >= 0),
    CONSTRAINT check_fechas_proceso CHECK (cronograma_fin_proceso IS NULL OR cronograma_fin_proceso >= cronograma_inicio_proceso)
);

-- ==============================================================
-- **NUEVAS TABLAS PARA TALENTO HUMANO (INTEGRADAS)**
-- ==============================================================

-- **NUEVA** - Tabla de proveedores (puede ser persona o empresa)
CREATE TABLE proveedor (
    id_proveedor                    SERIAL PRIMARY KEY,
    tipo_proveedor                  TIPO_PROVEEDOR_ENUM NOT NULL,
    codigo_proveedor                VARCHAR(50) UNIQUE,
    nombre_comercial                VARCHAR(200),
    id_persona                      INTEGER,                    -- FK a persona (si es persona natural)
    id_empresa                      INTEGER,                    -- FK a empresa (si es persona jurídica)
    calificacion_proveedor          DECIMAL(3,2),              -- Calificación del 1 al 5
    observaciones_proveedor         TEXT,
    activo                          BOOLEAN DEFAULT TRUE,
    
    FOREIGN KEY (id_persona) REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_empresa) REFERENCES empresa (id_empresa) ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Debe tener persona O empresa, no ambas ni ninguna
    CONSTRAINT check_proveedor_entidad CHECK (
        (tipo_proveedor = 'Persona Natural' AND id_persona IS NOT NULL AND id_empresa IS NULL) OR
        (tipo_proveedor = 'Persona Jurídica' AND id_persona IS NULL AND id_empresa IS NOT NULL) OR
        (tipo_proveedor = 'Mixto' AND id_persona IS NOT NULL AND id_empresa IS NOT NULL)
    ),
    CONSTRAINT check_calificacion_proveedor CHECK (calificacion_proveedor IS NULL OR (calificacion_proveedor >= 1 AND calificacion_proveedor <= 5))
);

-- **NUEVA** - Tabla de contratos (integra información del ERP)
CREATE TABLE contrato (
    id_contrato                     SERIAL PRIMARY KEY,
    numero_contrato                 VARCHAR(100) NOT NULL UNIQUE,
    numero_tramite_sipe             VARCHAR(100),               -- Número SIPE
    tipo_contrato                   TIPO_CONTRATO_ENUM NOT NULL,
    estado_contrato                 ESTADO_CONTRATO_ENUM NOT NULL DEFAULT 'Borrador',
    tipo_vinculacion                TIPO_VINCULACION_ENUM,
    objeto_contrato                 TEXT NOT NULL,
    id_proyecto                     INTEGER,                    -- **RELACION** - FK a proyecto
    id_proveedor                    INTEGER NOT NULL,           -- **RELACION** - FK a proveedor
    entidad_contratacion            VARCHAR(200),
    fecha_inicio                    DATE NOT NULL,
    fecha_fin                       DATE NOT NULL,
    valor_total                     NUMERIC(15,2) NOT NULL,
    moneda                          VARCHAR(10) DEFAULT 'COP',
    valor_hora                      NUMERIC(10,2),
    dias_calendario                 INTEGER,
    numero_informes_requeridos      INTEGER DEFAULT 1,
    id_lider_contrato               INTEGER,                    -- **RELACION** - FK a persona (líder del contrato)
    correo_lider                    VARCHAR(100),
    observaciones_estado            TEXT,
    roles_funciones                 TEXT,
    activo                          BOOLEAN DEFAULT TRUE,
    fecha_creacion                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion             TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_proyecto) REFERENCES proyecto (id_proyecto) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (id_proveedor) REFERENCES proveedor (id_proveedor) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_lider_contrato) REFERENCES persona (id_persona) ON DELETE SET NULL ON UPDATE CASCADE,
    
    CONSTRAINT check_fechas_contrato CHECK (fecha_fin >= fecha_inicio),
    CONSTRAINT check_valor_contrato CHECK (valor_total > 0),
    CONSTRAINT check_valor_hora_contrato CHECK (valor_hora IS NULL OR valor_hora > 0),
    CONSTRAINT check_dias_calendario CHECK (dias_calendario IS NULL OR dias_calendario > 0),
    CONSTRAINT check_numero_informes CHECK (numero_informes_requeridos > 0)
);

-- **NUEVA** - Documentos del contrato (certificados, autorizaciones, etc.)
CREATE TABLE documento_contrato (
    id_documento_contrato           SERIAL PRIMARY KEY,
    id_contrato                     INTEGER NOT NULL,           -- **RELACION** - FK a contrato
    tipo_documento                  VARCHAR(100) NOT NULL,     -- Ej: 'Hoja de vida', 'Certificado EPS', 'RUT', etc.
    nombre_documento                VARCHAR(200) NOT NULL,
    url_archivo                     TEXT,
    estado_entrega                  BOOLEAN DEFAULT FALSE,
    fecha_entrega                   DATE,
    observaciones                   TEXT,
    activo                          BOOLEAN DEFAULT TRUE,
    
    FOREIGN KEY (id_contrato) REFERENCES contrato (id_contrato) ON DELETE CASCADE ON UPDATE CASCADE
);

-- **NUEVA** - Informes de contratos
CREATE TABLE informe_contrato (
    id_informe_contrato             SERIAL PRIMARY KEY,
    id_contrato                     INTEGER NOT NULL,           -- **RELACION** - FK a contrato
    numero_informe                  INTEGER NOT NULL,
    mes_reporte                     VARCHAR(20),
    fecha_inicio_reporte            DATE NOT NULL,
    fecha_fin_reporte               DATE NOT NULL,
    fecha_entrega                   DATE,
    valor_honorario                 NUMERIC(12,2),
    firma_contratista               BOOLEAN DEFAULT FALSE,
    firma_lider                     BOOLEAN DEFAULT FALSE,
    firma_interventor               BOOLEAN DEFAULT FALSE,
    aprobacion_lider                BOOLEAN DEFAULT FALSE,
    observaciones_lider             TEXT,
    aprobacion_gestion              BOOLEAN DEFAULT FALSE,
    observaciones_gestion           TEXT,
    url_documento_generado          TEXT,
    activo                          BOOLEAN DEFAULT TRUE,
    fecha_creacion                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion             TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_contrato) REFERENCES contrato (id_contrato) ON DELETE CASCADE ON UPDATE CASCADE,
    
    CONSTRAINT check_fechas_informe CHECK (fecha_fin_reporte >= fecha_inicio_reporte),
    CONSTRAINT check_valor_honorario CHECK (valor_honorario IS NULL OR valor_honorario >= 0),
    CONSTRAINT check_numero_informe_positivo CHECK (numero_informe > 0),
    UNIQUE(id_contrato, numero_informe) -- No puede haber informes duplicados para el mismo contrato
);

-- **NUEVA** - Gestión de oportunidades (modificada para integrar con proyectos)
CREATE TABLE oportunidad (
    id_oportunidad                  SERIAL PRIMARY KEY,
    nombre_oportunidad              VARCHAR(255) NOT NULL,
    fecha_analisis                  DATE NOT NULL,
    oferente                        VARCHAR(255),
    fuente_recurso                  VARCHAR(255),
    alcance_oportunidad             ALCANCE_PROYECTO_ENUM,
    tipo_ingreso                    VARCHAR(100),
    url_enlace                      TEXT,
    objeto_oportunidad              TEXT,
    monto_oportunidad               NUMERIC(15,2),
    moneda_oportunidad              VARCHAR(10) DEFAULT 'COP',
    requiere_contrapartida          BOOLEAN DEFAULT FALSE,
    valor_contrapartida             NUMERIC(15,2),
    fecha_limite_presentacion       DATE,
    estado_oportunidad              ESTADO_OPORTUNIDAD_ENUM NOT NULL DEFAULT 'Identificada',
    se_presento                     BOOLEAN DEFAULT FALSE,
    id_identificador                INTEGER,                    -- **RELACION** - FK a persona que identificó
    id_ag_o_pe_relacionado          INTEGER,                    -- **RELACION** - FK a asunto de gestión
    id_proyecto_resultante          INTEGER,                    -- **RELACION** - FK a proyecto (si resulta en proyecto)
    observaciones_oportunidad       TEXT,
    activo                          BOOLEAN DEFAULT TRUE,
    fecha_creacion                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion             TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_identificador) REFERENCES persona (id_persona) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (id_ag_o_pe_relacionado) REFERENCES ag_o_pe (id_ag_o_pe) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (id_proyecto_resultante) REFERENCES proyecto (id_proyecto) ON DELETE SET NULL ON UPDATE CASCADE,
    
    CONSTRAINT check_monto_oportunidad CHECK (monto_oportunidad IS NULL OR monto_oportunidad >= 0),
    CONSTRAINT check_valor_contrapartida_op CHECK (valor_contrapartida IS NULL OR valor_contrapartida >= 0)
);

-- **NUEVA** - Actas (relacionadas con proyectos y contratos)
CREATE TABLE acta (
    id_acta                         SERIAL PRIMARY KEY,
    numero_acta                     VARCHAR(100) NOT NULL UNIQUE,
    tipo_acta                       VARCHAR(100),               -- Ej: 'Inicio', 'Cierre', 'Seguimiento'
    id_proyecto                     INTEGER,                    -- **RELACION** - FK a proyecto
    id_contrato                     INTEGER,                    -- **RELACION** - FK a contrato
    responsable_acta                VARCHAR(255),
    estado_acta                     VARCHAR(100),
    fecha_inicio_acta               DATE,
    fecha_fin_acta                  DATE,
    valor_acta                      NUMERIC(15,2),
    aliado                          VARCHAR(255),
    url_documento_contrato          TEXT,
    url_documento_cierre            TEXT,
    observaciones_acta              TEXT,
    activo                          BOOLEAN DEFAULT TRUE,
    fecha_creacion                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion             TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_proyecto) REFERENCES proyecto (id_proyecto) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (id_contrato) REFERENCES contrato (id_contrato) ON DELETE SET NULL ON UPDATE CASCADE,
    
    CONSTRAINT check_fechas_acta CHECK (fecha_fin_acta IS NULL OR fecha_fin_acta >= fecha_inicio_acta),
    CONSTRAINT check_valor_acta CHECK (valor_acta IS NULL OR valor_acta >= 0)
);

-- **NUEVAS** - Componentes y Compras (según imagen)
CREATE TABLE componente (
    id_componente                   SERIAL PRIMARY KEY,
    id_proyecto                     INTEGER NOT NULL,           -- **RELACION** - FK a proyecto
    nombre_componente               VARCHAR(255) NOT NULL,
    tipo_componente                 TIPO_COMPONENTE_ENUM NOT NULL,
    descripcion_componente          TEXT,
    cantidad_requerida              INTEGER DEFAULT 1,
    valor_unitario                  NUMERIC(12,2),
    valor_total                     NUMERIC(15,2),
    observaciones_componente        TEXT,
    activo                          BOOLEAN DEFAULT TRUE,
    fecha_creacion                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion             TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_proyecto) REFERENCES proyecto (id_proyecto) ON DELETE CASCADE ON UPDATE CASCADE,
    
    CONSTRAINT check_cantidad_componente CHECK (cantidad_requerida > 0),
    CONSTRAINT check_valor_unitario_comp CHECK (valor_unitario IS NULL OR valor_unitario >= 0),
    CONSTRAINT check_valor_total_comp CHECK (valor_total IS NULL OR valor_total >= 0)
);

CREATE TABLE compra (
    id_compra                       SERIAL PRIMARY KEY,
    id_componente                   INTEGER,                    -- **RELACION** - FK a componente
    id_proveedor                    INTEGER,                    -- **RELACION** - FK a proveedor
    numero_orden                    VARCHAR(100),
    estado_compra                   ESTADO_COMPRA_ENUM NOT NULL DEFAULT 'Solicitada',
    fecha_solicitud                 DATE NOT NULL,
    fecha_aprobacion                DATE,
    fecha_entrega                   DATE,
    valor_compra                    NUMERIC(15,2) NOT NULL,
    observaciones_compra            TEXT,
    url_factura                     TEXT,
    activo                          BOOLEAN DEFAULT TRUE,
    fecha_creacion                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion             TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_componente) REFERENCES componente (id_componente) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (id_proveedor) REFERENCES proveedor (id_proveedor) ON DELETE SET NULL ON UPDATE CASCADE,
    
    CONSTRAINT check_valor_compra CHECK (valor_compra > 0),
    CONSTRAINT check_fechas_compra CHECK (fecha_aprobacion IS NULL OR fecha_aprobacion >= fecha_solicitud)
);

-- ==============================================================
-- **INVENTARIO SIMPLIFICADO (SOLO 2 TABLAS)**
-- ==============================================================

-- **SIMPLIFICADA** - Inventario principal
CREATE TABLE inventario (
    id_inventario                   SERIAL PRIMARY KEY,
    codigo_inventario               VARCHAR(100) NOT NULL UNIQUE,
    codigo_activo_fijo              VARCHAR(100),
    numero_inventario               VARCHAR(100),
    subnumero                       VARCHAR(50),
    descripcion_inventario          TEXT NOT NULL,
    marca                           VARCHAR(100),
    serial                          VARCHAR(100),
    cantidad                        INTEGER NOT NULL DEFAULT 1,
    ubicacion_udea                  VARCHAR(200),
    centro_costo                    VARCHAR(100),
    dependencia                     VARCHAR(200),
    fecha_registro                  DATE DEFAULT CURRENT_DATE,
    estado_inventario               ESTADO_INVENTARIO_ENUM NOT NULL DEFAULT 'Disponible',
    id_responsable_actual           INTEGER,                    -- **RELACION** - FK a persona responsable
    activo                          BOOLEAN DEFAULT TRUE,
    fecha_creacion                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion             TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_responsable_actual) REFERENCES persona (id_persona) ON DELETE SET NULL ON UPDATE CASCADE,
    
    CONSTRAINT check_cantidad_inventario CHECK (cantidad >= 0)
);

-- **UNIFICADA** - Seguimiento que incluye TODOS los movimientos
CREATE TABLE seguimiento_inventario (
    id_seguimiento_inventario       SERIAL PRIMARY KEY,
    id_inventario                   INTEGER NOT NULL,           -- **RELACION** - FK a inventario
    tipo_seguimiento                TIPO_SEGUIMIENTO_INVENTARIO_ENUM NOT NULL,
    nombre_item                     VARCHAR(255),
    
    -- Fechas
    fecha_solicitud                 DATE NOT NULL,
    fecha_movimiento                DATE,
    
    -- Personas involucradas
    id_persona_origen               INTEGER,                    -- **RELACION** - FK a persona origen
    id_persona_destino              INTEGER,                    -- **RELACION** - FK a persona destino
    id_usuario_registro             INTEGER,                    -- **RELACION** - FK a persona que registra
    
    -- Ubicaciones
    ubicacion_origen                VARCHAR(200),
    ubicacion_destino               VARCHAR(200),
    centro_costo_origen             VARCHAR(100),
    centro_costo_destino            VARCHAR(100),
    dependencia_origen              VARCHAR(200),
    dependencia_destino             VARCHAR(200),
    
    -- Estados y observaciones
    estado_entrega                  VARCHAR(100),
    estado_devolucion               VARCHAR(100),
    observaciones_entrega           TEXT,
    observaciones_devolucion        TEXT,
    incidencias                     TEXT,
    responsable_seguimiento         VARCHAR(255),
    
    -- Documentos y evidencias
    url_formato_excel               TEXT,
    url_enlace_documento            TEXT,
    url_evidencia_correo            TEXT,
    url_evidencia_entrega           TEXT,
    url_evidencia_devolucion        TEXT,
    
    -- Control
    autorizacion                    BOOLEAN DEFAULT FALSE,
    activo                          BOOLEAN DEFAULT TRUE,
    fecha_creacion                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion             TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_inventario) REFERENCES inventario (id_inventario) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_persona_origen) REFERENCES persona (id_persona) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (id_persona_destino) REFERENCES persona (id_persona) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (id_usuario_registro) REFERENCES persona (id_persona) ON DELETE SET NULL ON UPDATE CASCADE,
    
    CONSTRAINT check_fechas_seguimiento CHECK (fecha_movimiento IS NULL OR fecha_movimiento >= fecha_solicitud)
);

-- ==============================================================
-- **ACTIVIDADES Y PRODUCTOS INTEGRADOS CON CONTRATOS**
-- ==============================================================

CREATE TABLE etapa_asunto_trabajo_proyecto_actividad (
    id_etapa_asunto_trabajo_proyecto_actividad               SERIAL PRIMARY KEY,
    nombre_etapa_asunto_trabajo_proyecto_actividad           VARCHAR(255) NOT NULL,
    descripcion_etapa_asunto_trabajo_proyecto_actividad      TEXT,
    orden_etapa                                              INT,
    id_asunto_de_trabajo_tipo_emprendimiento                    INTEGER NOT NULL,
    id_proyecto                                              INTEGER NOT NULL,

    FOREIGN KEY (id_asunto_de_trabajo_tipo_emprendimiento) REFERENCES asunto_de_trabajo_tipo_emprendimiento (id_asunto_de_trabajo_tipo_emprendimiento) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_proyecto) REFERENCES proyecto (id_proyecto) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE dimension_emprendimiento (
    id_dimension_emprendimiento           SERIAL PRIMARY KEY,
    nombre_dimension_emprendimiento       VARCHAR(255) NOT NULL UNIQUE,
    descripcion_dimension_emprendimiento  TEXT,
    activo                                BOOLEAN DEFAULT TRUE
);

-- **INTEGRADA** - Actividad momento ahora incluye campos de contrato
CREATE TABLE actividad_momento (
    id_actividad_momento                        SERIAL PRIMARY KEY,
    id_etapa_asunto_trabajo_proyecto_actividad  INT,
    -- **NUEVA INTEGRACION** - Campos de contrato
    id_contrato                                 INTEGER,                    -- **RELACION** - FK a contrato (OPCIONAL)
    orden_actividad_contrato                    INTEGER,                    -- Orden si es actividad de contrato
    
    -- Campos originales de actividad
    fecha_actividad                             DATE NOT NULL,
    nombre_actividad                            VARCHAR(255) NOT NULL,
    descripcion_actividad                       TEXT,
    hora_inicio_actividad                       TIME,
    hora_finalizacion_actividad                 TIME,
    tematica_actividad                          VARCHAR(255),
    modalidad_actividad                         MODALIDAD_ACTIVIDAD_ENUM DEFAULT 'Presencial',
    tipo_actividad                              TIPO_ACTIVIDAD_ENUM DEFAULT 'Actividad',
    materiales_actividad                        TEXT,
    alimentacion_actividad                      BOOLEAN DEFAULT FALSE,
    fase_actividad                              FASE_ACTIVIDAD_ENUM NOT NULL,
    semestre_ejecucion_fase                     VARCHAR(100),
    observaciones_actividad                     TEXT,
    activo                                      BOOLEAN DEFAULT TRUE,
    fecha_creacion                              TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion                         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_etapa_asunto_trabajo_proyecto_actividad) REFERENCES etapa_asunto_trabajo_proyecto_actividad (id_etapa_asunto_trabajo_proyecto_actividad) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_contrato) REFERENCES contrato (id_contrato) ON DELETE CASCADE ON UPDATE CASCADE,
    
    CONSTRAINT check_horas_actividad CHECK (hora_finalizacion_actividad IS NULL OR hora_finalizacion_actividad >= hora_inicio_actividad)
);

-- **INTEGRADA** - Subactividad producto ahora incluye campos de producto de contrato
CREATE TABLE subactividad_producto (
    id_subactividad_producto              SERIAL PRIMARY KEY,
    id_actividad_momento                  INTEGER NOT NULL,
    id_dimension_emprendimiento           INT,
    -- **NUEVA INTEGRACION** - Campos de producto de contrato
    id_contrato                           INTEGER,                    -- **RELACION** - FK a contrato (OPCIONAL)
    url_archivo_producto                  TEXT,                       -- URL archivo del producto
    url_enlace_producto                   TEXT,                       -- URL enlace del producto
    es_producto_contrato                  BOOLEAN DEFAULT FALSE,      -- Indica si es producto de contrato
    
    -- Campos originales
    nombre_subactividad_producto          VARCHAR(255) NOT NULL,
    tipo_subactividad_producto            VARCHAR(100),
    fecha_subactividad_producto           DATE NOT NULL,
    descripcion_subactividad_producto     TEXT,
    hora_inicio_subactividad              TIME,
    hora_finalizacion_subactividad        TIME,
    tematica_subactividad                 VARCHAR(255),
    modalidad_subactividad                MODALIDAD_ACTIVIDAD_ENUM DEFAULT 'Presencial',
    materiales_subactividad               TEXT,
    alimentacion_subactividad             BOOLEAN DEFAULT FALSE,
    facilitador_subactividad              VARCHAR(255),
    observaciones_subactividad            TEXT,
    activo                                BOOLEAN DEFAULT TRUE,
    fecha_creacion                        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion                   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_actividad_momento) REFERENCES actividad_momento (id_actividad_momento) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_dimension_emprendimiento) REFERENCES dimension_emprendimiento (id_dimension_emprendimiento) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (id_contrato) REFERENCES contrato (id_contrato) ON DELETE CASCADE ON UPDATE CASCADE,
    
    CONSTRAINT check_horas_subactividad CHECK (hora_finalizacion_subactividad IS NULL OR hora_finalizacion_subactividad >= hora_inicio_subactividad)
);

-- **NUEVA** - Tareas de contratos (vinculadas a productos y informes)
CREATE TABLE tarea_contrato (
    id_tarea_contrato               SERIAL PRIMARY KEY,
    id_subactividad_producto        INTEGER NOT NULL,           -- **RELACION** - FK a subactividad/producto
    id_informe_contrato             INTEGER,                    -- **RELACION** - FK a informe (opcional)
    nombre_tarea                    VARCHAR(255) NOT NULL,
    descripcion_tarea               TEXT,
    url_tarea                       TEXT,
    relacion_anexos                 TEXT,
    aprobacion_anexos               BOOLEAN DEFAULT FALSE,
    medios_verificacion             TEXT,
    aprobacion_url                  BOOLEAN DEFAULT FALSE,
    activo                          BOOLEAN DEFAULT TRUE,
    fecha_creacion                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion             TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_subactividad_producto) REFERENCES subactividad_producto (id_subactividad_producto) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_informe_contrato) REFERENCES informe_contrato (id_informe_contrato) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE relacion_actividad_persona (
    id_relacion_actividad_persona         SERIAL PRIMARY KEY,
    id_persona                            INTEGER NOT NULL,
    id_subactividad_producto              INTEGER NOT NULL,
    asistio                               BOOLEAN DEFAULT TRUE,
    calificacion                          INT,
    comentarios                           TEXT,
    rol                                   VARCHAR(255),
    
    FOREIGN KEY (id_persona) REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_subactividad_producto) REFERENCES subactividad_producto (id_subactividad_producto) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT check_calificacion CHECK (calificacion IS NULL OR (calificacion >= 1 AND calificacion <= 5)),
    UNIQUE(id_persona, id_subactividad_producto)
);

-- ==============================================================
-- TABLA DE ASIGNACIÓN DE ROLES (ACTUALIZADA)
-- ==============================================================

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
    -- **REFERENCIAS ACTUALIZADAS PARA TALENTO HUMANO**
    id_contrato                                         INTEGER,
    id_proveedor                                        INTEGER,
    id_inventario                                       INTEGER,
    id_componente                                       INTEGER,
    id_compra                                           INTEGER,
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
        + (CASE WHEN id_contrato                                                IS NOT NULL THEN 1 ELSE 0 END)
        + (CASE WHEN id_proveedor                                               IS NOT NULL THEN 1 ELSE 0 END)
        + (CASE WHEN id_inventario                                              IS NOT NULL THEN 1 ELSE 0 END)
        + (CASE WHEN id_componente                                              IS NOT NULL THEN 1 ELSE 0 END)
        + (CASE WHEN id_compra                                                  IS NOT NULL THEN 1 ELSE 0 END)
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
           (entidad = 'PROFESION'                AND id_profesion                               IS NOT NULL) OR
           (entidad = 'CONTRATO'                 AND id_contrato                                IS NOT NULL) OR
           (entidad = 'PROVEEDOR'                AND id_proveedor                               IS NOT NULL) OR
           (entidad = 'INVENTARIO'               AND id_inventario                              IS NOT NULL) OR
           (entidad = 'COMPONENTE'               AND id_componente                              IS NOT NULL) OR
           (entidad = 'COMPRA'                   AND id_compra                                  IS NOT NULL)
    ),

    -- Foreign Keys existentes
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
    FOREIGN KEY (id_profesion)                                      REFERENCES profesion                                        (id_profesion)                                      ON DELETE CASCADE ON UPDATE CASCADE,
    -- **Foreign Keys para Talento Humano**
    FOREIGN KEY (id_contrato)                                       REFERENCES contrato                                         (id_contrato)                                       ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_proveedor)                                      REFERENCES proveedor                                        (id_proveedor)                                      ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_inventario)                                     REFERENCES inventario                                       (id_inventario)                                     ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_componente)                                     REFERENCES componente                                       (id_componente)                                     ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_compra)                                         REFERENCES compra                                           (id_compra)                                         ON DELETE CASCADE ON UPDATE CASCADE
);

-- ==============================================================
-- SISTEMA DE LOGS Y AUDITORÍA (SIN CAMBIOS)
-- ==============================================================

CREATE TABLE log_cambios (
    id_log                  SERIAL PRIMARY KEY,
    nombre_tabla            VARCHAR(100) NOT NULL,
    tipo_operacion          TIPO_OPERACION_LOG NOT NULL,
    id_registro_afectado    INTEGER NOT NULL,
    datos_anteriores        JSONB,
    datos_nuevos            JSONB,
    usuario_accion          VARCHAR(100),
    ip_origen               INET,
    fecha_cambio            TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_persona              INT,
    
    FOREIGN KEY (id_persona) REFERENCES persona (id_persona) ON DELETE SET NULL ON UPDATE CASCADE
);

-- ==============================================================
-- ÍNDICES PARA OPTIMIZACIÓN 
-- ==============================================================

-- Índices existentes (sin cambios)
CREATE INDEX idx_departamento_pais ON departamento(id_pais);
CREATE INDEX idx_region_departamento ON region(id_departamento);
CREATE INDEX idx_ciudad_region ON ciudad(id_region);
CREATE INDEX idx_comuna_ciudad ON comuna(id_ciudad);
CREATE INDEX idx_barrio_comuna ON barrio(id_comuna);
CREATE INDEX idx_direccion_barrio ON direccion(id_barrio);

CREATE INDEX idx_sede_empresa ON sede_campus(id_empresa);
CREATE INDEX idx_unidad_admin_sede ON unidad_administrativa(id_sede_campus);
CREATE INDEX idx_unidad_acad_sede ON unidad_academica(id_sede_campus);
CREATE INDEX idx_programa_unidad ON programa_academico(id_unidad_academica);
CREATE INDEX idx_grupo_unidad ON grupo_investigacion(id_unidad_academica);

CREATE INDEX idx_actividad_fecha ON actividad_momento(fecha_actividad);
CREATE INDEX idx_actividad_tipo ON actividad_momento(tipo_actividad);
CREATE INDEX idx_subactividad_fecha ON subactividad_producto(fecha_subactividad_producto);

CREATE INDEX idx_emprendimiento_empresa ON emprendimiento(id_empresa);
CREATE INDEX idx_emprendimiento_estado ON emprendimiento(estado_desarrollo_emprendimiento);

CREATE INDEX idx_proyecto_programa ON proyecto(id_programa);
CREATE INDEX idx_proyecto_estado ON proyecto(estado_proyecto);
CREATE INDEX idx_proyecto_fechas ON proyecto(fecha_inicio_proyecto, fecha_finalizacion_proyecto);
CREATE INDEX idx_programa_estado ON programa(estado_programa);

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

-- **ÍNDICES PARA TALENTO HUMANO**
CREATE INDEX idx_proveedor_persona ON proveedor(id_persona);
CREATE INDEX idx_proveedor_empresa ON proveedor(id_empresa);
CREATE INDEX idx_proveedor_tipo ON proveedor(tipo_proveedor);

CREATE INDEX idx_contrato_proyecto ON contrato(id_proyecto);
CREATE INDEX idx_contrato_proveedor ON contrato(id_proveedor);
CREATE INDEX idx_contrato_estado ON contrato(estado_contrato);
CREATE INDEX idx_contrato_fechas ON contrato(fecha_inicio, fecha_fin);
CREATE INDEX idx_contrato_lider ON contrato(id_lider_contrato);

CREATE INDEX idx_documento_contrato ON documento_contrato(id_contrato);
CREATE INDEX idx_informe_contrato ON informe_contrato(id_contrato);

-- **ÍNDICES DE INTEGRACIÓN**
CREATE INDEX idx_actividad_contrato ON actividad_momento(id_contrato);
CREATE INDEX idx_subactividad_contrato ON subactividad_producto(id_contrato);
CREATE INDEX idx_tarea_subactividad ON tarea_contrato(id_subactividad_producto);
CREATE INDEX idx_tarea_informe ON tarea_contrato(id_informe_contrato);

CREATE INDEX idx_oportunidad_estado ON oportunidad(estado_oportunidad);
CREATE INDEX idx_oportunidad_fecha_limite ON oportunidad(fecha_limite_presentacion);
CREATE INDEX idx_oportunidad_identificador ON oportunidad(id_identificador);
CREATE INDEX idx_oportunidad_proyecto ON oportunidad(id_proyecto_resultante);

CREATE INDEX idx_acta_proyecto ON acta(id_proyecto);
CREATE INDEX idx_acta_contrato ON acta(id_contrato);

CREATE INDEX idx_componente_proyecto ON componente(id_proyecto);
CREATE INDEX idx_compra_componente ON compra(id_componente);
CREATE INDEX idx_compra_proveedor ON compra(id_proveedor);

-- **ÍNDICES INVENTARIO SIMPLIFICADO**
CREATE INDEX idx_inventario_responsable ON inventario(id_responsable_actual);
CREATE INDEX idx_inventario_estado ON inventario(estado_inventario);
CREATE INDEX idx_seguimiento_inventario_item ON seguimiento_inventario(id_inventario);
CREATE INDEX idx_seguimiento_tipo ON seguimiento_inventario(tipo_seguimiento);
CREATE INDEX idx_seguimiento_fechas ON seguimiento_inventario(fecha_solicitud, fecha_movimiento);

-- ==============================================================
-- PERMISOS
-- ==============================================================

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO postgres;

COMMIT;

-- ==============================================================
-- FIN DEL MODELO INTEGRADO DE BASE DE DATOS
-- ==============================================================

DO $$
DECLARE
    v_schema                text := current_schema();
    v_tablas                int;
    v_enums                 int;
    v_indices               int;
    v_constraints           int;
    v_fks                   int;
    v_funcs                 int;
    v_views                 int;
    v_tablas_integradas     int := 2;   -- Tablas que se integraron
    v_tablas_eliminadas     int := 3;   -- Tablas que se eliminaron por integración
    v_tablas_nuevas         int := 4;   -- Componente, compra + otras
BEGIN
    -- Conteos
    SELECT count(*) INTO v_tablas FROM information_schema.tables WHERE table_schema = v_schema AND table_type = 'BASE TABLE';
    SELECT count(*) INTO v_enums FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = v_schema AND t.typtype = 'e';
    SELECT count(*) INTO v_indices FROM pg_indexes WHERE schemaname = v_schema;
    SELECT count(*) INTO v_constraints FROM information_schema.table_constraints WHERE constraint_schema = v_schema;
    SELECT count(*) INTO v_fks FROM information_schema.table_constraints WHERE constraint_schema = v_schema AND constraint_type = 'FOREIGN KEY';
    SELECT count(*) INTO v_funcs FROM information_schema.routines WHERE routine_schema = v_schema AND routine_type IN ('FUNCTION','PROCEDURE');
    SELECT count(*) INTO v_views FROM information_schema.views WHERE table_schema = v_schema;

    -- Mensaje final
    RAISE NOTICE E'\n';
    RAISE NOTICE '╔═══════════════════════════════════════════════════════════════╗';
    RAISE NOTICE '║   BD EMPRENDIMIENTO + TALENTO HUMANO INTEGRADA (Schema: %)     ║', v_schema;
    RAISE NOTICE '╠═══════════════════════════════════════════════════════════════╣';
    RAISE NOTICE '║  ✅ Tablas TOTALES: %                                         ║', v_tablas;
    RAISE NOTICE '║     └─ Tablas INTEGRADAS: %                                   ║', v_tablas_integradas;
    RAISE NOTICE '║     └─ Tablas NUEVAS: %                                       ║', v_tablas_nuevas;
    RAISE NOTICE '║     └─ Tablas ELIMINADAS: %                                   ║', v_tablas_eliminadas;
    RAISE NOTICE '║  ✅ Tipos ENUM: %                                             ║', v_enums;
    RAISE NOTICE '║  ✅ Índices: %                                                ║', v_indices;
    RAISE NOTICE '║  ✅ Constraints: %                                            ║', v_constraints;
    RAISE NOTICE '║     └─ Foreign Keys: %                                        ║', v_fks;
    RAISE NOTICE '╠═══════════════════════════════════════════════════════════════╣';
    RAISE NOTICE '║                     🔄 INTEGRACIONES REALIZADAS                ║';
    RAISE NOTICE '║  ✅ actividad_contrato → actividad_momento (INTEGRADA)       ║';
    RAISE NOTICE '║  ✅ producto_contrato → subactividad_producto (INTEGRADA)    ║';
    RAISE NOTICE '║  ✅ movimiento_inventario → seguimiento_inventario (UNIF.)   ║';
    RAISE NOTICE '║  ✅ Inventario simplificado a 2 tablas                       ║';
    RAISE NOTICE '║  ➕ Tabla componente añadida (según imagen)                  ║';
    RAISE NOTICE '║  ➕ Tabla compra añadida (según imagen)                      ║';
    RAISE NOTICE '║  🔗 Relaciones cruzadas entre todos los módulos              ║';
    RAISE NOTICE '╚═══════════════════════════════════════════════════════════════╝';
END $$;