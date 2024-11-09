select * from sales

-- explore unique elemennts in columns
SELECT DISTINCT branch FROM sales

SELECT DISTINCT city FROM Sales

SELECT DISTINCT customer_type FROM sales

SELECT DISTINCT gender FROM sales

SELECT DISTINCT product_line FROM sales

-- Add a column for month
alter table sales 
add column month varchar(20)
update sales
set month = to_char(date,'month')

-- Add a column for week of the month
alter table sales 
add column time_of_day varchar(20)
update sales 
set time_of_day = case 
                       when extract(hour from time)>=5 and extract(hour from time)<12 then 'Morning'
					   when extract(hour from time)>=12 and extract(hour from time)<17 then 'aternoon'
					   when extract(hour from time)>-17 and extract(hour from time)<21 then 'evening'
					   else 'night' end
					   
-- Add a column for the days

ALTER TABLE sales
ADD COLUMN day VARCHAR(20); 

UPDATE sales
SET day =  TO_CHAR(date, 'Day')

-- ANALYSIS
--1. SALES, REVENUE and PROFIT ANALYSIS

select 
       sum(total) total_revenue,
	   sum(gross_income) total_profit,
	   sum(unit_price*quantity) total_sales
from sales
-- TOTAL REVENUE: 322970, total sales: 307641, total profit: 15382

--2. total revenue,profit and sales by branch
select branch,
       sum(total) total_revenue,
	   sum(gross_income) total_profit,
	   sum(unit_price*quantity) total_sales
from sales
group by branch
order by sum(total) desc
-- Branch C is at top whereas Branch B is at the bottom.


--3. total revenue, profit and sales by productline
select product_line,
       sum(total) total_revenue,
	   sum(gross_income) total_profit,
	   sum(unit_price*quantity) total_sales
from sales
group by product_line
order by sum(total) desc
--Food and Beverages is leading while health and beauty generated least total revenue

--4. total revenue, profit and sales by city
select city,
       sum(total) total_revenue,
	   sum(gross_income) total_profit,
	   sum(unit_price*quantity) total_sales
from sales
group by city
order by sum(total) desc
--Naypyitaw-top, Mandalay-bottom, Yangon and Mandalay doesn't have significant difference in the total revenue

--5. Revenue, profit and sales over time (Time series analysis)
select city,
       sum(total) total_revenue,
	   sum(gross_income) total_profit,
	   sum(unit_price*quantity) total_sales
from sales
group by city
order by sum(total) desc

--6. Revenue, profit and sales over time (Time series analysis)
select month,
       sum(total) total_revenue,
	   sum(gross_income) total_profit,
	   sum(unit_price*quantity) total_sales
from sales
group by month
order by sum(total) desc
-- january is leading, feb generated least

--7. average transaction value
SELECT
  AVG(total) AS average_transaction_value
FROM sales;
-- ATV: 322.97

--8. total revenue, profit,sales by customer_type
SELECT 
       customer_type,
	   SUM(total) AS total_revenue,
	   SUM(gross_income) AS total_profit,
	  SUM(unit_price*quantity) AS total_sales
FROM sales
GROUP BY customer_type
ORDER BY SUM(total) DESC
-- Members contribute significantly more as compared to non-member customers.

--9. Product Contribution Margin:
-- Analyze the profitability of individual products by calculating the contribution margin.
-- Contribution Margin (%) = [(Revenue - Cost of Goods Sold) / Revenue]*100

select 
       product_line,
	   avg((total-cogs)/total)*100 as contribution_margin
from sales 
group by product_line

--10. total revenue, profit, sales by payment
SELECT 
       payment,
	   SUM(total) AS total_revenue,
	   SUM(gross_income) AS total_profit,
	  SUM(unit_price*quantity) AS total_sales
FROM sales
GROUP BY payment
ORDER BY SUM(total) DESC
--customers prefer cash over credit card and e-wallet

--11. CUSTOMER SEGMENTATION
-- a. Demographic segmentation
SELECT
  gender,
  customer_type,
  COUNT(*) AS customer_count
FROM sales
GROUP BY gender, customer_type
ORDER BY customer_count DESC;
--Females have most membership while no. of the normal customers are more men

--12. Geographic segmentation
SELECT
  city, branch,
  COUNT(*) AS customer_count
FROM sales
GROUP BY city, branch
ORDER BY customer_count DESC;
-- Yangon, branch A has most no. of customers

--13. loyalty segmentation
select 
       case when rating between 4 and 6 then 'poor rating'
	        when rating between 6 and 8 then 'Avg rating'
			else 'high rating'
			end as rating_perfomance,
			customer_type,
			count(*) as customer_count
from sales 
where rating is not null
group by customer_type,rating_perfomance
order by customer_count desc
--Regular customers tended to provide average ratings, while those with memberships often gave lower ratings. 
--However, a greater number of members gave high ratings compared to non-members.

--TIME ANALYSIS
--14. monthly analysis
SELECT month, 
       SUM(total) AS total_revenue, 
	   SUM(gross_income) AS total_profit,
	   SUM(unit_price*quantity) AS total_sales,
	   COUNT(*) AS customer_count,
	   SUM(quantity) AS total_items_sold,
	   SUM(cogs) AS total_cost_of_goods_sold
FROM sales
GROUP BY month
ORDER BY total_revenue DESC;
--january at the top while feb at the bottom

--15. daily analysis
SELECT day,
       SUM(total) AS total_revenue, 
	   SUM(gross_income) AS total_profit,
	   SUM(unit_price*quantity) AS total_sales,
	   COUNT(*) AS customer_count,
	   SUM(quantity) AS total_items_sold,
	   SUM(cogs) AS total_cost_of_goods_sold
FROM sales
GROUP BY day
ORDER BY total_revenue DESC;
--saturday - highest , tuesday - second highest, wed and mon at bottom


-- 16. time_of_day analysis
SELECT time_of_day,
       SUM(total) AS total_revenue, 
	   SUM(gross_income) AS total_profit,
	   SUM(unit_price*quantity) AS total_sales,
	   COUNT(*) AS customer_count,
	   SUM(quantity) AS total_items_sold,
	   SUM(cogs) AS total_cost_of_goods_sold
FROM sales
GROUP BY time_of_day
ORDER BY total_revenue DESC;
--afternoon-highest and morning-least
