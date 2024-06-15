-- classicmodels database 

-- show all customers in Australia +
select * from classicmodels.customers where country = 'Australia';
-- show First and Last name of customers in Melbourne +
select contactFirstName, contactLastName, city from classicmodels.customers where city = 'Melbourne';
-- show all customers with Credit Limit over $200,000 +
select * from classicmodels.customers where creditLimit > 200000;
-- who is the president of the company? +
select firstName, lastName, jobTitle from classicmodels.employees where jobTitle = 'President';
-- how many Sales Reps are in the company? +
select count(*) from classicmodels.employees where jobTitle = 'Sales Rep'; -- с разбора 'Sales%Rep%'
-- show payments in descending order +
select * from classicmodels.payments order by amount desc;
-- what was the check# for the payment done on December 17th 2004 +
select checkNumber from classicmodels.payments where paymentDate = '2004-12-17';
-- show product line with the word 'realistic' in the description +
select * from classicmodels.productlines where textDescription like '%realistic %';
-- show product name for vendor 'Unimax Art Galleries' +
select productName, productVendor from classicmodels.products where productVendor = 'Unimax Art Galleries';
-- what is the customer number for the highest amount of payment +
select distinct customerNumber, MAX(amount) from classicmodels.payments group by customerNumber limit 1; -- made it wrong
select customerNumber, amount from classicmodels.payments order by amount desc limit 1;
select customerNumber, sum(amount) from classicmodels.payments group by customerNumber order by sum(amount) desc limit 1;
