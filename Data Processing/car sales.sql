select * from CAR_SALES.ANALYSIS.CAR_SALES;
-------------
--removing null

delete from CAR_SALES.ANALYSIS.CAR_SALES
where make is null or model is null;

-----------------------------------------
--checking how many nulls exist 
select sum(case when make is null then 1 else 0 end) as missing_make,
sum(case when model is null then 1 else 0 end) as missing_model,
sum(case when trim is null then 1 else 0 end) as missing_trim,
sum(case when body is null then 1 else 0 end) as missing_body,
sum(case when transmission is null then 1 else 0 end) as missing_transmission
from CAR_SALES.ANALYSIS.CAR_SALES;

---------------------------------------
-- checking car's vin duplicates

select vin,
count(*) as count
from CAR_SALES.ANALYSIS.CAR_SALES
group by vin 
having count(*) > 1;

----------------------------------------
-- removing vin's duplicates 
delete from CAR_SALES.ANALYSIS.CAR_SALES
where vin in(select vin from(select vin, row_number () over (partition by vin order by vin) as rn
from CAR_SALES.ANALYSIS.CAR_SALES) as temp 
where rn >1);
----------------------------------
--checking where there is blanks 
select * 
from CAR_SALES.ANALYSIS.CAR_SALES
where color is null 
or color = ''
or interior is null 
or interior = '';

--delete the rows that are blank 
delete from CAR_SALES.ANALYSIS.CAR_SALES
where color is null or color = ''
or interior is null or interior = ''
or transmission is null or transmission = '';
------------------------------
--converting records that might have invalid or lowercase state codes

update CAR_SALES.ANALYSIS.CAR_SALES
set STATE= upper(STATE);

---Checking invalid states
select distinct state
from CAR_SALES.ANALYSIS.CAR_SALES
where length(state) <>2;
----------------------------------
-- Replace missing selling price with 0

UPDATE CAR_SALES.ANALYSIS.CAR_SALES
SET sellingprice = 0
WHERE sellingprice IS NULL;
-------------------------------------------------------
--creating a new table
create table CAR_SALES.ANALYSIS.CAR_SALES_cleaned__table as 
select * 
from CAR_SALES.ANALYSIS.CAR_SALES;
-------
select *
from CAR_SALES.ANALYSIS.CAR_SALES_CLEANED__TABLE;
-------------------------------------------------------
--checking the manufucturing year of each car and vehicle age

SELECT year, YEAR(CURRENT_DATE) - year AS vehicle_age
FROM CAR_SALES.ANALYSIS.CAR_SALES_CLEANED__TABLE;
-----------------------------------------

select max(sellingprice) as  max_selling_price
from CAR_SALES.ANALYSIS.CAR_SALES_CLEANED__TABLE;

select min(sellingprice) as  min_selling_price
from CAR_SALES.ANALYSIS.CAR_SALES_CLEANED__TABLE;
-----------------------------------------
select * from CAR_SALES.ANALYSIS.CAR_SALES_CLEANED__TABLE;
--------------------------------------------------------
--Average Selling Price by Vehicle Body Type
SELECT 
    BODY,
    COUNT(*) AS units_sold,
    AVG(sellingprice) AS avg_selling_price
FROM CAR_SALES.ANALYSIS.CAR_SALES_CLEANED__TABLE
GROUP BY BODY
ORDER BY avg_selling_price DESC;
--------------------------------------------
--calculating the total car as total_unit_sold
select 
count(*) as  total_units_sold,
from CAR_SALES.ANALYSIS.CAR_SALES_CLEANED__TABLE;
-------------------------------------------------
-- Sales trend by car year

select
make,
count(*) AS total_cars_sold
        
from CAR_SALES.ANALYSIS.CAR_SALES_CLEANED__TABLE
group by make
order by total_cars_sold desc;
----------------------------------------------------------------------------
-- displaying the total revernue per each car
select *,
count(*) AS units_sold,        
sum(sellingprice) as total_revenue,
avg(sellingprice) as avg_price
from CAR_SALES.ANALYSIS.CAR_SALES_CLEANED__TABLE
group by  all
order by total_revenue desc;
----------------------------------------

--checking the best performing car brand 

select
make,
count(*) as total_car_solds,
count(*) AS total_units_sold,
sum(sellingprice) AS total_revenue,
round(avg(sellingprice), 2) AS avg_selling_price,
    
from CAR_SALES.ANALYSIS.CAR_SALES_CLEANED__TABLE
group By make
order by total_revenue desc;
-----------------------------------------
--displaying the max and min condition of the car

select max(condition) as max_condition 
from CAR_SALES.ANALYSIS.CAR_SALES_CLEANED__TABLE;

select min(condition) as min_condition 
from CAR_SALES.ANALYSIS.CAR_SALES_CLEANED__TABLE;


-------------------------------------------------------------
select year,
make,
model,
trim,
body,
transmission,
vin,
state,
condition,
odometer,
color,
interior,
seller,
mmr,
sellingprice,saledate,
count(*) as total_car_solds,
count(*) AS total_units_sold,
sum(sellingprice) AS total_revenue,
round(avg(sellingprice), 2) AS avg_selling_price,
year(current_date) -year AS vehicle_age,
case 
when sellingprice < 10000 then 'Budget'
when sellingprice between 10000 and 200000 then 'Mid-Range'
when sellingprice between 210000 and 250000 then 'Premium'
else 'Luxury' 
end as price_category,
case 
when condition between 31 and  45 then 'Excellent'
when condition between 6 and  30 then 'Good'
when condition between 1 and 5 then 'bad'
else 'Poor'
end as condition_cateory

from CAR_SALES.ANALYSIS.CAR_SALES_CLEANED__TABLE
group by  all
order by  total_revenue desc;
----------------------------------------------------------------







