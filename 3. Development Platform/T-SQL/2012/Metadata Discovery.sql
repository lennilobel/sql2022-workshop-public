---------------------------------------------------------------
-- Metadata discovery (SQL Server 2012)
---------------------------------------------------------------

USE AdventureWorks2017
GO

-- SET FMTONLY ON/OFF is deprecated
SET FMTONLY ON
SELECT * FROM HumanResources.Employee;
SET FMTONLY OFF
GO

-- Get the schema of the Employee table
EXEC sys.sp_describe_first_result_set
 @tsql = N'SELECT * FROM HumanResources.Employee'

-- DMV returns same information, but is queryable and you can limit metadata columns
SELECT name, system_type_name 
 FROM sys.dm_exec_describe_first_result_set(
  'SELECT * FROM HumanResources.Employee', NULL, 1)
 WHERE is_nullable = 1

-- Supports parameterized statements
SELECT name, system_type_name, is_hidden
 FROM sys.dm_exec_describe_first_result_set('
  SELECT OrderDate, TotalDue
   FROM Sales.SalesOrderHeader
   WHERE SalesOrderID = @OrderID',
  '@OrderID int', 1)

-- Multiple resultsets are no problem if they all have the same schema
SELECT name, system_type_name
 FROM sys.dm_exec_describe_first_result_set('
    IF @SortOrder = 1
      SELECT OrderDate, TotalDue
       FROM Sales.SalesOrderHeader
       ORDER BY SalesOrderID ASC
    ELSE IF @SortOrder = -1
      SELECT OrderDate, TotalDue
       FROM Sales.SalesOrderHeader
       ORDER BY SalesOrderID DESC',
   '@SortOrder AS tinyint', 0)

-- Stored proc throws exception if multiple resultsets have different columns
EXEC sys.sp_describe_first_result_set
  @tsql = N'
    IF @IncludeCurrencyRate = 1
      SELECT OrderDate, TotalDue, CurrencyRateID
       FROM Sales.SalesOrderHeader
    ELSE
      SELECT OrderDate, TotalDue
       FROM Sales.SalesOrderHeader'

--  The DMV will just return null data if multiple resultsets have different columns
SELECT name, system_type_name, is_hidden
 FROM sys.dm_exec_describe_first_result_set('
    IF @IncludeCurrencyRate = 1
      SELECT OrderDate, TotalDue, CurrencyRateID
       FROM Sales.SalesOrderHeader
    ELSE
      SELECT OrderDate, TotalDue
       FROM Sales.SalesOrderHeader',
   '@IncludeCurrencyRate AS bit', 0)
GO

-- Use sys.dm_exec_describe_first_result_set_for_object to get the schema returned by a stored procedure (or trigger)
CREATE PROCEDURE GetOrderInfo(@OrderID AS int) AS
  SELECT OrderDate, TotalDue
   FROM Sales.SalesOrderHeader
   WHERE SalesOrderID = @OrderID
GO

SELECT name, system_type_name, is_hidden
 FROM sys.dm_exec_describe_first_result_set_for_object(OBJECT_ID('GetOrderInfo'), 1)

DROP PROCEDURE GetOrderInfo

-- Deduce undeclared parameters
EXEC sys.sp_describe_undeclared_parameters
 N'IF @IsFlag = 1 SELECT 1 ELSE SELECT 0'
