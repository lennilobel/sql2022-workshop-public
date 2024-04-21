/* =================== SELECT...INTO...ON =================== */

USE master
GO

DROP DATABASE IF EXISTS MyPartitionedDB
GO

-- Create database with a primary and and secondary filegroup
CREATE DATABASE MyPartitionedDB
 ON PRIMARY
  (NAME = MyPartitionedDB_primary,
   FILENAME = 'C:\Demo\MyPartitionedDB\MyPartitionedDB.mdf'),
 FILEGROUP MySecondary
  (NAME = MyPartitionedDB_secondary,
   FILENAME = 'C:\Demo\MyPartitionedDB\MyPartitionedDB_secondary.ndf')
 LOG ON
  (NAME = MyPartitionedDB_log,
   FILENAME = 'C:\Demo\MyPartitionedDB\MyPartitionedDB_log.ldf')
GO

-- Discover the filegroups
EXEC sp_helpdb 'MyPartitionedDB'

SELECT
	groupname,
	isdefault = FILEGROUPPROPERTY(groupname, 'IsDefault')
FROM
	MyPartitionedDB.dbo.sysfilegroups


USE MyPartitionedDB
GO

-- SELECT...INTO always creates new table in the default filegroup
SELECT * 
INTO ProductDemo
FROM AdventureWorks2017.Production.Product

EXEC sp_help 'ProductDemo'

DROP TABLE ProductDemo

-- With ON, we can create the new table in any specific filegroup
SELECT * 
INTO ProductDemo ON MySecondary
FROM AdventureWorks2017.Production.Product

EXEC sp_help 'ProductDemo'

-- Cleanup
USE master
GO

DROP DATABASE MyPartitionedDB
