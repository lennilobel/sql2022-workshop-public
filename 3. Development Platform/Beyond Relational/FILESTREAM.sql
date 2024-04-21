USE master
GO

EXEC sp_configure filestream_access_level, 2
RECONFIGURE
GO

/* =================== Create a new FILESTREAM-enabled database =================== */

-- Create database with FILESTREAM filegroup/container
CREATE DATABASE PhotoLibrary
 ON PRIMARY
  (NAME = PhotoLibrary_data, 
   FILENAME = 'C:\Demo\PhotoLibrary\PhotoLibrary_data.mdf'),
 FILEGROUP FileStreamGroup1 CONTAINS FILESTREAM
  (NAME = PhotoLibrary_blobs, 
   FILENAME = 'C:\Demo\PhotoLibrary\Photos')
 LOG ON 
  (NAME = PhotoLibrary_log,
   FILENAME = 'C:\Demo\PhotoLibrary\PhotoLibrary_log.ldf')
GO

-- Switch to the new database
USE PhotoLibrary
GO

-- Show the database filegroups
SELECT * FROM sys.filegroups

/* =================== FILESTREAM-enable an existing database =================== */

-- Switch to master
USE master
GO

-- Drop the database
DROP DATABASE PhotoLibrary
GO

-- Recreate the database without the FILESTREAM filegroup/container
 CREATE DATABASE PhotoLibrary
 ON PRIMARY
  (NAME = PhotoLibrary_data, 
   FILENAME = 'C:\Demo\PhotoLibrary\PhotoLibrary_data.mdf')
 LOG ON 
  (NAME = PhotoLibrary_log,
   FILENAME = 'C:\Demo\PhotoLibrary\PhotoLibrary_log.ldf')
GO

-- Switch to the new database
USE PhotoLibrary
GO

-- Show the database filegroups
SELECT * FROM sys.filegroups

-- Add a FILESTREAM filegroup to the database
ALTER DATABASE PhotoLibrary
 ADD FILEGROUP FileStreamGroup1 CONTAINS FILESTREAM

-- Add a container to the FILESTREAM filegroup
ALTER DATABASE PhotoLibrary
 ADD FILE
  (NAME = PhotoLibrary_blobs, 
   FILENAME = 'C:\Demo\PhotoLibrary\Photos')
 TO FILEGROUP FileStreamGroup1

-- Show the database filegroups
SELECT * FROM sys.filegroups
USE PhotoLibrary
GO

/* =================== Use T-SQL to store and retrieve FILESTREAM data =================== */

-- Create a FILESTREAM-enabled table
CREATE TABLE PhotoAlbum(
 PhotoId int PRIMARY KEY,
 RowId uniqueidentifier ROWGUIDCOL NOT NULL UNIQUE DEFAULT NEWSEQUENTIALID(),
 PhotoDescription varchar(max),
 Photo varbinary(max) FILESTREAM)

GO

-- Add row #1 with a simple text BLOB using CAST
INSERT INTO PhotoAlbum(PhotoId, PhotoDescription, Photo)
 VALUES(
	1,
	'Text file',
	CAST('BLOB' AS varbinary(max)))
 
SELECT *, DATALENGTH(Photo) AS BlobSize, CAST(Photo AS varchar) AS BlobAsText FROM PhotoAlbum

-- Add row #2 with a small icon BLOB using inlined binary content
INSERT INTO PhotoAlbum(PhotoId, PhotoDescription, Photo)
 VALUES(
	2,
	'Document icon',
	0x4749463839610C000E00B30000FFFFFFC6DEC6C0C0C0000080000000D3121200000000000000000000000000000000000000000000000000000000000021F90401000002002C000000000C000E0000042C90C8398525206B202F1820C80584806D1975A29AF48530870D2CEDC2B1CBB6332EDE35D9CB27DCA554484204003B)

SELECT *, DATALENGTH(Photo) AS BlobSize FROM PhotoAlbum

-- Add row #3 with an external image file imported using OPENROWSET with SINGLE_BLOB
INSERT INTO PhotoAlbum(PhotoId, PhotoDescription, Photo)
 VALUES(
	3,
	'Mountains',
	(SELECT BulkColumn FROM OPENROWSET(BULK 'C:\Demo\Files\Ascent.jpg', SINGLE_BLOB) AS x))

SELECT *, DATALENGTH(Photo) AS BlobSize FROM PhotoAlbum


/* =================== Use T-SQL to delete FILESTREAM data =================== */

-- Delete row #1
DELETE FROM PhotoAlbum WHERE PhotoId = 1
SELECT * FROM PhotoAlbum

-- Forcing garbage collection won't delete the file without a BACKUP if using FULL recovery model
EXEC sp_filestream_force_garbage_collection 

-- Backup the database
ALTER DATABASE PhotoLibrary SET RECOVERY SIMPLE
BACKUP DATABASE PhotoLibrary TO DISK = N'C:\Demo\Backups\PhotoLibrary.bak' 

-- Forcing garbage collection will now delete the file immediately
EXEC sp_filestream_force_garbage_collection 
GO


/* =================== PhotoLibraryWeb stored procedures to insert/select rows for streaming API =================== */

-- Insert new photo row
CREATE PROCEDURE InsertPhotoRow(
	@PhotoId int,
	@PhotoDescription varchar(max))
 AS
BEGIN
	
	INSERT INTO PhotoAlbum(PhotoId, PhotoDescription, Photo)
	 OUTPUT inserted.Photo.PathName(), GET_FILESTREAM_TRANSACTION_CONTEXT()
	 SELECT @PhotoId, @PhotoDescription, 0x

END
GO

-- Select photo image path + txn context
CREATE PROCEDURE SelectPhotoImageInfo(@PhotoId int)
 AS
BEGIN
	
	SELECT
		Photo.PathName(),
		GET_FILESTREAM_TRANSACTION_CONTEXT()
	 FROM PhotoAlbum
	 WHERE PhotoId = @PhotoId

END
GO

-- Select photo description
CREATE PROCEDURE SelectPhotoDescription(
	@PhotoId int,
	@PhotoDescription varchar(max) OUTPUT)
 AS
BEGIN
	
	SELECT @PhotoDescription = PhotoDescription
	 FROM PhotoAlbum
	 WHERE PhotoId = @PhotoId

END
GO
