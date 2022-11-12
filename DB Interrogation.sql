/* 
            IT 300 Project: Database Interrogation
                                            Project by Mohamed Amine AFFES & Sirine AMRI

*/

--Question 8: Package 'DB_Interrogation' specification
CREATE OR REPLACE PACKAGE DB_Interrogation 

IS

--Question 1: Funstion 'restock' declaration 
FUNCTION restock(Product_ID IN VARCHAR2, amount_to_be_added IN NUMBER) RETURN NUMBER;
--Question 2: Procdure 'customer_bank_wallet' declaration 
PROCEDURE customer_bank_wallet;
--Question 4: Procedure 'stocklevel' declaration
PROCEDURE stocklevel (v_product IN PRODUCT.productID%type) ;
--Question 5: Procedure 'discount' declaration
PROCEDURE discount(x_id IN product.productID%TYPE, t_disc IN FLOAT);
--Question 6: Procedure 'rat_store' declaration
 PROCEDURE rat_store(x_id in product.productID%TYPE);
--Question 7: Procedure 'delete_prod' declaration
PROCEDURE delete_prod(x_id IN product.productID%type , breakeven_sales in number );

END DB_Interrogation;

--Question 8: Package 'DB_Interrogation' body
CREATE OR REPLACE PACKAGE BODY DB_Interrogation

IS
--Question 1: Function 'restock' creation:
FUNCTION restock(Product_ID IN VARCHAR2, amount_to_be_added IN NUMBER) RETURN NUMBER
    AS
        quantity PRODUCT.stock%TYPE;
    BEGIN
        SELECT stock 
        INTO quantity
        FROM product
        WHERE productID = Product_ID;
      
        quantity := quantity + amount_to_be_added;
       
        UPDATE product
        SET stock = quantity
        WHERE productid = Product_ID;
        COMMIT;
    RETURN quantity;
END restock;

--Question 2: Procedure 'customer_bank_wallet' creation
PROCEDURE customer_bank_wallet
IS
CURSOR C1 IS SELECT  custname , wallet.balance , bankdetails.bankname 
                FROM customer 
                JOIN wallet ON customer.custID=wallet.custID
                JOIN bankdetails ON customer.custID=bankdetails.custID 
                ORDER BY balance DESC;
               
 v_name customer.custname%TYPE;
 n_balance wallet.balance%TYPE;
 v_bankname BANKDETAILS.BANKNAME%TYPE;
 BEGIN
    OPEN C1;
    LOOP
        FETCH C1 
        INTO  V_name, n_balance, v_bankname ;
        EXIT WHEN C1%notfound;
        DBMS_OUTPUT.PUT_LINE ('Customer Name: ' || v_name|| '      Customer Bank: ' || v_bankname || '     Customer Balance: ' || n_balance);
    END LOOP;
    CLOSE C1;
END customer_bank_wallet;

--Question 4: Procedure 'stocklevel' creation
PROCEDURE stocklevel (v_product IN PRODUCT.productID%type) 
IS
    low_stock EXCEPTION;
    medium_stock EXCEPTION;
    large_stock EXCEPTION;
    v_stock PRODUCT.STOCK%type;
BEGIN
    SELECT stock 
    INTO v_stock 
    FROM product 
    WHERE v_product=productID ;
    CASE 
        WHEN v_stock < 100 THEN RAISE low_stock ;
        WHEN v_stock < 500 THEN RAISE medium_stock;
        ELSE RAISE large_stock;
    END CASE;
EXCEPTION
    WHEN low_stock THEN dbms_output.put_line('Very low stock');
    WHEN medium_stock THEN dbms_output.put_line('Medium stock');
    WHEN OTHERS THEN dbms_output.put_line('Large stock');
    
END stocklevel;

--Question 5: Procedure 'discount' creation
PROCEDURE discount(x_id IN product.productID%TYPE, t_disc IN FLOAT) 
AS
    v_price PRODUCT.productprice%TYPE;
    EXC EXCEPTION;
BEGIN
    SELECT productprice 
    INTO v_price 
    FROM product
    WHERE x_id=productID;
    DBMS_OUTPUT.PUT_LINE('The price before update for the occasion of Black friday is :  '|| v_price);
    IF t_disc>0 AND t_disc <1 THEN 
        
        UPDATE PRODUCT
        SET productprice= productprice*(1-t_disc)
        WHERE x_id=productID;
        COMMIT;
        SELECT productprice
        INTO v_price
        FROM PRODUCT
        WHERE  x_id=productID;
        DBMS_OUTPUT.PUT_LINE('The price after update for the occasion Black friday is '|| v_price);
    ELSE Raise EXC;
    END IF;
    Exception
    WHEN EXC THEN RAISE_APPLICATION_ERROR(-20001,'The discount rate you entered is invalid, please retry again');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END discount;

--Question 6: Procedure 'rat_store' creation
PROCEDURE rat_store(x_id in product.productID%TYPE)
IS 
v_pname product.productname%TYPE;
v_sname store.storename%TYPE;
n_rat store.ratings%TYPE;
BEGIN
    SELECT productname , storename, ratings
    INTO v_pname, v_sname, n_rat
    FROM product, store
    WHERE x_id=product.PRODUCTID and  product.storeID=store.storeID;
    DBMS_OUTPUT.PUT_LINE('The product name is: ' || v_pname ||'   The store name is:  '|| v_sname || '   The store rating is: ' || n_rat);
    CASE
        WHEN n_rat<2 THEN DBMS_OUTPUT.PUT_LINE('the store ratings is bad');
        WHEN n_rat>3 THEN DBMS_OUTPUT.PUT_LINE('the store ratings is good');
        ELSE DBMS_OUTPUT.PUT_LINE('the store ratings is decent');
    END CASE;
END rat_store;

--Question 7: Procedure 'delete_prod' Creation
PROCEDURE delete_prod(x_id IN product.productID%type , breakeven_sales in number )
IS
v_name product.productname%TYPE;
n_price product.productprice%TYPE;
n_quantity product.itemssold%TYPE;
exp_plus EXCEPTION;
exp_zero EXCEPTION;
BEGIN
    SELECT productname , productprice, itemssold
    INTO v_name , n_price, n_quantity 
    FROM product
    WHERE x_id=productID;
    
    IF (n_price*n_quantity) < breakeven_sales THEN
        DELETE 
        FROM product
        WHERE productid=x_id;
        COMMIT;
    ELSIF (n_price*n_quantity) > breakeven_sales THEN RAISE exp_plus;
    ELSE RAISE exp_zero;
    END IF ;
    
EXCEPTION
    WHEN exp_plus THEN DBMS_OUTPUT.PUT_LINE('the product generates a positive profit');
    WHEN exp_zero THEN DBMS_OUTPUT.PUT_LINE('the product does not generate any profit, neither loss');
END delete_prod;

END DB_Interrogation;

--Remark: A trigger cannot be created inside a package 
--Question 3: Trigger 'remove_cust' creation
CREATE OR REPLACE TRIGGER remove_cust
BEFORE DELETE ON CUSTOMER
FOR EACH ROW
BEGIN
    DELETE FROM wallet WHERE wallet.custID = :OLD.custid;
    DELETE FROM bankdetails WHERE bankdetails.custID = :OLD.custid;
END ;

--ALL Functions and procedures' calls:

-- Question 1: Function 'restock' call
ACCEPT Product_ID prompt "Please enter the product identifier, use the following format: 'PDxxxx' "
ACCEPT amount_to_be_added prompt 'Please insert the quantity to be added of the specified product to its available stock  '  

VARIABLE New_stock NUMBER; 
EXECUTE :New_stock := DB_Interrogation.restock(&Product_ID, &amount_to_be_added);
PRINT New_stock;

--To check use:
SELECT * FROM PRODUCT;

--Question 2: Procedure 'customer_bank_wallet' call
EXECUTE DB_Interrogation.customer_bank_wallet;

--Question 4: Procedure 'stocklevel' call
ACCEPT Product_ID PROMPT "Please enter the product identifier you want to see the stock for, use the following format: 'PDxxxx' "
EXECUTE DB_Interrogation.stocklevel(&Product_ID);

--Question 5: Procedure 'discount' call:
ACCEPT Product_ID PROMPT "Please enter the product identifier you want to update its price, use the following format: 'PDxxxx' "
ACCEPT discount_rate PROMPT'Please enter the discount rate, the discount rate must be between 0 an 1. Example: for 20% enter 0.2'
EXECUTE DB_Interrogation.discount(&Product_ID,&discount_rate);

--Question 6: Procedure 'rat_store' call
ACCEPT Product_ID PROMPT "Please enter the product identifier you want to see its store's name and rating, use the following format: 'PDxxxx' "
EXECUTE DB_Interrogation.rat_store(&Product_ID);

--Question 7: Procedure 'delete_prod' call:
ACCEPT Product_ID PROMPT "Please enter the product identifier you want to check its sales, use the following format: 'PDxxxx' "
ACCEPT breakeven_sales PROMPT 'Please enter the breakeven sales for the specified product'
EXECUTE DB_Interrogation.delete_prod(&Product_ID, &breakeven_sales);