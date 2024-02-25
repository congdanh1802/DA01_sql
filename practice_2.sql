--ex1: hackerrank-weather-observation-station-3
select distinct city from station
where id % 2 = 0;

--ex2: hackerrank-weather-observation-station-4
select 
count(city) - count(distinct city)
from station;

--ex3: hackerrank-the-blunder
select 
ceiling(avg(salary) - avg(replace(salary, '0', '')))
from employees;

--ex4: datalemur-alibaba-compressed-mean
select round(cast(sum(item_count*order_occurrences)/sum(order_occurrences) as decimal),1) 
from items_per_order;

--ex5: datalemur-matching-skills
SELECT
candidate_id
FROM candidates
where skill in ('Python', 'Tableau', 'PostgreSQL')
group by candidate_id
having count(skill) = 3
order by candidate_id;

--ex6: datalemur-verage-post-hiatus-1
SELECT user_id,
max(date(post_date)) - min(date(post_date))
FROM posts
where post_date between '01/01/2021' and '01/01/2022'
group by user_id
having count(post_date) >= 2;

--ex7: datalemur-cards-issued-difference
SELECT card_name,
max(issued_amount) - min(issued_amount) as disparity
FROM monthly_cards_issued
group by card_name
order by disparity desc;

--ex8: datalemur-non-profitable-drugs
SELECT manufacturer, count(drug) as count_drug,
sum(abs(total_sales-cogs)) as losses
FROM pharmacy_sales
where cogs>total_sales
group by manufacturer
order by losses desc;

--ex9: leetcode-not-boring-movies
select *
from cinema
where id%2 = 1 and description not like 'boring'
order by rating desc;

--ex10: leetcode-number-of-unique-subject
select teacher_id, count(distinct subject_id) as cnt
from teacher
group by teacher_id;

--ex11: leetcode-find-followers-count
select user_id, count(follower_id) as followers_count
from followers
group by user_id;

--ex12:leetcode-classes-more-than-5-students
select class
from courses 
group by class
having count(distinct student) >= 5;

