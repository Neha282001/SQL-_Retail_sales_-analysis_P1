CREATE TABLE 'SQLRetailSalesAnalysis_utf' ('transactions_id' INTEGER,'sale_date' TEXT,'sale_time' TEXT,'customer_id' INTEGER,'gender' TEXT,'age' INTEGER,'category' TEXT,'quantiy' INTEGER,'price_per_unit' INTEGER,'cogs' REAL,'total_sale' INTEGER)
---
SELECT COUNT (*)
FROM RetailSalesAnalysis
----
SELECT * FROM RetailSalesAnalysis
WHERE transactions_id is NULL
OR
sale_date is NULL
or
sale_time is NULL
or
customer_id is NULL
or
gender is NULL
or
age is NULL
OR
category is NULL
OR
quantiy is NULL
or
price_per_unit is NULL
OR
cogs is NULL
OR
total_sale is null;
---
DELETE FROM RetailSalesAnalysis
WHERE transactions_id is NULL
OR
sale_date is NULL
or
sale_time is NULL
or
customer_id is NULL
or
gender is NULL
or
age is NULL
OR
category is NULL
OR
quantiy is NULL
or
price_per_unit is NULL
OR
cogs is NULL
OR
total_sale is null;
---------------------------------------
# data exploration
# how many sales do we have
SELECT COUNT(*) as total_sale FROM RetailSalesAnalysis;
---------------------------------------------
# how many customers do we have?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM RetailSalesAnalysis;
----------------
SELECT DISTINCT category FROM RetailSalesAnalysis
--------------------\\\\
---data analysis key problems and answers-----------------------
--q1 Write a SQL query to retrieve all columns for sales made on '2022-11-05--
SELECT *
FROM RetailSalesAnalysis
WHERE sale_date = '2022-11-05';
--q2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT *
FROM RetailSalesAnalysis
WHERE 
    category = 'Clothing'
    AND strftime('%Y-%m', sale_date) = '2022-11'
    AND quantiy >= 4;

----Q3 Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT 
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM RetailSalesAnalysis
GROUP BY category;
----q4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT
round(avg(age), 2) AS avg_age
FROM RetailSalesAnalysis
WHERE category = 'Beauty'
----q5 Write a SQL query to find all transactions where the total_sale is greater than 1000.:RetailSalesAnalysis
 SELECT * FROM RetailSalesAnalysis
 WHERE total_sale > 1000
 ---q6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:RetailSalesAnalysis
 SELECT 
 category,
 gender,
 count(*) as total_trans
 FROM RetailSalesAnalysis
 GROUP
 BY
 category,
 gender
 ORDER BY 1
 ----q7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT 
    year,
    month,
    avg_sale
FROM 
(    
    SELECT 
        strftime('%Y', sale_date) AS year,
        strftime('%m', sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER(PARTITION BY strftime('%Y', sale_date) ORDER BY AVG(total_sale) DESC) AS rank
    FROM RetailSalesAnalysis
    GROUP BY year, month
) AS t1
WHERE rank = 1;
----q8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
FROM RetailSalesAnalysis
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
----q9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
    category,
    COUNT( DISTINCT customer_id) as Cnt_unique_cs
FROM RetailSalesAnalysis
GROUP by category
---q10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH hourly_sale AS (
    SELECT *,
        CASE 
            WHEN CAST(strftime('%H', sale_time) AS INTEGER) < 12 THEN 'Morning'
            WHEN CAST(strftime('%H', sale_time) AS INTEGER) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM RetailSalesAnalysis
)
SELECT 
    shift,
    COUNT(*) AS total_orders    
FROM hourly_sale
GROUP BY shift;
--- end---



 