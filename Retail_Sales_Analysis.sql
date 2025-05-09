CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time VARCHAR2(8),
    customer_id INT,
    gender VARCHAR2(10),
    age INT,
    category VARCHAR2(35),
    quantity INT,
    price_per_unit NUMBER,
    cogs NUMBER,
    total_sale NUMBER
);

select * from retail_sales;
--------------------------------------------------------------------------------------------------
/*
Data Exploration & Cleaning
    Record Count: Determine the total number of records in the dataset.
    Customer Count: Find out how many unique customers are in the dataset.
    Category Count: Identify all unique product categories in the dataset.
    Null Value Check: Check for any null values in the dataset and delete records with missing data.
*/
select count(*) from retail_sales;

select count(distinct customer_id) from retail_sales;

select distinct category from retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

--------------------------------------------------------------------------------------------------
select * from retail_sales;

--Data Analysis & Findings
--Q1)Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT * FROM RETAIL_SALES
WHERE SALE_DATE = TO_DATE('05-11-22', 'DD-MM-YY');

--Q2)Write a SQL query to retrieve all transactions where the category is 'Clothing' 
--and the quantity sold is more than 4 in the month of Nov-2022:

SELECT * FROM RETAIL_SALES
WHERE CATEGORY = 'Clothing' 
AND QUANTITY > 4
AND EXTRACT(MONTH FROM SALE_DATE) = 11;

--Q3) Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT CATEGORY, SUM(TOTAL_SALE) AS TOTAL_SALES, COUNT(*) as total_orders
FROM RETAIL_SALES
GROUP BY CATEGORY;

--Q4) Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT ROUND(AVG(AGE), 2) AS AVG_AGE
FROM RETAIL_SALES
WHERE CATEGORY = 'Beauty';

--Q5)Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM RETAIL_SALES
WHERE TOTAL_SALE > 1000;

--Q6) Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT GENDER, CATEGORY, COUNT(*) AS TOTAL_TRANSACTIONS
FROM RETAIL_SALES
GROUP BY GENDER, CATEGORY
ORDER BY GENDER;

--Q7)Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
WITH CTE AS 
(SELECT EXTRACT(MONTH FROM SALE_DATE) AS MONTHS, EXTRACT(YEAR FROM SALE_DATE) AS YEARS, 
     ROUND(AVG(TOTAL_SALE),2) AS AVG_SALE, 
     DENSE_RANK() OVER(PARTITION BY EXTRACT(YEAR FROM SALE_DATE) ORDER BY AVG(TOTAL_SALE)) AS RNK
FROM RETAIL_SALES
GROUP BY EXTRACT(MONTH FROM SALE_DATE), EXTRACT(YEAR FROM SALE_DATE)
ORDER BY YEARS, AVG_SALE)

SELECT * FROM CTE
WHERE RNK = 1;

--Q8) Write a SQL query to find the top 5 customers based on the highest total sales
SELECT CUSTOMER_ID, SUM(TOTAL_SALE) AS TOTAL_SALES
FROM RETAIL_SALES
GROUP BY CUSTOMER_ID
ORDER BY TOTAL_SALES DESC
FETCH FIRST 5 ROWS ONLY;

--Q9) Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT CUSTOMER_ID, COUNT(DISTINCT CATEGORY) AS EACH_CATEGORY
FROM RETAIL_SALES
GROUP BY CUSTOMER_ID
HAVING COUNT(DISTINCT CATEGORY) = 3
ORDER BY CUSTOMER_ID;

--Q10)Write a SQL query to create each shift and number of orders 
--(Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH CTE AS(SELECT SALE_TIME,
    CASE WHEN TO_TIMESTAMP(sale_time, 'HH24:MI:SS') < TO_TIMESTAMP('12:00:00','HH24:MI:SS') THEN 'MORNING'
        WHEN TO_TIMESTAMP(sale_time, 'HH24:MI:SS') > TO_TIMESTAMP('12:00:00','HH24:MI:SS') 
            AND TO_TIMESTAMP(sale_time, 'HH24:MI:SS') < TO_TIMESTAMP('17:00:00','HH24:MI:SS') THEN 'AFTERNOON'
        WHEN TO_TIMESTAMP(sale_time, 'HH24:MI:SS') > TO_TIMESTAMP('17:00:00','HH24:MI:SS') THEN 'EVENING'
        END AS SHIFT_TIME
FROM RETAIL_SALES)
SELECT SHIFT_TIME, COUNT(*) AS TOTAL_ORDERS
FROM CTE
GROUP BY SHIFT_TIME;

-------------------------------------------------------------------------------------------------------
--ANALYSIS:
--BOTH FEMALE AND MALE HAS MOST DONE IN CLOTHING CATEGORY
--MARCH 2023 HAS BETTER SALES AS COMPARE TO MARCH 2022
--HIGHEST SALE MADE BY CUSTOMER IS MORE THAN 38k
--AS PER ANALYSIS HIGHEST ORDERS WERE MADE IN THE EVENING'S
--ACCORDING TO ANALYSIS, MOST CUSTOMER HAS ORDERS IN ALL CATEGORIES







