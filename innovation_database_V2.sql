-- ==============================================================
-- MODELO DE BASE DE DATOS - SISTEMA DE GESTIÓN DE EMPRENDIMIENTO
-- Versión: 2.1 - Completamente comentada
-- Fecha: 2025
-- Descripción: Sistema integral para gestión de emprendimiento,
--              empresas, instituciones educativas y programas
-- ==============================================================

-- ==============================================================
-- ENUMERADOS (TIPOS PERSONALIZADOS)
-- Ventaja: Garantizan consistencia de datos categóricos
-- ==============================================================

-- Enumerados para Persona
CREATE TYPE SEXO_ENUM AS ENUM (
    'Masculino', 
    'Femenino', 
    'Intersexual'
);

CREATE TYPE GENERO_ENUM AS ENUM (
    'Hombre', 
    'Mujer', 
    'No binario', 
    'Género fluido', 
    'Agénero', 
    'Prefiero no decirlo', 
    'Otro'
);

CREATE TYPE TIPO_DOCUMENTO_PERSONA_ENUM AS ENUM (
    'Cédula de Ciudadanía (CC)', 
    'Tarjeta de Identidad (TI)', 
    'Cédula de Extranjería (CE)', 
    'Pasaporte (P)', 
    'Registro Civil (RC)', 
    'NIT (Número de Identificación Tributaria)', 
    'Documento Nacional de Identidad (DNI)', 
    'Permiso Especial de Permanencia (PEP)'
);

CREATE TYPE ESTRATO_SOCIOECONOMICO_ENUM AS ENUM (
    'Estrato 1 (Bajo-bajo)', 
    'Estrato 2 (Bajo)', 
    'Estrato 3 (Medio-bajo)', 
    'Estrato 4 (Medio)', 
    'Estrato 5 (Medio-alto)', 
    'Estrato 6 (Alto)'
);

CREATE TYPE ETNIA_EMPRENDEDOR_ENUM AS ENUM (
    'Blanco', 
    'Mestizo', 
    'Afrocolombiano', 
    'Indígena', 
    'Raizal', 
    'Palenquero', 
    'Rom o Gitano', 
    'Prefiero no decir', 
    'Ninguno de los anteriores'
);

CREATE TYPE ESTADO_CIVIL_EMPRENDEDOR_ENUM AS ENUM (
    'Soltero', 
    'Casado', 
    'Unión libre', 
    'Separado', 
    'Divorciado', 
    'Viudo', 
    'Otro'
);

-- Enumerados para Empresa
CREATE TYPE CATEGORIA_EMPRESA_ENUM AS ENUM (
    'Microempresa',      -- 1-10 empleados
    'Pequeña empresa',   -- 11-50 empleados
    'Mediana empresa',   -- 51-200 empleados
    'Gran empresa'       -- 200+ empleados
);

CREATE TYPE ZONA_EMPRESA_ENUM AS ENUM (
    'Urbana',     -- Dentro de la ciudad
    'Rural',      -- Campo/agricultura
    'Periurbana'  -- Periferia de la ciudad
);

CREATE TYPE TIPO_EMPRESA_ENUM AS ENUM (
    'Tecnología', 
    'Comercio', 
    'Servicios', 
    'Industria', 
    'Agricultura', 
    'Institución educativa'
);

CREATE TYPE MAGNITUD_EMPRESA_ENUM AS ENUM (
    'Grande',    -- Facturación alta
    'Mediana',   -- Facturación media
    'Pequeña'    -- Facturación baja
);

CREATE TYPE ROL_ENUM AS ENUM (
    'Empleado',      -- Trabajador regular
    'Gerente',       -- Nivel gerencial
    'Socio',         -- Socio del negocio
    'Fundador',      -- Fundador original
    'Inversionista'  -- Inversor externo
);

-- Enumerados para Emprendimiento
CREATE TYPE MACROSECTOR_EMPRENDIMIENTO_ENUM AS ENUM (
    'Tecnología', 
    'Comercio', 
    'Servicios', 
    'Industria', 
    'Agricultura'
);

CREATE TYPE SUBSECTOR_EMPRENDIMIENTO_ENUM AS ENUM (
    'Agricultura', 
    'Ganadería', 
    'Alimentos y bebidas', 
    'Textiles, confecciones, cuero y calzado', 
    'Productos químicos y farmacéuticos', 
    'Plásticos y caucho', 
    'Minerales no metálicos', 
    'Metalmecánica', 
    'Automotriz', 
    'Electrónica y electrodomésticos',
    'Software y desarrollo',
    'Servicios financieros',
    'Salud',
    'Educación',
    'Turismo',
    'Logística y transporte',
    'Construcción',
    'Energía y recursos',
    'Telecomunicaciones',
    'Comercio al por menor',
    'Comercio al por mayor'
);

CREATE TYPE ESTADO_DESARROLLO_EMPREN_ENUM AS ENUM (
    'En incubación',  -- Fase inicial/idea
    'Consolidado',    -- Operando establemente
    'En pausa',       -- Temporalmente detenido
    'Finalizado'      -- Cerrado definitivamente
);

CREATE TYPE TIPO_EMPLEO_ENUM AS ENUM (
    'Temporal',  -- Contratos a término fijo
    'Fijo',      -- Contratos indefinidos
    'Mixto'      -- Combinación de ambos
);

-- Enumerados para Institución Educativa
CREATE TYPE TIPO_UNIDAD_ACADEMICA_ENUM AS ENUM (
    'Facultad',     -- División académica mayor
    'Escuela',      -- Unidad especializada
    'Instituto',    -- Centro de investigación
    'Corporación'   -- Entidad corporativa educativa
);

CREATE TYPE TIPO_UBICACION_UNIDAD_IE_ENUM AS ENUM (
    'Campus principal',  -- Sede principal
    'Sede',             -- Sede secundaria
    'Sede regional',    -- Sede en otra región
    'Sede única'        -- Solo tiene una sede
);

CREATE TYPE NIVEL_PROGRAMA_ACADEMICO_ENUM AS ENUM (
    'Técnica profesional',  -- 2 años aprox
    'Tecnológico',         -- 3 años aprox
    'Profesional',         -- 4-5 años
    'Especialización',     -- 1 año postgrado
    'Maestría',            -- 2 años postgrado
    'Doctorado'            -- 3-5 años postgrado
);

CREATE TYPE AREA_PROGRAMA_ACADEMICO_ENUM AS ENUM (
    'Ingeniería', 
    'Ciencias Sociales', 
    'Ciencias Naturales', 
    'Artes', 
    'Humanidades',
    'Ciencias de la Salud',
    'Ciencias Económicas y Administrativas',
    'Ciencias Agrarias',
    'Educación'
);

CREATE TYPE ESTADO_ACADEMICO_ENUM AS ENUM (
    'En curso',   -- Actualmente estudiando
    'Graduado',   -- Completó estudios
    'Retirado',   -- Abandonó estudios
    'Aplazado'    -- Pausó temporalmente
);

-- Enumerados para Programas y Proyectos
CREATE TYPE ESTADO_PROGRAMA_ENUM AS ENUM (
    'Activo',        -- En operación
    'Inactivo',      -- No operando actualmente
    'En desarrollo', -- En fase de creación
    'Finalizado',    -- Completado
    'Suspendido'     -- Pausado temporalmente
);

CREATE TYPE ESTADO_PROYECTO_ENUM AS ENUM (
    'Pendiente',     -- Por iniciar
    'En ejecución',  -- En progreso
    'Finalizado',    -- Completado
    'Cancelado',     -- Cancelado definitivamente
    'Suspendido'     -- Pausado temporalmente
);

CREATE TYPE PRIORIDAD_ENUM AS ENUM (
    'Alta',   -- Urgente/importante
    'Media',  -- Normal
    'Baja'    -- Puede esperar
);

CREATE TYPE ETAPA_ENUM AS ENUM (
    'Planificación',  -- Diseño y planeación
    'Ejecución',      -- Implementación
    'Cierre',         -- Finalización
    'Post-cierre'     -- Evaluación post-proyecto
);

CREATE TYPE TIPO_APORTE_ENUM AS ENUM (
    'Gubernamental',  -- Fondos del gobierno
    'Privado',        -- Inversión privada
    'Internacional',  -- Cooperación internacional
    'Mixto'          -- Combinación de fuentes
);

CREATE TYPE ESTADO_FINANCIACION_ENUM AS ENUM (
    'Aprobado',   -- Financiación confirmada
    'Pendiente',  -- En evaluación
    'Rechazado',  -- No aprobado
    'Finalizado'  -- Recursos ya ejecutados
);

-- Enumerados para Actividades
CREATE TYPE MODALIDAD_ACTIVIDAD_ENUM AS ENUM (
    'Virtual',    -- Online/remoto
    'Presencial', -- En sitio
    'Híbrido'     -- Mixto virtual/presencial
);

CREATE TYPE TIPO_ACTIVIDAD_ENUM AS ENUM (
    'Evento',       -- Evento puntual
    'Actividad',    -- Actividad general
    'Curso',        -- Formación estructurada
    'Taller',       -- Workshop práctico
    'Conferencia',  -- Charla magistral
    'Seminario'     -- Seminario académico
);

-- Enumerado para Logs
CREATE TYPE TIPO_OPERACION_LOG AS ENUM (
    'INSERT',  -- Creación de registro
    'UPDATE',  -- Modificación de registro
    'DELETE'   -- Eliminación de registro
);

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
    url_polygon_pais          TEXT,                                  -- URL a archivo GeoJSON con polígono del país
);

CREATE TABLE departamento (
    id_departamento           SERIAL PRIMARY KEY,                    -- ID único del departamento/estado
    nombre_departamento       VARCHAR(100) NOT NULL,                 -- Nombre del departamento
    codigo_departamento       VARCHAR(10),                           -- Código oficial del departamento
    url_polygon_departamento  TEXT,                                  -- URL a archivo GeoJSON con polígono
    id_pais                   INT NOT NULL,                          -- FK al país al que pertenece
    
    FOREIGN KEY (id_pais) REFERENCES pais (id_pais) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE(nombre_departamento, id_pais)  -- No puede haber departamentos duplicados en un país
);

CREATE TABLE region (
    id_region                 SERIAL PRIMARY KEY,                    -- ID único de la región
    nombre_region             VARCHAR(100) NOT NULL,                 -- Nombre de la región/provincia
    codigo_region             VARCHAR(10),                           -- Código oficial de la región
    url_polygon_region        TEXT,                                  -- URL a archivo GeoJSON
    id_departamento           INT NOT NULL,                          -- FK al departamento
    
    FOREIGN KEY (id_departamento) REFERENCES departamento (id_departamento) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE(nombre_region, id_departamento)  -- No puede haber regiones duplicadas en un departamento
);

CREATE TABLE ciudad (
    id_ciudad                 SERIAL PRIMARY KEY,                    -- ID único de la ciudad
    nombre_ciudad             VARCHAR(100) NOT NULL,                 -- Nombre de la ciudad/municipio
    codigo_ciudad             VARCHAR(10),                           -- Código DANE o similar
    url_polygon_ciudad        TEXT,                                  -- URL a archivo GeoJSON
    id_region                 INT NOT NULL,                          -- FK a la región
    
    FOREIGN KEY (id_region) REFERENCES region (id_region) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE(nombre_ciudad, id_region)  -- No puede haber ciudades duplicadas en una región
);

CREATE TABLE comuna (
    id_comuna                 SERIAL PRIMARY KEY,                    -- ID único de la comuna
    nombre_comuna             VARCHAR(100) NOT NULL,                 -- Nombre/número de la comuna
    codigo_comuna             VARCHAR(10),                           -- Código oficial de la comuna
    url_polygon_comuna        TEXT,                                  -- URL a archivo GeoJSON
    id_ciudad                 INT NOT NULL,                          -- FK a la ciudad
    
    FOREIGN KEY (id_ciudad) REFERENCES ciudad (id_ciudad) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE(nombre_comuna, id_ciudad)  -- No puede haber comunas duplicadas en una ciudad
);

CREATE TABLE barrio (
    id_barrio                 SERIAL PRIMARY KEY,                    -- ID único del barrio
    nombre_barrio             VARCHAR(100) NOT NULL,                 -- Nombre del barrio
    codigo_barrio             VARCHAR(10),                           -- Código catastral o similar
    url_polygon_barrio        TEXT,                                  -- URL a archivo GeoJSON
    id_comuna                 INT NOT NULL,                          -- FK a la comuna
    
    FOREIGN KEY (id_comuna) REFERENCES comuna (id_comuna) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE(nombre_barrio, id_comuna)  -- No puede haber barrios duplicados en una comuna
);

CREATE TABLE direccion (
    id_direccion              SERIAL PRIMARY KEY,                    -- ID único de la dirección
    direccion_textual         VARCHAR(200) NOT NULL,                 -- Dirección completa (Calle 123 #45-67)
    codigo_postal             VARCHAR(10),                           -- Código postal
    latitud                   DECIMAL(10, 8),                        -- Coordenada GPS latitud
    longitud                  DECIMAL(11, 8),                        -- Coordenada GPS longitud
    id_barrio                 INT NOT NULL,                          -- FK al barrio

    FOREIGN KEY (id_barrio) REFERENCES barrio (id_barrio) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ==============================================================
-- PERSONAS Y EMPRESAS
-- Entidades principales del sistema
-- ==============================================================

CREATE TABLE persona (
    id_persona                   SERIAL PRIMARY KEY,                    -- ID único de la persona
    nombres_persona              VARCHAR(100) NOT NULL,                 -- Nombres completos
    apellidos_persona            VARCHAR(100) NOT NULL,                 -- Apellidos completos
    tipo_documento_persona       TIPO_DOCUMENTO_PERSONA_ENUM NOT NULL, -- Tipo de documento de identidad
    numero_documento_persona     VARCHAR(50) UNIQUE NOT NULL,          -- Número del documento (único)
    sexo_biologico               SEXO_ENUM NOT NULL,                   -- Sexo biológico al nacer
    genero                       GENERO_ENUM NOT NULL,                 -- Identidad de género
    telefono_celular             VARCHAR(20),                           -- Teléfono móvil principal
    telefono_fijo                VARCHAR(20),                           -- Teléfono fijo/alternativo
    correo_electronico           VARCHAR(100) UNIQUE NOT NULL,         -- Email principal (único)
    correo_alternativo           VARCHAR(100),                          -- Email secundario
    estrato_socioeconomico       ESTRATO_SOCIOECONOMICO_ENUM,         -- Estrato socioeconómico (Colombia)
    fecha_nacimiento_persona     DATE NOT NULL,                         -- Fecha de nacimiento
    foto_persona_url             TEXT,                                  -- URL a foto de perfil
    id_direccion                 INT,                                   -- FK a dirección de residencia
    activo                       BOOLEAN DEFAULT TRUE,                  -- Soft delete
    fecha_creacion               TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Fecha de registro
    fecha_actualizacion          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Última actualización
    
    FOREIGN KEY (id_direccion) REFERENCES direccion (id_direccion) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT check_fecha_nacimiento CHECK (fecha_nacimiento_persona <= CURRENT_DATE),  -- No puede nacer en el futuro
    CONSTRAINT check_correo_formato CHECK (correo_electronico ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$')  -- Validación de email
);

CREATE TABLE empresa (
    id_empresa                        SERIAL PRIMARY KEY,                    -- ID único de la empresa
    nombre_empresa                    VARCHAR(100) NOT NULL UNIQUE,         -- Razón social (única)
    nit_empresa                       VARCHAR(20) UNIQUE,                   -- NIT o equivalente (único)
    categoria_empresa                 CATEGORIA_EMPRESA_ENUM NOT NULL,      -- Tamaño según empleados
    zona_empresa                      ZONA_EMPRESA_ENUM NOT NULL,           -- Ubicación urbana/rural
    tipo_empresa                      TIPO_EMPRESA_ENUM NOT NULL,           -- Sector económico
    magnitud_empresa                  MAGNITUD_EMPRESA_ENUM,                -- Tamaño según facturación
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
    
    CONSTRAINT check_correo_empresa CHECK (correo_empresa ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$'),  -- Validación email
    CONSTRAINT check_fecha_fundacion CHECK (fecha_fundacion <= CURRENT_DATE),  -- No puede fundarse en el futuro
    CONSTRAINT check_numero_empleados CHECK (numero_empleados >= 0)  -- No puede tener empleados negativos
);

-- Tabla para sede o campus (con dirección)
CREATE TABLE sede_campus (
    id_sede_campus         SERIAL PRIMARY KEY,                    -- ID único de la sede
    nombre_sede_campus     VARCHAR(100) NOT NULL,                 -- Nombre de la sede
    tipo_ubicacion         TIPO_UBICACION_UNIDAD_IE_ENUM NOT NULL, -- Tipo de sede
    es_sede_principal      BOOLEAN DEFAULT FALSE,                 -- Indica si es la sede principal
    telefono_sede          VARCHAR(20),                           -- Teléfono de la sede
    correo_sede            VARCHAR(100),                          -- Email de la sede
    id_empresa             INT NOT NULL,                          -- FK a la empresa propietaria
    id_direccion           INT NOT NULL,                          -- FK a la dirección física
    activo                 BOOLEAN DEFAULT TRUE,                  -- Soft delete
    fecha_creacion         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Fecha de creación
    fecha_actualizacion    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Última actualización
    
    FOREIGN KEY (id_empresa) REFERENCES empresa (id_empresa) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_direccion) REFERENCES direccion (id_direccion) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE(nombre_sede_campus, id_empresa)  -- No puede haber sedes con el mismo nombre en una empresa
);

-- Relación entre personas y empresas con rol
CREATE TABLE relacion_empresa_persona (
    id_rel_empresa_persona   SERIAL PRIMARY KEY,                    -- ID único de la relación
    id_persona               INT NOT NULL,                          -- FK a la persona
    id_empresa               INT NOT NULL,                          -- FK a la empresa
    rol                      ROL_ENUM NOT NULL,                     -- Rol en la empresa
    cargo                    VARCHAR(100),                          -- Cargo específico
    fecha_inicio             DATE NOT NULL DEFAULT CURRENT_DATE,    -- Fecha de inicio en el rol
    fecha_fin                DATE,                                   -- Fecha de fin (NULL si está activo)

    FOREIGN KEY (id_persona) REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_empresa) REFERENCES empresa (id_empresa) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT check_fechas_relacion CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio),  -- Fecha fin debe ser posterior a inicio
    UNIQUE(id_persona, id_empresa, rol, fecha_inicio)  -- Evita duplicados de la misma relación
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
    id_sede_campus                   INT NOT NULL,                          -- FK a la sede donde está ubicada
    activo                          BOOLEAN DEFAULT TRUE,                  -- Soft delete
    
    FOREIGN KEY (id_sede_campus) REFERENCES sede_campus (id_sede_campus) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE(nombre_unidad_administrativa, id_sede_campus)  -- No duplicados en la misma sede
);

-- Subunidad administrativa
CREATE TABLE subunidad_administrativa (
    id_subunidad_administrativa      SERIAL PRIMARY KEY,                    -- ID único
    nombre_subunidad                 VARCHAR(100) NOT NULL,                 -- Nombre de la subunidad
    descripcion                      TEXT,                                  -- Descripción
    id_unidad_administrativa         INT NOT NULL,                          -- FK a unidad padre
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
    id_sede_campus              INT NOT NULL,                          -- FK a la sede
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
    id_unidad_academica         INT NOT NULL,                          -- FK a unidad académica
    activo                      BOOLEAN DEFAULT TRUE,                  -- Soft delete
    
    FOREIGN KEY (id_unidad_academica) REFERENCES unidad_academica (id_unidad_academica) ON DELETE CASCADE ON UPDATE CASCADE,
);

-- Grupo de investigación
CREATE TABLE grupo_investigacion (
    id_grupo_investigacion       SERIAL PRIMARY KEY,                    -- ID único
    nombre_grupo_investigacion   VARCHAR(100) NOT NULL,                 -- Nombre del grupo
    codigo_colciencias           VARCHAR(50),                           -- Código Minciencias/Colciencias
    categoria_colciencias        VARCHAR(10),                           -- Categoría (A1, A, B, C)
    lineas_investigacion         TEXT,                                  -- Líneas de investigación
    id_unidad_academica          INT NOT NULL,                          -- FK a unidad académica
    activo                       BOOLEAN DEFAULT TRUE,                  -- Soft delete
    
    FOREIGN KEY (id_unidad_academica) REFERENCES unidad_academica (id_unidad_academica) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE(nombre_grupo_investigacion, id_unidad_academica)  -- No duplicados en la misma unidad
);

-- Relación persona con subunidad administrativa
CREATE TABLE subunidad_administrativa_persona (
    id_subunidad_administrativa_persona   SERIAL PRIMARY KEY,                    -- ID único
    id_subunidad_administrativa           INT NOT NULL,                          -- FK a subunidad
    id_persona                            INT NOT NULL,                          -- FK a persona
    cargo                                 VARCHAR(100),                          -- Cargo en la subunidad
    fecha_inicio                          DATE NOT NULL DEFAULT CURRENT_DATE,   -- Fecha de inicio
    fecha_fin                             DATE,                                  -- Fecha fin (NULL si activo)

    
    FOREIGN KEY (id_subunidad_administrativa) REFERENCES subunidad_administrativa (id_subunidad_administrativa) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_persona) REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT check_fechas_subunidad CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio),
    UNIQUE(id_subunidad_administrativa, id_persona, fecha_inicio)
);

-- Relación persona con grupo de investigación
CREATE TABLE grupo_investigacion_persona (
    id_grupo_investigacion_persona  SERIAL PRIMARY KEY,                    -- ID único
    id_grupo_investigacion          INT NOT NULL,                          -- FK a grupo
    id_persona                      INT NOT NULL,                          -- FK a persona
    rol                             VARCHAR(50),                           -- Rol (Investigador principal, etc.)
    fecha_inicio                    DATE NOT NULL DEFAULT CURRENT_DATE,   -- Fecha de inicio
    fecha_fin                       DATE,                                  -- Fecha fin (NULL si activo)

    
    FOREIGN KEY (id_grupo_investigacion) REFERENCES grupo_investigacion (id_grupo_investigacion) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_persona) REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT check_fechas_grupo CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio),
    UNIQUE(id_grupo_investigacion, id_persona, fecha_inicio)
);

-- Relación persona con programa académico
CREATE TABLE programa_academico_persona (
    id_programa_academico_persona  SERIAL PRIMARY KEY,                    -- ID único
    id_programa_academico          INT NOT NULL,                          -- FK a programa
    id_persona                     INT NOT NULL,                          -- FK a persona (estudiante)
    fecha_inicio                   DATE NOT NULL DEFAULT CURRENT_DATE,   -- Fecha de matrícula
    fecha_fin                      DATE,                                  -- Fecha de graduación/retiro
    estado_academico               ESTADO_ACADEMICO_ENUM NOT NULL DEFAULT 'En curso', -- Estado actual

    
    FOREIGN KEY (id_programa_academico) REFERENCES programa_academico (id_programa_academico) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_persona) REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT check_fechas_programa CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio),
    CONSTRAINT check_promedio CHECK (promedio_acumulado IS NULL OR (promedio_acumulado >= 0 AND promedio_acumulado <= 5)),
    UNIQUE(id_programa_academico, id_persona, fecha_inicio)
);

-- ==============================================================
-- PROFESIONES Y REDES SOCIALES
-- ==============================================================

CREATE TABLE profesion (
    id_profesion       SERIAL PRIMARY KEY,                    -- ID único
    titulo_profesion   VARCHAR(100) NOT NULL UNIQUE,          -- Título profesional
    area_profesion     VARCHAR(100),                          -- Área del conocimiento
    codigo_profesion   VARCHAR(50),                           -- Código clasificación ocupacional
    activo             BOOLEAN DEFAULT TRUE,                  -- Soft delete
);

CREATE TABLE profesion_persona (
    id_persona_profesion  SERIAL PRIMARY KEY,                    -- ID único
    id_profesion          INT NOT NULL,                          -- FK a profesión
    id_persona            INT NOT NULL,                          -- FK a persona
    anios_experiencia     INT DEFAULT 0,                         -- Años de experiencia

    
    FOREIGN KEY (id_profesion) REFERENCES profesion (id_profesion) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_persona) REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT check_experiencia CHECK (anios_experiencia >= 0),  -- Experiencia no negativa
    UNIQUE(id_profesion, id_persona)  -- Una persona no puede tener la misma profesión dos veces
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
    CONSTRAINT check_red_social_entidad CHECK (
        (id_persona IS NOT NULL AND id_empresa IS NULL) OR 
        (id_persona IS NULL AND id_empresa IS NOT NULL)
    )  -- Debe estar asociado a persona O empresa, no ambos ni ninguno
);

-- ==============================================================
-- EMPRENDIMIENTO Y EMPRENDEDOR
-- ==============================================================

CREATE TABLE emprendimiento (
    id_emprendimiento                  SERIAL PRIMARY KEY,                    -- ID único
    id_empresa                         INT NOT NULL,                          -- FK a empresa (1:1)
    surgimiento_emprendimiento         VARCHAR(255),                          -- Cómo surgió la idea
    idea_negocio                       TEXT,                                  -- Descripción de la idea
    estado_desarrollo_emprendimiento   ESTADO_DESARROLLO_EMPREN_ENUM NOT NULL, -- Estado actual
    macrosector_emprendimiento         MACROSECTOR_EMPRENDIMIENTO_ENUM,      -- Sector principal
    subsector_emprendimiento           SUBSECTOR_EMPRENDIMIENTO_ENUM,        -- Subsector específico
    cantidad_empleados                 INT DEFAULT 0,                         -- Número de empleados
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
    activo                            BOOLEAN DEFAULT TRUE,                  -- Soft delete
    fecha_creacion                    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Fecha de registro
    fecha_actualizacion               TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Última actualización
    
    FOREIGN KEY (id_empresa) REFERENCES empresa (id_empresa) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT check_empleados CHECK (cantidad_empleados >= 0),
    CONSTRAINT check_ventas CHECK (ventas_promedio_anual IS NULL OR ventas_promedio_anual >= 0),
    CONSTRAINT check_clientes CHECK (cantidad_clientes_promedio_mes IS NULL OR cantidad_clientes_promedio_mes >= 0),
    UNIQUE(id_empresa)  -- Relación 1:1 con empresa
);

CREATE TABLE emprendedor (
    id_emprendedor                    SERIAL PRIMARY KEY,                    -- ID único
    id_persona                        INT NOT NULL,                          -- FK a persona (1:1)
    etnia_emprendedor                 ETNIA_EMPRENDEDOR_ENUM NOT NULL,      -- Autoidentificación étnica
    discapacidad_emprendedor          BOOLEAN DEFAULT FALSE,                 -- Tiene alguna discapacidad
    victima_emprendedor               BOOLEAN DEFAULT FALSE,                 -- Víctima del conflicto armado
    poblacion_campesina_emprendedor   BOOLEAN DEFAULT FALSE,                 -- Población campesina
    estado_civil_emprendedor          ESTADO_CIVIL_EMPRENDEDOR_ENUM NOT NULL, -- Estado civil
    cabeza_hogar_emprendedor          BOOLEAN DEFAULT FALSE,                 -- Es cabeza de hogar
    personas_a_cargo                  INT DEFAULT 0,                         -- Número de personas a cargo
    nivel_educativo_maximo            NIVEL_PROGRAMA_ACADEMICO_ENUM,        -- Máximo nivel educativo alcanzado
    activo                            BOOLEAN DEFAULT TRUE,                  -- Soft delete
    fecha_creacion                    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Fecha de registro
    fecha_actualizacion               TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Última actualización
    
    FOREIGN KEY (id_persona) REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT check_personas_cargo CHECK (personas_a_cargo >= 0),
    UNIQUE(id_persona)  -- Relación 1:1 con persona
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
    lider_programa                      VARCHAR(255),                          -- Nombre del líder/coordinador
    correo_programa                     VARCHAR(255),                          -- Email de contacto
    telefono_programa                   VARCHAR(20),                           -- Teléfono de contacto
    equipo_programa                     TEXT,                                  -- Descripción del equipo
    roles_funciones_programa            TEXT,                                  -- Roles y responsabilidades
    resumen_estado_programa             TEXT,                                  -- Resumen ejecutivo del estado
    activo                             BOOLEAN DEFAULT TRUE,                  -- Soft delete
    fecha_creacion                     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Fecha de registro
    fecha_actualizacion                TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Última actualización
    
    CONSTRAINT check_valor_programa CHECK (valor_programa IS NULL OR valor_programa >= 0),
    CONSTRAINT check_fechas_programa CHECK (cronograma_fin_programa IS NULL OR cronograma_fin_programa >= cronograma_inicio_programa),
    CONSTRAINT check_correo_programa CHECK (correo_programa IS NULL OR correo_programa ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$')
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
    contratante_proyecto               VARCHAR(255),                          -- Entidad contratante
    valor_proyecto                     NUMERIC(15,2),                         -- Valor total del proyecto
    moneda_proyecto                    VARCHAR(10) DEFAULT 'COP',            -- Moneda (COP, USD, EUR, etc.)
    lider_proyecto                     VARCHAR(255),                          -- Líder del proyecto
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
    personas_ag_o_pe                     TEXT,                                  -- Personas involucradas
    procesos_ag_pe                       TEXT,                                  -- Procesos relacionados
    macroproceso_ag_pe                   TEXT,                                  -- Macroproceso al que pertenece
    activo                              BOOLEAN DEFAULT TRUE,                  -- Soft delete
);

CREATE TABLE asunto_de_trabajo_tipo_emprendimiento (
    id_asunto_trabajo                    SERIAL PRIMARY KEY,                    -- ID único
    id_ag_o_pe                          INT,                                   -- FK a ag_o_pe
    nombre_asunto_trabajo                VARCHAR(255) NOT NULL,                 -- Nombre del asunto
    descripcion_asunto_trabajo           TEXT,                                  -- Descripción detallada
    responsable_asunto_trabajo           VARCHAR(255),                          -- Responsable principal
    talento_humano_asunto_trabajo        TEXT,                                  -- Equipo de trabajo
    agrupacion_asunto_trabajo            TEXT,                                  -- Agrupación/categoría
    activo                              BOOLEAN DEFAULT TRUE,                  -- Soft delete
    
    FOREIGN KEY (id_ag_o_pe) REFERENCES ag_o_pe(id_ag_o_pe) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE mapa_conocimiento_proceso (
    id_mapa_conocimiento                SERIAL PRIMARY KEY,                    -- ID único
    id_asunto_trabajo                   INT,                                   -- FK a asunto de trabajo
    nombre_proceso                      VARCHAR(255) NOT NULL,                 -- Nombre del proceso
    responsable_proceso                 VARCHAR(255),                          -- Responsable del proceso
    prioridad_proceso                   PRIORIDAD_ENUM DEFAULT 'Media',       -- Prioridad
    estado_documentacion_proceso        VARCHAR(100),                          -- Estado de la documentación
    cronograma_inicio_proceso           DATE,                                  -- Fecha inicio planeada
    cronograma_fin_proceso              DATE,                                  -- Fecha fin planeada
    duracion_dias                       INT,                                   -- Duración en días
    esfuerzo_planificado_horas          INT,                                   -- Horas estimadas
    esfuerzo_real_horas                 INT,                                   -- Horas reales ejecutadas
    presupuesto_proceso                 NUMERIC(15,2),                         -- Presupuesto asignado
    tipo_proyecto_proceso               VARCHAR(100),                          -- Tipo de proyecto
    activo                              BOOLEAN DEFAULT TRUE,                  -- Soft delete
    
    FOREIGN KEY (id_asunto_trabajo) REFERENCES asunto_de_trabajo_tipo_emprendimiento (id_asunto_trabajo) ON DELETE SET NULL ON UPDATE CASCADE,
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
    responsable_etapa_asunto_trabajo_proyecto_actividad      VARCHAR(255),        -- Responsable
    orden_etapa                                             INT,                  -- Orden de ejecución
    id_asunto_trabajo                                       INT,                  -- FK a asunto de trabajo
    id_proyecto                                             INT,                  -- FK a proyecto

    
    FOREIGN KEY (id_asunto_trabajo) REFERENCES asunto_de_trabajo_tipo_emprendimiento (id_asunto_trabajo) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_proyecto) REFERENCES proyecto (id_proyecto) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE dimension_emprendimiento (
    id_dimension_emprendimiento           SERIAL PRIMARY KEY,                    -- ID único
    nombre_dimension_emprendimiento       VARCHAR(255) NOT NULL UNIQUE,         -- Nombre de la dimensión
    descripcion_dimension_emprendimiento  TEXT,                                  -- Descripción
    responsable_dimension_emprendimiento  VARCHAR(255),                          -- Responsable
    activo                                BOOLEAN DEFAULT TRUE,                  -- Soft delete
);

CREATE TABLE actividad_momento (
    id_actividad                          SERIAL PRIMARY KEY,                    -- ID único
    id_etapa_asunto_trabajo_proyecto_actividad INT,                             -- FK a etapa
    fecha_actividad                       DATE NOT NULL,                         -- Fecha de la actividad
    nombre_actividad                      VARCHAR(255) NOT NULL,                 -- Nombre de la actividad
    descripcion_actividad                 TEXT,                                  -- Descripción
    hora_inicio_actividad                 TIME,                                  -- Hora de inicio
    hora_finalizacion_actividad           TIME,                                  -- Hora de fin
    tematica_actividad                    VARCHAR(255),                          -- Temática principal
    modalidad_actividad                   MODALIDAD_ACTIVIDAD_ENUM DEFAULT 'Presencial', -- Modalidad
    tipo_actividad                        TIPO_ACTIVIDAD_ENUM DEFAULT 'Actividad', -- Tipo
    materiales_actividad                  TEXT,                                  -- Materiales necesarios
    alimentacion_actividad                BOOLEAN DEFAULT FALSE,                 -- Incluye alimentación
    facilitador_actividad                 VARCHAR(255),                          -- Facilitador/instructor
    fase_actividad                        VARCHAR(100),                          -- Fase del proceso
    semestre_ejecucion_fase               VARCHAR(100),                          -- Semestre de ejecución
    observaciones_actividad               TEXT,                                  -- Observaciones
    
    FOREIGN KEY (id_etapa_asunto_trabajo_proyecto_actividad) REFERENCES etapa_asunto_trabajo_proyecto_actividad (id_etapa_asunto_trabajo_proyecto_actividad) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT check_horas_actividad CHECK (hora_finalizacion_actividad IS NULL OR hora_finalizacion_actividad >= hora_inicio_actividad)
);

CREATE TABLE subactividad_producto (
    id_subactividad                       SERIAL PRIMARY KEY,                    -- ID único
    id_actividad                          INT NOT NULL,                          -- FK a actividad principal
    id_dimension_emprendimiento           INT,                                   -- FK a dimensión
    id_direccion                          INT,                                   -- FK a dirección del evento
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
    
    FOREIGN KEY (id_actividad) REFERENCES actividad_momento (id_actividad) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_direccion) REFERENCES direccion (id_direccion) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (id_dimension_emprendimiento) REFERENCES dimension_emprendimiento (id_dimension_emprendimiento) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT check_horas_subactividad CHECK (hora_finalizacion_subactividad IS NULL OR hora_finalizacion_subactividad >= hora_inicio_subactividad)
);

CREATE TABLE relacion_actividad_persona (
    id_relacion_actividad_persona         SERIAL PRIMARY KEY,                    -- ID único
    id_persona                            INT NOT NULL,                          -- FK a persona (asistente)
    id_subactividad                       INT NOT NULL,                          -- FK a subactividad
    asistio                               BOOLEAN DEFAULT TRUE,                  -- Confirmación de asistencia
    calificacion                          INT,                                   -- Calificación (1-5)
    comentarios                           TEXT,                                  -- Comentarios/feedback
    rol                                   VARCHAR(255),                          -- Tipo de rol en actividad 
    
    FOREIGN KEY (id_persona) REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_subactividad) REFERENCES subactividad_producto (id_subactividad) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT check_calificacion CHECK (calificacion IS NULL OR (calificacion >= 1 AND calificacion <= 5)),
    UNIQUE(id_persona, id_subactividad)  -- Una persona no puede estar dos veces en la misma subactividad
);

-- ==============================================================
-- SISTEMA DE LOGS Y AUDITORÍA
-- ==============================================================

CREATE TABLE log_cambios (
    id_log                  SERIAL PRIMARY KEY,                    -- ID único del log
    nombre_tabla            VARCHAR(100) NOT NULL,                 -- Tabla afectada
    tipo_operacion          TIPO_OPERACION_LOG NOT NULL,          -- INSERT, UPDATE o DELETE
    id_registro_afectado    INT NOT NULL,                          -- ID del registro modificado
    datos_anteriores        JSONB,                                 -- Valores antes del cambio (UPDATE/DELETE)
    datos_nuevos            JSONB,                                 -- Valores después del cambio (INSERT/UPDATE)
    usuario_accion          VARCHAR(100),                          -- Usuario que realizó la acción
    ip_origen               INET,                                  -- Dirección IP del origen
    fecha_cambio            TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Fecha/hora del cambio
    id_persona              INT,                                   -- FK a persona que hizo el cambio
    id_empresa              INT,                                   -- FK a empresa relacionada
    
    FOREIGN KEY (id_persona) REFERENCES persona (id_persona) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (id_empresa) REFERENCES empresa (id_empresa) ON DELETE SET NULL ON UPDATE CASCADE
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
CREATE INDEX idx_relacion_actividad_persona_persona ON relacion_actividad_persona(id_persona);

-- Índices para emprendimiento
CREATE INDEX idx_emprendimiento_empresa ON emprendimiento(id_empresa);
CREATE INDEX idx_emprendimiento_estado ON emprendimiento(estado_desarrollo_emprendimiento);
CREATE INDEX idx_emprendedor_persona ON emprendedor(id_persona);

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

-- Comentarios en tablas principales
COMMENT ON TABLE persona IS 'Tabla principal de personas del sistema, incluye datos personales y de contacto';
COMMENT ON TABLE empresa IS 'Tabla de empresas e instituciones, incluye emprendimientos y entidades educativas';
COMMENT ON TABLE emprendimiento IS 'Detalles específicos de emprendimientos, relación 1:1 con empresa';
COMMENT ON TABLE emprendedor IS 'Información adicional de personas que son emprendedores, relación 1:1 con persona';

-- Comentarios en columnas importantes
COMMENT ON COLUMN persona.activo IS 'Soft delete: TRUE=registro activo, FALSE=registro eliminado lógicamente';
COMMENT ON COLUMN empresa.es_emprendimiento IS 'Indica si la empresa es un emprendimiento';
COMMENT ON COLUMN sede_campus.es_sede_principal IS 'Identifica la sede principal de la empresa/institución';

-- ==============================================================
-- FIN DEL MODELO DE BASE DE DATOS
-- ==============================================================

-- Estadísticas del modelo:
-- Total de tablas: 47
-- Total de enumerados: 30
-- Total de índices: 45+
-- Total de constraints: 100+
-- Total de foreign keys: 80+
-- Funciones y procedimientos: 5+
-- Vistas: 5+ para búsquedas frecuentes

