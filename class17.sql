/*1)Create two or three queries using address table in sakila db:
 -include postal_code in where (try with in/not it operator)
 -eventually join the table with city/country tables.
 -measure execution time.
 -Then create an index for postal_code on address table.
 -measure execution time again and compare with the previous ones.
 -Explain the results*/
select postal_code from address where postal_code IN (select postal_code from address 
inner join city using(city_id)
inner join country using(country_id)
where country like('%Argentina%'));
--Tiempo de ejecucion: 3ms

select postal_code from address where postal_code NOT IN (select postal_code from address 
inner join city using(city_id)
inner join country using(country_id)
where country like('%Chile%'));
--Tiempo de ejecucion: 4ms

SELECT postal_code FROM address;  
--Tiempo de ejecucion: 4ms
CREATE INDEX postal_code ON address(postal_code);

--El tiempo de ejecucion se redujo, 1 ms aproximadamente en cada query, por lo cual llegamos a la conclusion de que los indices agilizan la query


--2)Run queries using actor table, searching for first and last name columns independently. Explain the differences and why is that happening?
select first_name from film 
inner join film_actor using(film_id)
inner join actor using(actor_id)
where first_name like('C%');
/*3ms*/
select last_name from film 
inner join film_actor using(film_id)
inner join actor using(actor_id)
where last_name like('C%');
/*2ms*/
DESCRIBE actor;
--Esta query nos muestra que el field last_name tiene una key llamada MUL, esto nos indica que tiene un indice no unico
--La query hecha sobre last name es mas rapida que la hecha sobre first_name porque la primera tiene un index


--3)Compare results finding text in the description on table film with LIKE and in the film_text using MATCH ... AGAINST. Explain the results.
SELECT description FROM film_text WHERE MATCH(description) AGAINST('Dentist');
--2ms
SELECT description FROM film WHERE description like ('%Dentist%');
--5ms

--Los resultados muestran que comparar usando match against es mas rapido que usando like