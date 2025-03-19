-- Apple Store Data Analysis Project

CREATE DATABASE Apple_db;
USE Apple_db;

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(25),
    product_category VARCHAR(15),
    Price FLOAT,
    stock INT
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(25)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    product_id INT,
    quantity_ordered INT,
    customer_id INT,
    payment_type CHAR(10),
    FOREIGN KEY (product_id)
        REFERENCES products (product_id),
    FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id)
);


SELECT 
    *
FROM
    orders;
    

SELECT 
    *
FROM
    customers;
    
SELECT 
    *
FROM
    products;
    
-- Q1. Find out total sales per year
SELECT 
    EXTRACT(YEAR FROM o.order_date) AS YEAR,
    SUM(o.quantity_ordered) AS quantity_sold,
    SUM(o.quantity_ordered * p.price) AS Total_sale
FROM
    orders AS o
        JOIN
    products AS p ON o.product_id = p.product_id
GROUP BY YEAR;

-- Q.2 Best selling products and their sale
SELECT 
    p.product_name,
    SUM(o.quantity_ordered) AS qty_sold,
    SUM(p.price * o.quantity_ordered) AS total_sale
FROM
    orders AS o
        JOIN
    products AS p ON p.product_id = o.product_id
GROUP BY p.product_name
ORDER BY total_sale DESC;

-- Q.3 How many customer does we have
SELECT 
    COUNT(DISTINCT customer_id) AS total_customer
FROM
    customers; 

-- Q.4 Find out total orders placed by each customer 
SELECT 
    customer_id, COUNT(quantity_ordered) AS total_no_order
FROM
    orders
GROUP BY customer_id
ORDER BY total_no_order DESC;

-- Q.5 Find out total no of orders 
SELECT COUNT(*)
FROM orders;

-- Q.6 Count of payment cash vs credit card
SELECT 
    payment_type, COUNT(payment_type)
FROM
    orders
GROUP BY payment_type;

-- Q.7 Find out best selling category
SELECT 
    p.product_category,
    COUNT(o.quantity_ordered) AS total_orders
FROM
    orders AS o
        JOIN
    products p ON o.product_id = p.product_id
GROUP BY p.product_category
ORDER BY total_orders DESC;

-- Q.8 Customer who placed most orders
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(o.quantity_ordered) AS total_orders
FROM
    orders AS o
        JOIN
    customers AS c ON o.customer_id = c.customer_id
GROUP BY c.customer_id , c.customer_name
ORDER BY total_orders DESC;

-- Q.9 Best selling product where payment type is cash.
SELECT 
    p.product_name, COUNT(o.quantity_ordered) AS cnt_order
FROM
    orders AS o
        JOIN
    products AS p ON o.product_id = p.product_id
WHERE
    o.payment_type = 'Cash'
GROUP BY p.product_name
ORDER BY cnt_order DESC
LIMIT 1;