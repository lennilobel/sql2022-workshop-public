--------------------------------------------------------------------------------------
-- *** Example #1 ***

-- [ include actual execution plan / run first query... THEN talk ]

USE AdventureWorks2017
GO

CREATE OR ALTER FUNCTION fnFormatCustomerName(@CustomerId int)
RETURNS varchar(max)
AS
BEGIN
	
	DECLARE @PersonId int
	DECLARE @FirstName varchar(max)
	DECLARE @LastName varchar(max)

	SELECT @PersonId = PersonID
	FROM Sales.Customer
	WHERE CustomerID = @CustomerId
	
	SELECT @FirstName = FirstName, @LastName = LastName
	FROM Person.Person
	WHERE BusinessEntityID = @PersonId

	DECLARE @CustomerName varchar(max) = CONCAT(@LastName, ', ', @FirstName)
	RETURN @CustomerName

END
GO

CREATE OR ALTER FUNCTION fnFormatSalesPersonName(@SalesPersonId int)
RETURNS varchar(max)
AS
BEGIN
	
	DECLARE @FirstName varchar(max)
	DECLARE @LastName varchar(max)

	SELECT @FirstName = FirstName, @LastName = LastName
	FROM Person.Person
	WHERE BusinessEntityID = @SalesPersonId

	DECLARE @SalesPersonName varchar(max) = CONCAT(@FirstName, ' ', @LastName)
	RETURN @SalesPersonName

END
GO

CREATE OR ALTER FUNCTION fnGetDiscountedShipBase(@ShipMethodId int)
RETURNS decimal(9, 2)
AS
BEGIN
	
	DECLARE @ShipBase decimal(9, 2)

	SELECT @ShipBase = ShipBase * .9
	FROM Purchasing.ShipMethod
	WHERE ShipMethodID = @ShipMethodId

	RETURN @ShipBase

END
GO

CREATE OR ALTER FUNCTION fnGetDiscountedShipRate(@ShipMethodId int)
RETURNS decimal(9, 2)
AS
BEGIN
	
	DECLARE @ShipRate decimal(9, 2)

	SELECT @ShipRate = ShipRate * .8
	FROM Purchasing.ShipMethod
	WHERE ShipMethodID = @ShipMethodId

	RETURN @ShipRate

END
GO


EXEC master.dbo.SetDbCompatLevel 'AdventureWorks2017', 140		-- SQL Server 2017

-- Takes ~ 15 seconds with excessive memory grant
SELECT
	SalesOrderID,
	OrderDate,
	CustomerName = dbo.fnFormatCustomerName(CustomerID),
	SalesPersonName = dbo.fnFormatSalesPersonName(SalesPersonID),
	ShipBase = dbo.fnGetDiscountedShipBase(ShipMethodID),
	ShipRate = dbo.fnGetDiscountedShipRate(ShipMethodID)
FROM
	Sales.SalesOrderHeader
ORDER BY
	CustomerName, OrderDate DESC


EXEC master.dbo.SetDbCompatLevel 'AdventureWorks2017', 150		-- SQL Server 2019

-- Takes ~ 2 seconds with excessive memory grant; run 2x for memory grant feedback
SELECT
	SalesOrderID,
	OrderDate,
	CustomerName = dbo.fnFormatCustomerName(CustomerID),
	SalesPersonName = dbo.fnFormatSalesPersonName(SalesPersonID),
	ShipBase = dbo.fnGetDiscountedShipBase(ShipMethodID),
	ShipRate = dbo.fnGetDiscountedShipRate(ShipMethodID)
FROM
	Sales.SalesOrderHeader
ORDER BY
	CustomerName, OrderDate DESC


EXEC master.dbo.SetDbCompatLevel 'AdventureWorks2017', 140		-- SQL Server 2017

-- Still, using NO functions, takes 0 seconds even in older SQL Server versions
SELECT
	soh.SalesOrderID,
	soh.OrderDate,
	CustomerName = CONCAT(pc.LastName, ', ', pc.FirstName),
	SalesPersonName = CONCAT(ps.FirstName, ' ', ps.LastName),
	ShipBase = CONVERT(decimal(9, 2), sm.ShipBase * .9),
	ShipRate = CONVERT(decimal(9, 2), sm.ShipRate * .8)
FROM
	Sales.SalesOrderHeader AS soh
	INNER JOIN Sales.Customer AS c ON c.CustomerID = soh.CustomerID
	INNER JOIN Person.Person AS pc ON pc.BusinessEntityID = c.PersonID
	LEFT JOIN Person.Person AS ps ON ps.BusinessEntityID = soh.SalesPersonID
	LEFT JOIN Purchasing.ShipMethod AS sm ON sm.ShipMethodID = soh.ShipMethodID
ORDER BY
	pc.LastName, pc.FirstName, soh.OrderDate DESC



GO

-- Cleanup
DROP FUNCTION IF EXISTS fnFormatCustomerName
DROP FUNCTION IF EXISTS fnFormatSalesPersonName
DROP FUNCTION IF EXISTS fnGetDiscountedShipBase
DROP FUNCTION IF EXISTS fnGetDiscountedShipRate
GO


--------------------------------------------------------------------------------------
-- *** Example #2 ***

USE WideWorldImportersDW
GO

CREATE OR ALTER FUNCTION fnGetCityAverage(@CityKey int)
RETURNS decimal(5, 2)
AS 
BEGIN

	DECLARE @AvgQty decimal(5, 2) = (
		SELECT AVG(CONVERT(decimal(5, 2), Quantity))
		FROM Fact.[Order]
		WHERE [City Key] = @CityKey
	)

	RETURN @AvgQty

END
GO

CREATE OR ALTER FUNCTION fnGetCityRating(@CityKey int)
RETURNS varchar(max) 
AS 
BEGIN

	DECLARE @AvgQty decimal(5, 2) = dbo.fnGetCityAverage(@CityKey)

	DECLARE @Rating varchar(max) =
		IIF(@AvgQty / 40 >= 1,
			'Above Average',
			'Below Average'
		)

	RETURN @Rating

END
GO

CREATE OR ALTER PROCEDURE GetCityAverages
AS
BEGIN

	SELECT
		[City Key],
		City,
		[State Province],
		Average = dbo.fnGetCityAverage([City Key]),
		Rating = dbo.fnGetCityRating([City Key])
	FROM
		Dimension.City
	WHERE
		dbo.fnGetCityAverage([City Key]) IS NOT NULL
	ORDER BY
		City, [State Province]

END

GO

EXEC master.dbo.SetDbCompatLevel 'WideWorldImportersDW', 140		-- SQL Server 2017
EXEC GetCityAverages

EXEC master.dbo.SetDbCompatLevel 'WideWorldImportersDW', 150		-- SQL Server 2019
EXEC GetCityAverages
GO

CREATE OR ALTER PROCEDURE GetCityAverages_DoItYourself
AS
BEGIN

	SELECT
		[City Key],
		City,
		[State Province],
		Average = (	SELECT AVG(CONVERT(decimal(5, 2), Quantity))
					FROM Fact.[Order] AS o
					WHERE o.[City Key] = c.[City Key]),
		Rating = IIF((
					SELECT AVG(CONVERT(decimal(5, 2), Quantity))
					FROM Fact.[Order] AS o
					WHERE o.[City Key] = c.[City Key]) / 40 > = 1,
						'Above Average', 'Below Average')
	FROM
		Dimension.City AS c
	WHERE
		(	SELECT AVG(CONVERT(decimal(5, 2), Quantity))
			FROM Fact.[Order] AS o
			WHERE o.[City Key] = c.[City Key]
		) IS NOT NULL
	ORDER BY
		City, [State Province]

END

EXEC master.dbo.SetDbCompatLevel 'WideWorldImportersDW', 140		-- SQL Server 2017
EXEC GetCityAverages_DoItYourself
GO

-- Cleanup
DROP PROCEDURE IF EXISTS GetCityAverages_DoItYourself
DROP PROCEDURE IF EXISTS GetCityAverages
DROP FUNCTION IF EXISTS fnGetCityAverage
DROP FUNCTION IF EXISTS fnGetCityRating

GO


--------------------------------------------------------------------------------------
-- *** Example #3 ***

-- Relies on Fact.OrderHistory table in WideWorldImportersDW (3,702,592 rows)
--  Execute 'Enlarge WWIDW.sql' to generate it


-- Create a scalar function
CREATE OR ALTER FUNCTION fnGetCustomerCategory(@CustomerKey int)
RETURNS varchar(max) AS
BEGIN
	DECLARE @TotalAmount decimal
	DECLARE @Category varchar(max)

	SELECT @TotalAmount = SUM([Total Including Tax]) 
	FROM Fact.OrderHistory
	WHERE [Customer Key] = @CustomerKey

	IF @TotalAmount <= 3000000
		SET @Category = 'REGULAR'
	ELSE IF @TotalAmount <= 4500000
		SET @Category = 'GOLD'
	ELSE
		SET @Category = 'PLATINUM'

	RETURN @Category
END
GO

-- Create a stored procedure that calls the function
CREATE OR ALTER PROCEDURE GetCustomerCategories
AS
BEGIN
	SELECT
		[Customer Key],
		Customer,
		dbo.fnGetCustomerCategory([Customer Key]) AS Category
	FROM
		Dimension.Customer
	ORDER BY
		[Customer Key]
END
GO

-- Without inlining, takes ~ 1-2 min for 403 rows
EXEC master.dbo.SetDbCompatLevel 'WideWorldImportersDW', 140		-- SQL Server 2017
EXEC GetCustomerCategories
GO

-- With inlining, takes ~ 30 sec for 403 rows
EXEC master.dbo.SetDbCompatLevel 'WideWorldImportersDW', 150		-- SQL Server 2019
EXEC GetCustomerCategories
GO

-- For varying cardinalities, perf could actually get worse with inlining
-- Almost always better off avoiding the scalar UDF altogether

CREATE OR ALTER PROCEDURE GetCustomerCategories_DoItYourself
AS
BEGIN
	WITH MyCte AS (
		SELECT
			[Customer Key],
			Customer,
			Total = (SELECT SUM([Total Including Tax]) FROM Fact.OrderHistory AS oh WHERE oh.[Customer Key] = c.[Customer Key])
		FROM
			Dimension.Customer AS c
	)
	SELECT
		[Customer Key],
		Customer,
		Category = CASE
			WHEN Total <= 3000000
				THEN 'REGULAR'
			WHEN Total <= 4500000
				THEN 'GOLD'
			ELSE
				'PLATINUM'
		END
	FROM
		MyCte AS c
	ORDER BY
		[Customer Key]
END
GO


-- Takes just one second!
EXEC master.dbo.SetDbCompatLevel 'WideWorldImportersDW', 140		-- SQL Server 2017
EXEC master.dbo.SetDbCompatLevel 'WideWorldImportersDW', 150		-- SQL Server 2019
EXEC GetCustomerCategories_DoItYourself
GO

-- Cleanup
DROP PROCEDURE IF EXISTS GetCustomerCategories_DoItYourself 
DROP PROCEDURE IF EXISTS GetCustomerCategories
DROP FUNCTION IF EXISTS fnGetCustomerCategory
