#Write a query that gets all the customers that live in Argentina. Show the first and last name in one column, the address and the city.
select CONCAT_WS(' ', first_name ,last_name)as 'Full name',country from customer 
inner join address using(address_id)
inner join city using(city_id)
inner join country using(country_id)
where country like ('%Argentina%');

#Write a query that shows the film title, language and rating. Rating shall be shown as the full text described here:
select title,language.name,
    case f.rating when 'G' then 'G (General Audiences) – All ages admitted.' 
    when 'PG' then 'PG (Parental Guidance Suggested) – Some material may not be suitable for children.' 
    when 'PG-13' then 'PG-13 (Parents Strongly Cautioned) – Some material may be inappropriate for children under 13.'
    when 'R' then 'R (Restricted) – Under 17 requires accompanying parent or adult guardian.'
    when 'NC-17' then 'NC-17 (Adults Only) – No one 17 and under admitted.'
    end as 'Rating'
    from film f 
    inner join `language` using(language_id);
   
   
#Write a search query that shows all the films 
#(title and release year) an actor was part of. Assume the actor comes from a 
#text box introduced by hand from a web page. Make sure to "adjust" the input text to try to find the films as effectively as you think is possible.
   
select title, release_year  from film
inner join film_actor using(film_id)
inner join actor using(actor_id)
where actor.first_name like(select SUBSTRING_INDEX('Ed Chase',' ',1) )/*No pude hacerlo con una variable*/
and actor.last_name like(select SUBSTRING_INDEX('Ed Chase',' ',-1) )

   
#Find all the rentals done in the months of May and June. Show the film title, customer name 
#and if it was returned or not. There should be returned column with two possible values 'Yes' and 'No'.

select title, rental_date, first_name as 'Customer name',
CASE when return_date is Null then 'No'
	when return_date is not Null then 'Yes'
	end as 'Returned'  from rental 
inner join customer using (customer_id)
inner join inventory using (inventory_id)
inner join film using (film_id) 
where month(rental_date ) like 5
or month(rental_date ) like 6

#Convert and Cast example
#La diferencia entre cast y convert es la sintaxis
#Write a search query that shows all rental,the customer name and the film title done in a certain date
#Assume the date comes from a text box introduced by hand from a web page in this format 'dd/mm/yyyy'

select title, rental_date, first_name from rental
inner join customer using (customer_id)
inner join inventory using (inventory_id)
inner join film using (film_id) 
where rental_date like CAST(replace("2005/05/24 22:53:30.0","/","-") AS DATETIME)

select title, rental_date, first_name from rental
inner join customer using (customer_id)
inner join inventory using (inventory_id)
inner join film using (film_id) 
where rental_date like convert(replace("2005/05/24 22:53:30.0","/","-"),DATETIME)


#Isnull retorna un valor si la expresion es null y si no es null retorna la expresion ISNULL(expression, value) es el de sql server

#IFNULL retorna el valor especificado si la expresion es null y no es null retorna la expression IFNULL(expression, value)

#Return all rentals with their return date but if it has not been returned yet show a message instead of null
select rental_id , ifnull(return_date,'No ha sido devuelta todavia' ) as 'return date' from rental

#nvl es lo mismo que ifnull e isnull nada mas que en lugar de ser para sql y sqlserver es para oracle
 
#Coalesence busca y retorna de un lista de valores el primer valor que no sea null
#SELECT COALESCE(NULL, NULL, NULL, '1')

#When they give you a multiple choice with a send button and if you do not select any option press send it show you have not selected anything
COALESCE(option1, option2, option3, 'you have not selected anything')