-- Part #1
-- 1. use union: (classicmodels db) show products with buyPrice or msrp > $100 and < $200
-- 110 -- query works but doesn't make sence because we pull ALL records
select productName, productLine, buyPrice
from classicmodels.products
where buyPrice >100
UNION
select productName, productLine, buyPrice
from classicmodels.products
where buyPrice <200;
 
-- a much better query
select productName, productLine, buyPrice
from classicmodels.products
where buyPrice between 100 and 200;

-- 2. use subquery: (classicmodels db) show all customer names with employees in San Francisco office
-- subquery version 1
-- 12
select salesRepEmployeeNumber, customerName
from classicmodels.customers
where salesRepEmployeeNumber in 
(select distinct employeeNumber from classicmodels.employees 
where officeCode in 
(select officeCode from classicmodels.offices where city = 'San Francisco'));

-- subquery version 2
-- 12
select salesRepEmployeeNumber, customerName
from classicmodels.customers c
where salesRepEmployeeNumber in
(select distinct e.EmployeeNumber -- ,o.officeCode 
from classicmodels.employees e
join classicmodels.offices o 
on e.officecode = o.officecode
where o.city = 'San Francisco');

-- without subquery version 3
-- 12
select c.salesRepEmployeeNumber, o.city, c.customerName
from classicmodels.customers c
join classicmodels.employees e on c.salesRepEmployeeNumber = e.employeeNumber 
join classicmodels.offices o on e.officeCode  = o.officeCode
 where o.city = 'San Francisco';
 
 -- 3. use count (*) in subquery
select count(*) from
(select salesRepEmployeeNumber, customerName
from classicmodels.customers
where salesRepEmployeeNumber in 
(select distinct employeeNumber from classicmodels.employees 
where officeCode in 
(select officeCode from classicmodels.offices where city = 'San Francisco')))a;
 
-- Part #2
-- Classicmodels Database - Keep working on these queries
-- write sql for #1,2,3,4,5,7
-- 1.how many vendors, product lines, and products exist in the database?
-- 2.what is the average price (buy price, MSRP) per vendor?
-- 3.what is the average price (buy price, MSRP) per customer?
-- 4.what product was sold the most?
-- 5.how much money was made between buyPrice and MSRP?
-- 7.which vendor sells more products?

-- 1.how many vendors, product lines, and products exist in the database?
SELECT
	COUNT(distinct ProductVendor) as Vendors_count,
	COUNT(distinct ProductLine) as Product_lines_count,
	COUNT(distinct productCode) as Products_count
FROM classicmodels.products;

-- 2.what is the average price (buy price, MSRP) per vendor?
SELECT
	productVendor,
    AVG (buyPrice) as AvgPrice,
    AVG (MSRP) as AvgMSRP
FROM classicmodels.products
GROUP BY productVendor;    

-- 3.what is the average price (buy price, MSRP) per customer?
SELECT
orders.customerNumber, AVG(det.priceEach) as AvgPrice, AVG(prod.buyPrice) as AvgBuyPrice, AVG(prod.MSRP) as AvgMSRP 
FROM classicmodels.orders orders 
JOIN classicmodels.orderdetails det on det.orderNumber = orders.orderNumber
JOIN classicmodels.products prod on prod.productCode = det.productCode
GROUP BY orders.customerNumber
ORDER BY orders.customerNumber;

-- 4.Pay Attention!!! which fields: productCode or quatityOrdered?
-- what product was sold the most?
SELECT prod.productName,
COUNT(prod.productCode) as prod_cnt, 
SUM(det.quantityOrdered) as quantity_ordered_sum,
MAX(det.quantityOrdered) as order_cnt
FROM classicmodels.orderdetails det
JOIN classicmodels.products prod ON det.productCode = prod.productCode
GROUP BY prod.productCode
ORDER BY prod_cnt DESC -- order_cnt DESC 
LIMIT 1;

-- 5.how much money was made between buyPrice and MSRP?
-- wrong!
SELECT 
-- msrp, buyPrice, (msrp - buyPrice)difference
SUM(msrp - buyPrice) as moneyMade, SUM(msrp)- SUM(buyPrice) as difference
-- select * 
FROM classicmodels.products;

-- correct
SELECT SUM(prod.msrp * det.quantityOrdered) as msrp_sales, 
SUM(prod.buyPrice * det.quantityOrdered) as buyPrice_sales,
SUM(prod.msrp * det.quantityOrdered) - SUM(prod.buyPrice * det.quantityOrdered) as difference_in_sales
FROM classicmodels.products prod
JOIN classicmodels.orderdetails det on prod.productCode = det.productCode;


-- 6.which vendor sells 1966 Shelby Cobra?
SELECT prod.productVendor, prod.productName
FROM classicmodels.products prod
WHERE prod.productName LIKE '1966 Shelby Cobra%';

-- 7.which vendor sells more products?
SELECT prod.productVendor, SUM(det.quantityOrdered) as quantity, count(det.productcode) as quantity2
FROM classicmodels.products prod
JOIN classicmodels.orderdetails det on prod.productCode = det.productCode
GROUP BY prod.productVendor
ORDER BY quantity desc
LIMIT 1;


-- Part #3 library_simple database
-- Database: library_simple
select count(*) from library_simple.author; -- 86
select count(*) from library_simple.author_has_book; -- 596
select count(*) from library_simple.book; -- 322
select count(*) from library_simple.category; -- 184
select count(*) from library_simple.category_has_book; -- 556
select count(*) from library_simple.copy; -- 1121
select count(*) from library_simple.issuance; -- 2000
select count(*) from library_simple.reader; -- 241 

-- join all tables
select distinct 
-- a.id, a.first_name, a.last_name,
-- b.author_id, b.book_id, 
c.id, c.ISBN, c.name, c.page_num, c.pub_year,
-- d.category_id, d.book_id,	
-- e.id, e.name,
f.id, f.book_id, f.number, f.admission_date,
g.id, g.copy_id, -- g.reader_id, 
g.issue_date, g.release_date, g.deadline_date,	
h.id, h.first_name, h.last_name, h.reader_num	-- select *
from library_simple.author a
join library_simple.author_has_book	b
on a.id = b.author_id
join library_simple.book c 
on b.book_id = c.id
join library_simple.category_has_book d
on c.id = d.book_id
join library_simple.category e
on d.category_id = e.id
join library_simple.copy f
on c.id = f.book_id
join library_simple.issuance g
on f.id = g.id 
join library_simple.reader h
on h.id = g.reader_id
where c.name = 'Lord Of Dread'
;

-- Find all release dates for book 'Dog With Money'
-- 3
select * from 
library_simple.book c 
join library_simple.copy f 
on  c.id = f.book_id --  where c.name = 'Dog With Money'
 join library_simple.issuance g
 on f.id = g.id -- f.id = g.copy_id 
where c.name = 'Dog With Money';
 
 
 select f.id, f.book_id, f.number, f.admission_date, 
 g.id as issuance_id, g.copy_id, g.reader_id, g.issue_date, g.release_date, g.deadline_date 
 from 
 library_simple.copy f 
 left join library_simple.issuance g
 on f.id = g.copy_id 
 where book_id = 61;
 -- where c.name = 'Dog With Money'

-- to verify 
select * from library_simple.book where name = 'Dog With Money';
select * from library_simple.copy f where book_id = 61;
select * from library_simple.issuance where id in (573,768,960);
-- select * from library_simple.issuance where copy_id in (573,768,960);


 
-- --------------------- Lesson #7 FUNCTIONS -------------------------------

-- https://www.w3schools.com/sql/sql_ref_mysql.asp

-- text/string functions
select customerNumber, addressLine1,
ASCII(addressLine1),-- Returns the number code that represents the specific character	
CHAR(addressLine1), -- Returns the ASCII character based on the number code
CONCAT(contactFirstName,' ', contactLastName),-- Concatenates two or more strings together
SUBSTRING(addressLine1,6,1), -- Extracts a substring from a string
LEFT(addressLine1,8), RIGHT(addressLine1,8),-- Extracts a substring from a string (starting from left)	
LTRIM(addressLine1), RTRIM(addressLine1), TRIM(addressLine1), -- Removes leading spaces from a string
LENGTH(addressLine1), -- Returns the length of the specified string
LOWER(contactLastName),UPPER(contactLastName), UCASE(contactLastName)-- Converts a string to lower-case	
from classicmodels.customers;

-- ---------------------------------------------------
-- number functions (with aggregation)
select city, 
AVG(creditLimit),-- Returns the average value of an expression	
COUNT(creditLimit),	-- Returns the count of an expression
MAX(creditLimit),-- Returns the maximum value of an expression	
MIN(creditLimit),-- Returns the minimum value of an expression	
SUM(creditLimit) -- Returns the summed value of an expression
from classicmodels.customers 
group by city
having city ='San Francisco';

-- number functions (without aggregation)
select city, creditLimit,
RAND(creditLimit),	-- Returns a random number or a random number within a range	
FLOOR(creditLimit),	-- Returns the largest integer value that is equal to or less than a number	
ABS(creditLimit),-- Returns the absolute value of a number
CEILING(creditLimit),-- Returns the smallest integer value that is greater than or equal to a number	
ROUND(creditLimit)	-- Returns a number rounded to a certain number of decimal places	
from classicmodels.customers 
where city ='San Francisco';

-- ---------------------------------------------------
-- date functions
select orderNumber,orderDate,shippedDate,
(orderDate)+5,	-- Returns a date after a certain time/date interval has been added		
ADDDATE(orderDate,5),-- Returns a date after a certain time/date interval has been added	
ADDTIME(orderDate,5),-- Returns time after a certain time/date interval has been added	
DATEDIFF(shippedDate,orderDate),	-- Returns the difference between two date values, based on the interval specified		
DAY(orderDate),	-- Returns the day of the month (from 1 to 31) for a given date		
MONTH(orderDate),	-- Returns the month (from 1 to 12) for a given date		
YEAR(orderDate),	-- Returns the year (as a four-digit number) for a given date
NOW()	-- Returns the current date and time			
from classicmodels.orders;	
-- ---------------------------------------------------

-- Advanced Functions           
-- CASE - #1 tool for data analysts - segmentation
select 
city, state, country,
case when country = 'USA' then 'USA' else 'non USA' end as US_customer1,
case when length(state)=2 then 'USA' else 'non USA' end as US_customer2
from classicmodels.customers;	

-- WINDOWS FUNCTIONS
/*Name	Description
CUME_DIST()	Cumulative distribution value
DENSE_RANK()	Rank of current row within its partition, without gaps
FIRST_VALUE()	Value of argument from first row of window frame
LAG()	Value of argument from row lagging current row within partition
LAST_VALUE()	Value of argument from last row of window frame
LEAD()	Value of argument from row leading current row within partition
NTH_VALUE()	Value of argument from N-th row of window frame
NTILE()	Bucket number of current row within its partition.
PERCENT_RANK()	Percentage rank value
RANK()	Rank of current row within its partition, with gaps
ROW_NUMBER()	Number of current row within its partition */


-- 122 records
select customerNumber, creditLimit,
ROW_NUMBER() OVER (ORDER BY creditLimit DESC) as `row_number`,
RANK() OVER (ORDER BY creditLimit DESC) as `rank`,
DENSE_RANK() OVER (ORDER BY creditLimit DESC) as `dense_rank`,
NTILE(4)  OVER (ORDER BY creditLimit DESC) as `cust_ntile`,
LAG(creditLimit,1) OVER (ORDER BY creditLimit DESC) as `lag`,
LEAD(creditLimit,1) OVER (ORDER BY creditLimit DESC) as `lead`,
CUME_DIST() OVER (ORDER BY creditLimit DESC) as `cume_dist`
from classicmodels.customers
order by creditLimit desc, customerNumber asc;

select country, creditLimit,
FIRST_VALUE(creditLimit) OVER(PARTITION BY country ORDER BY country) as `first_value`,
LAST_VALUE(creditLimit) OVER(PARTITION BY country ORDER BY country) as `last_value`,
AVG(creditLimit) OVER (PARTITION BY country) as `avg`,
MIN(creditLimit) OVER (PARTITION BY country) as `min`,
MAX(creditLimit) OVER (PARTITION BY country) as `max`
from classicmodels.customers
group by country, creditLimit;

-- create upper_lower from upper case
drop table if exists mywork.upper_lower;
create table mywork.upper_lower
as 
select UPPER(TRIM(contactFirstName)) as contactFirstName,
UPPER(TRIM(contactLastName)) as contactLastName,
CONCAT(TRIM(contactFirstName),' ', TRIM(contactLastName)) as contactFullName
from classicmodels.customers;
-- select * from mywork.upper_lower;

-- change name from upper to upper_lower case
select contactFirstName, contactLastName,
CONCAT(UCASE(LEFT(contactFirstName, 1))) as first_upper,
SUBSTRING(LCASE(contactFirstName),2,LENGTH(trim(contactFirstName))-1) as second_lower,
CONCAT(CONCAT(UCASE(LEFT(contactFirstName, 1))),SUBSTRING(LCASE(contactFirstName),2,LENGTH(trim(contactLastName))-1)) as ul_case_first,
CONCAT(CONCAT(UCASE(LEFT(contactLastName, 1))),SUBSTRING(LCASE(contactLastName),2,LENGTH(trim(contactLastName))-1)) as ul_case_last,
-- break into two columns
contactFullName,
locate(' ',contactFullName) position_of_space,
left(contactFullName,locate(' ',contactFullName))  as first_name,
substring((contactFullName),locate(' ',contactFullName)+1,length(contactFullName)) last_name
from mywork.upper_lower;

select * from classicmodels.customers;
desc classicmodels.customers;

-- classicmodels.customers. What is the max lenght of each field?
select 
max(length(customerNumber)),
max(length(customerName)),
max(length(contactLastName)),
max(length(contactFirstName)),
max(length(phone)),
max(length(addressLine1)),
max(length(addressLine2)),
max(length(city)),
max(length(state)),
max(length(postalCode)),
max(length(country)),
max(length(salesRepEmployeeNumber)),
max(length(creditLimit))
from classicmodels.customers;


	