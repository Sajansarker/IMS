Create Database SAJAN_KUMER_SARKER_IMS
USE SAJAN_KUMER_SARKER_IMS
--Name: Sajan Kumer Sarker
--ID: 2111131642
--Project Topic: Inventory Management System

-- Inventory Management System Table Create Codes: 
CREATE TABLE product (
    product_id INT NOT NULL,
    product_name VARCHAR(100),
    category VARCHAR(100),
    price NUMERIC (10, 2),
    supplier_id INT,
	CONSTRAINT product_pk PRIMARY KEY(product_id)
);
CREATE TABLE supplier (
    supplier_id INT NOT NULL,
    supplier_name VARCHAR(100),
    contact_name VARCHAR(100),
    number VARCHAR(20),
	email VARCHAR(50),
    address VARCHAR(200),
	CONSTRAINT supplier_pk PRIMARY KEY(supplier_id)
);
CREATE TABLE customer_order (
    order_id INT NOT NULL,
	name VARCHAR(100),
    order_date DATE,
    total_amount NUMERIC(10, 2),
	CONSTRAINT customer_pk PRIMARY KEY(order_id)
);
CREATE TABLE customer_order_item (
    order_item_id INT NOT NULL,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price NUMERIC(10, 2),
    CONSTRAINT c_oid_fk FOREIGN KEY (order_id) REFERENCES customer_order (order_id) 
	ON DELETE CASCADE 
	ON UPDATE CASCADE,
    CONSTRAINT c_pid_fk FOREIGN KEY (product_id) REFERENCES product (product_id) 
	ON DELETE CASCADE 
	ON UPDATE CASCADE
);
CREATE TABLE stock (
    stock_id INT NOT NULL,
    product_id INT,
    quantity INT,
	CONSTRAINT stock_pk PRIMARY KEY (stock_id),
	CONSTRAINT stock_fk FOREIGN KEY (product_id) REFERENCES Product (product_id)
	ON DELETE CASCADE 
	ON UPDATE CASCADE
);
CREATE TABLE supplier_delivered (
    order_id INT NOT NULL,
    supplier_id INT,
    deliver_date DATE,
    total_amount NUMERIC(10, 2),
	CONSTRAINT sd_pk PRIMARY KEY (order_id),
    CONSTRAINT s_id_fk FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
	ON DELETE CASCADE 
	ON UPDATE CASCADE,
	CONSTRAINT o_id_fk FOREIGN KEY (order_id) REFERENCES customer_order(order_id)
	ON DELETE CASCADE 
	ON UPDATE CASCADE
	
);
CREATE TABLE supplier_delivered_item (
    order_item_id INT NOT NULL,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price NUMERIC(10, 2),
	CONSTRAINT sorder_pk PRIMARY KEY(order_item_id),
	CONSTRAINT soid_fk FOREIGN KEY (order_id) REFERENCES supplier_delivered (order_id) 
	ON DELETE CASCADE 
	ON UPDATE CASCADE,
    CONSTRAINT spid_fk FOREIGN KEY (product_id) REFERENCES product (product_id) 
	ON DELETE CASCADE 
	ON UPDATE CASCADE
);

-- Table Data: 
INSERT INTO product VALUES
--(product id,product name,category,price,supplier id)
(2111, 'i5-10400F Processor', 'Processor', 15000, 111),
(2112, 'i7-12700 Processor', 'Processor', 30000, 222),
(3111, 'Corsair Vengence 8GB 3200MHz RAM', 'RAM', 3000, 111),
(3112, 'G-Skill Flare X5 16GB 5600MHz RAM', 'RAM', 7000, 222),
(4111, 'Asus B460-Plus Motherboard', 'Motherboard', 10000, 111),
(4112, 'MSI B660M DDR4 Motherboard', 'Motherboard', 20000, 222)
INSERT INTO stock VALUES
--(stock id,product id,quantity)
(1, 2111, 30),
(2, 3111, 40),
(3, 4111, 18),
(4, 2112, 55),
(5, 3112, 43),
(6, 4112, 20)
INSERT INTO supplier VALUES
--(supplier id,supplier name,contact name,number,email,address)
(111, 'Gamo Tech', 'MR. X', '88017', 'mrx@gmail.com', 'Mirpur-1'),
(222, 'CO Zome', 'MR. Y', '88019', 'mry@gmail.com', 'Uttara-3'),
(333, 'C Tech', 'MR.Z', '88018', 'mrz@gmail.com', 'Dhanmondi-13')
INSERT INTO customer_order VALUES
--(order id,name,order date,total ammount)
(50001, 'A Computer', '2023-03-24', 200000),
(50002, 'B Computer', '2023-05-12', 7000),
(50003, 'C Computer', '2023-04-23', 230000)
INSERT INTO customer_order_item VALUES
--(order item id,order id,product id,quantity,unit price)
(1, 50001, 2111, 10, 150000),
(2, 50001, 4111, 05, 50000),
(3, 50002, 3112, 01, 7000),
(4, 50003, 4112, 10, 200000),
(5, 50003, 3111, 10, 30000)
INSERT INTO supplier_delivered VALUES
--(order id,supplier id,deliver date,total ammount)
(50001, 111, '2023-04-01', 200000),
(50002, 222, '2023-05-20', 7000),
(50003, 333, '2023-05-01', 230000)
INSERT INTO supplier_delivered_item VALUES
--(order item id,order id,product id,quantity,unit price)
(1, 50001, 2111, 10, 150000),
(2, 50001, 4111, 05, 50000),
(3, 50002, 3112, 01, 7000),
(4, 50003, 4112, 10, 200000),
(5, 50003, 3111, 10, 30000)

-- Query Questions and Answers: 
/*
-- Query-1: Write a query that displays the supplier name, supplier contact name and the product they 
-- supplied to order id= 50001
SELECT s.supplier_name, s.contact_name, p.product_id, p.product_name
FROM supplier AS s, product AS p, supplier_delivered AS sd, supplier_delivered_item AS sdi
WHERE sd.order_id=50001 and s.supplier_id=sd.supplier_id and sd.order_id=sdi.order_id and sdi.product_id= p.product_id
-- Query-2: Retrieve the customers name and id who order product id= 4112
SELECT c.order_id, c.name
FROM customer_order AS c, product AS p, customer_order_item AS coi
WHERE p.product_id=4112 AND c.order_id= coi.order_id AND coi.product_id= p.product_id
-- Query-3: Retrieve those customers name and id and order price who ordered more than 150000TK
SELECT order_id, name, total_amount
FROM customer_order
Where total_amount > 150000
-- Query-4: Retrieve the total number of product have in the stock and total price of those product.
SELECT SUM(quantity) AS total_products_in_stock, SUM(price * quantity) AS total_price
FROM stock
JOIN product ON stock.product_id = product.product_id;
-- Query-5: Update the product id which id 4114 to 4115 and show the updated table.
UPDATE product
SET product_id = 4115
WHERE product_id = 4114;
SELECT *
FROM product
--Query-6: Retrieve the average price of products in each category.
SELECT category, AVG(price) AS average_price
FROM product
GROUP BY category;
*/