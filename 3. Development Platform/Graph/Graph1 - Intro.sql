/* =================== Graph DB =================== */

SET NOCOUNT OFF
GO

USE master
GO

DROP DATABASE IF EXISTS MyDB
GO

CREATE DATABASE MyDB
GO

USE MyDB

/* Simple graph demo */

CREATE TABLE Company (
	CompanyId int NOT NULL,
	CompanyName varchar(100),
	Sector varchar(100),
	CONSTRAINT UC_Company_CompanyName UNIQUE (CompanyName),
) AS NODE

CREATE TABLE Employee (
	EmployeeId int NOT NULL,
	EmployeeName varchar(100),
	Gender char(1),
	CONSTRAINT UC_Employee_EmployeeName UNIQUE (EmployeeName),
) AS NODE

CREATE TABLE City (
	CityId int NOT NULL,
	CityName varchar(100),
	StateName varchar(100),
	CONSTRAINT UC_City_CityName UNIQUE (CityName),
) AS NODE

INSERT INTO Company VALUES
 (1, 'A Datum', 'Pharma'),
 (2, 'Contoso, Ltd', 'Manufacturing'),
 (3, 'Fabrikam Land', 'Pharma'),
 (4, 'Nod Publishers', 'IT')

INSERT INTO Employee VALUES
 (1, 'Henry Forlonge', 'M'),
 (2, 'Lily Code', 'F'),
 (3, 'Taj Shand', 'M'),
 (4, 'Archer Lamble', 'M'),
 (5, 'Piper Koch', 'F'),
 (6, 'Katie Darwin', 'F')

INSERT INTO City VALUES
 (1, 'Bellevue', 'Karlstad'),
 (2, 'Zionsville', 'Karlstad'),
 (3, 'Jonesbough', 'Lancing'),
 (4, 'Abbeville', 'Lancing'),
 (5, 'Brooklyn', 'New York'),
 (6, 'Zortman', 'Wyoming')

SELECT * FROM Company
SELECT * FROM Employee
SELECT * FROM City


CREATE TABLE WorksAt (SinceYear int) AS EDGE

CREATE TABLE LocatedIn AS EDGE


INSERT INTO WorksAt ($from_id, $to_id, SinceYear) VALUES
 ((SELECT $node_id FROM Employee WHERE EmployeeId = 1), (SELECT $node_id FROM Company WHERE CompanyId = 1), 2015),
 ((SELECT $node_id FROM Employee WHERE EmployeeId = 2), (SELECT $node_id FROM Company WHERE CompanyId = 2), 2014),
 ((SELECT $node_id FROM Employee WHERE EmployeeId = 3), (SELECT $node_id FROM Company WHERE CompanyId = 3), 2015),
 ((SELECT $node_id FROM Employee WHERE EmployeeId = 4), (SELECT $node_id FROM Company WHERE CompanyId = 3), 2016),
 ((SELECT $node_id FROM Employee WHERE EmployeeId = 5), (SELECT $node_id FROM Company WHERE CompanyId = 3), 2014),
 ((SELECT $node_id FROM Employee WHERE EmployeeId = 6), (SELECT $node_id FROM Company WHERE CompanyId = 4), 2014)

INSERT INTO LocatedIn ($from_id, $to_id) VALUES
 ((SELECT $node_id FROM Company WHERE CompanyId = 1), (SELECT $node_id FROM City WHERE CityId = 2)),
 ((SELECT $node_id FROM Company WHERE CompanyId = 2), (SELECT $node_id FROM City WHERE CityId = 1)),
 ((SELECT $node_id FROM Company WHERE CompanyId = 3), (SELECT $node_id FROM City WHERE CityId = 3)),
 ((SELECT $node_id FROM Company WHERE CompanyId = 4), (SELECT $node_id FROM City WHERE CityId = 2)),
 ((SELECT $node_id FROM Employee WHERE EmployeeId = 1), (SELECT $node_id FROM City WHERE CityId = 6)),
 ((SELECT $node_id FROM Employee WHERE EmployeeId = 2), (SELECT $node_id FROM City WHERE CityId = 5)),
 ((SELECT $node_id FROM Employee WHERE EmployeeId = 3), (SELECT $node_id FROM City WHERE CityId = 4)),
 ((SELECT $node_id FROM Employee WHERE EmployeeId = 4), (SELECT $node_id FROM City WHERE CityId = 2)),
 ((SELECT $node_id FROM Employee WHERE EmployeeId = 5), (SELECT $node_id FROM City WHERE CityId = 3)),
 ((SELECT $node_id FROM Employee WHERE EmployeeId = 6), (SELECT $node_id FROM City WHERE CityId = 1))

SELECT * FROM WorksAt
SELECT * FROM LocatedIn

DELETE FROM WorksAt
DELETE FROM LocatedIn

GO

CREATE OR ALTER PROCEDURE AddEmployeeWorksInCompanyEdge
	@EmployeeName varchar(max),
	@CompanyName varchar(max),
	@SinceYear int
 AS
BEGIN
	INSERT INTO WorksAt ($from_id, $to_id, SinceYear)
	 VALUES (
		(SELECT $node_id FROM Employee WHERE EmployeeName = @EmployeeName),
		(SELECT $node_id FROM Company WHERE CompanyName = @CompanyName),
		@SinceYear
	)
END
GO

CREATE OR ALTER PROCEDURE AddCompanyLocatedInCityEdge
	@CompanyName varchar(max),
	@CityName varchar(max)
 AS
BEGIN
	INSERT INTO LocatedIn ($from_id, $to_id)
	 VALUES (
		(SELECT $node_id FROM Company WHERE CompanyName = @CompanyName),
		(SELECT $node_id FROM City WHERE CityName = @CityName)
	)
END
GO

CREATE OR ALTER PROCEDURE AddEmployeeLocatedInCityEdge
	@EmployeeName varchar(max),
	@CityName varchar(max)
 AS
BEGIN
	INSERT INTO LocatedIn ($from_id, $to_id)
	 VALUES (
		(SELECT $node_id FROM Employee WHERE EmployeeName = @EmployeeName),
		(SELECT $node_id FROM City WHERE CityName = @CityName)
	)
END
GO

EXEC AddEmployeeWorksInCompanyEdge	'Henry Forlonge',	'A Datum',			2015
EXEC AddEmployeeWorksInCompanyEdge	'Lily Code',		'Contoso, Ltd',		2014
EXEC AddEmployeeWorksInCompanyEdge	'Taj Shand',		'Fabrikam Land',	2015
EXEC AddEmployeeWorksInCompanyEdge	'Archer Lamble',	'Fabrikam Land',	2016
EXEC AddEmployeeWorksInCompanyEdge	'Piper Koch',		'Fabrikam Land',	2014
EXEC AddEmployeeWorksInCompanyEdge	'Katie Darwin',		'Nod Publishers',	2014

EXEC AddCompanyLocatedInCityEdge	'A Datum',			'Zionsville'
EXEC AddCompanyLocatedInCityEdge	'Contoso, Ltd',		'Bellevue'
EXEC AddCompanyLocatedInCityEdge	'Fabrikam Land',	'Jonesbough'
EXEC AddCompanyLocatedInCityEdge	'Nod Publishers',	'Zionsville'

EXEC AddEmployeeLocatedInCityEdge	'Henry Forlonge',	'Zortman'
EXEC AddEmployeeLocatedInCityEdge	'Lily Code',		'Brooklyn'
EXEC AddEmployeeLocatedInCityEdge	'Taj Shand',		'Abbeville'
EXEC AddEmployeeLocatedInCityEdge	'Archer Lamble',	'Zionsville'
EXEC AddEmployeeLocatedInCityEdge	'Piper Koch',		'Jonesbough'
EXEC AddEmployeeLocatedInCityEdge	'Katie Darwin',		'Bellevue'

SELECT * FROM WorksAt
SELECT * FROM LocatedIn


/* Run CQL queries */

SELECT
	Employee.EmployeeName,
	WorksAt.SinceYear,
	Company.CompanyName
FROM
	Employee,
	WorksAt,
	Company
WHERE
	MATCH (Employee-(WorksAt)->Company)

SELECT
	e.EmployeeName,
	w.SinceYear,
	c.CompanyName
FROM
	Employee AS e,
	WorksAt AS w,
	Company AS c
WHERE
	MATCH (e-(w)->c)		-- or  MATCH (c<-(w)-e)
	AND e.EmployeeName = 'Henry Forlonge'

-- What cities do the employees live in?
SELECT
	e.EmployeeName,
	c.CityName
FROM
	Employee AS e,
	LocatedIn AS l,		-- Employee-LocatedIn-City
	City AS c
WHERE
	MATCH (e-(l)->c)
	AND c.CityName = 'Zortman'

SELECT
	e.EmployeeName,
	w.SinceYear,
	co.CompanyName,
	ci.CityName
FROM
	Employee AS e,		-- Employee
	WorksAt AS w,		-- Employee-WorksAt-Company
	Company AS co,		-- Company
	LocatedIn AS l,		-- Company-LocatedIn-City
	City AS ci			-- Company City
WHERE
	MATCH (
		e-(w)->co AND
		co-(l)->ci
	)
	AND w.SinceYear = 2014
	AND co.CompanyName = 'Fabrikam Land'

SELECT
	e.EmployeeName,
	EmployeeCity = ec.CityName,
	w.SinceYear,
	co.CompanyName,
	CompanyCity = cc.CityName
FROM
	Employee AS e,		-- Employee
	WorksAt AS w,		-- Employee-WorksAt-Company
	Company AS co,		-- Company
	LocatedIn AS cl,	-- Company-LocatedIn-City
	City AS cc,			-- Company City
	LocatedIn AS el,	-- Employee-LocatedIn-City
	City AS ec			-- Employee City
WHERE
	MATCH (
		e-(w)->co AND		-- Employee WorksAt Company
		co-(cl)->cc AND		-- Company LocatedIn City
		e-(el)->ec			-- Employee LivesIn City
	)


/* Cleanup */
DROP TABLE IF EXISTS Company
DROP TABLE IF EXISTS Employee
DROP TABLE IF EXISTS City
DROP TABLE IF EXISTS WorksAt
DROP TABLE IF EXISTS LocatedIn
DROP TABLE IF EXISTS LivesIn
