USE sakila;

#List all the actors that share the last name. Show them in order
SELECT first_name, last_name from actor a 
WHERE EXISTS (SELECT last_name FROM actor a2 WHERE a.last_name = a2.last_name AND a.actor_id != a2.actor_id ) ORDER BY 2;

#Find actors that don't work in any film
SELECT * FROM actor a WHERE NOT EXISTS (SELECT actor_id FROM film_actor f WHERE a.actor_id = f.actor_id );

#Find customers that rented only one film
SELECT first_name, last_name FROM customer c1 WHERE (SELECT count(*) FROM rental r WHERE r.customer_id = c1.customer_id) = 1;

#Find customers that rented more than one film
SELECT first_name, last_name FROM customer c1 WHERE (SELECT count(*) FROM rental r WHERE r.customer_id = c1.customer_id) > 1;

#List the actors that acted in 'BETRAYED REAR' or in 'CATCH AMISTAD'
SELECT * FROM actor a WHERE EXISTS (SELECT * FROM film f INNER JOIN film_actor fa ON fa.film_id=f.film_id WHERE fa.actor_id=a.actor_id AND (f.title= 'BETRAYED REAR' AND f.title='CATCH AMISTAD' ))

#List the actors that acted in 'BETRAYED REAR' but not in 'CATCH AMISTAD'
SELECT * FROM actor a WHERE EXISTS (SELECT * FROM film f INNER JOIN film_actor fa ON fa.film_id=f.film_id WHERE fa.actor_id=a.actor_id AND f.title= 'BETRAYED REAR') 
AND NOT EXISTS (SELECT * FROM film f INNER JOIN film_actor fa ON fa.film_id=f.film_id WHERE fa.actor_id=a.actor_id AND f.title= 'CATCH AMISTAD')

#List the actors that acted in both 'BETRAYED REAR' and 'CATCH AMISTAD'
SELECT * FROM actor a WHERE EXISTS (SELECT * FROM film f INNER JOIN film_actor fa ON fa.film_id=f.film_id WHERE fa.actor_id=a.actor_id AND f.title= 'BETRAYED REAR') 
AND EXISTS (SELECT * FROM film f INNER JOIN film_actor fa ON fa.film_id=f.film_id WHERE fa.actor_id=a.actor_id AND f.title= 'CATCH AMISTAD')

#List all the actors that didn't work in 'BETRAYED REAR' or 'CATCH AMISTAD'
SELECT * FROM actor a WHERE NOT EXISTS (SELECT * FROM film f INNER JOIN film_actor fa ON fa.film_id=f.film_id WHERE fa.actor_id=a.actor_id AND f.title= 'BETRAYED REAR') 
AND NOT EXISTS (SELECT * FROM film f INNER JOIN film_actor fa ON fa.film_id=f.film_id WHERE fa.actor_id=a.actor_id AND f.title= 'CATCH AMISTAD') ORDER BY a.first_name 
