USE master
GO

/*
	SELECT compatibility_level FROM sys.databases WHERE name = 'AdventureWorks2017'

	ALTER DATABASE AdventureWorks2017 SET COMPATIBILITY_LEVEL = 130		-- SQL Server 2016
	ALTER DATABASE AdventureWorks2017 SET COMPATIBILITY_LEVEL = 140		-- SQL Server 2017
	ALTER DATABASE AdventureWorks2017 SET COMPATIBILITY_LEVEL = 150		-- SQL Server 2019
*/

CREATE OR ALTER PROCEDURE SetDbCompatLevel
	@DbName varchar(max),
	@CompatLevel int
AS
BEGIN

	-- Get current db compat level
	DECLARE @CurrentCompatLevel int = (SELECT compatibility_level FROM sys.databases WHERE name = @DbName)

	-- Change db compat level
	DECLARE @Sql nvarchar(max) = CONCAT('ALTER DATABASE ', @DbName, ' SET COMPATIBILITY_LEVEL = ', @CompatLevel)
	EXEC sp_executesql @Sql

	-- Show before/after
	SELECT
		@DbName AS DbName,
		@CurrentCompatLevel AS Before,
		@CompatLevel AS After

	-- Clear caches for cold start
	DBCC FREEPROCCACHE
	DBCC DROPCLEANBUFFERS

END
GO
