USE MyDB
GO

-- Cleanup for Azure Blob Storage
DROP TABLE IF EXISTS Flight
DROP EXTERNAL TABLE Airport
DROP EXTERNAL FILE FORMAT CsvFileFormat
DROP EXTERNAL DATA SOURCE AzureStorageDataSource
DROP DATABASE SCOPED CREDENTIAL AzureStorageCredential

-- Cleanup for MongoDB
DROP EXTERNAL TABLE Task
DROP EXTERNAL DATA SOURCE MongoDbDataSource
DROP DATABASE SCOPED CREDENTIAL MongoDbCredential
DROP MASTER KEY

EXEC sp_configure @configname = 'polybase enabled', @configvalue = 0
RECONFIGURE
GO
