-- ***********************
-- Student1 Name: Jiseok Shim Student1 ID: 122758170
-- Date: 2022-08-09
-- Purpose: Assignment 2 - DBS311
-- ***********************
SET SERVEROUTPUT ON
/
CREATE OR REPLACE PROCEDURE find_customer(c_id IN NUMBER, found OUT NUMBER) AS    
BEGIN   
    SELECT customer_id
    INTO found
    FROM customers c
    WHERE customer_id=c_id;
    --DBMS_OUTPUT.PUT_LINE ('ID: ' || found);
EXCEPTION
    WHEN NO_DATA_FOUND THEN    
    found := 0;
    --DBMS_OUTPUT.PUT_LINE ('The customer does not exist.'||found);
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE ('Error!');
END;

/
DECLARE
   found NUMBER;
BEGIN
    find_customer(44,found);
    DBMS_OUTPUT.PUT_LINE ('found: '||found);
END;
/

CREATE OR REPLACE PROCEDURE find_product (p_id IN NUMBER, price OUT products.list_price%TYPE) AS
BEGIN   
    SELECT list_price
    INTO price
    FROM products
    WHERE product_id=p_id;
    --DBMS_OUTPUT.PUT_LINE ('price: ' || price);
EXCEPTION
    WHEN NO_DATA_FOUND THEN    
    price := 0;
    --DBMS_OUTPUT.PUT_LINE ('The product does not exist.'||price);
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE ('Error!');
END;

/
DECLARE
   price NUMBER(9,2) := 0;
BEGIN
    find_product(1000,price);
    DBMS_OUTPUT.PUT_LINE ('price: '||price);
END;
/

CREATE OR REPLACE PROCEDURE add_order(c_id IN NUMBER, new_order_id OUT NUMBER) AS
    max_id orders.order_id%TYPE;
BEGIN
    SELECT MAX(order_id)
    INTO max_id
    FROM orders;
    new_order_id := max_id+1;
    INSERT INTO orders
    (order_id, customer_id, status, salesman_id, order_date)
    VALUES
    (new_order_id,c_id,'Shipped',56,SYSDATE);
EXCEPTION    
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE ('Error!');
END;

/
DECLARE
   new_order_id NUMBER := 0;
BEGIN
    add_order(44, new_order_id);    
END;
/
CREATE OR REPLACE PROCEDURE add_order_item (orderId IN order_items.order_id%type, 
                                            itemId IN order_items.item_id%type, 
                                            productId IN order_items.product_id%type, 
                                            q IN order_items.quantity%type, 
                                            price IN order_items.unit_price%type) AS
    
BEGIN
    INSERT INTO order_items
    (order_id,item_id,product_id,quantity,unit_price)
    VALUES
    (orderId,itemId,productId,q,price);
EXCEPTION    
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE ('Error!');
END;

/
BEGIN
    add_order_item(106,1,112,3,808.92);    
END;