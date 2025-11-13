DROP database bank_010;
create database IF not exists BANK_010;
USE BANK_010;

DROP TABLE IF EXISTS BORROWER;
DROP TABLE IF EXISTS LOAN;
DROP TABLE IF EXISTS DEPOSITER;
DROP TABLE IF EXISTS BANKCUSTOMER;
DROP TABLE IF EXISTS BANKACCOUNT;
DROP TABLE IF EXISTS BRANCH;

CREATE TABLE branch (
branch_name VARCHAR(30),
branch_city VARCHAR(25),
assets INT,
PRIMARY KEY (branch_name)
);

CREATE TABLE bankaccount (
accno INT,
branch_name VARCHAR(30),
balance INT,
PRIMARY KEY (accno),
FOREIGN KEY (branch_name)
REFERENCES branch (branch_name)
);


CREATE TABLE bankcustomer (
customername VARCHAR(20),
customer_street VARCHAR(30),
customer_city VARCHAR(35),
PRIMARY KEY (customername)
);


CREATE TABLE depositer (
customername VARCHAR(20),
accno INT,
PRIMARY KEY (customername , accno),
FOREIGN KEY (accno)
REFERENCES bankaccount (accno),
FOREIGN KEY (customername)
REFERENCES bankcustomer (customername)
);


CREATE TABLE loan (
loan_number INT,
branch_name VARCHAR(30),
amount INT,
PRIMARY KEY (loan_number),
FOREIGN KEY (branch_name)
REFERENCES branch (branch_name));


CREATE TABLE borrower (
loan_number INT,
customername VARCHAR(20),
PRIMARY KEY (loan_number),
FOREIGN KEY (loan_number)
REFERENCES loan (loan_number),
FOREIGN KEY (customername)
REFERENCES bankcustomer (customername)
);


insert into branch values("SBI_Chamrajpet","Bangalore",50000);
insert into branch values("SBI_ResidencyRoad","Bangalore",10000);
insert into branch values("SBI_ShivajiRoad","Bombay",20000);
insert into branch values("SBI_Parliamentroad","Delhi",10000);
insert into branch values("SBI_Jantarmantar","Delhi",20000);
select * from branch;


insert into bankaccount values(1,"SBI_Chamrajpet",2000);
insert into bankaccount values(2,"SBI_ResidencyRoad",5000);
insert into bankaccount values(3,"SBI_ShivajiRoad",6000);
insert into bankaccount values(4,"SBI_Parliamentroad",9000);
insert into bankaccount values(5,"SBI_Jantarmantar",8000);
insert into bankaccount values(6,"SBI_ShivajiRoad",4000);
insert into bankaccount values(7,"SBI_ShivajiRoad",6800);
insert into bankaccount values(8,"SBI_ResidencyRoad",4000);
insert into bankaccount values(9,"SBI_Parliamentroad",3000);
insert into bankaccount values(10,"SBI_ResidencyRoad",5000);
insert into bankaccount values(11,"SBI_Jantarmantar",2000);
select * from bankaccount;



insert into bankcustomer values("Avinash","BUll_temple_Road","Bangalore");
insert into bankcustomer values("Dinesh","Bannergatta_Road","Bangalore");
insert into bankcustomer values("Mohan","NationaCollege_Road","Bangalore");
insert into bankcustomer values("Nikil","Akbar_Road","Delhi");
insert into bankcustomer values("Ravi","Prithviraj_Road","Delhi");
select * from bankcustomer;



insert into depositer values("Avinash",1);
insert into depositer values("Dinesh",2);
insert into depositer values("Nikil",4);
insert into depositer values("Ravi",5);
insert into depositer values("Avinash",8);
insert into depositer values("Nikil",9);
insert into depositer values("Dinesh",10);
insert into depositer values("Nikil",11);
select * from depositer;



insert into loan values(1,"SBI_Chamrajpet",1000);
insert into loan values(2,"SBI_ResidencyRoad",2000);
insert into loan values(3,"SBI_ShivajiRoad",3000);
insert into loan values(4,"SBI_Parliamentroad",4000);
insert into loan values(5,"SBI_Jantarmantar",5000);
select * from loan;



insert into borrower values(1,"Mohan");
insert into borrower values(2,"Avinash");
insert into borrower values(3,"Dinesh");
insert into borrower values(4,"Mohan");
insert into borrower values(5,"Nikil");
select * from borrower;



select branch_name,(assets/100000) as assets_in_lakhs from branch;


SELECT d.customername FROM depositer d,bankaccount b
WHERE b.branch_name = 'SBI_ResidencyRoad'
AND d.accno = b.accno
GROUP BY d.customername
HAVING COUNT(d.accno) >= 2;


DROP VIEW IF EXISTS sum_of_loan;

create view sum_of_loan
as select branch_name,sum(amount) from loan
group by branch_name;

select * from sum_of_loan;

SELECT d.customername
FROM depositer d
JOIN bankaccount b ON d.accno = b.accno
JOIN branch br ON b.branch_name = br.branch_name
WHERE br.branch_city = 'Delhi'
GROUP BY d.customername
HAVING COUNT(DISTINCT b.branch_name) = (
    SELECT COUNT(branch_name)
    FROM branch
    WHERE branch_city = 'Delhi'
);

SELECT DISTINCT bo.customername
FROM borrower bo
WHERE bo.customername NOT IN (
    SELECT d.customername FROM depositer d
);

SELECT DISTINCT d.customername
FROM depositer d
JOIN bankaccount ba ON d.accno = ba.accno
JOIN branch b1 ON ba.branch_name = b1.branch_name
WHERE b1.branch_city = 'Bangalore'
AND d.customername IN (
    SELECT bo.customername
    FROM borrower bo
    JOIN loan l ON bo.loan_number = l.loan_number
    JOIN branch b2 ON l.branch_name = b2.branch_name
    WHERE b2.branch_city = 'Bangalore'
);

SELECT branch_name
FROM branch
WHERE assets > ALL (
    SELECT assets
    FROM branch
    WHERE branch_city = 'Bangalore'
);

DELETE FROM bankaccount
WHERE branch_name IN (
    SELECT branch_name
    FROM branch
    WHERE branch_city = 'Bombay'
);
SELECT *FROM BANKACCOUNT;

UPDATE bankaccount
SET balance = balance * 1.05;
SELECT *FROM BANKACCOUNT;


