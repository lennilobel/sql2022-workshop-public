/* =================== Hekaton: Hash & Range Indexes =================== */

-- Indexes are all non-clustered; no concept of heap
-- Indexes are created inline or at end of statement; must be created with table (also works for disk-based tables!)
-- Indexes cannot be created on nullable columns
-- Table can have 8 indexes max
-- Requirements to create a memory-optimized table
--  1) WITH MEMORY_OPTIMIZED = ON
--  2) Create at least one index (up to 8 allowed)
--  3) If durable, must create a PK and an index on that PK

SET NOCOUNT ON
GO

USE MyDb
GO

/* Hash index demo */

CHECKPOINT; DBCC DROPCLEANBUFFERS; DBCC FREEPROCCACHE
SET STATISTICS IO ON

-- (view execution plans)

-- point lookup
SELECT * FROM Order_disk WHERE OrderId = 100000  -- clustered index
SELECT * FROM Order_mod  WHERE OrderId = 100000  -- hash index
-- MOD table is faster because of hash index and no I/O
--  Order_disk: Clustered Index Seek over RowStore storage
--  Order_mod:  Nonclustered Index Seek over MemoryOptimized storage

-- range lookup
SELECT * FROM Order_disk WHERE OrderId BETWEEN 100000 AND 110000
SELECT * FROM Order_mod  WHERE OrderId BETWEEN 100000 AND 110000
-- Disk-based table is faster?!?
--  Order_disk: Clustered Index Seek
--  Order_mod:  Table Scan + Filter, because hash index not helping with range query


/* Range index demo */

-- OrderDate has nonclustered index in Order_disk
-- OrderDate has nonclustered range index in Order_mod

-- point lookup (noncovering)
SELECT * FROM Order_disk WHERE OrderDate = '2013-09-20'	-- nonclustered noncovering index
SELECT * FROM Order_mod  WHERE OrderDate = '2013-09-20'	-- nonclustered covering range index
-- MOD table is faster because their indexes (hash or range) are always covering

-- point lookup (covering)
SELECT OrderDate FROM Order_disk WHERE OrderDate = '2013-09-20'
SELECT OrderDate FROM Order_mod  WHERE OrderDate = '2013-09-20'
-- Disk-based table is faster because now it uses a covering index, and may very well be cached, and there are no concurrency conditions
--  while MOD table is using range (not hash) index not efficient for single-record point lookups, and will shine when there are concurrency conditions

SELECT OrderDate FROM Order_disk WHERE OrderDate BETWEEN '2013-09-20' AND '2013-09-30'
SELECT OrderDate FROM Order_mod  WHERE OrderDate BETWEEN '2013-09-20' AND '2013-09-30'
-- MOD table is faster because of range index

SELECT * FROM Order_mod  WHERE OrderDate BETWEEN '2013-09-20' AND '2013-09-30' ORDER BY OrderDate
SELECT * FROM Order_mod  WHERE OrderDate BETWEEN '2013-09-20' AND '2013-09-30' ORDER BY OrderDate DESC
-- ASC is faster because DESC requires sorting


/* Advanced indexes */

-- Won't work; index columns require *_BIN2 collation (allows high-performance bit-level lookups)
CREATE TABLE Students (
	StudentId int NOT NULL,
	FirstName varchar(256) NOT NULL,
	LastName varchar(256) NOT NULL,
	Age tinyint NOT NULL,
	Major varchar(256) NOT NULL,
	EnrollmentDate datetime,
	INDEX IX_Student_Hash HASH(FirstName, LastName) WITH(BUCKET_COUNT=100),
	INDEX IX_Student_Age_Major (Major ASC, Age ASC)
) WITH (MEMORY_OPTIMIZED=ON, DURABILITY=SCHEMA_ONLY)

-- Using *_BIN2 collation
CREATE TABLE Students (
	StudentId int NOT NULL,
	FirstName varchar(256) COLLATE Latin1_General_100_BIN2 NOT NULL,
	LastName varchar(256) COLLATE Latin1_General_100_BIN2 NOT NULL,
	Age tinyint NOT NULL,
	Major varchar(256) COLLATE Latin1_General_100_BIN2 NOT NULL,
	EnrollmentDate datetime,
	INDEX IX_Student_Hash HASH(FirstName, LastName) WITH(BUCKET_COUNT=100),
	INDEX IX_Student_Age_Major (Major ASC, Age ASC)
) WITH (MEMORY_OPTIMIZED=ON, DURABILITY=SCHEMA_ONLY)

INSERT INTO Students VALUES
 (1, 'John', 'Doe', 26, 'MBA', '5/26/2010'),
 (2, 'James', 'Doe', 22, 'Finance', '5/26/2010'),
 (3, 'Alex', 'Twain', 24, 'Engineering', '5/26/2010'),
 (4, 'Nick', 'Stevens', 30, 'Computer Science', '5/26/2010')

SELECT * FROM Students WHERE FirstName = 'john'							-- won't match on lower case
SELECT * FROM Students WHERE FirstName = 'John'							-- matches, but does a scan because it's a composite index
SELECT * FROM Students WHERE FirstName = 'John' AND LastName = 'Doe'	-- matches, and *does* perform a hash seek because both columns are supplied
SELECT * FROM Students WHERE Major LIKE 'C%' AND Age > 20				-- LIKE and range queries will seek on range indexes
SELECT * FROM Students WHERE Major LIKE 'C%'							-- still seeks when only using *first* column, because range indexes are similar to non-clustered indexes on disk based tables (b-trees)
SELECT * FROM Students WHERE Age > 20									-- now scans because using *second* column

DROP TABLE Students
GO
