
-- SQL PROJECT - 1: ECOMMERCE SALES AND CUSTOMER ANALYTICS
-- __________________________________________________________
-- 1.Busness Scenarioo:

-- Imagine tha we are working as a Data Analyst for an e-commerce company

-- The company sells products through  its website.Every day,customers place orders,make payments and product from diffrent categories.

-- The company collects information from different business systems:
-- 1.Customer registration system
-- 2.Order management system
-- 3.Product cataloge
-- 4.Payment system
-- 5.Order-item records

-- Management wants to understand how the business is performing.
-- They want answers to questions such as:
-- Q1.What is the total revenue?
-- Q2.Which products generate  the highest revenue?
-- Q3.Which cities generate the most sales?
-- Q4.Who are the repeat customers?
-- Q5.What is the average order value?
-- Q6.How many orders are cancelled?
-- Q7.How is monthly revenue changing?

-- Our responibality is to consolidate the information and SQL reports

-- 2.Tool and Technologies
--  Tools                     Purpose
-- 1.MySQL8.0             Relational Database
-- 2.MySQL workbench      Writing and execiteing SQL
-- 3.SQL                  Data Quring and Analysis
-- 4.Excel                Optional result inspection
-- github                 Project publishing

-- 3.Database design:
-- We will create five tables:

-- 1.customers:
-- Stores customer information
-- column                Description
-- customer_id          Unique customer identifier
-- customer_name         Customer Name
-- City                  Customer City
-- Registration_date     Registration Date

-- Products:
-- Storse products information
-- column                Description
-- product_id            Unique product identifier
-- product_name          Product name
-- category              Product category
-- price                 Product price

-- 2.Orders:
-- Stores order level informaton
-- Column                Description
-- order_id             Unique order identifire
-- customer_id       Customer who placed the order
-- order_date           Date of order
-- status               Order status

-- order_items:
-- Stores productd included in each order
-- Column               Description
-- item_id              Unique item identifir
-- order_id             Purchased order
-- quantity             Purchased quantity
-- unit_price           Price at the time purchase

-- Payments:
-- Storse payment method
-- Column                Description
-- payment_id            Unique payment identifir
-- order_id              Associated order
-- payment method        Card,UPI,net banking,etc
-- amount                payment amount
-- payment_status        Successful,failed,refunded

-- 4.STEP 1 - CREATE DATABASE:
-- Create database
create database ecommerce_analytics; -- is database name
USE ecommerce_analytics; 

-- 5.step 2 - Create Tables
create table customers (
customer_id int PRIMARY KEY,
customer_name VARCHAR(100),
city VARCHAR(50),
registration_date date
);



-- Create table product
create table products(
product_id int PRIMARY KEY,
product_name VARCHAR(100),
category VARCHAR(50),
price DECIMAl(10,2)
);



-- Create order table
create table orders(
order_id int PRIMARY KEY,
customer_id int,
order_date DATE,
status VARCHAR(30),
FOREIGN KEY (customer_id) 
REFERENCES customers(customer_id)
);

Create table order_items(
item_id int PRIMARY KEY,
order_id int,
product_id int,
quantity int,
unit_price DECIMAL(10,2),
FOREIGN KEY (order_id) REFERENCES orders(order_id)
);



Create table payments(
payment_id int PRIMARY KEY,
order_id int,
payment_method VARCHAR(30),
amount DECIMAL(10,2),
payment_status VARCHAR(30),
FOREIGN KEY (order_id) REFERENCES orders(order_id)
);



-- Trainer explination
-- A PRIMARY KEY uniquely identifies a record.
-- For example, customer_id identifies one customer.

-- A FOREIGN KEY connects the table with another.
-- The order table contains customer_id,which references the customer table. 
-- This create a relationship between customers and orders.

-- We use DECIMAL(10,2) for financial amounts because it is suitable for storing currency values. 
-- without binary floating_point rounding behaviour associated with approximate numeric types. 

-- 6.STEP 3. LOAD THE DATA:
-- student should use publice ecommerce dataset or prepare a large synthetic datset
-- Recommended dataset characteristics:
-- 5,000 - 20,000 customers
-- 10000 - 50,000 orders
-- 500 - 2,000 products
-- Multiple product categories
-- Multiple cities
-- Diffrent order statuses
-- Diffrent payment method

-- The dataset should include realistic relationalship between customerIDs,orderIDs and productIDs,

-- Import the file into the respective tables using MySQL Workbench's Table data Import Wizard or 
-- LOAD DATA after configuring file access. 

-- AFTER lOADING DATA

select * from customers limit 10;

select * from products limit 10;

select * from orders limit 10;

select * from order_items limit 10;

select * from payments limit 10;

-- Explain the limit 10 restricts the output to ten rows.it does not delete and change the uderlyning data. 

-- 7.STEP 4 - PERFORM DATA VALIDATION:
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

-- Trainer explination
-- Data validation is important because incorrect records can produce incorrect business reports.
-- A duplicate order can inflate revenue. An invalid quantity can produce incorrect product sales. 
-- A missing customer relationship can cause customer level analysis to be incomplete. 
-- Student should document validation result and explain how handled each issue

-- 8 STEP 5 - PERFORM BUSINESS ANALYSIS
-- Q1.Find total delivered orders
SELECT
     COUNT(*) as completed_orders
FROM orders
WHERE status = 'Delivered';

-- Q2.Calculate total revenue
SELECT 
     sum(p.amount) as total_revenue
from payments p 
JOIN orders o ON p.order_id = o.order_id
WHERE p.payment_status= 'Successful'
AND o.status = 'Delivered';

-- Q3.Calulate revenue by product
SELECT pr.product_name,
       o.status,
       SUM(oi.quantity *oi.unit_price) AS total_revenue
FROM products pr
JOIN order_items oi ON pr.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Delivered'
GROUP BY pr.product_name
ORDER BY total_revenue desc;

-- we join order otems with products to retrivr product names
-- we calxulate item revenue using
-- quantity * unit_price
-- We group records by product and sort the revenue from highest to lowest.


-- Q4.Find th top 10 products
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

-- Q5.Calculate city wise revenue
SELECT c.city,
       o.status,
       SUM(oi.quantity * oi.unit_price) as revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Delivered'
GROUP BY c.city,o.status
ORDER BY revenue desc;

-- Q6 identify repeat customers
select c.customer_id,
       c.customer_name,
       o.status,
       COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'Delivered'
GROUP BY c.customer_id,c.customer_name
HAVING COUNT(DISTINCT o.order_id) >1;

-- Q7 Calculate monthly revenue
SELECT
      DATE_FORMAT(o.order_date,'%Y-%m') AS sales_month,
      SUM(oi.quantity * oi.unit_price) AS monthly_revenue
FROM orders o 
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Delivered'
GROUP BY DATE_FORMAT(o.order_date,'%Y-%m')
ORDER BY sales_month desc;

-- Q8 Calculate Average order values
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


-- 9.STEP 7- CREATE BUSINESS REPORTS
-- The final report should contain
-- 1.Total Delevered orders
-- 2.Total successful revenue
-- 3.Top 10 products
-- 4.Revenue by category
-- 5.Revenue by city
-- 6.Repeat customer count
-- 7.Average order values
-- 8.Cancelled order count


        
     
