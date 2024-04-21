/* =================== TRUNCATE TABLE...WITH PARTITIONS =================== */

USE master
GO

-- Create database with partitions for each quarter
CREATE DATABASE MyPartitionedDB
 ON PRIMARY
  (NAME = MyPartitionedDB_data,
   FILENAME = 'C:\Demo\MyPartitionedDB\MyPartitionedDB.mdf'),
 FILEGROUP MyPartitionedDB_Q1_2018
  (NAME = MyPartitionedDB_Q1_2018,
   FILENAME = 'C:\Demo\MyPartitionedDB\MyPartitionedDB_Q1_2018.ndf'),
 FILEGROUP MyPartitionedDB_Q2_2018
  (NAME = MyPartitionedDB_Q2_2018,
   FILENAME = 'C:\Demo\MyPartitionedDB\MyPartitionedDB_Q2_2018.ndf'),
 FILEGROUP MyPartitionedDB_Q3_2018
  (NAME = MyPartitionedDB_Q3_2018,
   FILENAME = 'C:\Demo\MyPartitionedDB\MyPartitionedDB_Q3_2018.ndf'),
 FILEGROUP MyPartitionedDB_Q4_2018
  (NAME = MyPartitionedDB_Q4_2018,
   FILENAME = 'C:\Demo\MyPartitionedDB\MyPartitionedDB_Q4_2018.ndf')
 LOG ON
  (NAME = MyPartitionedDB_log,
   FILENAME = 'C:\Demo\MyPartitionedDB\MyPartitionedDB_log.ldf')
GO

USE MyPartitionedDB
GO

-- Create the partitioning function to partition the data depending on the four quarters
CREATE PARTITION FUNCTION PartitionByQuarter(int) AS
  RANGE RIGHT FOR VALUES (20181, 20182, 20183, 20184)	-- maps to ((Year * 10) + Quarter)
GO

-- Create the partitioning scheme that specifies the filegroup assigned for each partition value mentioned in the partitioning function
CREATE PARTITION SCHEME PartitionByQuarterScheme AS
  PARTITION PartitionByQuarter TO (
	MyPartitionedDB_Q1_2018,
	MyPartitionedDB_Q2_2018,
	MyPartitionedDB_Q3_2018,
	MyPartitionedDB_Q4_2018,
	[PRIMARY])
GO

-- Create partitioned table
CREATE TABLE PartitionDemo (
 PartitionDemoId int IDENTITY,
 Info varchar(50),
 CreatedAt date,
 QuarterNumber AS ((DATEPART(YEAR, CreatedAt) * 10) + DATEPART(QUARTER, CreatedAt)) PERSISTED,
 CONSTRAINT PK_PartitionDemo PRIMARY KEY (PartitionDemoId, QuarterNumber)
) ON PartitionByQuarterScheme (QuarterNumber)

GO

-- Populate data spread across all quarters
INSERT INTO PartitionDemo VALUES
 ('Lorem ipsum', DATEFROMPARTS(2018, 1, 15)),
 ('dolor sit', DATEFROMPARTS(2018, 2, 15)),
 ('amet brute', DATEFROMPARTS(2018, 4, 15)),
 ('Mea at', DATEFROMPARTS(2018, 6, 15)),
 ('Sit malis', DATEFROMPARTS(2018, 8, 15)),
 ('malorum sed', DATEFROMPARTS(2018, 9, 15)),
 ('omnes decore', DATEFROMPARTS(2018, 10, 15)),
 ('atqui nec', DATEFROMPARTS(2018, 12, 15))

-- View all 8 rows
SELECT * FROM PartitionDemo

-- View partition distribution (Q1 - Q4 in partitions 2 - 5)
SELECT partition_number, rows, object_id
FROM sys.partitions
WHERE OBJECT_NAME(object_id) = 'PartitionDemo'

-- Truncate all Q1 and Q2 data
TRUNCATE TABLE PartitionDemo
WITH (PARTITIONS (2 TO 3))

-- View 4 rows from Q3 and Q4
SELECT * FROM PartitionDemo

-- View partition distribution (data removed from Q1 and Q2 in partitions 2 and 3)
SELECT partition_number, rows, object_id
FROM sys.partitions
WHERE OBJECT_NAME(object_id) = 'PartitionDemo'

-- Cleanup
USE master
GO

DROP DATABASE MyPartitionedDB
