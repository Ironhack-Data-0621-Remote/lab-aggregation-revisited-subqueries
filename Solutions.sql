use sakila;


--  1. Select the first name, last name, and email address of all the customers who have rented a movie.
select r.customer_id, c.first_name, c.last_name, c.email
from rental r
join customer c on c.customer_id = r.customer_id
group by r.customer_id; 

-- 2. What is the average payment made by each customer (display the *customer id*, *customer name* (concatenated), and the *average payment made*).
select p.customer_id, concat(c.first_name, " ", c.last_name) as name, p.avg_amount
from(
select customer_id, avg(amount) as avg_amount
from payment 
group by customer_id) p
join customer c on c.customer_id = p.customer_id;


-- 3. Select the *name* and *email* address of all the customers who have rented the "Action" movies.
    -- 3.1 Write the query using multiple join statements
    select distinct(concat(cu.first_name, " ", cu.last_name)) as customer_name, cu.email
from rental r 
join inventory i on i.inventory_id = r.inventory_id
join film_category fc on i.film_id = fc.film_id
join category c on c.category_id = fc.category_id
join customer cu on cu.customer_id = r.customer_id
where c.name = "Action";
    -- 3.2 Write the query using sub queries with multiple WHERE clause and `IN` condition
    -- no idea how to do that...??
    -- 3.3 Verify if the above two queries produce the same results or not

-- 4. Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. If the amount is between 0 and 2, label should be `low` and if the amount is between 2 and 4, the label should be `medium`, and if it is more than 4, then it should be `high`.
select amount,
	CASE
		WHEN amount < 2 then 'low'
        WHEN amount < 4 and amount >=2 then 'medium'
        Else 'high'
	end as label
from payment;