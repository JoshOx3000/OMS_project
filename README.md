# OMS_project
The Order Management System is a relational database project built using MySQL to simulate a real-world e-commerce order workflow.

It demonstrates database design, data integrity, indexing, performance optimization, views, stored procedures, and triggers.

This project is designed to showcase core database engineering and SQL development skills.


🛠 Technologies Used

MySQL 8.x

SQL (DDL, DML, DCL concepts)

InnoDB storage engine



🧩 Key Features

- Normalized relational schema

- Foreign key constraints for data integrity

- Indexes for query performance

- Reporting views

- Stored procedures for business logic

- Triggers for audit logging

- Analytical queries for insights



🗂 Database Schema
Tables

customers – Stores customer information

products – Stores product catalog and inventory

orders – Tracks customer orders

order_items – Line-item details per order

payments – Payment records per order

audit_log – Tracks insert activity on orders


📈 Indexing & Performance

Indexes were added to optimize frequent joins and lookup queries:

CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_order_items_order ON order_items(order_id);


These indexes reduce full table scans and improve query execution time.

👁 Reporting View
order_summary View

Provides an aggregated view of customer orders:

SELECT
    o.order_id,
    c.first_name,
    c.last_name,
    SUM(oi.quantity * p.price) AS total_amount,
    o.status,
    o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY o.order_id;

⚙ Stored Procedure
get_customer_orders

Returns all orders for a specific customer.

CALL get_customer_orders(1);


Used to encapsulate business logic and promote reusability.

🔔 Trigger & Audit Logging

A trigger captures insert activity on the orders table and logs it to audit_log.

AFTER INSERT ON orders → audit_log


This simulates production audit tracking.

📊 Sample Analytical Queries
Top Customers by Spending
SELECT
    first_name,
    last_name,
    SUM(total_amount) AS total_spent
FROM order_summary
GROUP BY first_name, last_name
ORDER BY total_spent DESC;

Daily Revenue
SELECT
    DATE(order_date),
    SUM(total_amount)
FROM order_summary
GROUP BY DATE(order_date);



🚀 Future Enhancements

- Inventory deduction triggers

- Refunds & chargebacks table

- Transaction handling with SAVEPOINTs

- ETL pipeline integration

- Cloud deployment (Azure / AWS RDS)








