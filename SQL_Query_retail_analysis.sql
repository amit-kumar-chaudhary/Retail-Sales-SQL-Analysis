-- Create Database
CREATE DATABASE retail_db;

-- Switch database
USE retail_db;

-- Create table
CREATE TABLE sales (
	transactions_id INT PRIMARY KEY
	,sale_date DATE
	,sale_time TIME
	,customer_id INT
	,gender VARCHAR(20)
	,age INT
	,category VARCHAR(20)
	,quantiy INT
	,price_per_unit INT
	,cogs FLOAT
	,total_sale INT
	);

SELECT *
FROM sales;

DROP TABLE sales;

-- check null
SELECT *
FROM sales
WHERE transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR customer_id IS NULL
	OR gender IS NULL
	OR age IS NULL
	OR category IS NULL
	OR quantiy IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;

-- Delete null records
SET SQL_SAFE_UPDATES = 0;

DELETE
FROM sales
WHERE transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR customer_id IS NULL
	OR gender IS NULL
	OR age IS NULL
	OR category IS NULL
	OR quantiy IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;

-- Data exploration
SELECT count(*)
FROM sales;

-- how many customers we have
SELECT count(DISTINCT customer_id) AS total_customers
FROM sales;-- 155

-- how many category we have
SELECT count(DISTINCT category) AS total_category
FROM sales;-- 3

-- Business key problem
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT *
FROM sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
SELECT *
FROM sales
WHERE category = 'clothing'
	AND month(sale_date) = 11
	AND year(sale_date) = 2022
	AND quantiy >= 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category
	,sum(total_sale) AS total_sale
FROM sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT avg(age)
FROM sales
WHERE category = 'beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category
	,gender
	,count(transactions_id) AS total_transaction
FROM sales
GROUP BY category
	,gender
ORDER BY 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
WITH avg_monthly_sale
AS (
	SELECT year(sale_date) AS year
		,month(sale_date) AS month
		,avg(total_sale) AS avg_sale
	FROM sales
	GROUP BY year
		,month
	)
SELECT m1.*
FROM avg_monthly_sale m1
INNER JOIN (
	SELECT year
		,max(avg_sale) AS max_avg_sale
	FROM avg_monthly_sale
	GROUP BY year
	) m2 ON m1.year = m2.year
	AND m1.avg_sale = m2.max_avg_sale;

------------------- or ------------------------------------------
WITH cte
AS (
	SELECT year(sale_date) AS year
		,month(sale_date) AS month
		,avg(total_sale) AS avg_sale
		,rank() OVER (
			PARTITION BY year(sale_date) ORDER BY avg(total_sale) DESC
			) AS sale_rank
	FROM sales
	GROUP BY year
		,month
	)
SELECT year
	,month
	,avg_sale
FROM cte
WHERE sale_rank = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT customer_id
	,sum(total_sale) AS sales
FROM sales
GROUP BY customer_id
ORDER BY sales DESC limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT *
FROM retail_db.sales;

SELECT category
	,count(DISTINCT (customer_id)) AS total_unique_customer
FROM sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
SELECT count(transactions_id) AS num_of_orders
	,CASE 
		WHEN sale_time <= '12:00:00'
			THEN 'Morning'
		WHEN sale_time > '12:00:00'
			AND sale_time <= '17:00:00'
			THEN 'Agternoon'
		WHEN sale_time > '17:00:00'
			THEN 'Evening'
		ELSE 'ok'
		END AS test
FROM sales
GROUP BY test;
