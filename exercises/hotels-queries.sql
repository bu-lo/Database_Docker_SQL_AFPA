-- 1. CREATION DE LA BASE DE DONNEES

-- **********************************************************************************

-- 2. CREATION D’UN JEU DE TEST 

-- Alimentez la base de données avec un jeu de test minimaliste en créant un script permettant de : 
-- • Insérer au moins 2 stations ; 
-- • Insérer au moins 2 hôtels par station ; 
-- • Insérer au moins 2 chambres par hôtel ; 
-- • Insérer au moins 2 clients. 

-- **********************************************************************************

-- 3. REQUETES A ECRIRE 

-- 3.1 LOT 1 

-- 1 - Afficher la liste des hôtels : Le résultat doit faire apparaître le nom de l’hôtel et la ville 
select name, city
from hotel;

-- 2 - Afficher la ville de résidence de Mr White : Le résultat doit faire apparaître le nom, le prénom, 
-- et l'adresse du client 
select first_name, last_name, address
from client;

-- 3 - Afficher la liste des stations dont l’altitude < 1000 : Le résultat doit faire apparaître le nom de 
-- la station et l'altitude 
select name, altitude
from station
where altitude < 1000;

-- 4 - Afficher la liste des chambres ayant une capacité > 1 : Le résultat doit faire apparaître le 
-- numéro de la chambre ainsi que la capacité 
select number, capacity
from room
where capacity > 1;

-- 5 - Afficher les clients n’habitant pas à Londres : Le résultat doit faire apparaître le nom du client 
-- et la ville 
select last_name, city
from client
where city != 'Londres';

-- 6 - Afficher la liste des hôtels située sur la ville de Bretou et possédant une catégorie > 3 : Le 
-- résultat doit faire apparaître le nom de l'hôtel, ville et la catégorie 
select name, city, category
from hotel
where city like 'Bretou' and category > 3;


-- **********************************************************************************

-- 3.2 LOT 2 

-- 7 - Afficher la liste des hôtels avec leur station : Le résultat doit faire apparaître le nom de la 
-- station, le nom de l’hôtel, la catégorie, la ville) 
select s.name, h.name, h.category, h.city
from station as s
join hotel as h
on s.id = h.station_id ;

-- 8 - Afficher la liste des chambres et leur hôtel : Le résultat doit faire apparaître le nom de l’hôtel, la 
-- catégorie, la ville, le numéro de la chambre) 
select h.name, h.category, h.city, r.number
from room as r
join hotel as h
on h.id = r.hotel_id;

-- 9 - Afficher la liste des chambres de plus d'une place dans des hôtels situés sur la ville de 
-- Bretou : Le résultat doit faire apparaître le nom de l’hôtel, la catégorie, la ville, le numéro de la 
-- chambre et sa capacité) 
select h.name, h.category, h.city, r.number, r.capacity
from room as r
join hotel as h
on h.id = r.hotel_id
where capacity > 1;

-- 10 - Afficher la liste des réservations avec le nom des clients : Le résultat doit faire apparaître le 
-- nom du client, le nom de l’hôtel, la date de réservation 
select c.last_name, h.name, b.booking_date
from booking as b
join client as c
on c.id = b.client_id
join room as r
on b.room_id = r.id 
join hotel as h
on r.hotel_id= h.id;

-- 11 - Afficher la liste des chambres avec le nom de l’hôtel et le nom de la station : Le résultat doit 
-- faire apparaître le nom de la station, le nom de l’hôtel, le numéro de la chambre et sa capacité)
select s.name,h.name,r.number,r.capacity
from station as s
join hotel as h
on s.id = h.station_id 
join room as r 
on h.id = r.hotel_id;

-- 12 - Afficher les réservations avec le nom du client et le nom de l’hôtel : Le résultat doit faire 
-- apparaître le nom du client, le nom de l’hôtel, la date de début du séjour et la durée du séjour
select c.last_name, h.name, b.stay_start_date, (b.stay_end_date - b.stay_start_date) as "Durée"
from booking as b
join client as c
on c.id = b.client_id
join room as r
on b.room_id = r.id 
join hotel as h
on r.hotel_id= h.id;

-- **********************************************************************************

-- 3.3 LOT 3 

-- 13 - Compter le nombre d’hôtel par station
select s.name, count(h.station_id)
from station as s
join hotel as h
on s.id = h.station_id
group by s.name;

-- 14 - Compter le nombre de chambre par station 
select s.name, count(r.id)
from station as s
join hotel as h
on s.id = h.station_id
join room as r
on h.id = r.hotel_id
group by s.name;

-- 15 - Compter le nombre de chambre par station ayant une capacité > 1 
select s.name, count(r.id)
from station as s
join hotel as h
on s.id = h.station_id
join room as r
on h.id = r.hotel_id
where r.capacity > 1
group by s.name;

-- 16 - Afficher la liste des hôtels pour lesquels Mr Squire a effectué une réservation 
select h.name, c.last_name, count(b.id)
from booking as b
join client as c
on c.id = b.client_id
join room as r
on b.room_id = r.id 
join hotel as h
on r.hotel_id= h.id
where c.last_name like 'Squire'
group by h.name, c.last_name;

-- 17 - Afficher la durée moyenne des réservations par station 
select s.name, avg((b.stay_end_date - b.stay_start_date))
from booking as b
join room as r
on b.room_id = r.id 
join hotel as h
on r.hotel_id= h.id
join station as s
on s.id = h.station_id
group by s.name;

