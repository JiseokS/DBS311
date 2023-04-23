-- ***********************
-- Name: Jiseok Shim
-- ID: 122758170
-- Date: 2022-05-27
-- Purpose: Lab 2 DBS311NBB
-- ***********************


-- Q1: For each job title display the number of employees. 
SELECT job_title, COUNT(*) as employees -- Use count to count all selected rows (number of employees)
FROM employees                          -- from employees table
GROUP BY job_title;                     -- To apply group function 

-- Q2: Display the Highest, Lowest and Average customer credit limits. Name these results High, Low and Avg. Add a column that shows the difference between the highest and lowest credit limits. o	Use the round function to display two digits after the decimal point.
SELECT MAX(credit_limit)AS "High",                      -- Use Max, Min, Avg to select Highest, Lowest and Average credit limits of customer 
MIN(credit_limit) AS "Low", 
ROUND(AVG(credit_limit),2) AS "Avg", 
(MAX(credit_limit)-MIN(credit_limit)) AS "Difference"   -- calculate highest - lowest credit limit = Difference of highest and lowest
FROM customers;                                         -- from customers table

-- Q3: Display the order id and the total order amount for orders with the total amount over $1000,000. 
SELECT order_id, SUM(quantity*unit_price) AS Total_Order_Amount      -- Sum value of (quantity*unit_price)
FROM order_items                                                     -- from order_items table
GROUP BY order_id                                                    -- To apply group function 
HAVING SUM(quantity*unit_price) > 1000000                            -- Use having to exclude total_order_amount values that less than 1000000
ORDER BY Total_Order_Amount DESC;                                    -- use DESC to descending total_order_amount values

-- Q4: Display the warehouse id, warehouse name, and the total number of products for each warehouse. 
SELECT i.warehouse_id, w.warehouse_name, SUM(i.quantity) AS Total_Number_Products    -- i.warehouse_id from inventories table, w.warehouse_name from warehouse table, and sum quantity values from inventories table
FROM inventories i                                                        -- inventories table is left(default table) and warehouse table is right
LEFT JOIN warehouses w ON i.warehouse_id = w.warehouse_id                
GROUP BY i.warehouse_id, w.warehouse_name                                 -- use group by to apply group function
ORDER BY i.warehouse_id;                                                  -- sort data by inventories warehouse_id

-- Q5: For each customer display the number of orders issued by the customer. If the customer does not have any orders, the result show display 0.
SELECT c.customer_id ,COUNT(o.customer_id) AS Number_Orders              -- c.customer_id from customers table, o.customer_id from order table, and counting order table customer_id
FROM orders o RIGHT JOIN customers c ON o.customer_id = c.customer_id    -- orders table is left and customers table is right(default table)
GROUP BY c.customer_id;                                                  -- apply group function

-- Q6: Write a SQL query to show the total and the average sale amount for each category.
SELECT p.category_id , SUM (quantity* unit_price)AS Total_Amount, AVG(quantity*unit_price) AS Average_Amount   -- p.category_id is from products table, sum values(quantity*unit_price), average value of (quantity*unit_price)
FROM order_items o LEFT JOIN products p ON o.product_id = p.product_id        --order_items table is left(default table) and products table is right
GROUP BY p.category_id;                                                       -- apply group function