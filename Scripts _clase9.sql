USE sakila;
#Get the amount of cities per country in the database. Sort them by country, country_id.
SELECT co.country, count(*) from city c inner join country co on co.country_id=c.country_id GROUP BY c.country_id ORDER BY co.country, c.country_id;
#Get the amount of cities per country in the database. Show only the countries with more than 10 cities, order from the highest amount of cities to the lowest
SELECT co.country, count(*) AS amount_of_cities from city c inner join country co on co.country_id=c.country_id GROUP BY c.country_id HAVING COUNT(*)>10 ORDER BY COUNT(*) DESC;
#Generate a report with customer (first, last) name, address, total films rented and the total money spent renting films.
SELECT c.first_name, c.last_name, a.address AS address1, a.address2 AS address2,COUNT(*) AS Films_rented, (SELECT SUM(p.amount) FROM payment p WHERE p.customer_id=c.customer_id) AS money_spent FROM customer c 
INNER JOIN address a ON a.address_id=c.address_id 
INNER JOIN rental r ON c.customer_id = r.customer_id 
WHERE c.customer_id IN (SELECT p.customer_id FROM payment p WHERE p.customer_id=c.customer_id)
GROUP BY c.customer_id 
ORDER BY money_spent DESC;
#Which film categories have the larger film duration (comparing average)?
SELECT c.name,(SELECT AVG(f.`length`) FROM film_category fc INNER JOIN film f ON f.film_id = fc.film_id WHERE fc.category_id=c.category_id) avg_film_duration FROM category c ORDER BY avg_film_duration DESC;
#Show sales per film rating(REVISAR)
SELECT f.rating, (SELECT COUNT(*) FROM rental r WHERE r.inventory_id IN (SELECT i.inventory_id FROM inventory i WHERE i.film_id = f.film_id )) sales FROM film f ORDER BY sales;#NO FUNCIONA
