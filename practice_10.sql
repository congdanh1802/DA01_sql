--II. Ad-hoc tasks

--1/Số lượng đơn hàng và số lượng khách hàng mỗi tháng
select format_date('%Y-%m',created_at) created_date, count(order_id) total_order, count(user_id) total_user
from bigquery-public-data.thelook_ecommerce.orders
where created_at between '2019-1-1' and '2022-5-1'
group by 1 
order by 1;

--Nhận xét: Qua các tháng thì tổng lượng order và tổng số users đều tăng liên tục




--2/Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
select format_date('%Y-%m',created_at) created_date, count(distinct user_id) as distinct_users, 
sum(sale_price)/count(order_id) as AOV
from bigquery-public-data.thelook_ecommerce.order_items
where created_at between '2019-1-1' and '2022-5-1'
group by 1 
order by 1;

--Nhận xét: 
--(1) Lượng users tăng liên tục qua các tháng; 
--(2) Giá trị đơn hàng trung bình qua các tháng giao động liên tục trong khoảng 55-64, chỉ có duy nhất ở tháng 2/2019 thì AOV=47




--3/Nhóm khách hàng theo độ tuổi
with cte1 as (select first_name, last_name, gender,age,
rank() over(partition by gender order by age) as r1
from bigquery-public-data.thelook_ecommerce.users
where created_at between '2019-1-1' and '2022-5-1')
,cte2 as(select first_name, last_name, gender,age,
rank() over(partition by gender order by age desc) as r2
from bigquery-public-data.thelook_ecommerce.users
where created_at between '2019-1-1' and '2022-5-1')
select first_name, last_name, gender,age, case when r1=1 then 'youngest' else null end tag 
from cte1
where r1=1
union all
select first_name, last_name, gender,age, case when r2=1 then 'oldest' else null end tag 
from cte2
where r2=1;

--Nhận xét
--(1) Số tuổi thấp nhất của Nữ là 12 với 536 người, Số tuổi thấp nhất của Nam là 12 với 505 người
with cte1 as (select first_name, last_name, gender,age,
rank() over(partition by gender order by age) as r1
from bigquery-public-data.thelook_ecommerce.users
where created_at between '2019-1-1' and '2022-5-1')
,cte2 as(select first_name, last_name, gender,age,
rank() over(partition by gender order by age desc) as r2
from bigquery-public-data.thelook_ecommerce.users
where created_at between '2019-1-1' and '2022-5-1')
, cte3 as (select first_name, last_name, gender,age, case when r1=1 then 'youngest' else null end tag 
from cte1
where r1=1
union all
select first_name, last_name, gender,age, case when r2=1 then 'oldest' else null end tag 
from cte2
where r2=1)
select age, gender, count(*)
from cte3 
where tag='youngest'
group by age, gender;
--(2) Số tuổi thấp nhất của Nữ là 70 với 515 người, Số tuổi thấp nhất của Nam là 70 với 511 người
with cte1 as (select first_name, last_name, gender,age,
rank() over(partition by gender order by age) as r1
from bigquery-public-data.thelook_ecommerce.users
where created_at between '2019-1-1' and '2022-5-1')
,cte2 as(select first_name, last_name, gender,age,
rank() over(partition by gender order by age desc) as r2
from bigquery-public-data.thelook_ecommerce.users
where created_at between '2019-1-1' and '2022-5-1')
, cte3 as (select first_name, last_name, gender,age, case when r1=1 then 'youngest' else null end tag 
from cte1
where r1=1
union all
select first_name, last_name, gender,age, case when r2=1 then 'oldest' else null end tag 
from cte2
where r2=1)
select age, gender, count(*)
from cte3 
where tag='oldest'
group by age, gender;




--4/Top 5 sản phẩm mỗi tháng
with cte as (select format_date('%Y-%m',a1.created_at) created_date, a1.product_id product_id, a2.name product_name, a2.cost, a1.sale_price,a1.sale_price-a2.cost profit,
dense_rank() over(partition by format_date('%Y-%m',a1.created_at) order by a1.sale_price-a2.cost) as r
from bigquery-public-data.thelook_ecommerce.order_items as a1
left join bigquery-public-data.thelook_ecommerce.products as a2
on a1.product_id=a2.id
where created_at between '2019-1-1' and '2022-5-1'
order by format_date('%Y-%m',a1.created_at))
select * from cte 
where r<=5;




--5/Doanh thu tính đến thời điểm hiện tại trên mỗi danh mục
select format_date('%Y-%m-%d',a1.created_at) created_date, a2.category,
sum(a1.sale_price-a2.cost)
from bigquery-public-data.thelook_ecommerce.order_items as a1
left join bigquery-public-data.thelook_ecommerce.products as a2
on a1.product_id=a2.id
where DATE_DIFF('2022-04-15', PARSE_DATE('%Y-%m-%d', FORMAT_DATE('%Y-%m-%d', a1.created_at)), DAY) = 90
group by 1,2
order by 1;




--III. Tạo metric trước khi dựng dashboard

--1/Dataset như mô tả

create view bigquery-public-data.thelook_ecommerce.vw_ecommerce_analyst as
with cte1 as 
(select  ordered_date, 100.0*(revenue - lag(revenue) over(order by ordered_date))/lag(revenue) over(order by ordered_date) revenue_growth
FROM (select format_date('%Y-%m', created_at) AS ordered_date, sum(sale_price) revenue
 from bigquery-public-data.thelook_ecommerce.order_items
group by ordered_date)),
cte2 as
(select  ordered_date, 100.0*(cnt_order - lag(cnt_order) over(order by ordered_date))/lag(cnt_order) over(order by ordered_date) order_growth
FROM (select format_date('%Y-%m', created_at) AS ordered_date, count(order_id) cnt_order
 from bigquery-public-data.thelook_ecommerce.orders
group by ordered_date)),
cte3 as
(select format_date('%Y-%m', o1.created_at) AS ordered_date, sum(p.cost) total_cost
from bigquery-public-data.thelook_ecommerce.orders as o1
left join bigquery-public-data.thelook_ecommerce.order_items as o2 on o1.order_id=o2.order_id
left join bigquery-public-data.thelook_ecommerce.products as p on o2.product_id=p.id
group by ordered_date)

select format_date('%Y-%m',o1.created_at) ordered_date, p.category product_category,
sum(o2.sale_price) over(partition by format_date('%Y-%m',o1.created_at)) TPV, 
count(o2.order_id) over(partition by format_date('%Y-%m',o1.created_at)) TPO,
cte1.revenue_growth, cte2.order_growth, cte3.total_cost,
sum(o2.sale_price) over(partition by format_date('%Y-%m',o1.created_at))-cte3.total_cost total_profit,
100.0*(sum(o2.sale_price) over(partition by format_date('%Y-%m',o1.created_at))-cte3.total_cost)/cte3.total_cost profit_to_cost_ratio
from bigquery-public-data.thelook_ecommerce.orders as o1
left join bigquery-public-data.thelook_ecommerce.order_items as o2 on o1.order_id=o2.order_id
left join bigquery-public-data.thelook_ecommerce.products as p on o2.product_id=p.id
left join cte1 on cte1.ordered_date=format_date('%Y-%m',o1.created_at)
left join cte2 on cte2.ordered_date=format_date('%Y-%m',o1.created_at)
left join cte3 on cte3.ordered_date=format_date('%Y-%m',o1.created_at)
order by 1; 







