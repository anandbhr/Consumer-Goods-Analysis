# Consumer_Goods_Analysis_Using_SQL

## Project Overview

**Domain**: Consumer Goods | **Function**: Executive Management

Atliq Hardwares, one of the leading computer hardware producers in India with a significant global presence, has identified a need for enhanced data insights to support quick and smart data-informed decisions. To address this, they are expanding their data analytics team. Tony Sharma, the data analytics director, has initiated a SQL challenge to assess potential candidates' technical and soft skills.

This project involves performing ad-hoc analysis using SQL to address specific business requests and presenting the insights to top-level management.

## Task Description

As a data analyst, you are tasked with addressing 10 ad-hoc requests listed in the `ad-hoc-requests.pdf` document. These requests require insights that can be obtained through advanced MySQL queries. The final deliverable includes both the SQL queries used and a presentation designed to communicate the insights effectively to executive management.

## Project Components

### 1. Ad-Hoc Requests
The `ad-hoc-requests.pdf` document contains 10 specific business questions that need to be answered. These questions cover various aspects of the business operations and performance.

### 2. SQL Queries
For each of the 10 ad-hoc requests, advanced MySQL queries were written to extract the necessary data and generate insights. These queries demonstrate proficiency in SQL, including the use of joins, subqueries, aggregate functions, and other advanced SQL features.
```sql
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
```
For the complete set of queries refer to [Sql queries.sql](https://github.com/anandbhr/Consumer_Goods_Analysis/blob/main/Sql%20queries.sql)

### 3. Presentation
A presentation was created to communicate the insights derived from the SQL queries to aid in decision-making.

## Technologies Used

- **SQL**: Advanced MySQL for querying data.
- **Presentation Tools**:  PowerPoint for creating the presentation.

## Conclusion

This project demonstrates the ability to perform detailed data analysis using SQL and effectively communicate findings to executive management. It highlights proficiency in both technical skills (SQL querying) and soft skills (data presentation).

