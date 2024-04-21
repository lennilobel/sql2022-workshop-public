/* =================== SQL Audit =================== */

USE master
GO

-- Create a file audit
CREATE SERVER AUDIT MyFileAudit
 TO FILE (FILEPATH='C:\Demo\SqlAudits')
GO

-- Enable it
ALTER SERVER AUDIT MyFileAudit
 WITH (STATE=ON)
GO

-- Increase the asynchronous time-span for audit processing to one minute
ALTER SERVER AUDIT MyFileAudit WITH (STATE=OFF)
ALTER SERVER AUDIT MyFileAudit WITH (QUEUE_DELAY=60000)
ALTER SERVER AUDIT MyFileAudit WITH (STATE=ON)
GO

-- Change the on-failure setting to SHUTDOWN and reduce the time-span to five seconds
ALTER SERVER AUDIT MyFileAudit WITH (STATE=OFF)
ALTER SERVER AUDIT MyFileAudit WITH (ON_FAILURE=SHUTDOWN, QUEUE_DELAY=5000)
ALTER SERVER AUDIT MyFileAudit WITH (STATE=ON)
GO

-- Change the name of the audit, then name it back
ALTER SERVER AUDIT MyFileAudit WITH (STATE=OFF)
ALTER SERVER AUDIT MyFileAudit MODIFY NAME = SqlFileAudit
ALTER SERVER AUDIT SqlFileAudit WITH (STATE=ON)
GO
ALTER SERVER AUDIT SqlFileAudit WITH (STATE=OFF)
ALTER SERVER AUDIT SqlFileAudit MODIFY NAME = MyFileAudit 
ALTER SERVER AUDIT MyFileAudit WITH (STATE=ON)
GO

-- Create and start an event log audit
CREATE SERVER AUDIT MyEventLogAudit
 TO APPLICATION_LOG
GO
ALTER SERVER AUDIT MyEventLogAudit
 WITH (STATE=ON)
GO

-- Monitor server for all logins and record to event log
CREATE SERVER AUDIT SPECIFICATION CaptureLoginsToEventLog
 FOR SERVER AUDIT MyEventLogAudit
  ADD (FAILED_LOGIN_GROUP),
  ADD (SUCCESSFUL_LOGIN_GROUP)
 WITH (STATE=ON)
GO

-- ...same to file system
CREATE SERVER AUDIT SPECIFICATION CaptureLoginsToFile
 FOR SERVER AUDIT MyFileAudit
  ADD (FAILED_LOGIN_GROUP),
  ADD (SUCCESSFUL_LOGIN_GROUP)
 WITH (STATE=ON)
GO

-- Also monitor changed passwords, and stop monitoring successful logins
ALTER SERVER AUDIT SPECIFICATION CaptureLoginsToFile WITH (STATE=OFF)
ALTER SERVER AUDIT SPECIFICATION CaptureLoginsToFile
 ADD (LOGIN_CHANGE_PASSWORD_GROUP),
 DROP (SUCCESSFUL_LOGIN_GROUP)
ALTER SERVER AUDIT SPECIFICATION CaptureLoginsToFile WITH (STATE=ON)
GO

ALTER SERVER AUDIT SPECIFICATION CaptureLoginsToEventLog WITH (STATE=OFF)
ALTER SERVER AUDIT SPECIFICATION CaptureLoginsToEventLog
 ADD (LOGIN_CHANGE_PASSWORD_GROUP),
 DROP (SUCCESSFUL_LOGIN_GROUP)
ALTER SERVER AUDIT SPECIFICATION CaptureLoginsToEventLog WITH (STATE=ON)
GO

-- Create a database audit
USE MyDB
GO

CREATE DATABASE AUDIT SPECIFICATION CaptureDbActionsToFile
 FOR SERVER AUDIT MyFileAudit
  ADD (DATABASE_OBJECT_CHANGE_GROUP),
  ADD (SELECT, INSERT, UPDATE, DELETE
        ON SCHEMA::dbo
        BY public)
 WITH (STATE=ON)
GO

CREATE DATABASE AUDIT SPECIFICATION CaptureDbActionsToEventLog
 FOR SERVER AUDIT MyEventLogAudit
  ADD (DATABASE_OBJECT_CHANGE_GROUP),
  ADD (SELECT, INSERT, UPDATE, DELETE
        ON SCHEMA::dbo
        BY public)
 WITH (STATE=ON)
GO

CREATE TABLE TestTable(TestId int PRIMARY KEY, TestItem nvarchar(50) NULL)
GO

INSERT INTO TestTable VALUES(1, 'Test')
SELECT * FROM TestTable
UPDATE TestTable SET TestItem='Hello' WHERE TestId=1
DELETE FROM TestTable WHERE TestId=1

-- Using sys.fn_get_audit_file
SELECT * 
 FROM sys.fn_get_audit_file('C:\Demo\SqlAudits\*.sqlaudit', default, default);
GO

-- Using the audit catalog views
SELECT * FROM sys.server_file_audits 
SELECT * FROM sys.server_audit_specifications 
SELECT * FROM sys.server_audit_specification_details 
SELECT * FROM sys.database_audit_specifications 
SELECT * FROM sys.database_audit_specification_details 
SELECT * FROM sys.dm_server_audit_status 
SELECT * FROM sys.dm_audit_actions 
SELECT * FROM sys.dm_audit_class_type_map 

