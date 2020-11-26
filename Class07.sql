
use sakila;
--1)Find the films with less duration, show the title and rating.
SELECT title,rating,length FROM film f1 
 WHERE length <= all(SELECT length 
	FROM film f2	
	WHERE f2.film_id != f1.film_id);

--2)Write a query that returns the tiltle of the film which duration is the lowest. If there are more than one film with the lowest durtation, the query returns an empty resultset.

SELECT film_id ,title,rating,length FROM film f1 
 WHERE length <all(SELECT length 
	FROM film f2	
	WHERE f2.film_id != f1.film_id);


/*3)Generate a report with list of customers showing the lowest payments done by each of them. Show customer information, the address and the lowest amount, 
  provide both solution using ALL and/or ANY and MIN.*/

-- With all and any
 
 select customer.*,
 	(select address from address a2 
 		where customer.address_id = a2.address_id )as ADDRESS,
 	(select distinct amount from payment 
 		where customer.customer_id=payment.customer_id 
 		and amount <=all(select amount from payment where customer.customer_id = payment.customer_id ))as menor_compra
 	from customer;  
 
 
--With min and max
 
 
 select customer.*,
 	(select address from address a2 
 		where customer.address_id = a2.address_id )as ADDRESS,
 	(select min(amount) from payment 
 		where customer.customer_id=payment.customer_id)as menor_compra
 	from customer;  
 
 --4)Generate a report that shows the customer's information with the highest payment and the lowest payment in the same row
 
  select customer.*,
 	(select address from address a2 
 		where customer.address_id = a2.address_id )as ADDRESS,
 	(select distinct amount from payment 
 		where customer.customer_id=payment.customer_id 
 		and amount <=all(select amount from payment where customer.customer_id = payment.customer_id ))as menor_compra,
 	(select distinct amount from payment 
 		where customer.customer_id=payment.customer_id 
 		and amount >=all(select amount from payment where customer.customer_id = payment.customer_id ))as mayor_compra
 	from customer;  
 
 
 -- With min and max
 
 
 select customer.*,
 	(select address from address a2 
 		where customer.address_id = a2.address_id )as ADDRESS,
 	(select min(amount) from payment 
 		where customer.customer_id=payment.customer_id)as menor_compra,
 	(select max(amount) from payment 
 		where customer.customer_id=payment.customer_id)as mayor_compra
 	from customer;  
 
 