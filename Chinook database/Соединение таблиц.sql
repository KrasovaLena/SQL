-- Все задания выполнять только через JOIN
-- покажие имена клиентов и сотрудников
select firstname from chinook.customer
UNION
select firstname from chinook.employee;

select firstname from chinook.customer
UNION ALL
select firstname from chinook.employee;

-- INTERSECT
-- Покажите города в которых живут и сотрудники и клиенты. (используйте пример с урока № 4)
select city from chinook.customer where (city) IN (select city from chinook.employee);
select city from chinook.customer
INTERSECT
select city from chinook.employee;

-- Неявное соединение
-- Покажите данные счет-фактур и покупателя с ID = 16
select * from chinook.invoice;
select * from chinook.customer where customerId = 16;
select * from chinook.invoice, chinook.customer where chinook.invoice.customerID = chinook.customer.customerID and chinook.customer.customerId = 16;
-- Покажите данные счет-фактур и покупателя с ID = 16 (inner join)
select * from chinook.invoice inner join chinook.customer ON chinook.invoice.customerID = chinook.customer.customerID where chinook.customer.customerId = 16;
-- Покажите какие треки были куплены (покажите столбцы trackId, name, composer, unitprice, quantity)
select * from chinook.track;
select * from chinook.invoiceline;
select chinook.track.trackId, name, composer, chinook.invoiceline.unitprice, quantity from chinook.track inner join chinook.invoiceline on chinook.track.trackID = chinook.invoiceline.trackID;
-- Покажите данные счет-фактур и покупателя с ID = 16 (left join)
select * from chinook.invoice left join chinook.customer ON chinook.invoice.customerID = chinook.customer.customerID where chinook.customer.customerId = 16;
-- Покажите какие треки были куплены
select distinct chinook.track.trackId, name, composer, chinook.invoiceline.unitprice, quantity from chinook.track 
INNER join chinook.invoiceline on chinook.track.trackID = chinook.invoiceline.trackID;

select distinct chinook.track.trackId, name, composer, chinook.invoiceline.unitprice, quantity from chinook.track 
LEFT join chinook.invoiceline on chinook.track.trackID = chinook.invoiceline.trackID;

select distinct chinook.track.trackId, name, composer, chinook.invoiceline.unitprice, quantity from chinook.track 
RIGHT join chinook.invoiceline on chinook.track.trackID = chinook.invoiceline.trackID;

/* Покажите сколько раз покупали треки группы queen
Количество покупок необходимо посчитать по каждому треку 
Вывести название, ИД трека и количество купленных треков группы queen. */
select name, trackId, (select count(trackId) from chinook.invoiceline where trackid = chinook.track.trackid)
as total from chinook.track where Composer = 'Queen';
select * from chinook.invoiceline;
select name, chinook.track.trackId, count(chinook.invoiceline.trackId) from chinook.track 
left join chinook.invoiceline ON chinook.track.trackid = chinook.invoiceline.trackid
where Composer = 'Queen' group by name, chinook.track.trackId;
-- Покажите имена, фамилии покупателей, id счет-фактур и стоимость. Отсортировать столбец total по возрастанию
select * from chinook.customer;
select * from chinook.invoice;

select firstname, lastname, invoiceId, total from chinook.customer 
join chinook.invoice on chinook.customer.customerId = chinook.invoice.customerId order by total;
-- Покажите стоимость и количество всех покупок по каждому клиенту
select firstname, lastname, count(invoiceId), sum(total) from chinook.customer 
join chinook.invoice on chinook.customer.customerId = chinook.invoice.customerId group by firstname, lastname;

-- Покажите имя, фамилию покупателя (номер 16), компанию и общую сумму его заказов. Столбец назовите sum. (join)
select firstname, lastname, company, 
(select sum(total) from chinook.invoice where CustomerId = chinook.customer.CustomerId) as sum from chinook.customer where CustomerId = 16;

select firstname, lastname, company, sum(total) sum from chinook.customer 
JOIN chinook.invoice ON chinook.customer.CustomerId = chinook.invoice.CustomerId
where chinook.customer.CustomerId = 16 group by firstname;

-- Посчитайте количество треков в каждом альбоме. В результате вывести имя альбома и кол-во треков. (join)
select Title, (select count(*) from chinook.track where track.AlbumId = chinook.album.AlbumId) as count_track
from chinook.album order by title;

select chinook.track.albumId, Title, count(*) from chinook.track 
join chinook.album on chinook.track.AlbumId = chinook.album.AlbumId
group by albumId;
-- Отобразите сотрудников в компании и информацию о том, кому они подчиняются (self join)
select * from chinook.employee;
select LastName, FirstName, title, ReportsTo from chinook.employee;
select epm1.LastName, epm1.FirstName, epm1.title, epm1.ReportsTo, epm2.LastName, epm2.FirstName, epm2.title from chinook.employee epm1 
left join chinook.employee epm2 ON epm1.ReportsTo = epm2.employeeID;
-- Покажите все данные заказов покупателя (номер 13) и отсортируйте стоимость по возрастанию.
select * from chinook.customer
join chinook.invoice
on chinook.customer.CustomerId = chinook.invoice.CustomerId
where chinook.customer.CustomerId = 13
order by total;

-- Посчитайте количество треков в каждом альбоме. В результате вывести ID альбома, имя альбома и кол-во треков. 
select chinook.playlist.PlaylistId, chinook.playlist.Name, count(chinook.playlisttrack.TrackId) from chinook.playlist
join chinook.playlisttrack
on chinook.playlist.PlaylistId = chinook.playlisttrack.PlaylistId
group by chinook.playlist.PlaylistId, chinook.playlist.Name;

-- Посчитайте общую сумму продаж в США в 1 квартале 2012 года. Присвойте любой псевдоним столбцу.
select * from chinook.invoice;
select sum(Total) from chinook.invoice where BillingCountry = 'USA' and InvoiceDate between '2012-01-01 00:00:00' and '2012-04-01 00:00:00';

-- Выполните запросы по очереди и ответьте на вопросы:
-- Вернут ли данные запросы одинаковый результат?  Ответы: Да или НЕТ. *нет
-- Если ДА. Объяснить почему.
-- Если НЕТ. Объяснить почему. Разные типы джоинов 
-- Какой запрос вернет больше строк? Второй, потому что клиентов больше, чем специалистов службы поддержки  и при этом у каждого специалиста есть клиенты, но не
-- к каждому клиенту привязан специалист.

select chinook.customer.SupportRepId, chinook.employee.employeeId from chinook.customer left JOIN chinook.employee
ON chinook.customer.SupportRepId = chinook.employee.employeeId;

select chinook.customer.SupportRepId, chinook.employee.employeeId  from chinook.customer right JOIN chinook.employee
ON chinook.customer.SupportRepId = chinook.employee.employeeId;

-- Выполните запросы по очереди и ответьте на вопросы:
-- Вернут ли данные запросы одинаковый результат? Ответы: Да или НЕТ. *нет
-- Если ДА. Объяснить почему.
-- Если НЕТ. Объяснить почему. Разные типы джоинов 
-- Какой запрос вернет больше строк ? В первом запросе вообще не будет строк, потому что у нас не будет нулевых строк с именем специалистов поддержки, второй запрос выведет всех
-- клиентов у которых нет привязанных к ним специалистов поддержки

select chinook.customer.SupportRepId, chinook.employee.employeeId from chinook.customer LEFT JOIN chinook.employee
ON chinook.customer.SupportRepId = chinook.employee.employeeId
where chinook.employee.FirstName is null;

select chinook.customer.SupportRepId, chinook.employee.employeeId from chinook.customer LEFT JOIN chinook.employee
ON chinook.customer.SupportRepId = chinook.employee.employeeId
and chinook.employee.FirstName is null;

-- Покажите количество и среднюю стоимость треков в каждом жанре. Вывести ID жанра, название жанра, количество и среднюю стоимость.
select chinook.genre.GenreId, chinook.genre.Name, count(TrackId), avg(UnitPrice) from chinook.genre
join chinook.track
on chinook.genre.GenreId = chinook.track.GenreId
group by chinook.genre.GenreId, chinook.genre.Name;

-- Покажите клиента, который потратил больше всего денег. Для сокращения количества символов в запросе, используйте псевдонимы. 
-- Для ограничения количества записей используйте оператор "limit". Вывести ID покупателя, имя, фамилию и стоимость покупок
select chinook.customer.CustomerId, FirstName, LastName, sum(Total) from chinook.customer
join chinook.invoice
on chinook.customer.CustomerId = chinook.invoice.CustomerId
group by chinook.customer.CustomerId, FirstName, LastName
order by sum(Total)
limit 1;

-- Extra (используется соединение 3х таблиц)
-- Покажите список названий альбомов, ID альбомов, количество треков и общую цену альбомов для исполнителя Audioslave.
select chinook.artist.Name, chinook.album.Title, chinook.album.AlbumId, count(chinook.track.TrackId), sum(chinook.track.UnitPrice) from chinook.track
join chinook.album
on chinook.track.AlbumId = chinook.album.AlbumId
join chinook.artist
on chinook.album.ArtistId = chinook.artist.ArtistId
group by chinook.album.Title, chinook.album.AlbumId
having chinook.artist.Name like 'Audioslave';