--ex1: hackerrank-more-than-75-marks
select name 
from students
where marks > 75
order by right(name,3), id;

--ex2: leetcode-fix-names-in-a-table
select
user_id,
concat(upper(left(name,1)), lower(right(name, length(name)-1))) as name
from users
order by user_id;

--ex3: datalemur-total-drugs-sales
SELECT manufacturer,
concat('$', round(sum(total_sales)/1000000), ' million') as sale
FROM pharmacy_sales
group by manufacturer
order by round(sum(total_sales)/1000000) desc, manufacturer desc;

--ex4: avg-review-ratings
SELECT extract(month from submit_date) as month, product_id,
round(avg(stars),2) as avg_stars
FROM reviews
group by extract(month from submit_date), product_id
order by extract(month from submit_date), product_id;

--ex5: teams-power-users
SELECT  
sender_id,
count(message_id)
FROM messages
where extract(month from sent_date)=8
and extract(year from sent_date)=2022
group by sender_id
order by count(message_id) desc
limit 2;

--ex6: invalid-tweets
select
tweet_id
from tweets
where length(content) > 15;

--ex7: user-activity-for-the-past-30-days
select 
activity_date as day,
count(distinct user_id) as active_users
from activity
where activity_date between '2019-06-28' and '2019-07-28'
group by activity_date;

select 
activity_date as day,
count(distinct user_id) as active_users
from activity
where datediff(activity_date, '2019-07-27')<30
and activity_date <= '2019-07-27'
group by activity_date;
  

--ex8: number-of-hires-during-specific-time-period
select 
count(id)
from employees
where (extract(month from joining_date) between 1 and 7)
and (extract(year from joining_date)=2022);

--ex9: positions-of-letter-a
select 
position('a' in first_name)
from worker
where first_name = 'Amitah';

--ex10: macedonian-vintages
select winery,
substring(title from length(winery)+2 for 4) 
from winemag_p2
where country = 'Macedonia';

