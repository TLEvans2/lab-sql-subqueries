-- Write SQL queries to perform the following tasks using the Sakila database:

use sakila ; 
-- Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.

select film_id from sakila.film 
where title = 'Hunchback Impossible'; 

select count(inventory_id) 
from sakila.inventory
where film_id = (SELECT film_id 
					from sakila.film
                   where title = 'Hunchback Impossible');

-- List all films whose length is longer than  the average length of all the films in the Sakila database.

select * from film ;
SELECT 
    title
FROM
    sakila.film
WHERE
    length > (SELECT 
            AVG(length)
        FROM
            sakila.film) ; 


-- Use a subquery to display all actors who appear in the film "Alone Trip".

select * from sakila.film_actor ; 
select * from sakila.actor ; 

select first_name as first, last_name as last
from sakila.actor 
where actor_id in (select actor_id 
	from sakila.film_actor
	where film_id = (select film_id 
				from sakila.film 
				where title = 'Alone Trip'));


-- Bonus:
-- Sales have been lagging among young families, and you want to target family movies for a promotion. 
-- Identify all movies categorized as family films.

select * from film_category;
select * from film ;

select title as 'Family Films'
from film
where film_id in (
select film_id from film_category
where category_id = (select category_id from category 
where name = "Family")); 

-- Retrieve the name and email of customers from Canada using both subqueries and joins. 
-- To use joins, you will need to identify the relevant tables and their primary and foreign keys.

select * from customer;
select * from address ; 
select * from city; 

select first_name as name, last_name as surname, email
from customer
where address_id in (
select address_id 
from address 
where city_id in (
select city_id
from country c 
join city y 
using (country_id)
where c.country = 'Canada'));

-- It seems like not all addresses have customers, so if you work backwards your set gets smaller at the final stage 

-- Determine which films were starred by the most prolific actor in the Sakila database. 
-- A prolific actor is defined as the actor who has acted in the most number of films. 

select actor_id, count(actor_id) as apps
from film_actor 
group by actor_id
Order by apps desc
Limit 1; 

select title 
from film
where film_id in ( 
select film_id from 
film_actor 
where actor_id in (select actor_id
from film_actor 
group by actor_id
Order by count(actor_id) desc
Limit 1)); 


-- Find the films rented by the most profitable customer in the Sakila database. 
-- You can use the customer and payment tables to find the most profitable customer, i.e., 
-- the customer who has made the largest sum of payments.


-- Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
 
select * from payment ; 
select customer_id, sum(amount) as total 
from payment 
group by customer_id ;

select avg(total) as avg_spend
from (
select sum(amount) as total 
from payment 
group by customer_id) as average_cust;

SELECT customer_id as 'Top Customers', SUM(amount) AS 'Total Spend' 
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (
    SELECT AVG(total) AS avg_spend
    FROM (
        SELECT SUM(amount) AS total 
        FROM payment 
        GROUP BY customer_id
    ) AS average_cust
);
