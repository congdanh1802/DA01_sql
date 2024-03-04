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
with cte as (select a.user_id, a.event_date as lm , b.event_date as cm
from user_actions as a
join user_actions as b
on a.user_id=b.user_id
where (extract(month from a.event_date)=6 and extract(year from a.event_date)=2022)
and (extract(month from b.event_date)=7 and extract(year from a.event_date)=2022))
select extract(month from cm) as month, count(distinct user_id) as monthly_active_users
from cte
group by extract(month from cm);

--ex6: leetcode-monthly-transactions
select date_format(trans_date, '%Y-%m') as month, country, count(*) as trans_count, 
sum(case when state='approved' then 1 else 0 end) as approved_count ,sum(amount) as trans_total_amount, sum(case when state='approved' then amount else 0 end) as approved_total_amount
from transactions
group by month, country

--ex7: leetcode-product-sales-analysis
select product_id, year as first_year , quantity, price
from sales
where (product_id,year) in (select product_id, min(year)
from sales
group by product_id);

--ex8: leetcode-customers-who-bought-all-products
select customer_id
from customer
group by customer_id
having count(distinct product_key)=(select count(distinct product_key) from product);

--ex9: leetcode-employees-whose-manager-left-the-company
select employee_id
from employees 
where manager_id not in (select distinct employee_id from employees)
and salary < 30000;

--ex10: leetcode-primary-department-for-each-employee
with dup_com as(select company_id, title, description,count(job_id)
from job_listings
group by company_id, title, description
having count(job_id)>=2)
select count(*)
from dup_com;

--ex11: leetcode-movie-rating
select results from
(select u.name results
from users as u
right join movierating as m
on u.user_id=m.user_id
group by u.name
order by count(distinct m.rating) desc, u.name
limit 1) as a
union 
(select mov.title results
from movies as mov
right join movierating as m
on mov.movie_id=m.movie_id
where created_at between '2020-02-01' and '2020-02-29'
group by mov.title 
order by avg(m.rating) desc, results  
limit 1);

--ex12: leetcode-who-has-the-most-friends
with cte as ((select requester_id id ,accepter_id num
from requestaccepted )
union all
(select accepter_id id, requester_id num
from requestaccepted ))
select id, count(num) num
from cte 
group by id 
order by count(num) desc
limit 1;


