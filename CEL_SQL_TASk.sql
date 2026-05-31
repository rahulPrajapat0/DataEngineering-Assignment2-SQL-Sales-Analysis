CREATE DATABASE ecommerce_sales;
USE ecommerce_sales;
-- ===== cusomers_table ======
CREATE TABLE customers ( 
    customer_id   INT           PRIMARY KEY, 
    first_name    VARCHAR(50)   NOT NULL, 
    last_name     VARCHAR(50)   NOT NULL, 
    email         VARCHAR(100)  UNIQUE NOT NULL, 
    city          VARCHAR(50)   NOT NULL, 
    state         VARCHAR(50)   NOT NULL, 
    join_date     DATE          NOT NULL, 
    is_premium    BOOLEAN       DEFAULT FALSE 
); 
 
-- Index for filtering by city/state 
CREATE INDEX idx_customers_city ON customers(city); 
CREATE INDEX idx_customers_state ON customers(state); 

-- ====== products_table ======
CREATE TABLE products ( 
    product_id    INT           PRIMARY KEY, 
    product_name  VARCHAR(100)  NOT NULL, 
    category      VARCHAR(50)   NOT NULL, 
    brand         VARCHAR(50)   NOT NULL, 
    unit_price    DECIMAL(10,2) NOT NULL  CHECK (unit_price > 0), 
    stock_qty     INT           NOT NULL  DEFAULT 0  CHECK (stock_qty >= 0) 
); 
 
-- Index for filtering by category 
CREATE INDEX idx_products_category ON products(category); 

-- ====== orders_table ====== 
CREATE TABLE orders ( 
    order_id      INT           PRIMARY KEY, 
    customer_id   INT           NOT NULL, 
    order_date    DATE          NOT NULL, 
    status        VARCHAR(20)   NOT NULL  DEFAULT 'Pending' 
                  CHECK (status IN ('Pending','Shipped','Delivered','Cancelled')), 
    total_amount  DECIMAL(12,2) NOT NULL  CHECK (total_amount >= 0), 
     
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) 
); 
 
-- Index for date-based filtering and sorting 
CREATE INDEX idx_orders_date ON orders(order_date); 
CREATE INDEX idx_orders_status ON orders(status); 

-- ===== order_items =====
CREATE TABLE order_items ( 
    item_id       INT           PRIMARY KEY, 
    order_id      INT           NOT NULL, 
    product_id    INT           NOT NULL, 
    quantity      INT           NOT NULL  CHECK (quantity > 0), 
    unit_price    DECIMAL(10,2) NOT NULL  CHECK (unit_price > 0), 
    discount_pct  DECIMAL(5,2)  DEFAULT 0 CHECK (discount_pct BETWEEN 0 AND 100), 
     
    FOREIGN KEY (order_id)   REFERENCES orders(order_id), 
    FOREIGN KEY (product_id) REFERENCES products(product_id) 
); 

-- ========== INSERT: customers ========== 
INSERT INTO customers VALUES 
(101, 'Aarav',  'Sharma', 'aarav.s@email.com',  'Mumbai',    'Maharashtra', '2024-01-15', TRUE), 
(102, 'Priya',  'Patel',  'priya.p@email.com',  'Ahmedabad', 'Gujarat',     '2024-02-20', FALSE), 
(103, 'Rohan',  'Gupta',  'rohan.g@email.com',  'Delhi',     'Delhi',       '2024-03-10', TRUE), 
(104, 'Sneha',  'Reddy',  'sneha.r@email.com',  'Hyderabad', 'Telangana',   '2024-04-05', FALSE), 
(105, 'Vikram', 'Singh',  'vikram.s@email.com', 'Jaipur',    'Rajasthan',   '2024-05-12', TRUE), 
(106, 'Ananya', 'Iyer',   'ananya.i@email.com', 'Chennai',   'Tamil Nadu',  '2024-06-18', FALSE), 
(107, 'Karan',  'Mehta',  'karan.m@email.com',  'Pune',      'Maharashtra', '2024-07-22', TRUE), 
(108, 'Divya',  'Nair',   'divya.n@email.com',  'Kochi',     'Kerala',      '2024-08-30', FALSE);

-- ========== INSERT: products ========== 
INSERT INTO products VALUES 
(201, 'Wireless Earbuds',     'Electronics', 'BoAt',          1499.00, 250), 
(202, 'Cotton T-Shirt',       'Clothing',    'Levis',         799.00,  500), 
(203, 'Smart Watch',          'Electronics', 'Noise',         2999.00, 150), 
(204, 'Running Shoes',        'Clothing',    'Nike',          4599.00, 120), 
(205, 'Bluetooth Speaker',    'Electronics', 'JBL',           3499.00, 200), 
(206, 'Bedsheet Set',         'Home',        'Spaces',        1299.00, 300), 
(207, 'Laptop Stand',         'Electronics', 'AmazonBasics',  899.00,  180), 
(208, 'Cushion Covers (Set)', 'Home',        'HomeCenter',    599.00,  400); 

-- ========== INSERT: orders ========== 
INSERT INTO orders VALUES 
(1001, 101, '2024-08-01', 'Delivered',  4498.00), 
(1002, 102, '2024-08-03', 'Delivered',  799.00), 
(1003, 103, '2024-08-05', 'Shipped',    7498.00), 
(1004, 101, '2024-08-10', 'Delivered',  3499.00), 
(1005, 104, '2024-08-12', 'Cancelled',  2999.00), 
(1006, 105, '2024-08-15', 'Delivered',  5898.00), 
(1007, 106, '2024-08-18', 'Pending',    1299.00), 
(1008, 103, '2024-08-20', 'Delivered',  899.00), 
(1009, 107, '2024-08-25', 'Shipped',    6098.00), 
(1010, 108, '2024-08-28', 'Delivered',  1598.00); 

-- ========== INSERT: order_items ========== 
INSERT INTO order_items VALUES 
(5001, 1001, 201, 2, 1499.00, 0), 
(5002, 1001, 207, 1, 899.00,  10), 
(5003, 1002, 202, 1, 799.00,  0), 
(5004, 1003, 203, 1, 2999.00, 0), 
(5005, 1003, 204, 1, 4599.00, 5), 
(5006, 1004, 205, 1, 3499.00, 0), 
(5007, 1005, 203, 1, 2999.00, 0), 
(5008, 1006, 201, 1, 1499.00, 10), 
(5009, 1006, 204, 1, 4599.00, 5), 
(5010, 1007, 206, 1, 1299.00, 0), 
(5011, 1008, 207, 1, 899.00,  0), 
(5012, 1009, 205, 1, 3499.00, 0), 
(5013, 1009, 208, 2, 599.00,  15), 
(5014, 1010, 206, 1, 1299.00, 0), 
(5015, 1010, 208, 1, 599.00,  0); 

-- ==== Section A — SQL Basics (SELECT, Constraints, Primary Keys) ====
-- Q.1 Write a query to display all columns and rows from the customer's table.
SELECT * FROM customers;
-- Q.2 Retrieve only the first_name, last_name, and city of all customers.
SELECT first_name,last_name,city
FROM customers;
-- Q.3  List all unique categories available in the products table.
SELECT DISTINCT category
FROM products;
-- Q.4  Identify the Primary Key of each table in the schema. Explain why a Primary Key must be unique and NOT NULL.
/*
Each table's Primary Key: customers → customer_id, products → product_id, orders → order_id, order_items → item_id.
A Primary Key must be UNIQUE so that every row can be individually identified without ambiguity. 
It must be NOT NULL because a null value means "unknown" — an identifier that is unknown cannot be used to reference or link records across tables. 
Together, these two constraints ensure data integrity and reliable relationships between tables.
*/
-- Q.5 What constraints are applied to the email column in the customers table? What would happen if you tried to insert a duplicate email?
/*
The email column in the customers table has two constraints: UNIQUE and NOT NULL.
UNIQUE ensures no two customers can share the same email address. If a duplicate email is inserted, the database throws ERROR 1062: Duplicate entry and rejects the row.
NOT NULL ensures the email field cannot be left empty. Inserting a NULL value throws ERROR 1048: Column 'email' cannot be null.
Together, these constraints guarantee that every customer has a valid, one-of-a-kind email address — protecting data integrity and preventing duplicate accounts.
*/
-- Q.6  Try inserting a product with unit_price = -50. What happens and which constraint prevents it? Write both the INSERT statement and explain the error.
INSERT INTO products VALUES (209, 'Test', 'Electronics', 'Brand', -50, 10);
-- Error: Check constraint 'unit_price > 0' is violated.

-- ==== Section B — Filtering & Optimization (WHERE, Indexes) ====
-- Q.7  Retrieve all orders with status = 'Delivered'.
SELECT * FROM orders
WHERE status='Delivered';
-- Q.8 Find all products in the 'Electronics' category with a unit_price greater than ₹2000. 
SELECT * FROM products
WHERE category='Electronics' AND unit_price>2000;
-- Q.9  List all customers who joined in the year 2024 and belong to the state 'Maharashtra'.
SELECT * FROM customers
WHERE state='Maharashtra' AND YEAR(join_date)=2024;
-- Q.10 Find all orders placed between '2024-08-10' and '2024-08-25' (inclusive) that are NOT cancelled.
SELECT * FROM orders
WHERE order_date
BETWEEN '2024-08-10' AND '2024-08-25'
AND status<>'Cancelled';
-- Q.11  Explain what the index idx_orders_date does. 
-- How would it improve the performance of a query that filters orders by order_date? Write a sample query that would benefit from this index.
/*
idx_orders_date is an index created on the order_date column of the orders table. 
Without an index, the database performs a full table scan — checking every row one by one. 
With this index, the database maintains a sorted structure of dates and can jump directly to matching rows, similar to a book's index page.
Sample query that benefits from this index:
SELECT * FROM orders WHERE order_date = '2024-08-15';
This query runs significantly faster with idx_orders_date because the database uses the sorted index to locate matching rows instantly instead of scanning the entire table.
Note: The index is bypassed when functions like MONTH() or YEAR() wrap the column. Always use direct date comparisons or ranges to keep queries index-friendly (SARGable).
*/
-- Q.12 If you run: SELECT * FROM customers WHERE YEAR(join_date) = 2024; — would the index on join_date be used? Explain why or why not, and rewrite the query to be index-friendly (SARGable).
-- Non-SARGable (index NOT used):
SELECT * FROM customers WHERE YEAR(join_date) = 2024;

-- SARGable (index IS used):
SELECT * FROM customers 
WHERE join_date >= '2024-01-01' AND join_date < '2025-01-01';

-- ==== Section C — Aggregation (GROUP BY, SUM, COUNT, AVG, MIN, MAX) ====
-- Q.13 Count the total number of orders in the orders table.
SELECT COUNT(*) AS total_orders
-- Q.14 Find the total revenue (SUM of total_amount) from all 'Delivered' orders.
SELECT SUM(total_amount) AS revenue
FROM orders
WHERE status='Delivered';
-- Q.15  Calculate the average unit_price of products in each category.
SELECT category,
AVG(unit_price) AS avg_price
FROM products
GROUP BY category;
-- Q.16  For each order status, find the count of orders and the total revenue. Sort the result by total revenue in descending order.
SELECT status,
COUNT(*) AS total_orders,
SUM(total_amount) AS revenue
FROM orders
GROUP BY status
ORDER BY revenue DESC;
-- Q.17 Find the most expensive (MAX) and cheapest (MIN) product in each category.
SELECT category,
MAX(unit_price) AS max_price,
MIN(unit_price) AS min_price
FROM products
GROUP BY category;
-- Q.18 List all product categories where the average unit_price is greater than ₹2000. (Hint: Use HAVING clause) 
SELECT category, AVG(unit_price)
FROM products
GROUP BY category
HAVING AVG(unit_price)>2000;

-- ==== Section D — Joins & Relationships ====
-- Q.19  Write an INNER JOIN query to display each order along with the customer's first_name and last_name. Show: order_id, order_date, first_name, last_name, total_amount.
SELECT o.order_id,
o.order_date,
c.first_name,
c.last_name,
o.total_amount

FROM orders o
INNER JOIN customers c
ON o.customer_id=
c.customer_id;
-- Q.20 Using a LEFT JOIN, list ALL customers and their orders (if any). Customers with no orders should still appear with NULL values for order columns.
SELECT c.customer_id,
c.first_name,
o.order_id

FROM customers c
LEFT JOIN orders o
ON c.customer_id=
o.customer_id;
-- Q.21 Write a query using JOINs across three tables (orders → order_items → products) to show: order_id, product_name, quantity, unit_price, and discount_pct for each order item. 
SELECT o.order_id,
p.product_name,
oi.quantity,
oi.unit_price,
oi.discount_pct

FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id

JOIN products p
ON oi.product_id=
p.product_id;

-- Q.22 Explain the difference between LEFT JOIN and RIGHT JOIN with an example from this schema. When would you use a FULL OUTER JOIN?
/* 
LEFT JOIN returns all rows from the left (first) table, and only the matching rows from the right table. If there is no match, NULL is returned for the right table columns.
Example from ShopEase schema:
 Show all customers, even if they have no orders
SELECT c.customer_id, c.first_name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;
If a customer has placed no orders, their row still appears in the result — the order_id column will show NULL.

RIGHT JOIN returns all rows from the right (second) table, and only the matching rows from the left table. If there is no match, NULL is returned for the left table columns.
Example:
 Show all orders, even if the customer record is missing
SELECT c.customer_id, c.first_name, o.order_id
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;
In practice, a RIGHT JOIN can always be rewritten as a LEFT JOIN by simply swapping the table order. This is why RIGHT JOIN is rarely used in real projects.

When to use FULL OUTER JOIN?
FULL OUTER JOIN is used when you need all rows from both tables, regardless of whether a match exists. Unmatched rows from both sides appear in the result with NULL values on the missing side.
Example scenario: In ShopEase, if we want to find customers who have never placed an order AND orders that have no associated customer record — both at the same time:
sqlSELECT c.customer_id, c.first_name, o.order_id
FROM customers c
FULL OUTER JOIN orders o ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL OR o.order_id IS NULL;
Important Note: MySQL does not support FULL OUTER JOIN directly. The same result can be achieved using LEFT JOIN combined with UNION of RIGHT JOIN:
sqlSELECT c.customer_id, c.first_name, o.order_id
FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id
UNION
SELECT c.customer_id, c.first_name, o.order_id
FROM customers c RIGHT JOIN orders o ON c.customer_id = o.customer_id;
*/

-- Q.23  Identify all Foreign Key relationships in the schema. 
-- Explain what would happen if you tried to insert an order with customer_id = 999 (which doesn't exist in customers).
/*
Foreign Key Relationships in ShopEase schema:
Foreign KeyIn TableReferencescustomer_idorderscustomers(customer_id)order_idorder_itemsorders(order_id)product_idorder_itemsproducts(product_id)
These relationships enforce Referential Integrity — meaning a child table cannot contain a value that does not exist in the parent table.

What happens when we try to insert an order with customer_id = 999?
sqlINSERT INTO orders VALUES
(1011, 999, '2024-09-01', 'Pending', 2500.00);
Since customer_id = 999 does not exist in the customers table, the database immediately throws the following error:
ERROR 1452 (23000): Cannot add or update a child row:
a foreign key constraint fails
(`shopease`.`orders`, CONSTRAINT `orders_ibfk_1`
FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`))
The row is not inserted — the database automatically blocks the operation.

Why does the database block this?
The purpose of a Foreign Key constraint is to ensure that:

No order can exist without a valid customer
No order item can exist without a valid order
No order item can reference a product that does not exist

Without these constraints, the database would contain orphan records — rows that are not linked to any valid parent record. This leads to data corruption, incorrect reports, and unreliable query results.

Real world example:
Think of placing an order on Amazon — if your account does not exist, the system will not allow you to place an order. A Foreign Key constraint works exactly the same way in a database. It acts as a gatekeeper that prevents invalid or broken relationships between tables.
*/
-- === Section E — Advanced Concepts (CASE, ACID, Transactions) ===
-- Q.24  Write a query using CASE to classify products into price tiers: 
  -- • 'Budget'    → unit_price < 1000 
  -- • 'Mid-Range' → unit_price BETWEEN 1000 AND 3000 
  -- • 'Premium'   → unit_price > 3000 
-- Display: product_name, unit_price, price_tier. 
SELECT product_name,
unit_price,

CASE
WHEN unit_price <1000
THEN 'Budget'

WHEN unit_price
BETWEEN 1000 AND 3000
THEN 'Mid-Range'

ELSE 'Premium'
END AS price_tier

FROM products;
-- Q.25 Using a CASE statement inside an aggregate function, count how many orders are 'Delivered' vs 'Not Delivered' (all other statuses). 
-- Display the result in a single row.
SELECT

SUM(
CASE
WHEN status='Delivered'
THEN 1
ELSE 0
END
) AS delivered,

SUM(
CASE
WHEN status<>'Delivered'
THEN 1
ELSE 0
END
) AS not_delivered
FROM orders;

/*
Q26 — ACID Properties

> ACID*stands for Atomicity, Consistency, Isolation, and Durability. 
These are four properties that every reliable database transaction must follow to ensure data accuracy and integrity.

 Real World Example — Bank Transfer

> Suppose Rahul wants to transfer ₹5,000 to Priya.
> This transfer involves two operations:
> ```sql
> UPDATE accounts SET balance = balance - 5000 WHERE account_id = 'Rahul';
> UPDATE accounts SET balance = balance + 5000 WHERE account_id = 'Priya';
> ```
> Both operations must succeed together, or neither should happen at all.

 A — Atomicity
"All or Nothing"
> A transaction is treated as a single unit. Either **all steps complete successfully, ornone of them are applied.
Bank example:
> Rahul's account is debited ₹5,000. But suddenly the server crashes before Priya's account is credited.
> - Without Atomicity → Rahul loses ₹5,000, Priya gets nothing. ❌
> - With Atomicity → The entire transaction is rolled back. Both accounts stay unchanged. ✅
>
> ```sql
> START TRANSACTION;
> UPDATE accounts SET balance = balance - 5000 WHERE account_id = 'Rahul';
> UPDATE accounts SET balance = balance + 5000 WHERE account_id = 'Priya';
> -- If anything fails → ROLLBACK (nothing changes)
> -- If everything succeeds → COMMIT
> COMMIT;
 C — Consistency
"Data must always remain valid and follow all rules"
> Before and after every transaction, the database must remain in a valid state. All defined rules, constraints, and relationships must be satisfied.
Bank example:
> The bank has a rule — no account balance can go below ₹0.
> Rahul currently has ₹3,000 but tries to transfer ₹5,000.
> - Without Consistency → Balance becomes -₹2,000, which is invalid. 
> - With Consistency → Transaction is rejected because it violates the balance rule. 
>
> The database enforces this through constraints like `CHECK (balance >= 0)`. Consistency ensures the database never moves into a corrupted or rule-breaking state.
I — Isolation
"Transactions do not interfere with each other"
> When multiple transactions run at the same time, each one executes as if it is the only transaction running. Intermediate changes made by one transaction are not visible to others until it is committed.
Bank example:
> Rahul has ₹5,000. Two transactions happen at the same time:
> - Transaction 1: Rahul transfers ₹5,000 to Priya
> - Transaction 2: Rahul transfers ₹5,000 to Amit
>
> - Without Isolation → Both transactions read ₹5,000 balance simultaneously, both succeed, and Rahul's account goes to -₹5,000. 
> - With Isolation → Transaction 2 waits for Transaction 1 to complete first. It then reads the updated balance of ₹0 and gets rejected. 
>
> Isolation prevents problems like **dirty reads**, **phantom reads**, and **lost updates** in concurrent environments.

 D — Durability
"Once committed, data is permanently saved"
>
> After a transaction is successfully committed, the changes are **permanently stored** in the database — even if the system crashes, loses power, or restarts immediately after.
Bank example:
> Rahul's transfer is successfully completed and committed at 3:00 PM. At 3:01 PM the server crashes.
> - Without Durability → After restart, the transfer record is lost. Priya's balance goes back to what it was before. 
> - With Durability → After restart, the database recovers from its logs and the transfer remains intact. 

 ACID Summary Table
> | Property | Guarantee | Keyword | Bank Scenario |
> |----------|-----------|---------|---------------|
> | **Atomicity** | All steps succeed or none apply | "All or Nothing" | Server crash mid-transfer → full rollback |
> | **Consistency** | Data always follows all rules | "Always Valid" | Cannot transfer more than available balance |
> | **Isolation** | Transactions don't interfere | "No Interference" | Two simultaneous transfers don't corrupt balance |
> | **Durability** | Committed data survives crashes | "Permanently Saved" | Transfer record survives server restart |

-- Q.27
START TRANSACTION;

INSERT INTO orders
VALUES(
1011,
102,
CURDATE(),
'Pending',
1598.00
);

INSERT INTO order_items
VALUES
(5016,1011,202,1,799.00,0);

INSERT INTO order_items
VALUES
(5017,1011,208,1,599.00,0);

UPDATE products
SET stock_qty=stock_qty-1
WHERE product_id=202;

UPDATE products
SET stock_qty=stock_qty-1
WHERE product_id=208;

COMMIT;