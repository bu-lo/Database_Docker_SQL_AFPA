-- 2.3 PREMIERE VUE

-- 2.3.1 Création d'une vue

CREATE OR REPLACE VIEW hotel_station 
AS  
SELECT h.id AS "hotel_id", 
    h.station_id, 
    h.name as "Hotel name", 
    h.category, 
    h.address, 
    h.city, 
    s.name AS "Station name", 
    s.altitude 
FROM hotel h 
JOIN station s ON h.station_id = s.id;

-- Une fois la vue créée la requêter comme table physique: 
select * from hotel_station;


-- **********************************************************************************

-- 2.4 CREATION DE VUES

-- A partir de la base « hotel », créez les vues suivantes : 

-- 1. Vue 1 : Afficher la liste des réservations avec le nom des clients 
CREATE OR REPLACE VIEW vue_1
AS  
SELECT b.*,
c.last_name
FROM booking as b
JOIN client as c 
ON b.client_id = c.id;

-- Une fois la vue créée la requêter comme table physique: 
select * from vue_1;


-- 2. Vue 2 : Afficher la liste des chambres avec le nom de l’hôtel et le nom de la station
CREATE OR REPLACE VIEW vue_2
AS  
SELECT r.*,
h.name as "Hotel name",
s.name as "Station name"
FROM room as r
JOIN hotel as h
ON r.hotel_id = h.id
join station as s
on h.station_id = s.id;

-- Une fois la vue créée la requêter comme table physique: 
select * from vue_2;


-- 3. Vue 3 : Afficher les réservations avec le nom du client et le nom de l’hôtel

CREATE OR REPLACE VIEW vue_3
AS  
SELECT b.*,
c.last_name as "Last Name Client",
h.name as "Hotel Name"
FROM booking as b
JOIN client as c
on c.id = b.client_id
join room as r
on b.room_id = r.id
join hotel as h
on r.hotel_id = h.id;

-- Une fois la vue créée la requêter comme table physique: 
select * from vue_3;

-- **********************************************************************************

-- 3. RESTRICTION DE L'ACCES A LA 

-- 3.1 NOTION DE ROLES

-- Pour lister tous les rôles existants:
SELECT rolname FROM pg_roles; 


-- **********************************************************************************


-- 3.2 CREATION DE ROLES 

-- 1. Créez un utilisateur « application_admin » pouvant se connecter au SBGD
create role application_admin
login
password 'ExercisePassWord!33' ;

-- 2. Ajoutez  une  connexion  à  la  base  de  données  « hotel »  en  utilisant  votre  nouvel 
-- utilisateur dans votre client SQL. 

-- Connection -> hotels 2

-- 3. Essayez d’effectuer un select sur une table, que se passe-t-il ?
select *
from hotel;
-- -> SQL Error [42501]: ERROR: permission denied for table hotel


-- **********************************************************************************

-- 3.3 AJOUT DE PROVILEGES

-- 4. Accordez  les  privilèges  « SELECT »,  « INSERT »,  « UPDATE »  et  « DELETE »  à 
-- l’utilisateur « application_admin » sur toutes les tables sauf « station ». 
grant select, insert, update, delete
on hotel, room, booking, client
to application_admin;

-- 5. Essayez d’effectuer des requêtes.
select *
from hotel;
-- -> cette fois-ci ça marche

-- **********************************************************************************


-- 3.4 PRIVILEGES SUR UNE VUE

-- 6. Créez un nouveau rôle « application_client » pouvant se connecter à votre base de 
-- données. 
create role application_client
login
password 'ExercisePassWord!34' ;

-- 7. Ajoutez les privilèges de lecture des données uniquement sur votre vue permettant de 
-- retrouver chambres avec le nom de l’hôtel et le nom de la station (vue 2). 

-- RAPPEL CREATION VUE 2:

CREATE OR REPLACE VIEW vue_2
AS  
SELECT r.*,
h.name as "Hotel name",
s.name as "Station name"
FROM room as r
JOIN hotel as h
ON r.hotel_id = h.id
join station as s
on h.station_id = s.id;

-- Une fois la vue créée la requêter comme table physique: 
select * from vue_2;

-- Restrictions:
grant select 
on vue_2
to application_client;

-- 8. Testez vos permissions. 
select *
from vue_2;














