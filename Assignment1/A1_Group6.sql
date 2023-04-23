-- ***********************
-- Student1 Name: Jiseok Shim Student1 ID: 122758170
-- Date: 2022-06-24
-- Purpose: Assignment 1 - DBS311
-- ***********************

--1. Display the employee number, full employee name, job title, and hire date of all employees hired in September with the most recently hired 
--   employees displayed first. 
--Q1 SOLUCTION--
SELECT employee_id AS "Employee Number", last_name ||', '|| first_name AS "Full Name"   --Display employee_id, full name, job_title, and start date
, job_title AS "Job Title", TO_CHAR(hire_date, 'Month ddth "of" YYYY') AS "Start Date"  --Use TO_CHAR to make character format(Month dath of year) from integer format
FROM employees                                                                          --From employees table
WHERE EXTRACT (MONTH FROM hire_date)=9                                                  --Use EXTRACT to select which month is 9
ORDER BY hire_date DESC;                                                                --descending by hire_date

--2.	The company wants to see the total sale amount per sales person (salesman) for all orders. Assume that online orders do not have any sales 
--representative. For online orders (orders with no salesman ID), consider the salesman ID as 0. Display the salesman ID and the total sale amount 
--for each employee. Sort the result according to employee number.
--Q2 SOLUCTION--
SELECT NVL(o.salesman_id, 0) AS "Employee Number", TO_CHAR(SUM(oi.quantity * oi.unit_price),'$999,999,999,99') AS "Total Sale"
FROM orders o LEFT JOIN order_items oi    --Use NVL function if salesman_id is null make salesman_id 0, Use TO_CHAR make (quantity*unit_price) $999,999,999,99 format
USING (order_id)                          --orders table is default table
GROUP BY o.salesman_id
ORDER BY 1;                               --ORDER BY 1 means ORDER BY "Employee Number"

--3.Display customer Id, customer name and total number of orders for customers that the value of their customer ID is in values from 35 to 45.
--Include the customers with no orders in your report if their customer ID falls in the range 35 and 45. Sort the result by the value of total orders. 
--Q3 SOLUCTION--
SELECT c.customer_id AS "Customer Id", c.name AS "Name" , COUNT(o.order_id) AS "Total Orders"   --Use COUNT to counting order_id
FROM customers c
FULL OUTER JOIN orders o ON c.customer_id = o.customer_id           --FULL OUTER JOIN is selecting from whole two tables(customers, orders)
WHERE c.customer_id BETWEEN 35 AND 45                               --Only select customer_id value between 35 and 45
GROUP BY c.customer_id, c.name                                      --Grouping by customer_id and name from customers table
ORDER BY "Total Orders";                                            --Sorting by Total Orders

--4.	Display customer ID, customer name, and the order ID and the order date of all orders for customer whose ID is 44.
--a.	Show also the total quantity and the total amount of each customer’s order.
--b.	Sort the result from the highest to lowest total order amount.
--Q4 SOLUCTION--
SELECT c.customer_id AS "Customer Id" , c.name AS "Name", o.order_id AS "Order Id", TO_CHAR(o.order_date, 'dd-MON-yy') "Order Date"  --TO_CHAR make order_date values from orders table Date-Month-Year(00-00-00) format
, SUM(i.quantity) "Total Items", TO_CHAR(SUM(i.quantity*i.unit_price),'FM$999,999,999.99') "Total Amount"  --SUM value of (quantity * unit_price), TO_CHAR make (quantity*unit_price) $999,999,999,99 format
FROM customers c JOIN orders o ON c.customer_id=o.customer_id   --customers is default table
JOIN order_items i ON o.order_id=i.order_id
WHERE c.customer_id=44                                          --Select customer_id from customers table value = 44 
GROUP BY c.customer_id, c.name, o.order_id, o.order_date
ORDER BY SUM(i.quantity*i.unit_price) DESC;                     --Descending by Total Amount

--5.Display customer Id, name, total number of orders, the total number of items ordered, and the total order amount for customers who have
--  more than 30 orders. Sort the result based on the total number of orders.
--Q5 SOLUCTION--
SELECT c.customer_id AS "Customer Id", c.name AS "Name", COUNT(o.order_id) AS "Total Number of Orders"              --Count order_id from orders table 
, SUM(i.quantity) AS "Total Items", TO_CHAR(SUM(i.quantity*i.unit_price), '$999,999,999.99') AS "Total Amount"  --SUM values of (quantity), use TO_CHAR make SUM values of(quantity*unit_price) $999,999,999,99 format 
FROM customers c JOIN orders o                   --result of the inner join between  customers and orders
ON c.customer_id=o.customer_id                   --Make customer_id value from customers table and customer_id from orders table are equal
JOIN order_items i
ON o.order_id=i.order_id
GROUP BY c.customer_id, c.name                
HAVING COUNT(o.order_id)>30                      --Only select order_id values are more than 30
ORDER BY 3;                                      --Sorting by Total Number of Orders

--6.Display Warehouse Id, warehouse name, product category Id, product category name, and the lowest product standard cost for this combination.
--•In your result, include the rows that the lowest standard cost is less then $200.
--•Also, include the rows that the lowest cost is more than $500.
--•Sort the output according to Warehouse Id, warehouse name and then product category Id, and product category name.
--Q6 SOLUCTION--
SELECT i.warehouse_id AS "Warehouse ID", w.warehouse_name AS "Warehouse Name", c.category_id AS "Category ID" 
, c.category_name AS "Category Name", TO_CHAR(MIN(p.standard_cost),'$999,999,999.99') AS "Lowest Cost"  --Use TO_CHAR make minimum value of standard_cost $999,999,999,99 format
FROM warehouses w JOIN inventories i
ON w.warehouse_id=i.warehouse_id             --make warehouse_id values from warehouses table and warehouse_id values from inventories table are equal 
JOIN products p
ON i.product_id=p.product_id
JOIN product_categories c
ON p.category_id=c.category_id                --make category_id values from products table and category_id values from product_categories table are equal 
GROUP BY i.warehouse_id, w.warehouse_name, c.category_id, c.category_name
HAVING MIN(p.standard_cost) NOT BETWEEN 200 AND 500     --Only select minimum value of standard_cost is over 500 or under 200
ORDER BY 1, 2, 3, 4;            --Sorting by Warehouse ID, Warehouse Name, Category ID and Category Name

--7.	Display the total number of orders per month. Sort the result from January to December.
--Q7 SOLUCTION--
SELECT TO_CHAR(TO_DATE(EXTRACT(month FROM order_date),'MM'), 'Month') AS "Month", --Use EXTRACT select month from order_data and use TO_DATE make month to date format and use TO_CAHR make 'MM' Month format
COUNT(EXTRACT(month FROM order_date)) AS "Number of Orders"      --use EXTRACT select month from order_date and counting
FROM orders
GROUP BY EXTRACT(month FROM order_date) 
ORDER BY EXTRACT(month FROM order_date);                        --sorting by month from order_date

--8.	Display product Id, product name for products that their list price is more than any highest product standard cost per warehouse outside 
--Americas regions.(You need to find the highest standard cost for each warehouse that is located outside the Americas regions.Then you need to 
--return all products that their list price is higher than any highest standard cost of those warehouses.) Sort the result according to list price from highest value to the lowest.
--Q8 SOLUCTION--
SELECT pr.product_id "Product ID", pr.product_name "Product Name", TO_CHAR(pr.list_price,'$999,999,999.99') "Price"  --use TO_CHAR list_price make $999,999,999,99 format
FROM products pr
WHERE pr.list_price>ANY(SELECT MAX(p.standard_cost)            --Select pr.list_price over than maximum value of p.standard_cost, ANY means if even one value fits the previous inequality sign thats true
FROM products p JOIN inventories i ON p.product_id=i.product_id   --products table and inner join inventories table, product_id from products table and product_id from inventories table are equal
JOIN warehouses w ON i.warehouse_id=w.warehouse_id  --inner join warehouses table, warehouse_id from inventories table and warehouse_id from warehouses table are equal
JOIN locations l ON w.location_id=l.location_id  --inner join locations table, location_id from warehouses table and location_id from locations table are equal
JOIN countries c ON l.country_id=c.country_id  --inner join countries table, country_id from locations table and country_id from countries table are equal
JOIN regions r ON c.region_id=r.region_id      --inner join regions table, region_id from countries table and region_id from regions table are equal
WHERE LOWER (r.region_name)!='americas'        --make r.region_name lower alphabet that is not 'americas'
GROUP BY w.warehouse_id) 
ORDER BY 3 DESC;                               --sorting by Price 

--9.Write a SQL statement to display the most expensive and the cheapest product (list price). Display product ID, product name, and the list price.
--Q9 SOLUCTION--
SELECT product_id AS "Product ID", product_name AS "Product Name", list_price AS "Price"  --Display Product ID, Product Name, and Price
FROM products                                                                             --From products table
WHERE list_price = (SELECT MAX(list_price) FROM products)                                 --use subquery to select maximum list price from products
UNION                                                                         --Combine with below condition
    SELECT product_id, product_name, list_price
    FROM products
    WHERE list_price = (SELECT MIN(list_price) FROM products);                 --Select minimum list price from products

--10.	Write a SQL query to display the number of customers with total order amount over the average amount of all orders, the number of customers
--with total order amount under the average amount of all orders, number of customers with no orders, and the total number of customers.
--Q10 SOLUCTION--
