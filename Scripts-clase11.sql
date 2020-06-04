use sakila;

#Find all the film titles that are not in the inventory.
SELECT f.title FROM inventory i RIGHT JOIN film f ON i.film_id = f.film_id WHERE i.film_id IS NULL;

#Find all the films that are in the inventory but were never rented.
SELECT f.title, i.inventory_id FROM inventory i 
LEFT JOIN rental r ON r.inventory_id = i.inventory_id 
INNER JOIN film f ON f.film_id = i.film_id 
WHERE r.rental_id IS NULL;

#Generate a report with:customer (first, last) name, store id, film title and 
#when the film was rented and returned for each of these customers
#order by store_id, customer last_name
SELECT CONCAT(c.first_name," ",c.last_name) customer_name, i.store_id, f.title, r.rental_date, r.return_date FROM rental r 
INNER JOIN customer c on r.customer_id = c.customer_id 
INNER JOIN inventory i ON r.inventory_id = i.inventory_id 
INNER JOIN film f ON i.film_id = f.film_id 
ORDER BY i.store_id, c.last_name;

#Show sales per store (money of rented films)
#show store's city, country, manager info and total sales (money)
SELECT SUM(p.amount) total_sales, s.store_id, a.address, a.address2, CONCAT(st.first_name," ", st.last_name) manager_name, st.email FROM inventory i2 
INNER JOIN rental r on r.inventory_id = i2.inventory_id
INNER JOIN store s ON s.store_id = i2.store_id
INNER JOIN payment p on p.rental_id = r.rental_id
INNER JOIN address a on s.address_id = a.address_id 
INNER JOIN staff st on st.staff_id = s.manager_staff_id 
GROUP BY s.store_id;

#Which actor has appeared in the most films?
SELECT a.first_name, COUNT(a.actor_id) AS total FROM film_actor fa 
INNER JOIN film f on f.film_id = fa.film_id 
INNER JOIN actor a on a.actor_id = fa.actor_id
GROUP BY a.actor_id
HAVING COUNT(a.actor_id) = (SELECT MAX(v.total) FROM (SELECT a.first_name, COUNT(a.actor_id) AS total FROM film_actor fa 
INNER JOIN film f on f.film_id = fa.film_id 
INNER JOIN actor a on a.actor_id = fa.actor_id
GROUP BY a.actor_id ) v);
