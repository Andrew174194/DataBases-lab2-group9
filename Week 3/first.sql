-- first task

\c dvdrental;

SELECT * FROM country ORDER BY country_id ASC LIMIT 5 OFFSET 11;
SELECT address FROM address WHERE city_id in (SELECT city_id from city WHERE city LIKE 'A%');
SELECT customer.first_name, customer.last_name, new.city FROM customer INNER JOIN (SELECT address_id, city FROM city INNER JOIN address USING (city_id)) new USING (address_id);
SELECT first_name, last_name FROM customer WHERE customer_id in (select customer_id from payment where amount > 11);
SELECT first_name, COUNT(first_name) FROM customer GROUP BY first_name HAVING COUNT(first_name) > 1;
