-- ***********************
-- Name: Jiseok Shim
-- ID: 122758170
-- Date: 2022-06-03
-- Purpose: Lab 3 DBS311NBB
-- ***********************
--1.	Write a SQL query to display the last name and hire date of all employees who were hired before the employee with ID 107 got hired. Sort the result by the hire date.
SHOW user                                     --Display user ID
SELECT last_name, hire_date                   --Display last_name and hire_date
FROM employees                                --From table employees
WHERE hire_date < (SELECT hire_date           --Only get values of hire_date before('<') hire_date of employee_id is 107(using subquery)
                   FROM employees
                   WHERE employee_id = 107)
ORDER BY hire_date;                           --Sorting by hire_date
--2.	Write a SQL query to display customer name and credit limit for customers with lowest credit limit. Sort the result by customer name.
SHOW user                                            --Display user ID
SELECT name, credit_limit                            --Display customer name and credit limit
FROM customers                                       --From table customers
WHERE credit_limit IN (SELECT MIN(credit_limit)      --Use IN(equal to many member) to return more than one row, MIN is for get lowest value of credit limit
                      FROM customers )
ORDER BY name;                                       --Sorting by customer name
--3.	Write a SQL query to display the product ID, product name, and list price of the highest paid product(s) in each category.  Sort by category ID. 
SHOW user                                                  --Display user ID
SELECT category_id, product_id, product_name, list_price   --Display category id, product id, product name and list price 
FROM products                                              --From table products
WHERE list_price IN (SELECT MAX(list_price)                --Use IN(equal to many member) to return more than one row, MAX is for get Highest value of list price
                  FROM products
                  GROUP BY category_id)                    --GROUP BY to apply group function by category_id
ORDER BY category_id;                                      --Sorting by category_id
--4.	Write a SQL query to display the category name of the most expensive (highest list price) product(s).
SHOW user                                                                                --Display user ID
SELECT pc.category_name, p.list_price                                                    --Display category_name from product_categories table, and list_price from products table
FROM products p INNER JOIN product_categories pc on p.category_id = pc.category_id       --Use INNER JOIN to select only matching values in both tables(product_categories, products)
WHERE list_price = (SELECT MAX(list_price)                                               --Only select list price is highest list_price in produts table
                      FROM products);                                                 
--5.	Write a SQL query to display product name and list price for products in category 1 which have the list price less than the lowest list price in ANY category.  Sort the output by top list prices first and then by the product name.
SHOW user                                              --Display user ID
SELECT product_name, list_price                        --Display product_name and list_price
FROM products                                          --From table products
WHERE list_price < ANY (SELECT MIN(list_price)         --Select values less than ('<') lowest list price which is in category 1
                        FROM products                  --From table products
                        GROUP BY category_id)          --GROUP BY to apply group function by category_id
                        AND category_id = 1
GROUP BY list_price, product_name;                     --Sorting by list_price and then product_name
--6.	Display product ID, product name, and category ID for products of the category(s) that the lowest price product belongs to.
SHOW user                                                         --Display user ID
SELECT product_id, product_name, category_id                      --Display product_id, product_name and category_id
FROM products                                                     --From table products
WHERE category_id = (SELECT category_id                           --Select values of category id from products which is list price is lowest list price from products
                     FROM products
                     WHERE list_price = (SELECT MIN(list_price)
                     FROM products));