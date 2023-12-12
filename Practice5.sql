PRACTICE
-- Ex1
SELECT Country.Continent, 
FLOOR(AVG(City.Population))
FROM Country, City 
WHERE Country.Code = City.CountryCode 
GROUP BY Country.Continent ;
-- Ex2
SELECT
ROUND(
SUM(CASE WHEN b.signup_action = 'Confirmed' THEN 1 ELSE 0 END) 
*1.0
/ COUNT(DISTINCT a.user_id),2)
AS confirm_rate
FROM emails AS a
LEFT JOIN texts AS b
ON a.email_id=b.email_id
--Ex3 sài CTE sẽ rút gọn hơn
SELECT b.age_bucket,
-- send_perc = ts/(ts+to)*100.0
ROUND(
SUM(CASE WHEN activity_type='send' THEN time_spent ELSE 0 END)
/(
SUM(CASE WHEN activity_type='send' THEN time_spent ELSE 0 END)
+
SUM(CASE WHEN activity_type='open' THEN time_spent ELSE 0 END)
)*100.0,2) AS send_perc ,
-- open_perc = to/(ts+to)*100.0
ROUND(
SUM(CASE WHEN activity_type='open' THEN time_spent ELSE 0 END)
/(
SUM(CASE WHEN activity_type='send' THEN time_spent ELSE 0 END)
+
SUM(CASE WHEN activity_type='open' THEN time_spent ELSE 0 END)
)*100.0,2) AS open_perc
FROM activities AS a
LEFT JOIN age_breakdown AS b
ON a.user_id=b.user_id
GROUP BY b.age_bucket
-- Ex4 
WITH cte 
AS
(SELECT 
a.customer_id,b.product_category
FROM customer_contracts AS a
LEFT JOIN products AS b
ON a.product_id=b.product_id)

SELECT customer_id
FROM cte
GROUP BY customer_id
HAVING 
COUNT(DISTINCT product_category) = 
(SELECT COUNT(DISTINCT product_category) FROM products);
-- Ex5
SELECT
a.employee_id,
a.name,
COUNT(b.employee_id) AS reports_count,
ROUND(AVG(b.age),0) AS average_age
FROM
Employees a
JOIN Employees b
ON a.employee_id =b.reports_to
group by a.employee_id
order by a.employee_id
--Ex6
SELECT a.product_name,
SUM(b.unit) as unit
FROM Products as a
LEFT JOIN Orders as b
ON a.product_id = b.product_id
WHERE MONTH(b.order_date)=2 AND YEAR(b.order_date)=2020
GROUP BY a.product_name
HAVING unit >= 100
--Ex7
SELECT a.page_id
FROM pages AS a
LEFT JOIN page_likes AS b 
ON a.page_id = b.page_id
WHERE b.page_id IS NULL
ORDER BY a.page_id



MID COURSE
-- Question 1
SELECT DISTINCT replacement_cost FROM film
ORDER BY replacement_cost
LIMIT 1
-- Question 2
SELECT
CASE
WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'LOW'
WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 'MEDIUM'
WHEN replacement_cost BETWEEN 25.00 AND 29.99 THEN 'HIGH'
END quality,
COUNT (*) 
FROM film
WHERE replacement_cost BETWEEN 9.99 AND 19.99 
GROUP BY quality;
-- Question 3
SELECT a.title,a.length,c.name FROM film AS a
JOIN film_category AS b ON a.film_id=b.film_id
JOIN category as c ON b.category_id=c.category_id
WHERE name IN('Drama','Sports')
ORDER BY length DESC
LIMIT 1
-- Question 4
SELECT c.name,
COUNT(title)
FROM film AS a
JOIN film_category AS b ON a.film_id=b.film_id
JOIN category as c ON b.category_id=c.category_id
GROUP BY c.name
ORDER BY COUNT(title) DESC
LIMIT 1
-- Question 5
SELECT a.first_name||' '||a.last_name ,
COUNT(film_id)
FROM actor AS a
JOIN film_actor AS b ON a.actor_id=b.actor_id
GROUP BY a.first_name||' '||a.last_name
ORDER BY COUNT(film_id) DESC
LIMIT 1
-- Question 6
SELECT a.address_id,b.customer_id FROM address AS a
LEFT JOIN customer AS b ON a.address_id=b.address_id
WHERE b.customer_id IS NULL
-- Question 7
SELECT a.city,SUM(amount)
FROM city AS a
JOIN address AS b on a.city_id=b.city_id
JOIN customer AS c on b.address_id=c.address_id
JOIN payment AS d on c.customer_id=d.customer_id
GROUP BY a.city
ORDER BY SUM(amount) DESC
LIMIT 1
-- Question 8
SELECT b.city || ',' || a.country, SUM (amount)
FROM country AS a
JOIN city AS b on a.country_id=b.country_id
JOIN address AS c on b.city_id=c.city_id
JOIN customer AS d on c.address_id=d.address_id
JOIN payment AS e on d.customer_id=e.customer_id
GROUP BY b.city || ',' || a.country
ORDER BY SUM(amount) DESC
LIMIT 1

--fix ex3
SELECT age_bucket,
	ROUND(100*sum(CASE WHEN ac.activity_type = 'send'THEN ac.time_spent END) :: DECIMAL 
  /sum(CASE	WHEN ac.activity_type in ('open','send') THEN ac.time_spent END),2) as send_perc,
	
  ROUND(100* sum(CASE WHEN ac.activity_type = 'open' THEN ac.time_spent END) :: DECIMAL /sum(CASE 
			WHEN ac.activity_type in ('open','send')THEN ac.time_spent END),2) as open_perc
FROM activities AS ac
JOIN age_breakdown AS ab ON ac.user_id = ab.user_id
GROUP BY ab.age_bucket


