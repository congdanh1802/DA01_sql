--ex1: hackerrank-weather-observation-station-3
select distinct city from station
where id % 2 = 0;

--ex2: hackerrank-weather-observation-station-4
select 
count(city) - count(distinct city)
from station;

--ex3: hackerrank-the-blunder
