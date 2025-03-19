# Netflix Movies and TV Shows Data Analysis SQL Project

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Q&A

**Q1. Count the number of Movies vs TV Shows?**

```sql
SELECT 
    type, COUNT(*)
FROM
    netflix
GROUP BY type;

```

**Q2. Find the most common rating for movies and TV shows?**

```sql
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

```

**Q3. List all movies released in year 2020?**

```sql
SELECT 
    *
FROM
    netflix
WHERE
    release_year = 2020;

```

**Q4. Identify the longest movie?**

```sql
SELECT 
	*
FROM netflix
WHERE type = 'Movie'
ORDER BY duration DESC;

```

**Q5. Find all the movies/TV shows by director 'Rajiv'?**

```sql
SELECT 
    *
FROM
    netflix
WHERE
    director LIKE 'Rajiv%';

```
    
**Q6. List all TV shows?**

```sql
SELECT 
    *
FROM
    netflix
WHERE
    TYPE = 'TV Show';

```

**Q7. Find each year and the average numbers of content release by India on netflix?**
- return top 5 year with highest avg content release !

```sql
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

```

**Q8. List all movies that are documentaries?**

```sql
SELECT 
    *
FROM
    netflix
WHERE
    listed_in LIKE '%Documentaries%';

```
    
**Q9. Find all content without a director?**

```sql
SELECT 
    *
FROM
    netflix
WHERE
    director IS NULL;

````
    
**Q10. Find how many movies actor 'Salman Khan' appeared in last 10 years?**

```sql
SELECT 
    *
FROM
    netflix
WHERE
    casts LIKE '%Salman Khan%'
        AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

```
    
**Q11. Find the top 10 actors who have appeared in the highest number of movies produced in India?**

```sql
SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
	COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

```

## Findings and Conclusion

- **Diverse Content:** The dataset includes a variety of movies and TV shows across multiple genres and ratings.
- **Audience Insights:** Analysis of common ratings reveals the target audience for the content.
- **Regional Trends:** Insights into top countries and average content releases in India highlight geographical distribution patterns.
- **Content Classification:** Grouping content based on relevant keywords provides a clearer understanding of the types of content available on Netflix.

## Author
- **Email**: vineetgupta798@gmail.com
- **LinkedIn**: [vineet-gupta-01b317231](https://www.linkedin.com/in/vineet-gupta-01b317231/)

