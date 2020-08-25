/*Create a view named list_of_customers, it should contain the following columns:*/
Create view list_of_customers as
select customer_id, CONCAT_WS(' ', first_name ,last_name)as 'Full name',a.address,a.postal_code as 'zip code',a.phone ,c.city,cu.country,
CASE when active like'%1%' then 'Active'
	else 'Inactive'
	end as 'Status'  ,store_id
from customer 
inner join address as a using(address_id)
inner join city as c using(city_id)
inner join country as cu using(country_id);

#Create a view named film_details, it should contain the following columns: 
#film id, title, description, category, price, length, rating, actors - as a string of all the actors separated by comma. Hint use GROUP_CONCAT
create view film_details as
select film_id,title,description,category.name, replacement_cost as 'cost',`length`,rating,group_concat(CONCAT_WS(' ',actor.first_name, actor.last_name ) Separator ', ' ) as 'Actors' from film
inner join film_category using(film_id)
inner join category using(category_id)
inner join film_actor using(film_id)
inner join actor using(actor_id)
group by film_id,title,category.name;

#Create view sales_by_film_category, it should return 'category' and 'total_rental' columns.
create view sales_by_film_category as
select name ,count(rental.rental_id) as 'Total_rental'from category 
inner join film_category using(category_id)
inner join film using(film_id)
inner join inventory using(film_id )
inner join rental using(inventory_id)
group by category.name;

create view sales_by_film_category as
select name ,sum(payment.amount ) as 'Total_rental'from category 
inner join film_category using(category_id)
inner join film using(film_id)
inner join inventory using(film_id )
inner join rental using(inventory_id)
inner join payment using (rental_id)
group by category.name;

#Create a view called actor_information where it should return, actor id, first name, last name and the amount of films he/she acted on.
create view actor_information as
select actor_id, first_name, last_name, count(film.film_id ) as 'amount_of_films_acted_in' from actor
inner join film_actor using(actor_id)
inner join film using(film_id)
group by actor_id ;

#Analyze view actor_info, explain the entire query and specially how the sub query works. 
#Be very specific, take some time and decompose each part and give an explanation for each.
select * from actor_info;

#It returns this:

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `actor_info` AS
select
    `a`.`actor_id` AS `actor_id`,
    `a`.`first_name` AS `first_name`,
    `a`.`last_name` AS `last_name`,
    group_concat(distinct concat(`c`.`name`, ': ',
    (select group_concat(`f`.`title` order by `f`.`title` ASC separator ', ') from ((`film` `f` join `film_category` `fc` on((`f`.`film_id` = `fc`.`film_id`))) join `film_actor` `fa` on((`f`.`film_id` = `fa`.`film_id`))) where ((`fc`.`category_id` = `c`.`category_id`) and (`fa`.`actor_id` = `a`.`actor_id`))))
order by
    `c`.`name` ASC separator '; ') AS `film_info`
from
    (((`actor` `a`
left join `film_actor` `fa` on
    ((`a`.`actor_id` = `fa`.`actor_id`)))
left join `film_category` `fc` on
    ((`fa`.`film_id` = `fc`.`film_id`)))
left join `category` `c` on
    ((`fc`.`category_id` = `c`.`category_id`)))
group by
    `a`.`actor_id`,
    `a`.`first_name`,
    `a`.`last_name`
    
# la que la query hace es crear una view llamado actor_info con el actor_id,first_name y last_name
# Y hasta ahi llega mi analisis :3
    

#En una materialized view el resultado de la consulta se almacena en una tabla caché real, que será actualizada de forma periódica a partir de las tablas originales. 
#Esto proporciona un acceso mucho más eficiente, a costa de un incremento en el tamaño de la base de datos y a una posible falta de sincronía, es decir, que los datos de la vista pueden estar potencialmente desfasados con respecto a los datos reales.
#Materialized views existe en Oracle y en bases de datos mysql Mysql
#Una alternativa para las materialized views es crear una table y hacer 'refreshes' con triggers
