CREATE DATABASE university;
USE university;

CREATE TABLE  teachers(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    department VARCHAR(100)
);

CREATE TABLE courses(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    workload INTEGER
);

CREATE TABLE classes(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    courses_id INTEGER,
    teacher_id INTEGER,
    semester VARCHAR(10),
    FOREIGN KEY (courses_id) REFERENCES courses(id),
    FOREIGN KEY (teacher_id) REFERENCES teachers(id)
);

CREATE TABLE enrollment(
    id INTEGER PRIMARY KEY,
    student_name VARCHAR(100),
    class_id INTEGER,
    final_grade DECIMAL(4, 2),
    FOREIGN KEY (class_id) REFERENCES classes(id)
);

INSERT INTO teachers (name, department)  VALUES
                                            ('Igor da Penha Natal', 'FACOM'),
                                            ('Victor Sobreira', 'FACOM'),
                                            ('Danilo Elias de Oliveira', 'FAMAT'),
                                            ('Daniele Carvalho Oliveira', 'FACOM'),
                                            ('Adriano Mendonca Rocha', 'FACOM'),
                                            ('Thiago Fialho de Queiroz Lafeta', 'FACOM'),
                                            ('Mirella Silva Junqueira', 'FACOM'),
                                            ('Daniela Justiniano de Souza Pereira', 'FACOM'),
                                            ('Luis Florial Espinoza Sanchez', 'FAMAT'),
                                            ('Ana Claudia Martinez', 'FACOM'),
                                            ('Sara Melo', 'FACOM');

SELECT * FROM teachers;

INSERT INTO courses (name, workload) VALUES
                                         ('Banco de Dados II', 60),
                                         ('Redes de Computadores', 60),
                                         ('Sistemas Operacionas', 60),
                                         ('Testes e Manutencao de Software', 55),
                                         ('Algebra Linear', 50),
                                         ('Estrutura de Dados II', 65),
                                         ('Programacao Web I', 45),
                                         ('Programcao Orientada a Objetos II', 60),
                                         ('Algoritmos II', 50),
                                         ('Estrutura de Dados I', 50),
                                         ('Banco de Dados I', 45),
                                         ('Calculo I', 60),
                                         ('Algoritmos I', 60),
                                         ('Auditoria e Seguranca da Informacao', 40);

SELECT * FROM courses;

INSERT INTO classes (courses_id, teacher_id, semester) VALUES
                                                           (1, 1, '2025-1'),
                                                           (2, 1, '2025-1'),
                                                           (3, 1, '2025-1'),
                                                           (4, 2, '2025-1'),
                                                           (5, 3, '2025-1'),
                                                           (6, 4, '2025-1'),
                                                           (7, 5, '2025-1'),
                                                           (8, 6, '2025-1'),
                                                           (9, 10, '2023-2'),
                                                           (10, 8, '2024-2'),
                                                           (11, 8, '2024-2'),
                                                           (12, 9, '2024-2'),
                                                           (13, 7, '2024-1'),
                                                           (14, 11, '2025-2');

SELECT * FROM classes;

INSERT INTO enrollment (id, student_name, class_id, final_grade) VALUES
                                                                     (32221007,'Nicolas Freitas Silva', 1, 80.00 ),
                                                                     (1001, 'Ana Clara Sales', 2, 75.50),
                                                                     (1002, 'Bruno Henrique Costa', 3, 68.25),
                                                                     (1003, 'Carla Oliveira Santos', 4, 91.00),
                                                                     (1004, 'Diego Fernandes Lima', 5, 59.75),
                                                                     (1005, 'Eduarda Almeida Reis', 6, 88.00),
                                                                     (1006, 'Felipe Gomes Pereira', 7, 72.30),
                                                                     (1007, 'Gabriela Santos Rocha', 8, 81.50),
                                                                     (1008, 'Hugo Vaz Silva', 9, 65.00),
                                                                     (1009, 'Isabela Martins Souza', 10, 94.20),
                                                                     (1010, 'João Pedro Guimarães', 11, 70.00),
                                                                     (1011, 'Larissa Mendes Ribeiro', 12, 79.90),
                                                                     (1012, 'Miguel Antunes Barbosa', 13, 62.10),
                                                                     (1013, 'Natasha Vieira Soares', 14, 85.60);

SELECT * FROM enrollment;

DELETE FROM enrollment WHERE id = 32221007;

#-- 1.
SELECT
    t.name AS teacher,
    COUNT(c.id) AS total_classes,
    AVG(e.final_grade) AS avg_grade
FROM
    teachers t
JOIN
        classes c ON t.id = c.teacher_id
JOIN
        enrollment e ON c.id = e.class_id
GROUP BY
    t.id
HAVING
    COUNT(c.id) > 3
ORDER BY
    avg_grade DESC;

#-- 2.
SELECT
    co.name AS courses,
    COUNT(e.id) AS total_students
FROM
    courses co
JOIN
        classes c on co.id = c.courses_id
JOIN
        enrollment e on c.id = e.class_id
GROUP BY
    co.id
ORDER BY
    total_students DESC
LIMIT 5;

#-- 3.

SELECT
    t.name AS teacher,
    co.name AS courses,
    AVG(e.final_grade) AS avg_grade,
    COUNT(e.id) AS total_students
FROM
    classes c
JOIN
        teachers t ON c.teacher_id = t.id
JOIN
        courses co ON c.courses_id = co.id
JOIN
        enrollment e ON c.id = e.class_id
WHERE
    c.semester = '2024-2'
GROUP BY
    c.id;

#-- 4.

SELECT
    e.student_name,
    e.final_grade,
    e.class_id
FROM
    enrollment e
JOIN (
    SELECT
        class_id,
        AVG(final_grade) AS avg_class
    FROM
        enrollment
    GROUP BY
        class_id
) AS medias ON e.class_id = medias.class_id
WHERE
    e.final_grade > medias.avg_class;

#-- 5.

DELIMITER $$
    CREATE PROCEDURE class_overview (IN class_id INTEGER)
        BEGIN
            SELECT
                co.name AS courses,
                t.name AS teacher,
                COUNT(e.id) AS total_students,
                AVG(e.final_grade) AS avg_grades
            FROM
                classes c
            JOIN
                    courses co ON c.courses_id = co.id
            JOIN
                    teachers t ON c.teacher_id = t.id
            JOIN
                    enrollment e ON c.id = e.class_id
            WHERE
                c.id = class_id
            GROUP BY
                co.name, t.name;
        end $$
DELIMITER ;

#-- 6.

SELECT
    name
FROM
    teachers
GROUP BY
    name
HAVING
    COUNT(DISTINCT department) > 1;

#-- 7.

SELECT
    c.id AS class_id,
    COUNT(e.id) AS total_students,
    AVG(e.final_grade) AS avg_grades
FROM
    classes c
JOIN
        enrollment e ON c.id = e.class_id
GROUP BY
    c.id
HAVING
    COUNT(e.id) > 10;

#-- 8.

DELIMITER $$
        CREATE PROCEDURE student_performance(IN name VARCHAR(100))
            BEGIN
                SELECT
                    name,
                    AVG(final_grade) AS avg_geral
                FROM
                    enrollment
                WHERE
                    student_name = name;

                SELECT
                    co.name AS better_course,
                    MAX(e.final_grade) AS better_grade
                FROM
                    enrollment e
                JOIN
                        classes c ON e.class_id = c.id
                JOIN
                        courses co ON c.courses_id = co.id
                WHERE
                    e.student_name = name;

                SELECT
                    co.name AS worse_course,
                    MIN(e.final_grade) AS worse_grade
                FROM
                    enrollment e
                JOIN
                        classes c ON e.class_id = c.id
                JOIN
                        courses co ON c.courses_id = co.id
                WHERE
                    e.student_name = name;
            end $$
DELIMITER ;

CALL class_overview(3);
CALL student_performance('Nicolas Freitas Silva');