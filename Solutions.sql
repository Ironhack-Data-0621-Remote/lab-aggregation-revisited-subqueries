USE sakila;

--  1. Select the first name, last name, and email address of all the customers who have rented a movie.
SELECT first_name, last_name, email
FROM  customer c
JOIN rental r
ON c.customer_id = r.customer_id
GROUP BY last_name;

-- 2. What is the average payment made by each customer 
-- (display the *customer id*, *customer name* (concatenated), and the *average payment made*).
SELECT c.customer_id AS customer_id, concat(upper(substr(first_name,1,1)), lower(substr(first_name,2)), ' ', last_name) AS customer_name, ROUND(AVG(amount),2)
FROM  customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY p.customer_id;

-- 3. Select the *name* and *email* address of all the customers who have rented the "Action" movies.
    -- 3.1 Write the query using multiple join statements

  SELECT concat(upper(substr(first_name,1,1)), lower(substr(first_name,2)), ' ', last_name) AS customer_name, email
  FROM customer c
  JOIN rental r 
  ON c.customer_id = r.customer_id
  JOIN inventory i
  ON r.inventory_id = i.inventory_id
  JOIN film_category fc
  ON i.film_id = fc.film_id
  JOIN category ca
  ON fc.category_id = ca.category_id
  WHERE ca.name = "Action"
  GROUP BY last_name
  ORDER BY last_name;
    
    -- 3.2 Write the query using sub queries with multiple WHERE clause and `IN` condition
SELECT concat(upper(substr(first_name,1,1)), lower(substr(first_name,2)), ' ', last_name) AS customer_name, email
FROM customer 
WHERE customer_id 
IN (SELECT customer_id FROM rental WHERE inventory_id 
IN (SELECT inventory_id FROM inventory WHERE film_id
IN (SELECT film_id FROM film_category WHERE category_id 
IN (SELECT category_id FROM category where name = "Action"))))
GROUP BY customer_name
ORDER BY customer_name;
    
    -- 3.3 Verify if the above two queries produce the same results or not
-- Both queries give us 510 rows back.

-- 4. Use the case statement to create a new column classifying existing columns
-- as either or high value transactions based on the amount of payment. If the amount is between 0 and 2, 
-- label should be `low` and if the amount is between 2 and 4, the label should be `medium`, and if it is more than 4, 
-- then it should be `high`.
select amount,
case
when amount BETWEEN 0 AND 2 then 'low'
when amount BETWEEN 2 AND 4 then 'medium'
else 'high'
end as 'value transaction'
from payment;

