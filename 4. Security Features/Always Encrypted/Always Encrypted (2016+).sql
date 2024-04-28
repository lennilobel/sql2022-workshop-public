/* =================== Always Encrypted (2016) =================== */

CREATE DATABASE MyEncryptedDB
GO

USE MyEncryptedDB
GO

-- Populate a table with sensitive data
CREATE TABLE Employee(
    EmployeeId  int IDENTITY PRIMARY KEY,
    Name        varchar(20),
    SSN         varchar(20),
    Salary      money,
    City        varchar(20)
)

INSERT INTO Employee
 (Name,             SSN,            Salary,    City) VALUES
 ('James Miller',   '123-45-6789',  61692,    'New York'),      --  Same salary as Greg Stevens
 ('Doug Nichols',   '987-65-4321',  59415,    'Boston'),
 ('Richard Jones',  '346-90-5513',  50698,    'Chicago'),
 ('Joe Anonymous',  'n/a',          54036,    'Los Angeles'),   --  Same SSN as Jane Anonymous
 ('Jane Anonymous', 'n/a',          48909,    'Orlando'),       --  Same SSN as Joe Anonymous
 ('Greg Stevens',   '555-43-7801',  61692,    'Seattle')        --  Same salary as James Miller

-- View the sensitive data, unencrypted
SELECT * FROM Employee

-- Discover Always Encrypted keys (none yet)
SELECT * FROM sys.column_master_keys
SELECT * FROM sys.column_encryption_keys 
SELECT * FROM sys.column_encryption_key_values

-- Discover columns protected by Always Encrypted (none yet)
SELECT * FROM sys.columns WHERE column_encryption_key_id IS NOT NULL

/*
	Use Always Encrypted Wizard in SSMS to encrypt sensitive columns (Tasks, Encrypt Columns..., about 15 sec)
		- SSN (deterministic)
		- Salary (randomized)

	The Table now looks like this:

	CREATE TABLE Employee(
		EmployeeId int IDENTITY(1,1) NOT NULL,
		Name varchar(20),
		SSN varchar(20)
			COLLATE Latin1_General_BIN2
			ENCRYPTED WITH (
				COLUMN_ENCRYPTION_KEY = CEK_Auto1,
				ENCRYPTION_TYPE = Deterministic,
				ALGORITHM = 'AEAD_AES_256_CBC_HMAC_SHA_256'),
		Salary money
			ENCRYPTED WITH (
				COLUMN_ENCRYPTION_KEY = CEK_Auto1,
				ENCRYPTION_TYPE = Randomized,
				ALGORITHM = 'AEAD_AES_256_CBC_HMAC_SHA_256'),
		City varchar(20)
	)
*/

-- Data appears encrypted
SELECT * FROM Employee

-- Can't run queries on encrypted columns
SELECT * FROM Employee WHERE Salary = 59415
SELECT * FROM Employee WHERE SSN = 'n/a'

-- Discover Always Encrypted keys
SELECT * FROM sys.column_master_keys
SELECT * FROM sys.column_encryption_keys 
SELECT * FROM sys.column_encryption_key_values

-- Discover columns protected by Always Encrypted
SELECT
    ColumnName      = c.name,
    DatabaseName    = ISNULL(c.column_encryption_key_database_name, DB_NAME()),
    EncryptionType  = encryption_type_desc,
    CekName         = cek.name,
    CekValue        = cekv.encrypted_value,
    CmkName         = cmk.name,
    CmkProviderType = cmk.key_store_provider_name,
    CmkPath         = cmk.key_path
FROM
    sys.columns AS c
    INNER JOIN sys.column_encryption_keys AS cek ON cek.column_encryption_key_id = c.column_encryption_key_id
    INNER JOIN sys.column_encryption_key_values AS cekv ON cekv.column_encryption_key_id = cek.column_encryption_key_id
    INNER JOIN sys.column_master_keys AS cmk ON cmk.column_master_key_id = cekv.column_master_key_id
WHERE
    c.column_encryption_key_id IS NOT NULL

/* Change database connection to use "column encryption setting=enabled" option */

-- As of SSMS 17.0 - we can parameterize SQL statements in the query window for Always Encrypted
--  https://docs.microsoft.com/en-us/sql/relational-databases/security/encryption/configure-always-encrypted-using-sql-server-management-studio?view=sql-server-2017
USE MyEncryptedDB
GO

-- Data appears decrypted
SELECT * FROM Employee

-- Still can't run queries on encrypted columns, or insert/update encrypted columns, with SSMS alone. These
-- actions must be parameterized, and issued by an ADO.NET client with "column encryption setting=enabled"
SELECT * FROM Employee WHERE Salary = 59415
SELECT * FROM Employee WHERE SSN = 'n/a'

INSERT INTO Employee VALUES
 ('John Smith', '246-80-1357', 52631, 'Las Vegas')

-- Won't work with randomized
DECLARE @Salary money = 59415
SELECT * FROM Employee WHERE Salary = @Salary

-- Works with deterministic, if parameterization is enabled for AE in SSMS
DECLARE @SSN varchar(20) = 'n/a'
SELECT * FROM Employee WHERE SSN = @SSN

DECLARE @NewName varchar(20) = 'John Smith'
DECLARE @NewSSN varchar(20) = '246-80-1357'
DECLARE @NewSalary money = 52631
DECLARE @NewCity varchar(20) = 'Las Vegas'
INSERT INTO Employee VALUES
 (@NewName, @NewSSN, @NewSalary, @NewCity)

SELECT * FROM Employee
GO


-- Create stored procedures over AE-columns (automatic parameter-to-column mapping)

CREATE OR ALTER PROCEDURE SelectEmployees
AS
BEGIN
    SELECT
        EmployeeId,
        Name,
        SSN,
        Salary,
        City
    FROM
        Employee
END
GO

CREATE OR ALTER PROCEDURE SelectEmployeesBySSN
    @SSN varchar(20)
AS
BEGIN
    SELECT
        EmployeeId,
        Name,
        SSN,
        Salary,
        City
    FROM
        Employee
    WHERE
        SSN = @SSN
END
GO

CREATE OR ALTER PROCEDURE InsertEmployee
    @Name varchar(20),
    @SSN varchar(20),   	-- must match AE column data type in table or procedure won't compile
    @Salary money,         	-- must match AE column data type in table or procedure won't compile
    @City varchar(20)
AS
BEGIN
    INSERT INTO Employee (Name, SSN, Salary, City)
     VALUES (@Name, @SSN, @Salary, @City)
END
GO

/* Run ADO.NET client */

-- Show encrypted data generated by client (in clear text)
SELECT * FROM Employee

/* Change database connection not to use "column encryption setting=enabled" option */

USE MyEncryptedDB
GO

-- Show encrypted data generated by client unreadable
SELECT * FROM Employee


-- Client driver parameter detection

-- Can't query on randomized
EXEC sp_describe_parameter_encryption N'SELECT COUNT(*) FROM Employee WHERE Salary = @Salary',N'@Salary money'

-- Describe encrypted SELECT parameter
EXEC sp_describe_parameter_encryption N'SELECT COUNT(*) FROM Employee WHERE SSN = @SSN',N'@SSN varchar(20)'

EXEC sp_executesql N'SELECT COUNT(*) FROM Employee WHERE SSN = @SSN',N'@SSN varchar(20)',
 @SSN=0x01C6AACCAD7B5D30584626E97FE3CEB00B4C8DC4F5BE1ED9A951CAF73B6083EB9B69E30FB816C96B252794AB4EBC2CCD9193855A1D838331596EC868127A6DBAE8

-- Can't run range query
EXEC sp_describe_parameter_encryption N'SELECT COUNT(*) FROM Employee WHERE SSN >= @SSN',N'@SSN varchar(20)'

-- Describe encrypted INSERT parameters
EXEC sp_describe_parameter_encryption
 N'INSERT INTO Employee VALUES(@Name, @SSN, @Salary, @City)',
 N'@Name varchar(20),@SSN varchar(20),@Salary money,@City varchar(20)'

EXEC sp_executesql
 N'INSERT INTO Employee VALUES(@Name, @SSN, @Salary, @City)',
 N'@Name varchar(20),@SSN varchar(20),@Salary money,@City varchar(20)',
 @Name='John Doe',
 @SSN=0x0197EE262DFF8D30BD6572CEC3C6D876CBEED25F180E045204FDE51C15E121981C70FE07378D6AA9F0CAA8335AAC182EFC918C608B551D6AE24F70666799390F36,
 @Salary=0x01402770B9B82F5575A5A1E3154DBE4C590B21EFEA8F15BD959F8480BD5FAA74DFB645420CA5401ADBDFC2BC77CD8038A4B67014EEBDF77046447A9B4A785CF0B7,
 @City='Los Angeles'

-- Describe encrypted stored procedure parameter mapped to SELECT statement
EXEC sp_describe_parameter_encryption
 N'EXEC [SelectEmployeesBySSN] @SSN=@SSN',N'@SSN varchar(20)'

EXEC SelectEmployeesBySSN
 @SSN=0x01C6AACCAD7B5D30584626E97FE3CEB00B4C8DC4F5BE1ED9A951CAF73B6083EB9B69E30FB816C96B252794AB4EBC2CCD9193855A1D838331596EC868127A6DBAE8

-- Describe encrypted stored procedure parameter mapped to INSERT statement
EXEC sp_describe_parameter_encryption
 N'EXEC [InsertEmployee] @Name=@Name, @SSN=@SSN, @Salary=@Salary, @City=@City, @EmployeeId=@EmployeeId OUTPUT',
 N'@Name varchar(20),@SSN varchar(20),@Salary money,@City varchar(7),@EmployeeId int output'

DECLARE @p4 int
SET @p4=6
EXEC InsertEmployee
 @Name='Jane Smith',
 @SSN=0x0197EE262DFF8D30BD6572CEC3C6D876CBEED25F180E045204FDE51C15E121981C70FE07378D6AA9F0CAA8335AAC182EFC918C608B551D6AE24F70666799390F36,
 @Salary=0x01402770B9B82F5575A5A1E3154DBE4C590B21EFEA8F15BD959F8480BD5FAA74DFB645420CA5401ADBDFC2BC77CD8038A4B67014EEBDF77046447A9B4A785CF0B7,
 @City='Atlanta'
SELECT @p4

-- Cleanup
USE master
GO
ALTER DATABASE MyEncryptedDB SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
DROP DATABASE MyEncryptedDB


--  delete certificate
