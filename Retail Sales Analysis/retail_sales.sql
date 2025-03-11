-- Retail Sales Analysis Project 

CREATE DATABASE retail_sales_db;

USE retail_sales_db;

-- Create TABLE
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
    
-- Data Exploration & Cleaning

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
    
-- Data Analysis & Findings

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT 
    *
FROM
    retail_sales
WHERE
    sale_date = "2022-11-05";

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022    
SELECT 
    *
FROM
    retail_sales
WHERE
    category = 'Clothing' AND quantity >= 4
        AND EXTRACT(YEAR FROM sale_date) = 2022
        AND EXTRACT(MONTH FROM sale_date) = 11;
        
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
    category, SUM(total_sale) AS Total_Sale
FROM
    retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
    ROUND(AVG(age), 2) AS Avg_Age
FROM
    retail_sales
WHERE
    category = 'Beauty';
    
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT 
    *
FROM
    retail_sales
WHERE
    total_sale > 1000;
   
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
    COUNT(transaction_id) AS Total_trans, category, gender
FROM
    retail_sales
GROUP BY category, gender
ORDER BY Total_trans;

-- Q.7 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
    customer_id, SUM(total_sale) AS Total_sales
FROM
    retail_sales
GROUP BY customer_id
ORDER BY Total_sales DESC
LIMIT 5;

-- Q.8 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
    COUNT(DISTINCT customer_id) as Unique_customers,category
FROM retail_sales
GROUP BY category;

-- Q.9 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
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
 
-- OR

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

-- Q.10 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
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

