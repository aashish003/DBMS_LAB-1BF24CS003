show databases;

create database IF NOT exists Insurance;

show databases;

use Insurance;

DROP TABLE IF EXISTS PARTICIPATED;
DROP TABLE IF EXISTS OWNS;
DROP TABLE IF EXISTS ACCIDENT;
DROP TABLE IF EXISTS CAR;
DROP TABLE IF EXISTS PERSON;

create table person (driver_id varchar(10),
name varchar(20),
address varchar(30),
primary key(driver_id));

desc person;

create table car(
  reg_num varchar(10),
  model varchar(10),
  year int, primary key(reg_num));
 
desc car;
 
create table accident(
   report_num int,
   accident_date date,
   location varchar(20),
   primary key(report_num));
   
desc accident;

create table owns(
  driver_id varchar(10),
  reg_num varchar(10),
  primary key(driver_id, reg_num),
  foreign key(driver_id) references person(driver_id),
  foreign key(reg_num) references car(reg_num));
 
desc owns;

create table participated(driver_id varchar(10), reg_num varchar(10),
report_num int, damage_amount int,
primary key(driver_id, reg_num, report_num),

foreign key(driver_id) references person(driver_id),
foreign key(reg_num) references car(reg_num),
foreign key(report_num) references accident(report_num));

desc participated;


INSERT INTO person VALUES
('A01', 'Richard', 'Srinivas Nagar'),
('A02', 'Pradeep', 'Rajajinagar'),
('A03', 'Smith', 'Ashoknagar'),
('A04', 'Venu', 'N.R.Colony'),
('A05', 'John', 'Hanumanth Nagar');


select * from person;


INSERT INTO car VALUES
('KA052250', 'Indica', '1990'),
('KA031181', 'Lancer', '1957'),
('KA095477', 'Toyota', '1998'),
('KA053408', 'Honda', '2008'),
('KA041702', 'Audi', '2005');


select * from car;


INSERT INTO accident VALUES
(11, '2003-01-01', 'Mysore Road'),
(12, '2004-02-02', 'Southend Circle'),
(13, '2003-01-21', 'Bulltemple Road'),
(14, '2008-02-17', 'Mysore Road'),
(15, '2005-03-04', 'Kanakpura Road');


select * from accident;


INSERT INTO owns VALUES
('A01', 'KA052250'),
('A02', 'KA053408'),
('A03', 'KA031181'),
('A04', 'KA095477'),
('A05', 'KA041702');


select * from owns;


INSERT INTO participated VALUES
('A01', 'KA052250', 11, 10000),
('A02', 'KA053408', 12, 50000),
('A03', 'KA095477', 13, 25000),
('A04', 'KA031181', 14, 3000),
('A05', 'KA041702', 15, 5000);


select * from participated;

UPDATE PARTICIPATED SET damage_amount=25000
where reg_num='KA053408'
and report_num=12;

commit;
select * from participated;

INSERT INTO ACCIDENT VALUES
(16,'2008-03-15','DOMLUR');
SELECT*FROM ACCIDENT;

SELECT accident_date,location
from accident;

select driver_id from participated
where damage_amount>=25000;

select * from car order by year asc;

select count(report_num) CNT from car c,participated p where c.reg_num=p.reg_num and
model='Lancer';

select count(distinct driver_id) CNT from participated a, accident b where a.report_num=
b.report_num and b.accident_date like '2008%';

select count(distinct driver_id) CNT from participated a, accident b where a.report_num=
b.report_num and b.accident_date like '2008%';


SELECT * FROM PARTICIPATED ORDER BY DAMAGE_AMOUNT DESC;

SELECT AVG(DAMAGE_AMOUNT) FROM PARTICIPATED;

DELETE FROM PARTICIPATED
WHERE DAMAGE_AMOUNT < (
    SELECT avg_damage
    FROM (
        SELECT AVG(DAMAGE_AMOUNT) AS avg_damage
        FROM PARTICIPATED
    ) AS temp
);
select *from participated;


SELECT NAME FROM PERSON A, PARTICIPATED B WHERE A.DRIVER_ID = B.DRIVER_ID
AND DAMAGE_AMOUNT>(SELECT AVG(DAMAGE_AMOUNT) FROM PARTICIPATED);


SELECT MAX(DAMAGE_AMOUNT) FROM PARTICIPATED;

