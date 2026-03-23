-- MYySql RETAIL SALES ANALYSIS 

-- CEREATING A DATABASE
CREATE DATABASE IF NOT EXISTS sql_project ;
USE sql_project;

-- CREATE TABLE CUSTOMERS
CREATE TABLE customers( CustomerID VARCHAR(20),
						Customer_Name VARCHAR(20),
                        Region	VARCHAR(20),
                        City VARCHAR(20));
                        
-- CREATE TABLE PRODUCTS
CREATE TABLE products( ProductID VARCHAR(20),
						Product_Name	VARCHAR(50),
						Category VARCHAR(20), 
                        Sub_Category	VARCHAR(20));

-- CREATE TABLE ORDERS                        
CREATE TABLE orders(Order_ID	VARCHAR(20),
					Order_Date DATE	,
					CustomerID VARCHAR(20),
					ProductID VARCHAR(20),
					Sales_Amount DECIMAL(10,2),
					Quantity TINYINT,
					Discount_Percentage DECIMAL(4,2),
					Profit DECIMAL(8,2)	,
					Delivery_Status	VARCHAR(20),
					Payment_Method VARCHAR(20));
                    
select * from orders ;

--                              Exploratory Data Analysis                                          -- 
------------------------------------------------------------------------------------------------------
-- Query to retrive Sales made on '2024-07-10'
SELECT *
FROM orders
WHERE Order_Date = '2024-07-10';

-- Query to retrive  all transaction where the sub_category is "Mobile" and "Quantity" is more than 15 in the month of april 2025

SELECT *
FROM products AS p
INNER JOIN orders AS o 
WHERE p.Sub_Category = "Mobile" AND o.Quantity > 5 AND o.Order_Date BETWEEN "2025-04-01" AND "2025-04-30" ;
-------------------------------------------------------------------------------------------------------------------
-- Sales Trends :   
-- Monthly Sales Trends 

SELECT MONTHNAME(Order_Date) AS Month_,
		MONTH(Order_Date) AS Month_number,
	   sum(Sales_Amount) as Total_Sales_Amount
FROM orders
GROUP BY Month_,Month_number
ORDER BY Month_number;

-- Top 5 months by total sales (from highest to lowest)

SELECT MONTHNAME(Order_Date) AS Month_,
		MONTH(Order_Date) AS Month_number,
	   sum(Sales_Amount) as Total_Sales_Amount
FROM orders
GROUP BY Month_,Month_number
ORDER BY Total_Sales_Amount DESC
LIMIT 5 ;

-- Quarterly Sales Trends 

SELECT quarter(Order_Date) AS Quarter, sum(Sales_Amount) as Total_Sales_Amount
FROM orders
GROUP BY Quarter
ORDER BY Quarter;

-------------------------------------------------------------------------
-- Profitability :
-- Product sub-categories ranked by total profit in descending order

SELECT products.Sub_Category, sum(orders.Profit) as Total_Profit_Amount 
FROM products
INNER JOIN orders
ON products.ProductID = orders.ProductID
GROUP BY products.Sub_Category
ORDER BY  Total_Profit_Amount DESC ;

-- Total profit by region, ordered in descending order

SELECT c.Region, SUM(o.Profit) AS Total_Profit_Amount
FROM customers c
INNER JOIN orders o
ON c.CustomerId = o.customerId
GROUP BY c.Region
ORDER BY Total_Profit_Amount DESC;

-- Cities ranked by total profit (highest to lowest)

SELECT c.City, SUM(o.Profit) AS Total_Profit_Amount
FROM customers c
INNER JOIN orders o
ON c.CustomerId = o.customerId
GROUP BY c.City
ORDER BY Total_Profit_Amount DESC;

--------------------------------------------------------------------------
-- Customer Segments:
-- Customers-Wise Total spending order by spending from highest to lowest
SELECT C.Customer_Name , SUM(O.SALES_AMOUNT) AS TOTAL_SALES
FROM CUSTOMERS AS C
INNER JOIN ORDERS AS O
ON C.CUSTOMERID = O.CUSTOMERID
GROUP BY C.CUSTOMER_NAME
ORDER BY TOTAL_SALES DESC;

-- Customers-wise spending on differnt Category of products order by Customers and their spending from highest to lowest
SELECT C.Customer_Name ,
	   P.Category,
       SUM(O.SALES_AMOUNT) AS TOTAL_SALES
FROM CUSTOMERS AS C
INNER JOIN ORDERS AS O
ON C.CUSTOMERID = O.CUSTOMERID
INNER JOIN products AS P
ON O.ProductID = P.ProductID
GROUP BY C.CUSTOMER_NAME,P.Category
ORDER BY C.Customer_Name,TOTAL_SALES DESC;


-- Region Wise spending ordered by spending from highet to lowest

SELECT C.REGION , SUM(O.SALES_AMOUNT) AS TOTAL_SALES
FROM CUSTOMERS AS C
INNER JOIN ORDERS AS O
ON C.CUSTOMERID = O.CUSTOMERID
GROUP BY C.REGION
ORDER BY TOTAL_SALES DESC;

------------------------------------------------------------------------
-- How discounts affect profit margin ?

SELECT DISCOUNT_PERCENTAGE, AVG(PROFIT)
FROM ORDERS
GROUP BY DISCOUNT_PERCENTAGE
ORDER BY AVG(PROFIT) DESC ;

------------------------------------------------------------------------
-- Product Analysis              |
-- Best selling product by Sales_amount
SELECT products.Sub_Category, sum(orders.SALES_AMOUNT) as Total_Sales_Amount 
FROM products
INNER JOIN orders
ON products.ProductID = orders.ProductID
GROUP BY products.Sub_Category
ORDER BY  Total_Sales_Amount DESC 
LIMIT 1 ;

-- Least selling product by Sales_amount
SELECT products.Sub_Category, sum(orders.SALES_AMOUNT) as Total_Sales_Amount 
FROM products
INNER JOIN orders
ON products.ProductID = orders.ProductID
GROUP BY products.Sub_Category
ORDER BY  Total_Sales_Amount  ASC
LIMIT 1;

-- Sub_category of Products from best selling to least selling based on Sales_amount, ordered by Sales_amount
SELECT products.Sub_Category, sum(orders.SALES_AMOUNT) as Total_Sales_Amount 
FROM products
INNER JOIN orders
ON products.ProductID = orders.ProductID
GROUP BY products.Sub_Category
ORDER BY  Total_Sales_Amount DESC ;

-- Sub_Category of products frombest selling to least selling based QUANTY SOLD, order by quantity sold
SELECT products.Sub_Category, sum(orders.QUANTITY) as Total_Quantity 
FROM products
INNER JOIN orders
ON products.ProductID = orders.ProductID
GROUP BY products.Sub_Category
ORDER BY  Total_Quantity DESC ;

------------------------------------------------------------------------------------------
-- Payment Behavior :
-- Which Payment methods is most used in different regions 
SELECT CUSTOMERS.REGION,
		orders.Payment_Method, 
		COUNT(orders.Payment_Method) AS COUNT
FROM CUSTOMERS
INNER JOIN orders
ON CUSTOMERS.CustomerID = orders.CustomerID
GROUP BY CUSTOMERS.REGION,orders.Payment_Method
ORDER BY CUSTOMERS.REGION,COUNT DESC;

-- Which Payment methods is most used in different cities 
SELECT CUSTOMERS.CITY,orders.Payment_Method, COUNT(orders.Payment_Method) AS COUNT
FROM CUSTOMERS
INNER JOIN orders
ON CUSTOMERS.CustomerID = orders.CustomerID
GROUP BY CUSTOMERS.CITY,orders.Payment_Method
ORDER BY CUSTOMERS.CITY,COUNT DESC;

------------------------------------------------------------------------------
-- Operational Bottlenecks 
-- Where most returns occur by Region

SELECT CUSTOMERS.REGION, COUNT(ORDERS.DELIVERY_STATUS) AS COUNT
FROM CUSTOMERS
INNER JOIN (SELECT * 
			FROM ORDERS 
			WHERE DELIVERY_STATUS = "Returned") AS ORDERS
ON CUSTOMERS.CustomerID = ORDERS.CustomerID
GROUP BY CUSTOMERS.REGION
ORDER BY COUNT DESC;

-- Where most returns occur by Region and cty

SELECT CUSTOMERS.REGION,CUSTOMERS.CITY, COUNT(ORDERS.DELIVERY_STATUS) AS COUNT
FROM CUSTOMERS
INNER JOIN (SELECT * 
			FROM ORDERS 
			WHERE DELIVERY_STATUS = "Returned") AS ORDERS
ON CUSTOMERS.CustomerID = ORDERS.CustomerID
GROUP BY CUSTOMERS.REGION,CUSTOMERS.CITY
ORDER BY CUSTOMERS.REGION,COUNT DESC;



