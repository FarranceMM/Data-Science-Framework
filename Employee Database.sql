show DATABASES;
use classicmodels;
show tables;

/* 1 Find products containing the name 'Ford'. */

SELECT productName FROM products
WHERE productName REGEXP 'Ford';

/* 2 List products ending in 'ship'. */

SELECT productName FROM products
WHERE LOWER(productName) REGEXP 'ship';

/* 3 Report the number of customers in Denmark, Norway, and Sweden. */

SELECT COUNT(DISTINCT(customerName)), country FROM customers
WHERE country IN ('Denmark', 'Norway', 'Sweden')
GROUP BY country;

/* 4 What are the products with a product code in the range S700_1000 to S700_1499? */

SELECT productName FROM products
WHERE productCode BETWEEN 'S700_1000' and 'S700_1499';

/* 5 Which customers have a digit in their name? */

SELECT customerName FROM customers
WHERE customerName REGEXP '[0-9]';

/* 6 List the names of employees called Dianne or Diane. */

SELECT firstName FROM Employees
WHERE firstName REGEXP 'Dian';

/* 7 List the products containing ship or boat in their product name. */

SELECT productName FROM products
WHERE productName REGEXP 'ship|boat';

/* 8 List the products with a product code beginning with S700. */

SELECT productName FROM products
WHERE productCode REGEXP 'S700';

/* 9 List the names of employees called Larry or Barry. */

SELECT firstName FROM employees 
WHERE firstName REGEXP 'Larry|Barry';

/* 10 List the names of employees with non-alphabetic characters in their names. */

SELECT firstName FROM employees 
WHERE LOWER(firstName) REGEXP '[^a-z]';

/* 11 List the vendors whose name ends in Diecast */

SELECT productVendor FROM products
WHERE productVendor LIKE '%Diecast';

/* 12 What is the value of orders shipped in August 2004? */

SELECT FORMAT(SUM(quantityOrdered*priceEach),0) as orderValue
FROM Orders JOIN OrderDetails
ON Orders.orderNumber = OrderDetails. orderNumber
AND YEAR(orderDate) = 2004;

/* 13 Compute the total value ordered, total amount paid, and their difference for each customer for orders placed in 2004 and payments received in 2004 (Hint; Create views for the total paid and total ordered) */

SELECT DISTINCT(customerName), FORMAT(SUM(quantityOrdered*priceEach),0) AS totalValue, SUM(amount) AS totalAmount FROM orders
JOIN customers ON orders.customerNumber=customers.customerNumber
JOIN orderDetails ON orders.orderNumber=orderDetails.orderNumber
JOIN payments ON customers.customerNumber=payments.customerNumber
WHERE YEAR(orderDate)=2004
AND YEAR(paymentDate)=2004
GROUP BY customerName;

/* 14 Write a procedure to change the credit limit of all customers in a specified country by a specified percentage. */

DELIMITER //
CREATE PROCEDURE changeCredit(
IN inNation CHARACTER(20),
IN inPercent DECIMAL(5, 2))
LANGUAGE SQL
BEGIN
UPDATE customers
SET creditLimit = creditLimit*(1 + inPercent)
WHERE country = inNation;
END//

/* 15 Write a procedure to report the amount ordered in a specific month and year for customers containing a specified character string in their name. */

DELIMITER //
CREATE PROCEDURE reportOrderValue (
IN inMonth INT,
IN inYear INT,
IN inString VARCHAR(20))
LANGUAGE SQL
BEGIN
SELECT customerName AS Customer, (FORMAT(SUM(quantityOrdered*priceEach), 0)) AS `Order Value`
FROM Orders JOIN OrderDetails
ON Orders.customerNumber = Customers.customerNumber
JOIN Customers
ON Orders.customerNumber = Customers.customerNumber
WHERE YEAR(orderDate) = inYear
AND MONTH(orderDate) = inMonth
AND customerName REGEXP inString
GROUP BY customerName;
END //

/* 15 What is the ratio of the value of payments made to orders received for each month of 2004? (i.e., divide the value of payments made by the orders received)? */
WITH
pay2004 AS (SELECT SUM(amount) AS Payment, MONTH(paymentDate) AS period FROM payments
WHERE YEAR(paymentDate)=2004
GROUP BY MONTH(paymentDate)),
order2004 AS (SELECT SUM(quantityOrdered*priceEach) AS orderValue, MONTH(orderDate) AS 
period FROM orders
JOIN orderDetails ON orders.orderNumber=orderDetails.orderNumber
WHERE YEAR(orderDate)=2004
GROUP BY MONTH(orderDate))
SELECT pay2004.period, FORMAT(Payment/orderValue, 2) AS ratio FROM pay2004
JOIN order2004 
ON
pay2004.period=order2004.period;

/* 16 What is the difference in the amount received for each month of 2004 compared to 2003? */

WITH
pay2004 AS (SELECT SUM(amount) AS Payment, MONTH(paymentDate) AS 'month', YEAR(paymentDate) AS 'year' FROM payments
WHERE YEAR(paymentDate) = 2004
GROUP BY YEAR(paymentDate),
MONTH(paymentDate)),
pay2003 AS (SELECT SUM(amount) AS Payment, MONTH(paymentDate) AS 'month', YEAR(paymentDate) AS 'year' FROM payments
WHERE YEAR(paymentDate) = 2003
GROUP BY YEAR(paymentDate),
MONTH(paymentDate))
SELECT pay2004.month, FORMAT(pay2004.Payment - pay2003.Payment, 2) AS difference FROM pay2004
JOIN pay2003  
ON pay2004.month = pay2003.month
ORDER BY pay2004.month;

/* 17 Find the products sold in 2003 but not 2004. */

SELECT productName FROM products
JOIN orderDetails ON products.productCode = orderDetails.productCode
JOIN orders ON orderDetails.orderNumber = orders.orderNumber
WHERE YEAR(orderDate) = 2003
AND products.productCode NOT IN
(SELECT productName FROM products
JOIN orderDetails ON products.productCode = orderDetails.productCode
JOIN orders ON orderDetails.orderNumber = orders.orderNumber;

/* 18 Find the customers without payments in 2003. */

SELECT DISTINCT customerName AS CustomersName FROM customers
JOIN payments ON customers.customerNumber = payments.customerNumber
WHERE customerName NOT IN 
(SELECT customerName FROM customers
JOIN payments ON customers.customerNumber = payments.customerNumber
WHERE YEAR(paymentDate) = 2003)
WHERE YEAR(orderDate) = 2004);

