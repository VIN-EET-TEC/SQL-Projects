# Mentor User Performance Analysis SQL Project

## Overview

This project is designed to showcase essential SQL skills and techniques commonly used by data analysts to explore, clean, and analyze retail sales data. It involves setting up a database, conducting exploratory data analysis (EDA), and using SQL queries to answer key business questions.

## Objectives

- Learn how to use SQL for data analysis tasks such as aggregation, filtering, and ranking.
- Understand how to calculate and manipulate data in a real-world dataset.
- Gain hands-on experience with SQL functions like `COUNT`, `SUM`, `AVG`, `EXTRACT()`, and `DENSE_RANK()`.
- Develop skills for performance analysis using SQL by solving different types of data problems related to user performance.

## Dataset

The dataset consists of information about user submissions for an online learning platform. Each submission includes:
- **User ID**
- **Question ID**
- **Points Earned**
- **Submission Timestamp**
- **Username**

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `mentor`.
- **Table Creation**: A table named `user_submissions` is created to store the data. The table structure includes columns for id, user_id, question_id, points, submitted_at, username.

```sql
CREATE DATABASE mentor;

USE mentor;

CREATE TABLE user_submissions (
    id SERIAL PRIMARY KEY,
    user_id BIGINT,
    question_id INT,
    points INT,
    submitted_at TIMESTAMP,
    username VARCHAR(50)
);

SELECT 
    *
FROM
    user_submissions;

```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **User Count**: Extract the count of distinct user records from the dataset.
- **question_id Count**: Extract all unique question_id present in the dataset.
- **Null Value Check**: Find and delete rows that contain null or NaN values in the dataset.

```sql
-- Data Exploration

SELECT 
    COUNT(*) AS Total_Records
FROM
    user_submissions;
     
SELECT 
    COUNT(DISTINCT user_id) as Unique_User_Count
FROM
    user_submissions;

SELECT DISTINCT
    question_id AS Unique_Question_id
FROM
    user_submissions;
   
-- Data Cleaning

SELECT 
    *
FROM
    user_submissions
WHERE
    id IS NULL
        OR user_id IS NULL
        OR question_id IS NULL
        OR points IS NULL
        OR submitted_at IS NULL
        OR username IS NULL;
        
DELETE FROM user_submissions 
WHERE
    id IS NULL
    OR user_id IS NULL
    OR question_id IS NULL
    OR points IS NULL
    OR submitted_at IS NULL
    OR username IS NULL;

```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

### Q1. List All Distinct Users and Their Stats
- **Description**: Return the user name, total submissions, and total points earned by each user.

```
SELECT 
    username,
    COUNT(id) AS Total_Submissions,
    SUM(points) AS Points_earned
FROM
    user_submissions
GROUP BY username
ORDER BY total_submissions DESC;

```

### Q2. Calculate the Daily Average Points for Each User
- **Description**: For each day, calculate the average points earned by each user.

```
SELECT 
    EXTRACT(DAY FROM submitted_at) AS Day,
    username,
    AVG(points) AS Daily_avg_points
FROM
    user_submissions
GROUP BY Day , username
ORDER BY username;

```

### Q3. Find the Top 3 Users with the Most Correct Submissions for Each Day
- **Description**: Identify the top 3 users with the most correct submissions for each day.

```
SELECT * FROM user_submissions;

WITH daily_submissions
AS
(
	SELECT 
		EXTRACT(DAY FROM submitted_at) as day,
		username,
		SUM(CASE 
			WHEN points > 0 THEN 1 ELSE 0
		END) as correct_submissions
	FROM user_submissions
	GROUP BY 1, 2
),
users_rank
as
(SELECT 
	day,
	username,
	correct_submissions,
	DENSE_RANK() OVER(PARTITION BY day ORDER BY correct_submissions DESC) as Rankk
FROM daily_submissions
)

SELECT 
	day,
	username,
	correct_submissions
FROM users_rank
WHERE Rankk <= 3;

```

### Q4. Find the Top 5 Users with the Highest Number of Incorrect Submissions
- **Description**: Identify the top 5 users with the highest number of incorrect submissions.

```
SELECT 
    username,
    SUM(CASE
        WHEN points < 0 THEN 1
        ELSE 0
    END) AS incorrect_submissions,
    SUM(CASE
        WHEN points > 0 THEN 1
        ELSE 0
    END) AS correct_submissions,
    SUM(CASE
        WHEN points < 0 THEN points
        ELSE 0
    END) AS incorrect_submissions_points,
    SUM(CASE
        WHEN points > 0 THEN points
        ELSE 0
    END) AS correct_submissions_points_earned,
    SUM(points) AS points_earned
FROM
    user_submissions
GROUP BY username
ORDER BY points_earned DESC;

```

### Q5. Find the Top 10 Performers for Each Week
- **Description**: Identify the top 10 users with the highest total points earned each week.

```
SELECT *  
FROM
(
	SELECT 
		EXTRACT(WEEK FROM submitted_at) as Week_no,
		username,
		SUM(points) as Total_points_earned,
		DENSE_RANK() OVER(PARTITION BY EXTRACT(WEEK FROM submitted_at) ORDER BY SUM(points) DESC) as Rankk
	FROM user_submissions
	GROUP BY week_no, username
	ORDER BY week_no, total_points_earned DESC
) as inner_query
where Rankk <=10;

```

## Key SQL Concepts Covered

- **Aggregation**: Using `COUNT`, `SUM`, `AVG` to aggregate data.
- **Date Functions**: Using `EXTRACT()` and `TO_CHAR()` for manipulating dates.
- **Conditional Aggregation**: Using `CASE WHEN` to handle positive and negative submissions.
- **Ranking**: Using `DENSE_RANK()` to rank users based on their performance.
- **Group By**: Aggregating results by groups (e.g., by user, by day, by week).

## Author
- **Email**: vineetgupta798@gmail.com
- **LinkedIn**: [vineet-gupta-01b317231](https://www.linkedin.com/in/vineet-gupta-01b317231/)

