USE sakila;

#1 Select the first name, last name, and email address of all the customers who have rented a movie.
SELECT DISTINCT first_name, last_name, email
FROM rental r
JOIN customer c
ON r.customer_id = c.customer_id
WHERE rental_id != 0;

#2 What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).
SELECT c.customer_id AS CID, CONCAT(c.first_name," ", c.last_name) AS name, ROUND(AVG(p.amount),2) AS avg_payment
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id;

#3 Select the name and email address of all the customers who have rented the "Action" movies.
--  Write the query using multiple join statements
SELECT DISTINCT c.first_name, c.last_name, c.email
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film_category f ON  f.film_id = i.film_id
JOIN category ca ON ca.category_id = f.category_id
WHERE ca.name = "Action";

-- Write the query using sub queries with multiple WHERE clause and IN condition
SELECT first_name, email
FROM customer
WHERE customer_id IN(SELECT customer_id
FROM rental
WHERE inventory_id IN(SELECT inventory_id 
FROM inventory
WHERE film_id IN(SELECT film_id
FROM film_category
WHERE category_id IN(SELECT category_id
FROM category
WHERE category_id = "1"))));
                        
-- Verify if the above two queries produce the same results or not
-- VERIFIED, they produce the same results!

#4 Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment.
SELECT * , 
CASE
	WHEN amount < 2 THEN "low"
    WHEN amount >= 2  AND amount < 4 then "medium"
    ELSE "high"
END AS value
FROM payment;