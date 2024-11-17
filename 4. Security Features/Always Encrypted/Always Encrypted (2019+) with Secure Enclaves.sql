/* =================== Always Encrypted with Secure Enclaves (2019) =================== */

-- https://learn.microsoft.com/en-us/sql/relational-databases/security/tutorial-getting-started-with-always-encrypted-enclaves?view=sql-server-ver16


/* Step 1: Make sure virtualization-based security (VBS) is enabled */

-- msinfo32.exe

--  If not enabled, use an elevated PowerShell console:
--	 Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard -Name EnableVirtualizationBasedSecurity -Value 1
--   Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard -Name RequirePlatformSecurityFeatures -Value 0
--	 Restart-Computer


/* Step 2: Enable Always Encrypted with secure enclaves in SQL Server */

-- Connect WITHOUT enabling AE in the connection string

-- Set the secure enclave type to virtualization based security (VBS).
EXEC sys.sp_configure 'column encryption enclave type', 1
RECONFIGURE

-- Restart SQL Server instance (?)

-- Confirm the secure enclave is now loaded
SELECT
	name,
	description,
	value,
	value_in_use
FROM
	sys.configurations
WHERE
	name = 'column encryption enclave type'

GO


/* Step 3: Create a sample database */

CREATE DATABASE MyEncryptedDB
GO

USE MyEncryptedDB
GO

CREATE TABLE Employee(
    EmployeeId  int IDENTITY(1,1) PRIMARY KEY,
    Name        varchar(20),
    SSN         varchar(20),
    Salary      money,
    City        varchar(20)
)

INSERT INTO Employee
	(Name,             SSN,            Salary,    City) VALUES
	('James Miller',   '123-45-6789',  61692,    'New York'),      -- > 60000  Same salary as Greg Stevens
	('Doug Nichols',   '987-65-4321',  59415,    'Boston'),        -- < 60000
	('Richard Jones',  '346-90-5513',  50698,    'Chicago'),       -- < 60000
	('Joe Anonymous',  'n/a',          54036,    'Los Angeles'),   -- < 60000
	('Greg Stevens',   '555-43-7801',  61692,    'Seattle')        -- > 60000  Same salary as James Miller

SELECT * FROM Employee
GO


/* Step 4: Provision enclave-enabled keys */

-- CMK1 & CEK1


/* Step 5: Encrypt some columns in place */

-- Connect WITH enabling AE in the connection string (enable secure enclaves, protocol: none)

USE MyEncryptedDB
GO

ALTER TABLE Employee 
	ALTER COLUMN SSN varchar(20)
		COLLATE Latin1_General_BIN2
		ENCRYPTED WITH (
			COLUMN_ENCRYPTION_KEY = CEK1,
			ENCRYPTION_TYPE = Randomized,
			ALGORITHM = 'AEAD_AES_256_CBC_HMAC_SHA_256')
	WITH (ONLINE = ON)

ALTER TABLE Employee
	ALTER COLUMN Salary money
		ENCRYPTED WITH (
			COLUMN_ENCRYPTION_KEY = CEK1,
			ENCRYPTION_TYPE = Randomized,
			ALGORITHM = 'AEAD_AES_256_CBC_HMAC_SHA_256')
	WITH (ONLINE = ON)

-- Notice the ALTER DATABASE SCOPED CONFIGURATION CLEAR PROCEDURE_CACHE statement to clear the query plan cache for the database
-- in the above script. After you have altered the table, you need to clear the plans for all batches and stored procedures that
-- access the table, to refresh parameters encryption information.
ALTER DATABASE SCOPED CONFIGURATION CLEAR PROCEDURE_CACHE

SELECT * FROM Employee
GO

-- and then again with AE disabled in the connection string, just to prove it's encrypted
USE MyEncryptedDB
GO
SELECT * FROM Employee
GO

-- re-enable AE in the connection string
-- and MAKE SURE that parameterization is enabled in advanced query options
USE MyEncryptedDB
GO


/* Step 6: Run rich queries against encrypted columns */

DECLARE @SsnPattern varchar(20) = '%5513'
DECLARE @MinSalary money = 60000

SELECT
    *
FROM
    Employee
WHERE
    SSN LIKE @SSNPattern OR
    Salary >= @MinSalary

GO


/* Cleanup */

EXEC sys.sp_configure 'column encryption enclave type', 0
RECONFIGURE
