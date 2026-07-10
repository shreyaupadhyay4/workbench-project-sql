DROP DATABASE IF EXISTS company_db;
CREATE DATABASE company_db;
USE company_db;

-- =========================
-- Employees Table
-- =========================
CREATE TABLE employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DepartmentID INT
);

-- =========================
-- Departments Table
-- =========================
CREATE TABLE departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

-- =========================
-- Salaries Table
-- =========================
CREATE TABLE salaries (
    EmployeeID INT PRIMARY KEY,
    Salary INT
);

-- =========================
-- Departments Data
-- =========================
INSERT INTO departments VALUES
(1,'Mentor'),
(2,'Designer'),
(3,'Editor'),
(4,'Onboarding'),
(5,'Project Manager'),
(6,'Marketing'),
(7,'Sales'),
(8,'HR');

-- =========================
-- Employees Data
-- =========================
INSERT INTO employees VALUES
(1,'Harshvardhan','Singh',1),
(2,'Ankur','Gupta',2),
(3,'Shivam','Kumar',3),
(4,'Sakshi','Awasthi',4),
(5,'Nitin','Kaur',5),
(6,'Vinit','Singhal',1),
(7,'Adarsh','Sharma',4),
(8,'Prakash','Sakari',6),
(9,'Puneet','Sharma',7),
(10,'Riya','Mehta',8),
(11,'Rahul','Bansal',NULL),     -- no department
(12,'Sneha','Kapoor',3),
(13,'Aman','Verma',2),
(14,'Karan','Malhotra',9);      -- invalid department

-- =========================
-- Salaries Data
-- =========================
INSERT INTO salaries VALUES
(1,50000),
(2,54000),
(3,30000),
(4,60000),
(5,58000),
(6,62000),
(7,56000),
(8,45000),
(9,52000),
(10,48000),
(12,61000);

-- employees 11,13,14 have no salary

-- =========================
-- Table Preview
-- =========================
SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM salaries;





-- Q1. Write a SQL query to display EmployeeID, FirstName, LastName,and DepartmentName for employees who belong to a department.


SELECT e.EmployeeID,e.FirstName,e.LastName,d.DepartmentName
FROM employees e
INNER JOIN departments d
ON e.DepartmentID=d.DepartmentID;



-- Q2. Write a SQL query to display EmployeeID, FirstName, and Salary for employees who have a salary record.
SELECT e.EmployeeID,e.FirstName,s.Salary
FROM employees e
INNER JOIN salaries s
ON e.EmployeeID=s.EmployeeID;



-- Q3. Write a SQL query to display EmployeeID, FirstName, and DepartmentName for all employees, even if they do not belong to any department.
SELECT e.EmployeeID,e.FirstName,d.DepartmentName
FROM employees e
LEFT JOIN departments d
ON e.DepartmentID=d.DepartmentID;


-- Q4. Write a SQL query to display all departments along with employees working in them. Departments without employees should also appear.
SELECT d.DepartmentID,d.DepartmentName,e.EmployeeID,e.FirstName
FROM departments d 
LEFT JOIN employees e
ON d.DepartmentID=e.DepartmentID;



-- Q5. Write a SQL query to display EmployeeID, FirstName,DepartmentName, and Salary for employees who have bothdepartment and salary information.

SELECT e.EmployeeID ,e.FirstName, d.DepartmentName,s.Salary
FROM employees e 
INNER JOIN departments d
ON e.DepartmentID=d.DepartmentID
INNER JOIN salaries s
ON e.EmployeeID=s.EmployeeID;


-- Q6. Write a SQL query to display all employees and their salary. Employees without salary should also appear.
SELECT e.EmployeeID,e.FirstName,s.Salary
FROM employees e
LEFT JOIN salaries s
ON e.EmployeeID=s.EmployeeID;


-- Q7. Write a SQL query to display employees who do not have a salary record.
CREATE VIEW V1 AS (SELECT e.EmployeeID,e.FirstName
FROM employees e
LEFT JOIN salaries s
ON e.EmployeeID=s.EmployeeID
where Salary IS NULL);


-- Q8. Write a SQL query to display all departments and employees working in them. Departments with no employees should also be displayed.
SELECT d.DepartmentName,e.EmployeeID,e.FirstName
FROM departments d
LEFT JOIN employees e
ON d.DepartmentID= e.DepartmentID;



-- Q9. Write a SQL query using UNION to combine the FirstName of employees and the DepartmentName from departments.
SELECT FirstName AS name
FROM employees 

UNION

SELECT DepartmentName FROM departments ;




-- Q10. Write a SQL query using UNION ALL to combine the FirstName of employees and DepartmentName.
SELECT FirstName AS name FROM employees
UNION ALL
SELECT DepartmentName FROM departments;




-- Q11. Write a SQL query to display EmployeeID from employees and EmployeeID from salaries using UNION.
SELECT EmployeeID FROM employees
UNION
SELECT EmployeeID FROM salaries;



-- Q12. Write a SQL query to find employees who appear in both employees and salaries tables (common EmployeeID).
SELECT e.FirstName FROM employees e 
INNER JOIN salaries s 
ON e.EmployeeID=s.EmployeeID;



-- Q13. Write a SQL query to generate all possible combinations of employees and departments.
SELECT e.EmployeeID,e.FirstName,d.DepartmentName
FROM employees e 
CROSS JOIN departments d ;



-- Q14. Write a SQL query using SELF JOIN to display pairs of employees who work in the same department.
SELECT e1.EmployeeID, e1.FirstName ,e2.EmployeeID,e2.FirstName,e1.DepartmentID
FROM employees e1
INNER JOIN employees e2
ON e1.DepartmentID=e2.DepartmentID
AND e1.EmployeeID>e2.EmployeeID; -- we used this bcz we wanted unique value and it create this