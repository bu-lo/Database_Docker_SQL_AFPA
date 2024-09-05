-- 2. JOINTURE 

-- 1. Affichage de tous les employés et leur département (requête ci-dessus).
select * from employee e join department d on e.department_id = d.id;

select * from employee join department d on department_id = d.id;


-- **********************************************************************************

-- 3.1 SELECT ET JOINTURE ***

-- 2. Rechercher le numéro du département, le nom du département, le nom des 
-- employés classés par numéro de département (utilisez des alias pour les 
-- tables). 
select d.id, d.name, e.last_name
from department as d
join employee as e
	on d.id = e.department_id
order by d.id asc;

-- 3. Rechercher le nom des employés du département « Distribution ». 
select e.last_name, d.name
from department as d
join employee as e
on d.id = e.department_id
where d.name='distribution';


-- **********************************************************************************

-- 3.2 AUTO-JOINTURES ***

-- 4. Rechercher le nom et le salaire des employés qui gagnent plus que leur 
-- supérieur hiérarchique, et le nom et le salaire du supérieur. 
select e1.last_name, e1.salary, e2.last_name, e2.salary 
from employee as e1
join employee as e2
on e2.id = e1.superior_id
where e1.salary > e2.salary;

-- **********************************************************************************

-- 3.3 SOUS-REQUETE 

-- 5. Rechercher les employés du département « finance » en utilisant une sous
-- requête. 
select *
from employee
where department_id 
in (select id from department where name like 'finance');

-- 6. Rechercher le nom et le titre des employés qui ont le même titre que 
-- « Amartakaldire »
select e.last_name, e.title
from employee e
where e.title
in (select e2.title from employee e2 where e2.last_name = 'Amartakaldire');

-- 7. Rechercher le nom, le salaire et le numéro de département des employés qui 
-- gagnent plus qu'un seul employé du département 31, classés par numéro de 
-- département et salaire. 
select e.last_name, e.salary, e.department_id
from employee as e
where e.salary > any (select e2.salary from employee e2 where e2.department_id = '31')
order by department_id, salary;
-- => comment on peux faire département & salaire ? ***


-- 8. Rechercher le nom, le salaire et le numéro de département des employés qui 
-- gagnent plus que tous les employés du département 31, classés par numéro 
-- de département et salaire. 
select e.last_name, e.salary, e.department_id
from employee as e
where e.salary > all (select e2.salary from employee e2 where e2.department_id = '31')
order by department_id, salary;

-- 9. Rechercher le nom et le titre des employés du service 31 qui ont un titre que 
-- l'on trouve dans le département 32. 
select e.last_name, e.title
from employee as e
where e.department_id = '31' 
and e.title in (select e2.title from employee e2 where e2.department_id = '32');

-- 10. Rechercher le nom et le titre des employés du service 31 qui ont un titre que 
-- l'on ne trouve pas dans le département 32.
select e.last_name, e.title
from employee as e
where e.department_id = '31' 
and e.title not in (select e2.title from employee e2 where e2.department_id = '32');

-- 11. Rechercher le nom, le titre et le salaire des employés qui ont le même 
-- titre et le même salaire que « Fairant ».

select e.last_name, e.title, e.salary
from employee as e
where e.title = (select e2.title from employee e2 where e2.last_name = 'Fairant')
and e.salary = (select e2.salary from employee e2 where e2.last_name = 'Fairant');

select e.last_name, e.title, e.salary from employee e where (e.title, e.salary) = (select e2.title, e2.salary from employee e2 where e2.last_name = 'Fairant');


-- **********************************************************************************

-- 3.4 REQUETES EXTERNES ***

-- 12. Rechercher le numéro de département, le nom du département, le nom des 
-- employés, en affichant aussi les départements dans lesquels il n'y a personne, 
-- classés par numéro de département. 
select d.id, d.name, e.last_name
from department as d
left join employee as e
on d.id = e.department_id
order by d.id;

-- **********************************************************************************

-- 3.5 UTILISATION DE FONCTIONS D’AGREGATION (OU DE GROUPE)

-- 13. Calculer la moyenne des salaires des secrétaires (requête fournie ci-dessous) 
select avg(salary)
from employee 
where title like 'secrétaire';

-- **********************************************************************************

-- 3.6 LES GROUPES ***

-- 14. Calculer le nombre d’employé de chaque titre.
select title, count(*) from employee group by title;


-- 15. Calculer la moyenne des salaires et leur somme, par région.
select region_id, avg(salary), sum(salary)
from employee 
join department as d
on department_id = d.id
group by region_id;

-- **********************************************************************************

-- 3.7 LA CLAUSE « HAVING » ***

-- 16. Afficher les numéros des départements ayant au moins 3 employés. 
select department_id, count(*)
from employee 
group by department_id
having count(*)>=3;

-- 17. Afficher les lettres qui sont l'initiale d'au moins trois employés. 
select substring(last_name,1,1), count(*)
from employee 
group by substring(last_name,1,1)
having count(*)>=3;

-- 18. Rechercher le salaire maximum et le salaire minimum parmi tous les 
-- salariés et l'écart entre les deux. 
select max(salary), min(salary), max(salary)-min(salary) as "Ecart de salaire" from employee;

-- 19. Rechercher le nombre de titres différents. 
select count(distinct title)
from employee;

-- 20. Pour chaque titre, compter le nombre d'employés possédant ce titre. 
select distinct title, count(*)
from employee
group by distinct title;

-- 21. Pour chaque nom de département, afficher le nom du département et 
-- le nombre d'employés. 
select d.name, count(*)
from employee e
join department d 
on d.id = e.department_id
group by d.name;

-- 22. Rechercher les titres et la moyenne des salaires par titre dont la 
-- moyenne est supérieure à la moyenne des salaires des « Représentant ». 
select title, avg(salary)
from employee
group by title
having avg(salary) > (select avg(e2.salary)from employee as e2 where e2.title like 'représentant');

-- 23. Rechercher le nombre de salaires renseignés et le nombre de taux de 
-- commission renseignés. 
select count(salary) "Nb Salaires",count(commission_rate) as "Nb taux"
from employee;

