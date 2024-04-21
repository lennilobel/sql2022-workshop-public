/* =================== Create Or Alter =================== */

CREATE DATABASE MyDB
GO

USE MyDB
GO


-- PROCEDURE

DROP PROCEDURE IF EXISTS SomeProcedure

EXEC SomeProcedure

CREATE OR ALTER PROCEDURE SomeProcedure AS
 SELECT 'Some output'

EXEC SomeProcedure

CREATE OR ALTER PROCEDURE SomeProcedure AS
 SELECT 'Different output'

EXEC SomeProcedure

DROP PROCEDURE IF EXISTS SomeProcedure

EXEC SomeProcedure


-- FUNCTION

DROP FUNCTION IF EXISTS SomeFunction

SELECT dbo.SomeFunction()

GO
CREATE OR ALTER FUNCTION SomeFunction() RETURNS varchar(50) AS BEGIN
 RETURN 'Some output'
END
GO

SELECT dbo.SomeFunction()

GO
CREATE OR ALTER FUNCTION SomeFunction() RETURNS varchar(50) AS BEGIN
 RETURN 'Different output'
END
GO

SELECT dbo.SomeFunction()

DROP FUNCTION IF EXISTS SomeFunction

SELECT dbo.SomeFunction()
