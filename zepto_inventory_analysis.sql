drop table if exist zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC (8,2),
discountpercent NUMERIC (5,2),
availableQuantity INTEGER,
discountedSellingprice NUMERIC (8,2),
weightinGms INTEGER,
outofstock BOOLEAN,
quantity INTEGER
)

--data exploration 

--count of rows 
select count(*) from zepto;

--sample data
select *  from zepto
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
 availableQuantity is null
OR
 discountedSellingprice is null
OR
 weightinGms is null
OR
 outofstock is null
OR
 quantity is null;

--different product categories
select distinct category
from zepto 
order by category;

--products in stock vs out of stock
select outofstock ,count(sku_id)
from zepto
Group by outofstock;

--product names present multiple times
select name ,count(sku_id) as "Number of SKU's"
from zepto 
group by name
Having count(sku_id)>1
order by count(sku_id) desc;

--data cleaning

--products with price is equals to 0
select * from zepto
where mrp=0 OR discountedsellingprice=0;

delete from zepto
where mrp=0;

--convert paise to rupees
update zepto
SET mrp=mrp/100.0,
discountedsellingprice=discountedsellingprice/100.0;

SELECT mrp,discountedsellingprice from zepto;

-- data analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.
Select distinct name, mrp,discountpercent
from zepto
order by discountpercent desc
limit 10;

--Q2.What are the Products with High MRP but Out of Stock
select distinct name,mrp
from zepto
where outofstock= True and mrp>300
order by mrp desc;

--Q3.Calculate Estimated Revenue for each category
select category,
sum(discountedsellingprice * availableQuantity) as Total_revenue
from zepto
group by category
order by Total_revenue;

--Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
select distinct name, mrp , discountpercent
from zepto
where mrp>500 and discountpercent<10
order by mrp desc , discountpercent desc;

--Q5.Identify the top 5 categories offering the highest average discount percentage.
select category,
round(Avg(discountpercent),2) as avg_discount
from zepto
group by category
order by avg_discount desc
limit 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

--Q7.Group the products into categories like Low, Medium, Bulk.
select distinct name, weightinGms,
 case When weightinGms < 1000 Then 'Low'
       when weightinGms < 5000 Then 'Medium'
	   else 'Bulk'
	   End AS weight_category
	   from zepto;
	   
--Q8.What is the Total Inventory Weight Per Category 
select category,
sum( weightinGms * availableQuantity) as Total_inventory_weight
from zepto
group by category
order by Total_inventory_weight;


