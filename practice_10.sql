--Số lượng đơn hàng và số lượng khách hàng mỗi tháng
select format_date('%Y-%m',created_at) created_date, count(order_id) total_order, count(user_id) total_user
from bigquery-public-data.thelook_ecommerce.orders
where created_at between '2019-1-1' and '2022-5-1'
group by 1 
order by 1;

--Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
select format_date('%Y-%m',created_at) created_date, count(distinct user_id) as distinct_users, 
sum(sale_price)/count(order_id) as AOV
from bigquery-public-data.thelook_ecommerce.order_items
where created_at between '2019-1-1' and '2022-5-1'
group by 1 
order by 1;

--Nhóm khách hàng theo độ tuổi
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

--Top 5 sản phẩm mỗi tháng
with cte as (select format_date('%Y-%m',a1.created_at) created_date, a1.product_id product_id, a2.name product_name, a2.cost, a1.sale_price,a1.sale_price-a2.cost profit,
dense_rank() over(partition by format_date('%Y-%m',a1.created_at) order by a1.sale_price-a2.cost) as r
from bigquery-public-data.thelook_ecommerce.order_items as a1
left join bigquery-public-data.thelook_ecommerce.products as a2
on a1.product_id=a2.id
where created_at between '2019-1-1' and '2022-5-1'
order by format_date('%Y-%m',a1.created_at))
select * from cte 
where r<=5;

--Doanh thu tính đến thời điểm hiện tại trên mỗi danh mục
select format_date('%Y-%m-%d',a1.created_at) created_date, a2.category,
sum(a1.sale_price-a2.cost)
from bigquery-public-data.thelook_ecommerce.order_items as a1
left join bigquery-public-data.thelook_ecommerce.products as a2
on a1.product_id=a2.id
where DATE_DIFF('2022-04-15', PARSE_DATE('%Y-%m-%d', FORMAT_DATE('%Y-%m-%d', a1.created_at)), DAY) = 90
group by 1,2
order by 1;



