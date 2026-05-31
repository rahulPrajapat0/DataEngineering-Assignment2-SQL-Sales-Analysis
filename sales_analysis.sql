CREATE DATABASE superstore_db;
USE superstore_db;
-- 2.Explore table (schema, sample data)
DESCRIBE superstore_data;
-- sample data
SELECT *
FROM superstore_data
LIMIT 10;

-- 3. Apply WHERE filters (region, category, date, sales)
-- Region Filter
SELECT *
FROM superstore_data
WHERE Region = 'West';
-- Category Filter
SELECT *
FROM superstore_data
WHERE Category = 'Technology';
-- Sales Filter
SELECT *
FROM superstore_data
WHERE Sales > 1000;

-- 4.Use GROUP BY for aggregations (sales, quantity, averages).
-- Total Sales by Region
SELECT Region,
SUM(Sales) AS Total_Sales
FROM superstore_data
GROUP BY Region;
-- Total Quantity by Category
SELECT Category,
SUM(Quantity) AS Total_Quantity
FROM superstore_data
GROUP BY Category;
-- Average Sales by Category
SELECT Category,
AVG(Sales) AS Avg_Sales
FROM superstore_data
GROUP BY Category;

-- 5.Sort and limit results (top products, top categories)
-- Products by Sales
SELECT `Product Name`,
SUM(Sales) AS Total_Sales
FROM superstore_data
GROUP BY `Product Name`
ORDER BY Total_Sales DESC
LIMIT 5;
-- Top 3 Categories
SELECT Category,
SUM(Sales) AS Total_Sales
FROM superstore_data
GROUP BY Category
ORDER BY Total_Sales DESC
LIMIT 3;

-- 6.Solve use cases (monthly trends, top customers, duplicates)
-- monthly trends
SELECT MONTH(STR_TO_DATE(`Order Date`,'%m/%d/%Y')) AS Month_No,
SUM(Sales) AS Total_Sales
FROM superstore_data
GROUP BY Month_No
ORDER BY Month_No;
-- top customers
SELECT `Customer Name`,
SUM(Sales) AS Total_Sales
FROM superstore_data
GROUP BY `Customer Name`
ORDER BY Total_Sales DESC
LIMIT 10;
-- Duplicate Orders
SELECT `Order ID`,
COUNT(*) AS Duplicate_Count
FROM superstore_data
GROUP BY `Order ID`
HAVING COUNT(*) > 1;

-- 7.Validate results (row counts, data quality)
-- row counts
SELECT COUNT(*)
FROM superstore_data;
--  data quality
SELECT *
FROM superstore_data
WHERE Region IS NULL
   OR Category IS NULL
   OR Sales IS NULL;

SELECT MIN(sales), MAX(sales), AVG(sales) FROM superstore_data;
