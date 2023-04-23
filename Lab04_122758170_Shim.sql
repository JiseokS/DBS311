-- ***********************
-- Name: Jiseok Shim
-- ID: 122758170
-- Date: 2022-06-10
-- Purpose: Lab 4 DBS311
-- ***********************
--1.	The HR department needs a list of Department IDs for departments that do not contain the job ID of ST_CLERK> Use a set operator to create this report.
show user;
SELECT department_id "Department IDs" from departments                  -- display department_id to "Department IDs" from departments table
MINUS                                                                   --only select department_id from departments
SELECT department_id from employees WHERE job_id  = 'ST_CLERK';
--2.	Display cities that no warehouse is located in them. (use set operators to answer this question)
show user;
SELECT city                                                    --display city
FROM locations                                                 --from table locations
WHERE location_id IN (SELECT location_id FROM locations        --use sub query to use set operator(MINUS) display location_id from locations that not include location_id from warehouses 
                      MINUS
                      SELECT location_id FROM warehouses)
ORDER BY city;                                                 --sort by city
--3.	Display the category ID, category name, and the number of products in category 1, 2, and 5. In your result, display first the number of products in category 5, then category 1 and then 2.
show user;
SELECT p.category_id , pc.category_name, COUNT(*)       --display category_id from products, category_name from product_categories, and return total numbers of rows(COUNT(*))
FROM products p 
INNER JOIN 
    (SELECT category_id, category_name                  --use sub-query to select the category_id and category_name
     FROM product_categories                            --use inner join (sub query and products table)
     WHERE category_id 
     IN (1,2,5)
INTERSECT                                               --Only select duplicated value in products and product_categories tables
SELECT category_id, category_name 
FROM product_categories) pc 
ON p.category_id = pc.category_id 
GROUP BY p.category_id, pc.category_name
ORDER BY COUNT(*) DESC;                                --To display category id 5 1 and 2
--4.	Display product ID for ordered products whose quantity in the inventory is greater than 5. (You are not allowed to use JOIN for this question.)
show user;
select product_id from products                                          --display product_id from product table
INTERSECT                                                                --Only select duplicated value in products and inventories tables
select product_id from inventories WHERE inventories.quantity > 5;       --select value that are greater than '5'

--5.	We need a single report to display all warehouses and the state that they are located in and all states regardless of whether they have warehouses in them or not.
show user;
SELECT w.warehouse_name, l.state                   --display warehouse_name from warehouses and state from location table          
FROM warehouses w INNER JOIN locations l 
ON w.location_id = l.location_id 
UNION                                              --select values that all warehouse_name and state from warehouses table and locations table duplicates not showing twice
SELECT l.warehouse_name, w.state 
FROM locations w LEFT JOIN warehouses l 
ON w.location_id = l.location_id 
WHERE l.warehouse_name IS NULL ;                   --Use left join to select the state where the warehouse_name is null