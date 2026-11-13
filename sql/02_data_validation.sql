-- PERFORM DATA VALIDATION:
-- Brfor reporting we must verify that the data is relaibl. 

-- Check the duplicate customers
SELECT
     customer_id,
     COUNT(*) as record_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) >1;

-- Check messing customer infomation
SELECT *
FROM customers
WHERE customer_name is NULL
      OR city is NULL;

-- Check invalid quantities
SELECT *
FROM order_items
WHERE quantity <=0;

-- Check invalid Product price
SELECT *
FROM products
WHERE price <0;

-- Check order records without a valid customer
SELECT o.*
FROM orders o 
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
