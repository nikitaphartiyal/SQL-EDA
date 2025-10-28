  -- checking the data --
  
  
SELECT 
    *
FROM
    sales;
    
    
    
-- checking the rows  of the data--


SELECT 
    COUNT(*) AS total_rows
FROM
    sales;
    
    
    
 -- checking the columns of the data--
 
 
SELECT 
    COUNT(*) AS total_columns
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE
    TABLE_NAME = 'sales';
    
    
    -- CHECKINHG THE FIRST 10 DATA 
    
    
    SELECT 
    *
FROM
    sales
LIMIT 10;


-- MISSSING VALUES IN THE COLUMNS 


SELECT
    SUM(CASE WHEN `Transaction ID` IS NULL THEN 1 ELSE 0 END) AS Transaction_id_nulls,
    SUM(CASE WHEN `Date` IS NULL THEN 1 ELSE 0 END) AS order_date_nulls,
    SUM(CASE WHEN `Product Name` IS NULL THEN 1 ELSE 0 END) AS ProductName_nulls,
    SUM(CASE WHEN `Product Category` IS NULL THEN 1 ELSE 0 END) AS ProductCategory_nulls,
    SUM(CASE WHEN `Units Sold` IS NULL THEN 1 ELSE 0 END) AS UnitsSold_nulls,
    SUM(CASE WHEN `Unit Price` IS NULL THEN 1 ELSE 0 END) AS UnitPrice_nulls
FROM sales;


-- UNIQUE VALUES 


SELECT COUNT(DISTINCT `Transaction ID` ) as unique_transaction FROM sales;
SELECT COUNT(DISTINCT `Date`)  as unique_dates  FROM sales;
SELECT COUNT(DISTINCT `Product Name`) as unique_productname FROM sales;
SELECT COUNT(DISTINCT `Product Category`) as unique_productcategory  FROM sales;
SELECT COUNT(DISTINCT `Units Sold` ) as unique_unitsSold FROM sales;
SELECT COUNT(DISTINCT `Unit price` )  as unique_unitprice FROM sales;


-- DUPLICATES VALUE 


SELECT
    `Transaction ID`, COUNT(*) AS duplicate_count
FROM sales
GROUP BY `Transaction ID`
HAVING COUNT(*) > 1;


-- Summary of numeric columns


SELECT
    ROUND(AVG(`Units Sold`), 2) AS avg_units_sold,
    ROUND(MIN(`Units Sold`), 2) AS min_units_sold,
    ROUND(MAX(`Units Sold`), 2) AS max_units_sold,
    ROUND(AVG(`Unit Price`), 2) AS avg_unit_price,
    ROUND(MIN(`Unit Price`), 2) AS min_unit_price,
    ROUND(MAX(`Unit Price`), 2) AS max_unit_price,
    ROUND(AVG(`Total Revenue`), 2) AS avg_total_revenue,
    ROUND(MIN(`Total Revenue`), 2) AS min_total_revenue,
    ROUND(MAX(`Total Revenue`), 2) AS max_total_revenue
FROM sales;


 -- REVENUE ANALYSIS BY CATEGORY
 
 
SELECT 
    `Product Category`,
    COUNT(*) AS total_transactions,
    SUM(`Total Revenue`) AS total_revenue,
    ROUND(AVG(`Total Revenue`), 2) AS avg_revenue_per_transaction
FROM sales
GROUP BY `Product Category`
ORDER BY total_revenue DESC;


-- REGION WISE SALES 


SELECT 
      `Region`,
    COUNT(*) AS total_transactions,
    SUM(`Total Revenue`) AS total_revenue,
    ROUND(AVG(`Total Revenue`), 2) AS avg_revenue_per_transaction
FROM sales
GROUP BY `Region`
ORDER BY total_revenue DESC;


-- Payment Method Distribution


SELECT 
    `Payment Method`,
    COUNT(*) AS transaction_count,
    ROUND(SUM(`Total Revenue`), 2) AS total_revenue
FROM sales
GROUP BY `Payment Method`
ORDER BY transaction_count DESC;


-- Daily and Monthly Trends


-- Daily trend


SELECT 
    `Date`,
    SUM(`Total Revenue`) AS daily_revenue
FROM sales
GROUP BY `Date`
ORDER BY `Date`;



-- Monthly trend


SELECT 
    m.month_num,
    m.month_name,
    COALESCE(SUM(s.`Total Revenue`), 0) AS total_revenue
FROM (
    SELECT 1 AS month_num, 'January' AS month_name UNION ALL
    SELECT 2, 'February' UNION ALL
    SELECT 3, 'March' UNION ALL
    SELECT 4, 'April' UNION ALL
    SELECT 5, 'May' UNION ALL
    SELECT 6, 'June' UNION ALL
    SELECT 7, 'July' UNION ALL
    SELECT 8, 'August' UNION ALL
    SELECT 9, 'September' UNION ALL
    SELECT 10, 'October' UNION ALL
    SELECT 11, 'November' UNION ALL
    SELECT 12, 'December'
) AS m
LEFT JOIN sales AS s
    ON EXTRACT(MONTH FROM s.`Date`) = m.month_num
GROUP BY m.month_num, m.month_name
ORDER BY m.month_num;


-- Top 5 Products by Revenue


SELECT 
    `Product Name`,
    `Product Category`,
    SUM(`Total Revenue`) AS total_revenue
FROM sales
GROUP BY `Product Name`, `Product Category`
ORDER BY total_revenue DESC
LIMIT 5;


-- Outlier Detection (High Value Sales)


SELECT  * 
FROM sales
WHERE `Total Revenue` > (
    SELECT AVG(`Total Revenue`) + 2 * STDDEV("Total Revenue") FROM sales
);



-- Extract the month and year


SELECT 
    EXTRACT(YEAR FROM `Date`) AS year,
    EXTRACT(MONTH FROM `Date`) AS month,
    SUM(`Total Revenue`) AS total_revenue,
    COUNT(DISTINCT `Transaction ID`) AS total_orders
FROM sales
GROUP BY year, month
ORDER BY year, month;


