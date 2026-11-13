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

-- Q9. Rank products by revenue
WITH product_sales AS (
   SELECT
       pr.product_id,
       pr.product_name,
       SUM(oi.quantity * oi.unit_price) as revenue
  FROM products pr
  JOIN order_items oi ON pr.product_id = oi.product_id
  JOIN orders o ON oi.order_id = o.order_id
  WHERE o.status = 'Delivered'
  GROUP BY pr.product_id,pr.product_name
)
SELECT
    product_name,
    revenue,
    DENSE_RANK() OVER (ORDER BY revenue desc) as revenue_rank
FROM product_sales;

-- Q10. Calculate month - over - month revenue change
WITH monthly_sales AS (
     SELECT 
           DATE_FORMAT(o.order_date,'%Y-%m') as sales_month,
            SUM(oi.quantity * oi.unit_price) AS revenue
     FROM orders o 
     JOIN order_items oi ON o.order_id = oi.order_id
     WHERE o.status = 'Delivered'
     GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
),
sales_comparison AS (
  SELECT
        sales_month,
        revenue,
        LAG(revenue) OVER (ORDER BY sales_month asc) as privious_month_revenue
  FROM monthly_sales
)
SELECT 
     sales_month,
     revenue,
     privious_month_revenue,
     revenue - privious_month_revenue As revenue_change
FROM sales_comparison;
