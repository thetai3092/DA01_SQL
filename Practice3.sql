--Ex1
SELECT Name 
FROM STUDENTS
WHERE Marks >75
ORDER BY RIGHT(Name,3),ID;
--Ex2
SELECT user_id, 
CONCAT(UPPER(LEFT(name,1)),LOWER(SUBSTRING(name FROM 2))) 
AS name 
FROM Users 
ORDER BY user_id;
--Ex3
SELECT manufacturer,
'$'||Round(SUM(total_sales)/1000000,0)||' million'
AS sale
FROM pharmacy_sales
GROUP BY manufacturer	
ORDER BY SUM(total_sales) DESC, manufacturer;
--Ex4
SELECT 
Extract(month FROM submit_date) AS month,
product_id AS product,
ROUND(AVG(stars),2) AS avg_stars
FROM reviews
GROUP BY Extract(month FROM submit_date),product
ORDER BY month,product;
--Ex5
SELECT 
sender_id,
COUNT(content) AS message_count
FROM messages
WHERE sent_date BETWEEN '2022-08-01' AND '2022-09-01' --HOẶC SÀI EXTRACT(month FROM sent_date) =8 AND EXTRACT(year FROM sent_date) =2022
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2;
--Ex6
SELECT
tweet_id
FROM Tweets
WHERE LENGTH(content)>15;
--Ex7
SELECT activity_date AS day,
COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date BETWEEN '2019-06-28' AND '2019-07-27'
GROUP BY activity_date;
--Ex8
SELECT
COUNT(id)AS "Employees Hired"
FROM employees
WHERE joining_date BETWEEN '2022-01-01' AND '2022-08-01';
--Ex9
SELECT
POSITION('a' IN first_name)
FROM worker
WHERE first_name = 'Amitah';
--Ex10
SELECT id,
SUBSTRING(title FROM LENGTH(winery)+2 FOR 4)
FROM winemag_p2
WHERE country='Macedonia';



