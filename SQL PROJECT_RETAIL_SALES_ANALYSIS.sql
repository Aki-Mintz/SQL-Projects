--SQL Retail Sales Analysis--
CREATE DATABASE sql_project11;

--Create tables--
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales(
    transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

SELECT * FROM Retail_Sales_Analysis
LIMIT5;
-- count the rows
SELECT COUNT(*)
FROM Retail_Sales_Analysis


-- Check if there is null value
SELECT * FROM Retail_Sales_Analysis
WHERE transactions_id IS NULL

SELECT * FROM Retail_Sales_Analysis
WHERE sale_date IS NULL

SELECT * FROM Retail_Sales_Analysis
WHERE sale_time IS NULL

-- for large datasets
SELECT * FROM Retail_Sales_Analysis
WHERE transactions_id IS NULL
         OR sale_date IS NULL
		 OR sale_time IS NULL
		 OR gender IS NULL
		 OR category IS NULL
		 OR quantiy IS NULL
		 OR cogs IS NULL
		 OR total_sale IS NULL

-- delete data/row for null values
DELETE FROM Retail_Sales_Analysis
WHERE transactions_id IS NULL
         OR sale_date IS NULL
		 OR sale_time IS NULL
		 OR gender IS NULL
		 OR category IS NULL
		 OR quantiy IS NULL
		 OR cogs IS NULL
		 OR total_sale IS NULL



--DATA EXPLORATION--

--How many Sales we have?
SELECT COUNT(*) as total_sale
FROM Retail_Sales_Analysis

--How many unique customers we have?
SELECT COUNT( DISTINCT customer_id) as total_sale
FROM Retail_Sales_Analysis

--How many category we have?
SELECT COUNT(DISTINCT category) as total_sale
FROM Retail_Sales_Analysis

SELECT DISTINCT category 
FROM Retail_Sales_Analysis



--DATA ANALYSIS, BUSINESS KEY PROBLEMS AND ANSWERS--

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


--answers:
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
       SELECT *
	   FROM Retail_Sales_Analysis
	   WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal 4 in the month of Nov-2022
       SELECT *
	   FROM Retail_Sales_Analysis
	   WHERE category = 'Clothing'
	   AND YEAR(sale_date) = 2022
	   AND MONTH(sale_date) = 11
	   AND quantiy >= 4

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category
        SELECT category,
		SUM(total_sale) as net_sale,
		COUNT(*) as total_orders
		FROM Retail_Sales_Analysis
		GROUP BY category
		
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
        SELECT ROUND(AVG(age), 2) as avg_age
		FROM Retail_Sales_Analysis
		WHERE category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
        SELECT *
		FROM Retail_Sales_Analysis
		WHERE total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
        SELECT gender,category,
		COUNT(*) as total_transac
		FROM Retail_Sales_Analysis
		GROUP BY gender,category
		ORDER BY 1

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
       SELECT year, month, avg_sale
	   FROM
	   (
	   SELECT year(sale_date) as year, month(sale_date) as month, 
	   AVG(total_sale) as avg_sale,
	   RANK() OVER(PARTITION BY year(sale_date) ORDER BY AVG(total_sale) DESC ) as rank
	   FROM Retail_Sales_Analysis
	   GROUP BY year(sale_date), month(sale_date)
	   ) as t1
	   WHERE RANK = 1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
        SELECT TOP 5 customer_id,
		SUM(total_sale) as total_sales
		FROM Retail_Sales_Analysis
		GROUP BY customer_id
		ORDER BY 2 DESC

--Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
        SELECT  COUNT(DISTINCT customer_id) as unique_customers, category
		FROM Retail_Sales_Analysis
		GROUP BY  category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
    WITH Hourly_sale
	As (
	SELECT *,
		  CASE
		     WHEN DATEPART(HOUR,sale_time) < 12 THEN 'Morning'
			 WHEN DATEPART(HOUR,sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			 ELSE 'Evening'
		  END as shift
		FROM Retail_Sales_Analysis
	)
	SELECT shift,COUNT(*) as total_orders
	FROM Hourly_sale
	GROUP BY shift

	--END--