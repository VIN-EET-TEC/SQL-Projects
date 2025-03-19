# Apple Store Data Analysis SQL Project

This repository includes SQL scripts and datasets designed to analyze Apple Store data. The dataset consists of three tables:

- orders – Contains order details and transaction information.
- customers – Stores customer information and demographics.
- products – Lists product details available in the store.

## Dataset Description

The dataset comprises three key tables with the following details:

Orders – Stores information about customer orders, including:

- Order ID
- Customer ID
- Product ID
- Order date
- Quantity

Customers – Contains customer-related data such as:

- Customer ID
- Name
- Email
- Location

Products – Provides details about available Apple Store products, including:

- Product ID
- Name
- Category
- Price

## Q&A

**Q1. Find out total sales per year?**

```sql
SELECT 
    EXTRACT(YEAR FROM o.order_date) AS YEAR,
    SUM(o.quantity_ordered) AS quantity_sold,
    SUM(o.quantity_ordered * p.price) AS Total_sale
FROM
    orders AS o
        JOIN
    products AS p ON o.product_id = p.product_id
GROUP BY YEAR;

```

**Q.2 Best selling products and their sale?**

```sql
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

```

**Q.3 How many customer does we have?**

```sql
SELECT 
    COUNT(DISTINCT customer_id) AS total_customer
FROM
    customers; 

```

**Q.4 Find out total orders placed by each customer?**

```sql
SELECT 
    customer_id, COUNT(quantity_ordered) AS total_no_order
FROM
    orders
GROUP BY customer_id
ORDER BY total_no_order DESC;

```

**Q.5 Find out total no of orders?**

```sql
SELECT COUNT(*)
FROM orders;

```

**Q.6 Count of payment cash vs credit card?**

```sql
SELECT 
    payment_type, COUNT(payment_type)
FROM
    orders
GROUP BY payment_type;

```

**Q.7 Find out best selling category?**

```sql
SELECT 
    p.product_category,
    COUNT(o.quantity_ordered) AS total_orders
FROM
    orders AS o
        JOIN
    products p ON o.product_id = p.product_id
GROUP BY p.product_category
ORDER BY total_orders DESC;

```

**Q.8 Customer who placed most orders?**

```sql
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

```

**Q.9 Best selling product where payment type is cash?**

```sql
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

```

## Author
- **Email**: vineetgupta798@gmail.com
- **LinkedIn**: [vineet-gupta-01b317231](https://www.linkedin.com/in/vineet-gupta-01b317231/)

