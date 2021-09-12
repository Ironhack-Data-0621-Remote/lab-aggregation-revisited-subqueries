--  1. Select the first name, last name, and email address of all the customers who have rented a movie.
use sakila;

SELECT DISTINCT(c.first_name), c.last_name, c.email
FROM rental r
JOIN customer c
ON r.customer_id = c.customer_id;

-- 2. What is the average payment made by each customer 
-- (display the *customer id*, *customer name* (concatenated), and the *average payment made*).

SELECT p.customer_id, CONCAT(c.first_name, ' ', c.last_name), ROUND(SUM(amount)/COUNT(amount),2) AS avg_payment
FROM payment p
JOIN customer c
ON p.customer_id = c.customer_id
GROUP BY p.customer_id;

-- 3. Select the *name* and *email* address of all the customers who have rented the "Action" movies.
    -- 3.1 Write the query using multiple join statements
SELECT * FROM rental; -- rental_id, inventory_id, customer_id
SELECT * FROM inventory; -- inventory_id, film_id
SELECT * FROM customer; -- customer_id
SELECT * FROM film_category; -- film_id, category_id
SELECT * FROM category; -- category_id, name

SELECT CONCAT(cus.first_name, ' ', cus.last_name), cus.email, c.name 
FROM rental r
JOIN inventory i
ON r.inventory_id = i.inventory_id
JOIN film_category f
ON i.film_id = f.film_id
JOIN category c
ON f.category_id = c.category_id
JOIN customer cus
ON r.customer_id = cus.customer_id
WHERE c.name = 'Action';

    -- 3.2 Write the query using sub queries with multiple WHERE clause and `IN` condition
SELECT * FROM (
SELECT CONCAT(cus.first_name, ' ', cus.last_name), cus.email, c.name AS category_name
FROM rental r
JOIN inventory i
ON r.inventory_id = i.inventory_id
JOIN film_category f
ON i.film_id = f.film_id
JOIN category c
ON f.category_id = c.category_id
JOIN customer cus
ON r.customer_id = cus.customer_id) t1
WHERE category_name IN ('Action');

    -- 3.3 Verify if the above two queries produce the same results or not
    -- I dont know how to use multiple where clause for 3.2. I can only think of a solution above.
    -- Both query shows the same results

-- 4. Use the case statement to create a new column classifying existing columns 
-- as either or high value transactions based on the amount of payment. 
-- If the amount is between 0 and 2, label should be `low` and if the amount is between 2 and 4,
-- the label should be `medium`, and if it is more than 4, then it should be `high`.
SELECT payment_id, amount,
CASE
WHEN amount < 2 THEN 'low'
WHEN amount >=2 AND amount < 4 THEN 'medium'
ELSE 'high'
END AS trans_level
FROM payment;
