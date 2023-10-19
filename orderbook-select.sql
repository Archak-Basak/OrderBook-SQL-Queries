-- Hanieh Mohseni  cohort:TP003

/*
Basic Selects

REQUIREMENT - Use a multi-line comment to paste the first 5 or fewer results under your query
		     Also include the total records returned.
*/

USE orderbook_activity_db;

-- #1: List all users, including username and dateJoined.
select uname, dateJoined FROM User;
/* 7 rows
admin	2023-02-14 13:13:28
wiley	2023-04-01 13:13:28
james	2023-03-15 19:15:48
kendra	2023-03-15 19:16:06
alice	2023-03-15 19:16:21
...
*/



-- #2: List the username and datejoined from users with the newest users at the top.
SELECT uname,dateJoined
FROM User
ORDER BY dateJoined desc;
/*
wiley	2023-04-01 13:13:28
sam	2023-03-15 19:16:59
robert	2023-03-15 19:16:43
alice	2023-03-15 19:16:21
kendra	2023-03-15 19:16:06
*/

-- #3: List all usernames and dateJoined for users who joined in March 2023.
SELECT Uname, dateJoined
FROM User
WHERE dateJoined>= '2023-03-01' AND dateJoined < '2023-04-01';
/*
james	2023-03-15 19:15:48
kendra	2023-03-15 19:16:06
alice	2023-03-15 19:16:21
robert	2023-03-15 19:16:43
sam	2023-03-15 19:16:59
*/

-- #4: List the different role names a user can have.
SELECT name 
FROM Role;
/*
admin
it
user
*/


-- #5: List all the orders.
SELECT *
FROM `Order`;
/*
1	1	WLY	1	2023-03-15 19:20:35	100	38.73	partial_fill
2	6	WLY	2	2023-03-15 19:20:50	-10	38.73	filled
3	6	NFLX	2	2023-03-15 19:21:12	-100	243.15	pending
4	5	A	1	2023-03-15 19:21:31	10	129.89	filled
5	3	A	2	2023-03-15 19:21:39	-10	129.89	filled
*/


-- #6: List all orders in March where the absolute net order amount is greater than 1000.
SELECT *
FROM `Order`
WHERE month(orderTime)=3 AND ABS(shares*price)>1000;
/*
also we can use this: orderTime>='2023-03-01' AND orderTime<'2023-04-01'
1	1	WLY	1	2023-03-15 19:20:35	100	38.73	partial_fill
3	6	NFLX	2	2023-03-15 19:21:12	-100	243.15	pending
4	5	A	1	2023-03-15 19:21:31	10	129.89	filled
5	3	A	2	2023-03-15 19:21:39	-10	129.89	filled
6	1	GS	1	2023-03-15 19:22:11	100	305.63	canceled_partial_fill
*/

-- #7: List all the unique status types from orders.
SELECT DISTINCT status
FROM `Order`;
/*
partial_fill
filled
pending
canceled_partial_fill
canceled
*/


-- #8: List all pending and partial fill orders with oldest orders first.
SELECT *
FROM `Order`
WHERE status IN ('partial_fill','pending')
ORDER BY orderTime ASC;
/*
also we can use : WHERE status='partial_fill' OR status='pending'
'1', '1', 'WLY', '1', '2023-03-15 19:20:35', '100', '38.73', 'partial_fill'
'3', '6', 'NFLX', '2', '2023-03-15 19:21:12', '-100', '243.15', 'pending'
'11', '5', 'SPY', '1', '2023-03-15 19:24:21', '100', '365.73', 'partial_fill'
'12', '4', 'QQQ', '2', '2023-03-15 19:24:32', '-100', '268.27', 'pending'
'13', '4', 'QQQ', '2', '2023-03-15 19:24:32', '-100', '268.27', 'pending'
*/


-- #9: List the 10 most expensive financial products where the productType is stock.
-- Sort the results with the most expensive product at the top
SELECT *
FROM Product
WHERE productType='stock'
ORDER BY price DESC
LIMIT 10;
/*
207940.KS	830000.00	stock	Samsung Biologics Co.,Ltd.	2022-10-17 15:24:51
003240.KS	715000.00	stock	Taekwang Industrial Co., Ltd.	2022-10-17 15:24:51
000670.KS	630000.00	stock	Young Poong Corporation	2022-10-17 15:24:51
010130.KS	616000.00	stock	Korea Zinc Company, Ltd.	2022-10-17 15:24:51
006400.KS	605000.00	stock	Samsung SDI Co., Ltd.	2022-10-17 15:24:51
*/


-- #10: Display orderid, fillid, userid, symbol, and absolute net fill amount
-- from fills where the absolute net fill is greater than $1000.
-- Sort the results with the largest absolute net fill at the top.
SELECT orderid,fillid, userid,symbol, ABS(share *price) AS absolute_fill_Amount
FROM Fill
WHERE ABS(share *price)>1000
ORDER BY absolute_fill_Amount DESC;
/* 10 rows
11	11	5	SPY	27429.75
14	12	4	SPY	27429.75
6	5	1	GS	3056.30
7	6	4	GS	3056.30
8	9	6	AAPL	2111.40
*/

