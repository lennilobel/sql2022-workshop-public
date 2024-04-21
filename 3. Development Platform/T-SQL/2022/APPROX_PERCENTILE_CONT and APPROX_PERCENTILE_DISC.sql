/* =================== APPROX_PERCENTILE_CONT and APPROX_PERCENTILE_DISC =================== */

-- https://learn.microsoft.com/en-us/sql/t-sql/functions/approx-percentile-disc-transact-sql?view=sql-server-ver16

CREATE DATABASE MyDB
GO

USE MyDB
GO

CREATE TABLE Employee (
	EmployeeId int IDENTITY PRIMARY KEY,
	DepartmentId int,
	Salary int);
GO

INSERT INTO Employee VALUES
	(1, 31), (1, 33), (1, 18),				-- Dept 1:	31, 33, 18
	(2, 25), (2, 35), (2, 10), (2, 10),		-- Dept 2:	25, 35, 10, 10
	(3, 1), (3, NULL),						-- Dept 3:	1, NULL
	(4, NULL), (4, NULL)					-- Dept 4:	

GO

SELECT
	DepartmentId,
	APPROX_PERCENTILE_CONT(0.10) WITHIN GROUP(ORDER BY Salary) AS APC10,
	APPROX_PERCENTILE_CONT(0.90) WITHIN GROUP(ORDER BY Salary) AS APC90,
	APPROX_PERCENTILE_DISC(0.10) WITHIN GROUP(ORDER BY Salary) AS APD10,
	APPROX_PERCENTILE_DISC(0.90) WITHIN GROUP(ORDER BY Salary) AS APD90
FROM
	Employee
GROUP BY
	DepartmentId

-- Cleanup
DROP TABLE IF EXISTS Employee
GO
