-- Query 1: Monthly Performance Analysis
SELECT 
    substr("Order Date", 7, 4) AS Year,
    substr("Order Date", 4, 2) AS Month,
    ROUND(SUM("Total Sales"), 2) AS Monthly_Sales,
    ROUND(SUM(Profit), 2) AS Monthly_Profit
FROM orders
GROUP BY Year, Month
ORDER BY Year, Month;
-- Query 2: Monthly Growth Rate

SELECT
    t1.Year,
    t1.Month,
    t1.Monthly_Sales,
    t2.Monthly_Sales AS Previous_Month_Sales,

    ROUND(
        ((t1.Monthly_Sales - t2.Monthly_Sales)
        / t2.Monthly_Sales) * 100,
        2
    ) AS Growth_Percentage

FROM
(
    SELECT
        substr("Order Date",7,4) AS Year,
        substr("Order Date",4,2) AS Month,
        SUM("Total Sales") AS Monthly_Sales
    FROM Orders
    GROUP BY Year, Month
) t1

LEFT JOIN

(
    SELECT
        substr("Order Date",7,4) AS Year,
        substr("Order Date",4,2) AS Month,
        SUM("Total Sales") AS Monthly_Sales
    FROM Orders
    GROUP BY Year, Month
) t2

ON
CAST(t1.Year AS INTEGER)=CAST(t2.Year AS INTEGER)
AND CAST(t1.Month AS INTEGER)=CAST(t2.Month AS INTEGER)+1

ORDER BY
t1.Year,
t1.Month;

-- Query 3: Business Classification using CASE

SELECT
    "Order ID",
    "Total Sales",

    CASE
        WHEN "Total Sales" > 1000 THEN 'High Value'
        WHEN "Total Sales" BETWEEN 500 AND 1000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Order_Type

FROM Orders;
-- Query 3B: Count Orders by Category

SELECT
    CASE
        WHEN "Total Sales" > 1000 THEN 'High Value'
        WHEN "Total Sales" BETWEEN 500 AND 1000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Order_Type,

    COUNT(*) AS Number_of_Orders

FROM Orders

GROUP BY Order_Type

ORDER BY Number_of_Orders DESC;

-- Query 4: Underperforming Regions
SELECT
    c.Region,
    ROUND(SUM(o.Profit),2) AS Total_Profit
FROM Orders o
JOIN Customers c
ON o."Customer ID" = c."Customer ID"
GROUP BY c.Region
HAVING SUM(o.Profit) < 1100000
ORDER BY Total_Profit;