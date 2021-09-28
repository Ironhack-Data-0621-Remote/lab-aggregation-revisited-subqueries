use sakila;
--  1. Select the first name, last name, and email address of all the customers who have rented a movie.
select c.customer_id, c.first_name, c.last_name, c.email, r.rental_id
from customer c
join rental r
on c.customer_id = r.customer_id
where r.rental_id != 0 
group by c.customer_id ;

-- 2. What is the average payment made by each customer (display the *customer id*, *customer name* (concatenated),
--  and the *average payment made*).
select concat(c.customer_id,' ',c.first_name,' ', c.last_name) as customer_details, avg(p.amount) as average_payment_made
from customer c
join payment p
on c.customer_id = p.customer_id
group by c.customer_id;

-- 3. Select the *name* and *email* address of all the customers who have rented the "Action" movies.
    -- 3.1 Write the query using multiple join statements
select concat(c.first_name,' ', c.last_name) as customer_name, c.email,ca.name as category_name
from customer c
join rental r
on c.customer_id = r.customer_id
join inventory i
on r.inventory_id = i.inventory_id
join film_category fc
on i.film_id = fc.film_id
join category ca
on fc.category_id = ca.category_id
where ca.name = 'Action' 
group by c.customer_id ;

-- 3.2 Write the query using sub queries with multiple WHERE clause and `IN` condition

select customer_name, email 
from ( 
select concat(first_name,' ', last_name) as customer_name, email 
from customer c
join rental r
on c.customer_id = r.customer_id
join inventory i
on r.inventory_id = i.inventory_id
join film_category fc
on i.film_id = fc.film_id
join category ca
on fc.category_id = ca.category_id 
where ca.name  = 'Action'
group by c.customer_id
order by c.customer_id
) sub_1
;
 
    -- 3.3 Verify if the above two queries produce the same results or not
 --   yes 510 rows returned
 
-- 4. Use the case statement to create a new column classifying existing
-- columns as either or high value transactions based on the amount of payment.
--  If the amount is between 0 and 2, label should be `low` and if the amount
--  is between 2 and 4, the label should be `medium`, 
-- and if it is more than 4, then it should be `high`.
drop procedure if exists average_payment;

DELIMITER //
create procedure average_payment ()
begin

declare zone varchar(20) default "";

select concat(c.customer_id,' ',c.first_name,' ', c.last_name) as customer_details, avg(p.amount) as average_payment_made
from customer c
join payment p
on c.customer_id = p.customer_id
group by c.customer_id;

case
	when amount > 0 and amount < 2 then
		set zone = 'low';
	when amount <= 2 and amount > 4 then
		set zone = 'medium';
	else
		set zone = 'high';
  end case;
end //
DELIMITER ;