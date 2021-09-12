use sakila;

--  1. Select the first name, last name, and email address of all the customers who have rented a movie.
select c.first_name, c.last_name, c.email
from customer c
join rental r
on c.customer_id = r.customer_id
group by c.customer_id;

-- 2. What is the average payment made by each customer (display the *customer id*, *customer name* (concatenated), and the *average payment made*).
select c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, avg(p.amount)
from customer c
join payment p
on c.customer_id = p.customer_id
group by c.customer_id;

-- 3. Select the *name* and *email* address of all the customers who have rented the "Action" movies.
    -- 3.1 Write the query using multiple join statements
select CONCAT(c.first_name, ' ', c.last_name) AS customer_name, c.email
from rental r
join customer c
on c.customer_id = r.customer_id
join inventory i
on r.inventory_id = i.inventory_id
join film_category fc
on i.film_id = fc.film_id
where fc.category_id = 1
group by c.customer_id;

    -- 3.2 Write the query using sub queries with multiple WHERE clause and `IN` condition



    -- 3.3 Verify if the above two queries produce the same results or not

-- 4. Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount 
-- of payment. If the amount is between 0 and 2, label should be `low` and if the amount is between 2 and 4, the label should be `medium`, 
-- and if it is more than 4, then it should be `high`.
select payment_id,
	sum(case when amount between 0 and 2 then amount end) low,
    sum(case when amount between 2 and 4 then amount end) medium,
    sum(case when amount > 4 then amount end) high
from payment
group by payment_id;