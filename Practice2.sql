--Ex1
SELECT DISTINCT CITY 
FROM STATION
WHERE ID%2=0;
--Ex2
SELECT 
COUNT(CITY)-COUNT(DISTINCT CITY)
FROM STATION;
--Ex3
SELECT
CEIL(AVG(Salary)-AVG(REPLACE(salary,0,''))) 
FROM EMPLOYEES;
--Ex4
SELECT 
ROUND(CAST(SUM(item_count*order_occurrences)/SUM(order_occurrences)AS DECIMAL),1)
AS mean
FROM items_per_order;
--Ex5
SELECT candidate_id
FROM candidates
WHERE skill IN('Python','Tableau','PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(skill)=3;
--Ex6
SELECT user_id,
DATE(MAX(post_date))-DATE(MIN(post_date)) 
AS days_between
FROM posts
WHERE post_date BETWEEN '2021-01-01' AND '2022-01-01'
GROUP BY user_id
HAVING COUNT(post_id) >=2;
--Ex7
SELECT card_name,
MAX(issued_amount)-MIN(issued_amount)
AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY MAX(issued_amount)-MIN(issued_amount) DESC;
--Ex8
SELECT manufacturer,
COUNT(drug) AS drug_count,
ABS(SUM(cogs-total_sales)) AS total_loss
FROM pharmacy_sales
WHERE cogs>total_sales
GROUP BY manufacturer
ORDER BY total_loss DESC
--Ex9
SELECT * FROM Cinema
WHERE id%2=1
AND description !="boring"
ORDER BY rating DESC;
--Ex10
SELECT teacher_id, 
COUNT(DISTINCT subject_id) as cnt
FROM Teacher
GROUP BY teacher_id;
--Ex11
SELECT user_id,
COUNT(follower_id) AS followers_count
FROM Followers
GROUP BY user_id
ORDER BY user_id ;
--Ex12
# Write your MySQL query statement below
SELECT class
FROM Courses
GROUP BY class
HAVING COUNT(student) >=5;


