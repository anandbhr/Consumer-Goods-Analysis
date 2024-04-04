#1.Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC region.
select market from dim_customer
where region='APAC' and customer='Atliq Exclusive'
group by market
order by market;

#2.What is the percentage of unique product increase in 2021 vs. 2020?
select X.A as unique_products_2020,  Y.B as unique_products_2021, round((B-A)/A*100,2) as percentage_chg from (
(select count(distinct(product_code)) as A from fact_sales_monthly where fiscal_year=2020)X,
(select count(distinct(product_code)) as B from fact_sales_monthly where fiscal_year=2021)Y
);

#3.Provide a report with all the unique product counts for each segment and sort them in descending order of product counts.
select segment, count(distinct(product_code)) as product_count
from dim_product
group by segment
order by product_count desc;

#4.Follow-up: Which segment had the most increase in unique products in 2021 vs 2020?
with cte1 as (
select dp.segment as A, count(distinct(fsm.product_code)) as B 
from dim_product dp, fact_sales_monthly fsm
where dp.product_code = fsm.product_code
group by fsm.fiscal_year,dp.segment
having fsm.fiscal_year='2020'),
cte2 as (
select dp.segment as C, count(distinct(fsm.product_code)) as D 
from dim_product dp, fact_sales_monthly fsm
where dp.product_code = fsm.product_code
group by fsm.fiscal_year,dp.segment
having fsm.fiscal_year='2021')

select cte1.A as segment, cte1.B as product_count_2020, cte2.D as product_count_2021, (cte2.D-cte1.B) as difference
from cte1,cte2
where 
cte1.A=cte2.C;


#5.Get the products that have the highest and lowest manufacturing costs.
select dp.product_code,product,fmc.manufacturing_cost from dim_product dp
join fact_manufacturing_cost fmc on dp.product_code = fmc.product_code
where
	fmc.manufacturing_cost = (select max(manufacturing_cost) from fact_manufacturing_cost)
    or
    fmc.manufacturing_cost = (select min(manufacturing_cost) from fact_manufacturing_cost);


#6.Generate a report which contains the top 5 customers who received an average high pre_invoice_discount_pct for the fiscal year 2021 and in the Indian market.
with cte1 as (
	select customer_code as A, avg(pre_invoice_discount_pct) as B 
	from fact_pre_invoice_deductions
	where fiscal_year='2021'
	group by customer_code),
cte2 as (
	select customer_code as C,customer as D 
	from dim_customer 
	where market='India')
select cte1.A as customer_code, cte2.D as customer, round(cte1.B,4) as average_discount_percentage 
from cte1 join cte2 on cte1.A = cte2.C
order by average_discount_percentage desc
limit 5;


#7.Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month .
select concat(monthname(fsm.date), ' (',year(fsm.date),')') as month,fsm.fiscal_year,concat(round(sum((fsm.sold_quantity*gross_price))/1000000,2),"M") as gross_sales_amount 
from fact_sales_monthly fsm
join dim_customer on fsm.customer_code=dim_customer.customer_code
join fact_gross_price on fsm.product_code=fact_gross_price.product_code
where dim_customer.customer='Atliq Exclusive'
group by month,fsm.fiscal_year
order by fsm.fiscal_year;

#8.In which quarter of 2020, got the maximum total_sold_quantity?
SELECT
CASE
    WHEN date BETWEEN '2019-09-01' AND '2019-11-30' then 1  
    WHEN date BETWEEN '2019-12-01' AND '2020-02-29' then 2
    WHEN date BETWEEN '2020-03-01' AND '2020-05-31' then 3
    WHEN date BETWEEN '2020-06-01' AND '2020-08-31' then 4
    END AS Quarter,
SUM(sold_quantity) AS total_sold_quantity
FROM fact_sales_monthly
WHERE fiscal_year = 2020
GROUP BY Quarter
ORDER BY total_sold_quantity DESC;

#9.Which channel helped to bring more gross sales in the fiscal year 2021 and the percentage of contribution?

with cte as (
select channel, concat(round(sum(gross_price*sold_quantity)/1000000,2),' M')as gross_sales_mln from dim_customer
join fact_sales_monthly on dim_customer.customer_code = fact_sales_monthly.customer_code
join fact_gross_price on fact_sales_monthly.product_code = fact_gross_price.product_code
where fact_sales_monthly.fiscal_year=2021
group by channel)
select channel, gross_sales_mln, concat(round((gross_sales_mln/total*100),2),' %')as percentage from
(select sum(gross_sales_mln) as total from cte)a,
(select * from cte)b
order by percentage desc;

#10.Get the Top 3 products in each division that have a high total_sold_quantity in the fiscal_year 2021?
with cte1 as(
select dim_product.division, dim_product.product_code, product, sum(sold_quantity) as total_sold_quantity from dim_product
join fact_sales_monthly on dim_product.product_code = fact_sales_monthly.product_code
where fiscal_year=2021
group by dim_product.product_code,division,product),
cte2 as (
select division,product_code,total_sold_quantity, rank()over(partition by division order by total_sold_quantity desc ) as rank_order from cte1)

select cte1.division,cte1.product_code,cte1.product,cte1.total_sold_quantity,cte2.rank_order from cte1 join cte2 on cte1.product_code=cte2.product_code
where cte2.rank_order in (1,2,3) ; 