-- SQL Mentor User Performance 

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

SELECT * FROM user_submissions;

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
 
-- Data Analysis & Findings

-- Q.1 List all distinct users and their stats (return user_name, total_submissions, points earned)
SELECT 
    username,
    COUNT(id) AS Total_Submissions,
    SUM(points) AS Points_earned
FROM
    user_submissions
GROUP BY username
ORDER BY total_submissions DESC;

-- Q.2 Calculate the daily average points for each user.
SELECT 
    EXTRACT(DAY FROM submitted_at) AS Day,
    username,
    AVG(points) AS Daily_avg_points
FROM
    user_submissions
GROUP BY Day , username
ORDER BY username;

-- Q.3 Find the top 3 users with the most correct submissions for each day.
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

-- Q.4 Find the top 5 users with the highest number of incorrect submissions.
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

-- Q.5 Find the top 10 performers for each week.
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
