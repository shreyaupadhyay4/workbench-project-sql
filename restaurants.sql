USE swiggy;

-- Select all columns from the restaurant table --
SELECT * FROM restaurants;  

-- Display the names and cities of all restaurants--
SELECT name , city from restaurants;

-- Find all restaurants located in Bangalore--
SELECT * FROM restaurants
WHERE city='Bangalore';

-- Find restaurants where the cost is less than or equal to 300 --
SELECT name,cost FROM restaurants
WHERE cost <=300;

-- List the names and ratings of restaurants with a rating greater than 4.0. --
SELECT name,rating FROM restaurants
WHERE rating >4.0;

-- Display all distinct cuisine types available in the dataset.. --
SELECT DISTINCT(cuisine) FROM restaurants;

-- Find all restaurants serving Biryani cuisine. --
SELECT name ,cuisine FROM restaurants
WHERE cuisine='Biryani';


-- Show the top 5 restaurants with the highest ratings. --
SELECT DISTINCT name ,rating FROM restaurants
ORDER BY rating DESC
LIMIT 5;


-- 2nd highest rating --
  SELECT DISTINCT name,rating FROM restaurants
  ORDER BY rating DESC
  LIMIT 1 OFFSET 1;

-- List restaurants with a rating count greater than 1000. --
SELECT name ,rating_count 
FROM restaurants
WHERE rating_count>1000;



-- Count the total number of restaurants in the dataset. --
 Select COUNT(*) AS num_res
 FROM restaurants;
 
 
 
--  Find the average cost of all restaurants.
SELECT AVG(cost)
FROM restaurants;

USE swiggy;
-- Display restaurant names and costs ordered by cost in ascending order.
SELECT name,cost 
FROM restaurants
WHERE cost>49
ORDER BY cost ASC;



-- Find the average rating of restaurants for each city.
SELECT city,AVG(rating)
FROM restaurants
GROUP BY city;


-- Count the number of restaurants available in each city.
SELECT city,COUNT(*) 
FROM restaurants
GROUP BY city;


-- Find the maximum and minimum cost of restaurants for each cuisine.
SELECT cuisine, MIN(cost), MAX(cost)
FROM restaurants
GROUP by cuisine;


 -- List cuisines that have more than 10 restaurants.
 SELECT cuisine ,COUNT(*) FROM restaurants
 GROUP BY cuisine
 HAVING COUNT(*)>10;

 



 -- Find the top 3 cities with the highest number of restaurants.
 SELECT city,COUNT(*)
 FROM restaurants
 GROUP BY city
 ORDER BY COUNT(*) DESC
 LIMIT 3;


-- Display the average cost of restaurants for each cuisine.
SELECT cuisine,AVG(cost)
FROM restaurants
GROUP BY cuisine;



-- Find cities where the average restaurant rating is greater than 4.0.
SELECT city,AVG(rating) AS Avg_rating
FROM restaurants
GROUP BY city
HAVING AVG_rating >4.0;



-- List restaurants whose cost is higher than the average cost of all restaurants.
SELECT name,id,cost FROM restaurants
HAVING cost> (SELECT AVG(cost) FROM restaurants);



-- Find the total number of ratings (rating_count) for each city.
SELECT city,SUM(rating_count) FROM restaurants
GROUP by city;



 -- Display cuisines ordered by their average rating in descending order.
 SELECT cuisine ,AVG(rating) FROM restaurants
 GROUP BY cuisine
 ORDER BY AVG(rating) DESC;
 
 
 
 
 -- Find restaurants that have the highest rating within their city.
 
 
 
 
 
 
 
 -- List cities that have more than one cuisine type available.
 SELECT city,COUNT(DISTINCT cuisine) FROM restaurants
 GROUP BY city
 HAVING COUNT(DISTINCT cuisine)>1;



-- Find the restaurant(s) with the maximum rating_count in the dataset.
SELECT id,name, rating_count FROM restaurants
WHERE rating_count=(SELECT MAX(rating_count) FROM restaurants);
 






