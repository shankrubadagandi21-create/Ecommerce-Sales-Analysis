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
