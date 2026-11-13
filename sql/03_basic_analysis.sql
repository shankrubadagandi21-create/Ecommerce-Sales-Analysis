--Find total delivered orders
SELECT
     COUNT(*) as completed_orders
FROM orders
WHERE status = 'Delivered';

-- Calculate total revenue
SELECT 
     sum(p.amount) as total_revenue
from payments p 
JOIN orders o ON p.order_id = o.order_id
WHERE p.payment_status= 'Successful'
AND o.status = 'Delivered';

-- Calulate revenue by product
SELECT pr.product_name,
       o.status,
       SUM(oi.quantity *oi.unit_price) AS total_revenue
FROM products pr
JOIN order_items oi ON pr.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Delivered'
GROUP BY pr.product_name
ORDER BY total_revenue desc;
