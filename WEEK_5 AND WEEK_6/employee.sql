CREATE DATABASE IF NOT EXISTS EmployeeData;
USE EmployeeData;


DROP TABLE IF EXISTS INCENTIVE;
DROP TABLE IF EXISTS ASSIGNED_TO;
DROP TABLE IF EXISTS PROJECT;
DROP TABLE IF EXISTS EMPLOYEE;
DROP TABLE IF EXISTS DEPT;
CREATE TABLE Dept (
    DeptNo INT PRIMARY KEY,
    DNAME VARCHAR(50),
    DLOC VARCHAR(50)
);


CREATE TABLE Employee (
    EmpNo INT PRIMARY KEY,
    EName VARCHAR(50),
    Mgr_No INT,
    HireDate DATE,
    Salary FLOAT,
    DeptNo INT,
    FOREIGN KEY (DeptNo) REFERENCES Dept(DeptNo) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE Project (
    Pno INT PRIMARY KEY,
    Pname VARCHAR(50),
    Ploc VARCHAR(50)
);


CREATE TABLE Assigned_To (
    EmpNo INT ,
    Pno INT ,
    Job_Role VARCHAR(50),
    PRIMARY KEY(EmpNo,Pno),
    FOREIGN KEY (EmpNo) REFERENCES Employee(EmpNo) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Pno) REFERENCES Project(Pno) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE Incentive (
    EmpNo INT ,
    Incentive_Date DATE,
    primary key (EmpNo,Incentive_Date),
    Incentive_Amount FLOAT,
    FOREIGN KEY (EmpNo) REFERENCES Employee(EmpNo)
);


INSERT INTO Dept VALUES
(10, 'HR', 'Bengaluru'),
(20, 'Finance', 'Hyderabad'),
(30, 'IT', 'Mysuru'),
(40, 'Sales', 'Chennai'),
(50, 'R&D', 'Bengaluru');
SELECT *FROM DEPT;


INSERT INTO Employee VALUES
(101, 'Ravi', 201, '2020-01-15', 45000, 10),
(102, 'Priya', 202, '2019-03-22', 50000, 20),
(103, 'Anil', 203, '2018-07-18', 55000, 30),
(104, 'Kiran', 204, '2021-05-11', 47000, 40),
(105, 'Deepa', 205, '2022-09-01', 48000, 50),
(106, 'Rahul', 201, '2020-02-10', 52000, 10);
SELECT *FROM EMPLOYEE;


INSERT INTO Project VALUES
(1, 'Alpha', 'Bengaluru'),
(2, 'Beta', 'Hyderabad'),
(3, 'Gamma', 'Mysuru'),
(4, 'Delta', 'Chennai'),
(5, 'Nima', 'Pune');
SELECT *FROM PROJECT;


INSERT INTO Assigned_To VALUES
(101, 1, 'Developer'),
(102, 2, 'Analyst'),
(103, 3, 'Tester'),
(104, 4, 'Sales Executive'),
(105, 5, 'Researcher'),
(106, 1, 'Developer');
SELECT *FROM ASSIGNED_TO;


INSERT INTO Incentive VALUES
(101,'2019-01-10',5000),
(102,'2019-01-19',6000),
(105,'2023-08-25',4000);
SELECT *FROM INCENTIVE;


SELECT EmpNo FROM Employee
WHERE DeptNo IN (
SELECT DeptNo
FROM Dept
WHERE DLOC IN ('Bengaluru', 'Hyderabad', 'Mysuru')
);


SELECT EmpNo
FROM Employee
WHERE EmpNo NOT IN (SELECT EmpNo FROM Incentive);


SELECT E.ENAME, E.EMPNO, D.DNAME, A.JOB_ROLE, D.DLOC AS Department_Location, P.PLOC AS Project_Location FROM EMPLOYEE E
JOIN DEPT D ON E.DEPTNO = D.DEPTNO
JOIN ASSIGNED_TO A ON E.EMPNO = A.EMPNO
JOIN PROJECT P ON A.PNO = P.PNO
WHERE D.DLOC = P.PLOC;


INSERT INTO EMPLOYEE VALUES
(201, 'Manoj', NULL, '2015-02-10', 70000, 10),   -- Manager HR
(202, 'Sneha', NULL, '2016-04-12', 68000, 20),   -- Manager Finance
(203, 'Vikram', NULL, '2014-09-25', 72000, 30),  -- Manager IT
(204, 'Anita', NULL, '2017-01-30', 69000, 40),   -- Manager Sales
(205, 'Karthik', NULL, '2013-11-18', 75000, 50); -- Manager R&D

SELECT *FROM EMPLOYEE;

SELECT E.EName AS Manager_Name, COUNT(*) AS Employee_Count
FROM Employee M
JOIN Employee E ON M.Mgr_No = E.EmpNo
GROUP BY M.Mgr_No
HAVING COUNT(*) = (
    SELECT MAX(EmpCount)
    FROM (
        SELECT COUNT(*) AS EmpCount
        FROM Employee
        WHERE Mgr_No IS NOT NULL
        GROUP BY Mgr_No
    ) AS T
);

SELECT M.EName AS Manager_Name
FROM Employee M
WHERE M.EmpNo IN (
    SELECT Mgr_No FROM Employee
)
AND M.Salary > (
    SELECT AVG(E.Salary)
    FROM Employee E
    WHERE E.Mgr_No = M.EmpNo
);

SELECT DeptNo, EName, Salary
FROM (
    SELECT E.*,
           ROW_NUMBER() OVER (PARTITION BY DeptNo ORDER BY Salary DESC) AS RN
    FROM Employee E
    WHERE EmpNo IN (SELECT Mgr_No FROM Employee)
) AS T
WHERE RN = 2;

SELECT EmpNo, Incentive_Amount
FROM Incentive
WHERE YEAR(Incentive_Date) = 2019 AND MONTH(Incentive_Date) = 1
ORDER BY Incentive_Amount DESC
LIMIT 1 OFFSET 1;

SELECT E.EName AS Employee_Name, M.EName AS Manager_Name, E.DeptNo
FROM Employee E
JOIN Employee M ON E.Mgr_No = M.EmpNo
WHERE E.DeptNo = M.DeptNo;
