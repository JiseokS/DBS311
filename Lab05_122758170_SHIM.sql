-- ***********************
-- Name: Jiseok Shim
-- ID: 122758170
-- Date: 2022-07-08
-- Purpose: Lab 5 DBS311
-- ***********************

/*1.	Write a store procedure that get an integer number and prints
The number is even.
If a number is divisible by 2.
Otherwise, it prints 
The number is odd.
*/

CREATE OR REPLACE PROCEDURE division(InputNum IN NUMBER) AS                   --make procedure that named division and parameter is InputNum(number)
BEGIN
  IF MOD(InputNum, 2) = 0                                                     --Use MOD to devide InputNum by 2
THEN
  DBMS_OUTPUT.PUT_LINE ('The number is even.');                               --If InputNum /2 = 0 display "The number is even."
ELSE 
  DBMS_OUTPUT.PUT_LINE ('The number is odd.');                                --If InputNum /2 != 0 display "The number is odd."
 END IF;                                                                      --End if loop
END;

EXECUTE division(20);
EXECUTE division(7);


/*2.	Create a stored procedure named find_employee. This procedure gets an employee number and prints the following employee information:
First name 
Last name 
Email
Phone 	
Hire date 
Job title

The procedure gets a value as the employee ID of type NUMBER.
See the following example for employee ID 107: 
*/

SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE find_employee(empNumber IN NUMBER) AS               --Make prodecure that called find_employee and the parameter is empNumber(number)
firstName VARCHAR(256 BYTE);                                                    --Make firstname that is char type and size is 256 byte
lastName VARCHAR (256 BYTE);                                                    --Make lastName that is char type and size is 256 byte
EmailAddress VARCHAR (256 BYTE);                                                --Make EmailAddress that is char type and size is 256 byte
PhoneNumber VARCHAR (256 BYTE);                                                 --Make PhoneNumber that is char type and size is 256 byte
hireDate VARCHAR (256 BYTE);                                                    --Make hireDate that is char type and size is 256 byte
jobTitle VARCHAR (256 BYTE);                                                    --Make jobTitle that is char type and size is 256 byte

BEGIN
  SELECT first_name, last_name, email, phone, hire_date, job_Title              --Copy values of first_name, last_name, email, phone, hire_date and job_title 
  INTO firstName,lastName,EmailAddress,PhoneNumber,hireDate,jobTitle            --to firstName, lastName, EmailAddress, PhoneNumber, hireDate, jobTitle
  FROM employees
  WHERE employee_id = empNumber;                                                

  DBMS_OUTPUT.PUT_LINE ('First Name: '|| firstName);                            --Display firstname
  DBMS_OUTPUT.PUT_LINE ('Last Name: '|| lastName);                              --Display lastName
  DBMS_OUTPUT.PUT_LINE ('Email: '|| EmailAddress);                              --Display EmailAddress
  DBMS_OUTPUT.PUT_LINE ('Phone: '|| PhoneNumber);                               --Display PhoneNumber
  DBMS_OUTPUT.PUT_LINE ('Hire Date: '|| hireDate);                              --Display hireDate
  DBMS_OUTPUT.PUT_LINE ('Job Title: '|| jobTitle);                              --Display jobTitle

IF SQL %ROWCOUNT = 0                                                            --For implicit cursors
THEN 
DBMS_OUTPUT.PUT_LINE ('Employee ID '|| empNumber||'Not found');                 --If rowcount is 0 display employee ID -- not found.
END IF;
EXCEPTION  
WHEN OTHERS
THEN
DBMS_OUTPUT.PUT_LINE ('ERROR!');                                                --Display ERROR!

END;
BEGIN
find_employee(107);                                                             --Select employee number 107 and display information
END;

BEGIN
find_employee(1234567);                                                         --1234567 is not valid employee number so display ERROR!
END;
/*3.	Every year, the company increases the price of all products in one category. For example, the company wants to increase the price (list_price) of 
products in category 1 by $5. Write a procedure named update_price_by_cat to update the price of all products in a given category and the given amount to be 
added to the current price if the price is greater than 0. The procedure shows the number of updated rows if the update is successful.*/
SET SERVEROUTPUT ON;

create or replace procedure update_price_by_cat (m_category_id IN products.category_id%TYPE, m_amount IN products.list_price%TYPE) --Make procedure called update_price_by_cat and the parameters are m_category_id from products.category_id and m_amount from products.list_price
as m_value number;           --m_value is number
BEGIN
SELECT COUNT(category_id) INTO m_value FROM products WHERE category_id = m_category_id;  --counting category_id and input to m_value from products table who is category_id = m_category_id
IF (m_amount > 0 and m_value > 0) THEN
UPDATE products SET LIST_PRICE = LIST_PRICE + m_amount WHERE category_id = m_category_id;   --Update value of products 
DBMS_OUTPUT.PUT_LINE('Rows updated :' || SQL%rowcount);                                     --Display Rows updated : rowcount
ELSE
DBMS_OUTPUT.PUT_LINE('The category entered does not exist or the price is less than zero'); --error handling and display 'The category entered does not exist or the price is less than zero'
END IF;
END;

BEGIN
update_price_by_cat(4,5);
END;

/*4.	Every year, the company increase the price of products whose price is less than the average price of all products by 1%. (list_price * 1.01).
 Write a stored procedure named update_price_under_avg. This procedure do not have any parameters. You need to find the average price of all products 
and store it into a variable of the same type. If the average price is less than or equal to $1000, update products’ price by 2% if the price of the product
 is less than the calculated average. If the average price is greater than $1000, update products’ price by 1% if the price of the product is less than
 the calculated average. The query displays an error message if any error occurs. Otherwise, it displays the number of updated rows.
*/
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE update_price_under_avg AS                   --make procedure called update_price_number_avg
AvgPrice products.list_price%TYPE;                                     
updatedRows NUMBER;                                                     --updateRows is number type
BEGIN
 SELECT avg(list_price) INTO AvgPrice                                   --select average of list_price and put into AvgPrice
 FROM products; 

IF(AvgPrice <= 1000) --If AvgPrice is less or same as 1000
THEN
UPDATE products SET products.list_price = products.list_price * 1.02       --multiply 1.02 to products.list_price 
WHERE list_price < AvgPrice;                                               --which is value of list_price is less than AvgPrice 

updatedRows := SQL%ROWCOUNT;
DBMS_OUTPUT.PUT_LINE ('Rows updated: '|| updatedRows);
ELSE
UPDATE products SET products.list_price = products.list_price * 1.01      --multiply 1.02 to products.list_price 
WHERE list_price < AvgPrice;                                              --which is value of list_price is less than AvgPrice 

updatedRows := SQL%ROWCOUNT;
DBMS_OUTPUT.PUT_LINE ('Rows updated: '|| updatedRows);
END IF;
EXCEPTION
WHEN OTHERS
THEN DBMS_OUTPUT.PUT_LINE ('Error!!');
END;

BEGIN
update_price_under_avg();
END;
/*5.	The company needs a report that shows three category of products based their prices. The company needs to know if the product price is cheap, fair, or expensive. Let’s assume that
?	If the list price is less than 
o	(avg_price - min_price) / 2
The product’s price is cheap.
?	If the list price is greater than 
o	(max_price - avg_price) / 2
The product’ price is expensive.
?	If the list price is between 
o	(avg_price - min_price) / 2
o	and
o	(max_price - avg_price) / 2
o	the end values included
The product’s price is fair.
*/
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE product_price_report AS                      --Make procedure called product_price_report that has no parameter
price products.list_price%TYPE;                                          
avg_price products.list_price%TYPE;
min_price products.list_price%TYPE;
max_price products.list_price%TYPE;
cheap_count NUMBER;
fair_count NUMBER;
exp_count NUMBER;
calculate1 FLOAT;
calculate2 FLOAT;

BEGIN
SELECT AVG(list_price), MAX(list_price), MIN(list_price) INTO avg_price, max_price, min_price  --Select average of list_price, maximum of list_price, Minimum of list_price to avg_price, max_price, and min_price
FROM products;

calculate1 := (avg_price - min_price)/2;           
calculate2 := (max_price - avg_price)/2;

SELECT COUNT(*) INTO cheap_count                             --cheap_count is counting which list_price is less than calculate1 from products table
FROM products
WHERE list_price < calculate1;
DBMS_OUTPUT.PUT_LINE ('Cheap count: '|| cheap_count);

SELECT COUNT(*) INTO exp_count                               --exp_count is counting which list_price is more than calculate2 from products table
FROM products
WHERE list_price > calculate2;
DBMS_OUTPUT.PUT_LINE ('Expensive count: '|| exp_count);

SELECT COUNT(*) INTO fair_count                              --fair_count is counting which list_price is more than calculate1 and less than calculate2 from products table
FROM products
WHERE list_price > calculate1 AND list_price < calculate2;
DBMS_OUTPUT.PUT_LINE ('Fair count: '|| fair_count);

EXCEPTION 
 WHEN OTHERS
 THEN
 DBMS_OUTPUT.PUT_LINE ('ERROR!');                            --Error handling and display ERROR!
END;

BEGIN
product_price_report();
END;