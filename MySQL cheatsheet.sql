/* */
SELECT channel, account_id, occurred_at
FROM web_events
LIMIT 15

/* DESC,ASC  */

SELECT id, occurred_at,total_amt_usd
FROM orders
ORDER BY occurred_at /*DESC for LATEST(newest) OR LARGEST, by default it is ASC from earliest(oldest) OR smallest OR ABC */
LIMIT 10;

/*   */

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC; /* priority for account_id because it is first */

/* >,=  */
SELECT * /*selects everything */
FROM orders
WHERE gloss_amt_usd >= 1000 
LIMIT 5;

/* search a single name,WHERE  */
SELECT name,website,primary_poc
FROM accounts
WHERE name = 'Exxon Mobil' /* to select names */

/*  making a column with arithmetic */
SELECT id,account_id,standard_amt_usd/standard_qty as ratio /* do arithmetic and call column 'ratio' */
FROM orders
LIMIT 10; /* we put semicolon when we end program */

/*   */
SELECT id,account_id,
(poster_amt_usd/(standard_amt_usd+gloss_amt_usd+poster_amt_usd)*100) AS poster_revenue /*Arithmetic Statements */
FROM orders
LIMIT 10;

/*  LIKE */
SELECT name
FROM accounts
WHERE name LIKE 'C%' /* All the companies whose names start with 'C'.  */

SELECT name
FROM accounts
WHERE name LIKE '%one%' /* All companies whose names contain the string 'one' somewhere in the name.  */


SELECT name
FROM accounts
WHERE name LIKE '%s' /* All companies whose names end with 's'. */

/* search multiple names */
SELECT name,website,primary_poc,sales_rep_id
FROM accounts
WHERE name IN ('Target','Nordstrom')

/* NOT */
SELECT name,website,primary_poc,sales_rep_id
FROM accounts
WHERE name NOT IN ('Target','Nordstrom') /* Does the complete opposite of previous statement */

/* AND */
SELECT *
FROM orders
WHERE standard_qty >1000 AND poster_qty=0 AND gloss_qty=0

SELECT name
FROM accounts
WHERE name NOT LIKE 'C%' AND name LIKE '%s' /* Using the accounts table, find all the companies whose names do not start with 'C' and end with 's'.*/

/*BETWEEN,DATE*/

SELECT occurred_at,gloss_qty
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29

SELECT occurred_at,gloss_qty
FROM orders
WHERE gloss_qty >=24 AND gloss_qty <=29 /* which is same as BETWEEN */

SELECT occurred_at,channel
FROM web_events
WHERE channel IN ('organic','adwords') AND occurred_at BETWEEN '2016-01-01' AND '2016-12-31' /* Find range of dates */
ORDER BY occurred_at DESC

/* OR */
SELECT *
FROM orders
WHERE standard_qty=0 AND (gloss_qty>1000 or poster_qty>1000)  /* Write a query that returns a list of orders where the standard_qty is zero and either the gloss_qty or poster_qty is over 1000. */

SELECT *
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%') AND (primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%') AND (primary_poc NOT LIKE '%eana%')
/* Find all the company names that start with a 'C' or 'W', and the primary contact contains 'ana' or 'Ana', but it doesn't contain 'eana'. */

/* JOIN  */
SELECT orders.* , /* SELECT basically shows you what you want to see */
accounts.* /*add other file to main file orders*/
FROM orders /* our main file is orders */
JOIN accounts /* other file is accounts */
ON orders.account_id = accounts.id; /* we have id in accounts and id in orders, id in accounts replaces id in orders because there are 2 */


/* ALIAS */
SELECT a.primary_poc, w.occurred_at, w.channel, a.name /* what you want to show */
FROM web_events w /* Give Alias in From & JOIN */
JOIN accounts a
ON w.account_id = a.id /* Link between tables */
WHERE a.name = 'Walmart'; /*which name you want */

/* linking 3 tables */
/* we have 3 tables, so we need to connect them
in order of ON,always start with ON */
SELECT r.name region,s.name sales_rep,a.name account /* always 1 SELECT , also make sure you give the column names so they appear*/

FROM sales_reps s /* always 1 FROM, notice that sales_rep is link between r and s*/
JOIN region r
ON s.region_id=r.id /*stp1)sequence 1*/

JOIN accounts a
ON a.sales_rep_id=s.id /*stp2)sequence 2 */
ORDER BY a.name

/* linking 4 tables */
SELECT r.name region_name, a.name account_name,o.total_amt_usd/(o.total+0.01) AS unit_price
/*Note, accounts is in the middle, so FROM accounts */
FROM accounts a
JOIN orders o
ON a.id=o.account_id /* Link o and a */

JOIN sales_reps s 
ON s.id=a.sales_rep_id /* Link s and a */

JOIN region r 
ON r.id=s.region_id /* Link r and s ,now all are connected in 1 line which is o,a,s,r*/

/* 2nd name starts with a letter K */
WHERE r.name = 'Midwest' AND s.name LIKE '% K%' 

/* DISTINCT  */
SELECT DISTINCT a.name, w.channel /* SELECT DISTINCT to narrow down the results to only the unique values. */
 

/* NULL  */
WHERE primary_poc IS NULL /*If you are looking for nulls, IS NOT NULL if you don’t want nulls */

/* COUNT  */
SELECT COUNT(*) */ counts number of non nulls */

/*MIN,MAX,AVG */
SELECT MIN(occurred_at)  /*get the earliest date */
FROM orders

/* This is equivalent of */
SELECT *
FROM orders
ORDER BY occurred_at
LIMIT 1

/* GROUP BY */
SELECT a.name,SUM(o.total) AS total_sales
from accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY a.name /*find the total sales of every account , so for example instead of having multiple walmart it adds them all up into a single walmart*/


SELECT a.name,MIN(o.total_amt_usd) AS smallest_order /* Takes the minumum order out of each account and puts in a column, so if walmart has 0,3,4 then it picks 0 */
FROM accounts a
JOIN orders o
ON a.id=account_id
GROUP BY a.name
ORDER BY total



SELECT r.name, COUNT(*) num_reps /* count how many each region has id’s */
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
GROUP BY r.name
ORDER BY num_reps;

SELECT s.name,w.channel,COUNT(*) occ 
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id=s.id
JOIN web_events w
ON w.account_id=a.id
GROUP BY s.name,w.channel /*if we have multiple group by’s */
ORDER BY occ

/*HAVING*/
SELECT s.id,s.name,COUNT(*) no_of_acc_managed /* counts number of accounts managed by each sales rep */
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id=s.id
GROUP BY s.name,s.id
HAVING COUNT(*) > 5 /*Finds which sales rep has more than 5 accounts managed */
ORDER BY no_of_acc_managed 

/*HAVING, AND*/
HAVING COUNT(*)>6 AND w.channel='facebook'

/*Order by year ,DATE*/
SELECT DATE_PART('year',occurred_at),SUM(total_amt_usd) FROM orders
GROUP BY 1 
ORDER BY 2 DESC
/* you can also use DATE_TRUNC for another format,DATE TRUNC includes the day, month and year and seperates same days from different days but DATE_PART
 organizes the days together regardless of years*/

/*CASE*/
SELECT account_id, total_amt_usd, 
CASE WHEN total_amt_usd > 3000 THEN 'Large' ELSE 'Small' END AS order_level 
FROM orders;


SELECT  
CASE WHEN total >= 2000 THEN 'Atleast 2000'      
           WHEN total >= 1000 AND total <2000 THEN 'Between 1000 and 2000'      
          WHEN total < 1000 THEN 'Less than 1000' END AS order_lvl, /*  ELSE 'Less than 1000' END AS order_lvl */
          COUNT(*)  
FROM orders  
GROUP BY 1

/* Subquery */
SELECT channel,AVG(event_count) AS avg_event_count /* Finds the avg event count per day for every channel */
FROM 
(SELECT DATE_TRUNC('day',occurred_at) AS day,channel,COUNT(*) AS event_count
FROM web_events
GROUP BY 1,2
ORDER BY day
/* This code finds the number of events that occur for each day for each channel*/
 )sub /* This is the name of the subquery */
GROUP BY 1
ORDER BY 2 DESC

/* WITH */
‭WITH t1 AS (‬ /*function 1 , finds the avg of all channels*/
   SELECT AVG(o.total_amt_usd) avg_all
   FROM orders o
   JOIN accounts a
   ON a.id = o.account_id),
t2 AS (  /*function 2, finds the channels bigger than the average */
   SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
   FROM orders o
   GROUP BY 1
   HAVING AVG(o.total_amt_usd) > (SELECT * FROM t1))
SELECT AVG(avg_amt) /*function 3 , averages out channels bigger than the average*/
FROM t2;

/* LEFT,RIGHT capture */
SELECT RIGHT(website, 3) AS domain,COUNT(*)
FROM accounts
GROUP BY 1