--Doanh thu theo từng ProductLine, Year  và DealSize?
select productline, year_id, dealsize, sum(sales) as revenue
from public.sales_dataset_rfm_prj_clean
group by productline, year_id, dealsize;

--Đâu là tháng có bán tốt nhất mỗi năm?
select  year_id, month_id, sum(sales),
dense_rank() over(partition by year_id order by sum(sales) desc) as r
from public.sales_dataset_rfm_prj_clean
group by year_id, month_id
order by year_id;

--Product line nào được bán nhiều ở tháng 11?
select  month_id, productline, sum(sales),
dense_rank() over(partition by month_id order by sum(sales) desc) as r
from public.sales_dataset_rfm_prj_clean
group by month_id, productline
having month_id=11;

--Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm?
select * from (select  year_id, productline, country, sum(sales),
dense_rank() over(partition by year_id,country order by sum(sales) desc) as r
from public.sales_dataset_rfm_prj_clean
group by year_id, productline, country
having country='UK')
where r=1;
