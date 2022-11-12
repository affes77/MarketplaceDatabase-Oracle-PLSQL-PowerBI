/* 
            IT 300 Project: Database
                                            Project by Mohamed Amine AFFES & Sirine AMRI

*/

--To drop any user database having the same name as Project and all objects in the user's schema 
DROP USER Project CASCADE ;

--To drop any table having the same name as ours if exist
DROP TABLE CUSTOMER;
DROP TABLE WALLET;
DROP TABLE BANKDETAILS;
DROP TABLE STORE;
DROP TABLE PRODUCT;
DROP TABLE ORDERS;

--To create the user of the database
CREATE USER Project IDENTIFIED BY Project;
GRANT ALL PRIVILEGES TO Project;

--To connect the user to the database
CONNECT Project/Project;

--To create the database

--Creation of the table CUSTOMER:
CREATE TABLE CUSTOMER(
    custID NUMBER(4),
    custName VARCHAR2(100) NOT NULL,
    custPhone VARCHAR2(15) UNIQUE,
    custUsername VARCHAR2(50)UNIQUE,
    custPassword VARCHAR2(50) NOT NULL,
    custEmail VARCHAR2(50) UNIQUE,
    custPhoto VARCHAR2(50),
    custDOB DATE NOT NULL,
    custGender VARCHAR2(10),
    CONSTRAINT PK_custID PRIMARY KEY(custID)
);

INSERT INTO CUSTOMER VALUES(1001, 'Iman BEN DKHIL', '23 216 234', 'Iman28', 'amouna2000','iman@gmail.com','Iman.jpeg','28-10-2000','Female');
INSERT INTO CUSTOMER VALUES(1002, 'Zouhair MRAD', '92 542 140', 'Zouhairl02', 'zahrouch23','zouhair.m@gmail.com','zouhair.jpeg','23-07-2001','Male');
INSERT INTO CUSTOMER VALUES(1003, 'Ahlem DHIEF', '24 241 987', 'Ahlem4', 'halouma2002','dhief.ahlem@gmail.com','ahlem.jpeg','4-03-2002','Female');
INSERT INTO CUSTOMER VALUES(1004, 'Salem SLIMI', '26 087 567', 'Ssalem', 'salem672','salem12@gmail.com','salem.jpeg','12-05-2003','Male');
INSERT INTO CUSTOMER VALUES(1005, 'Anwer MEJRI', '21 546 769', 'Anwer_M', 'mnawer23','Anwer2000@gmail.com','anwer.jpeg','23-06-2000','Male');
INSERT INTO CUSTOMER VALUES(1006, 'Khdija BEJAOUI', '22 561 222', 'Khadouja', 'khadoujabb','Khdija23@gmail.com','khdija.jpeg','13-09-1997','Female');
INSERT INTO CUSTOMER VALUES(1007, 'Kawther AMRI', '24 261 129', 'Kouka', 'kawthoura','amri.kawt@gmail.com','kawther.jpeg','01-11-1999','Female');
INSERT INTO CUSTOMER VALUES(1008, 'Houssem BEJI', '41 221 404', 'Houssi', 'moumou6','houssem.beji@gmail.com','houssem.jpeg','16-04-1996','Male');
INSERT INTO CUSTOMER VALUES(1009, 'Walid BEN AMEUR', '22 645 999', 'Walid01', 'woulda1223','walid.BA@gmail.com','walid.jpeg','10-02-2000','Male');

--Creation of table WALLET
CREATE TABLE WALLET(
    walletID VARCHAR2(10),
    balance NUMBER(10,2),
    custID NUMBER(4),
    CONSTRAINT PK_walletID PRIMARY KEY(walletID),
    CONSTRAINT FK_custID FOREIGN KEY(custID) REFERENCES CUSTOMER(custID) 
);

INSERT INTO WALLET VALUES('CW1001', 50.00, 1001);
INSERT INTO WALLET VALUES('CW1002', 190.99, 1002);
INSERT INTO WALLET VALUES('CW1003', 200.30, 1003);
INSERT INTO WALLET VALUES('CW1004', 78.00, 1004);
INSERT INTO WALLET VALUES('CW1005', 90.00, 1005);
INSERT INTO WALLET VALUES('CW1006', 45.00, 1006);
INSERT INTO WALLET VALUES('CW1007', 120.00, 1007);
INSERT INTO WALLET VALUES('CW1008', 300.00, 1008);
INSERT INTO WALLET VALUES('CW1009', 33.00, 1009);

--Creation of table BANKDETAILS
CREATE TABLE BANKDETAILS(
    bankNo VARCHAR2(30),
    bankName VARCHAR2(25) NOT NULL,
    custID NUMBER(4),
    CONSTRAINT PK_bankNo PRIMARY KEY(bankNo),
    CONSTRAINT FK3_custID FOREIGN KEY(custID) REFERENCES CUSTOMER(custID)
);

INSERT INTO BANKDETAILS VALUES('1000200030004000', 'BH', 1001);
INSERT INTO BANKDETAILS VALUES('1234567890213456', 'Banque de Tunisie', 1002);
INSERT INTO BANKDETAILS VALUES('3425777789029999', 'Zaytouna', 1003);
INSERT INTO BANKDETAILS VALUES('4444123456789999', 'BNA', 1004);
INSERT INTO BANKDETAILS VALUES('2323444465781111', 'UIB', 1005);
INSERT INTO BANKDETAILS VALUES('5623098176431900', 'UBCI', 1006);
INSERT INTO BANKDETAILS VALUES('7409902849850900', 'UBCI', 1007);
INSERT INTO BANKDETAILS VALUES('8208462324378900', 'UBCI', 1008);
INSERT INTO BANKDETAILS VALUES('2374380079884111', 'UIB', 1009);


--Creation of Table STORE
CREATE TABLE STORE(
    storeID VARCHAR2(10),
    storeName VARCHAR2(30) NOT NULL,
    storePhone VARCHAR2(15) NOT NULL,
    ratings NUMBER(3,2),
    storeAddress VARCHAR2(200) NOT NULL,
    CONSTRAINT PK_storeID PRIMARY KEY(storeID)
);

INSERT INTO STORE VALUES('ST1001', 'Mme Hchicha', '0187694657', 5, '9 Novembre Street, Bizerte, Bizerte');
INSERT INTO STORE VALUES('ST1002', 'Florist Zayd', '0125634526', 2, 'Algeria Street, Denden, Manouba');
INSERT INTO STORE VALUES('ST1003', 'Les Services de Plombrie', '0176453689', 3, 'Zouhour Street, Ghazella, Ariana');
INSERT INTO STORE VALUES('ST1004', 'Chaabani Accessoires', '0187457390', 4, 'Sousse Street, Le Bardo, Tunis');
INSERT INTO STORE VALUES('ST1005', 'Gaaloul et cie', '0143526891', 5, 'Mouselini Street, El Mourouj, Ben Arous');
INSERT INTO STORE VALUES('ST1006', 'Candy Shop', '1123789890', 4, 'Bourguiba Street, Menzel Bourguiba, Bizerte');

--Creation of table PRODUCT
CREATE TABLE PRODUCT(
    productID VARCHAR2(10),
    productName VARCHAR2(30) NOT NULL,
    stock NUMBER(4),
    itemsSold NUMBER(4),
    productPrice NUMBER(10,2) NOT NULL,
    warranty VARCHAR2(30),
    storeID VARCHAR(10),
    CONSTRAINT PK_productID PRIMARY KEY(productID),
    CONSTRAINT FK2_storeID FOREIGN KEY(storeID) REFERENCES STORE(storeID)
);

INSERT INTO PRODUCT VALUES('PD1001', 'Baklawa',100, 150, 40,'No warranty', 'ST1001');
INSERT INTO PRODUCT VALUES('PD1002', 'Fleur Rouge',10, 100, 5, 'No warranty', 'ST1002');
INSERT INTO PRODUCT VALUES('PD1003', 'Entretien des chauffages',10, 20, 45, 'No warranty', 'ST1003');
INSERT INTO PRODUCT VALUES('PD1004', 'Collier',5, 50, 30, '3 months', 'ST1004');
INSERT INTO PRODUCT VALUES('PD1005', 'Fromage Mozerella',20, 100, 11, 'No warranty', 'ST1005');
INSERT INTO PRODUCT VALUES('PD1006', 'Ghrayba',100, 150, 10, 'No warranty', 'ST1001');
INSERT INTO PRODUCT VALUES('PD1007', 'Chocolat Frero Roché',90, 160, 23, 'No warranty', 'ST1006');
INSERT INTO PRODUCT VALUES('PD1008', 'Kaak Warka',80, 170, 35, 'No warranty', 'ST1001');
INSERT INTO PRODUCT VALUES('PD1009', 'Maestro Passion',200, 250, 09, 'No warranty', 'ST1006');


--Creation of table ORDERS
CREATE TABLE ORDERS(
    orderID VARCHAR2(10),
    orderDate DATE NOT NULL,
    orderTime VARCHAR2(5) NOT NULL,
    totalPrice NUMBER(10,2) NOT NULL,
    custID NUMBER(4),
    CONSTRAINT PK_orderID PRIMARY KEY(orderID),
    CONSTRAINT FK4_custID FOREIGN KEY(custID) REFERENCES CUSTOMER(custID)
);

INSERT INTO ORDERS VALUES('OR1001', '8-10-2021', '14:05', 35.00, 1001);
INSERT INTO ORDERS VALUES('OR1002', '9-10-2021', '13:09', 80.00, 1002);
INSERT INTO ORDERS VALUES('OR1003', '10-10-2021', '23:57', 45.00, 1003);
INSERT INTO ORDERS VALUES('OR1004', '8-11-2021', '00:40', 70.00, 1004);
INSERT INTO ORDERS VALUES('OR1005', '12-11-2021', '13:20', 35.00, 1005);
INSERT INTO ORDERS VALUES('OR1006', '13-05-2021', '12:20', 75.00, 1006);
INSERT INTO ORDERS VALUES('OR1007', '02-07-2021', '14:10', 100.00, 1007);
INSERT INTO ORDERS VALUES('OR1008', '04-04-2021', '15:09', 120.00, 1008);
INSERT INTO ORDERS VALUES('OR1009', '21-01-2021', '09:30', 85.00, 1009);
INSERT INTO ORDERS VALUES('OR1010', '16-03-2021', '16:35', 60.00, 1003);
COMMIT;

SELECT * FROM CUSTOMER;
SELECT * FROM WALLET;
SELECT * FROM BANKDETAILS;
SELECT * FROM PRODUCT;
SELECT * FROM STORE;