--Create a new database called imdb
CREATE DATABASE IF NOT EXISTS imdb;

USE imdb;
DROP TABLE IF EXISTS film,actor,film_actor;

--Create tables: film (film_id, title, description, release_year); actor (actor_id, first_name, last_name) , film_actor (actor_id, film_id)
CREATE TABLE film(
     film_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
     title VARCHAR(40),
     description TEXT NOT NULL,
     release_year YEAR,
);
CREATE TABLE actor(
     actor_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
     first_name VARCHAR(40),
     last_name VARCHAR(40),
);
CREATE TABLE film_actor(
     film_actor_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
     id_film INT NOT NULL,
     id_actor INT NOT NULL,
);

--Alter table add column last_update to film and actor
ALTER TABLE actor
  ADD last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    AFTER actor_id;

ALTER TABLE film
  ADD last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    AFTER film_id;

--Alter table add foreign keys to film_actor table
ALTER TABLE film_actor ADD 
    FOREIGN KEY (id_film)
    REFERENCES film (film_id);

ALTER TABLE film_actor ADD 
    FOREIGN KEY (id_actor)
    REFERENCES actor (actor_id);

--Insert some actors, films and who acted in each film
insert into film(title, description,release_year )
  values ('The incredibles','Animated action movie about a family with super powers',2006);
insert into film(title, description,release_year )
  values ('Allien vs Predator','Science fiction movie',2014);

insert into actor(first_name ,last_name )
  values ('Alejandro','San');
insert into actor(first_name ,last_name )
  values ('Xd?','Xd?');

insert into film_actor(id_film,id_actor)
  values (1,1);
insert into film_actor(id_film,id_actor)
  values (2,2); 