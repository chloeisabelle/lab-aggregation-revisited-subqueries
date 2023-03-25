# 1. Select the first name, last name, and email address of all the customers who have rented a movie

USE sakila;
SELECT concat(first_name,' ',last_name,'',email) as customer_name FROM customer
INNER JOIN rental 
USING(customer_id)
INNER JOIN inventory 
USING (inventory_id)
INNER JOIN film 
USING (film_id)
INNER JOIN film_category
USING (film_id)
INNER JOIN category
USING (category_id)
GROUP BY customer_name
HAVING count(rental_id) 
ORDER BY customer_name;


# 2. What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).

SELECT
    c.customer_id,
    concat((c.first_name), ' ', (c.last_name)) customer_name,
    c.email,
    round(avg(p.amount),2) as average_payment_made
FROM
    payment p
    JOIN customer c USING (customer_id)
GROUP BY
    1
ORDER BY
    2; 

# 3. Select the name and email address of all the customers who have rented the "Action" movies.
# 3a) Write the query using multiple join statements

SELECT
    DISTINCT concat(c.first_name, ' ', c.last_name) customer_name,
    c.email,
    cy.name film_category
FROM
    rental r
    JOIN customer c USING (customer_id)
    JOIN inventory i USING (inventory_id)
    JOIN film_category fc ON i.film_id = fc.film_id
    JOIN category cy USING (category_id)
WHERE
    cy.name = 'Action'
ORDER BY  1; 

# 3b) Write the query using sub queries with multiple WHERE clause and IN condition

SELECT
    DISTINCT concat(first_name, ' ', last_name) customer_name,
    email,
    (
        SELECT
            'Action'
    ) film_category
FROM customer
WHERE
    customer_id IN (
        SELECT
            customer_id
        FROM rental
        WHERE
            inventory_id IN (
                SELECT
                    inventory_id
                FROM inventory
                WHERE
                    film_id IN (
                        SELECT
                            film_id
                        FROM film_category
                        WHERE
                            category_id IN (
                                SELECT
                                    category_id
                                FROM
                                    category
                                WHERE
                                    name = 'Action'
                            )
                    )
            )
    )
ORDER BY 1;  

# 3c Verify if the above two queries produce the same results or not - Answer is yes same result



# 4. Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.

    SELECT
    *,
    CASE
        WHEN amount <= 2 THEN "low"
        WHEN amount <= 4 THEN "medium"
        WHEN amount > 4 THEN "high"
    END AS payment_rating
FROM payment;