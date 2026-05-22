-- ================================================
-- Q1: Content type split (Movies vs TV Shows)
-- Insight: Movies make up ~70% of the catalogue
-- ================================================
SELECT type,
       COUNT(*) AS total_titles
FROM netflix_cleaned
GROUP BY type;


-- ================================================
-- Q2: Top 10 countries by number of titles
-- Insight: USA dominates with 3x more content than 
-- India (2nd). South Korea & Egypt show Netflix's 
-- growing investment in non-Western content
-- ================================================
SELECT country,
       COUNT(*) AS total_titles
FROM netflix_cleaned
WHERE country != 'Unknown'
GROUP BY country
ORDER BY total_titles DESC
LIMIT 10;


-- ================================================
-- Q3: Countries with highest TV-MA content ratio
-- Insight: Spain leads at 82.1%. All top 10 are 
-- non-English markets suggesting Netflix targets 
-- mature content for international audiences
-- Skill: CASE WHEN + percentage calculation
-- ================================================
SELECT country,
       COUNT(*) AS total_titles,
       SUM(CASE WHEN rating = 'TV-MA' THEN 1 ELSE 0 END) AS tvma_titles,
       ROUND(SUM(CASE WHEN rating = 'TV-MA' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS tvma_percentage
FROM netflix_cleaned
WHERE country != 'Unknown'
GROUP BY country
HAVING COUNT(*) > 30
ORDER BY tvma_percentage DESC
LIMIT 10;


-- ================================================
-- Q4: Kids vs Adult content gap by country
-- Insight: Spain has 2.1% kids vs 83.4% adult content
-- Colombia, Thailand & Turkey have 0% kids content
-- France is the exception with 11.3% kids content
-- Netflix uses these markets purely for adult content
-- Skill: Multiple CASE WHEN + IN clause
-- ================================================
SELECT country,
       COUNT(*) AS total_titles,
       SUM(CASE WHEN rating IN ('TV-Y', 'TV-Y7', 'G', 'PG') THEN 1 ELSE 0 END) AS kids_titles,
       SUM(CASE WHEN rating IN ('TV-MA', 'R', 'NC-17') THEN 1 ELSE 0 END) AS adult_titles,
       ROUND(SUM(CASE WHEN rating IN ('TV-Y', 'TV-Y7', 'G', 'PG') THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS kids_pct,
       ROUND(SUM(CASE WHEN rating IN ('TV-MA', 'R', 'NC-17') THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS adult_pct
FROM netflix_cleaned
WHERE country != 'Unknown'
GROUP BY country
HAVING COUNT(*) > 30
ORDER BY adult_pct DESC
LIMIT 10;



-- ================================================
-- Q5: Top 3 genres per year
-- Insight: Documentaries & Stand-Up dominated 2013-2019
-- 2020-2021 shifted to International Dramas post-COVID
-- Skill: Window function RANK() OVER (PARTITION BY)
-- ================================================
SELECT year_added,
       genre,
       total_titles,
       genre_rank
FROM (
    SELECT CAST(year_added AS INTEGER) AS year_added,
           listed_in AS genre,
           COUNT(*) AS total_titles,
           RANK() OVER (PARTITION BY year_added ORDER BY COUNT(*) DESC) AS genre_rank
    FROM netflix_cleaned
    WHERE year_added IS NOT NULL
    AND year_added != ''
    GROUP BY year_added, listed_in
) ranked_genres
WHERE genre_rank <= 3
ORDER BY year_added DESC, genre_rank;



-- ================================================
-- Q6: Year on year content growth
-- Insight: 2016 was the turning point with 420.7% growth
-- when Netflix launched globally in 130 new countries
-- 2020-2021 declined due to COVID slowing production
-- Skill: LAG() window function for growth calculation
-- ================================================
SELECT CAST(year_added AS INTEGER) AS year,
       COUNT(*) AS total_titles,
       LAG(COUNT(*)) OVER (ORDER BY year_added) AS previous_year,
       COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY year_added) AS titles_added,
       ROUND((COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY year_added)) * 100.0 / 
       LAG(COUNT(*)) OVER (ORDER BY year_added), 1) AS growth_pct
FROM netflix_cleaned
WHERE year_added IS NOT NULL
AND year_added != ''
GROUP BY year_added
ORDER BY year_added;



-- ================================================
-- Q7: Country growth over time using CTE
-- Insight: USA grew consistently to 2,718 titles
-- India spiked in 2018 with 333 titles in one year
-- South Korea grew from 9 to 199 reflecting K-drama boom
-- Skill: CTE (Common Table Expression) WITH clause
-- ================================================
WITH yearly_country AS (
    SELECT CAST(year_added AS INTEGER) AS year,
           country,
           COUNT(*) AS total_titles
    FROM netflix_cleaned
    WHERE year_added IS NOT NULL
    AND year_added != ''
    AND country != 'Unknown'
    GROUP BY year_added, country
)
SELECT year,
       country,
       total_titles,
       SUM(total_titles) OVER (PARTITION BY country ORDER BY year) AS running_total
FROM yearly_country
WHERE year >= 2016
AND country IN ('United States', 'India', 'United Kingdom', 'South Korea', 'Japan')
ORDER BY country, year;



-- ================================================
-- Q8: Average movie duration by genre
-- Insight: Music & Musicals + Drama longest at 135.6 mins
-- Action & Adventure consistently runs long at 113-133 mins
-- International Movies appear in almost every top genre
-- Skill: AVG() + MIN() + MAX() + HAVING clause
-- ================================================
SELECT listed_in AS genre,
       COUNT(*) AS total_movies,
       ROUND(AVG(duration_int), 1) AS avg_duration_mins,
       MIN(duration_int) AS shortest_mins,
       MAX(duration_int) AS longest_mins
FROM netflix_cleaned
WHERE type = 'Movie'
AND duration_unit = 'min'
AND duration_int IS NOT NULL
GROUP BY listed_in
HAVING COUNT(*) > 20
ORDER BY avg_duration_mins DESC
LIMIT 10;


-- ================================================
-- Q9: Content added by month
-- Insight: July peak at 9.4% (summer) and December 
-- at 9.2% (holidays). February slowest at 6.4%
-- Distribution is even showing Netflix's strategy
-- of keeping subscribers engaged year round
-- Skill: SUM() OVER() for percentage of total
-- ================================================
SELECT month_name,
       CAST(month_added AS INTEGER) AS month_num,
       COUNT(*) AS total_titles,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct_of_yearly
FROM netflix_cleaned
WHERE month_added IS NOT NULL
AND month_added != ''
GROUP BY month_name, month_added
ORDER BY month_num;



-- ================================================
-- Q10: International vs Domestic content ratio
-- Insight: 58.6% of Netflix content is International
-- Only 31.9% is US domestic content
-- Netflix is a global platform not an American one
-- Skill: CASE WHEN + subquery + SUM() OVER()
-- ================================================
SELECT content_origin,
       COUNT(*) AS total_titles,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS percentage
FROM (
    SELECT CASE 
               WHEN country = 'United States' THEN 'Domestic (USA)'
               WHEN country = 'Unknown' THEN 'Unknown Origin'
               ELSE 'International'
           END AS content_origin
    FROM netflix_cleaned
) origin_table
GROUP BY content_origin
ORDER BY total_titles DESC;
