/*
-----Nivel 1 — Fundamentos (Exploración básica)-----------
1. Listar todos los usuarios.
2. Mostrar solo first_name, last_name, email.
3. Filtrar usuarios cuyo role sea 'admin'.
4. Filtrar usuarios con document_type = 'CC'.
5. Mostrar usuarios mayores de 18 años (calcular edad desde birth_date).
6. Mostrar usuarios cuyo ingreso sea mayor a 5,000,000.
7. Mostrar usuarios cuyo nombre empiece por "A".
8. Mostrar usuarios que no tengan company
 * */

--1
SELECT * FROM users u 

--2
SELECT u.first_name, u.last_name, u.email  FROM users u 

--3
select * FROM users u where role = 'admin';

--4
SELECT * FROM users WHERE document_type = 'CC'

--5
SELECT * FROM users where TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) > 18;

--6
SELECT  * FROM users WHERE monthly_income > 5000000;

--7
SELECT * FROM users where first_name LIKE 'A%';

--8 
SELECT * FROM users where company is NULL
------------------------------------------------------------------------------------


/*
--------------------Nivel 2 — Combinación de condiciones
1. Usuarios mayores de 25 años que sean 'employee'.
2. Usuarios con 'CC' que estén activos.
3. Usuarios mayores de edad sin empleo.
4. Usuarios con empleo y con ingresos mayores a 3,000,000.
5. Usuarios casados con al menos 1 hijo.
6. Usuarios entre 30 y 40 años.
7. Usuarios 'admin' verificados mayores de 25 años.
 
*/

--1
select * FROM users where birth_date < '2001-01-01' AND role = 'employee';
--2
select * FROM users where document_type = 'CC' and is_active = 1;
--3
SELECT * FROM users where TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) > 18 and is_active = 0;
--4
SELECT  * FROM users WHERE monthly_income > 3000000 and role = 'employee';
--5
SELECT  * FROM users WHERE marital_status = 'Casado' and children_count > 0;
--6
SELECT * FROM users WHERE TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) >= 30 and TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) <= 40; 
--7
SELECT * FROM users WHERE TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) > 25 and role = 'admin';

/*
--------------------Nivel 3 — Introducción a análisis (Agregaciones)
1. Contar usuarios por role.
2. Contar usuarios por document_type.
3. Contar cuántos usuarios están desempleados.
4. Calcular el promedio general de ingresos.
5. Calcular el promedio de ingresos por role.
*/

--1
SELECT role, count(*) FROM users GROUP BY role;
--2
SELECT document_type, count(*) FROM users GROUP BY document_type;
--3
SELECT is_active, count(*) FROM users GROUP BY is_active;
--4
SELECT AVG(monthly_income) AS Pormedio_general from users
--5
SELECT role, AVG(monthly_income) AS Pormedio_general from users GROUP BY role;

/*
--------------------Nivel 4 — Pensamiento analítico
1. Mostrar profesiones con más de 10 personas.
2. Mostrar la ciudad con más usuarios.
3. Comparar cantidad de menores vs mayores de edad.
4. Promedio de ingresos por ciudad ordenado de mayor a menor.
5. Mostrar las 5 personas con mayor ingreso.

Aquí ya estás usando GROUP BY, ORDER BY, LIMIT y HAVING.
*/

--1
SELECT profession, COUNT(*) AS total_personas
FROM users
GROUP BY profession
HAVING COUNT(*) > 35;

--2
SELECT city,count(*) as total_personas
FROM users
group by city
ORDER BY city DESC
LIMIT 1;

--3
SELECT 
    SUM(
    CASE WHEN TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) < 18 
    	THEN 1 
    	ELSE 0 
    END) AS menores,
    
    SUM(
    CASE WHEN TIMESTAMPDIFF(YEAR, birth_date , CURDATE()) >= 18 
    THEN 1 
    ELSE 0 
    END) AS mayores
FROM users;

--4
SELECT city, AVG(monthly_income) AS promedio_ingresos
FROM users
GROUP BY city
ORDER BY promedio_ingresos DESC;

--5
SELECT first_name , monthly_income 
FROM users
ORDER BY monthly_income DESC
LIMIT 5;


/*
--------------------Nivel 5 — Nivel Ingeniero
1. Clasificar usuarios como:

"Menor"
"Adulto"
"Adulto mayor"

2. Mostrar cuántos usuarios hay en cada clasificación anterior.
3. Ranking de ingresos por ciudad.
4. Profesión con mayor ingreso promedio.
5. Mostrar usuarios cuyo ingreso esté por encima del promedio general.
*/

-- 1
SELECT 
    first_name ,
    birth_date ,
    TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) AS edad,
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) < 18 THEN 'Menor'
        WHEN TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) BETWEEN 18 AND 59 THEN 'Adulto'
        ELSE 'Adulto mayor'
    END AS clasificacion
FROM users;

-- 2
SELECT 
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) < 18 THEN 'Menor'
        WHEN TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) BETWEEN 18 AND 59 THEN 'Adulto'
        ELSE 'Adulto mayor'
    END AS clasificacion,
    COUNT(*) AS total
FROM users
GROUP BY clasificacion;

-- 3
SELECT 
    city,
    SUM(monthly_income ) AS total_ingresos,
    RANK() OVER (ORDER BY SUM(monthly_income) DESC) AS ranking
FROM users
GROUP BY city;

-- 4
SELECT profession, AVG(monthly_income) AS ingreso_promedio
FROM users
GROUP BY profession
ORDER BY ingreso_promedio DESC
LIMIT 1;

-- 5
SELECT 
    u.*,
    (SELECT AVG(monthly_income) FROM users) AS promedio_general
FROM users u
WHERE u.monthly_income > (
    SELECT AVG(monthly_income)
    FROM users
);






