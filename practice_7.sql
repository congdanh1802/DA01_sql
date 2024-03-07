--ex1: datalemur-yoy-growth-rate
SELECT 
extract(year from transaction_date) as year, product_id, spend as curr_year_spend,
lag(spend) over(partition by product_id  order by extract(year from transaction_date)) as prev_year_spend,
round(100.0*(spend-lag(spend) over(partition by product_id  order by extract(year from transaction_date)))/lag(spend) over(partition by product_id  order by extract(year from transaction_date)),2) as yoy_rate
FROM user_transactions;

--ex2: datalemur-card-launch-success
select card_name, issued_amount
from
(SELECT 
card_name, make_date(issue_year, issue_month,1) as issued_date,
row_number() over(partition by card_name order by make_date(issue_year, issue_month,1)) as r, issued_amount
FROM monthly_cards_issued) as a
where r=1
order by issued_amount desc;

--ex3: datalemur-third-transaction
select user_id, spend, transaction_date
from
(SELECT user_id,
rank() over(partition by user_id order by transaction_date) as r, spend, transaction_date
FROM transactions) as a
where r=3
order by user_id, spend, transaction_date;

--ex4: datalemur-histogram-users-purchases
select transaction_date,user_id, count(r)
from
(SELECT user_id,
rank() over(partition by user_id order by transaction_date desc) as r,transaction_date 
FROM user_transactions) as a
where r=1
group by transaction_date,user_id
order by transaction_date;

--
