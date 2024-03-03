--ex1: datalemur-duplicate-job-listings
with dup_com as
(select company_id, title, description,count(job_id)
from job_listings
group by company_id, title, description
having count(job_id)>=2)
select count(*)
from dup_com;

--ex2: datalemur-highest-grossing
with appliance as 
(select category, product, sum(spend)
from product_spend
where extract(year from transaction_date)=2022
and (category='appliance')
group by category, product
order by sum(spend) desc
limit 2),
electronics as
(select category, product, sum(spend)
from product_spend
where extract(year from transaction_date)=2022
and (category='electronics')
group by category, product
order by sum(spend) desc
limit 2)
select * from appliance
union all select * from electronics;

--ex3: datalemur-frequent-callers
with cases as (select policy_holder_id, count(case_id)
from callers
group by policy_holder_id
having count(case_id)>=3)
select count(*)
from cases;

--ex4: datalemur-page-with-no-likes
SELECT page_id
from pages
where page_id not in 
(select page_id from page_likes);

--ex5: datalemur-user-retention

--ex6: leetcode-monthly-transactions

