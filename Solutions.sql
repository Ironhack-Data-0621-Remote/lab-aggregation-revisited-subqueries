use sakila;

--  1. Select the first name, last name, and email address of all the customers who have rented a movie.
with cte_1 as(
	select c.customer_id, c.first_name, c.last_name, c.email
    from customer c
    join rental r
    on c.customer_id = r.customer_id
)
select first_name, last_name, email
from cte_1
group by customer_id;

-- 2. What is the average payment made by each customer (display the *customer id*, *customer name* (concatenated), and the *average payment made*).
with cte_1 as(
	select c.customer_id, concat(c.first_name, ' ', c.last_name) as name, c.email, p.amount
    from customer c
    join rental r
    on c.customer_id = r.customer_id
    join payment p
    on r.rental_id = p.rental_id
)
select customer_id, name, round(avg(amount),2) avg_payment
from cte_1
group by customer_id;


-- 3. Select the *name* and *email* address of all the customers who have rented the "Action" movies.
    -- 3.1 Write the query using multiple join statements
with cte_1 as(
	select c.customer_id, concat(c.first_name, ' ', c.last_name) as name, c.email, ca.name as category_name
    from customer c
    join rental r
    on c.customer_id = r.customer_id
	join inventory i
    on r.inventory_id = i.inventory_id
    join film_category f
    on i.film_id = f.film_id
    join category ca
    on f.category_id = ca.category_id
)
select distinct(name), email
from cte_1
where category_name = 'Action'
order by name;

    -- 3.2 Write the query using sub queries with multiple WHERE clause and `IN` condition
select concat(first_name, ' ', last_name) as name, email
from customer
where customer_id in (
	select customer_id from rental 
    where inventory_id in (
		select inventory_id from inventory
        where film_id in (
			select film_id from film_category
            where category_id in(
				select category_id from category
                where name = 'Action'
				)
			)
        )
	)
order by name;

    -- 3.3 Verify if the above two queries produce the same results or not
	-- Both queries returned 510 rows. 

-- 4. Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. If the amount is between 0 and 2, label should be `low` and if the amount is between 2 and 4, the label should be `medium`, and if it is more than 4, then it should be `high`.

select payment_id, customer_id, amount,
	case 
		when amount <= 2 then 'low'
		when (amount > 2 and amount <= 4) then 'medium'
		else 'high'
	end as amount_level
from payment;