-- Creación de la base de datos
CREATE DATABASE innovacion;

-- Conexión a la base de datos
\c innovacion;

-- Enumerados para tipos específicos
CREATE TYPE SEXO_ENUM AS ENUM ('Masculino', 'Femenino', 'Otro');
CREATE TYPE GENERO_ENUM AS ENUM ('Hombre', 'Mujer', 'No binario', 'Prefiero no decirlo');
CREATE TYPE CATEGORIA_EMPRESA_ENUM AS ENUM ('Microempresa', 'Pequeña empresa', 'Mediana empresa', 'Gran empresa');
CREATE TYPE ZONA_EMPRESA_ENUM AS ENUM ('Urbana', 'Rural', 'Periurbana');
CREATE TYPE SECTOR_EMPRESA_ENUM AS ENUM ('Tecnología', 'Comercio', 'Servicios', 'Industria', 'Agricultura');
CREATE TYPE TIPO_EMPRESA_ENUM AS ENUM ('Tecnología', 'Comercio', 'Servicios', 'Industria', 'Agricultura');
CREATE TYPE ROL_ENUM AS ENUM ('Empleado', 'Gerente', 'Socio', 'Fundador', 'Inversionista');
CREATE TYPE TIPO_VINCULO_UNIDAD_IE_ENUM AS ENUM ('Facultad', 'Instituto', 'Escuela', 'Centro de Investigación');
CREATE TYPE TIPO_UBICACION_UNIDAD_IE_ENUM AS ENUM ('Urbana', 'Rural');
CREATE TYPE NIVEL_PROGRAMA_ACADEMICO_ENUM AS ENUM ('Pregrado', 'Maestría', 'Doctorado');
CREATE TYPE AREA_PROGRAMA_ACADEMICO_ENUM AS ENUM ('Ingeniería', 'Ciencias Sociales', 'Ciencias Naturales', 'Artes', 'Humanidades');
CREATE TYPE ESTADO_ACADEMICO_ENUM AS ENUM ('En curso', 'Graduado', 'Retirado');

-- Tabla persona
CREATE TABLE persona (
    id_persona                   SERIAL PRIMARY KEY,
    nombres_persona              VARCHAR(100) NOT NULL,
    apellidos_persona            VARCHAR(100) NOT NULL,
    tipo_documento_persona       VARCHAR(20) NOT NULL,
    numero_documento_persona     VARCHAR(50) UNIQUE NOT NULL,
    sexo_biologico               SEXO_ENUM NOT NULL,
    genero                       GENERO_ENUM NOT NULL,
    telefono_celular             VARCHAR(20),
    correo_electronico           VARCHAR(100) UNIQUE NOT NULL,
    estrato_socioeconomico       INT CHECK (estrato_socioeconomico BETWEEN 1 AND 6),
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
    magnitud_empresa                  VARCHAR(100),  
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

    FOREIGN KEY (id_persona) REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_empresa) REFERENCES empresa (id_empresa) ON DELETE CASCADE ON UPDATE CASCADE
);

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

-- Índices compuestos para optimizar consultas
CREATE INDEX idx_relacion_persona_empresa ON relacion_empresa_persona (id_persona, id_empresa);
CREATE INDEX idx_correo_persona ON persona (correo_electronico);
CREATE INDEX idx_nombre_empresa ON empresa (nombre_empresa);