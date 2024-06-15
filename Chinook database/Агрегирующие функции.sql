-- Посчитать количество строк в таблице customer
select * from chinook.customer;
select count(*) from chinook.customer;
select count(company) from chinook.customer;
select * from chinook.customer where company is not null;
-- найти все счет-фактуры
select * from chinook.invoice;
-- подсчитать общее количество счет-фактур
select count(*) from chinook.invoice;
-- подсчитать количество покупок, где ИД покупателя 1. Назвать столбец - кол-во покупок
select count(*) 'кол-во покупок' from chinook.invoice where CustomerId ;
-- Просуммировать стоимость покупок по всем счет-фактурам
select sum(total) from chinook.invoice;
-- Найти максимальную сумму среди счет-фактур
select max(total) from chinook.invoice;
-- найти среднюю сумму среди счет-фактур
select avg(total) from chinook.invoice;
-- ceiling
select ceiling(avg(total)) as округл from chinook.invoice;
select (avg(total)* 0.95) as округл from chinook.invoice;
select ceiling(avg(total)* 0.95) as округл from chinook.invoice;
-- floor
select floor(avg(total)) as округл from chinook.invoice;
select (avg(total)* 0.95) as округл from chinook.invoice;
select floor(avg(total)* 0.95) as округл from chinook.invoice;
-- round
select round(avg(total)) as округл from chinook.invoice;
select round(avg(total)* 0.95) as округл from chinook.invoice;
-- Отсортируйте страны в порядке возрастания/убывания 
select country from chinook.customer ORDER BY country ASC;
-- Отсортируйте уникальные страны в порядке возрастания/убывания
select distinct country from chinook.customer ORDER BY country ASC;
-- Посчитайте количество покупателей из каждой страны
select country from chinook.customer group by country;
-- ??
select distinct country, count(*) as total from chinook.customer group by country ;
select country, count(*) as total from chinook.customer group by country;
-- показать всех исполнителей и посчитать общую стоимость треков. Столбцу unitPrice дать название total
select composer, sum(UnitPrice) as total from chinook.track group by Composer;
-- HAVING
/* Найдите счета-фактуры выставленные в страны с общей суммой более 100 долларов. 
Выведите страну и стоимость. Столбцу total дать название total_sum */
select BillingCountry, sum(total) total_sum from chinook.invoice group by BillingCountry having total_sum > 100 order by total_sum;
-- LIMIT
select * from chinook.invoice LIMIT 5;
select * from chinook.employee limit 2, 3; 
-- 1.	Покажите клиентов с именем Френк.
select * from chinook.customer where FirstName like 'Frank';
-- 2.	Покажите фамилии и имя клиентов, у которых имя Mарк.
select LastName, FirstName from chinook.customer where FirstName like 'Mar_';
-- 3.	Покажите название и размер треков в Мегабайтах, применив округление до 2 знаков и отсортировав по убыванию. Столбец назовите MB.
select Name, round(Bytes/1048576, 2) as MB from chinook.track order by Bytes desc;
-- 4.	Покажите возраст сотрудников, на момент оформления на работу. Вывести фамилию, имя, возраст. дату оформления и день рождения. Столбец назовите age.*
SELECT LastName, FirstName, ceiling(datediff(HireDate, BirthDate)/365) as Age, HireDate, BirthDate from chinook.employee;
-- Необходимо будет “загуглить” решение данной задачи в интернет. 
-- Один из вариантов решения задачи здесь: https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html#function_datediff   
-- 5.	Покажите покупателей-американцев без факса.
select * from chinook.customer where Country like 'USA' and Fax is null;
-- 6.	Покажите почтовые адреса клиентов из домена gmail.com.
select Address, Email from chinook.customer where Email like '%gmail.com';
-- 7.	Покажите в алфавитном порядке все уникальные должности в компании.
select distinct title from chinook.employee order by title;
--- Review
select title from chinook.employee group by title order by title asc;
-- 8.	Покажите название самой короткой песни.
select Name, Milliseconds from chinook.track order by Milliseconds limit 1;
--- Review
select Name, Milliseconds from chinook.track where Milliseconds = (select min(Milliseconds) from chinook.track);
-- 9.	Покажите название и длительность в секундах самой короткой песни. Столбец назвать sec.
select Name, Milliseconds / 1000 as Sec from chinook.track order by Milliseconds limit 1;
-- 10.	Покажите средний возраст сотрудников, работающих в компании*.
SELECT avg(datediff(HireDate, BirthDate)/365) as average from chinook.employee;
--- Review
SELECT round(avg(datediff(sysdate(), BirthDate)/365)) as average from chinook.employee;
-- 11.	Проведите аналитическую работу: узнайте фамилию, имя и компанию покупателя (номер 5). Сколько заказов он сделал и на какую сумму. Покажите 2 запроса Вашей работы.
select LastName, FirstName, Company from chinook.customer where CustomerId = '5';
select count(invoiceId), sum(total) from chinook.invoice where CustomerId = '5';
-- 12.	Напишите запрос, определяющий количество треков, где ID плейлиста > 15. Назовите столбцы соответственно их расположения.  Полученный результат должен быть таким:
 -- condition/result
 -- 	16	/	15
 -- 	17	/	26
 -- 	18	/	1
select PlaylistId, count(TrackId) from chinook.playlisttrack where PlaylistId > '15' group by PlaylistId;
--- Review
select PlaylistId 'Condition', count(TrackId) 'Resut' from chinook.playlisttrack where PlaylistId > '15' group by PlaylistId;
-- 13.	Найти все ID счет-фактур, в которых количество товаров больше или равно 6 и меньше или равно 9.
select * from chinook.invoiceline;
select InvoiceId, sum(Quantity) from chinook.invoiceline group by InvoiceId;
select InvoiceId, sum(Quantity) from chinook.invoiceline group by InvoiceId having sum(Quantity) between '6' and '9';

-- P.S. Если останется время, постарайтесь: 
-- 1) составить задание на выполнение запроса для таблицы invoiceline так, чтобы запрос содержал агрегирующие функции с использованием группировки;
select * from chinook.invoiceline;
-- Найти все ID счет-фактур, в которых сумма покупки больше 3
-- 2) подготовить и выполнить запрос на основании п.1
select InvoiceId, sum(UnitPrice) from chinook.invoiceline group by InvoiceId having sum(UnitPrice) > '3';
-- 3) составить задание на выполнение запроса, которое бы отбирало уникальные значения из таблицы
select * from chinook.invoiceline;
select * from chinook.track;
-- Найти количество счет-фактур, в которых содержится песня 'Inject The Venom' (TrackId = '8')
-- 4) подготовить и выполнить запрос на основании п.3
select count(InvoiceId), TrackId from chinook.invoiceline where TrackID = '8';
-- 5) Покажите штаты (округа) стран, где количество покупателей не больше 1
select * from chinook.invoice;
select distinct CustomerId, BillingState from chinook.invoice where BillingState is not null;