Ex1
WITH cte as
(SELECT EXTRACT (year FROM transaction_date) as year,
product_id,
spend as curr_year_spend,
LAG(spend)OVER(PARTITION BY product_id ORDER BY 
product_id,EXTRACT (YEAR FROM transaction_date)) 
AS prev_year_spend
FROM user_transactions)

SELECT * ,
ROUND(100*(curr_year_spend-prev_year_spend)/
prev_year_spend,2)
as yoy_rate
FROM cte;

Ex2
WITH cte as
(SELECT *, RANK() OVER(PARTITION BY card_name ORDER BY issue_year,issue_month) AS rank
FROM monthly_cards_issued)

SELECT card_name,issued_amount
FROM cte
WHERE rank =1
ORDER BY issued_amount DESC
  
Ex3
WITH cte as
(SELECT * ,ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date ) as row
FROM transactions)

SELECT user_id,spend,transaction_date FROM cte 
WHERE row=3;

Ex4
WITH cte as
(SELECT*,
RANK() OVER (PARTITION BY user_id ORDER BY transaction_date DESC) AS rank
FROM user_transactions)

SELECT transaction_date,user_id,
COUNT(user_id) as purchase_count
FROM cte 
WHERE rank=1
GROUP BY transaction_date,user_id;

Ex5
SELECT user_id,tweet_date,   
ROUND
(AVG(tweet_count) OVER (PARTITION BY user_id ORDER BY tweet_date     
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) 
AS rolling_avg_3d
FROM tweets
  
Ex6
WITH cte as
(SELECT transaction_id,
transaction_timestamp as time1,
LAG(transaction_timestamp) OVER (PARTITION BY merchant_id,credit_card_id
ORDER BY transaction_timestamp) as time2
from transactions)

SELECT
COUNT(transaction_id)
FROM cte
WHERE EXTRACT(MINUTE FROM time1-time2)<10

Ex7
WITH cte AS
(SELECT category,product,
SUM(spend) AS total_spend,
RANK() OVER (PARTITION BY category 
ORDER BY SUM(spend) DESC) AS rank_spend 
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date)='2022'
group by category,product)

SELECT category,product,total_spend
FROM cte
WHERE rank_spend <=2;

Ex8
WITH cte AS
(SELECT a.artist_name,
DENSE_RANK() OVER( ORDER BY COUNT(s.song_id) DESC) 
as artist_rank
FROM artists as a
JOIN songs as s ON a.artist_id=s.artist_id
JOIN global_song_rank as r ON r.song_id=s.song_id
WHERE r.rank <=10
GROUP BY a.artist_name)

SELECT artist_name,artist_rank
FROM cte
WHERE artist_rank <=5;
