# E-Commerce End-to-End SQL Analysis & Business Insights

##  📌 Project Overview
This project performs an end-to-end analysis of e-commerce operations. It tracks the journey from customer acquisition and order placement to delivery performance and final profitability. The analysis reveals a business scaling well in volume but facing significant operational hurdles and financial losses.

## 🗂️ Database Schema
The following tables form the foundation of this analysis

-- 1. Customers: Profiles and acquisition data
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    signup_date DATE,
    city TEXT,
    acquisition_channel TEXT,
    device_type TEXT,
    age_group TEXT,
    is_active BOOLEAN,
    last_order_date DATE
); [cite: 3-12]

-- 2. Orders: Core transactional data
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_timestamp TIMESTAMP,
    order_value NUMERIC(10,2),
    discount_amount NUMERIC(10,2),
    payment_method TEXT,
    city TEXT,
    order_status TEXT
); [cite: 13-22]

-- 3. Order Items: Product-level details
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT,
    category TEXT,
    quantity INT,
    item_price NUMERIC(10,2)
); [cite: 23-30]

-- 4. Deliveries: Logistics and performance tracking
CREATE TABLE deliveries (
    delivery_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    delivery_time_min INT,
    promised_time_min INT,
    is_delayed BOOLEAN,
    delivery_partner_id INT
); [cite: 31-38]

-- 5. Support Tickets: Post-purchase issues and refunds
CREATE TABLE support_tickets (
    ticket_id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    issue_type TEXT,
    resolution_time_hrs NUMERIC(5,2),
    compensation_amount NUMERIC(10,2)
); [cite: 39-45]

-- 6. Marketing Spend: Growth investment by channel
CREATE TABLE marketing_spend (
    date DATE,
    channel TEXT,
    spend_amount NUMERIC(12,2),
    users_acquired INT,
    PRIMARY KEY (date, channel)
); [cite: 46-52]

-- 7. Costs: Operational overhead per city
CREATE TABLE costs (
    date DATE,
    city TEXT,
    delivery_cost NUMERIC(12,2),
    marketing_cost NUMERIC(12,2),
    refunds_cost NUMERIC(12,2),
    PRIMARY KEY (date, city)
); [cite: 53-60]
