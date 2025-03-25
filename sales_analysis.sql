-- 1️⃣ Create Database
CREATE DATABASE IF NOT EXISTS SalesDB;
USE SalesDB;

-- 2️⃣ Create Customers Table
CREATE TABLE IF NOT EXISTS customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50)
);

-- 3️⃣ Create Products Table
CREATE TABLE IF NOT EXISTS products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

-- 4️⃣ Create Sales Table (with Foreign Keys)
CREATE TABLE IF NOT EXISTS sales (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    sale_date DATE,
    quantity INT,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 5️⃣ Insert Sample Data (Customers)
INSERT INTO customers (customer_id, customer_name, city, state, country) VALUES
(1, 'Arun Kumar', 'Chennai', 'Tamil Nadu', 'India'),
(2, 'Priya Sharma', 'Bangalore', 'Karnataka', 'India'),
(3, 'Rahul Das', 'Mumbai', 'Maharashtra', 'India')
ON DUPLICATE KEY UPDATE customer_name = VALUES(customer_name);

-- 6️⃣ Insert Sample Data (Products)
INSERT INTO products (product_id, product_name, category, price) VALUES
(101, 'Laptop', 'Electronics', 55000.00),
(102, 'Smartphone', 'Electronics', 20000.00),
(103, 'Headphones', 'Accessories', 1500.00)
ON DUPLICATE KEY UPDATE product_name = VALUES(product_name);

-- 7️⃣ Insert Sample Data (Sales)
INSERT INTO sales (sale_id, customer_id, product_id, sale_date, quantity, total_amount) VALUES
(1, 1, 101, '2025-03-10', 1, 55000.00),
(2, 2, 102, '2025-03-11', 2, 40000.00),
(3, 3, 103, '2025-03-12', 3, 4500.00)
ON DUPLICATE KEY UPDATE total_amount = VALUES(total_amount);

-- 🟢 8️⃣ Calculate Total Revenue
SELECT SUM(total_amount) AS total_revenue FROM sales;

-- 🟢 9️⃣ Find the Top-Selling Product
SELECT p.product_name, SUM(s.quantity) AS total_sold
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 1;

-- 🟢 🔟 Find the Customer Who Spent the Most
SELECT c.customer_name, SUM(s.total_amount) AS total_spent
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 1;

-- 🟢 1️⃣1️⃣ Monthly Sales Report
SELECT DATE_FORMAT(sale_date, '%Y-%m') AS month, SUM(total_amount) AS total_sales
FROM sales
GROUP BY month
ORDER BY month;
