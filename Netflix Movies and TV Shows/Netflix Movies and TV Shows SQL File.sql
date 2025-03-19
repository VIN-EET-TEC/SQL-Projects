-- Netflix Movies and TV Shows Data Analysis SQL Project

CREATE DATABASE netflix_db;
USE netflix_db;

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix (
    show_id VARCHAR(5),
    type VARCHAR(10),
    title VARCHAR(250),
    director VARCHAR(550),
    casts VARCHAR(1050),
    country VARCHAR(550),
    date_added VARCHAR(55),
    release_year INT,
    rating VARCHAR(15),
    duration VARCHAR(15),
    listed_in VARCHAR(250),
    description VARCHAR(550)
);

SELECT * FROM netflix;

-- Q1. Count the number of Movies vs TV Shows?
SELECT 
    type, COUNT(*)
FROM
    netflix
GROUP BY type;

-- Q2. Find the most common rating for movies and TV shows
WITH Rating_Counts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
Ranked_Ratings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rankk
    FROM Rating_Counts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM Ranked_Ratings
WHERE rankk = 1;

-- Q3. List all movies released in year 2020?
SELECT 
    *
FROM
    netflix
WHERE
    release_year = 2020;

-- Q4. Identify the longest movie?
SELECT 
	*
FROM netflix
WHERE type = 'Movie'
ORDER BY duration DESC;

-- Q5. Find all the movies/TV shows by director 'Rajiv Chilaka'?
SELECT 
    *
FROM
    netflix
WHERE
    director LIKE 'Rajiv%';
    
-- Q6. List all TV shows?
SELECT 
    *
FROM
    netflix
WHERE
    TYPE = 'TV Show';


-- Q7. Find each year and the average numbers of content release by India on netflix. 
-- return top 5 year with highest avg content release !
SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(COUNT(show_id) / (SELECT 
                    COUNT(show_id)
                FROM
                    netflix
                WHERE
                    country = 'India') * 100,
            2) AS avg_release
FROM
    netflix
WHERE
    country = 'India'
GROUP BY country , 2
ORDER BY avg_release DESC
LIMIT 5;

-- Q8. List all movies that are documentaries?
SELECT 
    *
FROM
    netflix
WHERE
    listed_in LIKE '%Documentaries%';
    
-- Q9. Find all content without a director?
SELECT 
    *
FROM
    netflix
WHERE
    director IS NULL;
    
-- Q10. Find how many movies actor 'Salman Khan' appeared in last 10 years?
SELECT 
    *
FROM
    netflix
WHERE
    casts LIKE '%Salman Khan%'
        AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
    
-- Q11. Find the top 10 actors who have appeared in the highest number of movies produced in India?
SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
	COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;