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
