USE sakila;

--  1. Select the first name, last name, and email address of all the customers who have rented a movie.
SELECT last_name, first_name, email
FROM customer c
JOIN rental r
ON c.customer_id = r.customer_id
GROUP BY c.customer_id
ORDER BY last_name;

-- 2. What is the average payment made by each customer (display the *customer id*, *customer name* (concatenated), and the *average payment made*).
SELECT p.customer_id, CONCAT(first_name, ' ', last_name) AS name, ROUND(AVG(amount), 2) AS avg_payment
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY p.customer_id;

-- 3. Select the *name* and *email* address of all the customers who have rented the "Action" movies.
-- 3.1 Write the query using multiple join statements
SELECT CONCAT(first_name, ' ', last_name) AS name, email
FROM customer c
JOIN rental r 
ON r.customer_id = c.customer_id
JOIN inventory i 
ON i.inventory_id = r.inventory_id
JOIN film_category fc 
ON fc.film_id = i.film_id
JOIN category ct ON ct.category_id = fc.category_id
WHERE ct.name = 'Action' 
GROUP BY c.customer_id;
    
-- 3.2 Write the query using sub queries with multiple WHERE clause and `IN` condition
SELECT CONCAT(first_name, ' ', last_name) AS name, email
FROM customer 
WHERE customer_id IN ( 
	SELECT customer_id 
	FROM rental
	WHERE inventory_id IN (
		SELECT inventory_id
		FROM inventory
		WHERE film_id IN (
			SELECT film_id
			FROM film_category
			WHERE category_id IN (
				SELECT category_id
				FROM category
				WHERE name = 'Action'))))
GROUP BY customer_id;    
    
-- 3.3 Verify if the above two queries produce the same results or not
-- The both produce the same number of rows (510) but I don't know how to write a query to check if the results are the same 

-- 4. Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. If the amount is between 0 and 2, label should be `low` and if the amount is between 2 and 4, the label should be `medium`, and if it is more than 4, then it should be `high`.
SELECT *, 
CASE
	WHEN amount < 2 THEN 'low'
	WHEN amount >= 2 AND amount <= 4 THEN 'medium'
	WHEN amount > 4 THEN 'high'
	END AS transaction_level
FROM payment;