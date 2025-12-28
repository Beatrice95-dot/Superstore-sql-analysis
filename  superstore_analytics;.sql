-- Active: 1757782256378@@127.0.0.1@3306@superstore_analytics
USE superstore_analytics;

-- Create table to contaiin all data in the dataset.

 DROP TABLE IF EXISTS superstore_orders;

CREATE TABLE superstore_orders(
    `Row ID`      INT,
    `Order ID`    VARCHAR(50),
    `Order Date`  VARCHAR(20),
    `Ship Date`   VARCHAR(20),
    `Ship Mode`   VARCHAR(100),
    `Customer ID` VARCHAR(50),
    `Customer Name` VARCHAR(255),
    `Segment`     VARCHAR(50),
    `Country`     VARCHAR(100),
    `City`        VARCHAR(100),
    `State`       VARCHAR(100),
    `Postal Code` VARCHAR(20),
    `Region`      VARCHAR(50),
    `Product ID`  VARCHAR(50),
    `Category`    VARCHAR(100),
    `Sub-Category` VARCHAR(100),
    `Product Name` VARCHAR(255),
    `Sales`       DECIMAL(10,2),
    `Quantity`    INT,
    `Discount`    DECIMAL(5,2),
    `Profit`      DECIMAL(10,2)
);

-- Ii always read this code in the terminal before it uploads. 

LOAD DATA LOCAL INFILE '/Users/beatricenyarko/Downloads/Sample - Superstore.csv'
INTO TABLE superstore_orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
-- grouping them into four relational tables. Customers, orders, products and order item.


-- i have this code here so that i can re reun my codes and not get a table exist error
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
SET FOREIGN_KEY_CHECKS = 1;


CREATE TABLE customers (
    customer_id   VARCHAR(50) NOT NULL PRIMARY KEY,
    customer_name VARCHAR(255),
    segment       VARCHAR(50),
    city          VARCHAR(100),
    state         VARCHAR(100),
    postal_code   VARCHAR(20),
    country       VARCHAR(100),
    region        VARCHAR(50)
);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id    VARCHAR(50) NOT NULL PRIMARY KEY,
    order_date  DATE,
    ship_date   DATE,
    ship_mode   VARCHAR(100),
    customer_id VARCHAR(50) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


CREATE TABLE products (
    product_id   VARCHAR(50) NOT NULL PRIMARY KEY,
    product_name VARCHAR(255),
    category     VARCHAR(100),
    subcategory  VARCHAR(100)
);


CREATE TABLE order_items (
    row_id     INT NOT NULL PRIMARY KEY,
    order_id   VARCHAR(50) NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    sales      DECIMAL(10,2),
    quantity   INT,
    discount   DECIMAL(5,2),
    profit     DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

SHOW TABLES;
-- Populating the tables


INSERT IGNORE INTO customers (
    customer_id, customer_name, segment,
    city, state, postal_code, country, region
)
SELECT DISTINCT
    `Customer ID`,
    `Customer Name`,
    `Segment`,
    `City`,
    `State`,
    `Postal Code`,
    `Country`,
    `Region`
FROM superstore_orders;

-- fill orders

INSERT IGNORE INTO orders (
    order_id, order_date, ship_date, ship_mode, customer_id
)
SELECT DISTINCT
    `Order ID`,
    STR_TO_DATE(`Order Date`, '%m/%d/%Y'),
    STR_TO_DATE(`Ship Date`, '%m/%d/%Y'),
    `Ship Mode`,
    `Customer ID`
FROM superstore_orders;


-- fill products

INSERT IGNORE INTO products (
    product_id, product_name, category, subcategory
)
SELECT
    `Product ID` AS product_id,
    MAX(`Product Name`) AS product_name,
    MAX(`Category`) AS category,
    MAX(`Sub-Category`) AS subcategory
FROM superstore_orders
GROUP BY `Product ID`;

-- fill order_items

INSERT IGNORE INTO order_items (
    row_id, order_id, product_id, sales, quantity, discount, profit
)
SELECT
    `Row ID`,
    `Order ID`,
    `Product ID`,
    `Sales`,
    `Quantity`,
    `Discount`,
    `Profit`
FROM superstore_orders;

SELECT * FROM superstore_orders LIMIT 10;

SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM order_items;
SELECT COUNT(*) FROM products;

SELECT * FROM customers LIMIT 10;

