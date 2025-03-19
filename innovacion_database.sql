
-- Creacion de la base de datos
CREATE DATABASE innovacion;


-- Creacion de las tablas
CREATE TABLE persona (
    id_persona                   SERIAL PRIMARY KEY,
    nombres_persona              VARCHAR(100) NOT NULL,
    apellidos_persona            VARCHAR(100) NOT NULL,
    tipo_documento_persona       VARCHAR(20) NOT NULL,
    numero_documento_persona     VARCHAR(50) UNIQUE,
    sexo_biologico               VARCHAR(20) CHECK (sexo_biologico IN ('Masculino', 'Femenino', 'Otro')),
    genero                       VARCHAR(20) CHECK (genero IN ('Hombre', 'Mujer', 'No binario', 'Prefiero no decirlo')),
    telefono_celular             VARCHAR(20),
    correo_electronico           VARCHAR(100) UNIQUE,
    estrato_socioeconomico       INT,
    fecha_nacimiento_persona     DATE NOT NULL,
    es_emprendedor               BOOLEAN,   
    foto_persona_url             TEXT,              
    fecha_creacion_registro      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_ultima_actualizacion   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE empresa (
    id_empresa                        SERIAL PRIMARY KEY,
    nombre_empresa                    VARCHAR(100) NOT NULL UNIQUE,
    categoria_empresa                 VARCHAR(100) NOT NULL CHECK (categoria_empresa IN ('Microempresa', 'Pequeña empresa', 'Mediana empresa', 'Gran empresa'))
    zona_empresa                      VARCHAR(100), -- Hacer el CHECK
    sector_empresa                    VARCHAR(100), -- Hacer el CHECK
    magnitud_empresa                  VARCHAR(100),  
    tipo_empresa                      VARCHAR(50),
    naturaleza_juridica               VARCHAR(100),
    telefono_empresa                  VARCHAR(20),
    correo_empresa                    VARCHAR(100) UNIQUE NOT NULL,
    logo_empresa_url                  TEXT,
    es_emprendimiento                 BOOLEAN,
    pertenece_parque                  BOOLEAN,
    fecha_fundacion_empresa           DATE,
    fecha_creacion_empresa            TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ultima_actualizacion              TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_direccion                      INT, 

    FOREIGN KEY (id_direcion) REFERENCES direccion (id_dirrecion) ON DELETE CASCADE ON UPDATE CASCADE,

);

CREATE TABLE relacion_empresa_persona (
    id_rel_empresa_persona   SERIAL PRIMARY KEY,
    id_persona               INT NOT NULL,
    id_empresa               INT NOT NULL,
    rol                      VARCHAR(50) NOT NULL CHECK (rol IN ('Empleado', 'Gerente', 'Socio', 'Fundador', 'Inversionista'))

    FOREIGN KEY (id_persona) REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_empresa) REFERENCES empresa (id_empresa) ON DELETE CASCADE ON UPDATE CASCADE
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
    nombre_departamento       VARCHAR(100) NOT NULL,
    id_pais                   INT NOT NULL,

    FOREIGN KEY (id_pais) REFERENCES pais (id_pais) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE region (
    id_region                 SERIAL PRIMARY KEY,
    nombre_region             VARCHAR(100) NOT NULL,
    id_departamento           INT NOT NULL,

    FOREIGN KEY (id_departamento) REFERENCES departamento (id_departamento) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE ciudad (
    id_ciudad                 SERIAL PRIMARY KEY,
    nombre_ciudad             VARCHAR(100) NOT NULL,
    id_region                 INT NOT NULL,
    
    FOREIGN KEY (id_region) REFERENCES region (id_region) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE direccion (
    id_direccion              SERIAL PRIMARY KEY,
    calle                     VARCHAR(100) NOT NULL,
    numero                    VARCHAR(20),
    codigo_postal             VARCHAR(20),
    id_ciudad                 INT NOT NULL,

    FOREIGN KEY (id_ciudad) REFERENCES ciudad (id_ciudad) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Índices compuesto para optimizar consultas
CREATE INDEX idx_relacion_persona_empresa ON relacion_empresa_persona (id_persona, id_empresa);