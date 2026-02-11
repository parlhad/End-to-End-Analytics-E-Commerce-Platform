-- E-Commers_End TO END Analysis Advance Project With Bussiness Insights 

-- Table Creation Query 
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
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT,
    category TEXT,
    quantity INT,
    item_price NUMERIC(10,2)
);
CREATE TABLE deliveries (
    delivery_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    delivery_time_min INT,
    promised_time_min INT,
    is_delayed BOOLEAN,
    delivery_partner_id INT
);
CREATE TABLE support_tickets (
    ticket_id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    issue_type TEXT,
    resolution_time_hrs NUMERIC(5,2),
    compensation_amount NUMERIC(10,2)
);
CREATE TABLE marketing_spend (
    date DATE,
    channel TEXT,
    spend_amount NUMERIC(12,2),
    users_acquired INT,
    PRIMARY KEY (date, channel)
);
CREATE TABLE costs (
    date DATE,
    city TEXT,
    delivery_cost NUMERIC(12,2),
    marketing_cost NUMERIC(12,2),
    refunds_cost NUMERIC(12,2),
    PRIMARY KEY (date, city)
);

-- Que And Insights 

-- Q1) How big is the business and how active is it?

Select 
      Count(*) As total_orders,
	  Sum(order_value - discount_amount) As totale_revenue
From orders
Where order_status = 'Completed';

-- Insights :- 1) Total Orders That Are Completed is 836810
--             2) Total Revenue That Are Completed Orders 471511630.65

-- Q2)Monthly Revenue Trend (Growth Check):- Is the business growing or stagnating?

Select 
      Date_Trunc('month',order_timestamp) as month,
	  sum(order_value - discount_amount) As revenue
From orders
Where order_status = 'Completed'
group by month
order by month;

-- Q3) Is revenue driven by new users or loyal users?

 with first_orders 
 AS (
      Select customer_id,min(order_timestamp) as first_order_date
	  From orders 
	  where order_status = 'Completed'
	  group by customer_id
	  )
Select 
       Case 
	   when o.order_timestamp = f.first_order_date Then 'New'
	   Else 'Repeat'
	End As customer_type,
	count(*) as orders,
	sum(o.order_value - o.discount_amount) as revenue
from orders o
join first_orders f
on o.customer_id = f.customer_id
where o.order_status = 'Completed'
Group by customer_type;
 
-- insights :- New Users Orders 1,21,127 ordes with reveue generate 6,82,11,542 and the 
--             Repeat Users Orders 7,15,683 order with revenue 40,33,00,088 
--             Clearly our more revenu is comes and satble from repeat users

-- Q4) Churn Rate (Customer Loss):- How many customers stopped ordering?

   Select 
   
         Count(*) Filter(where is_active = 'False') :: Float
		 /Count(*)*100 as Churn_rate_per
   From customers

-- insights :- 27% customers are Chur out from our campany 

-- Q5) Delivery Delay Rate

SELECT 
    ROUND(
        (COUNT(*) FILTER (WHERE is_delayed = 'True')::FLOAT / COUNT(*) * 100)::NUMERIC, 
        2
    ) AS delivery_delay_rate
From deliveries

-- Q6) Delay Impact on Repeat Orders

 WITH delayed_customers AS (
    SELECT DISTINCT o.customer_id
    FROM orders o
    JOIN deliveries d ON o.order_id = d.order_id
    WHERE d.is_delayed = TRUE
)
SELECT
    CASE 
        WHEN c.customer_id IN (SELECT customer_id FROM delayed_customers)
        THEN 'Delayed Experience'
        ELSE 'On-time Experience'
    END AS experience_type,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'Completed'
GROUP BY 1;


--Insights :- From this we observe that  the impact on repeat orders are not stable beacuse of
-- the "Delayed_Experience " is hige repceativly the on-time Experieance , the main casue of the repeat orders is 
-- not comming cuase of delayed Experiance (835231) orders Customer  are having that delayed experence

-- Q7) Customer Acquisition Cost :- How expensive is growth? 

select * from marketing_spend

select 
     channel,
	 sum(spend_amount) as markating_expense ,
	 sum(users_acquired) as new_user_gain
from marketing_spend
group by channel

-- 2  
SELECT
    channel,
    round(SUM(spend_amount)::NUMERIC / SUM(users_acquired)::NUMERIC,2) AS cust_aqu_cost
FROM marketing_spend
GROUP BY channel;


-- insights :- 1) For customer acqusation cost is in hifher on the referral and its new customer gaining/aquireing
--                is very low as compare to other paid and organic 
--             2) Paid channel has low budget as compare  two respective other two and it gain more new custoner aquire 
--               73% 
--             3) from the above data efficient and prfoitable channle for now is paid other two are inefficient as 
--                compare to paid channel

-- Q8) CLTV :- How valuable is a customer long-term?

 Select 
      customer_id ,
	  sum(order_value - discount_amount) as life_time_revenue

from orders
where order_status = 'Completed'
group by customer_id
order by life_time_revenue desc ;

-- insights :- top highest life time valued added in our company is 15,461 , customer id  67633 
--   from this we can retain our more vlaued customers and give them benifit of loylty and discount to stick to us 
--  from this we build the more trust in customers to us 


-- Q9) CLTV vs Customer Acquisition Cost :- Are we spending more to acquire customers than they return?

  WITH cltv AS (
    SELECT customer_id,
           SUM(order_value - discount_amount) AS lifetime_value
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
)
SELECT
    c.acquisition_channel,
    AVG(cltv.lifetime_value) AS avg_cltv
FROM cltv
JOIN customers c ON cltv.customer_id = c.customer_id
GROUP BY c.acquisition_channel;


-- insights :- 1)From this Que and Query we find th insight that , how much we spend to acquire a custoem adn what 
-- he give us returns from our acquisition channel we spend the mony on them 
-- 2) so from above query we know that from every three acqistion channe are has same avg_life Time Custome Value 
--  3) so from thsi we conlclud from our markating acwusiton channle we recive sae amoount of returns so we can make adjust 
--- in our marketin acqisiton channle 


-- Q10) Contribution Margin :- Are we actually making money?

 Select * from costs

   SELECT 
    SUM(o.net_revenue) - SUM(co.total_daily_costs) AS Contribution_margin_revenue
FROM (
SELECT 
        DATE(order_timestamp) as order_date, 
        city, 
        SUM(order_value - discount_amount) as net_revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY 1, 2
) o
JOIN (
    SELECT 
        date, 
        city, 
        SUM(delivery_cost + marketing_cost + refunds_cost) as total_daily_costs
    FROM costs
    GROUP BY 1, 2
) co 
ON o.order_date = co.date AND o.city = co.city;

-- insights :- 1) Are we actually making money? answer is "NO" beasue our contribution_margine_revenu in in
--             -1,19,34,67,022 
--             2) we guys are in big losss because of the money we spend is more that we genreate revenue
      --        * we want to cut to discoutns,delevery,markaeting and refunds cost it the way more hgher it 
	  --            is very risky at thsi time and also long term , we cant servive if this goes we need to fix this 

-- Q11)Loss-Making Cities :-Where should we STOP investing?

  select 
       co.city,
 (rev.net_revenue)-(co.total_costs)  AS city_profit
  From (
     SELECT  
        city, 
        SUM(delivery_cost + marketing_cost + refunds_cost) as total_costs
    FROM costs
    GROUP BY  city
	order by total_costs desc
) co
join
(
	SELECT 
        city, 
        SUM(order_value - discount_amount) as net_revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY city
	order by net_revenue desc
	)rev
	on co.city = rev.city
group by co.city,co.total_costs,rev.net_revenue
order by city_profit desc;


-- insights :- from the above query we gain a insights the 7 city 

select 
       co.city,
 (co.total_costs) - (rev.net_revenue) AS city_loss
  From (
     SELECT  
        city, 
        SUM(delivery_cost + marketing_cost + refunds_cost) as total_costs
    FROM costs
    GROUP BY  city
	order by total_costs desc
) co
join
(
	SELECT 
        city, 
        SUM(order_value - discount_amount) as net_revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY city
	order by net_revenue desc
	)rev
	on co.city = rev.city
group by co.city,co.total_costs,rev.net_revenue
order by city_loss desc;


-- Q 12) Refund-Heavy Customers :- Which customers destroy margin?

Select 
  customer_id,
  Sum(compensation_amount) as total_refund
From support_tickets
Group By customer_id
having Sum(compensation_amount) > 500
order by total_refund desc;

-- insights :- From this the compensation Amount we pay to a custome more that 500 are 250 sudtomer
-- for this we need to fix our refund policy 


--Q13) Average Order Value (AOV) :- Are customers spending more or less per order?

SELECT
    ROUND(
        SUM(order_value - discount_amount) / COUNT(*),
        2
    ) AS avg_order_value
FROM orders
WHERE order_status = 'Completed';


-- Insights :- Average Order Value Of customer is 563 ,its is low-medium we need more customer who sped mony and 
-- we need to fix the disscount as well 

--Q14) AOV by Acquisition Channel :- Which channel brings higher-quality customers?

Select 
c.acquisition_channel,
Round
(
Avg(o.order_value - o.discount_amount),2) as Avg_aov
from orders o
join customers c 
on o.customer_id = c.customer_id
where o.order_status = 'Completed'
Group by c.acquisition_channel;


-- insihgts :- From the 3 acquisition_channel ther are all at same level of average 
-- order value in the paid and organic share same aov and the reffera has -1 only 
-- so the higher sped money custome are not come from any acquisition_channel ther are same at ow
-- we need to make sure our money goes in right and return to us 


-- Q15) Order Frequency per Customer(engement)

Select 
     customer_id,
	 Count(order_id) as total_orders
From orders
where order_status = 'Completed'
group by customer_id
order by total_orders desc;


/* imsights : we a a customer that orders a 20 orders frequently that is a highest
number or frequently return orders
To keep them more active and do order we need to give them a befite for ordering in 
like discount ,coupend ,gift,off so they stick with us long time 

*/


-- Q16) Top 20% Customers Contribution (80–20 Rule)
WITH customer_revenue AS (

 SELECT
        customer_id,
        SUM(order_value - discount_amount) AS revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
),
ranked As (
select *,
        NTILE(5) Over(order by revenue Desc) as bucket
from customer_revenue
)
select 
         bucket,
         sum(revenue) as revenue
from ranked
group by bucket
order by bucket;

-- Q17) Cancellation rate

select 
  ROUND(
        (COUNT(*) FILTER (WHERE order_status = 'Cancelled')::FLOAT / COUNT(*) * 100)::NUMERIC, 
        2
    ) AS  cancellaton_rate
	  
from orders

/* insights :- The Cancellation rate is is only 7.02 % means it is not that much harmfull or risky ita good 
*/
-- Q 18) City-wise Delivery Performance

Select 
    o.city, 
    ROUND(AVG(d.delivery_time_min)::numeric, 2) AS avg_delivery_time, 
    ROUND(
        (COUNT(*) FILTER (WHERE d.is_delayed = TRUE)::float / COUNT(*) * 100)::numeric, 
        2
    ) AS delay_percentage 
FROM deliveries d 
JOIN orders o ON d.order_id = o.order_id 
GROUP BY o.city 
ORDER BY delay_percentage DESC;

-- insights :- Avg delivery time and delay percentage is near around same of all the cities


--Q19) Complaint Rate per 100 Orders

SELECT
    ROUND(
        (COUNT(st.ticket_id)::float / COUNT(o.order_id) * 100)::numeric, 
        2
    ) AS complaints_per_100_orders
FROM orders o
LEFT JOIN support_tickets st
  ON o.customer_id = st.customer_id
WHERE o.order_status = 'Completed';

/* Insights :- Complain rate per 100 Order IS 73% 
  we need to fix the cpmplaints of customers 
  so our return orders increasees 
  the customer care and hepl service provide fast and efficeint to customers
*/

-- Q 20) Resolution Time Impact

SELECT
    CASE
        WHEN resolution_time_hrs <= 6 THEN 'Fast Resolution'
        ELSE 'Slow Resolution'
    END AS resolution_type,
    COUNT(DISTINCT customer_id) AS customers
FROM support_tickets
GROUP BY 1;


-- Q21) What are The  issue of the customers

 select
      distinct(issue_type),
      count (issue_type)
from support_tickets
group by issue_type;


-- isights :- Most Issue_Type Is "Late Delivery " 53874  customer said isuues is late delivery 


-- Q22) Profit per Order

  SELECT
    o.order_id,
    (o.order_value - o.discount_amount)
    - (co.delivery_cost
    + co.refunds_cost) AS profit_per_order
FROM orders o
JOIN costs co
  ON DATE(o.order_timestamp) = co.date
 AND o.city = co.city
WHERE o.order_status = 'Completed';


-- Q 23) Growth vs Profit Trade-off

  WITH daily_revenue AS (
    SELECT
        DATE(order_timestamp) AS date,
        city,
        SUM(order_value - discount_amount) AS revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY DATE(order_timestamp), city
)
SELECT
    r.city,
    SUM(r.revenue) AS total_revenue,
    SUM(r.revenue)
      - SUM(c.delivery_cost)
      - SUM(c.marketing_cost)
      - SUM(c.refunds_cost) AS profit
FROM daily_revenue r
JOIN costs c
  ON r.date = c.date
 AND r.city = c.city
GROUP BY r.city
ORDER BY profit ASC;

-- insight = the reveny is far low thatn a cost we put in marketing,delivery,and other his high 174541795 loss is highest nar all are smae 