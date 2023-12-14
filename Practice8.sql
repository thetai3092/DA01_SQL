--Mai em xin nghỉ 1 ngày nha do có việc tối mới xong ạ, xong việc em rảnh review lại bài ^^
Ex1
WITH cte as
(SELECT customer_id, 
MIN(order_date) as time1,
MIN(customer_pref_delivery_date) as time2
FROM Delivery 
GROUP BY customer_id)

SELECT ROUND(AVG(time1 = time2) * 100, 2) AS immediate_percentage
FROM cte
  
Ex2
WITH cte as
(SELECT player_id, 
MIN(event_date) as time1
FROM Activity
GROUP BY player_id)

SELECT ROUND(COUNT(DISTINCT b.player_id)/COUNT(DISTINCT a.player_id),2) as fraction
FROM cte as a
LEFT JOIN Activity as b ON a.player_id=b.player_id
AND DATE_ADD(a.time1, INTERVAL 1 DAY) = b.event_date

Ex3
SELECT id, 
CASE WHEN id%2=1 
THEN COALESCE(LEAD(student) OVER(ORDER BY id), student)
ELSE LAG(student) OVER(ORDER BY id) 
END AS student
FROM Seat 

Ex4
WITH cte as
(SELECT visited_on,sum(amount)as amount
from customer 
group by visited_on),

cte2 as
(SELECT visited_on,
SUM(amount)OVER ( ORDER BY visited_on     
ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)as amount,
ROUND(AVG(amount) OVER ( ORDER BY visited_on     
ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),2) as average_amount,
LAG(visited_on,6) OVER() as 6day_before
FROM cte)

SELECT visited_on,amount,average_amount
FROM cte2
WHERE 6day_before IS not null

Ex5
WITH cte AS 
(SELECT *,
COUNT(lat) OVER(PARTITION BY lat,lon) diff_latlon,
COUNT(tiv_2015) OVER(PARTITION BY tiv_2015) same_tiv
FROM Insurance)

SELECT ROUND(SUM(tiv_2016),2) as tiv_2016 
FROM cte
WHERE diff_latlon = 1 AND same_tiv > 1

Ex6
WITH cte as
(SELECT b.name as Department,a.name as Employee, a.salary as Salary,
DENSE_RANK() OVER (PARTITION BY b.name ORDER BY a.salary DESC) as salary_rank
FROM Employee a JOIN Department b ON a.departmentId= b.id)

SELECT Department,Employee,Salary
FROM cte
WHERE salary_rank<=3

Ex7
WITH cte as
(SELECT person_name,
SUM(weight) OVER(ORDER BY Turn) as limit_
FROM Queue)

SELECT person_name from cte
WHERE limit_ <=1000
ORDER BY limit_ DESC
LIMIT 1

Ex8
SELECT 
product_id, FIRST_VALUE(new_price) OVER(PARTITION BY product_id ORDER BY change_date DESC) AS price 
FROM Products
WHERE change_date <= '2019-08-16'

UNION

SELECT DISTINCT product_id,
10 AS price FROM Products
WHERE product_id NOT IN (SELECT product_id FROM Products WHERE change_date <= '2019-08-16')
