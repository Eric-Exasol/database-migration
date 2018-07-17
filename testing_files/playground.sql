create schema if not exists playground;

create or replace table staff (department varchar(20), name varchar(20));
insert into staff values ('sales', 'eric'),('sales', 'thomas'),('sales', 'valerie'),('sales', 'johannes');
insert into staff values ('marketing', '/*comment1*/'),('marketing', 'tina'),('marketing', '/*comment2*/'),('marketing', 'nico'),('marketing', 'sophie'),('marketing', '/*comment3*/');

create or replace table staff2 (department varchar(20), name varchar(20));
insert into staff2 values ('sales', 'eric'),('sales', 'thomas'),('sales', 'valerie'),('sales', 'johannes');
insert into staff2 values ('marketing', '/*comment1*/'),('marketing', 'tina'),('marketing', '/*comment2*/'),('marketing', 'nico'),('marketing', 'sophie'),('marketing', '/*comment3*/');


SELECT department, GROUP_CONCAT(name SEPARATOR ','), 
GROUP_CONCAT(
 case 
   when name like '/%/' then name 
 end
SEPARATOR '')
FROM staff GROUP BY department;


SELECT 2 as ord, s.* from staff s
union all
SELECT 1, s2.* from staff2 s2 order by ord;