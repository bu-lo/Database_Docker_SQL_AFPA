-- 2.3 FONCTION "FORMAT_DATE"

-- 2.3.2 Code à tester

-- 1. Analysez  le  code  de  la  fonction  et  essayez  de  comprendre  chacun  de  ses 
-- éléments. 

CREATE OR REPLACE FUNCTION format_date(date date, separator varchar) 
 RETURNS text 
 LANGUAGE plpgsql 
AS $$ 
begin 
    -- en plpgsql, l'opérateur de concaténation est || 
    return to_char(date, 'DD' || separator || 'MM' || separator || 'YYYY'); 
END; 
$$ 

select format_date('2023-02-01', '/');

-- 2. Utilisez  la  nouvelle  fonction  dans  une  requête  permettant  d’afficher toutes  les 
-- commandes avec un tiret (‘-‘) utilisé en tant que séparateur.
select format_date(o.date, '-'), o.supplier_id, o.comments 
from "order" as o;
-- => MOT RESERVE REQUETE SQL " "

-- **********************************************************************************

-- 2.4 FONCTION « GET_ITEM_COUNT » 

-- 2.4.2 Code à tester

CREATE OR REPLACE FUNCTION get_items_count() 
 RETURNS integer 
 LANGUAGE plpgsql 
AS $$ 
declare 
    items_count integer; 
    time_now time = now(); 
begin 
    select count(id) 
    into items_count 
    from item; 
 
    raise notice '% articles à %', items_count, time_now; 
 
    return items_count; 
END; 
$$

-- 3. Analysez et testez le  code,  comment  est  effectuée  l’affectation  de  la  variable 
-- « items_count » ?

select get_items_count();


-- **********************************************************************************

-- 2.5 FONCTION « COUNT_ITEMS_TO_ORDER » 

-- 4. Implémentez une fonction qui répond au besoin.

CREATE OR REPLACE FUNCTION count_items_to_order() 
 RETURNS integer 
 LANGUAGE plpgsql 
AS $$ 
declare 
    items_count integer; 
    time_now time = now(); 
begin 
    select count(id) 
    into items_count 
    from item
	where stock <= stock_alert; 
 
    raise notice '% articles en alerte à %', items_count, time_now; 
 
    return items_count; 
END; 
$$

select count_items_to_order();


-- **********************************************************************************

-- 2.6 FONCTION « BEST_SUPPLIER »

-- 5. Implémentez une fonction qui répond au besoin.

CREATE OR REPLACE FUNCTION best_supplier() 
 RETURNS integer 
 LANGUAGE plpgsql 
AS $$ 
declare 
    best_supplier integer; 
    time_now time = now(); 
begin 
    select supplier_id 
    into best_supplier 
    from "order"
	group by supplier_id
	order by count(supplier_id) desc
	limit 1;
 
    raise notice 'Best supplier ID: % at %', best_supplier, time_now; 
 
    return best_supplier; 
END; 
$$

select best_supplier();

-- **********************************************************************************

-- 2.7 FONCTION « SATISFACTION_STRING »

-- 2.7.2 Code à écrire

-- 6. Proposez deux fonctions, une basée sur un « if » et une autre sur un « switch-case ». 
-- Elles porteront les noms « satisfaction_string_if » et « satisfaction_string_case ». 

-- IF
CREATE OR REPLACE FUNCTION satisfaction_string_if(satisfaction_index integer)
 RETURNS varchar(30)
 LANGUAGE plpgsql 
AS $$ 
declare 
    satisfaction_note varchar(30); 
    time_now time = now();
begin 

	if satisfaction_index is Null then
	satisfaction_note = 'Sans commentaire';
	elsif satisfaction_index = 1 or satisfaction_index = 2 then
	satisfaction_note = 'Mauvais';
	elsif satisfaction_index = 3 or satisfaction_index = 4 then
	satisfaction_note = 'Passable';
	elsif satisfaction_index = 5 or satisfaction_index = 6 then
	satisfaction_note = 'Moyen';
	elsif satisfaction_index = 7 or satisfaction_index = 8 then
	satisfaction_note = 'Bon';
	elsif satisfaction_index = 9 or satisfaction_index = 10 then
	satisfaction_note = 'Excellent';
	else satisfaction_note = 'Valeur invalide';
	end if;

	raise notice 'Note: % à %', satisfaction_note, time_now; 
 
    return satisfaction_note; 
END; 
$$

-- SWITCH-CASE
CREATE OR REPLACE FUNCTION satisfaction_string_case(satisfaction_index integer)
 RETURNS varchar(30)
 LANGUAGE plpgsql 
AS $$ 
declare 
    satisfaction_note varchar(30); 
    time_now time = now();
begin 
	
	satisfaction_note := case
		when satisfaction_index is Null 
		then 'Sans commentaire'
	
		when satisfaction_index = 1 or satisfaction_index = 2 
		then 'Mauvais'
	
		when satisfaction_index = 3 or satisfaction_index = 4 
		then 'Passable'
	
		when satisfaction_index = 5 or satisfaction_index = 6 
		then 'Moyen'
	
		when satisfaction_index = 7 or satisfaction_index = 8 
		then 'Bon'
	
		when satisfaction_index = 9 or satisfaction_index = 10 
		then 'Excellent'
	
		else 'Valeur invalide'
	end;

	raise notice 'Note: % à %', satisfaction_note, time_now; 
 
    return satisfaction_note; 
END; 
$$

-- 7. Testez vos fonctions, en affichant le niveau de satisfaction des fournisseurs  en toutes 
-- lettres ainsi que leur identifiant et leur nom grâce à une requête « SELECT ».
-- IF
select s.id, s.name, satisfaction_string_if(s.satisfaction_index) as "Note"
from supplier as s;

-- SWITCH-CASE
select s.id, s.name, satisfaction_string_case(s.satisfaction_index) as "Note"
from supplier as s;


-- **********************************************************************************

-- 2.8 FONCTION « ADD_DAYS » 

-- 2.8.2 Code à écrire

-- 8. Créez la fonction « add_days ».

CREATE OR REPLACE FUNCTION add_days(date_in date, days_to_add integer)
 RETURNS date
 LANGUAGE plpgsql 
AS $$ 
declare 
    new_date date; 
    time_now time = now();
begin 
	
	select date_in + days_to_add
	into new_date;

    -- Ajout du nombre de jours à la date donnée
    -- new_date := date_in + days_to_add;

	raise notice 'Nouvelle date: % à %', new_date, time_now; 
 
    return new_date; 
END; 
$$


select add_days('2023-10-10' , 5) as "Nouvelle date";

-- Note: Si on veut supprimer une fonction:
DROP FUNCTION add_days(date,integer);


-- **********************************************************************************

-- 2.9 FONCTION « COUNT_ITEMS_BY_SUPPLIER »

-- 2.9.2 Code à écrire

-- 9. Créez la fonction « count_items_by_supplier ».

CREATE OR REPLACE FUNCTION count_items_by_supplier(supplier_idd integer)
 RETURNS integer
 LANGUAGE plpgsql 
AS $$ 
declare 
    number_articles integer = 0 ; 
    time_now time = now();
	supplier_exists boolean;
begin  
    supplier_exists = exists(select id from supplier s where s.id = supplier_idd); 
	
	if supplier_exists then

	select count(so.item_id) 
	into number_articles
	from sale_offer as so
	where so.supplier_id = supplier_idd
	group by so.supplier_id;

	raise notice 'Le fournisseur fournit % articles à %', number_articles, time_now; 

    else  
		 raise exception 'L''identifiant % n''existe pas', supplier_idd 
		 using HINT = 'Vérifiez l''identifiant du fournisseur.'; 
	end if; 
 
    return number_articles; 
END; 
$$
   

select so.supplier_id, count_items_by_supplier(so.supplier_id) as "Nb d'articles fournisseur"
from sale_offer as so;


select so.supplier_id, count_items_by_supplier(555) as "Nb d'articles fournisseur"
from sale_offer as so;


-- **********************************************************************************

-- 2.10  FONCTION « SALES_REVENUE » 

-- 2.10.2 Code à écrire

-- 9. Créez la fonction « sales_revenue »,  qui  en  fonction  d’un  identifiant 
-- fournisseur et d’une année entrée en paramètre, restituera le chiffre d’affaires 
-- de ce fournisseur pour l’année souhaitée.
alter table order_line
	add column total_price_line float;
	
	update order_line as ol
	set total_price_line = ol.ordered_quantity*ol.unit_price;


	alter table "order"
	add column total_price float;

	update "order" as o
	set total_price = 
		(
		select sum(ol.total_price_line)
		from order_line as ol
		where o.id = ol.order_id
		group by ol.order_id
		);


CREATE OR REPLACE FUNCTION sales_revenue(supplier_idd integer,year integer)
 RETURNS float
 LANGUAGE plpgsql 
AS $$ 
declare 
	supplier_exists boolean;
    réel float; 
    time_now time = now();
	tax float = 1.2;
begin  
    supplier_exists = exists(select id from supplier s where s.id = supplier_idd); 
	
	if supplier_exists then

	select sum(o.total_price) * tax
	into réel
	from "order" as o
	where o.supplier_id = supplier_idd and extract(year from o.date) = year
	group by o.supplier_id;

	raise notice 'Le fournisseur % a fait un chiffre d''affaire de % en %, %', supplier_idd,  réel, "year", time_now; 

    else  
		 raise exception 'L''identifiant % n''existe pas', supplier_idd 
		 using HINT = 'Vérifiez l''identifiant du fournisseur.'; 
	end if; 
 
    return réel; 
END; 
$$
   

select o.supplier_id, sales_revenue(o.supplier_id, 2021) as "Chiffre d'affaire"
from "order" as o;


-- Ex test partie fct hors fonction:
select sum(o.total_price) * 1.2
	from "order" as o
	where o.supplier_id = 120 and extract(year from o.date) = 2021
	group by o.supplier_id;


-- **********************************************************************************

-- 2.11  FONCTION « GET_ITEMS_STOCK_ALERT »

-- 2.11.2 Code à écrire

-- 10. Complétez la fonction afin qu’elle puisse fonctionner comme attendu. 
DROP FUNCTION get_items_stock_alert(); 

create or replace function get_items_stock_alert()  
    returns table ( 
        id integer, 
        item_code character(4),
        name varchar,
        stock_diff integer
    )  
    language plpgsql 
as $$ 

begin 
    return query  
        select i.id, i.item_code, i.name, (i.stock_alert-i.stock)
        from item as i 
        where i.stock < i.stock_alert;          
end;$$

select * from get_items_stock_alert();

-- **********************************************************************************

-- 2.12  PROCEDURE DE CREATION D’UTILISATEUR

-- 2.12.2 Code à écrire 
-- Implémentez  la  fonction  effectuant  un  « insert ».  Avant  cette  requête  vérifiez  les  paramètres  de 
-- procédure.

CREATE TABLE public.user (
	id SERIAL primary KEY,
	email varchar(100) not null,
	last_connection timestamp,
	"password" varchar(50) not null,
	"role" varchar(20) not null
);

create or replace procedure insert_user(email varchar, "password" varchar, "role" varchar)  
    language plpgsql 
as $$ 

begin 
	
if email similar to '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'then
raise exception 'L''email % est incorrect!', email 
		 using HINT = 'Format incorrect.'; 
end if;

if length("password")<8 then
raise exception 'Le password % est incorrect!', password 
		 using HINT = 'Minimum 8 caractères.'; 
end if;

if "role" not in('MAIN_ADMIN','ADMIN','COMMON') then
raise exception 'Le role % est incorrect!', role 
		 using HINT = '"MAIN_ADMIN" ou "ADMIN" ou "COMMON"'; 
end if;

insert into public."user"(email,password,role) values (email, encode(digest(password, 'sha1'), 'hex'), role);
end;
$$;


call insert_user('chloe.boivin@outlook.com','motdepassss','MAIN_ADMIN');

-- *** IMPORTANT ***
-- MODIFICATION DE LA  PROCEDURE POUR QUE MDP EN SHA1 BDD
-- EXTENSION "pgcrypto"
-- ***

-- **********************************************************************************

-- 2.13  FONCTION DE CONNEXION D’UN UTILISATEUR

-- 2.13.2 Code à écrire
alter table "user" 
add column connexion_attempt integer default 0,
add column blocked_account boolean default false;

CREATE OR REPLACE FUNCTION user_connection(user_email TEXT, user_password TEXT) 
RETURNS BOOLEAN 
LANGUAGE plpgsql 
AS $function$ 
DECLARE  
    user_id_reference INT;                -- Identifiant de l'utilisateur récupéré en base de données 
    user_password_reference TEXT;         -- Le mot de passe de l'utilisateur récupéré en base de données 
    user_exists BOOLEAN;                  -- Indicateur d'existence de l'utilisateur 
    hashed_password TEXT;                 -- Contient le mot de passe haché 
    connexion_attempts INT;               -- Nombre de tentatives de connexion infructueuses 
    blocked_account BOOLEAN;              -- Indicateur si le compte est bloqué ou non 
BEGIN 
    -- Vérification de l'existence de l'utilisateur 
    SELECT u."password", u.connexion_attempt, u.blocked_account 
    INTO user_password_reference, connexion_attempts, blocked_account 
    FROM "user" u 
    WHERE u.email = user_email; 
    
    -- Si l'utilisateur n'existe pas ou si le compte est bloqué 
    IF NOT FOUND THEN
        RAISE NOTICE 'L''utilisateur ayant pour email % n''existe pas.', user_email;
        RETURN FALSE;
    ELSIF blocked_account THEN
        RAISE NOTICE 'Le compte pour l''utilisateur % est bloqué.', user_email;
        RETURN FALSE;
    END IF;

    -- Calcul du hash du mot de passe passé en paramètre 
    hashed_password = encode(digest(user_password, 'sha1'), 'hex'); 
    
    -- Vérification du mot de passe 
    IF hashed_password = user_password_reference THEN 
        -- Connexion réussie : réinitialisation du compteur de tentatives et mise à jour de la date de connexion
        UPDATE "user" 
        SET last_connection = NOW(), 
            connexion_attempt = 0 
        WHERE email = user_email;
        
        RETURN TRUE; 
    ELSE 
        -- Si le mot de passe est incorrect, incrémenter le compteur de tentatives 
        connexion_attempts := connexion_attempts + 1;

		-- Mettre à jour le compteur de tentatives avant l'affichage
        UPDATE "user" 
        SET connexion_attempt = connexion_attempts 
        WHERE email = user_email;

		-- Afficher le nombre de tentatives après la mise à jour
		RAISE NOTICE 'Total tentatives:%', connexion_attempts; 

        -- Si le nombre de tentatives atteint 3, bloquer le compte 
        IF connexion_attempts >= 3 THEN 
            UPDATE "user" 
            SET blocked_account = TRUE 
            WHERE email = user_email;

            RAISE NOTICE 'Le compte de l''utilisateur % est maintenant bloqué après 3 tentatives infructueuses.', user_email;
        END IF;
        
        RETURN FALSE; 
    END IF;

END 
$function$;

-- BONNE REQUETE BDD:
select user_connection('chloe.boivin@outlook.com','motdepassss'),connexion_attempt, blocked_account from "user";

-- EX MAUVAIS MAIL:
select user_connection('chloe.boivin@outlook.con','motdepassss'),connexion_attempt, blocked_account from "user";
-- EX MAUVAIS MDP:
select user_connection('chloe.boivin@outlook.com','motdetassss'),connexion_attempt, blocked_account from "user";


-- **********************************************************************************
-- **********************************************************************************

-- 3.  CREATION DE DECLENCHEURS (TRIGGERS) 

-- 3.2 DECLENCHEURS AFFICHANT DES MESSAGES

-- 3.2.1 Message avant un "INSERT"

-- 3.2.1.2 Création de la fonction

CREATE OR REPLACE FUNCTION display_message_on_supplier_insert() 
 RETURNS trigger
 LANGUAGE plpgsql 
AS $$ 
BEGIN 
  raise notice '" Un ajout de fournisseur va être fait. Le nouveau fournisseur est % ."', NEW.name; 
  return NEW;
 
END; 
$$

-- 3.2.1.3 Création du déclencheur

create or replace trigger before_insert_supplier -- "before_insert_supplier" est le nom du déclencheur 
before insert -- indication sur le type d'évènement du déclencheur 
on public.supplier -- nom de la table concernée 
for each row -- quand se déclencher ? ROW ou statement (explication ci-dessous) 
execute function display_message_on_supplier_insert(); -- appel de la fonction lorsque le déclencheur s'active

insert into public.supplier(id,"name",address,postal_code,city,contact_name,satisfaction_index) values ('77777','Super','Rue de rue','33333','Bdx','Gilgert F','7');

-- => " Un ajout de fournisseur va être fait. Le nouveau fournisseur est Super ."


--3.2.2 Message après un "UPDATE"

CREATE OR REPLACE FUNCTION display_message_on_supplier_update() 
 RETURNS trigger 
 LANGUAGE plpgsql 
AS $$ 
BEGIN 
  raise notice '"Mise à jour de la table des fournisseurs. Le nouveau fournisseur est % . Le précédent était %."', NEW.name, OLD.name; 
  return null;
 
END; 
$$

create or replace trigger before_update_supplier -- "before_insert_supplier" est le nom du déclencheur 
after update -- indication sur le type d'évènement du déclencheur 
on public.supplier -- nom de la table concernée 
for each row -- quand se déclencher ? ROW ou statement (explication ci-dessous) 
execute function display_message_on_supplier_update(); -- appel de la fonction lorsque le déclencheur s'active

UPDATE public.supplier
SET
    "name" = 'Super 2',
    address = 'Rue de rue',
    postal_code = '33333',
    city = 'Bdx',
    contact_name = 'Gilgert F',
    satisfaction_index = 7
WHERE id = 1 ;


-- **********************************************************************************

-- 3.3 DECLENCHEURS EMPECHANT UNE REQUETE

-- 3.3.1 Empêcher la suppression de l’administrateur principal 

-- 11. Créez un déclencheur de type « before delete » appelant cette nouvelle 
-- fonction  
CREATE OR REPLACE function check_user_delete() 
 RETURNS trigger 
 LANGUAGE plpgsql 
AS $function$ 
begin 
    if old.role = 'MAIN_ADMIN' then 
        raise exception 'Impossible de supprimer l`''utilisateur %. Il s''agit de l''administrateur principal.', old.id; 
    end if; 
  return OLD; 
END; 
$function$

create or replace trigger before_user_delete -- "before_insert_supplier" est le nom du déclencheur 
before delete -- indication sur le type d'évènement du déclencheur 
on public."user" -- nom de la table concernée 
for each row -- quand se déclencher ? ROW ou statement (explication ci-dessous) 
execute function check_user_delete(); -- appel de la fonction lorsque le déclencheur s'active

delete from "user" where "role" like 'MAIN_ADMIN';

-- **********************************************************************************

-- 3.3.2 Empêcher la suppression des commandes non livrées

-- 12. Implémentez  une fonction ainsi que son déclencheur permettant d’empêcher ce type 
-- de suppression. 
CREATE OR REPLACE function check_orderline_delete() 
 RETURNS trigger 
 LANGUAGE plpgsql 
AS $function$ 
begin 
    if (old.ordered_quantity > old.delivered_quantity) 
	then raise exception '"Impossible de supprimer, cette commande n''est pas encore complète."'; 
    end if; 
  return null; 
END; 
$function$

create or replace trigger before_user_delete_orderline -- "before_insert_supplier" est le nom du déclencheur 
before delete -- indication sur le type d'évènement du déclencheur 
on public.order_line -- nom de la table concernée 
for each row -- quand se déclencher ? ROW ou statement (explication ci-dessous) 
execute function check_orderline_delete(); -- appel de la fonction lorsque le déclencheur s'active

delete from order_line where ordered_quantity > delivered_quantity;

-- **********************************************************************************

-- 3.4 DECLENCHEUR DE MODIFICATION DE CONTENU DE TABLES

-- 3.4.1 Modification des articles à commander

-- 13. Ecrivez le code de ce nouveau déclencheur 
-- ETAPE 1: création de la table
CREATE TABLE public.items_to_order(
	id SERIAL primary KEY,
	item_id  integer not null,
	date_update timestamp,
	quantity integer not null,
	foreign key (item_id) references item(id)
);

-- ETAPE 2: création d'une fonction qui met à jour la table

CREATE OR REPLACE FUNCTION display_message_on_stock_update() 
 RETURNS trigger 
 LANGUAGE plpgsql 
AS $$ 
BEGIN 
	if new.stock < new.stock_alert
	then insert into public.items_to_order(item_id, date_update, quantity)values(new.id,now(),new.stock);
	raise notice '"L''article % a atteint son stock d''alerte."', new.id; 
	end if;

  return new;
 
END; 
$$

create or replace trigger before_stock_update_supplier -- "before_insert_supplier" est le nom du déclencheur 
before update -- indication sur le type d'évènement du déclencheur 
on public.item -- nom de la table concernée 
for each row -- quand se déclencher ? ROW ou statement (explication ci-dessous) 
execute function display_message_on_stock_update(); -- appel de la fonction lorsque le déclencheur s'active

UPDATE public.item
set stock = 19
where id = 0;


-- ETAPE 3: Création du déclencheur

create or replace trigger after_stock_update_supplier -- "before_insert_supplier" est le nom du déclencheur 
after update -- indication sur le type d'évènement du déclencheur 
on public.item -- nom de la table concernée 
for each row -- quand se déclencher ? ROW ou statement (explication ci-dessous) 
execute function display_message_on_stock_update(); -- appel de la fonction lorsque le déclencheur s'active

UPDATE public.item
set stock = 10
where id = 0;

-- ETAPE 4: Empêcher la modification si la valeur est trop faible

CREATE OR REPLACE FUNCTION display_message_on_stock_update() 
 RETURNS trigger 
 LANGUAGE plpgsql 
AS $$ 
BEGIN 
	if new.stock < 0
	then raise exception '"Le stock ne peut pas être négatif."';
	return null;
	end if;

	if new.stock < new.stock_alert
	then insert into public.items_to_order(item_id, date_update, quantity)values(new.id,now(),new.stock);
	raise notice '"L''article % a atteint son stock d''alerte."', new.id; 
	end if;

  return new;
 
END; 
$$

create or replace trigger after_stock_update_supplier -- "before_insert_supplier" est le nom du déclencheur 
after update -- indication sur le type d'évènement du déclencheur 
on public.item -- nom de la table concernée 
for each row -- quand se déclencher ? ROW ou statement (explication ci-dessous) 
execute function display_message_on_stock_update(); -- appel de la fonction lorsque le déclencheur s'active

UPDATE public.item
set stock = -2
where id = 0;



-- **********************************************************************************

-- 3.4.2 Table d’audit 

-- 14. Inspirez-vous du code fourni pour créer votre table et développer le déclencheur 
-- approprié.

CREATE TABLE item_audit (
    audit_id SERIAL PRIMARY KEY,          -- Identifiant unique de l'enregistrement d'audit
    item_id INT NOT NULL,                 -- Identifiant de l'élément modifié dans la table 'item'
    operation_type VARCHAR(10),           -- Type d'opération (INSERT, UPDATE, DELETE)
    operation_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Horodatage de l'opération
    executed_by VARCHAR(100)              -- Utilisateur ayant effectué l'opération
);

CREATE OR REPLACE FUNCTION audit_item_changes() 
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        -- Enregistrement d'une opération INSERT
        INSERT INTO item_audit(item_id, operation_type, executed_by)
        VALUES (NEW.id, TG_OP, SESSION_USER);
        RETURN NEW;

    ELSIF (TG_OP = 'UPDATE') THEN
        -- Enregistrement d'une opération UPDATE
        INSERT INTO item_audit(item_id, operation_type, executed_by)
        VALUES (OLD.id, TG_OP, SESSION_USER);
        RETURN NEW;

    ELSIF (TG_OP = 'DELETE') THEN
        -- Enregistrement d'une opération DELETE
        INSERT INTO item_audit(item_id, operation_type, executed_by)
        VALUES (OLD.id, TG_OP, SESSION_USER);
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Trigger pour INSERT, UPDATE et DELETE
CREATE TRIGGER audit_item_changes_trigger
AFTER INSERT OR UPDATE OR DELETE ON item
FOR EACH ROW
EXECUTE FUNCTION audit_item_changes();

UPDATE public.item
set stock = 55
where id = 0;