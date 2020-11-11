use sakila;
--1)Insert a new employee to , but with an null email. Explain what happens.
insert  into `employees`(`employeeNumber`,`lastName`,`firstName`,`extension`,`email`,`officeCode`,`reportsTo`,`jobTitle`) values 
(1002,'Murphy','Diane','x5800',NULL,'1',NULL,'President');
--No pasa nada porque la tabla no permite que se ingresen valores nulos en el campo email, por lo que no se lleva a cabo el insert


--2)Run the first query
UPDATE employees SET employeeNumber = employeeNumber - 20;
SELECT * from employees e2 ;
--Lo que paso es que se modifico toda la columna employeeNumber y se le resto 20 a cada valor de la columna
UPDATE employees SET employeeNumber = employeeNumber + 20;
--Lo que paso es que se modifico toda la columna employee number y se le sumo 20 a cada valor de la columna

--3)Add a age column to the table employee where and it can only accept values from 16 up to 70 years old.
ALTER TABLE employees ADD age INT not null;
CREATE TRIGGER check_employee_age BEFORE 
INSERT ON employees
FOR EACH ROW 
    BEGIN 
        IF NOT NEW.AGE BETWEEN 17 AND 70 THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: No se aceptan empleados menores de 17 años ni mayores a 70 años';
    END IF;
    END;

--4)Describe the referential integrity between tables film, actor and film_actor in sakila db.
/*La relacion entre la tabla actor y film es del tipo many to many, un actor puede actuar en muchas peliculas y las peliculas tienen muchos actores, 
por esto es que existe la tabla film_actor, que funciona como una tabla intermedia. Esta ultima tabla contiene una foreign key hacia film y otra hacia actor.
Esta planteado de esta manera para evitar la redundancia de datos, es decir almacenar lo mismo varias veces. Si no existiera dicha tabla intermedia se deberia crear, hablando 
solo de la tabla film, una row por cada actor que haya actuado en una misma pelicula.
*/

/*5)Create a new column called lastUpdate to table employee and use trigger(s) to keep the date-time updated 
on inserts and updates operations. Bonus: add a column lastUpdateUser and the respective trigger(s) to 
specify who was the last MySQL user that changed the row (assume multiple users, other than root, can connect to MySQL and change this table).*/

ALTER TABLE employees
  ADD lastUpdate DATETIME DEFAULT NULL;
ALTER TABLE employees
  ADD lastUpdateUser varchar(255) DEFAULT NULL;

/*DATE*/ 
CREATE TRIGGER insert_last_update BEFORE 
INSERT ON employees
FOR EACH ROW 
    BEGIN 
        SET NEW.lastUpdate = CURRENT_TIMESTAMP(); 
    END;
   
CREATE TRIGGER update_last_update BEFORE 
UPDATE ON employees
FOR EACH ROW 
    BEGIN 
        SET NEW.lastUpdate = CURRENT_TIMESTAMP(); 
    END;
/*USER*/
CREATE TRIGGER insert_lastUpdateUser BEFORE 
INSERT ON employees
FOR EACH ROW 
    BEGIN 
        SET NEW.lastUpdateUser = USER();
    END;

CREATE TRIGGER update_lastUpdateUser BEFORE 
UPDATE ON employees
FOR EACH ROW 
    BEGIN 
        SET NEW.lastUpdateUser = USER();
    END;

--6) Find all the triggers in sakila db related to loading film_text table. What do they do? Explain each of them using its source code for the explanation.
CREATE DEFINER=`root`@`localhost` TRIGGER `ins_film` AFTER INSERT ON `film` FOR EACH ROW BEGIN
    INSERT INTO film_text (film_id, title, description)
        VALUES (new.film_id, new.title, new.description);
  END
  
/*Este trigger (ins_film) hace que, luego de que se haga un insert en la tabla film, se haga otro u otros inserts(dependiendo de la cantidad rows que se hayan insertado) en 
la tabla film_text, en los campos film_id, titile y description. Dichos campos tendran el valor correspondiente que se haya 
asignado en el insert a film (Por ejemplo: film_text.film_id= film.film_id) */
  
CREATE DEFINER=`root`@`localhost` TRIGGER `upd_film` AFTER UPDATE ON `film` FOR EACH ROW BEGIN
    IF (old.title != new.title) OR (old.description != new.description) OR (old.film_id != new.film_id)
    THEN
        UPDATE film_text
            SET title=new.title,
                description=new.description,
                film_id=new.film_id
        WHERE film_id=old.film_id;
    END IF;
  END
/*Este trigger (upd_film) hace que, luego de que se haga un update a la tabla film, en cada cada row modificada se actualizen los datos de los campos title, description
y film_id cambiandolos por los nuevos valores si alguno de ellos fue modificado en el update*/
CREATE DEFINER=`root`@`localhost` TRIGGER `del_film` AFTER DELETE ON `film` FOR EACH ROW BEGIN
    DELETE FROM film_text WHERE film_id = old.film_id;
  END
/*Este ultimo trigger hace que luego de que se borre una o mas rows en la tabla film se borren de la tabla film_text las rows que poseen el o los id de los films 
que fueron borrados */