--Ex1
WITH cte as
(SELECT company_id, title, description, 
COUNT(job_id) AS dup_job
FROM job_listings
GROUP BY company_id, title, description)

SELECT COUNT(DISTINCT company_id)
AS duplicate_companies
FROM cte 
WHERE dup_job>1

--Ex2
WITH cte 
AS
(SELECT category,product,
SUM(spend) AS total_spend,
RANK() OVER (PARTITION BY category 
ORDER BY SUM(spend) DESC) AS rank_spend 
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date)='2022'
group by category,product)

SELECT category,product,total_spend
FROM cte
WHERE rank_spend <=2

--Ex3
WITH cte 
AS
(SELECT policy_holder_id,
COUNT(case_id) as a
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id) >=3)

SELECT COUNT(policy_holder_id) 
AS member_count
FROM cte;

--Ex4
SELECT a.page_id
FROM pages AS a
LEFT JOIN page_likes AS b 
ON a.page_id = b.page_id
WHERE b.page_id IS NULL
ORDER BY a.page_id

--Ex5
WITH cte AS
(SELECT DISTINCT user_id,
EXTRACT(MONTH FROM event_date) AS event_month,
EXTRACT(YEAR FROM event_date) AS event_year
FROM user_actions
WHERE
EXTRACT(MONTH FROM event_date) = '7' AND
EXTRACT(YEAR FROM event_date) = '2022' AND
event_type IN ('sign-in','like','comment') )

SELECT b.event_month AS month,
COUNT(DISTINCT b.user_id) AS monthly_active_users
FROM user_actions AS a
JOIN cte AS b ON a.user_id=b.user_id 
AND EXTRACT(YEAR FROM a.event_date) = b.event_year
WHERE EXTRACT(MONTH FROM a.event_date)=b.event_month -1
GROUP BY b.event_month
  
--Ex6
SELECT
LEFT(trans_date,7) as month,
country, 
COUNT(*) as trans_count, 
SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) as approved_count, 
SUM(amount) as trans_total_amount,  
SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) as approved_total_amount
FROM
Transactions
GROUP BY month, country

--Ex7
SELECT product_id,year AS first_year,quantity,price
FROM Sales
WHERE (product_id,year) IN 
(SELECT product_id,MIN(year)
FROM Sales
GROUP BY product_id)
  
--Ex8
SELECT customer_id
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(*) FROM Product)
  
--Ex9
SELECT employee_id
FROM Employees
WHERE salary <30000 
AND manager_id NOT IN (SELECT employee_id FROM Employees)
ORDER BY employee_id

--Ex10
SELECT employee_id,department_id
FROM Employee
WHERE primary_flag = 'Y'
or employee_id IN
(SELECT employee_id
FROM Employee
GROUP BY employee_id
HAVING COUNT(DISTINCT department_id)=1)

--Ex11
(SELECT u.name AS results
FROM 
MovieRating as mr
JOIN Users as u ON u.user_id=mr.user_id
GROUP BY mr.user_id
ORDER BY COUNT(mr.user_id) DESC,u.name
LIMIT 1)

UNION ALL

(SELECT m.title AS results
FROM 
MovieRating as mr
JOIN Movies as m ON m.movie_id=mr.movie_id
WHERE
EXTRACT(YEAR FROM created_at)='2020' AND
EXTRACT(MONTH FROM created_at)='2'
GROUP BY mr.movie_id
ORDER BY AVG(mr.rating) DESC,m.title
LIMIT 1);

--Ex 12
WITH cte AS
(SELECT requester_id as id FROM RequestAccepted
UNION ALL
SELECT accepter_id as id FROM RequestAccepted)
  
SELECT id,count(*)as num
FROM cte
GROUP BY id
ORDER BY count(*) DESC
LIMIT 1




