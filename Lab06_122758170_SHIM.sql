-- ID: 122758170
-- Date: 2022-07-15
-- Purpose: Lab 5 DBS311
-- ***********************

/*1.	Write a store procedure that gets an integer number n and calculates and displays its factorial.
Example:
0! = 1
2! = fact(2) = 2 * 1 = 1
3! = fact(3) = 3 * 2 * 1 = 6
. . .
n! = fact(n) = n * (n-1) * (n-2) * . . . * 1
*/

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE factorial(num IN INT) AS                       --create procedure that called factorial and the parameter is num (type is integer)
  total INT :=1;                                                           --declare total as integer type and make it as '1'
  str VARCHAR(255) := num || '!' || ' = ' || 'fact(' || num || ') = ';     --make str format as above example "n! = fact(n) ="
  
BEGIN
  IF num = 0 THEN                                                          --initiate below command when num is 0
    DBMS_OUTPUT.PUT_LINE (num || '! = ' || num);                           --display "num! = num
  ELSE                                                                  
    FOR i IN REVERSE 1.. num LOOP                                          --initiate i = num and when first loop is done i = i-1 until i = 1
        total := total * i;                                                
        IF i = num THEN                                                    --IF i is num initiate below command 
          str := str || i;
        ELSE                                                               --IF i is not num initiate below command
          str := str || ' * ' || i;
        END IF;                                                            --End IF LOOP
    END LOOP;                                                              --End FOR LOOP
    DBMS_OUTPUT.PUT_LINE (str || ' = ' || total);                          --display str = total
   END IF;                                                                 --END IF LOOP
EXCEPTION
WHEN OTHERS THEN
   DBMS_OUTPUT.PUT_LINE ('ERROR!');                                        --Make exception when factorial function is not working and display ERROR! 
END;

/*
2.	The company wants to calculate the employees’ annual salary:
The first year of employment, the amount of salary is the base salary which is $10,000.
Every year after that, the salary increases by 5%.
Write a stored procedure named calculate_salary which gets an employee ID and for that employee calculates the salary based on the number of years the employee has been working in the company.  (Use a loop construct to calculate the salary).
The procedure calculates and prints the salary.
Sample output:
First Name: first_name 
Last Name: last_name
Salary: $9999,99
If the employee does not exists, the procedure displays a proper message.
*/

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE calculate_salary(emp_id IN INT) AS            --make procedure that called calculate_salary and parameter is emp_id 
fname VARCHAR(255 BYTE);
lname VARCHAR(255 BYTE);
salary NUMBER(8,2) := 10000;
hiredate DATE;
careeryear INT;
BEGIN
  SELECT first_name, last_name, hire_date INTO fname, lname, hiredate     --Get values from first_name last_name and hire_date and put values into fname, lname, and hiredate
  FROM employees
  WHERE employee_id = emp_id;                                             --only when employee_id is emp_id
  careeryear := FLOOR(MONTHS_BETWEEN(SYSDATE,hiredate)/12);               --calculate months between today and hiredate and divide by 12 = years. and use floor to make it integer value
  FOR i IN 1.. careeryear LOOP                                            --Use FOR LOOP start with i = 1 and when first loop is done i= i + 1 until i = careeryears 
    salary := salary * 1.05;                                              
  END LOOP;                                                               --End FOR LOOP
DBMS_OUTPUT.PUT_LINE ('First Name: ' || fname);                           --display firstname , lastname, and salary
DBMS_OUTPUT.PUT_LINE ('Last Name: '|| lname);
DBMS_OUTPUT.PUT_LINE ('Salary: $' || salary);
EXCEPTION
WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE ('ERROR!');                                         --When calculate_salary function is not working display ERROR!
END;

BEGIN
calculate_salary(100);
END;


/*
3.	Write a stored procedure named warehouses_report to print the warehouse ID, warehouse name, and the city where the warehouse is located in the following format for all warehouses:

Warehouse ID:
Warehouse name:
City:
State:

If the value of state does not exist (null), display “no state”.
The value of warehouse ID ranges from 1 to 9.
You can use a loop to find and display the information of each warehouse inside the loop.
(Use a loop construct to answer this question. Do not use cursors.) 
*/


SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE warehouses_report AS                              --Make procedure that called warehouses_report has no parameter
warehouseId warehouses.warehouse_id%TYPE;                                     --warehouseId type is warehouse_id type from warehouses table
warehouseName warehouses.warehouse_name%TYPE;                                 --warehouseName type is warehouse_name type from warehouses table
m_city locations.city%TYPE;                                                   --m_city type is city type from locations table
m_state locations.state%TYPE;                                                 --m_state type is state type from locations table
i warehouses.warehouse_id%TYPE := 1;                                          --i type is warehouse_id type from warehouses table and i is 1
BEGIN
 LOOP
  SELECT w.warehouse_id, w.warehouse_name, l.city, NVL(l.state, 'no state')   --select values of warehouse_id and warehouse_name from warehouses table, city from locations table. Use NYL to let replace null with 'no state' 
  INTO warehouseId, warehouseName, m_city, m_state                            --put values INTO warehouseId, warehouseName, m_city, and m_state 
  FROM warehouses w JOIN locations l ON w.location_id = l.location_id         
  WHERE w.warehouse_id = i;
  DBMS_OUTPUT.PUT_LINE ('Warehouse ID: ' || warehouseId);                     --Display warehouses Id
  DBMS_OUTPUT.PUT_LINE ('Warehouse Name: ' || warehouseName);                 --Display warehouses Name
  DBMS_OUTPUT.PUT_LINE ('City: ' || m_city);                                  --Display city
  DBMS_OUTPUT.PUT_LINE ('State: ' || m_state);                                --Display state
  DBMS_OUTPUT.PUT_LINE ('');
  i := i+1;                                                                 
  EXIT WHEN i>9;                                                              --initiate loop i until i>9
  END LOOP;                                                                   --End Loop
EXCEPTION 
WHEN NO_DATA_FOUND THEN                                                       --When system can not found data initiate below command
  DBMS_OUTPUT.PUT_LINE ('There is no data found.');                           
WHEN OTHERS THEN                                                              --When function is not working initiate below command
  DBMS_OUTPUT.PUT_LINE ('ERROR!');
END;
 
BEGIN
warehouses_report();
END;