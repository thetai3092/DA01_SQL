-- Câu 1
SELECT FORMAT_DATE('%Y-%m',created_at) AS month_year,
               COUNT(DISTINCT user_id) AS total_user,
                             COUNT(id) AS total_orde
FROM bigquery-public-data.thelook_ecommerce.order_items
WHERE status= 'Complete' AND FORMAT_DATE('%Y-%m',created_at) BETWEEN '2019-01' AND '2022-04'
GROUP BY 1
ORDER BY month_year

/*Nhìn tổng quan trong khoảng thời gian từ tháng 1/2019 - 4/2022 có sự tăng trưởng qua từng năm như sau:
--      2019-2020 YoY đạt 238.5%.
        2020-2021 YoY đạt 98.6%
        2021-2022 dự kiến đạt YoY 40.9% nếu không có gì thay đổi
- Trong năm đầu tiên có sự tăng trưởng rất lớn, do mô hình kinh doanh mới, dễ tiếp cận được với nhiều tệp KH,
nắm bắt được xu hướng nhu cầu muốn mua hàng online hiện nay.

- Năm thứ 2 vẫn đạt được tốc độ tăng trưởng lớn do mô hình E-commerce trở nên phổ biến hơn do có nhiều tiện ích về nhiều mặt  
nên vẫn giữ được tốc độ phát triển tốt .

- Năm thứ 3 nếu không có gì thay đổi có thể sẽ đạt tốc độ chậm dần đi theo các năm sắp tới, có thể sẽ xuất hiện các mô hình cạnh tranh hơn
và đặc biệt trong các năm qua ngoài các đơn hàng thành công còn xuất hiện nhiều đơn hàng bị hủy.
- 2019: chiếm 40.8% ; 2020: 38.3% ; 2021: 36.9% ; 4-2022: 37%

  Đây là vấn đề quan trọng vì số đơn hàng Cancelled chiếm gần nửa tổng đơn hàng.Cần các giải phải để giữ được tốc độ phát triển tốt như: xem xét,cải thiện giao diện,các mặt hàng,
quy trình phục vụ,dịch vụ giao hàng, khiếu nại và các phương tiện thanh toán trở nên dễ dàng với Khách hàng.
  Ngoài ra qua dữ liệu cho thấy Quý 1 và Quý 4 trong các năm tăng cao do xu hướng mua hàng trong các dịp lễ quan trọng qua đó có thể phát triển thêm các 
chiến dịch, khuyến mãi, phù hợp cho nhu cầu KH đồng thời phát triển Quý 2 và 3. */

--Câu 2
SELECT FORMAT_DATE('%Y-%m',created_at) AS month_year,
               COUNT(DISTINCT user_id) AS distinct_users,
               ROUND(SUM(sale_price)/COUNT( DISTINCT id),2) AS average_order_value
FROM bigquery-public-data.thelook_ecommerce.order_items
WHERE FORMAT_DATE('%Y-%m',created_at) BETWEEN '2019-01' AND '2022-04'
GROUP BY 1
ORDER BY month_year

/* Tổng quan trong hơn 3 năm từ 2019-4/2022 giá trị trung bình đơn hàng và số lượng khách hàng mỗi tháng như sau:
- Tốc độ số lượng khách hàng tăng ổn định qua từng tháng.
- Giá trị trung bình đơn hàng không nhiều biến đổi xoay quanh giá trị 56 và 62 dù đã hoạt động hơn 3 năm, biến động nhẹ ở Quý 1 và Quý 4
- Mặt tốt là dù tốc độ số lượng khách hàng tăng nhưng vẫn duy trì được ổn định giá trị trung bình
- Mặt còn lại giá trị trung bình không có nhiều biến động cao vượt quá 70, có thể do các mặt hàng còn hạn hẹp không được đa dạng,chính sách 
và truyền thông chưa tốt dẫn đến tốc độ số lượng khách hàng chỉ ở mức ổn định.
- Vì vậy cần các giải pháp để tăng cao giá trị trung bình như bổ sung thêm nhiều mặt hàng có giá trị cao vẫn đáp ứng được nhu cầu mua sắm,vận chuyển, 
các ưu đãi, giảm giá đi kèm khi mua các đơn hàng giá trị thấp và cải thiện giao diện để Khách hàng tiếp cận nhiều hơn.*/

--Câu 3
WITH  young AS
(SELECT first_name, last_name,gender,age,
       MIN(age) OVER(PARTITION BY gender) as youngg
FROM bigquery-public-data.thelook_ecommerce.users
WHERE FORMAT_DATE('%Y-%m',created_at) BETWEEN '2019-01' AND '2022-04'),

     old AS
(SELECT first_name, last_name,gender,age,
       MAX(age) OVER(PARTITION BY gender) as oldd
FROM bigquery-public-data.thelook_ecommerce.users
WHERE FORMAT_DATE('%Y-%m',created_at) BETWEEN '2019-01' AND '2022-04'),
  
     group_ AS
(SELECT *,'youngest' as tag FROM young
where age = youngg
UNION ALL
SELECT *,'oldest' as tag FROM old
where age =oldd)
  
SELECT gender,
SUM(CASE WHEN tag='youngest' THEN 1 ELSE 0 END ) AS youngest ,
SUM(CASE WHEN tag='oldest' THEN 1 ELSE 0 END ) AS oldest
FROM group_
GROUP BY gender

/* Trẻ nhất là 12 tuổi với 638 Nam, 608 Nữ
   Lớn nhất là 70 tuổi với 530 Nam, 556 Nữ*/

--Câu 4
WITH cte as
(SELECT FORMAT_DATE('%Y-%m',created_at) AS month_year,
        a.product_id,b.name AS product_name,
        SUM(a.sale_price)   AS sales,
        SUM(b.cost)         AS cost,
        SUM(a.sale_price)-SUM(b.cost)   AS profit
FROM bigquery-public-data.thelook_ecommerce.order_items AS a
JOIN bigquery-public-data.thelook_ecommerce.products    AS b
ON a.product_id=b.id
GROUP BY 1,2,3),
  
     cte1 AS
(SELECT *,
DENSE_RANK()OVER(PARTITION BY month_year ORDER BY profit DESC) AS RANK_
FROM cte)
  
SELECT * FROM cte1
WHERE RANK_<=5
ORDER BY month_year

--Câu 5
SELECT FORMAT_DATE('%Y-%m-%d',created_at) AS dates,
                               b.category AS product_categorie,
               ROUND(SUM(a.sale_price),2) AS revenue
FROM bigquery-public-data.thelook_ecommerce.order_items as a
JOIN bigquery-public-data.thelook_ecommerce.products as b
ON a.product_id=b.id
WHERE FORMAT_DATE('%Y-%m-%d',a.created_at)BETWEEN '2022-01-15' AND '2022-04-15'
GROUP BY 1,2
ORDER BY 1,2

------------------------------------------------------------------------------------------------------------------------------
--Project 2 III
--Câu 1: Tạo Metric
WITH cte AS
(SELECT FORMAT_DATE('%Y-%m',a.created_at) AS Month,
        FORMAT_DATE('%Y',a.created_at)    AS Year,  
        b.category               AS Product_category,
        ROUND(SUM(sale_price),2) AS TPV,
        COUNT(c.order_id)        AS TPO,
        ROUND(SUM(b.cost),2)     AS Total_cost
FROM bigquery-public-data.thelook_ecommerce.orders      as a 
JOIN bigquery-public-data.thelook_ecommerce.products    as b ON a.order_id=b.id
JOIN bigquery-public-data.thelook_ecommerce.order_items as c ON b.id=c.id 
GROUP BY 1,2,3
)
SELECT Month,Year,Product_category,TPV,TPO,
       ROUND(100.00*(TPV-p_TPV)/p_TPV,2) || '%' AS Revenue_growth ,
       ROUND(100.00*(TPO-p_TPO)/p_TPO,2) || '%' AS Order_growth,
       Total_cost,
       ROUND(TPV-Total_cost,2)              AS Total_profit,
       ROUND((TPV-Total_cost)/Total_cost,2) AS Profit_to_cost_ratio
FROM
(SELECT *,
LAG(TPV) OVER(PARTITION BY Product_category ORDER BY Month) AS p_TPV,
LAG(TPO) OVER(PARTITION BY Product_category ORDER BY Month) AS p_TPO
FROM cte)
ORDER BY 3,1

-- Câu 2
WITH Index_ AS
(SELECT user_id,amount,
        FORMAT_DATE('%Y-%m',DATE_1) AS cohort_date,
        created_at,
        (Extract(YEAR  FROM created_at)  - Extract(YEAR  FROM DATE_1))*12 
        +Extract(MONTH FROM created_at) - Extract(MONTH FROM DATE_1) +1
        AS index
FROM (SELECT user_id, 
      ROUND(sale_price,2) as amount,
      MIN(created_at) OVER(PARTITION BY user_id) AS DATE_1,
      created_at
      FROM bigquery-public-data.thelook_ecommerce.order_items)),
  
     Main_ AS
(SELECT cohort_date,index,
        COUNT(DISTINCT user_id) AS user_cnt,
        ROUND(SUM(amount),2)    AS revenue
FROM Index_
GROUP BY cohort_date,index
ORDER BY index),

    Customer_cohort AS
(SELECT 
cohort_date,
SUM(CASE WHEN index=1 THEN user_cnt else 0 END) as m1,
SUM(CASE WHEN index=2 THEN user_cnt else 0 END) as m2,
SUM(CASE WHEN index=3 THEN user_cnt else 0 END) as m3,
SUM(CASE WHEN index=4 THEN user_cnt else 0 END) as m4 
FROM Main_
GROUP BY 1
ORDER BY 1)
------------- Retention Cohort
SELECT 
cohort_date,
ROUND(100.00* m1/m1,2) || '%' as m1,
ROUND(100.00* m2/m1,2) || '%' as m2,
ROUND(100.00* m3/m1,2) || '%' as m3,
ROUND(100.00* m4/m1,2) || '%' as m4,
FROM Customer_cohort



 







