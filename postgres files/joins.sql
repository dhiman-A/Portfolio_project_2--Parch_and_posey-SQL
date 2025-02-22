SELECT orders.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

SELECT accounts.name, orders.occurred_at
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

SELECT *
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

--4.	Try pulling all the data from the accounts table, and all the data from the orders table.
SELECT *
FROM accounts
JOIN orders
ON accounts.id = orders.account_id;

--5.	Try pulling standard_qty, gloss_qty, and poster_qty from the orders table, and the website and the primary_poc from the accounts table.
SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty,accounts.website, accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

--6. if you were to join the web_events, accounts and orders table how would you do it?
SELECT *
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
JOIN orders
ON accounts.id = orders.account_id;

--7.	 Pull specific columns from any of the three tablesee tables
SELECT web_events.channel, accounts.name, orders.total
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
JOIN orders
ON accounts.id = orders.account_id;

/*When performing JOINS, it is easiest to give table names aliases. The aliases for a table will be created in the from
and join clauses. Once we have given these aliases, we can refer to columns in the select clause by using those alias names. 
Generally, the first character of the table name is chosen as the alias.*/
SELECT o.*, a.*
FROM orders o
JOIN accounts a
ON o.account_id = a.id;

/*
8.	Provide a table for all web_events associated with account name of Walmart. There should be three columns. Be sure to include
the primary_poc, time of the event, and the channel for each event. Additionally, you might choose to add a fourth column to assure
only Walmart events were chosen.
*/
SELECT accounts.name, accounts.primary_poc, web_events.occurred_at, web_events.channel
FROM accounts
JOIN web_events
ON accounts.id = web_events. account_id
WHERE accounts.name LIKE 'Walmart';

/*
9.	Provide a table that provides the region for each sales_rep along with their associated accounts. Your final table should include
three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
*/
SELECT region.name AS region_name, sales_reps.name AS sales_reps_name, accounts.name AS accounts_name
FROM region
JOIN sales_reps
ON region.id = sales_reps.region_id
JOIN accounts 
ON sales_reps.id = accounts.sales_rep_id
ORDER BY accounts.name;

/*
10.	Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for
the order. Your final table should have 3 columns: region name, account name, and unit price. A few accounts have 0 for total, so I divided
by (total + 0.01) to assure not dividing by zero.
*/
SELECT region.name AS region_name,accounts.name AS account_name, (orders.total_amt_usd/(orders.total+ 0.01)) AS unit_price
FROM region
JOIN sales_reps ON region.id = sales_reps.region_id
JOIN accounts ON sales_reps.id = accounts.sales_rep_id
JOIN orders ON accounts.id = orders.account_id;

/*
11.	Suppose you want to check all the orders that were brought by one particular sales rep. Imagine yourself as a sales rep at Parch and Posey.
You’d like to make it easy for a sales rep to find her own data deals rather than having to sift through all the orders and try and remember
which were hers. sales_rep_id isn’t in the orders table so join is necessary to get that information. The first thing to do this is by using
the WHERE clause:
*/
SELECT orders.*, accounts.*
FROM orders
LEFT JOIN accounts ON orders.account_id = accounts.id
WHERE accounts.sales_rep_id = 321500;

/*
12.	Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for the Midwest region. 
Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z)
according to account name.
*/
SELECT region.name AS region_name, sales_reps.name AS sales_rep_name, accounts.name AS accounts_name
FROM region
JOIN sales_reps ON region.id = sales_reps.region_id
JOIN accounts ON sales_reps.id = accounts.sales_rep_id
WHERE region.name = 'Midwest'
ORDER BY accounts.name;

/*
13.	Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep
has a first name starting with S and in the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the
account name. Sort the accounts alphabetically (A-Z) according to account name.
*/
SELECT region.name AS region_name, sales_reps.name AS sales_reps_name, accounts.name AS accounts_name
FROM sales_reps
JOIN region ON sales_reps.region_id = region.id 
JOIN accounts ON accounts.sales_rep_id =  sales_reps.id
WHERE sales_reps.name LIKE 'S%' AND region.name = 'Midwest'
ORDER BY accounts.name;

/*
14.	Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales
rep has a last name starting with K and in the Midwest region. Your final table should include three columns: the region name, the sales rep name, 
and the account name. Sort the accounts alphabetically (A-Z) according to account name.
*/
SELECT region.name AS region_name, sales_reps.name AS sales_rep_name, accounts.name AS accounts_name
FROM sales_reps
JOIN region ON sales_reps.region_id = region.id
JOIN accounts ON sales_reps.id =  accounts.sales_rep_id
WHERE sales_reps.name LIKE '%K%' and region.name = 'Midwest'
ORDER BY accounts.name; 

/*
15.	Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
However, you should only provide the results if the standard order quantity exceeds 100. Your final table should have 3 columns: region name, account name,
and unit price. In order to avoid a division by zero error, adding .01 to the denominator here is helpful total_amt_usd/(total+0.01).
*/
SELECT region.name AS region_name, accounts.name AS accounts_name, orders.total_amt_usd/(orders.total+0.01) AS unit_price
FROM region
JOIN sales_reps ON  sales_reps.region_id = region.id
JOIN accounts ON accounts.sales_rep_id = sales_reps.id
JOIN orders on orders.account_id = accounts.id
WHERE orders.standard_qty > 100;

/*
16.	Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order.
However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table 
should have 3 columns: region name, account name, and unit price. Sort for the smallest unit price first. In order to avoid a division by zero error, 
adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).
*/
SELECT region.name AS region_name, accounts.name AS accounts_name, orders.total_amt_usd/(orders.total+0.01) AS unit_price
FROM region
JOIN sales_reps ON sales_reps.region_id = region.id
JOIN accounts ON accounts.sales_rep_id = sales_reps.id
JOIN orders ON orders.account_id = accounts.id
WHERE orders.standard_qty > 100 AND orders.poster_qty >50
ORDER BY unit_price;

/*
17.	What are the different channels used by account id 1001? Your final table should have only 2 columns: account name and the different channels.
You can try SELECT DISTINCT to narrow down the results to only the unique values.
*/
SELECT DISTINCT web_events.channel, accounts.name
FROM accounts
JOIN web_events ON accounts.id = web_events.account_id
WHERE accounts.id ='1001';

/*
18.	Find all the orders that occurred in 2015. Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd.
*/
SELECT orders.occurred_at, accounts.name, orders.total, orders.total_amt_usd
FROM accounts
JOIN orders ON orders.account_id = accounts.id
WHERE orders.occurred_at BETWEEN '01-01-2015' AND '31-12-2015'
ORDER BY orders.occurred_at DESC;








































