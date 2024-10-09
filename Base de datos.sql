CREATE DATABASE IF NOT EXISTS ServiciosArchivos;
USE ServiciosArchivos;

CREATE TABLE IF NOT EXISTS Imagenes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    extension VARCHAR(10) NOT NULL,
    path VARCHAR(255) NOT NULL,
    tamano BIGINT NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion DATETIME ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    idcreador INT NOT NULL
);

CREATE TABLE IF NOT EXISTS CambiosImagenes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_imagen INT NOT NULL,
    descripcion_cambio VARCHAR(255),
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_usuario INT NOT NULL,
    FOREIGN KEY (id_imagen) REFERENCES Imagenes(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Archivos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    extension VARCHAR(10) NOT NULL,
    path VARCHAR(255) NOT NULL,
    tamano BIGINT NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion DATETIME ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    idcreador INT NOT NULL
);

CREATE TABLE IF NOT EXISTS CambiosArchivos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_archivo INT NOT NULL,
    descripcion_cambio VARCHAR(255),
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_usuario INT NOT NULL,
    FOREIGN KEY (id_archivo) REFERENCES Archivos(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Videos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    extension VARCHAR(10) NOT NULL,
    path VARCHAR(255) NOT NULL,
    tamano BIGINT NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion DATETIME ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    idcreador INT NOT NULL
);

CREATE TABLE IF NOT EXISTS CambiosVideos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_video INT NOT NULL,
    descripcion_cambio VARCHAR(255),
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_usuario INT NOT NULL,
    FOREIGN KEY (id_video) REFERENCES Videos(id) ON DELETE CASCADE
);

-- Trigger para insertar un registro de cambio cuando se crea una nueva imagen
CREATE TRIGGER after_imagen_insert
AFTER INSERT ON Imagenes
FOR EACH ROW
BEGIN
    INSERT INTO CambiosImagenes (id_imagen, descripcion_cambio, id_usuario)
    VALUES (NEW.id, 'Creación de la imagen', NEW.idcreador);
END;

-- Trigger para insertar un registro de cambio cuando se actualiza una imagen
CREATE TRIGGER after_imagen_update
AFTER UPDATE ON Imagenes
FOR EACH ROW
BEGIN
    INSERT INTO CambiosImagenes (id_imagen, descripcion_cambio, id_usuario)
    VALUES (NEW.id, 'Modificación de la imagen', NEW.idcreador);
END;

-- Trigger para insertar un registro de cambio cuando se elimina una imagen
CREATE TRIGGER after_imagen_delete
AFTER DELETE ON Imagenes
FOR EACH ROW
BEGIN
    INSERT INTO CambiosImagenes (id_imagen, descripcion_cambio, id_usuario)
    VALUES (OLD.id, 'Eliminación de la imagen', OLD.idcreador);
END;

-- Trigger para insertar un registro de cambio cuando se crea un nuevo archivo
CREATE TRIGGER after_archivo_insert
AFTER INSERT ON Archivos
FOR EACH ROW
BEGIN
    INSERT INTO CambiosArchivos (id_archivo, descripcion_cambio, id_usuario)
    VALUES (NEW.id, 'Creación del archivo', NEW.idcreador);
END;

-- Trigger para insertar un registro de cambio cuando se actualiza un archivo
CREATE TRIGGER after_archivo_update
AFTER UPDATE ON Archivos
FOR EACH ROW
BEGIN
    INSERT INTO CambiosArchivos (id_archivo, descripcion_cambio, id_usuario)
    VALUES (NEW.id, 'Modificación del archivo', NEW.idcreador);
END;

-- Trigger para insertar un registro de cambio cuando se elimina un archivo
CREATE TRIGGER after_archivo_delete
AFTER DELETE ON Archivos
FOR EACH ROW
BEGIN
    INSERT INTO CambiosArchivos (id_archivo, descripcion_cambio, id_usuario)
    VALUES (OLD.id, 'Eliminación del archivo', OLD.idcreador);
END;

-- Trigger para insertar un registro de cambio cuando se crea un nuevo video
CREATE TRIGGER after_video_insert
AFTER INSERT ON Videos
FOR EACH ROW
BEGIN
    INSERT INTO CambiosVideos (id_video, descripcion_cambio, id_usuario)
    VALUES (NEW.id, 'Creación del video', NEW.idcreador);
END;

-- Trigger para insertar un registro de cambio cuando se actualiza un video
CREATE TRIGGER after_video_update
AFTER UPDATE ON Videos
FOR EACH ROW
BEGIN
    INSERT INTO CambiosVideos (id_video, descripcion_cambio, id_usuario)
    VALUES (NEW.id, 'Modificación del video', NEW.idcreador);
END;

-- Trigger para insertar un registro de cambio cuando se elimina un video
CREATE TRIGGER after_video_delete
AFTER DELETE ON Videos
FOR EACH ROW
BEGIN
    INSERT INTO CambiosVideos (id_video, descripcion_cambio, id_usuario)
    VALUES (OLD.id, 'Eliminación del video', OLD.idcreador);
END;