USE MyDB
GO

-- Set Azure Storage credentials; IDENTITY must be set to SHARED ACCESS SIGNATURE, and SECRET is a SAS token
CREATE DATABASE SCOPED CREDENTIAL AzureStorageCredential
WITH
	IDENTITY = 'SHARED ACCESS SIGNATURE',
	SECRET = '[SECRET]'

-- Set Azure Storage data source; LOCATION = 'abs://<container-name>@<account-name>.blob.core.windows.net'
CREATE EXTERNAL DATA SOURCE AzureStorageDataSource WITH (
    LOCATION = 'abs://polybase@lennidemo.blob.core.windows.net',
    CREDENTIAL = AzureStorageCredential
)

-- Set the CSV file format
CREATE EXTERNAL FILE FORMAT CsvFileFormat 
WITH (
	FORMAT_TYPE = DELIMITEDTEXT,
	FORMAT_OPTIONS (
		FIELD_TERMINATOR = ',',
		STRING_DELIMITER = '"'
	)
)

-- Create the external table to CSV file in Azure Blob Storage
CREATE EXTERNAL TABLE Airport (
	Code varchar(3),
	Description varchar(100)
)
WITH (
	LOCATION = '/AIRPORT.csv',	-- Case sensitive; creates new file if not found
	DATA_SOURCE = AzureStorageDataSource,
	FILE_FORMAT = CsvFileFormat
)

-- Pull from CSV file
SELECT * FROM Airport
ORDER BY Code
