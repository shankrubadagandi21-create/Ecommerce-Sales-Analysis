-- final business report
-- total Delivered orders
SELECT 
      count(*) AS total_Delivered_oreders
FROM orders
WHERE status = 'Delivered';
        
-- Total susccessful revanue
SELECT 
     SUM(amount) AS total_successful_revenue
FROM payments
WHERE payment_status = 'Successful';

-- Find th top 10 products
SELECT pr.product_id,
        pr.product_name,
        o.status,
       SUM(oi.quantity ) as units_sold,
       SUM(oi.quantity * oi.unit_price) as revenue
FROM products pr
JOIN order_items oi ON pr.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Delivered'
GROUP BY pr.product_id,pr.product_name
ORDER BY revenue desc
LIMIT 10;
     
-- revenue by category
SELECT pr.category,
       SUM(oi.quantity*oi.unit_price) as total_revenue
FROM products pr 
JOIN order_items oi ON pr.product_id = oi.Product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Delivered'
GROUP BY pr.category
ORDER BY total_revenue desc;

-- revenue by city
SELECT c.city,
       o.status,
       SUM(oi.quantity * oi.unit_price) as revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Delivered'
GROUP BY c.city,o.status
ORDER BY revenue desc;

-- identify repeat customers
select c.customer_id,
       c.customer_name,
       o.status,
       COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'Delivered'
GROUP BY c.customer_id,c.customer_name
HAVING COUNT(DISTINCT o.order_id) >1;

-- Calculate Average order values
WITH order_revenue AS (
     SELECT
          o.order_id,
          SUM(oi.quantity * oi.unit_price) as order_total
    FROM orders o 
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Delivered'
    GROUP BY o.order_id
)
SELECT 
      AVG(order_total) As average_ordr_value
FROM order_revenue;

-- Cancelled order values
SELECT COUNT(*) AS cancelled_orders
FROM orders
WHERE status='Cancelled';


