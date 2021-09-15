use sakila;

-- Select the first name, last name, and email address of all the customers who have rented a movie.
select distinct first_name, last_name, email
from rental r
join customer c
on r.customer_id = c.customer_id
where rental_id != 0;

-- What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).
select concat(p.customer_id,"_", c.first_name) as customer, round(avg(p.amount),2) as avg_payment
from rental r
join payment p
on r.rental_id = p.rental_id
join customer c
on r.customer_id = c.customer_id
group by concat(p.customer_id,"_", c.first_name);

-- Select the name and email address of all the customers who have rented the "Action" movies.
		-- Write the query using multiple join statements
select distinct c.first_name, c.last_name, c.email
from rental r
join customer c
on r.customer_id = c.customer_id
join inventory i
on i.inventory_id = r.inventory_id
join film_category f
on  f.film_id = i.film_id
join category c2
on c2.category_id = f.category_id
where c2.name="Action";
		-- Write the query using sub queries with multiple WHERE clause and IN condition
select first_name, email
from customer
where customer_id in(
	select customer_id
	from rental
	where inventory_id in(
		select inventory_id 
		from inventory
		where film_id in(
				select film_id
				from film_category
				where category_id in(
						select category_id
						from category
						where category_id = "1"))));

		-- Verify if the above two queries produce the same results or not
		-- yes, in both cases i get 510 rows.
        
-- Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.
select * , 
case
	when amount < 2 then "low"
    when amount > 2  and amount < 4 then "medium"
    else "high"
end as label
from payment;










