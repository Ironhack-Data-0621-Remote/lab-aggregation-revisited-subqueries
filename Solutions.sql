--  1. Select the first name, last name, and email address of all the customers who have rented a movie.
USE sakila;

SELECT c.first_name, c.last_name, c.email
FROM sakila.customer c
RIGHT JOIN sakila.rental r
ON c.customer_id = r.customer_id
GROUP BY r.customer_id;

-- 2. What is the average payment made by each customer (display the *customer id*, *customer name* (concatenated), and the *average payment made*).

SELECT c.customer_id, concat(c.first_name, " ", c.last_name) as customer_name
		, round(avg(p.amount), 2) as average_payment_made
FROM sakila.payment p
JOIN sakila.customer c
ON p.customer_id = c.customer_id
GROUP BY p.customer_id;

-- 3. Select the *name* and *email* address of all the customers who have rented the "Action" movies.
    -- 3.1 Write the query using multiple join statements
    
SELECT concat(c.first_name, " ", c.last_name) as name, c.email
FROM sakila.rental r
JOIN sakila.customer c
ON r.customer_id = c.customer_id
JOIN sakila.inventory i
ON r.inventory_id = i.inventory_id
JOIN sakila.film_category fc
ON i.film_id = fc.film_id
JOIN sakila.category cat
ON fc.category_id = cat.category_id
WHERE cat.name = 'Action'
GROUP BY r.customer_id
;

    -- 3.2 Write the query using sub queries with multiple WHERE clause and `IN` condition

SELECT name, email FROM (
SELECT concat(first_name, " ", last_name) as name, email, customer_id
FROM sakila.customer
) sub1
WHERE sub1.customer_id in (
SELECT customer_id FROM sakila.rental
WHERE inventory_id in (
SELECT inventory_id FROM sakila.inventory
WHERE film_id in (
SELECT film_id FROM sakila.film_category
WHERE category_id in (
SELECT category_id FROM sakila.category
WHERE name = 'Action')
)));

    -- 3.3 Verify if the above two queries produce the same results or not

drop procedure if exists check_query_results;
 
 delimiter //
 create procedure check_query_results (out result1 varchar(50))
 begin
	declare result varchar(50) default "";
    
  WITH cte_1 AS (
SELECT concat(c.first_name, " ", c.last_name) as name, c.email
FROM sakila.rental r
JOIN sakila.customer c
ON r.customer_id = c.customer_id
JOIN sakila.inventory i
ON r.inventory_id = i.inventory_id
JOIN sakila.film_category fc
ON i.film_id = fc.film_id
JOIN sakila.category cat
ON fc.category_id = cat.category_id
WHERE cat.name = 'Action'
GROUP BY r.customer_id

), cte_2 AS (
SELECT name, email FROM (
SELECT concat(first_name, " ", last_name) as name, email, customer_id
FROM sakila.customer
) sub1
WHERE sub1.customer_id in (
SELECT customer_id FROM sakila.rental
WHERE inventory_id in (
SELECT inventory_id FROM sakila.inventory
WHERE film_id in (
SELECT film_id FROM sakila.film_category
WHERE category_id in (
SELECT category_id FROM sakila.category
WHERE name = 'Action')
)))
)
SELECT count(cte1.name) as param1, count(cte2.name) as param2,
(CASE 
WHEN count(cte1.name) = count(cte2.name) THEN 'Both queries have the same results'
WHEN count(cte1.name) <> count(cte2.name) THEN 'The queries present different results'
END) as result
FROM cte_1 cte1
JOIN cte_2 cte2
ON cte1.name = cte2.name;

select result into result1;
 end ;
 //
 delimiter ;
 
 call check_query_results(@x);
 
-- 4. Use the case statement to create a new column classifying existing columns as either 
-- or high value transactions based on the amount of payment. 
-- If the amount is between 0 and 2, label should be `low` and 
-- if the amount is between 2 and 4, the label should be `medium`, and 
-- if it is more than 4, then it should be `high`.

SELECT *, 
(CASE 
WHEN amount > 4 THEN 'high'
WHEN amount <= 4 AND amount > 2 THEN 'medium'
WHEN amount < 2 THEN 'low'
END) as label
FROM sakila.payment
;
