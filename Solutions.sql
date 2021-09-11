--  1. Select the first name, last name, and email address of all the customers who have rented a movie.
SELECT DISTINCT first_name, last_name, email
FROM customer c
JOIN rental r
	ON c.customer_id = r.customer_id;
-- 2. What is the average payment made by each customer (display the *customer id*, *customer name* (concatenated), and the *average payment made*).
SELECT customer_id, CONCAT(first_name, ' ', last_name) AS cust_name, ROUND(AVG(amount), 2) AS average
FROM customer c
JOIN payment p
	USING (customer_id)
GROUP BY 1;
-- 3. Select the *name* and *email* address of all the customers who have rented the "Action" movies.
    -- 3.1 Write the query using multiple join statements
    -- 3.2 Write the query using sub queries with multiple WHERE clause and `IN` condition
    -- 3.3 Verify if the above two queries produce the same results or not
WITH tb1 AS (
SELECT CONCAT(first_name, ' ', last_name) AS cust_name, LOWER(email) AS cust_email
FROM customer cu
),
tb2 AS(
SELECT name AS film_category
FROM category ca
WHERE name = 'Action'
)
SELECT DISTINCT *
FROM tb1
JOIN tb2;

SELECT CONCAT(first_name, ' ', last_name) AS cust_name, LOWER(email) AS cust_email
FROM customer cu
JOIN store st
	ON cu.store_id = st.store_id
JOIN inventory it
	ON st.store_id = it.store_id
JOIN film fi
	ON it.film_id = fi.film_id
JOIN film_category fc
	ON fi.film_id = fc.film_id
JOIN category ct
	ON fc.category_id = ct.category_id;
-- 4. Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. If the amount is between 0 and 2, label should be `low` and if the amount is between 2 and 4, the label should be `medium`, and if it is more than 4, then it should be `high`.
SELECT 	customer_id, 
		CONCAT(first_name, ' ', last_name) AS cust_name, 
		ROUND(AVG(amount), 2) AS average,
        CASE WHEN amount < 2 THEN 'low'
			WHEN amount BETWEEN 2 AND 4 THEN 'medium'
            WHEN amount > 4 THEN 'high' END AS classify
FROM customer c
JOIN payment p
	USING (customer_id)
GROUP BY 1, 2, 4;