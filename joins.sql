-- Hanieh Mohseni TP003

/*
Join Queries

REQUIREMENT - Use a multi-line comment to paste the first 5 or fewer results under your query
		     Also include the total records returned.
*/

USE orderbook_activity_db;

-- #1: Display the dateJoined and username for admin users.
SELECT U.uname, U.dateJoined
FROM User U
join UserRoles UR ON UR.userid = U.userid
join Role R ON R.roleid = UR.roleid
WHERE R.name = 'admin';
/*
admin	2023-02-14 13:13:28
wiley	2023-04-01 13:13:28
alice	2023-03-15 19:16:21
*/



-- #2: Display each absolute order net (share*price), status, symbol, trade data, and username.
-- Sort the results with largest the absolute order net (share*price) at the top.
-- Include only orders that were not canceled or partially canceled.

SELECT ABS(O.shares*O.price) AS absolut_order,
O.status,
O.symbol,
O.orderTime AS trade_data,
U.Uname
FROM `Order` O
Join User U ON U.userid=O.userid
WHERE O.status NOT IN ('canceled', 'partially canceled')
ORDER BY absolut_order DESC;

/*
36573.00	partial_fill	SPY	2023-03-15 19:24:21	alice
30563.00	canceled_partial_fill	GS	2023-03-15 19:22:11	admin
27429.75	filled	SPY	2023-03-15 19:24:47	kendra
26827.00	pending	QQQ	2023-03-15 19:24:32	kendra
26827.00	pending	QQQ	2023-03-15 19:24:32	kendra
*/



-- #3: Display the orderid, symbol, status, order shares, filled shares, and price for orders with fills.
-- Note that filledShares are the opposite sign (+-) because they subtract from ordershares!

SELECT O.orderid,
O.symbol, O.`status`,
O.shares,
F.share AS 'filled shares',
O.price
FROM `Order` O
JOIN Fill F ON O.orderid = F.orderid;
/*
1	WLY	partial_fill	100	-10	38.73
2	WLY	filled	-10	10	38.73
4	A	filled	10	-10	129.89
5	A	filled	-10	10	129.89
*/


-- #4: Display all partial_fill orders and how many outstanding shares are left.
-- Also include the username, symbol, and orderid.

SELECT O.orderid,
       U.uname AS username,
       O.symbol,
       O.shares AS order_shares,
       SUM(F.share) AS outstanding_shares_left
FROM `Order` O
JOIN User U ON O.userid = U.userid
LEFT JOIN `Fill` F ON O.orderid = F.orderid
WHERE O.status = 'partial fill'
GROUP BY O.orderid, U.uname, O.symbol, O.shares;
 
 /*
 No records
 */


-- #5: Display the orderid, symbol, status, order shares, filled shares, and price for orders with fills.
-- Also include the username, role, absolute net filled, and absolute net order.
-- Sort by the absolute net order with the largest value at the top.

SELECT o.orderid,
       o.symbol,
       o.status,
       o.shares AS 'order shares',
       SUM(f.share) AS 'filled shares',
       o.price,
       u.uname AS username,
       r.name AS role,
       ABS(SUM(f.share * f.price)) AS 'absolute net filled',
       ABS(SUM(o.shares * o.price)) AS 'absolute net order'
FROM `Order` o
JOIN User u ON o.userid = u.userid
JOIN UserRoles ur ON u.userid = ur.userid
JOIN Role r ON ur.roleid = r.roleid
LEFT JOIN `Fill` f ON o.orderid = f.orderid
GROUP BY o.orderid, o.symbol, o.status, o.shares, o.price, u.uname, r.name
ORDER BY ABS(SUM(o.shares * o.price)) DESC;

/*
11	SPY	partial_fill	100	-75	365.73	alice	admin	27429.75	36573.00
6	GS	canceled_partial_fill	100	-10	305.63	admin	admin	3056.30	30563.00
14	SPY	filled	-75	75	365.73	kendra	user	27429.75	27429.75
13	QQQ	pending	-100		268.27	kendra	user		26827.00
12	QQQ	pending	-100		268.27	kendra	user		26827.00
*/

-- #6: Display the username and user role for users who have not placed an order.

SELECT u.uname AS username, r.name AS user_role
FROM User u
LEFT JOIN UserRoles ur ON u.userid = ur.userid
LEFT JOIN Role r ON ur.roleid = r.roleid
WHERE u.userid NOT IN (SELECT DISTINCT userid FROM `Order`);

/*
sam	user
wiley	admin
*/




-- #7: Display orderid, username, role, symbol, price, and number of shares for orders with no fills.

SELECT o.orderid,
       u.uname AS username,
       r.name AS role,
       o.symbol,
       o.price,
       o.shares AS number_of_shares
FROM `Order` o
JOIN User u ON o.userid = u.userid
JOIN UserRoles ur ON u.userid = ur.userid
JOIN Role r ON ur.roleid = r.roleid
LEFT JOIN `Fill` f ON o.orderid = f.orderid
WHERE f.fillid IS NULL;

/*
19	alice	admin	GOOG	100.82	100
21	alice	admin	A	129.89	-1
22	alice	admin	A	129.89	2
23	alice	admin	A	129.89	5
24	alice	admin	A	129.89	2
*/


-- #8: Display the symbol, username, role, and number of filled shares where the order symbol is WLY.
-- Include all orders, even if the order has no fills.

SELECT o.symbol,
       u.uname AS username,
       r.name AS role,
       SUM(f.share) AS number_of_filled_shares
FROM `Order` o
JOIN User u ON o.userid = u.userid
JOIN UserRoles ur ON u.userid = ur.userid
JOIN Role r ON ur.roleid = r.roleid
LEFT JOIN `Fill` f ON o.orderid = f.orderid
WHERE o.symbol = 'WLY'
GROUP BY o.symbol, u.uname, r.name;

/*
WLY	admin	admin	-10
WLY	james	user	
WLY	robert	user	10
*/


