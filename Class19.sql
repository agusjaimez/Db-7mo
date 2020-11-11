--1)Create a user data_analyst

CREATE USER data_analyst IDENTIFIED BY '1234';

--2)Grant permissions only to SELECT, UPDATE and DELETE to all sakila tables to it.

GRANT SELECT,UPDATE,DELETE ON sakila.* TO 'data_analyst' WITH GRANT OPTION;

--3)Login with this user and try to create a table. Show the result of that operation.
CREATE TABLE xd (xd int, xd2 varchar(255))
-- Result: ERROR 1142 (42000): CREATE command denied to user 'data_analyst'@'localhost' for table 'xd'

--4)Try to update a title of a film. Write the update script.

UPDATE sakila.film SET title='Xd', last_update=CURRENT_TIMESTAMP WHERE film_id=0;

--5)With root or any admin user revoke the UPDATE permission. Write the command
REVOKE UPDATE ON sakila.* FROM data_analyst;

--6)Login again with data_analyst and try again the update done in step 4. Show the result.
UPDATE sakila.film SET title='Xd', last_update=CURRENT_TIMESTAMP WHERE film_id=0;
--ERROR 1142 (42000): UPDATE command denied to user 'data_analyst'@'localhost' for table 'film'
