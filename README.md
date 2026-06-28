# 🛒 ShopEase E-Commerce Sales Database
### Celebal Summer Internship 2026 — Week 2 SQL Task

![SQL](https://img.shields.io/badge/SQL-MySQL%20%7C%20PostgreSQL%20%7C%20SQLite-blue?style=flat-square&logo=mysql)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=flat-square)
![Internship](https://img.shields.io/badge/Celebal%20Technologies-Summer%202026-red?style=flat-square)

---

## 📌 Overview

This repository contains the complete SQL solution for **Week 2** of the Celebal Summer Internship 2026 program.

The task simulates a real-world scenario where I act as a **Junior Data Analyst at ShopEase** — a mid-sized Indian e-commerce company selling Electronics, Clothing, and Home products. The goal is to extract meaningful business insights from a relational database using SQL.

---

## 🗂️ Database Schema

The database consists of **4 relational tables**:

```
customers ──(1:N)──▶ orders ──(1:N)──▶ order_items ◀──(1:N)── products
```

| Table | Primary Key | Description |
|---|---|---|
| `customers` | `customer_id` | Customer profiles with city, state, premium status |
| `products` | `product_id` | Product catalogue with category, brand, price, stock |
| `orders` | `order_id` | Order header with status and total amount |
| `order_items` | `item_id` | Line items per order with quantity and discount |

### Entity Relationships
- `orders.customer_id` → FK → `customers.customer_id`
- `order_items.order_id` → FK → `orders.order_id`
- `order_items.product_id` → FK → `products.product_id`

---

## 📁 File Structure

```
📦 celebal-sql-week2/
├── 📄 shopease_week2_solution.sql   # Complete SQL script (all 27 questions)
└── 📄 README.md                     # This file
```

---

## 📋 Task Sections Covered

### Section A — SQL Basics
| Q# | Topic |
|---|---|
| Q1 | SELECT all rows from customers |
| Q2 | Project specific columns |
| Q3 | DISTINCT categories |
| Q4 | Primary Keys — purpose and constraints |
| Q5 | UNIQUE + NOT NULL on email |
| Q6 | CHECK constraint violation on unit_price |

### Section B — Filtering & Optimization
| Q# | Topic |
|---|---|
| Q7 | WHERE filter on order status |
| Q8 | Multi-condition filter (category + price) |
| Q9 | Date and state filtering |
| Q10 | BETWEEN with exclusion filter |
| Q11 | Index usage and performance benefit |
| Q12 | SARGability — rewriting YEAR() for index use |

### Section C — Aggregation
| Q# | Topic |
|---|---|
| Q13 | COUNT total orders |
| Q14 | SUM revenue for Delivered orders |
| Q15 | AVG unit price per category |
| Q16 | GROUP BY status with COUNT + SUM |
| Q17 | MAX and MIN price per category |
| Q18 | HAVING clause to filter aggregated groups |

### Section D — Joins & Relationships
| Q# | Topic |
|---|---|
| Q19 | INNER JOIN — orders with customer names |
| Q20 | LEFT JOIN — all customers including those with no orders |
| Q21 | 3-table JOIN — orders → order_items → products |
| Q22 | LEFT vs RIGHT vs FULL OUTER JOIN explained |
| Q23 | Foreign Key constraints and referential integrity |

### Section E — Advanced Concepts
| Q# | Topic |
|---|---|
| Q24 | CASE — product price tier classification |
| Q25 | CASE inside aggregate — Delivered vs Not Delivered |
| Q26 | ACID properties explained with real-world example |
| Q27 | Full transaction (BEGIN → INSERT → UPDATE → COMMIT/ROLLBACK) |

---

## 💡 Key Business Insights

| Insight | Finding |
|---|---|
| 💰 Total delivered revenue | ₹17,191 across 6 orders |
| 🏆 Top customer by spend | Rohan Gupta — ₹8,397 |
| 📦 Best-selling product (net revenue) | Running Shoes — ₹8,738 |
| 🏷️ Most units sold | Cushion Covers — 4 units |
| 🌟 Premium members dominate | All top 3 spenders are premium customers |
| ❌ Cancellation rate | 10% (1 out of 10 orders) |

---

## ▶️ How to Run

### SQLite (no installation needed on most systems)
```bash
# Create and load the database
sqlite3 shopease.db < shopease_week2_solution.sql
```

### MySQL
```sql
CREATE DATABASE shopease;
USE shopease;
SOURCE shopease_week2_solution.sql;
```

### PostgreSQL
```bash
psql -U your_username -d your_database -f shopease_week2_solution.sql
```

> **Note:** The script uses standard SQL syntax compatible with MySQL, PostgreSQL, and SQLite.  
> Minor adjustments may be needed for date functions:  
> - SQLite: `strftime('%Y', join_date)`  
> - MySQL: `YEAR(join_date)` or `DATE_FORMAT(...)`  
> - PostgreSQL: `EXTRACT(YEAR FROM join_date)`

---

## 🛠️ Tools Used

- **Database:** SQLite (local development)
- **Language:** Standard SQL
- **Concepts:** DDL, DML, Constraints, Indexes, Joins, Aggregation, CASE, Transactions, ACID

---

## 👤 Author

**Manoj Jadhav**  
Celebal Summer Internship 2026 — SQL Track  
Celebal Technologies

---

## 📜 License

This project is created for educational purposes as part of the Celebal Technologies internship program.
