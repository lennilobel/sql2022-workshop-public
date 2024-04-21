/* =================== Table-Valued Parameters =================== */


/* Order Entry */

CREATE DATABASE MyDB
GO

USE MyDB
GO

CREATE TABLE [Order](
 OrderId int NOT NULL,
 CustomerId int NOT NULL,
 OrderedAt date NOT NULL,
 CreatedAt datetime2(0) NOT NULL,
  CONSTRAINT PK_Order PRIMARY KEY CLUSTERED (OrderId ASC))

GO

CREATE TABLE [OrderDetail](
 OrderId int NOT NULL,
 LineNumber int NOT NULL,
 ProductId int NOT NULL,
 Quantity int NOT NULL,
 Price money NOT NULL,
 CreatedAt datetime2(0) NOT NULL,
  CONSTRAINT PK_OrderDetail PRIMARY KEY CLUSTERED (OrderId ASC, LineNumber ASC))

GO

CREATE TYPE OrderUdt AS TABLE(
 OrderId int,
 CustomerId int,
 OrderedAt date)

CREATE TYPE OrderDetailUdt AS TABLE(
 OrderId int,
 LineNumber int,
 ProductId int,
 Quantity int,
 Price money)

GO 

-- Pass TVP from remote client to to stored proc
CREATE PROCEDURE uspInsertNewOrder(
 @OrderHeader AS OrderUdt READONLY,
 @OrderDetails AS OrderDetailUdt READONLY)
AS 
BEGIN

    -- Pass TVP from one stored proc to another
    EXEC uspInspectDetails @OrderDetails

    BEGIN TRANSACTION

    -- Insert order header row from TVP
    INSERT INTO [Order]
     SELECT *, SYSDATETIME() FROM @OrderHeader

    -- Bulk insert order detail rows from TVP
    INSERT INTO [OrderDetail]
     SELECT *, SYSDATETIME() FROM @OrderDetails

    COMMIT TRANSACTION

END
GO

CREATE PROCEDURE uspInspectDetails(
 @OrderDetails AS OrderDetailUdt READONLY)
AS
BEGIN

    SELECT
     'Inspected' AS Inspected,
     dbo.udfGetDetailCount(@OrderDetails) AS DetailCount, -- Pass TVP from stored proc to UDF
     *
    FROM
     @OrderDetails

END
GO

CREATE FUNCTION udfGetDetailCount(
 @OrderDetails AS OrderDetailUdt READONLY)
 RETURNS int
AS
BEGIN
    DECLARE @result AS int
    SELECT @result = COUNT(*) FROM @OrderDetails
    RETURN @result
END
GO

-- Pilot
DECLARE @OrderHeader AS OrderUdt
DECLARE @OrderDetails AS OrderDetailUdt

INSERT INTO @OrderHeader VALUES(1, 1, '2/9/2008')
INSERT INTO @OrderDetails VALUES(1, 1, 329, 1, 24.95)
INSERT INTO @OrderDetails VALUES(1, 2, 247, 2, 15.95)
INSERT INTO @OrderDetails VALUES(1, 3, 193, 4, 9.50)

EXECUTE uspInsertNewOrder @OrderHeader, @OrderDetails

SELECT * FROM [Order]
SELECT * FROM [OrderDetail]

-- Cleanup
DROP FUNCTION udfGetDetailCount
DROP PROCEDURE uspInspectDetails
DROP PROCEDURE uspInsertNewOrder	
DROP TYPE OrderUdt
DROP TYPE OrderDetailUdt
DROP TABLE [Order]
DROP TABLE [OrderDetail]


/* Order Entry - for Business Collection demo */

USE MyDB
GO

CREATE TABLE [Order](
 OrderId int NOT NULL,
 CustomerId int NOT NULL,
 OrderedAt date NOT NULL,
 CreatedAt datetime2(0) NOT NULL,
  CONSTRAINT PK_Order PRIMARY KEY CLUSTERED (OrderId ASC))

GO

CREATE TABLE [OrderDetail](
 OrderId int NOT NULL,
 LineNumber int NOT NULL,
 ProductId int NOT NULL,
 Quantity int NOT NULL,
 Price money NOT NULL,
 CreatedAt datetime2(0) NOT NULL,
  CONSTRAINT PK_OrderDetail PRIMARY KEY CLUSTERED (OrderId ASC, LineNumber ASC))

GO

CREATE TYPE OrderUdt AS TABLE(
 OrderId int,
 CustomerId int,
 OrderedAt date)

CREATE TYPE OrderDetailUdt AS TABLE(
 OrderId int,
 LineNumber int,
 ProductId int,
 Quantity int,
 Price money)

GO 

-- Pass TVP from remote client to to stored proc
CREATE PROCEDURE uspInsertOrders(
 @OrderHeaders AS OrderUdt READONLY,
 @OrderDetails AS OrderDetailUdt READONLY)
AS 
BEGIN

    BEGIN TRANSACTION

    -- Insert order header rows from TVP
    INSERT INTO [Order]
     SELECT *, SYSDATETIME() FROM @OrderHeaders

    -- Bulk insert order detail rows from TVP
    INSERT INTO [OrderDetail]
     SELECT *, SYSDATETIME() FROM @OrderDetails

    COMMIT TRANSACTION

END
GO

-- Bulk load using C# collection with custom iterator

SELECT * FROM [Order]
SELECT * FROM [OrderDetail]

-- Cleanup
DROP PROCEDURE uspInsertOrders
DROP TYPE OrderUdt
DROP TYPE OrderDetailUdt
DROP TABLE [OrderDetail]
DROP TABLE [Order]
GO


/* Bulk Insert */

USE AdventureWorks2019
GO

CREATE TYPE LocationUdt AS TABLE 
(
  LocationName varchar(50),
  CostRate smallmoney
)
GO

CREATE PROCEDURE uspInsertProductionLocation
 (@TVP LocationUdt READONLY)

 AS

  INSERT INTO Production.Location
    (Name, CostRate, Availability, ModifiedDate)
   SELECT LocationName, CostRate, 0, GETDATE()
    FROM @TVP

GO

-- Pilot
SELECT * FROM Production.Location

DECLARE @LocationTvp AS LocationUdt

INSERT INTO @LocationTvp VALUES('UK', 122.4)
INSERT INTO @LocationTvp VALUES('Paris', 359.73)

EXEC uspInsertProductionLocation @LocationTvp
GO

SELECT * FROM Production.Location

-- Bulk Select + Insert
DECLARE @LocationTVP AS LocationUdt

INSERT INTO @LocationTVP
 SELECT Name, 0.00 FROM Person.StateProvince

EXEC uspInsertProductionLocation @LocationTVP
GO

SELECT * FROM Production.Location

-- Cleanup
DELETE FROM Production.Location WHERE LocationID > 60
DROP PROCEDURE uspInsertProductionLocation
DROP TYPE LocationUdt


/* Bulk Update */

USE MyDB
GO

CREATE TABLE Category
 (Id int PRIMARY KEY,
  Name nvarchar(max),
  CreatedAt datetime2(0) DEFAULT SYSDATETIME())

INSERT INTO Category(Id, Name) VALUES
 (1, 'Housewares'), (2, 'Maternity'), (3, 'Mens Apparel'),
 (4, 'Womens Apparel'), (5, 'Bath'), (6, 'Automotive')

SELECT * FROM Category

CREATE TYPE EditedCategoriesUdt AS TABLE
 (Id int PRIMARY KEY,
  Name nvarchar(max))
GO

CREATE PROCEDURE uspUpdateCategories(@EditedCategoriesTVP AS EditedCategoriesUdt READONLY)
AS
 BEGIN

	UPDATE Category
	 SET Category.Name = ec.Name
	 FROM Category INNER JOIN @EditedCategoriesTVP AS ec ON Category.Id = ec.Id

 END

DECLARE @Edits AS EditedCategoriesUdt
INSERT INTO @Edits VALUES(1, 'Gifts & Housewares')
INSERT INTO @Edits VALUES(5, 'Bath & Kitchen')

EXECUTE uspUpdateCategories @Edits

SELECT * FROM Category

-- Cleanup
DROP PROCEDURE uspUpdateCategories
DROP TYPE EditedCategoriesUdt
DROP TABLE Category
GO
