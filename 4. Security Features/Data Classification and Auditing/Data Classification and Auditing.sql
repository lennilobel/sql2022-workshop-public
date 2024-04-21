USE WideWorldImporters
GO

-- *** SSMS Data Classification Wizard ***

-- Right-click database, Tasks > Data Discovery and Classification > Classify Data
--   View recommendations
--   Select PaymentMethodName and FullName
--   Save
--   View Report (we'll do the same with catalog view query)
--   Add Classification (we'll do it with T-SQL)
GO

-- Discover classifications from the catalog view
CREATE OR ALTER VIEW ShowClassifications AS
SELECT
	c.name as column_name,
	o.name as table_name,
	sc.information_type,
	sc.information_type_id,
	sc.label,
	sc.label_id
FROM
	sys.sensitivity_classifications AS sc
	INNER JOIN sys.objects AS o ON o.object_id = sc.major_id
	INNER JOIN sys.columns AS c ON c.column_id = sc.minor_id AND c.object_id = sc.major_id

GO
SELECT * FROM ShowClassifications ORDER BY column_name, table_name

-- Add a new classification with any desired sensitivity label and type
--  E.g., Personally Identifiable Information (PII) on an email address column
ADD SENSITIVITY CLASSIFICATION TO [Application].[People].[EmailAddress] WITH (
  LABEL = 'PII',
  INFORMATION_TYPE = 'Email')

SELECT * FROM ShowClassifications ORDER BY column_name, table_name

-- Recreate with label and type IDs
DROP SENSITIVITY CLASSIFICATION FROM [Application].[PaymentMethods].[PaymentMethodName]
DROP SENSITIVITY CLASSIFICATION FROM [Application].[People].[FullName]
DROP SENSITIVITY CLASSIFICATION FROM [Application].[People].[EmailAddress]

DECLARE @LabelId uniqueidentifier = NEWID()
DECLARE @TypeId uniqueidentifier = NEWID()
DECLARE @Sql nvarchar(max) = CONCAT('
	ADD SENSITIVITY CLASSIFICATION TO [Application].[PaymentMethods].[PaymentMethodName] WITH (
	  LABEL = ''Confidential'',
	  LABEL_ID = ''', @LabelId, ''',
	  INFORMATION_TYPE = ''Financial'',
	  INFORMATION_TYPE_ID = ''', @TypeId, ''')
')
EXEC sp_executesql @Sql

SET @LabelId = NEWID()
SET @TypeId = NEWID()
SET @Sql = CONCAT('
	ADD SENSITIVITY CLASSIFICATION TO [Application].[People].[FullName] WITH (
	  LABEL = ''Confidential - GDPR'',
	  LABEL_ID = ''', @LabelId, ''',
	  INFORMATION_TYPE = ''Name'',
	  INFORMATION_TYPE_ID = ''', @TypeId, ''')
')
EXEC sp_executesql @Sql

SET @LabelId = NEWID()
SET @TypeId = NEWID()
SET @Sql = CONCAT('
	ADD SENSITIVITY CLASSIFICATION TO [Application].[People].[EmailAddress] WITH (
	  LABEL = ''PII'',
	  LABEL_ID = ''', @LabelId, ''',
	  INFORMATION_TYPE = ''Email'',
	  INFORMATION_TYPE_ID = ''', @TypeId, ''')
')
EXEC sp_executesql @Sql

SELECT * FROM ShowClassifications ORDER BY column_name, table_name


-- *** Integrate with SQL Audit ***
USE master
GO  
CREATE SERVER AUDIT GDPR_Audit TO FILE (FILEPATH = 'c:\db\audit') -- '/var/opt/mssql')
ALTER SERVER AUDIT GDPR_Audit WITH (STATE = ON)

USE WideWorldImporters
GO  
CREATE DATABASE AUDIT SPECIFICATION People_Audit FOR SERVER AUDIT GDPR_Audit
 ADD (SELECT ON Application.People BY public)   
 WITH (STATE = ON) 
GO

-- Query the audit in the file system
CREATE OR ALTER VIEW ShowAudit AS
SELECT
	event_time,
	session_id,
	server_principal_name,
	database_name,
	object_name,
	CONVERT(xml, data_sensitivity_information) as data_sensitivity_information, 
	client_ip,
	application_name
FROM
--	sys.fn_get_audit_file ('/var/opt/mssql/*.sqlaudit', DEFAULT, DEFAULT)
	sys.fn_get_audit_file ('c:\db\audit\*.sqlaudit', DEFAULT, DEFAULT)

GO
SELECT * FROM ShowAudit ORDER BY event_time

-- Return all columns, audits all sensitive columns
SELECT * FROM [Application].[People]
SELECT * FROM ShowAudit ORDER BY event_time
GO

-- Return specific sensitive column, audits just that column
SELECT FullName FROM [Application].[People]
SELECT * FROM ShowAudit ORDER BY event_time

-- Return specific non-sensitive columns, audits just the row with no column info
SELECT PreferredName FROM [Application].[People] WHERE EmailAddress LIKE '%microsoft%'
SELECT * FROM ShowAudit ORDER BY event_time

-- Attempting to return sensitive columns results in an audit, even for 0 rows returned
SELECT EmailAddress FROM [Application].[People] WHERE CustomFields LIKE '%nomatch%'
SELECT * FROM ShowAudit ORDER BY event_time


/* Cleanup */

ALTER DATABASE AUDIT SPECIFICATION People_Audit WITH (STATE = OFF)
DROP DATABASE AUDIT SPECIFICATION People_Audit
GO

USE master
GO

ALTER SERVER AUDIT GDPR_Audit WITH (STATE = OFF)
DROP SERVER AUDIT GDPR_Audit
GO

-- Remove the .audit files from default or your path
--  del C:\program files\microsoft sql server\mssql15.mssqlserver\mssql\data\GDPR*.audit
--  del C:\db\audit\GDPR*.audit

USE WideWorldImporters
GO

DROP VIEW IF EXISTS ShowAudit
DROP VIEW IF EXISTS ShowClassifications

DROP SENSITIVITY CLASSIFICATION FROM [Application].[PaymentMethods].[PaymentMethodName]
DROP SENSITIVITY CLASSIFICATION FROM [Application].[People].[FullName]
DROP SENSITIVITY CLASSIFICATION FROM [Application].[People].[EmailAddress]
