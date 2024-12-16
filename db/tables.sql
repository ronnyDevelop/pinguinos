-- Tabla de Usuarios
CREATE TABLE "usuarios" (
    "id" SERIAL PRIMARY KEY,
    "email" VARCHAR(255) NOT NULL UNIQUE,
    "password_hash" VARCHAR(255) NOT NULL,
    "tipo_usuario" VARCHAR(15) CHECK (tipo_usuario IN ('cuidador', 'empleador', 'admin')) NOT NULL,
    "fecha_creacion" DATE NOT NULL DEFAULT CURRENT_DATE
);

-- Tabla de Perfiles de Cuidadores
CREATE TABLE "perfiles_cuidadores" (
    "id" INTEGER PRIMARY KEY REFERENCES "usuarios"("id"),
    "nombre" VARCHAR(255) NOT NULL,
    "apellido" VARCHAR(255) NOT NULL,
    "experiencia" INTEGER,
    "habilidades" VARCHAR(255),
    "ubicacion" VARCHAR(255),
    "biografia" TEXT,
    "cursos_completados" INTEGER REFERENCES "cursos"("id")
);

-- Tabla de Perfiles de Empleadores
CREATE TABLE "perfiles_empleadores" (
    "id" INTEGER PRIMARY KEY REFERENCES "usuarios"("id"),
    "nombre_empresa" VARCHAR(255) NOT NULL,
    "descripcion" TEXT,
    "ubicacion" VARCHAR(255),
    "sector" VARCHAR(255)
);

-- Tabla de Perfiles de Administradores
CREATE TABLE "perfiles_administradores" (
    "id" INTEGER PRIMARY KEY REFERENCES "usuarios"("id"),
    "nombre" VARCHAR(255) NOT NULL,
    "apellido" VARCHAR(255) NOT NULL,
    "rol" VARCHAR(50) DEFAULT 'SuperAdmin' -- añadir roles específicos si es necesario
);

-- Tabla de Ofertas Laborales
CREATE TABLE "ofertas_laborales" (
    "id" SERIAL PRIMARY KEY,
    "id_empleador" INTEGER NOT NULL REFERENCES "perfiles_empleadores"("id"),
    "titulo" VARCHAR(255) NOT NULL,
    "descripcion" TEXT NOT NULL,
    "requisitos" TEXT,
    "ubicacion" VARCHAR(255),
    "fecha_publicacion" DATE NOT NULL DEFAULT CURRENT_DATE,
    "estado" VARCHAR(10) CHECK (estado IN ('abierta', 'cerrada')) NOT NULL
);

-- Tabla de Postulaciones
CREATE TABLE "postulaciones" (
    "id" SERIAL PRIMARY KEY,
    "id_oferta" INTEGER NOT NULL REFERENCES "ofertas_laborales"("id"),
    "id_cuidador" INTEGER NOT NULL REFERENCES "perfiles_cuidadores"("id"),
    "fecha_postulacion" DATE NOT NULL DEFAULT CURRENT_DATE,
    "estado" VARCHAR(10) CHECK (estado IN ('pendiente', 'aceptada', 'rechazada')) NOT NULL
);

-- Tabla de Cursos
CREATE TABLE "cursos" (
    "id" SERIAL PRIMARY KEY,
    "titulo" VARCHAR(255) NOT NULL,
    "descripcion" TEXT,
    "url" VARCHAR(255)
);

-- Tabla de Evaluaciones
CREATE TABLE "evaluaciones" (
    "id" SERIAL PRIMARY KEY,
    "id_cuidador" INTEGER REFERENCES "perfiles_cuidadores"("id"),
    "id_empleador" INTEGER REFERENCES "perfiles_empleadores"("id"),
    "comentarios" TEXT,
    "puntaje" INTEGER CHECK (puntaje BETWEEN 1 AND 5)
);

-- Tabla de acciones de adminstración
CREATE TABLE "acciones_administrativas" (
    "id" SERIAL PRIMARY KEY, -- Identificador único para cada acción
    "id_admin" INTEGER NOT NULL REFERENCES "perfiles_administradores"("id"), -- Admin que realizó la acción
    "accion" VARCHAR(255) NOT NULL, -- Descripción de la acción (ej. 'Aprobó publicación', 'Eliminó usuario')
    "fecha_hora" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Momento en que se realizó la acción
    "detalles" TEXT -- Información adicional (opcional)
);

-- Tabla auxiliar para las acciones administrativas
CREATE TABLE "tipos_acciones_administrativas" (
    "id" SERIAL PRIMARY KEY, -- Identificador único para cada tipo de acción
    "nombre" VARCHAR(100) NOT NULL UNIQUE, -- Nombre breve del tipo de acción (ej, 'CREAR_USUARIO')
    "descripcion" TEXT -- Descripción detallada de la acción
);
