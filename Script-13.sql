#Add a new customer
#To store 1
#For address use an existing address. The one that has the biggest address_id in 'United States'
INSERT INTO customers
(store_id, first_name, last_name, email, address_id, active, create_date, last_update)
 select 1, 'Agus', 'Jaimez', 'agustinjaim@gmail.com', max( address_id ), 1,CURRENT_TIMESTAMP, CURRENT_TIMESTAMP from address  
	inner join city using(city_id) 
	INNER JOIN country USING (country_id) 
	where country = ('United States');


#Add a rental
#Make easy to select any film title. I.e. I should be able to put 'film tile' in the where, and not the id.
#Do not check if the film is already rented, just use any from the inventory, e.g. the one with highest id.
#Select any staff_id from Store 2.

INSERT INTO sakila.rental
    (rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
    select CURRENT_TIMESTAMP,max(inventory_id ) , 1, DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 3 MONTH), (select max(staff_id) from staff where store_id = inventory.store_id ) , CURRENT_TIMESTAMP 
   from film 
   inner join inventory on film.film_id =inventory.film_id 
   where inventory.store_id =2 
   and film.title like ('ADAPTATION HOLES'); 
    
#Update film year based on the rating
#For example if rating is 'G' release date will be '2001'
#You can choose the mapping between rating and year.
#Write as many statements are needed.
   
UPDATE film
    SET release_year = (case when rating = 'PG' then 2011
                         when rating = 'G' then 2012
                         when rating = 'NC-17' then 2013
                         when rating = 'PG-13' then 2020
                         when rating = 'R' then 2010
                    end)
WHERE rating IN ('PG','G','NC-17','PG-13','R')
   
  
#Return a film
#Write the necessary statements and queries for the following steps.
#Find a film that was not yet returned. And use that rental id. Pick the latest that was rented for example.
#Use the id to return the film.

UPDATE sakila.rental
SET return_date=CURRENT_TIMESTAMP
where rental_id = (select * From (select max(rental_id) from rental where return_date is null)rental); 


#Try to delete a film
#Check what happens, describe what to do.
#Write all the necessary delete statements to entirely remove the film from the DB.

#Para borrar la film hay que borrar la film y todas las filas de otras tablas que estan relacionadas a dicho film


DELETE FROM sakila.film_actor
WHERE film_id=1;

DELETE FROM sakila.film_category
WHERE film_id=1;

DELETE FROM sakila.payment
WHERE payment_id=(select payment_id from rental 
inner join inventory using(inventory_id)
where film_id = 1);

DELETE FROM sakila.rental
WHERE inventory_id=(select inventory_id from inventory where film_id = 1);

DELETE FROM sakila.inventory
WHERE film_id=1;

DELETE FROM sakila.film
WHERE film_id=1;


#Rent a film
#Find an inventory id that is available for rent (available in store) pick any movie. Save this id somewhere.
#Add a rental entry
#Add a payment entry
#Use sub-queries for everything, except for the inventory id that can be used directly in the queries.




INSERT INTO sakila.payment
(customer_id, staff_id, rental_id, amount, payment_date, last_update)
select customer_id, staff_id, rental_id , 500, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP from rental 
where rental_id = (select max(rental_id)from rental);

INSERT INTO sakila.rental
(rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
select CURRENT_TIMESTAMP,max(inventory_id), max(customer.customer_id), DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 3 MONTH), max(staff.staff_id ), CURRENT_TIMESTAMP from inventory 
left join rental using(inventory_id )
inner join store using( store_id )
inner join staff on staff.store_id = store.store_id 
inner join customer on customer.store_id = store.store_id 
where rental_id is null;