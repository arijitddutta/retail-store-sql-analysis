-- LEVEL 1 --
-- Question 1 : Retrieve customer names and emails for email marketing --

SELECT name AS customer_name , email FROM customers;

-- Question 2 : View complete product catalog with all available details --

SELECT * FROM products;

-- Question 3 : List all unique product categories-- 

SELECT DISTINCT category FROM products;

-- Question 4 -- Show all products priced above ₹1,000--

SELECT name AS Product_Name, price, category
 FROM products
 WHERE price > 1000; 
 
-- Question 5 : Display products within a mid-range price bracket (₹2,000 to ₹5,000) --

SELECT name AS Product_Name, price, category
 FROM products
WHERE price BETWEEN 2000 AND 5000;

-- Question 6 : Fetch data for specific customer IDs (e.g., from a loyalty program list) --

SELECT * FROM customers 
WHERE customer_id IN (7,13,17,21,27,29,30);

-- Question 7 : Identify customers whose names start with the letter 'A' --

SELECT 
name AS customer_name FROM customers
WHERE name LIKE 'A%';

-- Question 8 : List electronics products priced under ₹3,000 --

SELECT
name AS Product_Name, category, price FROM products
WHERE price < 3000 AND category = 'Electronics';

-- 	Question 9 : Display product names and prices in descending order of price --

SELECT 
name AS product_name, price FROM products
ORDER BY price DESC;

-- Question 10 : Display product names and prices, sorted by price and then by name --

SELECT 
name as Product_Name, price FROM products 
ORDER BY price DESC, name ASC ;

-- =================
--    LEVEL  2    --
-- =================

-- Question 1 : Retrieve orders where customer information is missing (possibly due to data migration or deletion) --

SELECT 
order_id, customer_id, order_date, status
 FROM orders
WHERE customer_id IS NULL;

-- Question 2 : Display customer names and emails using column aliases for frontend readability --

SELECT 
name AS customer_name, email as Customer_email_address
FROM customers;

-- Question 3 : Calculate total value per item ordered by multiplying quantity and item price --
SELECT 
order_item_id, order_id, (item_price * quantity) AS Total_Value 
FROM order_items;

-- Question 4 : Combine customer name and phone number in a single column -- 
SELECT 
customer_id, CONCAT(name, ' - ', phone) AS Combined_Name_and_No
FROM customers;

-- Question 5 : Extract only the date part from order timestamps for date-wise reporting --
SELECT
order_id, status, total_amount, DATE(order_date) AS Order_Date
FROM orders;

-- Question 6 : List products that do not have any stock left --
SELECT
product_id, name, category, stock_quantity
FROM products 
WHERE stock_quantity = 0 ;

-- -------------------------------------------------
-- -------------------LEVEL 3-----------------------

-- Question 1 : Count the total number of orders placed --

SELECT COUNT(order_id) as TOTAL_ORDERS
FROM orders;

--  Question 2 : Calculate the total revenue collected from all orders --
SELECT
sum(total_amount) AS TOTAL_SALES
FROM orders;

-- Question 3 Calculate the average order value --
SELECT ROUND(avg(total_amount),2) AS Avg_order_value
FROM orders;

-- Question 4 : Count the number of customers who have placed at least one order --

SELECT COUNT(DISTINCT customer_id) AS active_customers
FROM orders;

-- Question 5 Find the number of orders placed by each customer --
SELECT customer_id, COUNT(order_id) AS order_count
FROM orders
GROUP BY customer_id;

-- Question 6 : Find total sales amount made by each customer --
SELECT 
customer_id, SUM(total_amount) AS total_sales
FROM orders
GROUP BY customer_id;

-- Question 7 : List the number of products sold per category --
SELECT category, SUM(quantity) AS total_units_sold
FROM order_items
JOIN products ON order_items.product_id = products.product_id
GROUP BY category;

-- Question 8 - Find the average item price per category --
SELECT category, 
round(avg(price),2) AS Avg_Price
FROM products
GROUP BY category;

-- Question 9 Show number of orders placed per day --
SELECT 
DATE(order_date) AS Order_Date,
COUNT(order_id) AS orders_per_day
FROM orders
Group By Order_Date;

-- Question 10 : List total payments received per payment method --
SELECT method, 
round(SUM(amount_paid),2) AS total_payments_rcvd
FROM payments
Group By method;

-- ==========================
-- ------LEVEL 4 ------------
-- ==========================
-- Question 1 : Retrieve order details along with the customer name (INNER JOIN) --
SELECT 
orders.order_id, orders.order_date, orders.status, orders.total_amount, 
customers.name AS customer_name
FROM orders
INNER JOIN customers
ON orders.customer_id = customers.customer_id;

-- Question 2 : Get list of products that have been sold (INNER JOIN with order_items) --
SELECT DISTINCT
products.product_id, products.category, 
products.name AS Product_Name, products.price
FROM products
INNER JOIN order_items ON products.product_id = order_items.product_id;

-- Question 3 : List all orders with their payment method (INNER JOIN) --
SELECT 
orders.order_id, orders.customer_id , orders.order_date,
orders.total_amount , payments.method
FROM orders 
INNER JOIN payments 
ON orders.order_id = payments.order_id ;

-- Question 4 Get list of customers and their orders (LEFT JOIN) --
SELECT 
customers.customer_id , customers.name AS customer_name,
customers.email, customers.phone, orders.order_id
FROM customers
LEFT JOIN orders on customers.customer_id = orders.customer_id ;

-- Question 5 : List all products along with order item quantity (LEFT JOIN) --
SELECT 
	products.product_id , products.name AS product_name,
    products.category , products.price , products.stock_quantity,
    order_items.quantity as Products_sold 
    FROM products 
    LEFT JOIN order_items ON products.product_id = order_items.product_id ;
    
-- Question 6 : List all payments including those with no matching orders (RIGHT JOIN) --
SELECT
orders.order_id,
payments.payment_id , payments.amount_paid, payments.method,
payments.payment_date 
FROM orders
RIGHT JOIN payments ON 
orders.order_id = payments.order_id ;

-- Question 7 : Combine data from three tables: customer, order, and payment --
SELECT 
customers.name AS customer_name, customers.email,
orders.order_id, orders.order_date, orders.status,
payments.method, payments.amount_paid, payments.payment_date
FROM customers
JOIN orders ON customers.customer_id = orders.customer_id
JOIN payments ON orders.order_id = payments.order_id;

-- =================================
--             Level 5            --
-- =================================
-- Question 1 : List all products priced above the average product price --
SELECT 
product_id ,name AS Product_name , category, price
FROM products
 WHERE 
		price >(SELECT AVG(price) FROM products) ;
        
-- Question 2 : Find customers who have placed at least one orde --
SELECT customer_id, name
FROM customers
WHERE customer_id IN (SELECT customer_id FROM orders);

-- Question 3 -- Show orders whose total amount is above the average for that customer --
SELECT 
a.order_id, a.order_date , a.customer_id, a.total_amount
FROM orders a 
WHERE a.total_amount > (
SELECT avg(b.total_amount) FROM orders b
WHERE a.customer_id = b.customer_id ) ;

-- Question 4 :Display customers who haven't placed any orders --
SELECT 
name as Customer_Name, customer_id 
FROM customers 
WHERE customer_id NOT IN (
SELECT customer_id 
FROM orders
WHERE customer_id IS NOT NULL
) ;

-- Question 5 : Show products that were never ordered --
SELECT 
product_id, name AS Product_name, category
FROM products
WHERE product_id NOT IN (SELECT product_id FROM order_items);

-- Question 6 : Show highest value order per customer --
SELECT customer_id, MAX(total_amount) AS highest_order_value
FROM orders
GROUP BY customer_id;

-- Question 7 : Highest Order Per Customer (Including Names) --
SELECT c.customer_id, c.name AS customer_name, o.order_id, o.total_amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.total_amount = (
    SELECT MAX(o1.total_amount)
    FROM orders o1
    WHERE o1.customer_id = c.customer_id
);

-- ===============================================
--               LEVEL 6                        --
-- ===============================================
-- Question 1 :List all customers who have either placed an order or written a product review --
SELECT c.customer_id, c.name AS customer_name
FROM customers c
WHERE c.customer_id IN (
    SELECT customer_id FROM orders
    UNION
    SELECT customer_id FROM product_reviews
);

-- Question 2 :List all customers who have placed an order as well as reviewed a product -- 

SELECT c.customer_id, c.name AS customer_name
FROM customers c
WHERE c.customer_id IN (SELECT customer_id FROM orders)
AND c.customer_id IN (SELECT customer_id FROM product_reviews);

