USE sakila; 

--  1. Select the first name, last name, and email address of all the customers who have rented a movie.
SELECT first_name, last_name, email
FROM customer
WHERE customer_id IN
(SELECT DISTINCT(customer_id)
FROM rental)
ORDER BY last_name ASC;
-- 599 rows 

-- 2. What is the average payment made by each customer (display the *customer id*, *customer name* (concatenated), 
-- and the *average payment made*).
SELECT c.customer_id AS ID, CONCAT(c.first_name," ", c.last_name) AS name, ROUND(AVG(p.amount),2) AS avg_payment
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id;
-- 599 rows 

-- 3. Select the *name* and *email* address of all the customers who have rented the "Action" movies.
    -- 3.1 Write the query using multiple join statements

SELECT CONCAT(c.first_name," ", c.last_name) AS name, email
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON f.film_id = i.film_id
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category cat ON cat.category_id = fc.category_id
WHERE cat.name = "Action"
GROUP BY name, email
ORDER BY name ASC;
-- 510 rows 

    -- 3.2 Write the query using sub queries with multiple WHERE clause and `IN` condition
SELECT CONCAT(first_name," ",last_name) AS customer_name, email
FROM customer 
WHERE customer_id IN (SELECT customer_id
FROM rental
WHERE inventory_id IN (SELECT inventory_id
FROM inventory
WHERE film_id IN (SELECT film_id
FROM film_category
WHERE category_id IN (SELECT category_id
FROM category
WHERE name = 'Action'))))
ORDER BY customer_name ASC;
-- 510 rows 

      -- 3.3 Verify if the above two queries produce the same results or not
      
-- Both queries have a result with 510 rows and the first 5 names are the same (Aaron Selby - Albert Crouse). 
-- So the results seem to be the same.  


-- 4. Use the case statement to create a new column classifying existing columns as either or high value transactions 
-- based on the amount of payment. If the amount is between 0 and 2, label should be `low` and if the amount is 
-- between 2 and 4, the label should be `medium`, and if it is more than 4, then it should be `high`.

SELECT payment_id, amount,
CASE
WHEN amount < 2 THEN 'low'
WHEN amount >=2 AND amount < 4 THEN 'medium'
ELSE 'high'
END AS trans_level
FROM payment
ORDER BY amount DESC;
