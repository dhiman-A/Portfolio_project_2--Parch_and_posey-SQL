SELECT *
FROM accounts
WHERE id>1500 AND id< 1600;

/*
1.	Find the count of orders that occurred between 2016-12-01 and 2016-12-31.
*/
SELECT COUNT (*) as order_count
FROM orders
WHERE occurred_at BETWEEN '2016-12-01' AND '2016-12-31';

/*
2.Imagine yourself as the manager at Parch and Posey. You are trying to do some inventory planning, and you want to know how much of each paper
type to produce. A good place to start might be to total up all sales of each paper type and compare them to one another. 
*/
SELECT SUM(standard_qty) AS standard, SUM(gloss_qty) AS gloss, SUM (poster_qty) AS poster
FROM orders;

/*
3.Find the total amount of poster_qty paper ordered in the orders table.
*/
SELECT SUM(poster_qty) as poster_qty
FROM orders;

/*
4.	Find the total amount of standard_qty paper ordered in the orders table.
*/
SELECT SUM(standard_qty) as standard_qty
FROM orders;

/*
5. Find the total dollar amount of sales using the total_amt_usd in the orders table.
*/
SELECT SUM(total_amt_usd) AS total_sales
FROM orders;

/*
6.	Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table.
This should give a dollar amount for each order in the table.
*/
SELECT SUM(standard_amt_usd) AS standard_amt, SUM(gloss_amt_usd) ASgloss_amt
FROM orders;

/*
7.	Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both an aggregation
and a mathematical operator.
*/
SELECT SUM(standard_amt_usd/(standard_qty+0.01)) AS unit_price_standard
FROM orders;

SELECT MIN(standard_qty) AS standard_min,
	MIN(gloss_qty) AS gloss_min,
	MIN(poster_qty) AS poster_min,
	MAX(standard_qty) AS standard_max,
	MAX(gloss_qty) AS gloss_max,
	MAX(poster_qty) AS poster_max
FROM orders;

/*
8. What’s the average order size?
*/
SELECT AVG(standard_qty) AS standard_avg,
	AVG(gloss_qty) AS gloss_avg,
	AVG (poster_qty) AS poster_avg
FROM orders;

/*
9.	When was the earliest order ever placed? You only need to return the date.
*/
SELECT MIN(occurred_at)
FROM orders;

/*
10.	Try performing the same query as above without using an aggregation function.
*/
SELECT occurred_at
FROM orders
ORDER BY occurred_at 
LIMIT 1;

/*
11.	When did the most recent (latest) web_event occur?
*/
SELECT MAX(occurred_at)
FROM web_events;

/*
12.	Try to perform the result of the previous query without using an aggregation function.
*/
SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;

/*
13.	Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order.
Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.
*/
SELECT AVG(standard_qty) AS standard_avg,
	AVG(poster_qty) AS poster_avg,
	AVG (gloss_qty) AS gloss_avg,
	AVG(standard_amt_usd) AS standard_amt_avg,
	AVG(gloss_amt_usd) AS gloss_amt_avg,
	AVG(poster_amt_usd) AS poster_amt_avg
FROM orders;

/*
As a sales manager, you might want to sum all of the sales of each paper type for each account. Group by allows you to create segments that will
aggregate independently of one another. In other words, group by allows you to take the sum of data limited to each account rather than across
the entire dataset.
We want to tell the query to aggregate into segments, where each segment is one of the values in the account id column. Do this using
GROUP BY clause.
*/
SELECT account_id,
SUM (standard_qty) AS standard_sum,
SUM (gloss_qty) AS gloss_sum,
SUM (poster_qty) AS poster_sum
FROM orders
GROUP BY account_id
ORDER BY account_id;


/*
15.	Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.
*/
SELECT accounts.name AS account_name, web_events.occurred_at AS date
FROM accounts
JOIN web_events ON accounts.id = web_events.account_id
ORDER BY web_events.occurred_at
LIMIT 1;

/*
16.	Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd and
the company name.
*/
SELECT accounts.name, SUM(total_amt_usd) AS total_sales
FROM orders
JOIN accounts ON accounts.id = orders.account_id
GROUP BY accounts.name;

/*
17.	Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? Your query should
return only three values - the date, channel, and account name.
*/
SELECT web_events.occurred_at, web_events.channel, accounts.name
FROM web_events
JOIN accounts ON web_events.account_id = accounts.id
ORDER BY web_events.occurred_at DESC
LIMIT 1;

/*
18.	Find the total number of times each type of channel from the web_events was used. Your final table should have two columns - the
channel and the number of times the channel was used.
*/
SELECT web_events.channel, COUNT(*)
FROM web_events
GROUP BY web_events.channel;

/*
19.	Who was the primary contact associated with the earliest web_event?
*/
SELECT accounts.primary_poc
FROM accounts
JOIN web_events ON accounts.id = web_events.account_id
ORDER BY web_events.occurred_at DESC
LIMIT 1;

/*
20.	What was the smallest order placed by each account in terms of total usd. Provide only two columns - the account name and the total usd.
Order from smallest dollar amounts to largest.
*/
SELECT accounts.name, MIN(orders.total_amt_usd) AS smallest_order
FROM accounts
JOIN orders ON accounts.id = orders.account_id
GROUP BY accounts.name
ORDER BY smallest_order;

/*
21.	Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps.
Order from fewest reps to most reps.
*/
SELECT region.name, COUNT(*) AS num_reps
FROM region
JOIN sales_reps
ON region.id = sales_reps.region_id
GROUP BY region.name
ORDER BY num_reps;


SELECT account_id, channel, COUNT(id) AS events
FROM web_events
GROUP BY account_id, channel
Order by account_id, channel;

/*
22.	For each account, determine the average amount of each type of paper they purchased across their orders. Your result should have four 
columns - one for the account name and one for the average quantity purchased for each of the paper types for each account.
*/
SELECT a.name, AVG(o.standard_qty) AS avg_standard, AVG(o.poster_qty) AS avg_poster, AVG(o.gloss_qty) AS avg_gloss
FROM accounts AS a 
JOIN orders AS o
ON  a.id= o.account_id
GROUP BY a.name;

/*
23.	For each account, determine the average amount spent per order on each paper type. Your result should have four columns - one for the account
name and one for the average amount spent on each paper type.
*/
SELECT a.name AS account_name, 
AVG(o.standard_amt_usd) AS avg_standard_amt,
AVG(o.gloss_amt_usd) AS avg_gloss_amt,
AVG(o.poster_amt_usd) AS avg_poster_amt	
FROM orders AS o
JOIN accounts AS a
ON o.account_id = a.id
GROUP BY A.name;

/*
24.	Determine the number of times a particular channel was used in the web_events table for each sales rep. Your final table should have three
columns - the name of the sales rep, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
*/
SELECT s.name AS sales_reps_name, w.channel AS web_events_channel, COUNT(*) AS num_events
FROM web_events AS w
JOIN accounts AS a
ON w.account_id = a.id
JOIN sales_reps AS s
ON a.sales_rep_id = s.id
GROUP BY sales_reps_name, web_events_channel
ORDER BY num_events DESC;

/*
25.	Determine the number of times a particular channel was used in the web_events table for each region. Your final table should have three
columns - the region name, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
*/
SELECT r.name as region_name, w.channel AS web_events_channel, COUNT(*) AS num_events
FROM accounts AS a
JOIN web_events AS w
ON a.id = w.account_id
JOIN sales_reps AS s
ON s.id = a.sales_rep_id
JOIN region AS r
ON r.id = s.region_id
GROUP BY region_name, web_events_channel
ORDER BY num_events DESC;

/*
26.	Use DISTINCT to test if there are any accounts associated with more than one region.
*/

SELECT DISTINCT id, name
FROM accounts;

/*
27.	Have any sales reps worked on more than one account?
*/
SELECT DISTINCT id, name
FROM sales_reps;

/*
Imagine yourself as an account manager at Parch and Posey, working with the company’s largest accounts. You might want to identify the total sales
in US dollars for accounts with over $250000 in sales, to better understand the proportion of revenue that comes from these large accounts.
*/
SELECT account_id, SUM(total_amt_usd) AS sum_total_amt_usd
FROM orders
GROUP BY 1
HAVING SUM(total_amt_usd) >= 250000;

/*
28.	How many of the sales reps have more than 5 accounts that they manage?
*/
SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts AS a 
JOIN sales_reps AS s
ON a.sales_rep_id = s.id
GROUP BY s.id, s.name
HAVING COUNT(*)>5
Order BY num_accounts;

/*
29.	How many accounts have more than 20 orders?
*/
SELECT a.id, a.name, COUNT(*) num_orders
FROM accounts AS a
Join orders AS o
ON a.id = o.account_id
GROUP BY a.id , a.name
HAVING COUNT(*) >20
ORDER BY num_orders;

/*
30.	Which account has the most orders?
*/
SELECT a.id, a.name, COUNT(*) num_orders
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY num_orders DESC
LIMIT 1;

/*
31.	How many accounts spent more than 30,000 usd total across all orders?
*/
SELECT a.id, a.name, SUM(o.total_amt_usd) AS total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY total_spent;

/*
32.	How many accounts spent less than 1,000 usd total across all orders?
*/
SELECT a.id, a.name, SUM(o.total_amt_usd) AS total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY total_spent;


/*
33.	Which account has spent the most with us?
*/
SELECT a.id, a.name, SUM(o.total_amt_usd) AS total_spent
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent DESC
LIMIT 1;

/*
34.	Which account has spent the least with us?
*/
SELECT a.id, a.name, SUM(o.total_amt_usd) AS total_spent
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent
LIMIT 1;

/*
35.	Which accounts used facebook as a channel to contact customers more than 6 times?
*/
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts AS a
JOIN web_events AS w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
Having COUNT(*) >6 AND w.channel = 'facebook'
ORDER BY use_of_channel;

/*
36.	Which account used facebook more as a channel?
*/
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts AS a
JOIN web_events AS w
ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 1;

/*
37.	Which channel was most frequently used by most accounts?
*/
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts AS a
JOIN web_events AS w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 10;

SELECT occurred_at, SUM(standard_qty) AS standard_qty_sum
FROM orders
GROUP BY occurred_at
ORDER BY occurred_at;

SELECT DATE_TRUNC('day', occurred_at) AS day, SUM(standard_qty) AS standard_qty_sum
FROM orders
GROUP BY DATE_TRUNC('day', occurred_at)
ORDER BY DATE_TRUNC('day', occurred_at);

/*
On what day of the week are the most sales made?
*/
SELECT DATE_PART('dow', occurred_at) AS day_of_week, SUM(total) AS total_qty
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

/*
38.	Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends
in the yearly sales totals?
*/
SELECT DATE_PART('year', occurred_at) AS ord_year, SUM(total_amt_usd) AS total_spent
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

/*
39. Which month did Parch & Posey have the greatest sales in terms of total dollars? 
Are all months evenly represented by the dataset?
*/
SELECT DATE_PART('month', occurred_at) AS ord_month, SUM(total_amt_usd) AS total_spent
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;

/*
40.	Which year did Parch and Posey have the greatest sales in terms of total number of orders? Are all years evenly represented
by the dataset?
*/
SELECT DATE_PART('year', occurred_at) AS ord_year, COUNT(*) AS total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

/*
41.	Which month did Parch & Posey have the greatest sales in terms of total number of orders? Are all months evenly represented
by the dataset?
*/
SELECT DATE_PART('month', occurred_at) AS ord_month, COUNT(*) AS total_sales
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;

/*
42.	In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
*/
SELECT DATE_TRUNC('month', o.occurred_at) AS ord_date, SUM(o.gloss_amt_usd) AS tot_spent
FROM orders AS o
JOIN accounts AS a
ON a.id = o.account_id
WHERE a.name ='Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

SELECT id, account_id, occurred_at, channel, CASE WHEN channel ='facebook' THEN 'yes' ELSE 'no' END AS is_facebook
FROM web_events
ORDER BY occurred_at;

SELECT id, account_id, occurred_at, channel, 
CASE WHEN channel ='facebook' OR channel = 'direct' THEN 'yes' ELSE 'no' END AS is_facebook
FROM web_events
ORDER BY occurred_at;

SELECT account_id, 
	   occurred_at, 
	   total,
	   CASE WHEN total > 500 THEN 'Over 500'
            WHEN total > 300 THEN '301-500'
			WHEN total > 100 THEN '101-300'
			ELSE '100 or under' END AS total_group
FROM orders;


SELECT 
    CASE 
        WHEN total > 500 THEN 'Over 500'
        ELSE '500 or under' 
    END AS total_group,
    COUNT(*) AS order_count
FROM orders
GROUP BY 
    CASE 
        WHEN total > 500 THEN 'Over 500'
        ELSE '500 or under' 
    END
ORDER BY 1;

/*
43.	Write a query to display for each order, the account ID, total amount of the order, and the level of the 
order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller than $3000.
*/
SELECT o.account_id, o.total,
	CASE 
		WHEN o.total >= 3000 THEN 'Large'
		ELSE 'Small'
		END AS order_level
FROM orders AS o
ORDER BY 1;

/*
44.	Write a query to display the number of orders in each of three categories, based on the total number of items in each order. 
The three categories, based on the total number of items in each order. The three categories are : ‘Atleast 2000’, 
‘Between 1000 and 2000’ and ‘Less than 1000’.
*/
SELECT 
	CASE WHEN o.total >= 2000 THEN 'At Least 2000'
	WHEN o.total  BETWEEN 1000 AND 1999 THEN 'Between 1000 AND 2000'
	WHEN o.total <1000 THEN 'Lesss than 1000'
END AS order_category,
	COUNT(*) AS order_count
FROM orders AS o
GROUP BY 1;

/*
45.	We would like to understand 3 different branches of customers based on the amount associated with their purchases. 
The top branch includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. The second branch 
is between 200,000 and 100,000 usd. The lowest branch is anyone under 100,000 usd. Provide a table that includes the level 
associated with each account. You should provide the account name, the total sales of all orders for the customer, and the level. 
Order with the top spending customers listed first.
*/
SELECT a.name, SUM(total_amt_usd) AS total_spent,
	CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
	WHEN SUM(total_amt_usd) > 100000 THEN 'middle'
	ELSE 'low'
	END AS customer_level
FROM orders AS o
JOIN accounts AS a
ON o.account_id = a.id
GROUP by a.name
ORDER BY 2 DESC;

/*
46.	We would now like to perform a similar calculation to the first, but we want to obtain the total amount spent by customers only
in 2016 and 2017. Keep the same levels as in the previous question. Order with the top spending customers listed first.
*/
SELECT a.name, SUM(total_amt_usd) AS total_spent,
CASE WHEN SUM(TOTAL_AMT_USD) > 200000 THEN 'top'
WHEN SUM(total_amt_usd) > 100000 THEN 'middle'
ELSE 'low' END AS customer_level
FROM orders AS o
JOIN accounts AS a
ON o.account_id = a.id
WHERE occurred_at > '2015-12-31'
GROUP BY 1
ORDER BY 2 DESC;

/*
47.	We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders. 
Create a table with the sales rep name, the total number of orders, and a column with top or not depending on if they 
have more than 200 orders. Place the top sales people first in your final table.
*/
SELECT s.name, COUNT(*) num_orders, 
CASE WHEN COUNT(*) > 200 THEN 'top' 
ELSE 'not' 
END AS sales_rep_level
	FROM orders AS o
	JOIN accounts AS a
ON o.account_id = a.id
JOIN sales_reps AS s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY 2 DESC;

/*
48.	The previous didn't account for the middle, nor the dollar amount associated with the sales. Management decides they want 
to see these characteristics represented as well. We would like to identify top performing sales reps, which are sales reps 
associated with more than 200 orders or more than 750000 in total sales. The middle group has any rep with more than 150 orders 
or 500000 in sales. Create a table with the sales rep name, the total number of orders, total sales across all orders, and a column 
with top, middle, or low depending on this criteria. Place the top sales people based on dollar amount of sales first in your 
final table.
*/
SELECT s.name, COUNT(*), SUM(o.total_amt_usd) total_spent,
	CASE WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'top'
	WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) > 750000 THEN 'middle'
	ELSE 'low' END AS sales_rep_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id
Join sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY 3 DESC;










































