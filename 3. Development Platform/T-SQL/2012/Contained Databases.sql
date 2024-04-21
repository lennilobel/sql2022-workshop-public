---------------------------------------------------------------
-- Contained Databases (SQL Server 2012)
---------------------------------------------------------------

-- =========== *** Contained Users *** ===========

-- Enable database containment
USE master
GO

EXEC sp_configure 'contained database authentication', 1
RECONFIGURE

-- Delete database if it already exists
DROP DATABASE IF EXISTS MyDB 
GO

-- Create a partially contained database
CREATE DATABASE MyDB CONTAINMENT=PARTIAL
GO

USE MyDB
GO


-- Create a contained user
CREATE USER UserWithPw
 WITH PASSWORD=N'password$1234'

-- Cleanup
USE master
DROP DATABASE MyDB


-- =========== *** Uncontained Entities View *** ===========

-- Create an uncontained database
CREATE DATABASE MyDB
GO

USE MyDB
GO

-- Create a procedure that references a database-level object
CREATE PROCEDURE GetTables AS
BEGIN
  SELECT * FROM sys.tables
END
GO

-- Create a procedure that references an instance-level object
CREATE PROCEDURE GetEndpoints AS
BEGIN
  SELECT * FROM sys.endpoints
END
GO

-- Identify objects that break containment
SELECT
  UncType = ue.feature_type_name,
  UncName = ue.feature_name,
  RefType = o.type_desc,
  RefName = o.name,
  Stmt = ue.statement_type,
  Line = ue.statement_line_number,
  StartPos = ue.statement_offset_begin,
  EndPos = ue.statement_offset_end
 FROM
  sys.dm_db_uncontained_entities AS ue
  INNER JOIN sys.objects AS o ON o.object_id = ue.major_id


-- =========== *** Collations and tempdb *** ===========

-- Create an uncontained database with custom collation
USE master
GO
DROP DATABASE IF EXISTS MyDB 
GO
CREATE DATABASE MyDB COLLATE Chinese_Simplified_Pinyin_100_CI_AS
GO

USE MyDB
GO

-- Create a table in MyDB (uses Chinese_Simplified_Pinyin_100_CI_AS collation)
CREATE TABLE TestTable (TextValue nvarchar(max))

-- Create a temp table in tempdb (uses SQL_Latin1_General_CP1_CI_AS collation)
CREATE TABLE #TempTable (TextValue nvarchar(max))

-- Fails, because MyDB and tempdb uses different collation
SELECT * FROM
 TestTable INNER JOIN #TempTable ON TestTable.TextValue = #TempTable.TextValue

-- Convert to a partially contained database
DROP TABLE #TempTable
USE master

ALTER DATABASE MyDB SET CONTAINMENT=PARTIAL
GO

USE MyDB
GO

-- Create a temp table in MyDB (uses Chinese_Simplified_Pinyin_100_CI_AS collation)
CREATE TABLE #TempTable (TextValue nvarchar(max))

-- Succeeds, because the table in tempdb now uses the same collation as MyDB
SELECT * FROM
 TestTable INNER JOIN #TempTable ON TestTable.TextValue = #TempTable.TextValue

-- Cleanup
DROP TABLE #TempTable
USE master
DROP DATABASE MyDB
GO


-------------------------------------------------------------------------------------------------------------

-- Change the database collation
USE master
ALTER DATABASE MyDB COLLATE Chinese_Simplified_Pinyin_100_CI_AS;
USE MyDB

-- Create a table with differently-collated columns
CREATE TABLE Customer(
 CustomerFirstName nvarchar(max),
 CustomerLastName nvarchar(max) COLLATE Frisian_100_CS_AS)
GO

SELECT name, collation_name
 FROM sys.columns
 WHERE name LIKE 'Customer%Name'
GO

-- Cleanup
DROP TABLE Customer
