USE swiggy;
SELECT * FROM restaurants;
-- 1. Which restaurant of abohar is visited by least number of people?
SELECT  name,city,rating_count AS Least_no FROM restaurants
WHERE city='abohar' AND
rating_count=(SELECT  MIN(rating_count) FROM restaurants WHERE city='abohar');





-- 2. Which restaurant has generated maximum revenue all over india?
SELECT name, cost*rating_count AS revenue
FROM restaurants
WHERE cost*rating_count =(SELECT MAX(cost*rating_count) FROM restaurants);

-- CTE (COMMON TABLE EXPRESSION)
WITH t1 AS(SELECT name, cost*rating_count AS revenue
FROM restaurants)
SELECT name, revenue
FROM t1
WHERE revenue=(SELECT MAX(revenue) FROM t1);

-- 3. How many restaurants are having rating more than the average rating?
SELECT COUNT(*)  AS better_rest FROM restaurants
WHERE rating>(SELECT AVG(rating) FROM restaurants);


-- 4. Which restaurant of Delhi has generated most revenue?
WITH t1 AS (SELECT name,city,cost*rating_count AS revenue
FROM restaurants
WHERE city='Delhi' ) 
SELECT name , revenue FROM t1
WHERE revenue=(SELECT MAX(revenue) FROM t1);


-- 5. Which restaurant chain has maximum number of restaurants?
SELECT name, COUNT(*) AS name_of_outlets
FROM restaurants
GROUP BY name
ORDER BY COUNT(*) DESC
LIMIT 5;


-- 6. Which restaurant chain has generated maximum revenue?
WITH t1 AS (SELECT name, SUM(cost*rating_count) AS revenue
FROM restaurants
GROUP BY name )
SELECT name,revenue 
FROM t1
WHERE revenue=(SELECT MAX(revenue) FROM t1);




-- 7. Which city has maximum number of restaurants?
SELECT city,COUNT(*) FROM restaurants
GROUP BY city
ORDER BY COUNT(*) DESC
LIMIT 1;

-- 8. Which city has generated maximum revenue all over india?

WITH t1 AS (SELECT city, SUM(cost*rating_count) AS revenue
FROM restaurants
GROUP BY city )
SELECT city,revenue 
FROM t1
WHERE revenue=(SELECT MAX(revenue) FROM t1);
-- 9. List 10 least expensive cuisines?
SELECT cuisine, AVG(cost) AS avg_cost
FROM restaurants
GROUP BY cuisine
ORDER BY avg_cost ASC
LIMIT 10;


-- 10. List 10 most expensive cuisines?
SELECT cuisine, AVG(cost) AS avg_cost
FROM restaurants
GROUP BY cuisine
ORDER BY avg_cost DESC
LIMIT 10;


-- 11. What is the city is having Biryani as most popular cuisine
SELECT city,SUM(rating_count) AS biryani_fav
FROM restaurants
WHERE cuisine='Biryani'
GROUP BY city
ORDER BY biryani_fav DESC
LIMIT 1;

-- 12. List top 10 unique restaurants with unique name only throughout the dataset as per generate maximum revenue (Single restaurant with that name)
SELECT DISTINCT(name),SUM(cost*rating_count) AS revenue
FROM restaurants
GROUP BY name
HAVING COUNT(*) =1
ORDER BY revenue DESC
LIMIT 10;