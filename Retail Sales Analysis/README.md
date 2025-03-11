# Retail Sales Analysis SQL Project

## Overview


This project is designed to showcase essential SQL skills and techniques commonly used by data analysts to explore, clean, and analyze retail sales data. It involves setting up a retail sales database, conducting exploratory data analysis (EDA), and using SQL queries to answer key business questions. Ideal for beginners in data analysis, this project helps build a strong foundation in SQL while applying real-world analytical techniques.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `retail_sales_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE retail_sales_db;

USE retail_sales_db;

CREATE TABLE retail_sales (
    transaction_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

SELECT 
    *
FROM
    retail_sales;

```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Extract the count of distinct customer records from the dataset.
- **Category Count**: Extract all unique product categories present in the dataset.
- **Null Value Check**: Find and delete rows that contain null or NaN values in the dataset.

```sql
-- Data Exploration
SELECT 
    COUNT(*) AS Total_Records
FROM
    retail_sales;
     
SELECT 
    COUNT(DISTINCT customer_id) as Unique_Customer_Count
FROM
    retail_sales;

SELECT DISTINCT
    category AS Unique_Category_Count
FROM
    retail_sales;
   
-- Data Cleaning
SELECT 
    *
FROM
    retail_sales
WHERE
    transaction_id IS NULL
        OR sale_date IS NULL
        OR sale_time IS NULL
        OR gender IS NULL
        OR category IS NULL
        OR quantity IS NULL
        OR cogs IS NULL
        OR total_sale IS NULL;
        
DELETE FROM retail_sales 
WHERE
    transaction_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05'.**
```
SELECT 
    *
FROM
    retail_sales
WHERE
    sale_date = "2022-11-05";
```
2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022.**
```
SELECT 
    *
FROM
    retail_sales
WHERE
    category = 'Clothing' AND quantity >= 4
        AND EXTRACT(YEAR FROM sale_date) = 2022
        AND EXTRACT(MONTH FROM sale_date) = 11;
```
3. **Write a SQL query to calculate the total sales (total_sale) for each category.**
```
SELECT 
    category, SUM(total_sale) AS Total_Sale
FROM
    retail_sales
GROUP BY category;
```
4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**
```
SELECT 
    ROUND(AVG(age), 2) AS Avg_Age
FROM
    retail_sales
WHERE
    category = 'Beauty';
```      
5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**
```
SELECT 
    *
FROM
    retail_sales
WHERE
    total_sale > 1000;
```  
6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**
```
SELECT 
    COUNT(transaction_id) AS Total_trans, category, gender
FROM
    retail_sales
GROUP BY category, gender
ORDER BY Total_trans;
```
7. **Write a SQL query to find the top 5 customers based on the highest total sales.**
```
SELECT 
    customer_id, SUM(total_sale) AS Total_sales
FROM
    retail_sales
GROUP BY customer_id
ORDER BY Total_sales DESC
LIMIT 5;
```
8. **Write a SQL query to find the number of unique customers who purchased items from each category.**
```
SELECT 
    COUNT(DISTINCT customer_id) as Unique_customers,category
FROM retail_sales
GROUP BY category;
```
9. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17).**
```
SELECT 
    COUNT(transaction_id) AS Number_of_orders,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift
FROM
    retail_sales
GROUP BY shift;
```
**OR**
```
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;
```
10. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.**
```
SELECT 
       Year,
       Month,
    Avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as Year,
    EXTRACT(MONTH FROM sale_date) as Month,
    AVG(total_sale) as Avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY Year, Month
) as t1
WHERE rank = 1;
SELECT 
    YEAR(sale_date) AS year, 
    MONTH(sale_date) AS month, 
    round(AVG(total_sale),2) AS avg_monthly_sales
FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY year, month;
```
## Findings

- **Customer Demographics**: The dataset encompasses customers of diverse age ranges, with sales spanning multiple categories, including Clothing and Beauty.
- **High-Value Transactions**: Multiple transactions exceeded a total sale amount of 1000, highlighting high-value purchases.
- **Sales Trends**: A monthly sales analysis reveals fluctuations, making it easier to pinpoint peak seasons.
- **Customer Insights**: The report highlights the highest-spending customers and the best-selling product categories.

## Report

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project provides a thorough introduction to SQL for data analysts, focusing on key aspects such as database setup, data cleaning, exploratory analysis, and business-oriented SQL queries. By analyzing sales trends, customer behavior, and product performance, the insights gained can support data-driven business decisions.

## Author
- **Email**: vineetgupta798@gmail.com
- **LinkedIn**: [vineet-gupta-01b317231](https://www.linkedin.com/in/vineet-gupta-01b317231/)

