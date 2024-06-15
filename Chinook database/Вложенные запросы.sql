-- 0	Покажите длительность самой длинной песни. Столбец назвать sec.
select Milliseconds as sec from chinook.track where Milliseconds = 
(select max(Milliseconds) from chinook.track);
-- 1 Покажите название и длительность в секундах самой длинной песни. Столбец назвать sec
select name, Milliseconds/1000 sec from chinook.track where Milliseconds = (select max(Milliseconds) from chinook.track);
-- 2 Покажите информацию о самой короткой песне.
select * from chinook.track where milliseconds = (select min(milliseconds) from chinook.track);
-- 3 Покажите все счёт-фактуры, стоимость которых выше средней
select * from chinook.invoice;
select avg(total) from chinook.invoice;
select customerId, InvoiceDate, BillingAddress, Total from chinook.invoice where total > (select avg(total) from chinook.invoice);
-- 4 Вывести трекИД и названия треков,  которые есть в счет-фактурах
select * from chinook.track;
select * from chinook.invoiceline;
select TrackId, Name from chinook.track where TrackId IN (select  TrackId from chinook.invoiceline);
-- 5 Покажите данные всех клиентов, чьи имена совпадают с именами сотрудников
select * from chinook.employee;
select * from chinook.customer;
select * from chinook.customer where firstname IN (select firstname from chinook.employee);
-- 6 Покажите имя, фамилию, компанию покупателя (номер 5) и общую сумму его заказов.
select firstname, lastname, company from chinook.customer where CustomerId = 5;
select count(*), sum(total) as sum from chinook.invoice where CustomerId = 5;
select firstname, lastname, company, (select sum(total) from chinook.invoice where CustomerId = chinook.customer.CustomerId) as sum from chinook.customer where CustomerId = 5;
select firstname, lastname, company, 
(select count(InvoiceId) from chinook.invoice where CustomerId = 5) as quantity, 
(select sum(total) from chinook.invoice where CustomerId = 5) as sum from chinook.customer where CustomerId = 5;
-- 7 Покажите количество треков с жанром РОК. Вывести жанр и количество  треков. Столбец назовите quantity.
select * from chinook.track;
select * from chinook.genre;
select * from chinook.track where genreId = 1;
select name, (select count(genreId) from chinook.track where genreId = chinook.genre.genreId) 
quantity from chinook.genre where genreId = 1;
-- 8 Покажите количество треков в плейлисте № 1 
select * from chinook.playlist;
select * from chinook.playlisttrack where playlistId = 1;
select PlaylistId, count(TrackId) from chinook.playlisttrack group by PlaylistId having playlistId = 
(select playlistId from chinook.playlist where playlistId = 1);
select PlaylistId, count(TrackId) from chinook.playlisttrack where playlistId = 1;
-- Покажите название и длительность в секундах самой короткой песни применив округление по правилам математики. Столбец назвать sec. +
select * from chinook.track;
select name, round(Milliseconds/1000, 0) sec from chinook.track where Milliseconds in (select min(Milliseconds) from chinook.track);
-- Покажите все счёт-фактуры, стоимость которых ниже средней. +
select * from chinook.invoice;
select * from chinook.invoice where Total < (select avg(Total) from chinook.invoice);
-- Покажите счёт-фактуру с высокой стоимостью. +
select * from chinook.invoice where Total = (select max(Total) from chinook.invoice);
-- Покажите города, в которых живут и сотрудники, и клиенты (используйте пример с урока № 4). + 
select * from chinook.employee;
select * from chinook.customer;
select City from chinook.employee where city in (select city from chinook.customer where city = chinook.customer.City);
-- review
select City from chinook.customer where city in (select city from chinook.employee);
-- Покажите имя, фамилию покупателя (номер 19), компанию и общую сумму его заказов. Столбец назовите sum. +
select FirstName, LastName, Company, (select sum(total) from chinook.invoice where CustomerId = 19) sum from chinook.customer where CustomerId = 19;
-- review
select FirstName, LastName, Company, (select sum(total) from chinook.invoice where CustomerId = chinook.customer.CustomerId) sum from chinook.customer where CustomerId = 19;
-- Покажите сколько раз покупали треки композитора группы Queen.  Количество покупок необходимо посчитать по каждому треку. Вывести название, ИД трека и количество купленных треков композитора группы Queen. Столбец назовите total. +
select * from chinook.track;
select * from chinook.invoiceline;
select Name, TrackID, (select count(Quantity) from chinook.invoiceline where TrackId = chinook.track.TrackId) as Total 
from chinook.track where Composer like 'Queen';
-- Посчитайте количество треков в каждом альбоме. В результате вывести имя альбома и кол-во треков. +
select * from chinook.album;
select * from chinook.track;
select Title, (select count(TrackID) from chinook.track where AlbumId = chinook.album.AlbumId) as Quantity from chinook.album;