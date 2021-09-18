--  1. Select the first name, last name, and email address of all the customers who have rented a movie.
use sakila;
select * from customer;
select first_name, last_name, email
from customer
where customer_id in
(select distinct (customer_id)
from rental)
order by first_name;

-- 2. What is the average payment made by each customer (display the *customer id*, *customer name* (concatenated), and the *average payment made*).
select c.customer_id as id, CONCAT(c.first_name," ", c.last_name) as name, ROUND(avg(p.amount),2) as avg_payment
from customer c
join payment p
on c.customer_id = p.customer_id
group by c.customer_id
order by id;

-- 3. Select the *name* and *email* address of all the customers who have rented the "Action" movies.
    -- 3.1 Write the query using multiple join statements
select c.customer_id, first_name, last_name, email
  from customer c
  join rental on c.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email
  order by c.customer_id;
  
  -- 510 rows: Top 5 Mary, Patricia, Linda, Barbara, Elizabeth
  
  select * from rental;
  select * from inventory;
    -- 3.2 Write the query using sub queries with multiple WHERE clause and `IN` condition
select customer_id, CONCAT(first_name," ",last_name) AS cstmr_name, email
from customer 
where customer_id in (select customer_id
from rental
where inventory_id in (select inventory_id
from inventory
where film_id in (select film_id
from film_category
where category_id in (select category_id
from category
where name = 'Action'))))
order by customer_id;

-- Also 510 rows: Top 5 Mary, Patricia, Linda, Barbara, Elizabeth

    -- 3.3 Verify if the above two queries produce the same results or not
-- Both queries have returned 510 rows ith Top 5 customers: Mary, Patricia, Linda, Barbara, Elizabeth

-- 4. Use the case statement to create a new column classifying existing columns as either or 
-- high value transactions based on the amount of payment. 
-- If the amount is between 0 and 2, label should be `low` and if the amount is between 2 and 4, 
-- the label should be `medium`, and if it is more than 4, then it should be `high`.
select payment_id, amount,
case
when amount < 2 then 'low'
when amount >=2 and amount < 4 then 'medium'
else 'high'
end as transaction_level
from payment
order by amount desc;