--1) Doanh thu theo từng ProductLine, Year  và DealSize?
SELECT ProductLine, Year_id, DealSize,
	     SUM(sales) as Revenue
FROM public.sales_dataset_rfm_prj_clean
GROUP BY 1,2,3
ORDER BY 1,2,3

--2) Đâu là tháng có bán tốt nhất mỗi năm?
SELECT * FROM
(SELECT year_id,month_id, 
	      SUM(sales)         as revenue,
	      COUNT(ordernumber) as ORDERNUMBER,
RANK() OVER(PARTITION BY year_id 
ORDER BY sum(sales) DESC,count(ordernumber) DESC) as rank

FROM public.sales_dataset_rfm_prj_clean
GROUP BY 1,2
)abc
WHERE rank=1
/* Tháng bán tốt nhất trong năm 2003: T11
                                2004: T11
                                2005: T5 */

--3) Product line nào được bán nhiều ở tháng 11?
SELECT month_id,productline, 
	     SUM(sales) 		    as revenue, 
	     COUNT(ordernumber) as order_number
FROM public.sales_dataset_rfm_prj_clean
WHERE month_id = 11
GROUP BY 1,2
ORDER BY 3 DESC

--4) Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm? 
SELECT * FROM
(SELECT year_id,productline,country,
	      SUM(sales)as revenue,
RANK() OVER(PARTITION BY year_id 
ORDER BY sum(sales) DESC) as rank

FROM public.sales_dataset_rfm_prj_clean
WHERE country='UK'
GROUP BY 1,2,3
)abc
WHERE rank=1
/* Sản phẩm có doanh thu tốt nhất ở UK trong năm 2003: Classic Cars
                                                 2004: Classic Cars
                                                 2005: Motorcycles */

--5) Ai là khách hàng tốt nhất, phân tích dựa vào RFM

--B1: RFM
WITH 
rfm AS
(SELECT customername, 
		    current_date - max(orderdate) as R,
	    	count(distinct ordernumber)   as F,
		    sum(sales)                    as M 
FROM public.sales_dataset_rfm_prj_clean
GROUP BY 1),
  
--B2: Chia khoảng
rfm_score as
(SELECT customername,R,F,M,
		ntile(5) OVER(ORDER BY R DESC) as R_score,
		ntile(5) OVER(ORDER BY F ) 	   as F_score,
		ntile(5) OVER(ORDER BY M)      as M_score
FROM rfm),

--B3: Phân nhóm
cte as
(SELECT customername,R,F,M,
		    CAST(R_score as varchar) || CAST(F_score as varchar)|| CAST(M_score as varchar) as rfm_score
FROM rfm_score)

-- Tìm khách hàng tốt nhất
SELECT a.customername,a.rfm_score,b.segment,
	     ROW_NUMBER()OVER(ORDER BY R,F DESC,M DESC) as rank 
FROM cte as a
JOIN public.segment_score as b on a.rfm_score=b.scores
WHERE rfm_score = '555'
LIMIT 1

