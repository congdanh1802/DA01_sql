#Practice_5
--ex1: hackerrank-average-population-of-each-continent
select co.continent, floor(avg(ci.population))
from city as ci 
join country as co
on ci.countrycode=co.code
group by co.continent;

--ex2: datalemur-signup-confirmation-rate
SELECT 
round(cast(sum(CASE
when t.signup_action='Confirmed' then 1
else 0
end) as decimal)/cast(count(distinct e.email_id) as decimal),2)
FROM emails as e
left join texts as t
on e.email_id=t.email_id;

--ex3: datalemur-time-spent-snaps
SELECT 
b.age_bucket,
round(100.0*sum(case when a.activity_type='send' then a.time_spent else 0 end)
/sum(case when a.activity_type in ('open','send') then a.time_spent else 0 end),2) as send_perc,
round(100.0*sum(case when a.activity_type='open' then a.time_spent else 0 end)
/sum(case when a.activity_type in ('open','send') then a.time_spent else 0 end),2) as open_perc
FROM activities as a
left join age_breakdown as b
on a.user_id=b.user_id
group by b.age_bucket;

--ex4: datalemur-supercloud-customer
SELECT c.customer_id
FROM customer_contracts as c
left join products as p
on c.product_id=p.product_id
group by c.customer_id
having count( distinct p.product_category) = 3;

--ex5: leetcode-the-number-of-employees-which-report-to-each-employee
select man.employee_id,man.name, count(emp.reports_to) as reports_count, round(avg(emp.age)) as average_age
from employees as emp
left join employees as man 
on emp.reports_to=man.employee_id
where emp.reports_to is not null
group by man.employee_id
order by man.employee_id;

--ex6: leetcode-list-the-products-ordered-in-a-period
select 
p.product_name, sum(o.unit) as unit
from orders as o
left join products as p
on o.product_id=p.product_id
where o.order_date between '2020-02-01' and '2020-02-29'
group by p.product_name
having sum(o.unit)>=100;

--ex7: leetcode-sql-page-with-no-likes
SELECT p.page_id
FROM pages as p
left join page_likes as pl
on p.page_id=pl.page_id
where pl.user_id is null
order by p.page_id;

#Midterm_test
