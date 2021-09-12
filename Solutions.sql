USE sakila;
-- Select the first name, last name, and email address of all the customers who have rented a movie.
SELECT first_name, last_name, email
FROM customer;
-- What is the average payment made by each customer? 
-- (display the customer id, customer name (concatenated), and the average payment made).
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, ROUND(AVG(amount), 2) AS average_payment 
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id;
-- Select the name and email address of all the customers who have rented the "Action" movies.
-- Write the query using multiple join statements.
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name, c.email
FROM customer c
JOIN rental r
ON c.customer_id = r.customer_id
JOIN inventory i
ON r.inventory_id = i.inventory_id
JOIN film f
ON i.film_id = f.film_id
JOIN film_category fc 
ON f.film_id = fc.film_id
JOIN category ca
ON fc.category_id = ca.category_id
WHERE ca.name = "Action"
GROUP BY customer_name, c.email;
-- Write the query using sub queries with multiple WHERE clause and IN condition.
SELECT CONCAT(first_name, ' ', last_name) AS customer_name, email
FROM customer
WHERE customer_id IN (SELECT customer_id FROM rental
WHERE inventory_id IN (SELECT inventory_id FROM inventory 
WHERE film_id IN (SELECT film_id FROM film_category
WHERE category_id IN (SELECT category_id FROM category
WHERE name = 'Action'))));
-- Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. 
-- If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high
SELECT *,
CASE
WHEN amount >= 0 AND amount < 2 THEN 'low'
WHEN amount >= 2 AND amount <= 4  THEN 'medium' -- includes 2.00 and 4.00
WHEN amount > 4 THEN 'high'
ELSE NULL END AS transaction_value
FROM payment;
 

 