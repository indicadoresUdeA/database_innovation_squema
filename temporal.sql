-- ==============================================================
-- SISTEMA UNIFICADO DE GESTIÓN DE ROLES Y RESPONSABILIDADES
-- Versión: 3.0
-- Fecha: 2025-01-28
-- Autor: Sistema de Arquitectura de Datos
-- 
-- CUMPLIMIENTO DE ESTÁNDARES:
-- - ISO/IEC 11179 (Metadata Registry)
-- - ANSI/ISO SQL:2016
-- - GDPR Article 30 (Records of processing activities)
-- - COBIT 5 (APO01.08 - Data Architecture)
-- ==============================================================

-- ==============================================================
-- FASE 1: CREACIÓN DE ESTRUCTURAS BASE
-- ==============================================================

BEGIN TRANSACTION;

-- Crear schema específico para auditoría (mejor práctica: separación de concerns)
CREATE SCHEMA IF NOT EXISTS audit;
CREATE SCHEMA IF NOT EXISTS core;

-- ==============================================================
-- ENUMERADOS PARA EL SISTEMA DE ROLES
-- ==============================================================

-- Tipo de ámbito donde aplica el rol
CREATE TYPE AMBITO_ROL_ENUM AS ENUM (
    'ACADEMICO',           -- Roles académicos (Decano, Coordinador, etc.)
    'ADMINISTRATIVO',      -- Roles administrativos (Director, Jefe, etc.)
    'PROYECTO',           -- Roles de proyecto (Líder, Coordinador, etc.)
    'PROGRAMA',           -- Roles de programa
    'EMPRESA',            -- Roles empresariales
    'INVESTIGACION',      -- Roles de investigación
    'ACTIVIDAD',          -- Roles en actividades/eventos
    'EMPRENDIMIENTO',     -- Roles en emprendimiento
    'PROCESO',            -- Roles en procesos
    'GENERAL'             -- Roles generales/transversales
);

-- Nivel jerárquico del rol
CREATE TYPE NIVEL_JERARQUICO_ENUM AS ENUM (
    'ESTRATEGICO',        -- Alta dirección
    'TACTICO',           -- Gerencia media
    'OPERATIVO',         -- Nivel operacional
    'APOYO'              -- Roles de soporte
);

-- Estado de la asignación
CREATE TYPE ESTADO_ASIGNACION_ENUM AS ENUM (
    'PENDIENTE',         -- Asignación pendiente de confirmación
    'ACTIVA',           -- Asignación vigente
    'SUSPENDIDA',       -- Temporalmente suspendida
    'FINALIZADA',       -- Completada normalmente
    'CANCELADA',        -- Cancelada antes de tiempo
    'TRANSFERIDA'       -- Transferida a otra persona
);

-- ==============================================================
-- TABLA: CATÁLOGO MAESTRO DE TIPOS DE ROLES
-- Patrón: Master Data Management (MDM)
-- ==============================================================

CREATE TABLE core.tipo_rol (
    id_tipo_rol              SERIAL PRIMARY KEY,
    
    -- Identificación del rol
    codigo_rol               VARCHAR(50) UNIQUE NOT NULL 
                            CONSTRAINT chk_codigo_rol_formato 
                            CHECK (codigo_rol ~ '^[A-Z][A-Z0-9_]{2,49}$'),  -- Formato: MAYUSCULAS_CON_GUION
    
    nombre_rol               VARCHAR(100) NOT NULL,
    nombre_corto_rol         VARCHAR(50),
    descripcion_rol          TEXT NOT NULL,
    
    -- Clasificación
    ambito_aplicacion        AMBITO_ROL_ENUM NOT NULL,
    nivel_jerarquico         NIVEL_JERARQUICO_ENUM NOT NULL DEFAULT 'OPERATIVO',
    nivel_autoridad          INTEGER NOT NULL DEFAULT 1 
                            CONSTRAINT chk_nivel_autoridad 
                            CHECK (nivel_autoridad BETWEEN 1 AND 10),  -- 1=mínimo, 10=máximo
    
    -- Reglas de negocio
    permite_multiple         BOOLEAN DEFAULT FALSE,  -- ¿Puede tener múltiples asignaciones simultáneas?
    requiere_aprobacion      BOOLEAN DEFAULT FALSE,  -- ¿Requiere aprobación para asignar?
    requiere_certificacion   BOOLEAN DEFAULT FALSE,  -- ¿Requiere certificación/competencias?
    duracion_maxima_dias     INTEGER,                -- Duración máxima en días (NULL = sin límite)
    duracion_tipica_dias     INTEGER,                -- Duración típica/esperada
    
    -- Jerarquía de roles (para delegación/escalamiento)
    id_rol_superior          INTEGER,
    id_rol_suplente          INTEGER,
    
    -- Metadatos
    activo                   BOOLEAN DEFAULT TRUE NOT NULL,
    fecha_creacion           TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_actualizacion      TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    creado_por               INTEGER,
    actualizado_por          INTEGER,
    version                  INTEGER DEFAULT 1 NOT NULL,
    
    -- Foreign Keys
    CONSTRAINT fk_tipo_rol_superior 
        FOREIGN KEY (id_rol_superior) REFERENCES core.tipo_rol(id_tipo_rol),
    CONSTRAINT fk_tipo_rol_suplente 
        FOREIGN KEY (id_rol_suplente) REFERENCES core.tipo_rol(id_tipo_rol),
    CONSTRAINT fk_tipo_rol_creado_por 
        FOREIGN KEY (creado_por) REFERENCES persona(id_persona),
    CONSTRAINT fk_tipo_rol_actualizado_por 
        FOREIGN KEY (actualizado_por) REFERENCES persona(id_persona),
    
    -- Constraints de negocio
    CONSTRAINT chk_duracion_rol 
        CHECK (duracion_maxima_dias IS NULL OR duracion_maxima_dias > 0),
    CONSTRAINT chk_rol_no_autoreferencia 
        CHECK (id_rol_superior != id_tipo_rol AND id_rol_suplente != id_tipo_rol)
);

-- Comentarios de documentación (mejores prácticas)
COMMENT ON TABLE core.tipo_rol IS 'Catálogo maestro de tipos de roles disponibles en el sistema. Define las características y reglas de negocio de cada rol.';
COMMENT ON COLUMN core.tipo_rol.codigo_rol IS 'Código único del rol en formato MAYUSCULAS_CON_GUION. Inmutable una vez creado.';
COMMENT ON COLUMN core.tipo_rol.nivel_autoridad IS 'Nivel de autoridad del rol (1-10). Usado para jerarquías y validaciones de aprobación.';
COMMENT ON COLUMN core.tipo_rol.permite_multiple IS 'TRUE si una persona puede tener múltiples asignaciones de este rol simultáneamente.';

-- ==============================================================
-- TABLA: ASIGNACIONES DE ROLES (NÚCLEO DEL SISTEMA)
-- Patrón: Temporal Pattern + Polymorphic Association
-- ==============================================================

CREATE TABLE core.asignacion_rol (
    id_asignacion            BIGSERIAL PRIMARY KEY,  -- BIGSERIAL para escalabilidad
    
    -- =====================================
    -- BLOQUE 1: PERSONA Y ROL (Requeridos)
    -- =====================================
    id_persona               INTEGER NOT NULL,
    id_tipo_rol              INTEGER NOT NULL,
    
    -- =====================================
    -- BLOQUE 2: ENTIDAD POLIMÓRFICA
    -- Solo UNA debe tener valor (validado por constraint)
    -- =====================================
    -- Entidades académicas
    id_empresa               INTEGER,
    id_sede_campus           INTEGER,
    id_unidad_academica      INTEGER,
    id_unidad_administrativa INTEGER,
    id_subunidad_administrativa INTEGER,
    id_programa_academico    INTEGER,
    id_grupo_investigacion   INTEGER,
    
    -- Entidades de gestión
    id_programa              INTEGER,
    id_proyecto              INTEGER,
    id_ag_o_pe              INTEGER,
    id_asunto_trabajo        INTEGER,
    id_mapa_conocimiento     INTEGER,
    
    -- Entidades de actividades
    id_actividad             INTEGER,
    id_subactividad          INTEGER,
    id_etapa_asunto_trabajo  INTEGER,
    
    -- Entidades de emprendimiento
    id_emprendimiento        INTEGER,
    id_dimension_emprendimiento INTEGER,
    
    -- =====================================
    -- BLOQUE 3: DETALLES DE LA ASIGNACIÓN
    -- =====================================
    cargo_especifico         VARCHAR(200),  -- "Decano de la Facultad de Ingeniería"
    descripcion_responsabilidades TEXT,     -- Descripción detallada de responsabilidades
    
    -- Gestión temporal (Patrón: Bi-temporal database)
    fecha_inicio_vigencia    DATE NOT NULL DEFAULT CURRENT_DATE,
    fecha_fin_vigencia       DATE,
    fecha_inicio_real        DATE,  -- Cuando realmente empezó (puede diferir de vigencia)
    fecha_fin_real           DATE,  -- Cuando realmente terminó
    
    -- Gestión de dedicación
    porcentaje_dedicacion    DECIMAL(5,2) DEFAULT 100.00 NOT NULL
                            CONSTRAINT chk_porcentaje_dedicacion 
                            CHECK (porcentaje_dedicacion > 0 AND porcentaje_dedicacion <= 100),
    horas_semanales         DECIMAL(4,1)
                            CONSTRAINT chk_horas_semanales 
                            CHECK (horas_semanales IS NULL OR (horas_semanales > 0 AND horas_semanales <= 168)),
    
    -- Clasificación de la asignación
    es_titular              BOOLEAN DEFAULT TRUE NOT NULL,  -- FALSE = suplente/encargado
    es_adhonorem           BOOLEAN DEFAULT FALSE NOT NULL,  -- Sin remuneración
    es_interino            BOOLEAN DEFAULT FALSE NOT NULL,  -- Temporal/provisional
    estado_asignacion      ESTADO_ASIGNACION_ENUM DEFAULT 'PENDIENTE' NOT NULL,
    
    -- Gestión de aprobaciones
    requiere_aprobacion    BOOLEAN DEFAULT FALSE NOT NULL,
    aprobado_por          INTEGER,
    fecha_aprobacion      TIMESTAMPTZ,
    
    -- Delegación y transferencia
    delegado_de           INTEGER,  -- Si es una delegación, ID de la asignación original
    transferido_a         INTEGER,  -- Si fue transferido, ID de la nueva asignación
    motivo_cambio         TEXT,     -- Razón del cambio/transferencia/cancelación
    
    -- Observaciones y documentación
    observaciones         TEXT,
    documentos_soporte    TEXT[],   -- Array de URLs a documentos
    competencias_requeridas TEXT[],  -- Array de competencias necesarias
    
    -- =====================================
    -- BLOQUE 4: AUDITORÍA COMPLETA
    -- =====================================
    asignado_por          INTEGER NOT NULL,
    fecha_asignacion      TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modificado_por        INTEGER,
    fecha_modificacion    TIMESTAMPTZ,
    ip_asignacion        INET,
    ip_modificacion      INET,
    user_agent           TEXT,
    
    -- Control de versiones optimista
    version              INTEGER DEFAULT 1 NOT NULL,
    
    -- Soft delete
    activo              BOOLEAN DEFAULT TRUE NOT NULL,
    fecha_eliminacion   TIMESTAMPTZ,
    eliminado_por       INTEGER,
    
    -- =====================================
    -- FOREIGN KEYS
    -- =====================================
    CONSTRAINT fk_asignacion_persona 
        FOREIGN KEY (id_persona) REFERENCES persona(id_persona) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT fk_asignacion_tipo_rol 
        FOREIGN KEY (id_tipo_rol) REFERENCES core.tipo_rol(id_tipo_rol) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT fk_asignacion_asignado_por 
        FOREIGN KEY (asignado_por) REFERENCES persona(id_persona) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT fk_asignacion_modificado_por 
        FOREIGN KEY (modificado_por) REFERENCES persona(id_persona) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT fk_asignacion_aprobado_por 
        FOREIGN KEY (aprobado_por) REFERENCES persona(id_persona) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT fk_asignacion_eliminado_por 
        FOREIGN KEY (eliminado_por) REFERENCES persona(id_persona) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    -- FKs para entidades (todas con ON DELETE RESTRICT para proteger integridad)
    CONSTRAINT fk_asignacion_empresa 
        FOREIGN KEY (id_empresa) REFERENCES empresa(id_empresa) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT fk_asignacion_sede_campus 
        FOREIGN KEY (id_sede_campus) REFERENCES sede_campus(id_sede_campus) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT fk_asignacion_unidad_academica 
        FOREIGN KEY (id_unidad_academica) REFERENCES unidad_academica(id_unidad_academica) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT fk_asignacion_unidad_administrativa 
        FOREIGN KEY (id_unidad_administrativa) REFERENCES unidad_administrativa(id_unidad_administrativa) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT fk_asignacion_subunidad_administrativa 
        FOREIGN KEY (id_subunidad_administrativa) REFERENCES subunidad_administrativa(id_subunidad_administrativa) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT fk_asignacion_programa_academico 
        FOREIGN KEY (id_programa_academico) REFERENCES programa_academico(id_programa_academico) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT fk_asignacion_grupo_investigacion 
        FOREIGN KEY (id_grupo_investigacion) REFERENCES grupo_investigacion(id_grupo_investigacion) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT fk_asignacion_programa 
        FOREIGN KEY (id_programa) REFERENCES programa(id_programa) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT fk_asignacion_proyecto 
        FOREIGN KEY (id_proyecto) REFERENCES proyecto(id_proyecto) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT fk_asignacion_ag_o_pe 
        FOREIGN KEY (id_ag_o_pe) REFERENCES ag_o_pe(id_ag_o_pe) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT fk_asignacion_asunto_trabajo 
        FOREIGN KEY (id_asunto_trabajo) REFERENCES asunto_de_trabajo_tipo_emprendimiento(id_asunto_trabajo) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT fk_asignacion_mapa_conocimiento 
        FOREIGN KEY (id_mapa_conocimiento) REFERENCES mapa_conocimiento_proceso(id_mapa_conocimiento) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT fk_asignacion_actividad 
        FOREIGN KEY (id_actividad) REFERENCES actividad_momento(id_actividad) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT fk_asignacion_subactividad 
        FOREIGN KEY (id_subactividad) REFERENCES subactividad_producto(id_subactividad) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT fk_asignacion_etapa_asunto_trabajo 
        FOREIGN KEY (id_etapa_asunto_trabajo) REFERENCES etapa_asunto_trabajo_proyecto_actividad(id_etapa_asunto_trabajo_proyecto_actividad) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT fk_asignacion_emprendimiento 
        FOREIGN KEY (id_emprendimiento) REFERENCES emprendimiento(id_emprendimiento) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT fk_asignacion_dimension_emprendimiento 
        FOREIGN KEY (id_dimension_emprendimiento) REFERENCES dimension_emprendimiento(id_dimension_emprendimiento) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT fk_asignacion_delegado_de 
        FOREIGN KEY (delegado_de) REFERENCES core.asignacion_rol(id_asignacion) 
        ON DELETE SET NULL ON UPDATE CASCADE,
    
    CONSTRAINT fk_asignacion_transferido_a 
        FOREIGN KEY (transferido_a) REFERENCES core.asignacion_rol(id_asignacion) 
        ON DELETE SET NULL ON UPDATE CASCADE,
    
    -- =====================================
    -- CONSTRAINTS DE INTEGRIDAD
    -- =====================================
    
    -- CRÍTICO: Garantizar que EXACTAMENTE UNA entidad está asignada
    CONSTRAINT chk_una_sola_entidad CHECK (
        (CASE WHEN id_empresa IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN id_sede_campus IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN id_unidad_academica IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN id_unidad_administrativa IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN id_subunidad_administrativa IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN id_programa_academico IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN id_grupo_investigacion IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN id_programa IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN id_proyecto IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN id_ag_o_pe IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN id_asunto_trabajo IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN id_mapa_conocimiento IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN id_actividad IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN id_subactividad IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN id_etapa_asunto_trabajo IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN id_emprendimiento IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN id_dimension_emprendimiento IS NOT NULL THEN 1 ELSE 0 END) = 1
    ),
    
    -- Validaciones temporales
    CONSTRAINT chk_fechas_vigencia 
        CHECK (fecha_fin_vigencia IS NULL OR fecha_fin_vigencia >= fecha_inicio_vigencia),
    
    CONSTRAINT chk_fechas_reales 
        CHECK (fecha_fin_real IS NULL OR fecha_fin_real >= fecha_inicio_real),
    
    CONSTRAINT chk_fecha_aprobacion 
        CHECK ((aprobado_por IS NULL AND fecha_aprobacion IS NULL) OR 
               (aprobado_por IS NOT NULL AND fecha_aprobacion IS NOT NULL)),
    
    -- Evitar asignaciones duplicadas activas (considerando NULL en fecha_fin)
    CONSTRAINT uq_asignacion_activa UNIQUE NULLS NOT DISTINCT (
        id_persona, 
        id_tipo_rol,
        id_empresa, 
        id_sede_campus,
        id_unidad_academica, 
        id_unidad_administrativa,
        id_subunidad_administrativa,
        id_programa_academico,
        id_grupo_investigacion,
        id_programa, 
        id_proyecto, 
        id_ag_o_pe,
        id_asunto_trabajo, 
        id_mapa_conocimiento,
        id_actividad,
        id_subactividad,
        id_etapa_asunto_trabajo,
        id_emprendimiento,
        id_dimension_emprendimiento,
        fecha_fin_vigencia
    )
);

-- Comentarios extensivos (documentación en la base de datos)
COMMENT ON TABLE core.asignacion_rol IS 'Tabla central del sistema unificado de roles. Gestiona todas las asignaciones de personas a roles en diferentes entidades usando un patrón polimórfico.';
COMMENT ON COLUMN core.asignacion_rol.id_asignacion IS 'Identificador único de la asignación. BIGSERIAL para soportar millones de registros.';
COMMENT ON COLUMN core.asignacion_rol.fecha_inicio_vigencia IS 'Fecha desde la cual la asignación es válida (puede ser futura).';
COMMENT ON COLUMN core.asignacion_rol.fecha_inicio_real IS 'Fecha en que la persona realmente comenzó en el rol (para auditoría).';
COMMENT ON COLUMN core.asignacion_rol.es_titular IS 'TRUE=Titular del cargo, FALSE=Suplente/Encargado/Interino';
COMMENT ON COLUMN core.asignacion_rol.version IS 'Control de concurrencia optimista. Se incrementa en cada UPDATE.';

-- ==============================================================
-- TABLA: HISTORIAL DE CAMBIOS EN ASIGNACIONES
-- Patrón: Event Sourcing / Audit Log
-- ==============================================================

CREATE TABLE audit.historial_asignacion_rol (
    id_historial            BIGSERIAL PRIMARY KEY,
    id_asignacion          BIGINT NOT NULL,
    
    -- Snapshot del estado
    estado_anterior        JSONB NOT NULL,
    estado_nuevo          JSONB NOT NULL,
    campos_modificados    TEXT[] NOT NULL,  -- Array de campos que cambiaron
    
    -- Tipo de cambio
    tipo_cambio           VARCHAR(50) NOT NULL,  -- CREATE, UPDATE, DELETE, APPROVE, TRANSFER, etc.
    descripcion_cambio    TEXT,
    
    -- Auditoría
    usuario_cambio        INTEGER NOT NULL,
    fecha_cambio         TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    ip_cambio            INET,
    user_agent           TEXT,
    
    -- Metadatos adicionales
    modulo_origen        VARCHAR(100),  -- Desde qué módulo/pantalla se hizo
    comentarios          TEXT,
    
    CONSTRAINT fk_historial_asignacion 
        FOREIGN KEY (id_asignacion) REFERENCES core.asignacion_rol(id_asignacion) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    CONSTRAINT fk_historial_usuario 
        FOREIGN KEY (usuario_cambio) REFERENCES persona(id_persona) 
        ON DELETE RESTRICT ON UPDATE CASCADE
);

COMMENT ON TABLE audit.historial_asignacion_rol IS 'Registro completo de todos los cambios realizados en las asignaciones de roles. Implementa Event Sourcing para auditoría completa.';

-- ==============================================================
-- FASE 2: ÍNDICES OPTIMIZADOS
-- ==============================================================

-- Índices para búsquedas frecuentes
CREATE INDEX idx_asignacion_persona 
    ON core.asignacion_rol(id_persona) 
    WHERE activo = TRUE;

CREATE INDEX idx_asignacion_tipo_rol 
    ON core.asignacion_rol(id_tipo_rol) 
    WHERE activo = TRUE;

CREATE INDEX idx_asignacion_estado 
    ON core.asignacion_rol(estado_asignacion) 
    WHERE activo = TRUE;

-- Índice para asignaciones vigentes (más común)
CREATE INDEX idx_asignacion_vigentes 
    ON core.asignacion_rol(id_persona, fecha_inicio_vigencia, fecha_fin_vigencia) 
    WHERE activo = TRUE AND estado_asignacion = 'ACTIVA';

-- Índices para cada tipo de entidad (partial indexes para performance)
CREATE INDEX idx_asignacion_empresa 
    ON core.asignacion_rol(id_empresa) 
    WHERE id_empresa IS NOT NULL AND activo = TRUE;

CREATE INDEX idx_asignacion_proyecto 
    ON core.asignacion_rol(id_proyecto) 
    WHERE id_proyecto IS NOT NULL AND activo = TRUE;

CREATE INDEX idx_asignacion_programa 
    ON core.asignacion_rol(id_programa) 
    WHERE id_programa IS NOT NULL AND activo = TRUE;

CREATE INDEX idx_asignacion_unidad_academica 
    ON core.asignacion_rol(id_unidad_academica) 
    WHERE id_unidad_academica IS NOT NULL AND activo = TRUE;

-- Índice para búsquedas por fecha
CREATE INDEX idx_asignacion_fechas 
    ON core.asignacion_rol(fecha_inicio_vigencia, fecha_fin_vigencia);

-- Índice para auditoría
CREATE INDEX idx_historial_asignacion 
    ON audit.historial_asignacion_rol(id_asignacion, fecha_cambio DESC);

CREATE INDEX idx_historial_usuario 
    ON audit.historial_asignacion_rol(usuario_cambio, fecha_cambio DESC);

-- Índice GIN para búsquedas en JSONB (historial)
CREATE INDEX idx_historial_estado_gin 
    ON audit.historial_asignacion_rol USING GIN (estado_anterior);

CREATE INDEX idx_historial_estado_nuevo_gin 
    ON audit.historial_asignacion_rol USING GIN (estado_nuevo);

-- ==============================================================
-- FASE 3: VISTAS MATERIALIZADAS Y VISTAS
-- ==============================================================

-- Vista de asignaciones activas actuales
CREATE VIEW core.v_asignaciones_activas AS
SELECT 
    ar.id_asignacion,
    ar.id_persona,
    p.nombres_persona || ' ' || p.apellidos_persona AS nombre_completo_persona,
    p.numero_documento_persona,
    p.correo_electronico,
    
    ar.id_tipo_rol,
    tr.codigo_rol,
    tr.nombre_rol,
    tr.ambito_aplicacion,
    tr.nivel_jerarquico,
    
    ar.cargo_especifico,
    ar.fecha_inicio_vigencia,
    ar.fecha_fin_vigencia,
    ar.porcentaje_dedicacion,
    ar.es_titular,
    ar.estado_asignacion,
    
    -- Identificar la entidad asignada
    CASE 
        WHEN ar.id_empresa IS NOT NULL THEN 'EMPRESA'
        WHEN ar.id_sede_campus IS NOT NULL THEN 'SEDE_CAMPUS'
        WHEN ar.id_unidad_academica IS NOT NULL THEN 'UNIDAD_ACADEMICA'
        WHEN ar.id_unidad_administrativa IS NOT NULL THEN 'UNIDAD_ADMINISTRATIVA'
        WHEN ar.id_subunidad_administrativa IS NOT NULL THEN 'SUBUNIDAD_ADMINISTRATIVA'
        WHEN ar.id_programa_academico IS NOT NULL THEN 'PROGRAMA_ACADEMICO'
        WHEN ar.id_grupo_investigacion IS NOT NULL THEN 'GRUPO_INVESTIGACION'
        WHEN ar.id_programa IS NOT NULL THEN 'PROGRAMA'
        WHEN ar.id_proyecto IS NOT NULL THEN 'PROYECTO'
        WHEN ar.id_ag_o_pe IS NOT NULL THEN 'AG_O_PE'
        WHEN ar.id_asunto_trabajo IS NOT NULL THEN 'ASUNTO_TRABAJO'
        WHEN ar.id_mapa_conocimiento IS NOT NULL THEN 'MAPA_CONOCIMIENTO'
        WHEN ar.id_actividad IS NOT NULL THEN 'ACTIVIDAD'
        WHEN ar.id_subactividad IS NOT NULL THEN 'SUBACTIVIDAD'
        WHEN ar.id_etapa_asunto_trabajo IS NOT NULL THEN 'ETAPA_ASUNTO_TRABAJO'
        WHEN ar.id_emprendimiento IS NOT NULL THEN 'EMPRENDIMIENTO'
        WHEN ar.id_dimension_emprendimiento IS NOT NULL THEN 'DIMENSION_EMPRENDIMIENTO'
    END AS tipo_entidad,
    
    -- ID de la entidad
    COALESCE(
        ar.id_empresa,
        ar.id_sede_campus,
        ar.id_unidad_academica,
        ar.id_unidad_administrativa,
        ar.id_subunidad_administrativa,
        ar.id_programa_academico,
        ar.id_grupo_investigacion,
        ar.id_programa,
        ar.id_proyecto,
        ar.id_ag_o_pe,
        ar.id_asunto_trabajo,
        ar.id_mapa_conocimiento,
        ar.id_actividad,
        ar.id_subactividad,
        ar.id_etapa_asunto_trabajo,
        ar.id_emprendimiento,
        ar.id_dimension_emprendimiento
    ) AS id_entidad,
    
    -- Nombre de la entidad (usando LEFT JOINs para obtener nombres)
    COALESCE(
        e.nombre_empresa,
        sc.nombre_sede_campus,
        ua.nombre_unidad_academica,
        uad.nombre_unidad_administrativa,
        sua.nombre_subunidad,
        pa.titulo_programa_academico,
        gi.nombre_grupo_investigacion,
        prg.nombre_programa,
        pry.nombre_proyecto,
        aop.nombre_ag_o_pe,
        att.nombre_asunto_trabajo,
        mcp.nombre_proceso,
        am.nombre_actividad,
        sp.nombre_subactividad_producto,
        eat.nombre_etapa_asunto_trabajo_proyecto_actividad,
        emp.idea_negocio,
        de.nombre_dimension_emprendimiento
    ) AS nombre_entidad
    
FROM core.asignacion_rol ar
INNER JOIN persona p ON ar.id_persona = p.id_persona
INNER JOIN core.tipo_rol tr ON ar.id_tipo_rol = tr.id_tipo_rol

-- LEFT JOINs para obtener nombres de entidades
LEFT JOIN empresa e ON ar.id_empresa = e.id_empresa
LEFT JOIN sede_campus sc ON ar.id_sede_campus = sc.id_sede_campus
LEFT JOIN unidad_academica ua ON ar.id_unidad_academica = ua.id_unidad_academica
LEFT JOIN unidad_administrativa uad ON ar.id_unidad_administrativa = uad.id_unidad_administrativa
LEFT JOIN subunidad_administrativa sua ON ar.id_subunidad_administrativa = sua.id_subunidad_administrativa
LEFT JOIN programa_academico pa ON ar.id_programa_academico = pa.id_programa_academico
LEFT JOIN grupo_investigacion gi ON ar.id_grupo_investigacion = gi.id_grupo_investigacion
LEFT JOIN programa prg ON ar.id_programa = prg.id_programa
LEFT JOIN proyecto pry ON ar.id_proyecto = pry.id_proyecto
LEFT JOIN ag_o_pe aop ON ar.id_ag_o_pe = aop.id_ag_o_pe
LEFT JOIN asunto_de_trabajo_tipo_emprendimiento att ON ar.id_asunto_trabajo = att.id_asunto_trabajo
LEFT JOIN mapa_conocimiento_proceso mcp ON ar.id_mapa_conocimiento = mcp.id_mapa_conocimiento
LEFT JOIN actividad_momento am ON ar.id_actividad = am.id_actividad
LEFT JOIN subactividad_producto sp ON ar.id_subactividad = sp.id_subactividad
LEFT JOIN etapa_asunto_trabajo_proyecto_actividad eat ON ar.id_etapa_asunto_trabajo = eat.id_etapa_asunto_trabajo_proyecto_actividad
LEFT JOIN emprendimiento emp ON ar.id_emprendimiento = emp.id_emprendimiento
LEFT JOIN dimension_emprendimiento de ON ar.id_dimension_emprendimiento = de.id_dimension_emprendimiento

WHERE ar.activo = TRUE
  AND ar.estado_asignacion = 'ACTIVA'
  AND (ar.fecha_fin_vigencia IS NULL OR ar.fecha_fin_vigencia >= CURRENT_DATE);

COMMENT ON VIEW core.v_asignaciones_activas IS 'Vista consolidada de todas las asignaciones activas con información completa de personas, roles y entidades.';

-- Vista para matriz de responsabilidades (RACI)
CREATE VIEW core.v_matriz_responsabilidades AS
WITH asignaciones_expandidas AS (
    SELECT 
        ar.*,
        tr.nombre_rol,
        tr.nivel_autoridad,
        p.nombres_persona || ' ' || p.apellidos_persona AS nombre_persona
    FROM core.asignacion_rol ar
    JOIN core.tipo_rol tr ON ar.id_tipo_rol = tr.id_tipo_rol
    JOIN persona p ON ar.id_persona = p.id_persona
    WHERE ar.activo = TRUE 
      AND ar.estado_asignacion = 'ACTIVA'
      AND (ar.fecha_fin_vigencia IS NULL OR ar.fecha_fin_vigencia >= CURRENT_DATE)
)
SELECT 
    CASE 
        WHEN id_proyecto IS NOT NULL THEN 'PROYECTO'
        WHEN id_programa IS NOT NULL THEN 'PROGRAMA'
        WHEN id_actividad IS NOT NULL THEN 'ACTIVIDAD'
        ELSE 'OTRO'
    END AS tipo_elemento,
    
    COALESCE(id_proyecto, id_programa, id_actividad) AS id_elemento,
    
    id_persona,
    nombre_persona,
    nombre_rol,
    
    CASE 
        WHEN nivel_autoridad >= 8 THEN 'Accountable'  -- Responsable final
        WHEN nivel_autoridad >= 6 AND es_titular THEN 'Responsible'  -- Ejecutor
        WHEN nivel_autoridad >= 4 THEN 'Consulted'  -- Consultado
        ELSE 'Informed'  -- Informado
    END AS tipo_responsabilidad_raci,
    
    porcentaje_dedicacion,
    fecha_inicio_vigencia,
    fecha_fin_vigencia
    
FROM asignaciones_expandidas
WHERE id_proyecto IS NOT NULL 
   OR id_programa IS NOT NULL 
   OR id_actividad IS NOT NULL;

COMMENT ON VIEW core.v_matriz_responsabilidades IS 'Matriz RACI (Responsible, Accountable, Consulted, Informed) para proyectos, programas y actividades.';

-- Vista materializada para performance: Carga de trabajo por persona
CREATE MATERIALIZED VIEW core.mv_carga_trabajo AS
SELECT 
    ar.id_persona,
    p.nombres_persona || ' ' || p.apellidos_persona AS nombre_completo,
    COUNT(DISTINCT ar.id_asignacion) AS total_asignaciones,
    COUNT(DISTINCT ar.id_proyecto) AS proyectos_activos,
    COUNT(DISTINCT ar.id_programa) AS programas_activos,
    SUM(ar.porcentaje_dedicacion) AS dedicacion_total_porcentaje,
    SUM(ar.horas_semanales) AS horas_semanales_totales,
    
    CASE 
        WHEN SUM(ar.porcentaje_dedicacion) > 120 THEN 'SOBRECARGADO'
        WHEN SUM(ar.porcentaje_dedicacion) > 100 THEN 'ALTO'
        WHEN SUM(ar.porcentaje_dedicacion) > 80 THEN 'NORMAL'
        WHEN SUM(ar.porcentaje_dedicacion) > 50 THEN 'MEDIO'
        ELSE 'BAJO'
    END AS nivel_carga,
    
    MAX(ar.fecha_actualizacion) AS ultima_actualizacion
    
FROM core.asignacion_rol ar
JOIN persona p ON ar.id_persona = p.id_persona
WHERE ar.activo = TRUE 
  AND ar.estado_asignacion = 'ACTIVA'
  AND (ar.fecha_fin_vigencia IS NULL OR ar.fecha_fin_vigencia >= CURRENT_DATE)
GROUP BY ar.id_persona, p.nombres_persona, p.apellidos_persona;

-- Índice único para refresh concurrente
CREATE UNIQUE INDEX idx_mv_carga_trabajo_persona ON core.mv_carga_trabajo(id_persona);

COMMENT ON MATERIALIZED VIEW core.mv_carga_trabajo IS 'Vista materializada con la carga de trabajo actual de cada persona. Se debe refrescar periódicamente.';

-- ==============================================================
-- FASE 4: FUNCIONES Y PROCEDIMIENTOS ALMACENADOS
-- ==============================================================

-- Función para asignar un rol
CREATE OR REPLACE FUNCTION core.fn_asignar_rol(
    p_id_persona INTEGER,
    p_id_tipo_rol INTEGER,
    p_id_entidad INTEGER,
    p_tipo_entidad VARCHAR(50),
    p_cargo_especifico VARCHAR(200) DEFAULT NULL,
    p_fecha_inicio DATE DEFAULT CURRENT_DATE,
    p_fecha_fin DATE DEFAULT NULL,
    p_porcentaje_dedicacion DECIMAL(5,2) DEFAULT 100.00,
    p_es_titular BOOLEAN DEFAULT TRUE,
    p_asignado_por INTEGER DEFAULT NULL,
    p_observaciones TEXT DEFAULT NULL
) RETURNS BIGINT AS $$
DECLARE
    v_id_asignacion BIGINT;
    v_permite_multiple BOOLEAN;
    v_requiere_aprobacion BOOLEAN;
    v_sql TEXT;
BEGIN
    -- Validar que el tipo de rol existe y está activo
    SELECT permite_multiple, requiere_aprobacion 
    INTO v_permite_multiple, v_requiere_aprobacion
    FROM core.tipo_rol 
    WHERE id_tipo_rol = p_id_tipo_rol AND activo = TRUE;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Tipo de rol % no existe o no está activo', p_id_tipo_rol;
    END IF;
    
    -- Validar que no hay asignaciones duplicadas si no permite múltiple
    IF NOT v_permite_multiple THEN
        PERFORM 1 
        FROM core.asignacion_rol 
        WHERE id_persona = p_id_persona 
          AND id_tipo_rol = p_id_tipo_rol 
          AND activo = TRUE 
          AND estado_asignacion = 'ACTIVA'
          AND (fecha_fin_vigencia IS NULL OR fecha_fin_vigencia >= CURRENT_DATE);
        
        IF FOUND THEN
            RAISE EXCEPTION 'La persona ya tiene una asignación activa de este rol y no permite múltiples asignaciones';
        END IF;
    END IF;
    
    -- Construir INSERT dinámico según el tipo de entidad
    v_sql := format('
        INSERT INTO core.asignacion_rol (
            id_persona, id_tipo_rol, %I, 
            cargo_especifico, fecha_inicio_vigencia, fecha_fin_vigencia,
            porcentaje_dedicacion, es_titular, estado_asignacion,
            requiere_aprobacion, asignado_por, observaciones
        ) VALUES (
            $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12
        ) RETURNING id_asignacion',
        'id_' || lower(p_tipo_entidad)
    );
    
    EXECUTE v_sql 
    INTO v_id_asignacion
    USING 
        p_id_persona, 
        p_id_tipo_rol, 
        p_id_entidad,
        p_cargo_especifico, 
        p_fecha_inicio, 
        p_fecha_fin,
        p_porcentaje_dedicacion, 
        p_es_titular,
        CASE WHEN v_requiere_aprobacion THEN 'PENDIENTE'::ESTADO_ASIGNACION_ENUM 
             ELSE 'ACTIVA'::ESTADO_ASIGNACION_ENUM END,
        v_requiere_aprobacion,
        COALESCE(p_asignado_por, p_id_persona),
        p_observaciones;
    
    -- Registrar en el historial
    INSERT INTO audit.historial_asignacion_rol (
        id_asignacion, tipo_cambio, estado_anterior, estado_nuevo, 
        campos_modificados, usuario_cambio
    )
    SELECT 
        v_id_asignacion,
        'CREATE',
        '{}'::jsonb,
        row_to_json(ar)::jsonb,
        ARRAY['*'],
        COALESCE(p_asignado_por, p_id_persona)
    FROM core.asignacion_rol ar
    WHERE ar.id_asignacion = v_id_asignacion;
    
    RETURN v_id_asignacion;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION core.fn_asignar_rol IS 'Función para asignar un rol a una persona en una entidad específica con validaciones de negocio.';

-- Función para transferir un rol a otra persona
CREATE OR REPLACE FUNCTION core.fn_transferir_rol(
    p_id_asignacion_origen BIGINT,
    p_id_persona_destino INTEGER,
    p_fecha_transferencia DATE DEFAULT CURRENT_DATE,
    p_transferido_por INTEGER DEFAULT NULL,
    p_motivo TEXT DEFAULT NULL
) RETURNS BIGINT AS $$
DECLARE
    v_asignacion_origen RECORD;
    v_id_asignacion_nueva BIGINT;
BEGIN
    -- Obtener datos de la asignación origen
    SELECT * INTO v_asignacion_origen
    FROM core.asignacion_rol
    WHERE id_asignacion = p_id_asignacion_origen 
      AND activo = TRUE
      AND estado_asignacion = 'ACTIVA';
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Asignación origen % no encontrada o no activa', p_id_asignacion_origen;
    END IF;
    
    -- Verificar que la persona destino existe
    PERFORM 1 FROM persona WHERE id_persona = p_id_persona_destino;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Persona destino % no encontrada', p_id_persona_destino;
    END IF;
    
    -- Iniciar transacción
    BEGIN
        -- Finalizar asignación origen
        UPDATE core.asignacion_rol
        SET fecha_fin_vigencia = p_fecha_transferencia - INTERVAL '1 day',
            fecha_fin_real = p_fecha_transferencia - INTERVAL '1 day',
            estado_asignacion = 'TRANSFERIDA',
            motivo_cambio = p_motivo,
            modificado_por = p_transferido_por,
            fecha_modificacion = CURRENT_TIMESTAMP
        WHERE id_asignacion = p_id_asignacion_origen;
        
        -- Crear nueva asignación
        INSERT INTO core.asignacion_rol (
            id_persona, id_tipo_rol,
            id_empresa, id_sede_campus, id_unidad_academica, id_unidad_administrativa,
            id_subunidad_administrativa, id_programa_academico, id_grupo_investigacion,
            id_programa, id_proyecto, id_ag_o_pe, id_asunto_trabajo,
            id_mapa_conocimiento, id_actividad, id_subactividad,
            id_etapa_asunto_trabajo, id_emprendimiento, id_dimension_emprendimiento,
            cargo_especifico, descripcion_responsabilidades,
            fecha_inicio_vigencia, porcentaje_dedicacion, horas_semanales,
            es_titular, es_adhonorem, es_interino, estado_asignacion,
            delegado_de, asignado_por, observaciones
        )
        SELECT 
            p_id_persona_destino, id_tipo_rol,
            id_empresa, id_sede_campus, id_unidad_academica, id_unidad_administrativa,
            id_subunidad_administrativa, id_programa_academico, id_grupo_investigacion,
            id_programa, id_proyecto, id_ag_o_pe, id_asunto_trabajo,
            id_mapa_conocimiento, id_actividad, id_subactividad,
            id_etapa_asunto_trabajo, id_emprendimiento, id_dimension_emprendimiento,
            cargo_especifico, descripcion_responsabilidades,
            p_fecha_transferencia, porcentaje_dedicacion, horas_semanales,
            es_titular, es_adhonorem, es_interino, 'ACTIVA'::ESTADO_ASIGNACION_ENUM,
            p_id_asignacion_origen, COALESCE(p_transferido_por, p_id_persona_destino),
            'Transferido desde asignación #' || p_id_asignacion_origen || '. ' || COALESCE(p_motivo, '')
        FROM core.asignacion_rol
        WHERE id_asignacion = p_id_asignacion_origen
        RETURNING id_asignacion INTO v_id_asignacion_nueva;
        
        -- Actualizar referencia de transferencia
        UPDATE core.asignacion_rol
        SET transferido_a = v_id_asignacion_nueva
        WHERE id_asignacion = p_id_asignacion_origen;
        
        -- Registrar en historial
        INSERT INTO audit.historial_asignacion_rol (
            id_asignacion, tipo_cambio, estado_anterior, estado_nuevo,
            campos_modificados, usuario_cambio, descripcion_cambio
        )
        VALUES 
        (p_id_asignacion_origen, 'TRANSFER_OUT', 
         row_to_json(v_asignacion_origen)::jsonb, 
         (SELECT row_to_json(ar)::jsonb FROM core.asignacion_rol ar WHERE ar.id_asignacion = p_id_asignacion_origen),
         ARRAY['estado_asignacion', 'fecha_fin_vigencia', 'transferido_a'],
         COALESCE(p_transferido_por, p_id_persona_destino),
         'Transferencia a persona ID: ' || p_id_persona_destino),
        (v_id_asignacion_nueva, 'TRANSFER_IN',
         '{}'::jsonb,
         (SELECT row_to_json(ar)::jsonb FROM core.asignacion_rol ar WHERE ar.id_asignacion = v_id_asignacion_nueva),
         ARRAY['*'],
         COALESCE(p_transferido_por, p_id_persona_destino),
         'Transferencia desde asignación ID: ' || p_id_asignacion_origen);
        
        RETURN v_id_asignacion_nueva;
    END;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION core.fn_transferir_rol IS 'Transfiere un rol de una persona a otra manteniendo la trazabilidad completa.';

-- Función para obtener el organigrama de una entidad
CREATE OR REPLACE FUNCTION core.fn_obtener_organigrama(
    p_tipo_entidad VARCHAR(50),
    p_id_entidad INTEGER
) RETURNS TABLE (
    nivel INTEGER,
    id_persona INTEGER,
    nombre_persona TEXT,
    id_tipo_rol INTEGER,
    nombre_rol VARCHAR(100),
    cargo_especifico VARCHAR(200),
    id_jefe INTEGER,
    nombre_jefe TEXT
) AS $$
BEGIN
    RETURN QUERY
    WITH RECURSIVE organigrama AS (
        -- Nivel 0: Rol más alto de la entidad
        SELECT 
            0 AS nivel,
            ar.id_persona,
            p.nombres_persona || ' ' || p.apellidos_persona AS nombre_persona,
            ar.id_tipo_rol,
            tr.nombre_rol,
            ar.cargo_especifico,
            CAST(NULL AS INTEGER) AS id_jefe,
            CAST(NULL AS TEXT) AS nombre_jefe
        FROM core.asignacion_rol ar
        JOIN persona p ON ar.id_persona = p.id_persona
        JOIN core.tipo_rol tr ON ar.id_tipo_rol = tr.id_tipo_rol
        WHERE ar.activo = TRUE
          AND ar.estado_asignacion = 'ACTIVA'
          AND (ar.fecha_fin_vigencia IS NULL OR ar.fecha_fin_vigencia >= CURRENT_DATE)
          AND CASE p_tipo_entidad
                WHEN 'EMPRESA' THEN ar.id_empresa = p_id_entidad
                WHEN 'UNIDAD_ACADEMICA' THEN ar.id_unidad_academica = p_id_entidad
                WHEN 'PROYECTO' THEN ar.id_proyecto = p_id_entidad
                -- Agregar más casos según necesidad
                ELSE FALSE
              END
          AND tr.id_rol_superior IS NULL  -- Rol más alto
        
        UNION ALL
        
        -- Niveles siguientes: Roles subordinados
        SELECT 
            o.nivel + 1,
            ar.id_persona,
            p.nombres_persona || ' ' || p.apellidos_persona,
            ar.id_tipo_rol,
            tr.nombre_rol,
            ar.cargo_especifico,
            o.id_persona,
            o.nombre_persona
        FROM organigrama o
        JOIN core.tipo_rol tr_sup ON o.id_tipo_rol = tr_sup.id_tipo_rol
        JOIN core.tipo_rol tr ON tr.id_rol_superior = tr_sup.id_tipo_rol
        JOIN core.asignacion_rol ar ON ar.id_tipo_rol = tr.id_tipo_rol
        JOIN persona p ON ar.id_persona = p.id_persona
        WHERE ar.activo = TRUE
          AND ar.estado_asignacion = 'ACTIVA'
          AND (ar.fecha_fin_vigencia IS NULL OR ar.fecha_fin_vigencia >= CURRENT_DATE)
          AND CASE p_tipo_entidad
                WHEN 'EMPRESA' THEN ar.id_empresa = p_id_entidad
                WHEN 'UNIDAD_ACADEMICA' THEN ar.id_unidad_academica = p_id_entidad
                WHEN 'PROYECTO' THEN ar.id_proyecto = p_id_entidad
                ELSE FALSE
              END
    )
    SELECT * FROM organigrama ORDER BY nivel, nombre_rol;
END;
$$ LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION core.fn_obtener_organigrama IS 'Genera el organigrama jerárquico de una entidad mostrando la estructura de roles.';

-- ==============================================================
-- FASE 5: TRIGGERS PARA VALIDACIONES Y AUDITORÍA
-- ==============================================================

-- Trigger para validar porcentaje de dedicación total
CREATE OR REPLACE FUNCTION core.trg_validar_dedicacion_total() 
RETURNS TRIGGER AS $$
DECLARE
    v_dedicacion_actual DECIMAL(5,2);
    v_dedicacion_maxima DECIMAL(5,2) := 150.00;  -- Permitir hasta 150% (horas extra)
BEGIN
    -- Solo validar si es INSERT o UPDATE con cambio en dedicación
    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;
    
    IF NEW.estado_asignacion != 'ACTIVA' THEN
        RETURN NEW;
    END IF;
    
    -- Calcular dedicación total actual
    SELECT COALESCE(SUM(porcentaje_dedicacion), 0)
    INTO v_dedicacion_actual
    FROM core.asignacion_rol
    WHERE id_persona = NEW.id_persona
      AND id_asignacion != NEW.id_asignacion
      AND activo = TRUE
      AND estado_asignacion = 'ACTIVA'
      AND (fecha_fin_vigencia IS NULL OR fecha_fin_vigencia >= CURRENT_DATE)
      AND (
        (NEW.fecha_inicio_vigencia BETWEEN fecha_inicio_vigencia AND COALESCE(fecha_fin_vigencia, '9999-12-31')) OR
        (NEW.fecha_fin_vigencia IS NOT NULL AND NEW.fecha_fin_vigencia BETWEEN fecha_inicio_vigencia AND COALESCE(fecha_fin_vigencia, '9999-12-31')) OR
        (fecha_inicio_vigencia BETWEEN NEW.fecha_inicio_vigencia AND COALESCE(NEW.fecha_fin_vigencia, '9999-12-31'))
      );
    
    -- Validar que no exceda el máximo
    IF (v_dedicacion_actual + NEW.porcentaje_dedicacion) > v_dedicacion_maxima THEN
        RAISE WARNING 'La dedicación total (%) excederá el máximo permitido (%). Actual: %, Nueva: %',
            v_dedicacion_actual + NEW.porcentaje_dedicacion,
            v_dedicacion_maxima,
            v_dedicacion_actual,
            NEW.porcentaje_dedicacion;
        -- Podríamos convertir esto en EXCEPTION para bloquear
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_dedicacion
    BEFORE INSERT OR UPDATE ON core.asignacion_rol
    FOR EACH ROW
    EXECUTE FUNCTION core.trg_validar_dedicacion_total();

-- Trigger para auditoría automática
CREATE OR REPLACE FUNCTION core.trg_auditar_asignacion() 
RETURNS TRIGGER AS $$
DECLARE
    v_campos_modificados TEXT[];
    v_campo TEXT;
BEGIN
    IF TG_OP = 'UPDATE' THEN
        -- Incrementar versión
        NEW.version = OLD.version + 1;
        NEW.fecha_modificacion = CURRENT_TIMESTAMP;
        
        -- Identificar campos modificados
        v_campos_modificados := ARRAY[]::TEXT[];
        
        -- Comparar cada campo relevante
        IF OLD.id_persona IS DISTINCT FROM NEW.id_persona THEN
            v_campos_modificados := array_append(v_campos_modificados, 'id_persona');
        END IF;
        IF OLD.id_tipo_rol IS DISTINCT FROM NEW.id_tipo_rol THEN
            v_campos_modificados := array_append(v_campos_modificados, 'id_tipo_rol');
        END IF;
        IF OLD.cargo_especifico IS DISTINCT FROM NEW.cargo_especifico THEN
            v_campos_modificados := array_append(v_campos_modificados, 'cargo_especifico');
        END IF;
        IF OLD.fecha_inicio_vigencia IS DISTINCT FROM NEW.fecha_inicio_vigencia THEN
            v_campos_modificados := array_append(v_campos_modificados, 'fecha_inicio_vigencia');
        END IF;
        IF OLD.fecha_fin_vigencia IS DISTINCT FROM NEW.fecha_fin_vigencia THEN
            v_campos_modificados := array_append(v_campos_modificados, 'fecha_fin_vigencia');
        END IF;
        IF OLD.porcentaje_dedicacion IS DISTINCT FROM NEW.porcentaje_dedicacion THEN
            v_campos_modificados := array_append(v_campos_modificados, 'porcentaje_dedicacion');
        END IF;
        IF OLD.estado_asignacion IS DISTINCT FROM NEW.estado_asignacion THEN
            v_campos_modificados := array_append(v_campos_modificados, 'estado_asignacion');
        END IF;
        
        -- Solo registrar si hubo cambios
        IF array_length(v_campos_modificados, 1) > 0 THEN
            INSERT INTO audit.historial_asignacion_rol (
                id_asignacion, tipo_cambio, estado_anterior, estado_nuevo,
                campos_modificados, usuario_cambio
            ) VALUES (
                NEW.id_asignacion,
                'UPDATE',
                row_to_json(OLD)::jsonb,
                row_to_json(NEW)::jsonb,
                v_campos_modificados,
                COALESCE(NEW.modificado_por, NEW.asignado_por)
            );
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_auditar_cambios
    AFTER UPDATE ON core.asignacion_rol
    FOR EACH ROW
    EXECUTE FUNCTION core.trg_auditar_asignacion();

-- Trigger para soft delete
CREATE OR REPLACE FUNCTION core.trg_soft_delete_asignacion() 
RETURNS TRIGGER AS $$
BEGIN
    -- En lugar de eliminar, marcar como inactivo
    UPDATE core.asignacion_rol
    SET activo = FALSE,
        fecha_eliminacion = CURRENT_TIMESTAMP,
        eliminado_por = COALESCE(NEW.eliminado_por, NEW.modificado_por, NEW.asignado_por),
        estado_asignacion = 'CANCELADA'
    WHERE id_asignacion = OLD.id_asignacion;
    
    -- Registrar en historial
    INSERT INTO audit.historial_asignacion_rol (
        id_asignacion, tipo_cambio, estado_anterior, estado_nuevo,
        campos_modificados, usuario_cambio, descripcion_cambio
    ) VALUES (
        OLD.id_asignacion,
        'DELETE',
        row_to_json(OLD)::jsonb,
        '{}'::jsonb,
        ARRAY['activo', 'estado_asignacion'],
        COALESCE(OLD.eliminado_por, OLD.modificado_por, OLD.asignado_por),
        'Eliminación lógica del registro'
    );
    
    -- Prevenir la eliminación física
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevenir_delete
    BEFORE DELETE ON core.asignacion_rol
    FOR EACH ROW
    EXECUTE FUNCTION core.trg_soft_delete_asignacion();

-- ==============================================================
-- FASE 6: DATOS INICIALES Y MIGRACIÓN
-- ==============================================================

-- Insertar tipos de roles iniciales
INSERT INTO core.tipo_rol (
    codigo_rol, nombre_rol, nombre_corto_rol, descripcion_rol,
    ambito_aplicacion, nivel_jerarquico, nivel_autoridad,
    permite_multiple, requiere_aprobacion, duracion_tipica_dias
) VALUES 
-- Roles Académicos
('RECTOR', 'Rector', 'Rector', 'Máxima autoridad académica de la institución', 
 'ACADEMICO', 'ESTRATEGICO', 10, FALSE, TRUE, NULL),

('VICERRECTOR', 'Vicerrector', 'Vicerrector', 'Segunda autoridad académica', 
 'ACADEMICO', 'ESTRATEGICO', 9, FALSE, TRUE, NULL),

('DECANO', 'Decano', 'Decano', 'Director de facultad o unidad académica', 
 'ACADEMICO', 'ESTRATEGICO', 8, FALSE, TRUE, 1460),

('VICEDECANO', 'Vicedecano', 'Vicedecano', 'Subdirector de facultad', 
 'ACADEMICO', 'TACTICO', 7, FALSE, TRUE, 1460),

('DIRECTOR_PROGRAMA', 'Director de Programa', 'Dir. Programa', 'Responsable de programa académico', 
 'ACADEMICO', 'TACTICO', 6, FALSE, TRUE, 1095),

('COORDINADOR_AREA', 'Coordinador de Área', 'Coord. Área', 'Coordinador de área académica', 
 'ACADEMICO', 'TACTICO', 5, TRUE, FALSE, 730),

('PROFESOR', 'Profesor', 'Prof.', 'Docente o catedrático', 
 'ACADEMICO', 'OPERATIVO', 3, TRUE, FALSE, 180),

('INVESTIGADOR_PRINCIPAL', 'Investigador Principal', 'IP', 'Líder de grupo de investigación', 
 'INVESTIGACION', 'TACTICO', 6, FALSE, TRUE, 1095),

('COINVESTIGADOR', 'Co-investigador', 'Co-Inv', 'Miembro del equipo de investigación', 
 'INVESTIGACION', 'OPERATIVO', 4, TRUE, FALSE, 365),

-- Roles Administrativos
('DIRECTOR_ADMINISTRATIVO', 'Director Administrativo', 'Dir. Admin', 'Director de unidad administrativa', 
 'ADMINISTRATIVO', 'ESTRATEGICO', 7, FALSE, TRUE, 1460),

('JEFE_DEPARTAMENTO', 'Jefe de Departamento', 'Jefe Depto', 'Responsable de departamento administrativo', 
 'ADMINISTRATIVO', 'TACTICO', 6, FALSE, TRUE, 1095),

('COORDINADOR_ADMINISTRATIVO', 'Coordinador Administrativo', 'Coord. Admin', 'Coordinador de procesos administrativos', 
 'ADMINISTRATIVO', 'TACTICO', 5, TRUE, FALSE, 730),

('ASISTENTE_ADMINISTRATIVO', 'Asistente Administrativo', 'Asist. Admin', 'Personal de apoyo administrativo', 
 'ADMINISTRATIVO', 'OPERATIVO', 2, TRUE, FALSE, 365),

-- Roles de Proyecto
('DIRECTOR_PROYECTO', 'Director de Proyecto', 'Dir. Proyecto', 'Máximo responsable del proyecto', 
 'PROYECTO', 'ESTRATEGICO', 8, FALSE, TRUE, NULL),

('LIDER_PROYECTO', 'Líder de Proyecto', 'Líder Proy.', 'Gestor operativo del proyecto', 
 'PROYECTO', 'TACTICO', 6, FALSE, TRUE, NULL),

('COORDINADOR_PROYECTO', 'Coordinador de Proyecto', 'Coord. Proy.', 'Coordinador de actividades del proyecto', 
 'PROYECTO', 'TACTICO', 5, TRUE, FALSE, NULL),

('MIEMBRO_PROYECTO', 'Miembro de Proyecto', 'Miembro', 'Integrante del equipo de proyecto', 
 'PROYECTO', 'OPERATIVO', 3, TRUE, FALSE, NULL),

-- Roles de Programa
('DIRECTOR_PROGRAMA', 'Director de Programa', 'Dir. Programa', 'Responsable estratégico del