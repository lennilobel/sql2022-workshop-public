USE MyDB
GO

/*
MongoDB (via the MongoDB API for Azure Cosmos DB)

Database:	FlightTasks
Collection:	TaskList

Documents:
 { "flightId": 1, "dueDate" : "2020-03-01", "name": "Task 1/2 for flight 1" }
 { "flightId": 1, "dueDate" : "2020-03-08", "name": "Task 2/2 for flight 1" }
 { "flightId": 3, "dueDate" : "2020-05-09", "name": "Task for flight 3" }

Use the PolyBaseCosmosMongo app to generate this collection
*/

-- Set MongoDB credentials; IDENTITY and SECRET from Connection Strings tab in Azure portal (Cosmos DB)
CREATE DATABASE SCOPED CREDENTIAL MongoDbCredential
WITH
	IDENTITY = 'cdb-mongo',
	SECRET = '[SECRET]'

-- Set MongoDB data source; LOCATION = 'mongodb://<url>:<port>'
--
-- Won't work with Windows Authenticated connection; use "sa" login, or get this error:
--  SQL Server Network Interfaces: No credentials are available in the security package
--
CREATE EXTERNAL DATA SOURCE MongoDbDataSource WITH (
    LOCATION = 'mongodb://cdb-mongo.mongo.cosmos.azure.com:10255',
    CREDENTIAL = MongoDbCredential
)

-- Create the external table to MongoDB collection in Cosmos DB
CREATE EXTERNAL TABLE Task (
	_id nvarchar(100) NOT NULL,
	flightId int,
	name nvarchar(100),
	dueDate nvarchar(max)
)
WITH (
	LOCATION = 'FlightTasks.TaskList',	-- Case sensitive; database.collection
	DATA_SOURCE = MongoDbDataSource
)

SELECT * FROM Task

