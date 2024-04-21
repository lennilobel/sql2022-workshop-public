/* =================== Change Data Capture =================== */

-- Create test database
CREATE DATABASE CDCDemo
GO

USE CDCDemo
GO

-- Enable CDC on the database
EXEC sp_cdc_enable_db

-- Show CDC-enabled databases
SELECT name, is_cdc_enabled FROM sys.databases

-- View the new "cdc" user and schema
SELECT * FROM sys.schemas WHERE name = 'cdc'
SELECT * FROM sys.database_principals WHERE name = 'cdc'

-- Create Employee table
CREATE TABLE Employee(
 EmployeeId    int NOT NULL PRIMARY KEY,
 EmployeeName  varchar(100) NOT NULL,
 EmailAddress  varchar(200) NOT NULL)

-- Enable CDC on the table (SQL Agent *should* be running when you run this)

EXEC sp_cdc_enable_table
 @source_schema = N'dbo', 
 @source_name = N'Employee',
 @role_name = N'CDC_admin',
 @capture_instance = N'dbo_Employee',
 @supports_net_changes = 1  -- Creates a second CDC function for net change tracking
 
-- Show CDC-enabled tables
SELECT name, is_tracked_by_cdc FROM sys.tables

-- Insert some employees...
INSERT INTO Employee VALUES(1, 'John Smith', 'john.smith@ourcorp.com')
INSERT INTO Employee VALUES(2, 'Steven Jones', 'steven.jones@ourcorp.com')
INSERT INTO Employee VALUES(3, 'Avery Michaels', 'avery.michaels@ourcorp.com')
INSERT INTO Employee VALUES(4, 'James Dylan', 'james.dylan@ourcorp.com')

-- Select them from the table and the change capture table
SELECT * FROM Employee
SELECT * FROM cdc.dbo_employee_ct

-- Delete James
DELETE Employee WHERE EmployeeId = 4

-- Results from Delete
SELECT * FROM Employee
SELECT * FROM cdc.dbo_employee_ct
-- (Note: result of DELETE may take several seconds to show up in CT table)

-- Update Steven and Avery
UPDATE Employee SET EmployeeName = 'Steven P. Jones' WHERE EmployeeId = 2
UPDATE Employee SET EmployeeName = 'Avery K. Michaels' WHERE EmployeeId = 3

-- Results from update
SELECT * FROM Employee
SELECT * FROM cdc.dbo_employee_ct	-- See note above

-- To access change data, use the CDC TVFs, not the change tables directly
DECLARE @begin_time datetime
DECLARE @end_time datetime
DECLARE @from_lsn binary(10)
DECLARE @to_lsn binary(10)
SET @begin_time = GETDATE() - 1
SET @end_time = GETDATE()

-- Map the time interval to a CDC LSN range
SELECT @from_lsn =
 sys.fn_cdc_map_time_to_lsn('smallest greater than or equal', @begin_time)

SELECT @to_lsn =
 sys.fn_cdc_map_time_to_lsn('largest less than or equal', @end_time)

SELECT @begin_time AS BeginTime, @end_time AS EndTime
SELECT @from_lsn AS FromLSN, @to_lsn AS ToLSN

-- Return the changes occurring within the query window.

-- First, all changes that occurred...
SELECT *
 FROM cdc.fn_cdc_get_all_changes_dbo_employee(@from_lsn, @to_lsn, N'all') 

-- Then, net changes, that is, final state...
SELECT *
 FROM cdc.fn_cdc_get_net_changes_dbo_employee(@from_lsn, @to_lsn, N'all')


-- Cleanup

EXEC sp_cdc_disable_table 
 @source_schema = N'dbo',
 @source_name = N'Employee',
 @capture_instance = N'dbo_Employee'

EXEC sp_cdc_disable_db
