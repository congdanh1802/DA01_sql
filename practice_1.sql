--- ex1: hackerank-revising-the-select-query
select name from city
where population > 120000
and countrycode = 'USA';

--- ex2: hackerank-japanese-cities-attributes
select * from city 
where countrycode = 'JPN';

--- ex3: hackerank-weather-observation-station-1
select city, state from station;

--- ex4: hackerank-weather-observation-station-6
select distinct city from station
where city like 'A%'
or city like 'E%'
or city like 'I%'
or city like 'O%'
or city like 'U%';

--- ex5: hackerank-weather-observation-station-7
select distinct city from station
where city like '%a'
or city like '%e'
or city like '%i'
or city like '%o'
or city like '%u';

--- ex6: hackerank-weather-observation-station-9
select distinct city from station
where city not like 'A%'
and city not like 'E%'
and city not like 'I%'
and city not like 'O%'
and city not like 'U%';

--- ex7: hackerank-name-of-employees
select name from employee
order by name;

--- ex8: hackerank-salary-of-employees
select name from employee
where salary > 2000
and months < 10
order by employee_id;

--- ex9: leetcode-recyclable-and-low-fat-products
select product_id from products
where low_fats = 'Y'
and recyclable = 'Y';
