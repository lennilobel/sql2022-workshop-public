/* =================== Creating a FileTable =================== */

USE master
GO

-- Create an ordinary FILESTREAM-enabled database
CREATE DATABASE DocLibrary
 ON PRIMARY
  (NAME = DocLibrary_data, 
   FILENAME = 'C:\Demo\Databases\DocLibrary_data.mdf'),
 FILEGROUP FileStreamGroup1 CONTAINS FILESTREAM
  (NAME = DocLibrary_blobs, 
   FILENAME = 'C:\Demo\Databases\DocLibrary_blobs')
 LOG ON 
  (NAME = DocLibrary_log,
   FILENAME = 'C:\Demo\Databases\DocLibrary_log.ldf')
GO

-- Switch to the new database
USE DocLibrary
GO

-- Can't create a FileTable without a DIRECTORY_NAME for the database
CREATE TABLE Doc AS FileTable

-- View database level directory name and transacted access settings
SELECT
	db = DB_NAME(database_id),
	directory_name,
	non_transacted_access_desc
 FROM
	sys.database_filestream_options
 ORDER BY
	db

-- Enable the database for FileTable
ALTER DATABASE DocLibrary
 SET FILESTREAM
  (DIRECTORY_NAME='DocLibrary',		-- Enable FileTable in this database
   NON_TRANSACTED_ACCESS=FULL)		-- Enable access via Windows share

-- Use a different folder name for the database
ALTER DATABASE DocLibrary
 SET FILESTREAM
  (DIRECTORY_NAME='Document Library')

-- View database level directory name and transacted access settings
SELECT
	db = DB_NAME(database_id),
	directory_name,
	non_transacted_access_desc
 FROM
	sys.database_filestream_options
 ORDER BY
	db

-- Create a FileTable
--  (directory name defaults to table name, name column collation defaults to database collation)
CREATE TABLE Doc AS FileTable

-- Override the default FileTable directory name
ALTER TABLE Doc SET (FILETABLE_DIRECTORY = 'Documents')

-- Specify the directory and collation when creating the table
DROP TABLE Doc
CREATE TABLE Doc AS FileTable WITH(
 FILETABLE_DIRECTORY = 'Documents',
 FILETABLE_COLLATE_FILENAME = SQL_Latin1_General_CP1_CI_AS)

-- Discover FileTables in the database
SELECT name, is_filetable FROM sys.tables

-- Can't specify a case-sensitive collation for the Name column (filenames in Windows are case-insensitive)
CREATE TABLE ForeignDoc AS FileTable WITH(
 FILETABLE_COLLATE_FILENAME = Japanese_CS_AS)

CREATE TABLE ForeignDoc AS FileTable WITH(
 FILETABLE_COLLATE_FILENAME = Japanese_CI_AS)

DROP TABLE ForeignDoc

GO

/* =================== Populating a FileTable =================== */

USE DocLibrary
GO


/* Show path_locator default constraint */

SELECT
    d.name,
	d.[definition]
 FROM 
    sys.all_columns AS c
    INNER JOIN sys.tables AS t ON c.[object_id] = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
	INNER JOIN sys.default_constraints AS d ON c.default_object_id = d.[object_id]
 WHERE
	s.name = 'dbo' AND t.name = 'Doc' AND c.name = 'path_locator'
GO


/* View FileTable defaults and constraints */

SELECT
	OBJECT_NAME(parent_object_id) FileTableName,
	OBJECT_NAME([object_id]) AS ObjectName
 FROM
	sys.filetable_system_defined_objects

GO


/* Create folders and files */

CREATE PROCEDURE uspAddItem(
	@Parent varchar(max),
	@Name varchar(max),
	@File varchar(max) = NULL)
 AS 
BEGIN

	DECLARE @ParentId hierarchyid = GETPATHLOCATOR(FILETABLEROOTPATH('Doc') + @Parent)
	IF @ParentId IS NULL
	 THROW 50000, 'Parent not found.', 1

	DECLARE @RandomId binary(16) = CONVERT(binary(16), NEWID())
	DECLARE @NewId hierarchyid = CONVERT(hierarchyid, CONCAT(
	 @ParentId.ToString(),
	 CONVERT(varchar(20), CONVERT(bigint, SUBSTRING(@RandomId, 1, 6))), '.',
	 CONVERT(varchar(20), CONVERT(bigint, SUBSTRING(@RandomId, 7, 6))), '.',
	 CONVERT(varchar(20), CONVERT(bigint, SUBSTRING(@RandomId, 13, 4))), '/'))

	DECLARE @Blob varbinary(max)

	IF @File IS NOT NULL BEGIN
		DECLARE @GetBlobSql nvarchar(max) =
		 N'SET @Blob = (SELECT BulkColumn FROM OPENROWSET(BULK ''' + @File + ''', SINGLE_BLOB) AS x)'
		EXECUTE sp_executesql @GetBlobSql, N'@Blob varbinary(max) OUTPUT', @Blob = @Blob OUTPUT
	END

	INSERT INTO Doc(file_stream, name, path_locator, is_directory)
	 VALUES(@Blob, @Name, @NewId, IIF(@File IS NULL, 1, 0))

END
GO


/* Don't allow files in the root folder */

ALTER TABLE Doc
 ADD CONSTRAINT CK_Doc_NoRootFiles CHECK (is_directory = 1 OR path_locator.GetLevel() > 1)
GO

EXEC uspAddItem '', 'CompanyLogo.png', 'C:\Demo\Files\Dummy.png'
GO


-- Create folder \Financial
EXEC uspAddItem '', 'Financial'

-- Add file to \Financial folder
EXEC uspAddItem '\Financial', 'CompanyLogo.png', 'C:\Demo\Files\Dummy.png'

SELECT *, path_locator.GetLevel(), path_locator.ToString() FROM Doc

-- Create folder \Financial\Budget
EXEC uspAddItem '\Financial', 'Budget'

-- Create folder \Financial\Budget\2014
EXEC uspAddItem '\Financial\Budget', '2014'

-- Add files to 2014 folder
EXEC uspAddItem '\Financial\Budget\2014', 'ReadMe2014.txt', 'C:\Demo\Files\Dummy.txt'
EXEC uspAddItem '\Financial\Budget\2014', 'DinnerReceipt.png', 'C:\Demo\Files\Dummy.png'
EXEC uspAddItem '\Financial\Budget\2014', 'TravelBudget.rtf', 'C:\Demo\Files\Dummy.rtf'

-- Create folder \Financial\2013
EXEC uspAddItem '\Financial', '2013'

-- Add files to 2013 folder
EXEC uspAddItem '\Financial\2013', 'ReadMe2013.txt', 'C:\Demo\Files\Dummy.txt'
EXEC uspAddItem '\Financial\2013', 'Entertainment.png', 'C:\Demo\Files\Dummy.png'

SELECT *, path_locator.GetLevel(), path_locator.ToString() FROM Doc

GO


/* Disable/Enable FileTable namespace */

ALTER TABLE Doc DISABLE FILETABLE_NAMESPACE

-- Constraints are disabled! Perform bulk updates very carefully...

ALTER TABLE Doc ENABLE FILETABLE_NAMESPACE
GO

/* =================== Querying and Manipulating a FileTable =================== */

USE DocLibrary
GO

SELECT *, path_locator.GetLevel(), path_locator.ToString() FROM Doc
GO


/* Move folders and files */

CREATE PROCEDURE uspMoveItem(@FullName varchar(max), @NewParent varchar(max))
 AS
BEGIN

	DECLARE @ItemId hierarchyid = GETPATHLOCATOR(FILETABLEROOTPATH('Doc') + @FullName)
	IF @ItemId IS NULL
	 THROW 50000, 'Item not found.', 1

	DECLARE @OldParentId hierarchyid = @ItemId.GetAncestor(1)

	DECLARE @NewParentId hierarchyid = GETPATHLOCATOR(FILETABLEROOTPATH('Doc') + @NewParent)
	IF @NewParentId IS NULL
	 THROW 50000, 'New parent not found.', 1

	UPDATE Doc
		SET path_locator = path_locator.GetReparentedValue(@OldParentId, @NewParentId)
		WHERE path_locator.IsDescendantOf(@ItemId) = 1

END
GO

-- Move \Financial\2013 to \Financial\Budget\2013
EXEC uspMoveItem '\Financial\2013', '\Financial\Budget'

-- Move DinnerReceipt.png from 2014 folder to 2013 folder
EXEC uspMoveItem '\Financial\Budget\2014\DinnerReceipt.png', '\Financial\Budget\2013'

GO


/* Get child subtrees */

CREATE PROCEDURE uspGetChildItems(@FullName varchar(max))
 AS
BEGIN
	SELECT
		IIF(is_directory = 1, 'Folder', 'File') AS ItemType,
		name AS ItemName,
		file_stream.GetFileNamespacePath() AS ItemPath
	 FROM
		Doc
	 WHERE
		path_locator.IsDescendantOf(GETPATHLOCATOR(FILETABLEROOTPATH('Doc') + @FullName)) = 1
	 ORDER BY
		ItemPath
END
GO

EXEC uspGetChildItems '\Financial'
EXEC uspGetChildItems '\Financial\Budget'
EXEC uspGetChildItems '\Financial\Budget\2013'
EXEC uspGetChildItems '\Financial\Budget\2014'

GO


/* Get parent folders */

CREATE PROCEDURE uspGetParentItems(@FullName varchar(max))
 AS
BEGIN
	SELECT
		IIF(parent.is_directory = 1, 'Folder', 'File') AS ItemType,
		parent.name as ItemName,
		parent.file_stream.GetFileNamespacePath() as ItemPath
	 FROM
		Doc AS parent
		INNER JOIN Doc AS child ON child.path_locator.IsDescendantOf(parent.path_locator) = 1
	 WHERE
		child.path_locator = GETPATHLOCATOR(FILETABLEROOTPATH('Doc') + @FullName)
	 ORDER BY
		ItemPath
END
GO

-- Show parent folders
EXEC uspGetParentItems '\Financial\Budget\2014\TravelBudget.rtf'
EXEC uspGetParentItems '\Financial\Budget\2014'
EXEC uspGetParentItems '\Financial\Budget\2013'
EXEC uspGetParentItems '\Financial\Budget'
EXEC uspGetParentItems '\Financial'

GO


/* Delete folders and files */

CREATE PROCEDURE uspDeleteItem(@FullName varchar(max))
 AS
BEGIN

	DECLARE @ItemId hierarchyid = GETPATHLOCATOR(FILETABLEROOTPATH('Doc') + @FullName)
	IF @ItemId IS NULL
	 THROW 50000, 'Item not found.', 1

	DELETE FROM Doc WHERE path_locator.IsDescendantOf(@ItemId) = 1

END
GO

-- Delete ReadMe2014.txt from 2014 folder
EXEC uspDeleteItem '\Financial\Budget\2014\ReadMe2014.txt'

-- Manipulate file table from file system
SELECT *, path_locator.GetLevel(), path_locator.ToString() FROM Doc

-- Delete \Financial\Budget folder
EXEC uspDeleteItem '\Financial\Budget'

GO

