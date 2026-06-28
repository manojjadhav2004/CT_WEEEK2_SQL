-- ============================================================
--  SHOPEASE E-COMMERCE DATABASE
--  Celebal Summer Internship 2026 -- Week 2 SQL Task
--  Compatible with: SQLite / MySQL / PostgreSQL (standard SQL)
-- ============================================================


-- ════════════════════════════════════════════════════════════
--  SECTION 0 — SCHEMA CREATION & DATA LOADING
-- ════════════════════════════════════════════════════════════

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name  VARCHAR(50)  NOT NULL,
    last_name   VARCHAR(50)  NOT NULL,
    email       VARCHAR(100) UNIQUE NOT NULL,
    city        VARCHAR(50)  NOT NULL,
    state       VARCHAR(50)  NOT NULL,
    join_date   DATE         NOT NULL,
    is_premium  BOOLEAN      DEFAULT FALSE
);

CREATE TABLE products (
    product_id   INT PRIMARY KEY,
    product_name VARCHAR(100)    NOT NULL,
    category     VARCHAR(50)     NOT NULL,
    brand        VARCHAR(50)     NOT NULL,
    unit_price   DECIMAL(10,2)   NOT NULL CHECK (unit_price > 0),
    stock_qty    INT             NOT NULL DEFAULT 0 CHECK (stock_qty >= 0)
);

CREATE TABLE orders (
    order_id     INT PRIMARY KEY,
    customer_id  INT           NOT NULL,
    order_date   DATE          NOT NULL,
    status       VARCHAR(20)   NOT NULL DEFAULT 'Pending'
                 CHECK (status IN ('Pending','Shipped','Delivered','Cancelled')),
    total_amount DECIMAL(12,2) NOT NULL CHECK (total_amount >= 0),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    item_id      INT PRIMARY KEY,
    order_id     INT           NOT NULL,
    product_id   INT           NOT NULL,
    quantity     INT           NOT NULL CHECK (quantity > 0),
    unit_price   DECIMAL(10,2) NOT NULL CHECK (unit_price > 0),
    discount_pct DECIMAL(5,2)  DEFAULT 0 CHECK (discount_pct BETWEEN 0 AND 100),
    FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Indexes (MySQL/PostgreSQL syntax; SQLite uses same syntax)
CREATE INDEX idx_customers_city      ON customers(city);
CREATE INDEX idx_customers_state     ON customers(state);
CREATE INDEX idx_products_category   ON products(category);
CREATE INDEX idx_orders_date         ON orders(order_date);
CREATE INDEX idx_orders_status       ON orders(status);


-- ---------- INSERT: customers ----------
INSERT INTO customers VALUES
(101,'Aarav','Sharma','aarav.s@email.com','Mumbai','Maharashtra','2024-01-15',TRUE),
(102,'Priya','Patel','priya.p@email.com','Ahmedabad','Gujarat','2024-02-20',FALSE),
(103,'Rohan','Gupta','rohan.g@email.com','Delhi','Delhi','2024-03-10',TRUE),
(104,'Sneha','Reddy','sneha.r@email.com','Hyderabad','Telangana','2024-04-05',FALSE),
(105,'Vikram','Singh','vikram.s@email.com','Jaipur','Rajasthan','2024-05-12',TRUE),
(106,'Ananya','Iyer','ananya.i@email.com','Chennai','Tamil Nadu','2024-06-18',FALSE),
(107,'Karan','Mehta','karan.m@email.com','Pune','Maharashtra','2024-07-22',TRUE),
(108,'Divya','Nair','divya.n@email.com','Kochi','Kerala','2024-08-30',FALSE);

-- ---------- INSERT: products ----------
INSERT INTO products VALUES
(201,'Wireless Earbuds','Electronics','BoAt',1499.00,250),
(202,'Cotton T-Shirt','Clothing','Levis',799.00,500),
(203,'Smart Watch','Electronics','Noise',2999.00,150),
(204,'Running Shoes','Clothing','Nike',4599.00,120),
(205,'Bluetooth Speaker','Electronics','JBL',3499.00,200),
(206,'Bedsheet Set','Home','Spaces',1299.00,300),
(207,'Laptop Stand','Electronics','AmazonBasics',899.00,180),
(208,'Cushion Covers (Set)','Home','HomeCenter',599.00,400);

-- ---------- INSERT: orders ----------
INSERT INTO orders VALUES
(1001,101,'2024-08-01','Delivered',4498.00),
(1002,102,'2024-08-03','Delivered',799.00),
(1003,103,'2024-08-05','Shipped',7498.00),
(1004,101,'2024-08-10','Delivered',3499.00),
(1005,104,'2024-08-12','Cancelled',2999.00),
(1006,105,'2024-08-15','Delivered',5898.00),
(1007,106,'2024-08-18','Pending',1299.00),
(1008,103,'2024-08-20','Delivered',899.00),
(1009,107,'2024-08-25','Shipped',6098.00),
(1010,108,'2024-08-28','Delivered',1598.00);

-- ---------- INSERT: order_items ----------
INSERT INTO order_items VALUES
(5001,1001,201,2,1499.00,0),
(5002,1001,207,1,899.00,10),
(5003,1002,202,1,799.00,0),
(5004,1003,203,1,2999.00,0),
(5005,1003,204,1,4599.00,5),
(5006,1004,205,1,3499.00,0),
(5007,1005,203,1,2999.00,0),
(5008,1006,201,1,1499.00,10),
(5009,1006,204,1,4599.00,5),
(5010,1007,206,1,1299.00,0),
(5011,1008,207,1,899.00,0),
(5012,1009,205,1,3499.00,0),
(5013,1009,208,2,599.00,15),
(5014,1010,206,1,1299.00,0),
(5015,1010,208,1,599.00,0);


-- ════════════════════════════════════════════════════════════
--  SECTION A — SQL BASICS (SELECT, Constraints, Primary Keys)
-- ════════════════════════════════════════════════════════════

-- ── Q1. Display all columns and rows from the customers table ──
SELECT * FROM customers;

/*
 RESULT: 8 rows — all customer records with every column.
 All 8 customers are from different cities across India.
*/


-- ── Q2. Retrieve first_name, last_name, city ──
SELECT first_name, last_name, city
FROM customers;

/*
 RESULT: 8 rows with only the three requested columns.
 Cities span: Mumbai, Ahmedabad, Delhi, Hyderabad, Jaipur, Chennai, Pune, Kochi.
*/


-- ── Q3. List all unique categories in products ──
SELECT DISTINCT category
FROM products;

/*
 RESULT: 3 rows — Electronics, Clothing, Home.
 The shop carries products across these three broad categories.
*/


-- ── Q4. PRIMARY KEYS (conceptual answer) ──
/*
 Table         Primary Key    Explanation
 ──────────    ───────────    ──────────────────────────────────────────
 customers     customer_id    Uniquely identifies each customer account.
 products      product_id     Uniquely identifies each catalogue item.
 orders        order_id       Uniquely identifies each order transaction.
 order_items   item_id        Uniquely identifies each line item within an order.

 WHY must a Primary Key be UNIQUE and NOT NULL?
 ─ UNIQUE: Two rows with the same PK would create an ambiguous record with
   no way to distinguish them, breaking referential integrity.
 ─ NOT NULL: A NULL PK means "unknown identity". Foreign keys in child tables
   that reference this column would not be able to point to a definite row,
   making JOIN operations and FK constraints unreliable.
*/


-- ── Q5. Constraints on the email column ──
/*
 email VARCHAR(100) UNIQUE NOT NULL

 Constraints applied:
   1. NOT NULL   — every customer MUST provide an email address.
   2. UNIQUE     — no two customers can share the same email.

 What happens on duplicate insert?
   INSERT INTO customers VALUES (109,'Test','User','aarav.s@email.com','Delhi','Delhi','2024-09-01',FALSE);
   → ERROR: UNIQUE constraint failed: customers.email
   The database rejects the INSERT and the row is not added.
   This protects against accidental duplicate accounts.
*/


-- ── Q6. Inserting a product with unit_price = -50 ──
/*
 Attempted statement (will fail):
   INSERT INTO products VALUES (209,'Test Product','Electronics','TestBrand',-50.00,100);

 Error produced:
   ERROR: CHECK constraint failed: unit_price > 0
   (In MySQL: CHECK constraint 'products_chk_1' is violated.)

 Reason: The column definition includes CHECK (unit_price > 0).
 A price of -50 is logically invalid; the database enforces business rules
 at the schema level so no application layer bug can corrupt price data.
*/


-- ════════════════════════════════════════════════════════════
--  SECTION B — FILTERING & OPTIMIZATION (WHERE, Indexes)
-- ════════════════════════════════════════════════════════════

-- ── Q7. All orders with status = 'Delivered' ──
SELECT *
FROM orders
WHERE status = 'Delivered';

/*
 RESULT: 6 orders (1001, 1002, 1004, 1006, 1008, 1010)
 Total delivered revenue = ₹17,191.
*/


-- ── Q8. Electronics products priced above ₹2000 ──
SELECT product_id, product_name, brand, unit_price
FROM products
WHERE category = 'Electronics'
  AND unit_price > 2000;

/*
 RESULT: 2 products
   Smart Watch (Noise)        — ₹2,999
   Bluetooth Speaker (JBL)    — ₹3,499
*/


-- ── Q9. Maharashtra customers who joined in 2024 ──
-- MySQL syntax: YEAR(join_date) = 2024
-- SARGable / index-friendly version (works in all RDBMS):
SELECT first_name, last_name, city, state, join_date
FROM customers
WHERE join_date >= '2024-01-01'
  AND join_date <  '2025-01-01'
  AND state = 'Maharashtra';

/*
 RESULT: 2 customers
   Aarav Sharma — Mumbai   (joined 2024-01-15)
   Karan Mehta  — Pune     (joined 2024-07-22)
*/


-- ── Q10. Orders between 10–25 Aug 2024 that are NOT Cancelled ──
SELECT order_id, customer_id, order_date, status, total_amount
FROM orders
WHERE order_date BETWEEN '2024-08-10' AND '2024-08-25'
  AND status <> 'Cancelled';

/*
 RESULT: 5 orders (1004, 1006, 1007, 1008, 1009)
 Note: order 1005 (Cancelled) is correctly excluded.
*/


-- ── Q11. How idx_orders_date helps performance ──
/*
 Without index: the DB engine does a Full Table Scan — reading every row
 to check whether order_date matches the filter. As the table grows to
 millions of rows this becomes very slow (O(n)).

 With idx_orders_date: the engine performs a B-Tree index seek, jumping
 directly to the matching date range in O(log n) time, then reading only
 qualifying rows.

 Sample query that benefits from this index:
*/
SELECT order_id, customer_id, status, total_amount
FROM orders
WHERE order_date BETWEEN '2024-08-01' AND '2024-08-15';
-- The optimizer uses idx_orders_date to find this date range instantly.


-- ── Q12. YEAR() function and SARGability ──
/*
 Non-SARGable query (index CANNOT be used):
   SELECT * FROM customers WHERE YEAR(join_date) = 2024;

 Why the index is skipped: Applying YEAR() wraps every stored value in a
 function call. The index stores raw dates, not computed years, so the engine
 cannot seek into the index — it must read every row and evaluate YEAR() on
 each one (full table scan).

 SARGable rewrite (index CAN be used):
*/
SELECT *
FROM customers
WHERE join_date >= '2024-01-01'
  AND join_date <  '2025-01-01';
/*
 Now the filter is a plain range comparison on the raw column value, which
 maps directly onto the B-Tree index — the engine seeks to '2024-01-01'
 and scans forward until '2025-01-01'.
*/


-- ════════════════════════════════════════════════════════════
--  SECTION C — AGGREGATION (GROUP BY, SUM, COUNT, AVG, MIN, MAX)
-- ════════════════════════════════════════════════════════════

-- ── Q13. Total number of orders ──
SELECT COUNT(*) AS total_orders
FROM orders;

-- RESULT: 10


-- ── Q14. Total revenue from Delivered orders ──
SELECT SUM(total_amount) AS delivered_revenue
FROM orders
WHERE status = 'Delivered';

-- RESULT: ₹17,191.00


-- ── Q15. Average unit_price per category ──
SELECT
    category,
    ROUND(AVG(unit_price), 2) AS avg_unit_price
FROM products
GROUP BY category
ORDER BY avg_unit_price DESC;

/*
 RESULT:
   Clothing     ₹2,699.00   (₹799 + ₹4,599 / 2)
   Electronics  ₹2,224.00
   Home         ₹949.00
*/


-- ── Q16. Order count and total revenue per status, sorted by revenue DESC ──
SELECT
    status,
    COUNT(*)             AS order_count,
    SUM(total_amount)    AS total_revenue
FROM orders
GROUP BY status
ORDER BY total_revenue DESC;

/*
 RESULT:
   Delivered  6  ₹17,191
   Shipped    2  ₹13,596
   Cancelled  1  ₹2,999
   Pending    1  ₹1,299
*/


-- ── Q17. Most expensive and cheapest product in each category ──
SELECT
    category,
    MAX(unit_price) AS most_expensive,
    MIN(unit_price) AS cheapest
FROM products
GROUP BY category;

/*
 RESULT:
   Clothing      ₹4,599  ₹799
   Electronics   ₹3,499  ₹899
   Home          ₹1,299  ₹599
*/


-- ── Q18. Categories where average unit_price > ₹2000 (HAVING) ──
SELECT
    category,
    ROUND(AVG(unit_price), 2) AS avg_price
FROM products
GROUP BY category
HAVING AVG(unit_price) > 2000;

/*
 RESULT: 2 categories
   Clothing     ₹2,699
   Electronics  ₹2,224
 Note: Home (₹949) is excluded — correctly filtered by HAVING.
*/


-- ════════════════════════════════════════════════════════════
--  SECTION D — JOINS & RELATIONSHIPS
-- ════════════════════════════════════════════════════════════

-- ── Q19. Orders with customer name (INNER JOIN) ──
SELECT
    o.order_id,
    o.order_date,
    c.first_name,
    c.last_name,
    o.total_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date;

/*
 RESULT: 10 rows — every order matched to its customer.
 INNER JOIN returns only rows where the join condition is satisfied on
 BOTH sides, so orders with a missing customer_id would be excluded
 (FK constraint prevents this here anyway).
*/


-- ── Q20. All customers with their orders (LEFT JOIN) ──
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id,
    o.order_date,
    o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

/*
 RESULT: 10 rows — all customers appear even if they have no orders.
 Customers with no orders would show NULL for order_id, order_date,
 total_amount (none in this dataset, but the query handles it).
*/


-- ── Q21. Order items with product details (3-table JOIN) ──
SELECT
    o.order_id,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.discount_pct
FROM orders o
JOIN order_items oi ON o.order_id   = oi.order_id
JOIN products   p  ON oi.product_id = p.product_id
ORDER BY o.order_id, p.product_name;

/*
 RESULT: 15 line-item rows spread across 10 orders.
 Shows the full sales detail — product, quantity, price, and any discount.
*/


-- ── Q22. LEFT JOIN vs RIGHT JOIN (explanation with examples) ──
/*
 LEFT JOIN  → returns ALL rows from the LEFT table + matching rows from
              the RIGHT table; unmatched right-side columns are NULL.

   Example: List all customers even if they have placed no orders.
     SELECT c.first_name, o.order_id
     FROM customers c
     LEFT JOIN orders o ON c.customer_id = o.customer_id;
   → A customer with no orders appears with o.order_id = NULL.

 RIGHT JOIN → returns ALL rows from the RIGHT table + matching rows from
              the LEFT table; unmatched left-side columns are NULL.

   Example: List all orders even if their customer record was deleted.
     SELECT c.first_name, o.order_id
     FROM customers c
     RIGHT JOIN orders o ON c.customer_id = o.customer_id;
   → An orphaned order appears with c.first_name = NULL.
   (FK constraint prevents this, but logically it illustrates RIGHT JOIN.)

 FULL OUTER JOIN → returns ALL rows from BOTH tables; NULL fills gaps on
 either side. Use when you need every customer AND every order regardless
 of whether a match exists — e.g., an audit report checking for orphaned
 orders OR customers with zero activity.

 NOTE: SQLite does not support FULL OUTER JOIN natively; emulate with
       LEFT JOIN UNION ALL RIGHT JOIN (filtering duplicates).
*/


-- ── Q23. Foreign Key relationships and referential integrity ──
/*
 FK Relationships in this schema:
   orders.customer_id      → customers.customer_id
   order_items.order_id    → orders.order_id
   order_items.product_id  → products.product_id

 What happens with INSERT INTO orders VALUES (1012, 999, ...)?
   ERROR: FOREIGN KEY constraint failed.
   The database checks that customer_id = 999 exists in customers.
   Since it does not, the INSERT is rejected to maintain referential
   integrity — preventing orphaned orders that point to no real customer.

   This ensures JOIN operations always return meaningful data and no
   dangling references corrupt aggregate reports.
*/


-- ════════════════════════════════════════════════════════════
--  SECTION E — ADVANCED (CASE, ACID, Transactions)
-- ════════════════════════════════════════════════════════════

-- ── Q24. Classify products into price tiers using CASE ──
SELECT
    product_name,
    unit_price,
    CASE
        WHEN unit_price < 1000              THEN 'Budget'
        WHEN unit_price BETWEEN 1000 AND 3000 THEN 'Mid-Range'
        ELSE                                     'Premium'
    END AS price_tier
FROM products
ORDER BY unit_price;

/*
 RESULT:
   Budget    : Cushion Covers (₹599), Cotton T-Shirt (₹799), Laptop Stand (₹899)
   Mid-Range : Bedsheet Set (₹1,299), Wireless Earbuds (₹1,499), Smart Watch (₹2,999)
   Premium   : Bluetooth Speaker (₹3,499), Running Shoes (₹4,599)
*/


-- ── Q25. Delivered vs Not Delivered in a single row ──
SELECT
    SUM(CASE WHEN status = 'Delivered' THEN 1 ELSE 0 END) AS delivered,
    SUM(CASE WHEN status <> 'Delivered' THEN 1 ELSE 0 END) AS not_delivered
FROM orders;

/*
 RESULT:
   delivered = 6   |   not_delivered = 4
 (Shipped=2, Cancelled=1, Pending=1 → 4 total non-delivered)
*/


-- ── Q26. ACID Properties (conceptual) ──
/*
 A — ATOMICITY
     A transaction is all-or-nothing. Every operation within it either
     completes successfully or none of them take effect.
     Example: In a bank transfer — debit ₹5,000 from Account A AND
     credit ₹5,000 to Account B must both succeed. If the credit fails,
     the debit is automatically rolled back. You can never have money
     leave one account without arriving at another.

 C — CONSISTENCY
     A transaction always moves the database from one valid state to
     another, respecting all defined constraints and rules.
     Example: A bank's rule states balance >= 0. If a transfer would push
     an account into negative, the transaction is aborted, keeping the
     database in a consistent, rule-compliant state.

 I — ISOLATION
     Concurrent transactions execute as if they were sequential; partial
     changes from an in-progress transaction are invisible to others.
     Example: While a ₹5,000 transfer is in flight, another session
     checking Account A's balance should not see a temporarily reduced
     amount before the transaction commits.

 D — DURABILITY
     Once a transaction is committed, its changes are permanent — even in
     the event of a power failure, crash, or restart.
     Example: After the bank confirms "Transfer Complete", the credit and
     debit persist in storage and will be there when the server restarts.
*/


-- ── Q27. Full Transaction Block — atomically create order 1011 ──
BEGIN;

-- Step 1: Insert the new order
INSERT INTO orders (order_id, customer_id, order_date, status, total_amount)
VALUES (1011, 102, CURRENT_DATE, 'Pending', 1598.00);

-- Step 2: Insert two order items for that order
INSERT INTO order_items (item_id, order_id, product_id, quantity, unit_price, discount_pct)
VALUES (5016, 1011, 206, 1, 1299.00, 0);

INSERT INTO order_items (item_id, order_id, product_id, quantity, unit_price, discount_pct)
VALUES (5017, 1011, 208, 1, 599.00, 0);

-- Step 3: Deduct stock for the purchased products
UPDATE products SET stock_qty = stock_qty - 1 WHERE product_id = 206;
UPDATE products SET stock_qty = stock_qty - 1 WHERE product_id = 208;

-- Step 4: Commit if all steps succeeded; otherwise roll back
COMMIT;

/*
 ROLLBACK pattern (use instead of COMMIT if any step raises an error):

 In application code (e.g., Python + psycopg2):
   try:
       conn.execute("INSERT INTO orders ...")
       conn.execute("INSERT INTO order_items ...")
       conn.execute("INSERT INTO order_items ...")
       conn.execute("UPDATE products ...")
       conn.execute("UPDATE products ...")
       conn.commit()
   except Exception as e:
       conn.rollback()
       raise e

 In stored procedure (MySQL):
   DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; END;

 Why atomicity matters here:
   If the UPDATE on stock_qty fails (e.g., stock = 0 violating CHECK),
   the order and its items should NOT be persisted — ROLLBACK undoes all
   four prior statements, leaving the database in its original clean state.
*/


-- ════════════════════════════════════════════════════════════
--  BONUS — BUSINESS INSIGHTS
-- ════════════════════════════════════════════════════════════

-- Top 3 customers by total spend
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.is_premium,
    COUNT(o.order_id)         AS total_orders,
    SUM(o.total_amount)       AS total_spend
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY total_spend DESC
LIMIT 3;

-- Net revenue per product (factoring in discounts)
SELECT
    p.product_name,
    p.category,
    SUM(oi.quantity)                                                 AS units_sold,
    SUM(oi.quantity * oi.unit_price)                                 AS gross_revenue,
    SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100.0)) AS net_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id
ORDER BY net_revenue DESC;

-- Monthly order trend (August 2024)
SELECT
    strftime('%Y-%m', order_date) AS month,   -- MySQL: DATE_FORMAT(order_date,'%Y-%m')
    COUNT(*)                      AS orders,
    SUM(total_amount)             AS revenue
FROM orders
GROUP BY strftime('%Y-%m', order_date)
ORDER BY month;

-- Data quality check: row counts per table
SELECT 'customers'   AS tbl, COUNT(*) AS rows FROM customers  UNION ALL
SELECT 'products',                  COUNT(*) FROM products     UNION ALL
SELECT 'orders',                    COUNT(*) FROM orders       UNION ALL
SELECT 'order_items',               COUNT(*) FROM order_items;
