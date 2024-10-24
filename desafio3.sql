-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
Requerimientos



1. Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo
pedido.

-- Crear la base de datos
CREATE DATABASE desafio3_camila_herrera_555;

-- Conectar a la base de datos
\c desafio3_camila_herrera_555;

-- Crear la tabla de usuarios
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    rol VARCHAR(20) NOT NULL
);

-- Crear la tabla de posts
CREATE TABLE post (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL,
    fecha_actualizacion TIMESTAMP NOT NULL,
    destacado BOOLEAN DEFAULT FALSE,
    usuario_id BIGINT REFERENCES usuarios(id) ON DELETE SET NULL  ------------------------------
);

-- Crear la tabla de comentarios
CREATE TABLE comentarios (
    id SERIAL PRIMARY KEY,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL,
    usuario_id BIGINT REFERENCES usuarios(id) ON DELETE SET NULL,
    post_id BIGINT REFERENCES post(id) ON DELETE CASCADE
);
-- Insertar 5 registros en la tabla usuarios
INSERT INTO usuarios (email, nombre, apellido, rol) VALUES
('admin@example.com', 'Camila', 'Herrera', 'administrador'),
('user1@example.com', 'Juan', 'Pérez', 'usuario'),
('user2@example.com', 'Maria', 'López', 'usuario'),
('user3@example.com', 'Carlos', 'Sanchez', 'usuario'),
('user4@example.com', 'Ana', 'García', 'usuario');
-- Insertar 5 posts
INSERT INTO post (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES
('Post de Admin 1', 'Contenido del primer post del administrador', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, TRUE, 1),
('Post de Admin 2', 'Contenido del segundo post del administrador', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, TRUE, 1),
('Post de Usuario 1', 'Contenido del primer post de un usuario', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, FALSE, 2),
('Post de Usuario 2', 'Contenido del segundo post de un usuario', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, FALSE, 3),
('Post Sin Usuario', 'Contenido de un post sin usuario asignado', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, FALSE, NULL);
-- Insertar 5 comentarios
INSERT INTO comentarios (contenido, fecha_creacion, usuario_id, post_id) VALUES
('Comentario del usuario 1 en el post 1', CURRENT_TIMESTAMP, 1, 1),
('Comentario del usuario 2 en el post 1', CURRENT_TIMESTAMP, 2, 1),
('Comentario del usuario 3 en el post 1', CURRENT_TIMESTAMP, 3, 1),
('Comentario del usuario 1 en el post 2', CURRENT_TIMESTAMP, 1, 2),
('Comentario del usuario 2 en el post 2', CURRENT_TIMESTAMP, 2, 2);
--------------------------------------------------------------------------------------------------------------------------------

2. Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas:
nombre y email del usuario junto al título y contenido del post.---no inner 

SELECT u.nombre, u.email, p.titulo, p.contenido
FROM usuarios u
INNER JOIN post p ON u.id = p.usuario_id;
---------------------------------------------------
SELECT u.nombre, u.email, p.titulo, p.contenido
FROM usuarios u
FULL JOIN post p ON u.id = p.usuario_id;
--------------------------------------------------------------------------------------------------------------------------------

3. Muestra el id, título y contenido de los posts de los administradores.
a. El administrador puede ser cualquier id.
SELECT p.id, p.titulo, p.contenido
FROM post p
INNER JOIN usuarios u ON p.usuario_id = u.id
WHERE u.rol = 'administrador';
--------------------------------------------------------------------------------------------------------------------------------

4. Cuenta la cantidad de posts de cada usuario.
a. La tabla resultante debe mostrar el id e email del usuario junto con la
cantidad de posts de cada usuario.
Hint: Aquí hay diferencia entre utilizar inner join, left join o right join, prueba con
todas y con eso determina cuál es la correcta. No da lo mismo la tabla desde la que
se parte.

SELECT u.id, u.email, COUNT(p.id) AS total_posts
FROM usuarios u
LEFT JOIN post p ON u.id = p.usuario_id
GROUP BY u.id, u.email
ORDER BY  u.id ASC;
--------------------------------------------------------------------------------------------------------------------------------

5. Muestra el email del usuario que ha creado más posts.
a. Aquí la tabla resultante tiene un único registro y muestra solo el email.

SELECT u.email
FROM usuarios u
INNER JOIN post p ON u.id = p.usuario_id
GROUP BY u.email
ORDER BY COUNT(p.id) DESC
LIMIT 1;
--------------------------------------------------------------------------------------------------------------------------------

6. Muestra la fecha del último post de cada usuario.
Hint: Utiliza la función de agregado MAX sobre la fecha de creación.

SELECT u.nombre, MAX(p.fecha_creacion) AS ultima_fecha_post
FROM usuarios u
INNER JOIN post p ON u.id = p.usuario_id
GROUP BY u.nombre;
--------------------------------------------------------------------------------------------------------------------------------

7. Muestra el título y contenido del post (artículo) con más comentarios.

SELECT p.titulo, p.contenido
FROM post p
INNER JOIN comentarios c ON p.id = c.post_id
GROUP BY p.id
ORDER BY COUNT(c.id) DESC
LIMIT 1;
--------------------------------------------------------------------------------------------------------------------------------

8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido
de cada comentario asociado a los posts mostrados, junto con el email del usuario
que lo escribió.

SELECT p.titulo, p.contenido AS contenido_post, c.contenido AS contenido_comentario, u.email
FROM post p
INNER JOIN comentarios c ON p.id = c.post_id
INNER JOIN usuarios u ON c.usuario_id = u.id;
--------------------------------------------------------------------------------------------------------------------------------

9. Muestra el contenido del último comentario de cada usuario.

SELECT u.email, c.contenido AS ultimo_comentario
FROM comentarios c
INNER JOIN usuarios u ON c.usuario_id = u.id
WHERE c.fecha_creacion = (
    SELECT MAX(c2.fecha_creacion) 
    FROM comentarios c2 
    WHERE c2.usuario_id = u.id
);
--------------------------------------------------------------------------------------------------------------------------------

10. Muestra los emails de los usuarios que no han escrito ningún comentario.
Hint: Recuerda el uso de Having

SELECT u.email
FROM usuarios u
LEFT JOIN comentarios c ON u.id = c.usuario_id
GROUP BY u.email
HAVING COUNT(c.id) = 0;



