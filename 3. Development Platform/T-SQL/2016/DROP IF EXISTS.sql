/* =================== Drop If Exists =================== */

CREATE DATABASE MyDB
GO

USE MyDB
GO

-- Create a table with a trigger

CREATE TABLE dbo.Product (Col1 int)
GO

CREATE TRIGGER dbo.trProductInsert ON dbo.Product
 AFTER INSERT 
 AS
	PRINT 'Do something everytime a row is inserted into the Product table'
GO

SELECT * FROM sys.tables
SELECT * FROM sys.triggers

-- Drop the table and trigger (old school)

IF OBJECT_ID('dbo.Product', 'U') IS NOT NULL
 DROP TABLE dbo.Product

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'trProductInsert')
 DROP TRIGGER dbo.trProductInsert

SELECT * FROM sys.tables
SELECT * FROM sys.triggers

-- Drop the table and trigger (DIE)

DROP TABLE IF EXISTS dbo.Product
DROP TRIGGER IF EXISTS dbo.trProductInsert

SELECT * FROM sys.tables
SELECT * FROM sys.triggers

-- Other supported DIE objects

GO

DROP AGGREGATE IF EXISTS dbo.SomeAggregate
DROP ASSEMBLY IF EXISTS SomeAssembly
DROP DATABASE IF EXISTS SomeDatabase
DROP DEFAULT IF EXISTS dbo.SomeDefault
DROP INDEX IF EXISTS dbo.SomeIndex
DROP PROCEDURE IF EXISTS dbo.SomeProcedure
DROP ROLE IF EXISTS SomeRole
DROP RULE IF EXISTS dbo.SomeRule
DROP SCHEMA IF EXISTS SomeSchema
DROP SECURITY POLICY IF EXISTS dbo.SomeSecurityPolicy
DROP SEQUENCE IF EXISTS dbo.SomeSequence
DROP SYNONYM IF EXISTS dbo.SomeSynonym
DROP TABLE IF EXISTS dbo.SomeTable
DROP TRIGGER IF EXISTS dbo.SomeTrigger
DROP TYPE IF EXISTS dbo.SomeType
DROP VIEW IF EXISTS dbo.SomeView

