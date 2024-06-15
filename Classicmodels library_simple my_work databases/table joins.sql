-- Part #1 classicmodels database 
-- (write sql for #6+, 8+, 9+, 10+, 11+, 14+, 16+, 17+, 21+) -- easy questions (13-)

-- HINT! If you don't know how to find tables and columns you need...
SELECT TABLE_NAME, COLUMN_NAME, COLUMN_TYPE, COLUMN_KEY
FROM INFORMATION_SCHEMA.columns
WHERE TABLE_SCHEMA = 'classicmodels' and COLUMN_NAME like '%vendor%';
-- 1.how many vendors, product lines, and products exist in the database?
select distinct productLine from classicmodels.products; -- 7
select distinct productVendor from classicmodels.products; -- 13
select distinct productCode from classicmodels.products; -- 110
--- Самое лучшее с ревью ---
select count(distinct productVendor), count(distinct productLine), count(distinct productCode) from classicmodels.products;
--- С ревью некорректно, но интересно ---
select count(productVendor), count(l.productLine), count(productCode)
from classicmodels.productlines as l
join classicmodels.products as r
on l.productline = r.productline;
-- 2.what is the average price (buy price, MSRP) per vendor?
select productVendor, sum(buyPrice) from classicmodels.products group by productVendor;
select productVendor, avg(buyPrice), avg(MSRP) from classicmodels.products group by productVendor;
--- Самое лучшее с ревью ---
select productVendor, 
		round(avg(buyPrice), 2) 'average buy price', 
		round(avg(MSRP), 2) 'average MSRP' 
from classicmodels.products 
group by productVendor;
-- 3.what is the average price (buy price, MSRP) per customer?
select distinct customerName from classicmodels.customers;
------
select *
from classicmodels.products as p
JOIN classicmodels.orderdetails as od
on p.productCode = od.productCode
JOIN classicmodels.orders as o
on od.orderNumber = o.orderNumber
JOIN classicmodels.customers as c
on o.customerNumber = c.customerNumber;
------
select customerName, avg(buyPrice), avg(MSRP)
from classicmodels.products as p
JOIN classicmodels.orderdetails as od
on p.productCode = od.productCode
JOIN classicmodels.orders as o
on od.orderNumber = o.orderNumber
JOIN classicmodels.customers as c
on o.customerNumber = c.customerNumber
group by customerName;
-- 4.what product was sold the most?
select *
from classicmodels.products as p
JOIN classicmodels.orderdetails as od
on p.productCode = od.productCode;
------
select productName, count(orderNumber)
from classicmodels.products as p
JOIN classicmodels.orderdetails as od
on p.productCode = od.productCode
group by productName
order by count(orderNumber) desc;
-- 5.how much money was made between buyPrice and MSRP?
select sum(MSRP), sum(buyPrice), sum(MSRP) - sum(buyPrice) as Profit from classicmodels.products;
-- 6.which vendor sells 1966 Shelby Cobra?
select productVendor, productName from classicmodels.products where productName like '%1966 Shelby Cobra%';
-- 7.which vendor sells more products?
select productVendor, productName from classicmodels.products;
select productVendor, count(productName) from classicmodels.products group by productVendor order by count(productName) desc;
-- 8.which product is the most and least expensive?
select * from classicmodels.products;
select productName, buyPrice from classicmodels.products 
where buyPrice = (select min(buyPrice) from classicmodels.products) or buyPrice = (select max(buyPrice) from classicmodels.products);
select productName, MSRP from classicmodels.products 
where MSRP = (select min(MSRP) from classicmodels.products) or MSRP = (select max(MSRP) from classicmodels.products);
--- Review
select * from classicmodels.products order by MSRP desc limit 1;
select * from classicmodels.products order by MSRP asc limit 1;
-- 9.which product has the most quantityInStock?
select productName, quantityInStock from classicmodels.products order by quantityInStock desc limit 1;
--- Review
select * from classicmodels.products order by quantityInStock desc limit 1;
-- 10.list all products that have quantity in stock less than 20
select productName, quantityInStock from classicmodels.products where quantityInStock  <= 20;
-- 11.which customer has the highest and lowest credit limit?
select * from classicmodels.customers;
select customerName, creditLimit from classicmodels.customers 
where creditLimit = (select min(creditLimit) from classicmodels.customers) or creditLimit = (select max(creditLimit) from classicmodels.customers) order by creditLimit desc;
--- Review
select customerName, creditLimit from classicmodels.customers order by creditLimit desc limit 1;
select customerName, creditLimit from classicmodels.customers order by creditLimit asc limit 1;
-- 12.rank customers by credit limit
select customerName, creditLimit from classicmodels.customers order by creditLimit desc;
-- 13.list the most sold product by city
select *
from classicmodels.products as p
JOIN classicmodels.orderdetails as od
on p.productCode = od.productCode
JOIN classicmodels.orders as o
on od.orderNumber = o.orderNumber
JOIN classicmodels.customers as c
on o.customerNumber = c.customerNumber
JOIN classicmodels.employees as e
on c.salesRepEmployeeNumber = e.employeeNumber
JOIN classicmodels.offices as offic
on e.officeCode = offic.officeCode;
--- review
select c.city, SUM(od.quantityOrdered) as totalQuantity 
from classicmodels.customers as c
JOIN classicmodels.orders as o
on c.customerNumber = o.customerNumber
JOIN classicmodels.orderdetails as od
on o.orderNumber = od.orderNumber
JOIN classicmodels.products as p
on od.productCode = p.productCode
group by c.city
order by totalQuantity desc;

use classicmodels;
	SELECT c.city, p.productName, SUM(od.quantityOrdered) AS totalQuantity
	FROM customers c JOIN orders o ON c.customerNumber = o.customerNumber
					 JOIN orderdetails od ON o.orderNumber = od.orderNumber
					 JOIN products p ON od.productCode = p.productCode
	GROUP BY c.city, od.productCode
	ORDER BY city, totalQuantity DESC

-- 13.list the most sold product by city
use classicmodels;
SELECT
    c.*,
    p.productName AS most_sold_product,
COUNT(od.productCode) AS total_sold
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
JOIN products p ON od.productCode = p.productCode
GROUP BY c.city
ORDER BY total_sold DESC
Limit 1;
-- 14.customers in what city are the most profitable to the company? -- based on highest single payment
select *
from classicmodels.products as p
JOIN classicmodels.orderdetails as od
on p.productCode = od.productCode
JOIN classicmodels.orders as o
on od.orderNumber = o.orderNumber
JOIN classicmodels.customers as c
on o.customerNumber = c.customerNumber
join classicmodels.payments as pay
on c.customerNumber = pay.customerNumber;

select city, amount
from classicmodels.customers as c
join classicmodels.payments as pay
on c.customerNumber = pay.customerNumber
order by amount desc limit 1;
-- 15.what is the average number of orders per customer?
select customerName, count(checkNumber)
from classicmodels.customers as c
join classicmodels.payments as pay
on c.customerNumber = pay.customerNumber
group by customerName;
-- 16.who is the best customer? --based on single payment
select customerName, amount
from classicmodels.customers as c
join classicmodels.payments as pay
on c.customerNumber = pay.customerNumber
order by amount desc limit 1;
-- 17.customers without payment
select customerName, amount
from classicmodels.customers as c
left join classicmodels.payments as pay
on c.customerNumber = pay.customerNumber
where amount is null;
-- 18.what is the average number of days between the order date and ship date?
select orderNumber, orderDate, shippedDate, datediff(shippedDate, orderDate) as Difference from classicmodels.orders;
select avg(datediff(shippedDate, orderDate)) as Difference from classicmodels.orders;
-- 19.sales by year
-- 20.how many orders are not shipped?
-- 21.list all employees by their (full name: first + last) in alpabetical order
select concat(firstName, ' ', lastName) from classicmodels.employees order by concat(firstName, ' ', lastName);
--- review
select concat(firstName, ' ', lastName) as FullName from classicmodels.employees order by FullName;
-- 22.list of employees  by how much they sold in 2003?
-- 23.which city has the most number of employees?
-- 24.which office has the biggest sales?

-- Part #2  -- library_simple database
-- 1.find all information (query each table seporately for book_id = 252)
SELECT TABLE_NAME, COLUMN_NAME, COLUMN_TYPE, COLUMN_KEY
FROM INFORMATION_SCHEMA.columns
WHERE TABLE_SCHEMA = 'library_simple' and COLUMN_NAME like '%book_id%';
select * from library_simple.author_has_book where book_id = 252;
select * from library_simple.category_has_book where book_id = 252;
select * from library_simple.copy where book_id = 252;
--- review
select * from library_simple.book b join library_simple.author_has_book ahb on b.id = ahb.book_id where id = 252;

USE library_simple;
SELECT
    book.*,
    author_has_book.*,
    author.*,
    category.*,
    copy.*,
    issuance.*,
    reader.*
FROM book
JOIN author_has_book ON book.id = author_has_book.book_id
JOIN author ON author_has_book.author_id = author.id
JOIN copy  ON book.id = copy.book_id
left JOIN issuance ON copy.id = issuance.copy_id
left JOIN reader on issuance.reader_id = reader.id
JOIN category_has_book ON book.id = category_has_book.book_id
JOIN category ON category_has_book.category_id = category.id
WHERE
    book.id = 252;

-- 2.which books did Van Parks write?
select name, concat(first_name, ' ', last_name)
from library_simple.book as b
join library_simple.author_has_book as a
on b.id = a.book_id
join library_simple.author as w
on a.author_id = w.id
where concat(first_name, ' ', last_name) like '%Van%Parks%';
-- 3.which books where published in 2003?
select * from library_simple.book as b
join library_simple.author_has_book as a
on b.id = a.book_id
join library_simple.author as w
on a.author_id = w.id
where pub_year = 2003;