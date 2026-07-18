/*
===============================================================================
Swiggy Restaurant Data Analysis Project
Author: Shreya Upadhyay
Description: We’re conducting a full analysis of restaurant data to spot market gaps, fine‑tune pricing strategies, and highlight the best locations for expansion.
Database:  MySQL Compatible
===============================================================================
*/

-- ============================================================================
USE swiggy;
-- 1. DATA CLEANING & STANDARDIZATION
-- Issue: Inconsistent capitalization and spelling in cuisine names (e.g., "North-Indian" vs "North Indian")
-- Fix: Standardize 'North-Indian' to 'North Indian' to ensure accurate grouping.
SET SQL_SAFE_UPDATES = 0;

UPDATE restaurants
SET cuisine = 'North Indian'
WHERE cuisine = 'North-Indian';

SET SQL_SAFE_UPDATES = 1;  --  it turn it back on

-- Issue: Missing rating values can skew averages.
-- Fix: Impute NULL ratings with 0 (assuming new restaurants with no ratings yet).
SET SQL_SAFE_UPDATES=0;
UPDATE restaurants
SET rating = 0
WHERE rating=NULL;


-- Issue: Cost outliers (e.g., negative costs or unrealistically high values)
-- Logic: Remove rows where cost is likely an error (e.g., > 50000 or < 50)
DELETE FROM restaurants
WHERE cost<50 or cost>50000;



-- ============================================================================
-- 2. EXPLORATORY DATA ANALYSIS (EDA)
-- ============================================================================

-- Q1: Overview of the Market
-- Goal: Understand the scale of the dataset (Total Restaurants & Cities covered)
SELECT COUNT(id) AS total_rest, COUNT(DISTINCT city) AS total_city FROM restaurants;

-- Q2: Market Saturation
-- Goal: Identify the top 5 cities with the highest number of restaurants.
-- Insight: Helps identify saturated markets vs. emerging markets.
SELECT city,COUNT(id) AS cnt
FROM restaurants
GROUP BY city
ORDER BY cnt DESC
LIMIT 5;

-- Q3: Cost of Living Analysis
-- Goal: Compare the average cost for two across major metropolitan cities.
SELECT city,ROUND(AVG(cost),0) AS cost_for_two  -- cost in table is given for two
FROM restaurants
WHERE city IN ( SELECT DISTINCT city
FROM restaurants
ORDER BY city)
GROUP BY city
ORDER BY cost_for_two DESC;

-- ============================================================================
-- 3. DEEP DIVE: CUISINE & POPULARITY
-- ============================================================================

-- Q4: Most Popular Cuisines (By Vote Volume)
-- Goal: Determine which cuisines have the highest demand based on total rating counts.
SELECT cuisine,SUM(rating_count) AS total_cnt FROM restaurants
GROUP BY cuisine
ORDER BY total_cnt DESC;



-- Q5: Quality vs. Quantity Matrix
-- Goal: Identify cuisines that are High Quality (High Avg Rating) but potentially Niche (Lower Vote Count).
-- Logic: We filter for cuisines with at least 1000 total votes to ensure statistical significance.
SELECT cuisine, ROUND(AVG(rating),2) AS avg_rating ,SUM(rating_count) AS total_cnt,
CASE 
    WHEN SUM(rating_count) >=1000 AND AVG(rating) >=4.0 THEN 'High Quality'
	WHEN SUM(rating_count) >= 1000 AND AVG(rating) < 4.0 THEN 'Mainstream'
	ELSE 'Niche Quality'
END AS cuisine_category
FROM restaurants
GROUP BY cuisine
ORDER BY avg_rating DESC;


-- ============================================================================
-- 4. ADVANCED ANALYTICS (Window Functions & CTEs)
-- ============================================================================

-- Q6: Top Rated Restaurant per City
-- Goal: Find the single highest-rated restaurant in every city.
-- Technique: Use RANK() Window Function to handle ties (e.g., if two restaurants have 4.9 rating).
WITH t1 AS(SELECT name,city, rating ,rating_count,RANK()
OVER(PARTITION BY city ORDER BY rating DESC,rating_count DESC) AS rnk
FROM restaurants
WHERE rating_count>55)
SELECT name,city,rating ,rating_count,RANK()
OVER(ORDER BY rating DESC,rating_count DESC)
FROM t1
WHERE rnk=1;

-- Q7: Market Segmentation (Bucketing)
-- Goal: Categorize restaurants into 'Budget', 'Mid-range', and 'Luxury' segments.
-- Insight: Determine the price distribution of the market.
WITH avg_cost AS (SELECT AVG(cost) AS av_cost FROM restaurants)
SELECT 
CASE
    WHEN cost>10 AND cost < (SELECT av_cost FROM avg_cost)  THEN 'Budget'
    WHEN cost=(SELECT av_cost FROM avg_cost)  THEN 'Mid-range'
    ELSE 'Luxury'
END AS segment,
COUNT(id) AS total_rest_seg,
ROUND(AVG(rating),2) AS rat_seg
FROM restaurants
GROUP BY 1
ORDER BY total_rest_seg DESC;
-- or
SELECT 
    CASE 
        WHEN cost < 300 THEN 'Budget'
        WHEN cost BETWEEN 300 AND 800 THEN 'Mid-range'
        ELSE 'Luxury' 
    END AS price_segment,
    COUNT(id) AS total_restaurants,
    ROUND(AVG(rating), 2) AS avg_rating
FROM restaurants
GROUP BY 1
ORDER BY total_restaurants DESC;


-- ============================================================================
-- 5. BUSINESS INTELLIGENCE & STRATEGY
-- ============================================================================

-- Q8: The "Blue Ocean" Strategy (High Demand, Low Supply)
-- Goal: Find the best City + Cuisine combination to open a new restaurant.
-- Logic: We want a high Total Demand (Rating Count) but Low Competition (Restaurant Count).
SELECT city,cuisine,
COUNT(id) AS supply,
SUM(rating_count) AS demand
FROM restaurants
GROUP BY city,cuisine
HAVING supply<50 -- Low Supply
   AND demand>20000 -- High Demand
ORDER BY demand DESC;

-- Lucknow (Mughlai), Vizag (South Indian), and Chennai (Chettinad) are prime opportunities — huge demand but very few restaurants, making them ideal spots to open a new restaurant.
-- Final Insights
-- Bangalore emerges as the most crowded and competitive dining market.

-- Mumbai stands out with the highest average dining costs.

-- North Indian cuisine dominates in popularity, but Biryani wins on customer satisfaction.

