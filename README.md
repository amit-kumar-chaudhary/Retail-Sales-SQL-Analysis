# Retail Sales SQL Analysis

## Project Description
Retail businesses rely on data analysis to optimize sales, track customer behavior, and identify trends. This project involves analyzing a retail sales dataset using SQL to gain insights into transactions, customer demographics, and product categories. By querying the data, we can help the business make informed decisions regarding sales performance, customer engagement, and product demand.

## Business Problem
A retail company wants to optimize its sales strategies by understanding key performance indicators (KPIs) such as total sales, customer demographics, and product category performance. The company aims to answer critical business questions like:
- What are the total sales figures for different product categories?
- How does customer age impact purchasing decisions?
- Which months have the highest sales?
- How do transaction patterns vary across different times of the day?

## Data Overview
The dataset consists of sales transaction records with the following fields:
- `transactions_id`: Unique identifier for each sale
- `sale_date`: Date of the transaction
- `sale_time`: Time of the transaction
- `customer_id`: Unique identifier for each customer
- `gender`: Customer's gender
- `age`: Customer's age
- `category`: Product category (e.g., Clothing, Beauty, Electronics)
- `quantity`: Number of items sold
- `price_per_unit`: Price per unit of the product
- `cogs`: Cost of goods sold
- `total_sale`: Total revenue generated per transaction

## Business Questions Answered
### 1. Retrieve all sales on '2022-11-05'
```sql
SELECT * FROM sales WHERE sale_date = '2022-11-05';
```

### 2. Transactions in 'Clothing' category with quantity >3 in Nov-2022
```sql
SELECT * FROM sales
WHERE category = 'Clothing' AND MONTH(sale_date) = 11 AND YEAR(sale_date) = 2022 AND quantity >= 4;
```

### 3. Total sales per category
```sql
SELECT category, SUM(total_sale) AS total_sale FROM sales GROUP BY category;
```

### 4. Average age of customers buying 'Beauty' category
```sql
SELECT AVG(age) FROM sales WHERE category = 'Beauty';
```

### 5. Transactions where total_sale > 1000
```sql
SELECT * FROM sales WHERE total_sale > 1000;
```

### 6. Total number of transactions by gender and category
```sql
SELECT category, gender, COUNT(transactions_id) AS total_transaction 
FROM sales GROUP BY category, gender ORDER BY category;
```

### 7. Best selling month per year
Using CTE and RANK function:
```sql
WITH cte AS (
    SELECT YEAR(sale_date) AS year, MONTH(sale_date) AS month, AVG(total_sale) AS avg_sale,
           RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS sale_rank
    FROM sales
    GROUP BY year, month
)
SELECT year, month, avg_sale FROM cte WHERE sale_rank = 1;
```

### 8. Top 5 customers by total sales
```sql
SELECT customer_id, SUM(total_sale) AS sales FROM sales GROUP BY customer_id ORDER BY sales DESC LIMIT 5;
```

### 9. Unique customers per category
```sql
SELECT category, COUNT(DISTINCT customer_id) AS total_unique_customer FROM sales GROUP BY category;
```

### 10. Number of orders per shift (Morning, Afternoon, Evening)
```sql
SELECT COUNT(transactions_id) AS num_of_orders,
    CASE 
        WHEN sale_time <= '12:00:00' THEN 'Morning'
        WHEN sale_time > '12:00:00' AND sale_time <= '17:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift
FROM sales
GROUP BY shift;
```

## Technologies Used
- MySQL
- SQL Queries
- Data Analysis

## Author
amit-kumar-chaudhary

---
This project showcases SQL skills in data cleaning, analysis, and business insights generation. 🚀
