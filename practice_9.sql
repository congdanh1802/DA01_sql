--Tạo table back up
Create table back_up as 
(select * from sales_dataset_rfm_prj);

--Chuyển đổi kiểu dữ liệu phù hợp cho các trường
ALTER TABLE public.back_up
ALTER COLUMN ordernumber TYPE integer USING regexp_replace(ordernumber, '\D', '', 'g')::integer,
ALTER COLUMN quantityordered TYPE smallint USING regexp_replace(quantityordered , '\D', '', 'g')::smallint,
ALTER COLUMN priceeach TYPE numeric USING regexp_replace(priceeach , '\D', '', 'g')::numeric ,
ALTER COLUMN orderlinenumber TYPE smallint USING regexp_replace(orderlinenumber, '\D', '', 'g')::smallint,
ALTER COLUMN sales TYPE numeric USING regexp_replace(sales , '\D', '', 'g')::numeric, 
ALTER COLUMN orderdate TYPE timestamptz
USING to_timestamp(orderdate, 'MM/DD/YYYY HH24:MI') AT TIME ZONE 'UTC',
ALTER COLUMN msrp TYPE smallint USING regexp_replace(msrp , '\D', '', 'g')::smallint;

--Check Null
Select *
from ORDERNUMBER
where ORDERNUMBER is null;
Select *
from QUANTITYORDERED
where QUANTITYORDERED is null;
Select *
from PRICEEACH
where PRICEEACH is null;
Select *
from ORDERNUMBER
where ORDERNUMBER is null;
Select *
from ORDERLINENUMBER
where ORDERLINENUMBER is null;
Select *
from SALES
where SALES is null;
Select *
from ORDERDATE
where ORDERDATE is null;

--Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME
alter table back_up
add column contact_firstname varchar,
add column contact_lastname varchar;

UPDATE back_up
SET contact_firstname = upper(left(contactfullname,1)) || substring(contactfullname, 2 , position('-' in contactfullname)-2);
UPDATE back_up
set contact_lastname = upper(substring(contactfullname from (position('-' in contactfullname)+1) for 1)) || right(contactfullname, length(contactfullname) - position('-' in contactfullname)-1);

--Thêm cột QTR_ID, MONTH_ID, YEAR_ID
alter table back_up
add column qrt_id numeric, 
add column month_id numeric, 
add column year_id numeric;

UPDATE back_up
SET qrt_id = CASE WHEN extract(month from orderdate) BETWEEN 1 AND 3 THEN 1
                  WHEN  extract(month from orderdate) BETWEEN 4 AND 6 THEN 2
                  WHEN  extract(month from orderdate) BETWEEN 7 AND 9 THEN 3
                  ELSE 4
             END;
UPDATE back_up
SET month_id = extract(month from orderdate);
UPDATE back_up
SET year_id = extract(year from orderdate);

--tìm outlier cho cột QUANTITYORDERED bằng boxplot
with cte as(select q1-1.5*iqr as min,
q3+1.5*iqr as max 
from
(SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY quantityordered) AS q1,
percentile_cont(0.75) WITHIN GROUP (ORDER BY quantityordered) AS q3,
percentile_cont(0.75) WITHIN GROUP (ORDER BY quantityordered) - percentile_cont(0.25) WITHIN GROUP (ORDER BY quantityordered) as iqr
from back_up))
select * from back_up
where quantityordered < (select min from cte)  
or quantityordered > (select max from cte);

--tìm outlier cho cột QUANTITYORDERED bằng z-score
with cte as (select ordernumber, quantityordered,
			 (select avg(quantityordered) from back_up) as avg,
			 (select stddev(quantityordered) from back_up) as stddev
			 from back_up)
select ordernumber, quantityordered, (quantityordered-avg)/stddev as z
from cte 
where abs((quantityordered-avg)/stddev) > 3;

--xử lý outlier bằng thay bằng giá trị trung bình
with cte as (select ordernumber, quantityordered,
			 (select avg(quantityordered) from back_up) as avg,
			 (select stddev(quantityordered) from back_up) as stddev
			 from back_up)
, outlier as (select ordernumber, quantityordered, (quantityordered-avg)/stddev as z
from cte 
where abs((quantityordered-avg)/stddev) > 3)
update  back_up
set quantityordered= (select avg(quantityordered) from back_up)
where quantityordered in (select quantityordered from outlier);

--Tạo bảng mới sau khi đã clean
create table SALES_DATASET_RFM_PRJ_CLEAN as (
select * from back_up);


