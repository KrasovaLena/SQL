-- Part 1
-- Group By  Example by Animation: https://dataschool.com/how-to-teach-people-sql/how-sql-aggregations-work/

-- Classicmodels Database 
--  1.use union: show products with buyPrice > 100 and <200
select * from classicmodels.products
where buyPrice > 100
UNION
select * from classicmodels.products
where buyPrice < 200;
-- Странное задание, всех смутило в т.ч. препода по ревью сделали без юнион
select * from classicmodels.products where buyPrice > 100 and buyPrice < 200;
--  2.use subquery: show all customer names with employees in San Francisco office +
select city, salesRepEmployeeNumber, customerName  from classicmodels.customers
where customerName in
(select customerName from classicmodels.customers as c
join classicmodels.employees as e
on c.salesRepEmployeeNumber = e.employeeNumber
join classicmodels.offices as o
on e.officeCode = o.officeCode
where o.city like '%San Francisco%');
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
-- review
select city, salesRepEmployeeNumber, customerName from classicmodels.customers
where salesRepEmployeeNumber in 
	(select distinct EmployeeNumber
	from classicmodels.employees
    where officeCode in 
		(select officeCode
        from classicmodels.offices
        where city like '%San Francisco%'));
-- От препода         
select * from classicmodels.customers
where salesRepEmployeeNumber in
(select employeeNumber from classicmodels.employees e
join classicmodels.offices as o
on e.officeCode = o.officeCode
where o.city like '%San Francisco%');
--  3.use subquery: based on previous query add count(*) to show total of employees in San Francisco office 
select count(employeeNumber) from classicmodels.employees
where employeeNumber in
(select employeeNumber from classicmodels.employees as e
join classicmodels.offices as o
on e.officeCode = o.officeCode
where o.city like '%San Francisco%');
-- От препода      
select customerName, (select count(employeeNumber) from classicmodels.employees e join classicmodels.offices o on e.officeCode = o.officeCode where o.city = 'San Francisco') as 'Emp in SF Office'
from classicmodels.customers
where salesRepEmployeeNumber in
(select employeeNumber from classicmodels.employees e
join classicmodels.offices as o
on e.officeCode = o.officeCode
where o.city like '%San Francisco%');

select count(*) from
(select salesRepEmployeeNumber, customerName
from classicmodels.customers
where salesRepEmployeeNumber in 
(select distinct employeeNumber from classicmodels.employees 
where officeCode in 
(select officeCode from classicmodels.offices where city = 'San Francisco')))a;

-- Part 2
-- Classicmodels Database - Keep working on these queries
-- write sql for #1,2,3,4,5,7
-- 1.how many vendors, product lines, and products exist in the database?
-- 2.what is the average price (buy price, MSRP) per vendor?
-- 3.what is the average price (buy price, MSRP) per customer?
-- 4.what product was sold the most?
-- 5.how much money was made between buyPrice and MSRP?
-- 7.which vendor sells more products?

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
-- 3.what is the average price (buy price, MSRP) per customer? +
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

