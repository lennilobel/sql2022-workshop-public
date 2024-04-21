/* Retention policy (2017+) */

USE MyDB
GO

-- (begin populate)
CREATE TABLE Employee
(
	EmployeeId		int PRIMARY KEY,
	FirstName		varchar(20) NOT NULL,
	LastName		varchar(20) NOT NULL,
	Salary			int,
	ValidFrom		datetime2 GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo			datetime2 GENERATED ALWAYS AS ROW END   NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeeHistory))
GO

INSERT INTO Employee (EmployeeId, FirstName, LastName, Salary) VALUES
 (1, 'Ken',		'Sanchez',		25000),
 (3, 'Roberto',	'Tamburello',	25000),
 (4, 'Rob',		'Walters',		25000),
 (5, 'Gail',	'Erickson',		25000)
GO

SELECT * FROM Employee
SELECT * FROM EmployeeHistory

GO
ALTER TABLE Employee SET (SYSTEM_VERSIONING = OFF)
GO

-- Simulate one year-old history row of each employee with a prior Salary value of 20000
INSERT INTO EmployeeHistory (EmployeeId, FirstName, LastName, Salary, ValidFrom, ValidTo)
 SELECT EmployeeId, FirstName, LastName,
	20000,							-- Previous salary
	DATEADD(YEAR, -1, ValidFrom),	-- ValidFrom = current ValidFrom - YEAR
	ValidFrom						-- ValidTo = current ValidFrom
 FROM Employee

-- Simulate two year-old history row of each employee with a prior Salary value of 15000
INSERT INTO EmployeeHistory (EmployeeId, FirstName, LastName, Salary, ValidFrom, ValidTo)
 SELECT EmployeeId, FirstName, LastName,
	15000,							-- Previous salary
	DATEADD(YEAR, -1, ValidFrom),	-- ValidFrom = previous ValidFrom - YEAR
	ValidFrom						-- ValidTo = previous ValidFrom
 FROM EmployeeHistory

-- Simulate a history row that was created two years ago and deleted a year ago
INSERT INTO EmployeeHistory (EmployeeId, FirstName, LastName, Salary, ValidFrom, ValidTo)
 VALUES(2, 'Terri', 'Duffy',
	24500,									-- Previous salary
	DATEADD(YEAR, -2, SYSUTCDATETIME()),	-- ValidFrom = 2 years ago
	DATEADD(YEAR, -1, SYSUTCDATETIME()))	-- ValidTo = 1 year ago

ALTER TABLE Employee SET (SYSTEM_VERSIONING = ON (
	HISTORY_TABLE = dbo.EmployeeHistory,
	DATA_CONSISTENCY_CHECK = ON))
GO

-- Add another employee to the base table with no history
INSERT INTO Employee(EmployeeId, FirstName, LastName, Salary)
 VALUES(6, 'Jossef', 'Goldberg', 22750)

-- Perform one more update on row #5
UPDATE Employee
SET FirstName = 'Gabriel', Salary = 26250
WHERE EmployeeId = 5

SELECT *, [Table] = 'BASE' FROM Employee UNION ALL
SELECT *, [Table] = 'HISTORY' FROM EmployeeHistory
ORDER BY EmployeeId, ValidFrom

-- (end populate)

-- Database flag is ON by default, but users can change it with ALTER DATABASE statement.
-- It is also automatically set to OFF after point in time restore operation.
SELECT is_temporal_history_retention_enabled, name FROM sys.databases
GO

-- In case its OFF
ALTER DATABASE MyDB SET TEMPORAL_HISTORY_RETENTION ON
GO

ALTER TABLE Employee SET (SYSTEM_VERSIONING = OFF)

ALTER TABLE Employee SET (SYSTEM_VERSIONING = ON (
	HISTORY_TABLE = dbo.EmployeeHistory,
	DATA_CONSISTENCY_CHECK = ON,
	HISTORY_RETENTION_PERIOD = 6 MONTHS))

SELECT
	TableName = CONCAT(SCHEMA_NAME(schema_id), '.', name),
	TemporalType = temporal_type_desc,
	RetentionPeriod = history_retention_period,
	RetentionPeriodUnit = history_retention_period_unit_desc
FROM
	sys.tables


SELECT * FROM Employee
SELECT * FROM EmployeeHistory ORDER BY ValidTo

ALTER TABLE Employee SET (SYSTEM_VERSIONING = OFF)
DROP TABLE Employee
DROP TABLE EmployeeHistory
