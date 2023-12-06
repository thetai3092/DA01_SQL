--Ex1
SELECT NAME FROM CITY
WHERE POPULATION > 120000 
  AND COUNTRYCODE ="USA";
--Ex2
SELECT * FROM CITY
WHERE COUNTRYCODE = "JPN";
--Ex3
SELECT CITY,STATE FROM STATION;
--Ex4
SELECT DISTINCT CITY FROM STATION
WHERE CITY LIKE 'a%' 
OR CITY LIKE 'e%'
OR CITY LIKE 'i%'
OR CITY LIKE 'o%'
OR CITY LIKE 'u%';
--Ex5
SELECT DISTINCT CITY FROM STATION
WHERE CITY LIKE '%a' 
OR CITY LIKE '%e'
OR CITY LIKE '%i'
OR CITY LIKE '%o'
OR CITY LIKE '%u';
--Ex6
SELECT DISTINCT CITY FROM STATION
WHERE CITY NOT LIKE 'a%' 
AND CITY NOT LIKE 'e%'
AND CITY NOT LIKE 'i%'
AND CITY NOT LIKE 'o%'
AND CITY NOT LIKE 'u%';
--Ex7
SELECT name FROM Employee
ORDER BY name ASC;
--Ex8
SELECT name from Employee
WHERE salary > 2000 
AND months <10
ORDER BY employee_id ;
--Ex9
SELECT product_id from Products
WHERE low_fats ='Y'
AND recyclable ='Y';
--Ex10
SELECT name FROM Customer
WHERE referee_id !=2
OR referee_id IS null;
--Ex11
SELECT name,population,area from World
WHERE area >= 3000000
OR population >=25000000;
--Ex12
SELECT DISTINCT author_id AS id FROM Views
WHERE author_id = viewer_id
ORDER BY author_id;
--Ex13
SELECT part,assembly_step FROM parts_assembly
WHERE finish_date is null;
--Ex14
select * from lyft_drivers
WHERE yearly_salary <=30000 
OR yearly_salary >=70000;
--Ex15
select distinct advertising_channel from uber_advertising
WHERE money_spent > 100000
AND year IN (2019);
