--Câu 1 : 
ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE integer USING (ordernumber::integer),
ALTER COLUMN quantityordered TYPE smallint USING (quantityordered::smallint),
ALTER COLUMN priceeach TYPE numeric USING (priceeach::numeric),
ALTER COLUMN orderlinenumber TYPE smallint USING (orderlinenumber::smallint),
ALTER COLUMN sales TYPE numeric USING (sales::numeric),	
ALTER orderdate TYPE TIMESTAMP USING orderdate::TIMESTAMP,
ALTER COLUMN msrp TYPE smallint USING (msrp::smallint)

--Câu 2
SELECT ordernumber,quantityordered,priceeach,orderlinenumber,sales,orderdate
FROM public.sales_dataset_rfm_prj
WHERE ordernumber IS NULL
OR quantityordered IS NULL
OR priceeach IS NULL
OR orderlinenumber IS NULL
OR sales IS NULL
OR orderdate IS NULL

--Câu 3
ALTER TABLE public.sales_dataset_rfm_prj
ADD COLUMN contactfirstname VARCHAR,
ADD COLUMN CONTACTLASTNAME VARCHAR

UPDATE public.sales_dataset_rfm_prj
SET 
CONTACTFIRSTNAME = CONCAT(UPPER(LEFT(contactfullname,1)),
	                        LOWER(SUBSTRING(contactfullname FROM 2 FOR POSITION('-' IN contactfullname)-2))),
  
CONTACTLASTNAME =  CONCAT(UPPER(SUBSTRING(contactfullname FROM POSITION('-' IN contactfullname)+1 FOR 1)),
	                        LOWER(SUBSTRING(contactfullname FROM POSITION('-' IN contactfullname)+2))) 

--Câu 4
ALTER TABLE public.sales_dataset_rfm_prj
ADD COLUMN QTR_ID int,
ADD COLUMN MONTH_ID int,
ADD COLUMN YEAR_ID int

UPDATE public.sales_dataset_rfm_prj
SET QTR_ID=EXTRACT(QUARTER FROM ORDERDATE),
	MONTH_ID=EXTRACT(MONTH FROM ORDERDATE),
	YEAR_ID=EXTRACT(YEAR FROM ORDERDATE)

--Câu 5
--Cách 1: BOX PLOT
WITH cte AS
(SELECT Q1-1.5*IQR AS min_value, Q3+1.5*IQR AS max_value
FROM
(SELECT 
percentile_cont (0.25) WITHIN GROUP (ORDER BY QUANTITYORDERED ) as Q1,
percentile_cont (0.75) WITHIN GROUP (ORDER BY QUANTITYORDERED ) as Q3,
percentile_cont (0.75) WITHIN GROUP (ORDER BY QUANTITYORDERED ) -
percentile_cont (0.25) WITHIN GROUP (ORDER BY QUANTITYORDERED ) as IQR
FROM public.sales_dataset_rfm_prj) as a),
Outlier AS
(SELECT * FROM public.sales_dataset_rfm_prj
WHERE
QUANTITYORDERED < (select min_value from cte) OR
QUANTITYORDERED > (select max_value from cte))
-- Xử lí Outlier
UPDATE public.sales_dataset_rfm_prj
SET QUANTITYORDERED=(SELECT AVG(QUANTITYORDERED) FROM public.sales_dataset_rfm_prj)
WHERE QUANTITYORDERED IN (SELECT QUANTITYORDERED FROM Outlier)
  
--Cách 2: Z-score = (X-avg)/stddev
WITH cte AS
(SELECT QUANTITYORDERED as X, 
(SELECT AVG(QUANTITYORDERED) FROM public.sales_dataset_rfm_prj) as avg_ ,
(SELECT stddev(QUANTITYORDERED) FROM public.sales_dataset_rfm_prj) as stddev 
FROM public.sales_dataset_rfm_prj),

Outlier AS
(select X,(X-avg_)/stddev as z_score
from cte
where abs((X-avg_)/stddev)> 3)
-- Xử lí Outlier
UPDATE public.sales_dataset_rfm_prj
SET QUANTITYORDERED=(SELECT AVG(QUANTITYORDERED) FROM public.sales_dataset_rfm_prj)
WHERE QUANTITYORDERED IN (SELECT X FROM outlier)

--Câu 6
CREATE TABLE SALES_DATASET_RFM_PRJ_CLEAN AS 
SELECT * FROM sales_dataset_rfm_prj



