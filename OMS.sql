CREATE DATABASE Order_Management_Sys_DB;

USE Order_Management_Sys_DB;

-- Creation of Tables

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2),
    stock_quantity INT
);


CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    amount DECIMAL(10,2),
    payment_method VARCHAR(50),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Verify Table was created properly
show tables;

-- Insert of Data
INSERT INTO customers (first_name, last_name, email) VALUES
('Josh', 'Ox', 'josh.ox@email.com'),
('Sarah', 'Miller', 'sarah.miller@email.com'),
('David', 'Johnson', 'david.johnson@email.com'),
('Emily', 'Brown', 'emily.brown@email.com'),
('Michael', 'Lee', 'michael.lee@email.com');

INSERT INTO products (product_name, price, stock_quantity) VALUES
('Wireless Mouse', 29.99, 100),
('Mechanical Keyboard', 89.99, 50),
('USB-C Hub', 49.99, 75),
('27-inch Monitor', 249.99, 30),
('Laptop Stand', 39.99, 60);

INSERT INTO orders (customer_id, status) VALUES
(1, 'COMPLETED'),
(2, 'COMPLETED'),
(3, 'PENDING'),
(1, 'CANCELLED'),
(4, 'COMPLETED');

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2),   -- 2 Wireless Mice
(1, 2, 1),   -- 1 Keyboard
(2, 3, 2),   -- 2 USB-C Hubs
(3, 5, 1),   -- 1 Laptop Stand
(5, 4, 1);   -- 1 Monitor

INSERT INTO payments (order_id, amount, payment_method) VALUES
(1, 149.97, 'Credit Card'),
(2, 99.98, 'PayPal'),
(5, 249.99, 'Credit Card');

-- Creation of Indexes

CREATE INDEX idx_orders_customer 
ON orders(customer_id);

CREATE INDEX idx_order_items_order
ON order_items(order_id);


-- Views

-- Reporting View

CREATE VIEW order_summary AS
SELECT
	o.order_id,
    c.first_name,
    c.last_name,
    SUM(oi.quantity*price) AS total_amount,
    o.status,
    o.order_date
FROM orders o
JOIN customers c 
	ON o.customer_id = c.customer_id
JOIN order_items oi
	ON o.order_id = oi.order_id
JOIN products p
	ON oi.product_id = p.product_id
GROUP BY o.order_id;


-- Store Procedure for Business Logic

DELIMITER $$
	
    CREATE PROCEDURE get_customer_orders(IN cust_id INT)
    BEGIN
		SELECT *
        FROM order_summary
        WHERE customer_id = cust_id;
    END $$
	
DELIMITER ;


-- Creation of Trigger for Audit Logging

CREATE TABLE audit_log(
	log_id INT AUTO_INCREMENT PRIMARY KEY,
    table_name  VARCHAR(50),
    action_type VARCHAR(10),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TRIGGER after_order_insert
AFTER INSERT ON orders
FOR EACH ROW
INSERT INTO audit_log(table_name, action_type)
VALUES
	('orders', 'INSERT')
;


-- Queries for some analysis

-- Top customers by spending
SELECT
	first_name,
    last_name,
    SUM(total_amount) AS total_spent
FROM order_summary
GROUP BY first_name, last_name
ORDER BY total_spent DESC;


-- Daily Revenue
SELECT
	DATE(order_date),
    SUM(total_amount)
FROM order_summary
GROUP BY DATE(order_date)
;


