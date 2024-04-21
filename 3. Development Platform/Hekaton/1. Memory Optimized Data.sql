/* =================== Hekaton: Memory Optimized Data =================== */

SET NOCOUNT OFF
GO

USE master
GO

-- Create database with memory-optimized (Hekaton) filegroup
CREATE DATABASE MyDb
 -- PRIMARY (default) filegroup; disk-based .mdf file
 ON PRIMARY 
  (NAME = MyDb,
   FILENAME = 'C:\Demo\Databases\MyDb.mdf'), 
 -- DiskFileGroup (secondary) filegroup; disk-based .ndf file
 FILEGROUP DiskFileGroup
  (NAME = MyDb_disk,
   FILENAME = 'C:\Demo\Databases\MyDb_disk.ndf'),
 -- MemoryFileGroup (secondary) filegroup; memory-optimized with 1 or more stream-storage containers
 FILEGROUP MemoryFileGroup CONTAINS MEMORY_OPTIMIZED_DATA
  (NAME = MyDb_memory,
   FILENAME = 'C:\Demo\Databases\MyDb_memory'),
  (NAME = MyDb_memory2,
   FILENAME = 'C:\Demo\Databases\MyDb_memory2'),
 -- BlobFileGroup; FILESTREAM data with one or more stream-storage containers
 FILEGROUP BlobFileGroup CONTAINS FILESTREAM
  (NAME = MyDb_blob,
   FILENAME = 'C:\Demo\Databases\MyDb_blob'),
  (NAME = MyDb_blob2,
   FILENAME = 'C:\Demo\Databases\MyDb_blob2')
 -- LOG filegroup; disk-based .ldf file
 LOG ON 
  (NAME = MyDb_log,
   FILENAME = 'C:\Demo\Databases\MyDb_log.ldf')
GO

USE MyDb
GO

-- Show filegroups
SELECT
	fg.data_space_id	AS FilegroupId,
	fg.name				AS FilegroupName,
	fg.type				AS FilegroupTypeCode,
	fg.type_desc		AS FilegroupTypeName,
	fg.is_default		AS IsDefaultFilegroup,
	fg.filegroup_guid	AS FilegroupGuid
FROM
	sys.filegroups AS fg

-- Show containers (database files and data spaces)
SELECT
	fg.data_space_id	AS FilegroupId,
	fg.name				AS FilegroupName,
	df.type				AS ContainerTypeId,
	df.type_desc		AS ContainerTypeName,
	df.name				AS ContainerName,
	df.physical_name	AS ContainerLocation
FROM
	sys.database_files AS df
	LEFT JOIN sys.filegroups AS fg ON fg.data_space_id = df.data_space_id
ORDER BY
	fg.data_space_id

/*
-- Add container to MOD filegroup (can have multiple containers to parallelize load) 
ALTER DATABASE MyDb
 ADD FILE (NAME = ModC, FILENAME = 'C:\Demo\Databases\MyDb_mod_c')
 TO FILEGROUP MyDb_Mod
ALTER DATABASE MyDb
 ADD FILE (NAME = ModSSD, FILENAME = 'D:\Demo\Databases\MyDb_mod_ssd')
 TO FILEGROUP MyDb_Mod
*/

-- View database properties in SSMS to see filegroup and memory allocation for memory-optimized data

-- Create disk-based tables
CREATE TABLE [Order](
    OrderId int NULL,
    CustomerId int NULL,
    TotalPrice decimal(13, 2) NULL,
    OrderDate datetime NULL
) ON DiskFileGroup
CREATE TABLE OrderDetail(
    OrderId int NULL,
    LineNumber int NULL,
    Quantity int NULL,
    ExtendedPrice decimal(13, 2) NULL,
    Discount decimal(13, 2) NULL,
    Tax decimal(13, 2) NULL,
    ShipDate datetime NULL,
    Comment varchar(64) NULL
) ON DiskFileGroup

-- Create clustered indexes on all the tables (:38)
CREATE CLUSTERED INDEX IX_Order_clustered ON [Order](
	OrderId ASC) ON Data
CREATE CLUSTERED INDEX IX_OrderDetail_clustered ON OrderDetail(
	OrderId ASC,
	LineNumber ASC) ON Data
GO

-- Insert rows to disk-based Order table (0:10 for 250,000)
CHECKPOINT; DBCC DROPCLEANBUFFERS; DBCC FREEPROCCACHE
BEGIN TRANSACTION
	DECLARE @OrderId int = 1
	WHILE @OrderId <= 250000
	BEGIN
		INSERT INTO [Order] VALUES(
			@OrderId,
			RAND() * (2500 - 1) + 1,		-- CustomerId
			RAND() * (50000 - 120) + 120,	-- TotalPrice
			DATEFROMPARTS(					-- OrderDate
			 RAND() * (2014 - 2010) + 2010,	--	Y
			 RAND() * (12 - 1) + 1,			--	M
			 RAND() * (28 - 1) + 1))		--	D
		SET @OrderId += 1
	END
COMMIT TRANSACTION
GO

-- Insert rows to disk-based OrderDetail table (0:22 for 500,000)
CHECKPOINT; DBCC DROPCLEANBUFFERS; DBCC FREEPROCCACHE
BEGIN TRANSACTION
	DECLARE @OrderId int = 1
	WHILE @OrderId <= 250000
	BEGIN
		INSERT INTO OrderDetail VALUES(
			@OrderId,
			1,										-- LineNumber
			RAND() * (20 - 1) + 1,					-- Quantity
			RAND() * (5000 - 120) + 120,			-- ExtendedPrice
			RAND() * (500 - 0) + 0,					-- Discount
			RAND() * (250 - 25) + 25,				-- Tax
			DATEFROMPARTS(							-- ShipDate
			 RAND() * (2014 - 2010) + 2010,			--	Y
			 RAND() * (12 - 1) + 1,					--	M
			 RAND() * (28 - 1) + 1),				--	D
			CONCAT('Order ', @OrderId, ', Line 1'))	-- Comment
		INSERT INTO OrderDetail VALUES(
			@OrderId,
			2,										-- LineNumber
			RAND() * (20 - 1) + 1,					-- Quantity
			RAND() * (5000 - 120) + 120,			-- ExtendedPrice
			RAND() * (500 - 0) + 0,					-- Discount
			RAND() * (250 - 25) + 25,				-- Tax
			DATEFROMPARTS(							-- ShipDate
			 RAND() * (2014 - 2010) + 2010,			--	Y
			 RAND() * (12 - 1) + 1,					--	M
			 RAND() * (28 - 1) + 1),				--	D
			CONCAT('Order ', @OrderId, ', Line 2'))	-- Comment
		SET @OrderId += 1
	END
COMMIT TRANSACTION
GO

-- Create memory-optimized Order table
CREATE TABLE Order_mod(
    OrderId int NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT = 1000000),  -- Hash index
    CustomerId int NULL,
    TotalPrice decimal(13, 2) NULL,
    OrderDate datetime NOT NULL INDEX IX_Order_mod_OrderDate NONCLUSTERED  -- Nonclustered range index
) WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA)
GO

-- Get database ID to look inside C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\xtp for generated C code
SELECT DB_ID()

-- Create memory-optimized OrderDetail table
CREATE TABLE OrderDetail_mod(
    OrderId int NOT NULL,
    LineNumber int NOT NULL,
    Quantity int NULL,
    ExtendedPrice decimal(13, 2) NULL,
    Discount decimal(13, 2) NULL,
    Tax decimal(13, 2) NULL,
    ShipDate datetime NOT NULL,		-- NULL won't work
    Comment varchar(8000) NULL,		-- max won't work
	PRIMARY KEY NONCLUSTERED (OrderId, LineNumber), -- Hash Index
	INDEX IX_OrderDetail_mod_ShipDate (ShipDate DESC) -- Range Index
) WITH (MEMORY_OPTIMIZED = ON)	-- DURABILITY = SCHEMA_AND_DATA is the default
GO

-- Won't work; 
CREATE INDEX IX_OrderDetail_mod_ShipDate ON OrderDetail_mod (ShipDate DESC)
GO

-- See which tables are memory optimized in sys.tables
SELECT name, is_memory_optimized, durability, durability_desc FROM sys.tables
GO


/* Add data to MOD tables, copying from equivalent disk-based tables */

-- Procedure that shows how many records in the log are generated from a transaction
CREATE PROCEDURE uspGetXactLogRecords(@xact_id bigint) AS
 BEGIN
	WITH xact_log AS (
		SELECT Operation
		 FROM sys.fn_dblog(NULL, NULL)
		 WHERE [Transaction ID] =
		  (SELECT TOP (1) [Transaction ID] FROM sys.fn_dblog(NULL, NULL) WHERE [Xact ID] = @xact_id)
	)
	SELECT Operation, COUNT(*)
	 FROM xact_log
	 GROUP BY Operation
 END
GO

CHECKPOINT; DBCC DROPCLEANBUFFERS; DBCC FREEPROCCACHE
-- Copy from disk table to MOD table (about 2 second for 250,000 rows)
DECLARE @xact_id bigint
BEGIN TRANSACTION
INSERT INTO Order_mod SELECT * FROM [Order]
SELECT @xact_id = TRANSACTION_ID FROM sys.dm_tran_current_transaction
COMMIT
PRINT @xact_id
GO

-- How many records in the log are generated from this transaction? (:53)
EXEC uspGetXactLogRecords 672184
GO
/*
LOP_BEGIN_XACT	1
LOP_COMMIT_XACT	1
LOP_HK	458

Shows < 500 records in the log for inserting (and indexing) 250,000 rows
*/

-- Now create new disk-based [Order] table for comparison
CREATE TABLE Order_disk(
    OrderId int NULL,
    CustomerId int NULL,
    TotalPrice decimal(13, 2) NULL,
    OrderDate datetime NULL
) ON Data
CREATE CLUSTERED INDEX IX_Order_disk_clustered ON Order_disk(OrderId ASC) ON Data		-- Clustered on OrderId
CREATE NONCLUSTERED INDEX IX_Order_disk_OrderDate ON Order_disk(OrderDate ASC) ON Data	-- Nonclustered on OrderDate

CHECKPOINT; DBCC DROPCLEANBUFFERS; DBCC FREEPROCCACHE
-- Copy from disk table to disk table (about 6 seconds for 250,000 rows)
DECLARE @xact_id bigint
BEGIN TRANSACTION
INSERT INTO Order_disk SELECT * FROM [Order]
SELECT @xact_id = TRANSACTION_ID FROM sys.dm_tran_current_transaction
COMMIT
PRINT @xact_id
GO

-- How many records in the log are generated from this transaction? (:16)
EXEC uspGetXactLogRecords 672996
GO
/*
LOP_BEGIN_XACT	1
LOP_COMMIT_XACT	1
LOP_INSERT_ROWS	500000
LOP_LOCK_XACT	3

Shows 500,000 records in the log for inserting (and indexing) 250,000 rows
*/

-- Default disk-based table order scans the B-treehash table, so rows are "in order"
SELECT * FROM Order_disk

-- Default MOD table scans the hash table, so rows are "out of order"
SELECT * FROM Order_mod
SELECT * FROM Order_mod ORDER BY OrderId

-- Copy OrderDetail to MOD table, watch memory consumption in Task Manager (0:06)
INSERT INTO OrderDetail_mod SELECT * FROM OrderDetail  -- ShipDate has no NULLs, so OK



/* =================== Hekaton: Memory Optimized Data =================== */

SET NOCOUNT OFF
GO

USE master
GO

-- Create database
CREATE DATABASE MyDb
 ON PRIMARY 
  (NAME = MyDb,
   FILENAME = 'C:\Demo\Databases\MyDb.mdf'), 
 FILEGROUP Data DEFAULT
  (NAME = MyDb_data,
   FILENAME = 'C:\Demo\Databases\MyDb_data.ndf')
 LOG ON 
  (NAME = MyDb_log,
   FILENAME = 'C:\Demo\Databases\MyDb_log.ldf')
GO

USE MyDb
GO

-- Add a MOD filegroup
ALTER DATABASE MyDb
 ADD FILEGROUP MyDb_mod CONTAINS MEMORY_OPTIMIZED_DATA

-- Show existing MOD filegroups (can only have 1 per database)
SELECT * FROM sys.data_spaces WHERE type = 'FX'

-- Add container to MOD filegroup (can have multiple containers to parallelize load) 
ALTER DATABASE MyDb
 ADD FILE (NAME = ModC, FILENAME = 'C:\Demo\Databases\MyDb_mod_c')
 TO FILEGROUP MyDb_Mod
/*
ALTER DATABASE MyDb
 ADD FILE (NAME = ModSSD, FILENAME = 'D:\Demo\Databases\MyDb_mod_ssd')
 TO FILEGROUP MyDb_Mod
*/

-- View database properties in SSMS to see filegroup and memory allocation for memory-optimized data

-- Create disk-based tables
CREATE TABLE [Order](
    OrderId int NULL,
    CustomerId int NULL,
    TotalPrice decimal(13, 2) NULL,
    OrderDate datetime NULL
) ON Data
CREATE TABLE OrderDetail(
    OrderId int NULL,
    LineNumber int NULL,
    Quantity int NULL,
    ExtendedPrice decimal(13, 2) NULL,
    Discount decimal(13, 2) NULL,
    Tax decimal(13, 2) NULL,
    ShipDate datetime NULL,
    Comment varchar(64) NULL
) ON Data

-- Create clustered indexes on all the tables (:38)
CREATE CLUSTERED INDEX IX_Order_clustered ON [Order](
	OrderId ASC) ON Data
CREATE CLUSTERED INDEX IX_OrderDetail_clustered ON OrderDetail(
	OrderId ASC,
	LineNumber ASC) ON Data
GO

-- Insert rows to disk-based Order table (0:10 for 250,000)
CHECKPOINT; DBCC DROPCLEANBUFFERS; DBCC FREEPROCCACHE
BEGIN TRANSACTION
	DECLARE @OrderId int = 1
	WHILE @OrderId <= 250000
	BEGIN
		INSERT INTO [Order] VALUES(
			@OrderId,
			RAND() * (2500 - 1) + 1,		-- CustomerId
			RAND() * (50000 - 120) + 120,	-- TotalPrice
			DATEFROMPARTS(					-- OrderDate
			 RAND() * (2014 - 2010) + 2010,	--	Y
			 RAND() * (12 - 1) + 1,			--	M
			 RAND() * (28 - 1) + 1))		--	D
		SET @OrderId += 1
	END
COMMIT TRANSACTION
GO

-- Insert rows to disk-based OrderDetail table (0:22 for 500,000)
CHECKPOINT; DBCC DROPCLEANBUFFERS; DBCC FREEPROCCACHE
BEGIN TRANSACTION
	DECLARE @OrderId int = 1
	WHILE @OrderId <= 250000
	BEGIN
		INSERT INTO OrderDetail VALUES(
			@OrderId,
			1,										-- LineNumber
			RAND() * (20 - 1) + 1,					-- Quantity
			RAND() * (5000 - 120) + 120,			-- ExtendedPrice
			RAND() * (500 - 0) + 0,					-- Discount
			RAND() * (250 - 25) + 25,				-- Tax
			DATEFROMPARTS(							-- ShipDate
			 RAND() * (2014 - 2010) + 2010,			--	Y
			 RAND() * (12 - 1) + 1,					--	M
			 RAND() * (28 - 1) + 1),				--	D
			CONCAT('Order ', @OrderId, ', Line 1'))	-- Comment
		INSERT INTO OrderDetail VALUES(
			@OrderId,
			2,										-- LineNumber
			RAND() * (20 - 1) + 1,					-- Quantity
			RAND() * (5000 - 120) + 120,			-- ExtendedPrice
			RAND() * (500 - 0) + 0,					-- Discount
			RAND() * (250 - 25) + 25,				-- Tax
			DATEFROMPARTS(							-- ShipDate
			 RAND() * (2014 - 2010) + 2010,			--	Y
			 RAND() * (12 - 1) + 1,					--	M
			 RAND() * (28 - 1) + 1),				--	D
			CONCAT('Order ', @OrderId, ', Line 2'))	-- Comment
		SET @OrderId += 1
	END
COMMIT TRANSACTION
GO

-- Create memory-optimized Order table
CREATE TABLE Order_mod(
    OrderId int NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT = 1000000),  -- Hash index
    CustomerId int NULL,
    TotalPrice decimal(13, 2) NULL,
    OrderDate datetime NOT NULL INDEX IX_Order_mod_OrderDate NONCLUSTERED  -- Nonclustered range index
) WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA)
GO

-- Get database ID to look inside C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\xtp for generated C code
SELECT DB_ID()

-- Create memory-optimized OrderDetail table
CREATE TABLE OrderDetail_mod(
    OrderId int NOT NULL,
    LineNumber int NOT NULL,
    Quantity int NULL,
    ExtendedPrice decimal(13, 2) NULL,
    Discount decimal(13, 2) NULL,
    Tax decimal(13, 2) NULL,
    ShipDate datetime NOT NULL,		-- NULL won't work
    Comment varchar(8000) NULL,		-- max won't work
	PRIMARY KEY NONCLUSTERED (OrderId, LineNumber), -- Hash Index
	INDEX IX_OrderDetail_mod_ShipDate (ShipDate DESC) -- Range Index
) WITH (MEMORY_OPTIMIZED = ON)	-- DURABILITY = SCHEMA_AND_DATA is the default
GO

-- Won't work; 
CREATE INDEX IX_OrderDetail_mod_ShipDate ON OrderDetail_mod (ShipDate DESC)
GO

-- See which tables are memory optimized in sys.tables
SELECT name, is_memory_optimized, durability, durability_desc FROM sys.tables
GO


/* Add data to MOD tables, copying from equivalent disk-based tables */

-- Procedure that shows how many records in the log are generated from a transaction
CREATE PROCEDURE uspGetXactLogRecords(@xact_id bigint) AS
 BEGIN
	WITH xact_log AS (
		SELECT Operation
		 FROM sys.fn_dblog(NULL, NULL)
		 WHERE [Transaction ID] =
		  (SELECT TOP (1) [Transaction ID] FROM sys.fn_dblog(NULL, NULL) WHERE [Xact ID] = @xact_id)
	)
	SELECT Operation, COUNT(*)
	 FROM xact_log
	 GROUP BY Operation
 END
GO

CHECKPOINT; DBCC DROPCLEANBUFFERS; DBCC FREEPROCCACHE
-- Copy from disk table to MOD table (about 2 second for 250,000 rows)
DECLARE @xact_id bigint
BEGIN TRANSACTION
INSERT INTO Order_mod SELECT * FROM [Order]
SELECT @xact_id = TRANSACTION_ID FROM sys.dm_tran_current_transaction
COMMIT
PRINT @xact_id
GO

-- How many records in the log are generated from this transaction? (:53)
EXEC uspGetXactLogRecords 672184
GO
/*
LOP_BEGIN_XACT	1
LOP_COMMIT_XACT	1
LOP_HK	458

Shows < 500 records in the log for inserting (and indexing) 250,000 rows
*/

-- Now create new disk-based [Order] table for comparison
CREATE TABLE Order_disk(
    OrderId int NULL,
    CustomerId int NULL,
    TotalPrice decimal(13, 2) NULL,
    OrderDate datetime NULL
) ON Data
CREATE CLUSTERED INDEX IX_Order_disk_clustered ON Order_disk(OrderId ASC) ON Data		-- Clustered on OrderId
CREATE NONCLUSTERED INDEX IX_Order_disk_OrderDate ON Order_disk(OrderDate ASC) ON Data	-- Nonclustered on OrderDate

CHECKPOINT; DBCC DROPCLEANBUFFERS; DBCC FREEPROCCACHE
-- Copy from disk table to disk table (about 6 seconds for 250,000 rows)
DECLARE @xact_id bigint
BEGIN TRANSACTION
INSERT INTO Order_disk SELECT * FROM [Order]
SELECT @xact_id = TRANSACTION_ID FROM sys.dm_tran_current_transaction
COMMIT
PRINT @xact_id
GO

-- How many records in the log are generated from this transaction? (:16)
EXEC uspGetXactLogRecords 672996
GO
/*
LOP_BEGIN_XACT	1
LOP_COMMIT_XACT	1
LOP_INSERT_ROWS	500000
LOP_LOCK_XACT	3

Shows 500,000 records in the log for inserting (and indexing) 250,000 rows
*/

-- Default disk-based table order scans the B-treehash table, so rows are "in order"
SELECT * FROM Order_disk

-- Default MOD table scans the hash table, so rows are "out of order"
SELECT * FROM Order_mod
SELECT * FROM Order_mod ORDER BY OrderId

-- Copy OrderDetail to MOD table, watch memory consumption in Task Manager (0:06)
INSERT INTO OrderDetail_mod SELECT * FROM OrderDetail  -- ShipDate has no NULLs, so OK
