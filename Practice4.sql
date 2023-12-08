--Ex1
SELECT 
COUNT(CASE
WHEN device_type ='laptop' THEN 1
END) AS laptop_views,
COUNT(CASE
WHEN device_type !='laptop' THEN 1
END) AS mobile_views
FROM viewership;
--Ex2
SELECT *,
CASE 
WHEN x+y>z and y+z>x and x+z>y THEN 'Yes' 
ELSE 'No' 
END AS triangle 
FROM triangle; 
--Ex3
SELECT 
CAST
(
COUNT(CASE
WHEN call_category = ('n/a') OR call_category IS NULL THEN 1
END)
/COUNT(*)*100
AS DECIMAL (12,1)
)
AS call_percentage
FROM callers;
--Ex4 
--cách 1
SELECT name FROM Customer         
WHERE referee_id !=2
OR referee_id IS null;
-- cách 2
SELECT name
FROM Customer
WHERE COALESCE(referee_id,'') != 2
--Ex5
SELECT 
 survived,
SUM(CASE WHEN pclass = 1 THEN 1 ELSE 0 END) AS first_class,
SUM(CASE WHEN pclass = 2 THEN 1 ELSE 0 END) AS second_class,
SUM(CASE WHEN pclass = 3 THEN 1 ELSE 0 END) AS third_class
FROM titanic
GROUP BY 
survived
