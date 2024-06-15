-- Покажите содержимое списка клиентов. Вывести Фамилию, Имя, телефон и е-мейл клиента
select FirstName, LastName, Phone, Email from chinook.customer;
-- Покажите  содержимое продаж. Вывести дату покупки, город в которую совершена продажа и стоимость покупки. Стоимость покупки назвать как "Итог"
select InvoiceDate, BillingCity, Total as Итог from chinook.invoice;
-- Отобрать все музыкальные треки с ценой  меньше 1 доллара.
select * from chinook.track where UnitPrice < 1;
-- Отобрать все музыкальные треки с ценой больше 1 доллара.
select * from chinook.track where UnitPrice < 1;
-- Отобрать все музыкальные треки с ценой не равной 0.99 долларов.
select * from chinook.track where UnitPrice <> 0.99;
-- Покажите  содержимое продаж. Вывести дату покупки, город в которую совершена продажа и стоимость покупки больше 10 долл. Стоимость покупки назвать как "Итог"
select InvoiceDate, BillingCity, Total as Итог from chinook.invoice where Total > 10;
-- Как зовут работников-продавцов в компании? Показать фамилии и имена в одном столбце назвав FULL_NAME.
select concat(LastName,' ', FirstName) as FULL_NAME from chinook.employee;
-- Отобрать все треки, композиторами которых являются Red Hot Chili Peppers и Nirvana.
select * from chinook.track where Composer = 'Red Hot Chili Peppers' or Composer = 'Nirvana';
-- Показать все продажи с ценой больше 1.98 долларов и меньше 4 долларов
select * from chinook.invoice where Total > 1.98 and Total < 4;
select * from chinook.invoice where Total between 1.98 and 4;
-- Показать 3 композиторов из таблицы музыкальных треков
select * from chinook.track where Composer in ('Red Hot Chili Peppers','Apocalyptica', 'R.E.M.');
-- Отобрать все треки в названии которых содержится слово night.
select * from chinook.track where Name like '%night%';
-- Отобрать все треки, название которых начинается на букву b
select * from chinook.track where Name like 'b%';
-- Получить список треков в которых содержится буква b, где композиторы Apocalyptica и AC/DC
select * from chinook.track where Name like '%b%' and (Composer = 'Apocalyptica' or Composer = 'AC/DC');
-- Покажите содержимое таблицы исполнителей (артистов)
select * from chinook.artist;
-- Покажите фамилии и имена клиентов из города Париж
select FirstName, LastName, City from chinook.customer where City = 'Paris';
-- Покажите продажи за 2012 год, со стоимостью продаж более 4 долларов
select * from chinook.invoice where Total > 4 and InvoiceDate like '2012%';
-- Покажите дату продажи, адрес продажи, город в которую совершена продажа и стоимость покупки равную 16.86. Присвоить названия столбцам InvoiceDate – Дата_Продажи, BillingAddress – Адрес_Продажи и BillingCity - Город_Продажи.
select InvoiceDate as Дата_Продажи, BillingAddress as Адрес_Продажи, BillingCity as Город_Продажи, Total from chinook.invoice where total = 16.86;
-- Покажите фамилии и имена сотрудников компании, нанятых в 2004 году и проживающих в городе Lethbridge
select * from chinook.employee where City = 'Lethbridge' and HireDate like '2004%';
-- Покажите канадские города, в которые были сделаны продажи в августе 2009 года.
select BillingCity from chinook.invoice where BillingCountry = 'Canada' and InvoiceDate like '2009%';
-- Покажите Фамилии и имена работников, нанятых в мае. Решите 2-мя способами:
-- 		используя оператор like
select FirstName, LastName, HireDate from chinook.employee where HireDate like '_____05%';
-- 		используя форматирование даты*
select FirstName, LastName, HireDate from chinook.employee where date_format(HireDate, '%c') = 5;
-- неверный, но интересный --
select concat(FirstName, ' ', LastName) Full_Name, date_format (HireDate, '-5-') Month from chinook.employee;
-- Покажите фамилии и имена сотрудников, занимающих должности IT Staff и IT manager. Решите задание двумя способами: 
-- 		используя оператор IN
select FirstName, LastName, Title from chinook.employee where Title in ('IT Staff', 'IT manager');
-- 		используя логические операции
select FirstName, LastName, Title from chinook.employee where Title = 'IT Staff' or Title = 'IT manager';