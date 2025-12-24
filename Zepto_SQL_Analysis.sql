drop table if exists Zepto;
Create table Zepto(
sku_id serial primary key,
Category VARCHAR,	
name VARCHAR NOT NULL,
mrp	NUMERIC,	
discountPercent	NUMERIC,	
availableQuantity INT,	
discountedSellingPrice	NUMERIC,	
weightInGms	INT,	
outOfStock	BOOLEAN,	
quantity INT	
);

--Data Exploration

--Count of rows
select COUNT(*) from zepto;

--Data
select * from zepto;
limit 10;

--null values
select * from zepto
where name is null
OR
category is null
OR
mrp is null
OR
discountpercent is null
OR
weightingms is null
OR
availablequantity is null
OR
discountedsellingprice is null
OR
outofstock is null
OR
quantity is null
;
--Different categories
select distinct category
from zepto
order by category;

--checking stocks
select outOfStock ,count(sku_id)
from zepto
group by outOfStock;

--retrieving outofstock products
select name,category from zepto
where outofstock=true;

--product names present multipletimes
select name,count(sku_id) as "Number of SKUs"
from zepto
group by name 
having count(sku_id)>1
ORder by count(sku_id) desc;

--Data cleaning

--products with price zero
select *from zepto
where mrp=0 OR discountedsellingprice=0;

delete from zepto
where mrp=0;

--converting  paise to rupees
update zepto
set mrp=mrp/100.0,discountedsellingprice=discountedsellingprice/100.0 ;

--	Q1 what are the top 10 best products based on the discount percentage
select name,
       max(discountpercent) as max_discount
from zepto
group by name
order by max_discount desc
limit 10;


-- Q2 What are the products with high MRP but out of stock
select distinct name,mrp,outofstock from zepto
where outofstock=true
order by mrp desc
limit 5;

--calculate estimated revenue for each category
select category,round(sum(discountedsellingprice*availablequantity),2) AS Revenue from zepto
where outofstock = false
group by category
order by Revenue desc
;


--products where mrp is greater than 500 and discount is less than 10%
select distinct name,mrp,discountpercent from zepto
where mrp>500 AND discountpercent<10
order by discountpercent asc, mrp desc;

--Which category gives best avg discounts
select category,avg(discountpercent) AS AVG_DISCOUNT from zepto
group by category
order by AVG_DISCOUNT DESC
limit 5;

--Find the price per gram for products abov 100g and sort_by best value
select
    name,
    weightingms,
    discountedsellingprice,
    discountedsellingprice / weightingms as price_per_gram
from zepto
where weightingms > 100
  and outofstock = false
order by price_per_gram asc
limit 5;


--GRoup the products into categories like low , medium,bulk
select distinct name,weightingms, 
CASE when weightingms<=1000 then 'low'
	 when weightingms>1000 AND weightingms<=5000 then 'medium'
	 else 'bulk'
	 END AS weight_category
	 from zepto
group by weightingms,name
order by weightingms DESC;

--what is the total inventory weight per category
select category,SUM(weightingms*availableQuantity) AS INVENTORY_WEIGHT FROM ZEPTO 
GROUP BY category
order by INVENTORY_WEIGHT desc ;



select distinct name,(weightingms) from zepto
order by weightingms desc
limit 5;
select name,


