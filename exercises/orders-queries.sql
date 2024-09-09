-- QUESTIONS

-- 1. MISE EN PLACE

-- 1.1 Diagramme d'entite/relation

-- - A quoi correspond la table "order_line"?
-- Division de la commande à la référence: 
-- -> si une commande concerne "x" références, on dit qu'elle est composée de "x" lignes de commandes.

-- - A quoi sert la colonne "order_id"?
-- A faire le lien avec customer_order -> order_id = customer_order.id
-- => client_id = client.id

-- **********************************************************************************

-- 2. REQUETES A ECRIRE

-- 1. Récupérer l’utilisateur ayant le prénom “Muriel” et le mot de passe “test11”, sachant 
-- que l’encodage du mot de passe est effectué avec l’algorithme Sha1. 
select *
from client
where first_name = 'Muriel' and password = encode(digest('test11','sha1'),'hex');

-- 2. Récupérer la liste de tous les produits qui sont présents sur plusieurs commandes.
select last_name, count(*)
from order_line
group by last_name
having count(*)>1;

-- 3. Enregistrer le prix total à l’intérieur de chaque ligne des commandes, en fonction du 
-- prix unitaire et de la quantité (il vous faudra utiliser une requête de mise à jour d’une 
-- table : « UPDATE TABLE ».
update order_line
set total_price = (quantity*unit_price);

-- 4. Récupérer le montant total pour chaque commande et afficher la date de commande 
-- ainsi que le nom et le prénom du client. 
update customer_order as co
set total_price_cache = 
(
select sum(ol.total_price)
from order_line as ol
where co.id = ol.order_id
group by ol.order_id
);

select co.total_price_cache, co.purchase_date, c.first_name, c.last_name
from customer_order as co
join client as c
on co.client_id = c.id;

-- 5. Récupérer le montant global de toutes les commandes, pour chaque mois.
select extract(month from purchase_date), sum(total_price_cache) as "Somme"
from customer_order
group by extract(month from purchase_date)
order by extract asc;

-- 6. Récupérer la liste des 10 clients qui ont effectué le plus grand montant de 
-- commandes, et obtenir ce montant total pour chaque client.
select
	c.first_name,
	c.last_name,
	sum(co.total_price_cache) as total_order_amount
from
	client c
join customer_order co on
	c.id = co.client_id
group by
	c.first_name,
	c.last_name
order by
	total_order_amount desc
limit 10;

-- 7. Récupérer le montant total des commandes pour chaque jour. 
select extract(day from purchase_date), sum(total_price_cache) as "Somme"
from customer_order
group by extract(day from purchase_date)
order by extract asc;

-- 8. Ajouter une colonne intitulée “category” à la table contenant les commandes. Cette 
-- colonne contiendra une valeur numérique (il faudra utiliser « ALTER TABLE ».
alter table order_line 
add column category int4;

-- 9. Enregistrer la valeur de la catégorie, en suivant les règles suivantes : 
-- o “1” pour les commandes de moins de 200€ 
-- o “2” pour les commandes entre 200€ et 500€ 
-- o “3” pour les commandes entre 500€ et 1.000€ 
-- o “4” pour les commandes supérieures à 1.000€ 
-- Plusieurs solutions peuvent être envisagées pour répondre à la demande : - 
-- Utiliser plusieurs requête « UPDATE » en adaptant la condition ; - 
-- Utiliser une seule requête « UPDATE » en y ajoutant un « CASE ». 
UPDATE order_line
SET category = 1
WHERE total_price < 200;

UPDATE order_line
SET category = 2
WHERE total_price >= 200 AND total_price < 500;

UPDATE order_line
SET category = 3
WHERE total_price >= 500 AND total_price < 1000;

UPDATE order_line
SET category = 4
WHERE total_price >= 1000;


update order_line
set category = case 
	when total_price < 200 then 1
	when total_price >= 200 and total_price < 500 then 2
	when total_price >= 500 and total_price < 1000 then 3
	else 4
end;