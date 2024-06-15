/*
Part 1 - mywork database
Write sql 
	1. Add column 'country' to dept table in mywork database
	2. Rename column 'loc' to 'city'
	3. Add three more departments: HR, Engineering, Marketing
	4. Write sql statement to show which department is in Atlanta
    Save your work 
*/
-- 1. Add column 'country' to dept table in mywork database
select * from mywork.dept;
alter table mywork.dept add column country varchar (30);
-- 2. Rename column 'loc' to 'city'
alter table mywork.dept rename column loc to city;
-- 3. Add three more departments: HR, Engineering, Marketing
insert into mywork.dept (deptno, dname, city, country)
values 
(5, 'HR', 'HOUSTON', 'USA'),
(6, 'Engineering', 'MIAMI', 'USA'),
(7, 'Marketing', 'LOS ANGELES', 'USA');
-- 4. Write sql statement to show which department is in Atlanta
select * from mywork.dept where city like 'Atlanta';
-- where binary будет чувствителен к регистру
-----------------

/*
Part 2  - library_simple database
Run library_simple.sql script  (takes a few minutes)
(source: https://github.com/amyasnov/stepic-db-intro/tree/2650f9a7f9c72e1219ea93cb4c4e410cca046e54/test)
Look at table relationships in EER Diagram
Write sql 
	1. What is the first name of the author with the last name Swanson?
	2. How many pages are in Men Without Fear book?
	3. Show all book categories that start with with letter 'W'
*/
-- 1. What is the first name of the author with the last name Swanson?
select * from library_simple.author where last_name like 'Swanson';
-- 2. How many pages are in Men Without Fear book?
select * from library_simple.book where name like 'Men Without Fear';
-- 3. Show all book categories that start with with letter 'W'
select * from library_simple.category where `name` like 'W%';
-- `если название совпадает с зарезервированными словами`