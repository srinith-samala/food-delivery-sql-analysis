/* =====================================================
   Project: Food Delivery Data Analysis
   Description: SQL analysis to understand customers,
                restaurants, revenue, and order patterns
   ===================================================== */


/* -----------------------------
   Q1. Total number of orders
------------------------------*/
SELECT 
    COUNT(*) AS total_orders
FROM orders;


/* -----------------------------
   Q2. Total revenue generated
------------------------------*/
SELECT 
    SUM(total_amount) AS total_revenue
FROM orders;


/* -----------------------------
   Q3. Total number of customers
------------------------------*/
SELECT 
    COUNT(DISTINCT customer_id) AS total_customers
FROM customers;


/* -----------------------------
   Q4. Number of restaurants in each city
------------------------------*/
SELECT 
    city,
    COUNT(DISTINCT restaurant_id) AS total_restaurants
FROM restaurants
GROUP BY city;


/* -----------------------------
   Q5. Top 5 restaurants by total revenue
------------------------------*/
SELECT 
    r.restaurant_name,
    SUM(o.total_amount) AS total_revenue
FROM orders o
JOIN restaurants r
    ON o.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_name
ORDER BY total_revenue DESC
LIMIT 5;


/* -----------------------------
   Q6. Total orders placed by each customer
------------------------------*/
SELECT 
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_orders DESC;


/* -----------------------------
   Q7. Average order value per restaurant
------------------------------*/
SELECT 
    r.restaurant_name,
    SUM(o.total_amount) AS total_revenue,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) / COUNT(o.order_id) AS avg_order_value
FROM orders o
JOIN restaurants r
    ON o.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_name
ORDER BY avg_order_value DESC;


/* -----------------------------
   Q8. Customers who placed more than 5 orders
------------------------------*/
SELECT 
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING COUNT(o.order_id) > 5
ORDER BY total_orders DESC;


/* -----------------------------
   Q9. Top 3 restaurants in each city by revenue
------------------------------*/
SELECT *
FROM (
    SELECT 
        r.city,
        r.restaurant_name,
        SUM(o.total_amount) AS total_revenue,
        RANK() OVER (
            PARTITION BY r.city
            ORDER BY SUM(o.total_amount) DESC
        ) AS revenue_rank
    FROM orders o
    JOIN restaurants r
        ON o.restaurant_id = r.restaurant_id
    GROUP BY r.city, r.restaurant_name
) ranked_restaurants
WHERE revenue_rank <= 3;


/* -----------------------------
   Q10. Customer classification based on total spend
------------------------------*/
SELECT 
    c.customer_name,
    SUM(o.total_amount) AS total_spending,
    CASE
        WHEN SUM(o.total_amount) > 5000 THEN 'Premium'
        WHEN SUM(o.total_amount) BETWEEN 2000 AND 5000 THEN 'Gold'
        ELSE 'Regular'
    END AS customer_category
FROM orders o
JOIN customers c
    ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_spending DESC;
