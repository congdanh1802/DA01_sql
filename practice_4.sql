--ex1: datalemur-laptop-mobile-viewership
SELECT 
sum(case 
when device_type='laptop' then 1
else 0
end) as laptop_views,
sum(case 
when device_type in ('tablet','phone') then 1
else 0
end) as mobile_views
FROM viewership;

--ex2: datalemur-triangle-judgement
select x,y,z,
case
when (x+y>z) and (x+z>y) and (y+z>x) then 'Yes'
else 'No'
end triangle
from triangle;

--ex3: datalemur-uncategorized-calls-percentage
SELECT
round(sum(case 
when (call_category is null) or (call_category='n/a') then 1
else 0
end)*100/count(case_id),1) as call_percentage
from callers;

--ex4: datalemur-find-customer-referee
select 
name
from customer
where coalesce(referee_id,1)<>2;

--ex5: stratascratch the-number-of-survivors
select survived,
sum(case
when pclass=1 then 1
else 0
end) as first_class,
sum(case
when pclass=2 then 1
else 0
end) as second_class,
sum(case
when pclass=3 then 1
else 0
end) as third_class
from titanic
group by survived;
