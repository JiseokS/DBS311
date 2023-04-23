-- ***********************
-- Name: Jiseok Shim
-- ID: 122758170
-- Email: jshim13@myseneca.ca
-- Date: 2022-05-19
-- Purpose: Lab 1 DBS311NBB
-- ***********************

--Q1: Write a query to display the tomorrow's date in the following format
SELECT to_char(sysdate + 1, 'Month ddth "of year" yyyy')  AS "Tomorrow" -- sysdate displays current date, and +1 means add 1 date to current date
FROM dual;          -- dual is dummy table

/* Q2: For each product in category 2, 3, and 5, show product ID, product name, list price, and the new list price increased by 2%. Display a new list price as a whole number.
In your result, add a calculated column to show the difference of old and new list prices.*/

SELECT
   product_id, product_name, list_price, (list_price*1.02) AS "NEW price", (list_price*0.02) AS "price difference"  -- use AS rename the value of list_price*1.02 and list_price 0.02
FROM
   products                  -- From table products
WHERE
   category_id IN (2, 3, 5);          -- Only select which category_id value are 2,3 and 5
   
/* Q3: For employees whose manager ID is 2, write a query that displays the employee’s Full Name and Job Title in the following format:
SUMMER, PAYNE is Public Accountant.*/
SELECT first_name || ' ' || last_name ||' is '|| job_title as "Full name and Job Title"       -- Use || to combine previous one and latter one
FROM employees            -- From table employees
WHERE manager_id =2;      -- only select manager_id = 2

/* Q4: For each employee hired before October 2016, display the employee’s last name, hire date and calculate the number of YEARS 
between TODAY and the date the employee was hired.
•	Label the column Years worked. 
•	Order your results by the number of years employed.  Round the number of years employed up to the closest whole number.*/

SELECT last_name, hire_date, ROUND((sysdate - hire_date)/365) AS "Continuous service years"  -- (sysdate - hire_date) and divide 365 to make service years and use ROUND to round value to close year
FROM employees;       --From table employees

/* Q5: Display each employee’s last name, hire date, and the review date, which is the first Tuesday after a year of service, 
but only for those hired after 2016.  
•	Label the column REVIEW DAY. 
•	Format the dates to appear in the format like:
    TUESDAY, August the Thirty-First of year 2016
•	Sort by review date*/

SELECT last_name, hire_date, to_char(next_day(add_months(hire_date, 12), 'TUESDAY'), 'DAY, Month "the" ddspth "of year" yyyy') AS "Review Day" -- to_char transfer integer, date format to letter EX) "TUESDAY, August the Thirty-First of year 2016"  
FROM employees                                                -- From table employees                                                                                                       -- use ddspth to change date format to letter format EX) 24 -> Twenty-Four
WHERE trunc(hire_date) > to_date('01/01/2016', 'dd/mm/yyyy') -- Only display hired after 2016 Jan First
ORDER BY hire_date;                                          -- Sorting by hie_date

/* Q6: For all warehouses, display warehouse id, warehouse name, city, and state. For warehouses with the null value for the state column,
display “unknown”. */

SELECT warehouse_id, warehouse_name, l.city, l.state                       -- 1.city and 1.state are location.city, location,state                              
FROM warehouses w LEFT JOIN locations l on w.location_id = l.location_id;  -- only display warehouse and intersection of warehouse and locations.

