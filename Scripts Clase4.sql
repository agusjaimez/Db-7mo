USE sakila;
/*Show title and special_features of films that are PG-13 */
select title,special_features FROM film WHERE rating like 'PG-13';
/*Get a list of all the different films duration */
select distinct film.length from film order by `length`;
/*Show title, rental_rate and replacement_cost of films that have replacement_cost from 20.00 up to 24.00*/
select title, rental_rate, replacement_cost from film where replacement_cost BETWEEN 20.00 and 24.00 order by replacement_cost;

/*Show title, category and rating of films that have 'Behind the Scenes' as special_features*/
select title, rating,category.name from film 
INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category on film_category.category_id = category.category_id 
where film.special_features like 'Behind the Scenes' order by film.title;
/*sin inner join:*/
select title,special_features, category.name from film,film_category,category 
where film.film_id =film_category.film_id
and category.category_id = film_category.category_id 
and film.special_features like 'Behind the Scenes';

/*Show first name and last name of actors that acted in 'ZOOLANDER FICTION'*/
SELECT first_name,last_name,film.title FROM actor
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
INNER JOIN film on film_actor.film_id = film.film_id 
WHERE film.title like 'ZOOLANDER FICTION'; 


/* Show the address, city and country of the store with id 1 */
select address,city,country from store 
INNER JOIN address ON store.address_id =address.address_id 
INNER JOIN city on address.city_id = city.city_id 
INNER JOIN country on city.country_id =country.country_id 
where store.store_id like '1';

/*Show pair of film titles and rating of films that have the same rating.*/

SELECT f1.title, f2.title , f1.rating from film f1, film f2
where f1.rating like f2.rating and f1.film_id not like f2.film_id;

/*Get all the films that are available in store id 2 and the manager first/last name of this store (the manager will appear in all the rows).*/

SELECT title,staff.first_name,staff.last_name from film 
INNER JOIN inventory on film.film_id = inventory.film_id
INNER JOIN store on inventory.store_id = store.store_id 
INNER JOIN staff on store.manager_staff_id = staff.staff_id 
where store.store_id like '2';












