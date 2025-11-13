
DROP DATABASE IF EXISTS SupplyDB;
CREATE DATABASE SupplyDB;
USE SupplyDB;


CREATE TABLE Suppliers (
    SID    INT PRIMARY KEY,
    SNAME  VARCHAR(100) NOT NULL,
    CITY   VARCHAR(100)
);

CREATE TABLE Parts (
    PID   INT PRIMARY KEY,
    PNAME VARCHAR(100) NOT NULL,
    COLOR VARCHAR(50)
);

CREATE TABLE Catalog (
    SID  INT,
    PID  INT,
    COST DECIMAL(10,2),
    PRIMARY KEY (SID, PID),
    FOREIGN KEY (SID) REFERENCES Suppliers(SID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (PID) REFERENCES Parts(PID) ON DELETE CASCADE ON UPDATE CASCADE
);


INSERT INTO Suppliers (SID, SNAME, CITY) VALUES
(10001, 'Acme Widget', 'Bangalore'),
(10002, 'Johns', 'Kolkata'),
(10003, 'Vimal', 'Mumbai'),
(10004, 'Reliance', 'Delhi');
select * from supplier;

INSERT INTO Parts (PID, PNAME, COLOR) VALUES
(20001, 'Book', 'Red'),
(20002, 'Pen', 'Red'),
(20003, 'Pencil', 'Green'),
(20004, 'Mobile', 'Green'),
(20005, 'Charger', 'Black');
select * from parts;

INSERT INTO Catalog (SID, PID, COST) VALUES
(10001,20001,10),
(10001,20002,10),
(10001,20003,30),
(10001,20004,10),
(10001,20005,10),
(10002,20001,10),
(10002,20002,20),
(10003,20003,30),
(10004,20003,40);
select *from catalog;

SELECT DISTINCT p.PNAME
FROM Parts p
JOIN Catalog c ON p.PID = c.PID;

-- 4. Find the snames of suppliers who supply every part.

SELECT s.SNAME
FROM Suppliers s
JOIN Catalog c ON s.SID = c.SID
GROUP BY s.SID, s.SNAME
HAVING COUNT(DISTINCT c.PID) = (SELECT COUNT(*) FROM Parts);

-- 5. Find the snames of suppliers who supply every red part.

SELECT s.SNAME
FROM Suppliers s
JOIN Catalog c ON s.SID = c.SID
JOIN Parts p ON c.PID = p.PID
WHERE p.COLOR = 'Red'
GROUP BY s.SID, s.SNAME
HAVING COUNT(DISTINCT c.PID) = (SELECT COUNT(*) FROM Parts WHERE COLOR = 'Red');

-- 6. Find the pnames of parts supplied by Acme Widget (SID 10001) and by no one else.
SELECT p.PNAME
FROM Parts p
WHERE p.PID IN (
    SELECT c.PID FROM Catalog c WHERE c.SID = 10001
)
AND p.PID NOT IN (
    SELECT c2.PID FROM Catalog c2 WHERE c2.SID <> 10001
);


-- 7. Find the sids of suppliers who charge more for some part than the average cost of that part (averaged over all suppliers who supply that part).

SELECT DISTINCT c.SID
FROM Catalog c
JOIN (
    SELECT PID, AVG(COST) AS avg_cost
    FROM Catalog
    GROUP BY PID
) avgc ON c.PID = avgc.PID
WHERE c.COST > avgc.avg_cost;


-- 8. For each part, find the sname of the supplier who charges the most for that part.

SELECT p.PID, p.PNAME, s.SNAME, c.COST
FROM Parts p
JOIN Catalog c ON p.PID = c.PID
JOIN Suppliers s ON c.SID = s.SID
WHERE c.COST = (
    SELECT MAX(COST) FROM Catalog c2 WHERE c2.PID = p.PID
)
ORDER BY p.PID;
