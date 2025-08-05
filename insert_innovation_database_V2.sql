-- =============================================================
-- JERARQUÍA GEOGRÁFICA
-- =============================================================

-- pais
INSERT INTO pais (nombre_pais, codigo_iso2, codigo_iso3, codigo_numerico, url_polygon_pais) VALUES
 ('Colombia','CO','COL','170', NULL),
 ('Ecuador','EC','ECU','218', NULL),
 ('Perú','PE','PER','604', NULL)
ON CONFLICT DO NOTHING;

-- departamento
INSERT INTO departamento (nombre_departamento, codigo_departamento, url_polygon_departamento, id_pais) VALUES
 ('Antioquia','05', NULL, (SELECT id_pais FROM pais WHERE nombre_pais='Colombia')),
 ('Pichincha','17', NULL, (SELECT id_pais FROM pais WHERE nombre_pais='Ecuador')),
 ('Lima','15', NULL, (SELECT id_pais FROM pais WHERE nombre_pais='Perú'))
ON CONFLICT DO NOTHING;

-- region
INSERT INTO region (nombre_region, codigo_region, url_polygon_region, id_departamento) VALUES
 ('Valle de Aburrá','0501', NULL, (SELECT id_departamento FROM departamento d JOIN pais p ON p.id_pais=d.id_pais WHERE d.nombre_departamento='Antioquia' AND p.nombre_pais='Colombia')),
 ('Distrito Metropolitano de Quito','1701', NULL, (SELECT id_departamento FROM departamento d JOIN pais p ON p.id_pais=d.id_pais WHERE d.nombre_departamento='Pichincha' AND p.nombre_pais='Ecuador')),
 ('Lima Metropolitana','1501', NULL, (SELECT id_departamento FROM departamento d JOIN pais p ON p.id_pais=d.id_pais WHERE d.nombre_departamento='Lima' AND p.nombre_pais='Perú'))
ON CONFLICT DO NOTHING;

-- ciudad
INSERT INTO ciudad (nombre_ciudad, codigo_ciudad, url_polygon_ciudad, id_region) VALUES
 ('Medellín','05001', NULL, (SELECT id_region FROM region r JOIN departamento d ON d.id_departamento=r.id_departamento JOIN pais p ON p.id_pais=d.id_pais WHERE r.nombre_region='Valle de Aburrá' AND d.nombre_departamento='Antioquia' AND p.nombre_pais='Colombia')),
 ('Quito','17001', NULL, (SELECT id_region FROM region r JOIN departamento d ON d.id_departamento=r.id_departamento JOIN pais p ON p.id_pais=d.id_pais WHERE r.nombre_region='Distrito Metropolitano de Quito' AND d.nombre_departamento='Pichincha' AND p.nombre_pais='Ecuador')),
 ('Lima','15001', NULL, (SELECT id_region FROM region r JOIN departamento d ON d.id_departamento=r.id_departamento JOIN pais p ON p.id_pais=d.id_pais WHERE r.nombre_region='Lima Metropolitana' AND d.nombre_departamento='Lima' AND p.nombre_pais='Perú'))
ON CONFLICT DO NOTHING;

-- comuna
INSERT INTO comuna (nombre_comuna, codigo_comuna, url_polygon_comuna, id_ciudad) VALUES
 ('Comuna 10 - La Candelaria','10', NULL, (SELECT id_ciudad FROM ciudad c JOIN region r ON r.id_region=c.id_region WHERE c.nombre_ciudad='Medellín' AND r.nombre_region='Valle de Aburrá')),
 ('Comuna 11 - Laureles-Estadio','11', NULL, (SELECT id_ciudad FROM ciudad c JOIN region r ON r.id_region=c.id_region WHERE c.nombre_ciudad='Medellín' AND r.nombre_region='Valle de Aburrá')),
 ('Comuna 14 - El Poblado','14', NULL, (SELECT id_ciudad FROM ciudad c JOIN region r ON r.id_region=c.id_region WHERE c.nombre_ciudad='Medellín' AND r.nombre_region='Valle de Aburrá'))
ON CONFLICT DO NOTHING;

-- barrio
INSERT INTO barrio (nombre_barrio, codigo_barrio, url_polygon_barrio, id_comuna) VALUES
 ('La Candelaria Centro','1001', NULL, (SELECT id_comuna FROM comuna WHERE nombre_comuna='Comuna 10 - La Candelaria')),
 ('Laureles','1101', NULL, (SELECT id_comuna FROM comuna WHERE nombre_comuna='Comuna 11 - Laureles-Estadio')),
 ('El Poblado','1401', NULL, (SELECT id_comuna FROM comuna WHERE nombre_comuna='Comuna 14 - El Poblado'))
ON CONFLICT DO NOTHING;

-- direccion
INSERT INTO direccion (direccion_textual, codigo_postal, latitud, longitud, id_barrio) VALUES
 ('Calle 50 # 50-50', '050001', 6.244203, -75.581215, (SELECT id_barrio FROM barrio WHERE nombre_barrio='La Candelaria Centro')),
 ('Circular 2 # 70-30', '050021', 6.252500, -75.588000, (SELECT id_barrio FROM barrio WHERE nombre_barrio='Laureles')),
 ('Carrera 43A # 1-50', '050022', 6.205000, -75.565000, (SELECT id_barrio FROM barrio WHERE nombre_barrio='El Poblado'));

-- =============================================================
-- PERSONAS Y EMPRESAS
-- =============================================================

-- persona
INSERT INTO persona (nombres_persona, apellidos_persona, tipo_documento_persona, numero_documento_persona, sexo_biologico, genero, telefono_celular, correo_electronico, correo_alternativo, estrato_socioeconomico, fecha_nacimiento_persona, foto_persona_url, id_direccion)
VALUES
 ('Ana María','García López','Cédula de Ciudadanía (CC)','100000001','Femenino','Mujer','3001112233','ana.garcia@example.com','ana.alt@example.com','Estrato 4 (Medio)','1992-03-15',NULL,(SELECT id_direccion FROM direccion WHERE direccion_textual='Calle 50 # 50-50')),
 ('Carlos Andrés','Pérez Rojas','Cédula de Ciudadanía (CC)','100000002','Masculino','Hombre','3002223344','carlos.perez@example.com',NULL,'Estrato 3 (Medio-bajo)','1988-07-22',NULL,(SELECT id_direccion FROM direccion WHERE direccion_textual='Circular 2 # 70-30')),
 ('Valentina','Moreno Díaz','Pasaporte (P)','P123456789','Intersexual','No binario','3003334455','valentina.moreno@example.com',NULL,'Estrato 5 (Medio-alto)','1995-11-05',NULL,(SELECT id_direccion FROM direccion WHERE direccion_textual='Carrera 43A # 1-50'));

-- empresa
INSERT INTO empresa (nombre_empresa, nit_empresa, categoria_empresa, zona_empresa, tipo_empresa, magnitud_empresa, naturaleza_juridica, telefono, correo_empresa, sitio_web_url, descripcion_empresa, pertenece_parque, fecha_fundacion, numero_empleados)
VALUES
 ('TecnoAndes SAS','900111222','Microempresa','Urbana','Tecnología','Pequeña','SAS','6041111','contacto@tecnoandes.co','https://www.tecnoandes.co','Desarrollo de software y consultoría',TRUE,'2018-05-10',12),
 ('ComerLocal LTDA','900222333','Pequeña empresa','Urbana','Comercio','Mediana','LTDA','6042222','info@comerlocal.com','https://www.comerlocal.com','Marketplace de comercios locales',FALSE,'2016-03-01',45),
 ('SaludPlus SA','900333444','Mediana empresa','Periurbana','Servicios','Mediana','SA','6043333','contacto@saludplus.com','https://www.saludplus.com','Servicios de salud y bienestar',FALSE,'2014-09-20',120);

-- sede_campus
INSERT INTO sede_campus (nombre_sede_campus, tipo_ubicacion, es_sede_principal, telefono_sede, correo_sede, id_empresa, id_direccion)
VALUES
 ('Sede Principal TecnoAndes','Sede única', TRUE, '6041111','sede@tecnoandes.co',(SELECT id_empresa FROM empresa WHERE nombre_empresa='TecnoAndes SAS'), (SELECT id_direccion FROM direccion WHERE direccion_textual='Calle 50 # 50-50')),
 ('Sede Central ComerLocal','Sede', TRUE, '6042222','sede@comerlocal.com',(SELECT id_empresa FROM empresa WHERE nombre_empresa='ComerLocal LTDA'), (SELECT id_direccion FROM direccion WHERE direccion_textual='Circular 2 # 70-30')),
 ('Campus SaludPlus','Sede regional', TRUE, '6043333','campus@saludplus.com',(SELECT id_empresa FROM empresa WHERE nombre_empresa='SaludPlus SA'), (SELECT id_direccion FROM direccion WHERE direccion_textual='Carrera 43A # 1-50'));

-- relacion_empresa_persona
INSERT INTO relacion_empresa_persona (id_persona, id_empresa, rol, cargo, fecha_inicio, fecha_fin)
VALUES
 ((SELECT id_persona FROM persona WHERE correo_electronico='ana.garcia@example.com'), (SELECT id_empresa FROM empresa WHERE nombre_empresa='TecnoAndes SAS'),'Fundador','CTO','2019-01-15',NULL),
 ((SELECT id_persona FROM persona WHERE correo_electronico='carlos.perez@example.com'), (SELECT id_empresa FROM empresa WHERE nombre_empresa='ComerLocal LTDA'),'Gerente','COO','2020-02-01',NULL),
 ((SELECT id_persona FROM persona WHERE correo_electronico='valentina.moreno@example.com'), (SELECT id_empresa FROM empresa WHERE nombre_empresa='SaludPlus SA'),'Empleado','Analista','2021-03-10',NULL);

-- =============================================================
-- ESTRUCTURA ACADÉMICA
-- =============================================================

-- unidad_administrativa
INSERT INTO unidad_administrativa (nombre_unidad_administrativa, descripcion, id_sede_campus)
VALUES
 ('Gestión Administrativa TecnoAndes','Compras, presupuesto y soporte',(SELECT id_sede_campus FROM sede_campus WHERE nombre_sede_campus='Sede Principal TecnoAndes')),
 ('Operaciones ComerLocal','Logística y soporte a comercios',(SELECT id_sede_campus FROM sede_campus WHERE nombre_sede_campus='Sede Central ComerLocal')),
 ('Gestión Clínica SaludPlus','Administración de servicios clínicos',(SELECT id_sede_campus FROM sede_campus WHERE nombre_sede_campus='Campus SaludPlus'));

-- subunidad_administrativa
INSERT INTO subunidad_administrativa (nombre_subunidad, descripcion, id_unidad_administrativa)
VALUES
 ('Compras','Gestión de proveedores y adquisiciones',(SELECT id_unidad_administrativa FROM unidad_administrativa WHERE nombre_unidad_administrativa='Gestión Administrativa TecnoAndes')),
 ('Atención a Comercios','Soporte a tiendas asociadas',(SELECT id_unidad_administrativa FROM unidad_administrativa WHERE nombre_unidad_administrativa='Operaciones ComerLocal')),
 ('Urgencias','Coordinación de urgencias',(SELECT id_unidad_administrativa FROM unidad_administrativa WHERE nombre_unidad_administrativa='Gestión Clínica SaludPlus'));

-- unidad_academica
INSERT INTO unidad_academica (tipo_unidad_academica, nombre_unidad_academica, descripcion, id_sede_campus)
VALUES
 ('Facultad','Facultad de Ingeniería',NULL,(SELECT id_sede_campus FROM sede_campus WHERE nombre_sede_campus='Sede Principal TecnoAndes')),
 ('Escuela','Escuela de Negocios',NULL,(SELECT id_sede_campus FROM sede_campus WHERE nombre_sede_campus='Sede Central ComerLocal')),
 ('Instituto','Instituto de Salud Pública',NULL,(SELECT id_sede_campus FROM sede_campus WHERE nombre_sede_campus='Campus SaludPlus'));

-- programa_academico
INSERT INTO programa_academico (titulo_programa_academico, codigo_snies, nivel_programa_academico, area_programa_academico, id_unidad_academica)
VALUES
 ('Ingeniería de Software','12345','Profesional','Ingeniería',(SELECT id_unidad_academica FROM unidad_academica WHERE nombre_unidad_academica='Facultad de Ingeniería')),
 ('Administración de Empresas','67890','Tecnológico','Ciencias Económicas y Administrativas',(SELECT id_unidad_academica FROM unidad_academica WHERE nombre_unidad_academica='Escuela de Negocios')),
 ('Salud Pública','54321','Técnica profesional','Ciencias de la Salud',(SELECT id_unidad_academica FROM unidad_academica WHERE nombre_unidad_academica='Instituto de Salud Pública'));

-- grupo_investigacion
INSERT INTO grupo_investigacion (nombre_grupo_investigacion, codigo_colciencias, categoria_colciencias, lineas_investigacion, id_unidad_academica)
VALUES
 ('GID-Software','COL-001','A1','Ingeniería de software, IA',(SELECT id_unidad_academica FROM unidad_academica WHERE nombre_unidad_academica='Facultad de Ingeniería')),
 ('GIN-Negocios','COL-002','A','Emprendimiento, logística',(SELECT id_unidad_academica FROM unidad_academica WHERE nombre_unidad_academica='Escuela de Negocios')),
 ('GIS-Salud','COL-003','B','Epidemiología, política pública',(SELECT id_unidad_academica FROM unidad_academica WHERE nombre_unidad_academica='Instituto de Salud Pública'));

-- subunidad_administrativa_persona
INSERT INTO subunidad_administrativa_persona (id_subunidad_administrativa, id_persona, cargo, fecha_inicio, fecha_fin)
VALUES
 ((SELECT id_subunidad_administrativa FROM subunidad_administrativa WHERE nombre_subunidad='Compras'), (SELECT id_persona FROM persona WHERE correo_electronico='ana.garcia@example.com'),'Jefe de Compras','2022-01-01',NULL),
 ((SELECT id_subunidad_administrativa FROM subunidad_administrativa WHERE nombre_subunidad='Atención a Comercios'), (SELECT id_persona FROM persona WHERE correo_electronico='carlos.perez@example.com'),'Coordinador','2022-02-01',NULL),
 ((SELECT id_subunidad_administrativa FROM subunidad_administrativa WHERE nombre_subunidad='Urgencias'), (SELECT id_persona FROM persona WHERE correo_electronico='valentina.moreno@example.com'),'Asistente','2022-03-01',NULL);

-- grupo_investigacion_persona
INSERT INTO grupo_investigacion_persona (id_grupo_investigacion, id_persona, rol, fecha_inicio, fecha_fin)
VALUES
 ((SELECT id_grupo_investigacion FROM grupo_investigacion WHERE nombre_grupo_investigacion='GID-Software'), (SELECT id_persona FROM persona WHERE correo_electronico='ana.garcia@example.com'),'Investigador principal','2021-01-01',NULL),
 ((SELECT id_grupo_investigacion FROM grupo_investigacion WHERE nombre_grupo_investigacion='GIN-Negocios'), (SELECT id_persona FROM persona WHERE correo_electronico='carlos.perez@example.com'),'Investigador','2021-02-01',NULL),
 ((SELECT id_grupo_investigacion FROM grupo_investigacion WHERE nombre_grupo_investigacion='GIS-Salud'), (SELECT id_persona FROM persona WHERE correo_electronico='valentina.moreno@example.com'),'Asistente de investigación','2021-03-01',NULL);

-- programa_academico_persona
INSERT INTO programa_academico_persona (id_programa_academico, id_persona, fecha_inicio, fecha_fin, estado_academico)
VALUES
 ((SELECT id_programa_academico FROM programa_academico WHERE titulo_programa_academico='Ingeniería de Software'), (SELECT id_persona FROM persona WHERE correo_electronico='ana.garcia@example.com'),'2010-01-15','2015-12-15','Graduado'),
 ((SELECT id_programa_academico FROM programa_academico WHERE titulo_programa_academico='Administración de Empresas'), (SELECT id_persona FROM persona WHERE correo_electronico='carlos.perez@example.com'),'2007-02-10','2011-11-30','Graduado'),
 ((SELECT id_programa_academico FROM programa_academico WHERE titulo_programa_academico='Salud Pública'), (SELECT id_persona FROM persona WHERE correo_electronico='valentina.moreno@example.com'),'2023-01-20',NULL,'En curso');

-- =============================================================
-- PROFESIONES Y REDES SOCIALES
-- =============================================================

-- profesion
INSERT INTO profesion (titulo_profesion, area_profesion, codigo_profesion) VALUES
 ('Ingeniero de Sistemas','Ingeniería','2512'),
 ('Administrador de Empresas','Administración','1213'),
 ('Diseñador Gráfico','Artes','2166')
ON CONFLICT DO NOTHING;

-- profesion_persona
INSERT INTO profesion_persona (id_profesion, id_persona, anios_experiencia) VALUES
 ((SELECT id_profesion FROM profesion WHERE titulo_profesion='Ingeniero de Sistemas'), (SELECT id_persona FROM persona WHERE correo_electronico='ana.garcia@example.com'), 7),
 ((SELECT id_profesion FROM profesion WHERE titulo_profesion='Administrador de Empresas'), (SELECT id_persona FROM persona WHERE correo_electronico='carlos.perez@example.com'), 10),
 ((SELECT id_profesion FROM profesion WHERE titulo_profesion='Diseñador Gráfico'), (SELECT id_persona FROM persona WHERE correo_electronico='valentina.moreno@example.com'), 3);

-- red_social_persona_empresa
INSERT INTO red_social_persona_empresa (nombre_plataforma, url_perfil, tipo_cuenta, id_persona, id_empresa) VALUES
 ('LinkedIn','https://www.linkedin.com/in/anagarcia','Personal',(SELECT id_persona FROM persona WHERE correo_electronico='ana.garcia@example.com'), NULL),
 ('LinkedIn','https://www.linkedin.com/in/carlosperez','Personal',(SELECT id_persona FROM persona WHERE correo_electronico='carlos.perez@example.com'), NULL),
 ('LinkedIn','https://www.linkedin.com/company/saludplus','Corporativa',NULL,(SELECT id_empresa FROM empresa WHERE nombre_empresa='SaludPlus SA'));

-- =============================================================
-- EMPRENDIMIENTO Y EMPRENDEDOR
-- =============================================================

-- emprendimiento (1:1 con empresa)
INSERT INTO emprendimiento (id_empresa, surgimiento_emprendimiento, idea_negocio, estado_desarrollo_emprendimiento, macrosector_emprendimiento, subsector_emprendimiento, cantidad_empleados, esta_formalizada, importacion, exportacion, esta_asociada_red, esta_asociada_upa, pertenece_cluster, genera_ingresos, genera_empleo, tipo_empleo, tiene_camara_comercio, ventas_promedio_anual, cantidad_clientes_promedio_mes, realiza_comercio_internacional)
VALUES
 ((SELECT id_empresa FROM empresa WHERE nombre_empresa='TecnoAndes SAS'),'Proyecto universitario','Plataforma SaaS para pymes','En incubación','Tecnología','Software y desarrollo',8, TRUE, FALSE, FALSE, TRUE, FALSE, TRUE, TRUE, TRUE,'Mixto', TRUE, 250000000, 50, FALSE),
 ((SELECT id_empresa FROM empresa WHERE nombre_empresa='ComerLocal LTDA'),'Identificación de oportunidad local','Marketplace para tiendas de barrio','Consolidado','Comercio','Comercio al por menor',40, TRUE, TRUE, TRUE, TRUE, FALSE, TRUE, TRUE, TRUE,'Fijo', TRUE, 1200000000, 800, TRUE),
 ((SELECT id_empresa FROM empresa WHERE nombre_empresa='SaludPlus SA'),'Experiencia profesional','Servicios preventivos y de bienestar','En pausa','Servicios','Salud',100, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE,'Fijo', TRUE, 3500000000, 1200, FALSE);

-- emprendedor (1:1 con persona)
INSERT INTO emprendedor (id_persona, etnia_emprendedor, discapacidad_emprendedor, victima_emprendedor, poblacion_campesina_emprendedor, estado_civil_emprendedor, cabeza_hogar_emprendedor, personas_a_cargo, nivel_educativo_maximo)
VALUES
 ((SELECT id_persona FROM persona WHERE correo_electronico='ana.garcia@example.com'),'Mestizo', FALSE, FALSE, FALSE, 'Soltero', FALSE, 0, 'Profesional'),
 ((SELECT id_persona FROM persona WHERE correo_electronico='carlos.perez@example.com'),'Blanco', FALSE, FALSE, FALSE, 'Casado', TRUE, 2, 'Profesional'),
 ((SELECT id_persona FROM persona WHERE correo_electronico='valentina.moreno@example.com'),'Afrocolombiano', TRUE, FALSE, FALSE, 'Unión libre', FALSE, 1, 'Tecnológico');

-- =============================================================
-- PROGRAMAS Y PROYECTOS
-- =============================================================

-- programa
INSERT INTO programa (nombre_programa, nombre_corto_programa, objetivo_programa, tipo_programa, estado_programa, prioridad_programa, etapa_programa, valor_programa, cronograma_inicio_programa, cronograma_fin_programa, lider_programa, correo_programa, telefono_programa, equipo_programa, roles_funciones_programa, resumen_estado_programa)
VALUES
 ('ImpulsaTec','IMPTEC','Fortalecer capacidades tecnológicas de emprendimientos','Formación','Activo','Alta','Ejecución', 800000000, '2024-02-01','2025-12-31','Ana García','programa@tecnoandes.co','6041111','Equipo A','Rol A,B,C','En ejecución con cronograma al día'),
 ('Comercio Local','COMLOC','Digitalizar comercios locales','Acompañamiento','Activo','Media','Ejecución', 600000000, '2023-09-01','2025-06-30','Carlos Pérez','programa@comerlocal.com','6042222','Equipo B','Rol D,E,F','Avance del 70%'),
 ('Salud Emprende','SALEM','Promover bienestar en emprendedores','Servicios','En desarrollo','Baja','Planificación', 300000000, '2025-01-15','2025-12-15','Valentina Moreno','programa@saludplus.com','6043333','Equipo C','Rol G,H','Diseño de malla de servicios');

-- proyecto
INSERT INTO proyecto (id_programa, nombre_proyecto, estado_proyecto, prioridad_proyecto, etapa_proyecto, fecha_inicio_proyecto, fecha_finalizacion_proyecto, numero_contrato_proyecto, objeto_proyecto, tipo_ingreso_proyecto, figura_contractual_proyecto, fuente_recurso_proyecto, alcance_proyecto, contratante_proyecto, valor_proyecto, moneda_proyecto, lider_proyecto)
VALUES
 ((SELECT id_programa FROM programa WHERE nombre_programa='ImpulsaTec'),'Plataforma e-Learning','En ejecución','Alta','Ejecución','2024-03-10',NULL,'CT-001-2024','Implementación LMS','Transferencia','Contrato de prestación de servicios','Recursos propios','Despliegue regional','TecnoAndes SAS', 250000000,'COP','Ana García'),
 ((SELECT id_programa FROM programa WHERE nombre_programa='Comercio Local'),'App Comercios','En ejecución','Media','Ejecución','2023-10-01','2025-05-31','CT-045-2023','Desarrollo de app móvil','Venta','Convenio','Cooperación','Cobertura municipal','ComerLocal LTDA', 400000000,'COP','Carlos Pérez'),
 ((SELECT id_programa FROM programa WHERE nombre_programa='Salud Emprende'),'Kits de Bienestar','Pendiente','Baja','Planificación',NULL,NULL,'CT-010-2025','Diseño y distribución de kits','Donación','Convenio','Donantes','Piloto en dos comunas','SaludPlus SA', 120000000,'COP','Valentina Moreno');

-- =============================================================
-- ASUNTOS DE GESTIÓN Y PROCESOS
-- =============================================================

-- ag_o_pe
INSERT INTO ag_o_pe (nombre_ag_o_pe, tipo_ag_pe, sigla_corta_ag_pe, sigla_larga_ag_pe, objetivo_ag_pe, personas_ag_o_pe, procesos_ag_pe, macroproceso_ag_pe, activo)
VALUES
 ('Gestión de Emprendimientos','Asunto de Gestión','GE','Gestión de Emprendimientos','Coordinar el portafolio de emprendimientos','Ana, Carlos, Valentina','Acompañamiento, formación','Desarrollo Empresarial', TRUE),
 ('Operación Comercial','Proceso Ejecutable','OC','Operación Comercial','Optimizar operaciones de marketplace','Equipo Operaciones','Logística, atención','Operaciones', TRUE),
 ('Gestión Clínica','Proceso Ejecutable','GC','Gestión Clínica','Mejorar tiempos de atención','Equipo Clínico','Urgencias, ambulatorio','Servicios', TRUE);

-- asunto_de_trabajo_tipo_emprendimiento
INSERT INTO asunto_de_trabajo_tipo_emprendimiento (id_ag_o_pe, nombre_asunto_trabajo, descripcion_asunto_trabajo, responsable_asunto_trabajo, talento_humano_asunto_trabajo, agrupacion_asunto_trabajo)
VALUES
 ((SELECT id_ag_o_pe FROM ag_o_pe WHERE nombre_ag_o_pe='Gestión de Emprendimientos'),'Acompañamiento inicial','Diagnóstico y plan de trabajo','Ana García','Consultores','Formación'),
 ((SELECT id_ag_o_pe FROM ag_o_pe WHERE nombre_ag_o_pe='Operación Comercial'),'Onboarding de tiendas','Vinculación y capacitación','Carlos Pérez','Equipo Operaciones','Operaciones'),
 ((SELECT id_ag_o_pe FROM ag_o_pe WHERE nombre_ag_o_pe='Gestión Clínica'),'Jornadas de prevención','Charlas y tamizajes','Valentina Moreno','Equipo Salud','Servicios');

-- mapa_conocimiento_proceso
INSERT INTO mapa_conocimiento_proceso (id_asunto_trabajo, nombre_proceso, responsable_proceso, prioridad_proceso, estado_documentacion_proceso, cronograma_inicio_proceso, cronograma_fin_proceso, duracion_dias, esfuerzo_planificado_horas, esfuerzo_real_horas, presupuesto_proceso, tipo_proyecto_proceso)
VALUES
 ((SELECT id_asunto_trabajo FROM asunto_de_trabajo_tipo_emprendimiento WHERE nombre_asunto_trabajo='Acompañamiento inicial'),'Diagnóstico 360','Ana García','Alta','Borrador','2024-04-01','2024-06-30',90, 200, 180, 50000000,'Formación'),
 ((SELECT id_asunto_trabajo FROM asunto_de_trabajo_tipo_emprendimiento WHERE nombre_asunto_trabajo='Onboarding de tiendas'),'Vinculación y capacitación','Carlos Pérez','Media','Publicada','2023-10-15','2024-02-15',120, 300, 320, 80000000,'Operaciones'),
 ((SELECT id_asunto_trabajo FROM asunto_de_trabajo_tipo_emprendimiento WHERE nombre_asunto_trabajo='Jornadas de prevención'),'Plan de jornadas','Valentina Moreno','Baja','En elaboración','2025-02-01','2025-05-31',120, 160, 0, 30000000,'Servicios');

-- =============================================================
-- ACTIVIDADES Y EVENTOS
-- =============================================================

-- etapa_asunto_trabajo_proyecto_actividad
INSERT INTO etapa_asunto_trabajo_proyecto_actividad (nombre_etapa_asunto_trabajo_proyecto_actividad, descripcion_etapa_asunto_trabajo_proyecto_actividad, responsable_etapa_asunto_trabajo_proyecto_actividad, orden_etapa, id_asunto_trabajo, id_proyecto)
VALUES
 ('Etapa 1 - Levantamiento','Recolección de información','Ana García',1,(SELECT id_asunto_trabajo FROM asunto_de_trabajo_tipo_emprendimiento WHERE nombre_asunto_trabajo='Acompañamiento inicial'),(SELECT id_proyecto FROM proyecto WHERE nombre_proyecto='Plataforma e-Learning')),
 ('Etapa 1 - Onboarding','Convocatoria y registro','Carlos Pérez',1,(SELECT id_asunto_trabajo FROM asunto_de_trabajo_tipo_emprendimiento WHERE nombre_asunto_trabajo='Onboarding de tiendas'),(SELECT id_proyecto FROM proyecto WHERE nombre_proyecto='App Comercios')),
 ('Etapa 1 - Diseño','Planificación de jornadas','Valentina Moreno',1,(SELECT id_asunto_trabajo FROM asunto_de_trabajo_tipo_emprendimiento WHERE nombre_asunto_trabajo='Jornadas de prevención'),(SELECT id_proyecto FROM proyecto WHERE nombre_proyecto='Kits de Bienestar'));

-- dimension_emprendimiento
INSERT INTO dimension_emprendimiento (nombre_dimension_emprendimiento, descripcion_dimension_emprendimiento, responsable_dimension_emprendimiento) VALUES
 ('Mercado','Clientes, competencia y propuesta de valor','Ana García'),
 ('Finanzas','Modelos de ingresos, costos y caja','Carlos Pérez'),
 ('Producto','Desarrollo y calidad del producto','Valentina Moreno')
ON CONFLICT DO NOTHING;

-- actividad_momento
INSERT INTO actividad_momento (id_etapa_asunto_trabajo_proyecto_actividad, fecha_actividad, nombre_actividad, descripcion_actividad, hora_inicio_actividad, hora_finalizacion_actividad, tematica_actividad, modalidad_actividad, tipo_actividad, materiales_actividad, alimentacion_actividad, facilitador_actividad, fase_actividad, semestre_ejecucion_fase, observaciones_actividad)
VALUES
 ((SELECT id_etapa_asunto_trabajo_proyecto_actividad FROM etapa_asunto_trabajo_proyecto_actividad WHERE nombre_etapa_asunto_trabajo_proyecto_actividad='Etapa 1 - Levantamiento'),'2024-04-10','Taller de diagnóstico','Sesión inicial', '09:00','12:00','Diagnóstico','Presencial','Taller','Proyector, marcadores', FALSE,'Ana García','Fase 1','2024-1','Asistencia completa'),
 ((SELECT id_etapa_asunto_trabajo_proyecto_actividad FROM etapa_asunto_trabajo_proyecto_actividad WHERE nombre_etapa_asunto_trabajo_proyecto_actividad='Etapa 1 - Onboarding'),'2023-11-05','Sesión de inducción','Inducción a comercios', '10:00','12:30','Onboarding','Virtual','Seminario','Presentaciones', FALSE,'Carlos Pérez','Fase 1','2023-2','Se resolvieron dudas'),
 ((SELECT id_etapa_asunto_trabajo_proyecto_actividad FROM etapa_asunto_trabajo_proyecto_actividad WHERE nombre_etapa_asunto_trabajo_proyecto_actividad='Etapa 1 - Diseño'),'2025-02-20','Plan de jornadas','Diseño de actividades', '08:00','10:00','Prevención','Híbrido','Conferencia','Guías', TRUE,'Valentina Moreno','Fase 1','2025-1','Requiere ajustes');

-- subactividad_producto
INSERT INTO subactividad_producto (id_actividad, id_dimension_emprendimiento, nombre_subactividad_producto, tipo_subactividad_producto, fecha_subactividad_producto, descripcion_subactividad_producto, hora_inicio_subactividad, hora_finalizacion_subactividad, tematica_subactividad, modalidad_subactividad, materiales_subactividad, alimentacion_subactividad, facilitador_subactividad, observaciones_subactividad)
VALUES
 ((SELECT id_actividad FROM actividad_momento WHERE nombre_actividad='Taller de diagnóstico'), (SELECT id_dimension_emprendimiento FROM dimension_emprendimiento WHERE nombre_dimension_emprendimiento='Mercado'), 'Mapa de Empatía', 'Herramienta', '2024-04-10', 'Trabajo en equipos','10:30','11:30','Clientes','Presencial','Post-its', FALSE, 'Ana García','Muy participativo'),
 ((SELECT id_actividad FROM actividad_momento WHERE nombre_actividad='Sesión de inducción'), (SELECT id_dimension_emprendimiento FROM dimension_emprendimiento WHERE nombre_dimension_emprendimiento='Finanzas'), 'Modelo de ingresos', 'Plantilla', '2023-11-05', 'Revisión de opciones','11:45','12:15','Ingresos','Virtual','Plantillas', FALSE, 'Carlos Pérez','Se enviaron recursos'),
 ((SELECT id_actividad FROM actividad_momento WHERE nombre_actividad='Plan de jornadas'), (SELECT id_dimension_emprendimiento FROM dimension_emprendimiento WHERE nombre_dimension_emprendimiento='Producto'), 'Checklist de servicios', 'Lista', '2025-02-20', 'Definición preliminar','09:00','09:45','Calidad','Híbrido','Listas', TRUE, 'Valentina Moreno','Pendiente validación');

-- relacion_actividad_persona
INSERT INTO relacion_actividad_persona (id_persona, id_subactividad, asistio, calificacion, comentarios, rol)
VALUES
 ((SELECT id_persona FROM persona WHERE correo_electronico='ana.garcia@example.com'), (SELECT id_subactividad FROM subactividad_producto WHERE nombre_subactividad_producto='Mapa de Empatía'), TRUE, 5, 'Excelente dinámica','Facilitador'),
 ((SELECT id_persona FROM persona WHERE correo_electronico='carlos.perez@example.com'), (SELECT id_subactividad FROM subactividad_producto WHERE nombre_subactividad_producto='Modelo de ingresos'), TRUE, 4, 'Buena participación','Facilitador'),
 ((SELECT id_persona FROM persona WHERE correo_electronico='valentina.moreno@example.com'), (SELECT id_subactividad FROM subactividad_producto WHERE nombre_subactividad_producto='Checklist de servicios'), TRUE, 4, 'Requiere mejora de materiales','Facilitador');

-- =============================================================
-- LOGS Y AUDITORÍA
-- =============================================================

INSERT INTO log_cambios (nombre_tabla, tipo_operacion, id_registro_afectado, datos_anteriores, datos_nuevos, usuario_accion, ip_origen, id_persona, id_empresa)
VALUES
 ('persona','INSERT', (SELECT id_persona FROM persona WHERE correo_electronico='ana.garcia@example.com'), NULL, '{"correo":"ana.garcia@example.com"}', 'admin', '192.168.1.10', (SELECT id_persona FROM persona WHERE correo_electronico='ana.garcia@example.com'), NULL),
 ('empresa','UPDATE', (SELECT id_empresa FROM empresa WHERE nombre_empresa='ComerLocal LTDA'), '{"telefono":"6042222"}', '{"telefono":"6042223"}', 'admin', '192.168.1.11', NULL, (SELECT id_empresa FROM empresa WHERE nombre_empresa='ComerLocal LTDA')),
 ('proyecto','DELETE', 9999, '{"id":9999}', NULL, 'auditor', '192.168.1.12', NULL, NULL);
