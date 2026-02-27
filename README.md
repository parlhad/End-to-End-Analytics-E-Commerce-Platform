# 🛒 End-to-End E-Commerce Analytics Platform  
### SQL + Power BI | Business Intelligence & Unit Economics Analysis

---

##  📌 Project Overview

This project delivers a **complete end-to-end business intelligence case study** for a modern e-commerce platform.

It evaluates the full operational lifecycle:

- Customer acquisition
- Order behavior
- Delivery performance
- Marketing efficiency
- Refund leakage
- Operational cost structure
- Unit economics & profitability
- Refund leakage
  

### The analysis reveals a business that is scaling in volume but structurally loss-making due to operational inefficiencies.

#### This project combines:

- Advanced SQL (23 Business Queries)
- Power BI Executive Dashboard
- Business KPI Engineering
- Unit Economics Diagnosis

### 🎯 Core Objective

To diagnose why a high-scale, high-revenue e-commerce platform is **structurally loss-making**, and identify strategic actions required to restore sustainable growth.

---

# 🏗️ Data Architecture

The analytics model is built on a relational schema consisting of 7 core business entities:

- Customers  
- Orders  
- Order Items  
- Deliveries  
- Support Tickets  
- Marketing Spend  
- Operational Costs  

This structure enables full-funnel business analysis — from acquisition to post-order support.

## 🗂️ Database Schema
The following tables form the foundation of this analysis
```

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
); 

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
);

-- 3. Order Items: Product-level details
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT,
    category TEXT,
    quantity INT,
    item_price NUMERIC(10,2)
);

-- 4. Deliveries: Logistics and performance tracking
CREATE TABLE deliveries (
    delivery_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    delivery_time_min INT,
    promised_time_min INT,
    is_delayed BOOLEAN,
    delivery_partner_id INT
);

-- 5. Support Tickets: Post-purchase issues and refunds
CREATE TABLE support_tickets (
    ticket_id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    issue_type TEXT,
    resolution_time_hrs NUMERIC(5,2),
    compensation_amount NUMERIC(10,2)
);

-- 6. Marketing Spend: Growth investment by channel
CREATE TABLE marketing_spend (
    date DATE,
    channel TEXT,
    spend_amount NUMERIC(12,2),
    users_acquired INT,
    PRIMARY KEY (date, channel)
);

-- 7. Costs: Operational overhead per city
CREATE TABLE costs (
    date DATE,
    city TEXT,
    delivery_cost NUMERIC(12,2),
    marketing_cost NUMERIC(12,2),
    refunds_cost NUMERIC(12,2),
    PRIMARY KEY (date, city)
); 

```
---

# 📊 Business Intelligence Layer (Power BI Executive Dashboard)

The project includes a professionally designed **6-page executive dashboard**, structured for leadership-level decision making.

---

## 🔹 Dashboard Structure

1. Home  
2. Overview  
3. Customer  
4. Revenue  
5. Cost & Growth Efficiency  
6. Risk & Experience  

Each page answers a specific strategic question.

---

# 🏠 1️⃣ Home – Strategic Context

### Purpose
Defines the business problem and analytical objective.

### Problem Statement

Despite processing **836,810 completed orders** and generating **₹471M+ revenue**, the platform is experiencing structural financial losses driven by operational inefficiencies.

---

# 📈 2️⃣ Overview – Business Health Snapshot

### Core KPIs

- **₹471M Net Revenue**
- **837K Completed Orders**
- **₹563 Average Order Value**
- **27.76% Customer Churn**
- **86.53% Revenue from Repeat Customers**
- **8.59% Revenue MoM Growth**

### Executive Insight

The business demonstrates strong scale and demand.  
However, revenue sustainability is heavily dependent on retention.

---

# 👥 3️⃣ Customer – Retention & Behavior Analysis

### Key KPIs

- **72.24% Active Customers**
- **27.76% High-Risk Customers**
- **99.58% Repeat Customer Rate**
- **6.98 Average Orders per Active User**

### Insights

- Revenue is primarily driven by repeat users.
- High churn signals post-order experience issues.
- Customer value distribution shows limited premium segmentation.
- Retention must take strategic priority over acquisition.

---

# 💰 4️⃣ Revenue – Growth Drivers & Stability

### Key Metrics

- **Revenue per Active Customer:** ₹3.93K
- **Revenue Volatility Index:** 0.05
- **Top 20% Revenue Contribution:** 36.28%
- **Discount Dependency:** 8.54%

### Insights

- Revenue is volume-driven rather than value-driven.
- Paid acquisition drives majority of revenue.
- Product and device distribution are balanced.
- Moderate 80–20 revenue concentration risk.

---

# 📊 5️⃣ Cost & Growth Efficiency – Unit Economics

### Core KPIs

- **₹175M Total Marketing Spend**
- **CAC:** 76.03
- **CLTV:** 204.51
- **CLTV/CAC Ratio:** 55.54
- **Marketing ROI:** 168.97%
- **Refund Cost:** ₹222M
- **Cost per Order:** ₹2.20K
- **AOV:** ₹563

### Critical Insight

Cost per order significantly exceeds AOV.

Growth is currently increasing losses instead of profit.

Marketing ROI appears healthy in isolation but fails to reflect full operational cost structure.

---

# ⚠️ 6️⃣ Risk & Experience – Operational Diagnosis

### Key KPIs

- **31.61% On-Time Delivery**
- **68.39% Delivery Delay Rate**
- **73.13% Complaints per 100 Orders**
- **47.21% Refund Rate**
- **HIGH CX Risk Classification**

### Operational Findings

- 53,874 complaints due to late delivery.
- 72,480 customers affected by slow support resolution.
- Refund leakage is materially damaging margins.
- All 7 cities analyzed are loss-making.
- Highest city-level loss ≈ ₹17.45 Cr.

---

# 🔎 SQL Business Analysis (23 Advanced Queries)

The SQL layer powers all insights and includes:

- Business Scale & Revenue Calculation
- Monthly Growth Tracking
- New vs Repeat Revenue Analysis
- Churn Rate Calculation
- Delivery Delay Rate Measurement
- CAC by Channel
- CLTV Analysis
- Contribution Margin Calculation
- City-Level Profitability
- Refund-Heavy Customer Detection
- AOV & Channel Quality Analysis
- Order Frequency Distribution
- 80–20 Revenue Rule
- Cancellation Rate
- Complaint Rate
- Profit per Order
- Growth vs Profit Trade-off

  
## 🚀 Business Analysis & Insights (23 Queries)
### Q1: Business Scale & Total Activity
SQL
```
SELECT 
    COUNT(*) AS total_orders, 
    SUM(order_value - discount_amount) AS total_revenue 
FROM orders 
WHERE order_status = 'Completed';
```
### 💡 Insight: The business has processed 836,810 completed orders, generating a total revenue of 471,511,630.65 .

### Q2: Monthly Revenue Trend (Growth Check)
SQL
```
SELECT 
    DATE_TRUNC('month', order_timestamp) AS month, 
    SUM(order_value - discount_amount) AS revenue 
FROM orders 
WHERE order_status = 'Completed' 
GROUP BY month 
ORDER BY month;
```
### 💡 Insight: Measures if the business is growing or stagnating by tracking revenue fluctuations month-over-month.

### Q3: New vs. Loyal Customer Revenue
SQL
```
WITH first_orders AS (
    SELECT customer_id, MIN(order_timestamp) AS first_order_date 
    FROM orders 
    WHERE order_status = 'Completed' 
    GROUP BY customer_id
)
SELECT 
    CASE WHEN o.order_timestamp = f.first_order_date THEN 'New' ELSE 'Repeat' END AS customer_type,
    COUNT(*) AS orders,
    SUM(o.order_value - o.discount_amount) AS revenue
FROM orders o
JOIN first_orders f ON o.customer_id = f.customer_id
WHERE o.order_status = 'Completed'
GROUP BY customer_type;
```
### 💡 Insight: Repeat users contribute significantly more revenue (403,300,088.09) than new users (68,211,542.56), proving retention is the primary revenue driver .

### Q4: Churn Rate (Customer Loss)
SQL
```
SELECT 
    COUNT(*) FILTER(WHERE is_active = 'False')::FLOAT / COUNT(*) * 100 AS Churn_rate_per 
FROM customers;
```
### 💡 Insight: Approximately 27.76% of the customer base has stopped ordering from the company.

###  Q5: Delivery Delay Rate
SQL
```
SELECT 
    ROUND((COUNT(*) FILTER (WHERE is_delayed = 'True')::FLOAT / COUNT(*) * 100)::NUMERIC, 2) AS delivery_delay_rate
FROM deliveries;
```
###  💡 Insight: The delivery delay rate is critically high at 68.39% .

###  Q6: Delay Impact on Repeat Orders
SQL
```
WITH delayed_customers AS (
    SELECT DISTINCT o.customer_id
    FROM orders o
    JOIN deliveries d ON o.order_id = d.order_id
    WHERE d.is_delayed = TRUE
)
SELECT 
    CASE WHEN c.customer_id IN (SELECT customer_id FROM delayed_customers) THEN 'Delayed Experience' ELSE 'On-time Experience' END AS experience_type,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'Completed'
GROUP BY 1;
```
###  💡 Insight: 835,231 orders were from customers with a delayed experience, compared to only 1,579 for on-time, suggesting delays are a massive barrier to retention .

###  Q7: Customer Acquisition Cost (CAC) by Channel
SQL
```
SELECT 
    channel, 
    ROUND(SUM(spend_amount)::NUMERIC / SUM(users_acquired)::NUMERIC, 2) AS cust_aqu_cost
FROM marketing_spend 
GROUP BY channel;
```
### 💡 Insight: Paid channels are the most efficient (73.88), while Referral channels are the least efficient (77.60) .

###  Q8: Identifying High-Value Customers (LTV)
SQL
```
SELECT 
    customer_id, 
    SUM(order_value - discount_amount) AS life_time_revenue
FROM orders
WHERE order_status = 'Completed'
GROUP BY customer_id
ORDER BY life_time_revenue DESC;
💡 Insight: Top customer (ID: 67633) has added 15,461.07 in revenue. Retaining these high-value users through loyalty programs is essential .
```
###  Q9: CLTV vs. Acquisition Spend Efficiency
SQL
```
WITH cltv AS (
    SELECT customer_id, SUM(order_value - discount_amount) AS lifetime_value 
    FROM orders WHERE order_status = 'Completed' GROUP BY customer_id
)
SELECT 
    c.acquisition_channel, 
    AVG(cltv.lifetime_value) AS avg_cltv
FROM cltv
JOIN customers c ON cltv.customer_id = c.customer_id
GROUP BY c.acquisition_channel;
```
###  💡 Insight: Returns are nearly identical across channels (~3,930), meaning marketing budgets can be optimized to the cheapest acquisition sources .

###  Q10: Contribution Margin (Overall Profitability)
SQL
```
SELECT 
    SUM(o.net_revenue) - SUM(co.total_daily_costs) AS Contribution_margin_revenue
FROM (
    SELECT DATE(order_timestamp) as order_date, city, SUM(order_value - discount_amount) as net_revenue
    FROM orders WHERE order_status = 'Completed' GROUP BY 1, 2
) o
JOIN (
    SELECT date, city, SUM(delivery_cost + marketing_cost + refunds_cost) as total_daily_costs
    FROM costs GROUP BY 1, 2
) co ON o.order_date = co.date AND o.city = co.city;
```
###  💡 Insight: The company is currently at a massive loss (-1,193,467,022.38); operational spend is far exceeding revenue .

### Q11: Profit/Loss per City
SQL
```
SELECT 
    co.city, 
    (rev.net_revenue)-(co.total_costs) AS city_profit
FROM (
    SELECT city, SUM(delivery_cost + marketing_cost + refunds_cost) as total_costs FROM costs GROUP BY city
) co
JOIN (
    SELECT city, SUM(order_value - discount_amount) as net_revenue FROM orders WHERE order_status = 'Completed' GROUP BY city
) rev ON co.city = rev.city
ORDER BY city_profit ASC;
```
### 💡 Insight: All 7 major cities analyzed are currently loss-making, with Pune and Delhi showing the highest losses .

###  Q12: Identification of Refund-Heavy Customers
SQL
```
SELECT 
    customer_id, 
    SUM(compensation_amount) AS total_refund
FROM support_tickets
GROUP BY customer_id
HAVING SUM(compensation_amount) > 500
ORDER BY total_refund DESC;
```
### 💡 Insight: 250 customers have each received over 500 in compensation; the refund policy must be tightened to protect margins .

###  Q13: Average Order Value (AOV)
SQL
```
SELECT 
    ROUND(SUM(order_value - discount_amount) / COUNT(*), 2) AS avg_order_value
FROM orders
WHERE order_status = 'Completed';
```
###  💡 Insight: The global AOV is 563.46, categorized as low-to-medium .

###  Q14: AOV by Acquisition Channel
SQL
```
SELECT 
    c.acquisition_channel, 
    ROUND(AVG(o.order_value - o.discount_amount), 2) AS Avg_aov
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.acquisition_channel;
```
###  💡 Insight: Customer quality is uniform across all channels (~563 AOV), regardless of acquisition source .

###  Q15: Order Frequency per Customer (Engagement)
SQL
```
SELECT 
    customer_id, 
    COUNT(order_id) AS total_orders
FROM orders
WHERE order_status = 'Completed'
GROUP BY customer_id
ORDER BY total_orders DESC;
```
###  💡 Insight: Top loyalists place up to 20 orders. Keeping them engaged with targeted offers is vital for long-term health .

###  Q16: Top 20% Customer Contribution (80–20 Rule)
SQL
``` 
WITH customer_revenue AS (
    SELECT customer_id, SUM(order_value - discount_amount) AS revenue FROM orders 
    WHERE order_status = 'Completed' GROUP BY customer_id
),
ranked AS (
    SELECT *, NTILE(5) OVER(ORDER BY revenue DESC) AS bucket FROM customer_revenue
)
SELECT bucket, SUM(revenue) AS revenue FROM ranked GROUP BY bucket ORDER BY bucket;
``` 
###  💡 Insight: Identifies revenue concentration, showing how much total revenue is driven by the top tier (Bucket 1) of customers.

###  Q17: Order Cancellation Rate
SQL
``` 
SELECT 
    ROUND((COUNT(*) FILTER (WHERE order_status = 'Cancelled')::FLOAT / COUNT(*) * 100)::NUMERIC, 2) AS cancellation_rate
FROM orders;
```
###  💡 Insight: The cancellation rate is 7.02%, which is manageable and not a high-risk factor .

### Q18: City-wise Delivery Performance
SQL
```
SELECT 
    o.city, 
    ROUND(AVG(d.delivery_time_min)::numeric, 2) AS avg_delivery_time,
    ROUND((COUNT(*) FILTER (WHERE d.is_delayed = TRUE)::float / COUNT(*) * 100)::numeric, 2) AS delay_percentage
FROM deliveries d
JOIN orders o ON d.order_id = o.order_id
GROUP BY o.city
ORDER BY delay_percentage DESC;
```
### 💡 Insight: Delay percentages are consistently high (~68%) across all cities, with Mumbai being the highest .

### Q19: Complaint Rate per 100 Orders
SQL
```
SELECT 
    ROUND((COUNT(st.ticket_id)::float / COUNT(o.order_id) * 100)::numeric, 2) AS complaints_per_100_orders
FROM orders o
LEFT JOIN support_tickets st ON o.customer_id = st.customer_id
WHERE o.order_status = 'Completed';
```
###  💡 Insight: A staggering 73.13% complaint rate, indicating a severe need for operational improvements .

###  Q20: Support Resolution Time Impact
SQL
```
SELECT 
    CASE WHEN resolution_time_hrs <= 6 THEN 'Fast Resolution' ELSE 'Slow Resolution' END AS resolution_type,
    COUNT(DISTINCT customer_id) AS customers
FROM support_tickets
GROUP BY 1;
```
###  💡 Insight: Identifies the volume of customers affected by slow service (72,480) compared to fast service (8,903).

### Q21: Primary Customer Issue Types
SQL
```
SELECT 
    issue_type, 
    COUNT(issue_type) 
FROM support_tickets 
GROUP BY issue_type;
```
###  💡 Insight: Late Delivery is the top issue (53,874 cases), confirming the logistics bottleneck .

###  Q22: Profit per Order (Transactional Level)
`SQL
```
SELECT 
    o.order_id, 
    (o.order_value - o.discount_amount) - (co.delivery_cost + co.refunds_cost) AS profit_per_order
FROM orders o
JOIN costs co ON DATE(o.order_timestamp) = co.date AND o.city = co.city
WHERE o.order_status = 'Completed';
```
###  💡 Insight: Granular view of profit/loss per individual transaction after accounting for overhead.

###  Q23: Growth vs. Profit Trade-off
SQL
``` 
WITH daily_revenue AS (
    SELECT DATE(order_timestamp) AS date, city, SUM(order_value - discount_amount) AS revenue FROM orders 
    WHERE order_status = 'Completed' GROUP BY 1, 2
)
SELECT 
    r.city, 
    SUM(r.revenue) AS total_revenue,
    SUM(r.revenue) - SUM(c.delivery_cost) - SUM(c.marketing_cost) - SUM(c.refunds_cost) AS profit
FROM daily_revenue r
JOIN costs c ON r.date = c.date AND r.city = c.city
GROUP BY r.city
ORDER BY profit ASC;
```
###  💡 Insight: In every city, revenue is significantly lower than the costs of marketing, delivery, and refunds .



### Key SQL Highlights

- **Total Revenue:** ₹471,511,630
- **Churn Rate:** 27.76%
- **Delivery Delay Rate:** 68.39%
- **Contribution Margin:** –₹1.19B
- **All cities are loss-making**
- **Cancellation Rate:** 7.02% (manageable)
- ** Total Completed Orders: **  836,810
- ** Net Revenue:** ₹471,511,630
- ** Highest city-level loss : **≈ ₹17.45 Cr


---

# 🧠 Final Business Diagnosis

The platform is NOT suffering from:

❌ Demand shortage  
❌ Pricing issues  
❌ Acquisition scale problems  

The platform IS suffering from:

✅ Unit economics failure  
✅ Delivery inefficiency  
✅ Refund leakage  
✅ Operational cost imbalance  
✅ Customer experience risk  

Scaling further without correcting cost structure compounds financial losses.

---

# 📈 Strategic Recommendations

## Immediate (0–3 Months)

- Improve delivery SLAs
- Reduce refund leakage
- Tighten operational cost controls

## Short-Term (3–6 Months)

- Shift budget from acquisition to retention
- Introduce loyalty programs for high-frequency users
- Optimize delivery partner agreements

## Long-Term (6–12 Months)

- Reduce cost per order below AOV
- Align marketing spend with CLTV, not CAC alone
- Rebuild unit economics before geographic expansion

---

---

# 📈 Business Impact Simulation

- If operational inefficiencies are corrected:
- Reduce delivery delays → Improve repeat rate
- Improve retention by 5% → Significant CLTV boost
- Reduce refund leakage → Direct margin recovery
- Optimize CAC by channel → Sustainable growth

# 📚 What This Project Demonstrates

- Real-world SQL analytics
- Business metric engineering
- Executive dashboard design
- KPI storytelling
- Unit economics diagnosis
- Cross-functional business thinking

--- 
# 🛠️ Technology Stack

- PostgreSQL
- Advanced SQL (CTEs, Window Functions, Aggregations)
- Power BI
- DAX Measures & KPI Engineering
- Data Modeling (Star Schema)
- Business Metric Framework
- Unit Economics Analysis

---

# 📚 What This Project Demonstrates

- Real-world SQL analytics
- Business metric engineering
- Executive dashboard design
- KPI storytelling
- Financial diagnostics
- Unit economics modeling
- Cross-functional business thinking

---

# 🎯 Ideal Roles Alignment

This project is aligned with:

- Data Analyst
- Business Intelligence Analyst
- Product Analyst
- Growth Analyst
- Operations Analyst

---

# 🔗 Live Dashboard

Power BI Service:
https://app.fabric.microsoft.com/groups/me/reports/978457cc-59a4-4fda-9a20-0be3356c8546/087e1c588a6444f94290?experience=fabric-developer
---

# ⭐ Executive Summary

Despite strong order volume and revenue scale, the platform is structurally loss-making due to delivery inefficiencies, high operational costs, and refund leakage. Sustainable growth requires correcting unit economics before further expansion.

---


##  📌 Project Overview
This project performs an end-to-end analysis of e-commerce operations. It tracks the journey from customer acquisition and order placement to delivery performance and final profitability. The analysis reveals a business scaling well in volume but facing significant operational hurdles and financial losses.


