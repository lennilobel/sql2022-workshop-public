/* =================== Transparent Data Encryption =================== */

USE master
GO

-- Create master key
CREATE MASTER KEY
 ENCRYPTION BY PASSWORD = '[PASSWORD]'

-- Create TDE certificate
CREATE CERTIFICATE MyEncryptionCert
 WITH SUBJECT = 'My Encryption Certificate'

-- Verify that the certificate has been created and is protected by the master key
SELECT name, pvt_key_encryption_type_desc FROM sys.certificates
 WHERE name = 'MyEncryptionCert'

-- Store some sensitive data in our database
USE MyDB
GO

CREATE TABLE Customer(
 CustomerId int PRIMARY KEY,
 FirstName varchar(50),
 LastName varchar(50),
 CardType varchar(10),
 CardNumber varchar(20))

INSERT INTO Customer VALUES
 (1, 'Luke', 'Skywalker', 'Amex', '3728-495384-12338'),
 (2, 'Frodo', 'Baggins', 'Visa', '4563-3423-4345-6011'),
 (3, 'James', 'Kirk', 'MasterCard', '5424-4837-1425-3928')

SELECT * FROM Customer

-- Backup the unencrypted database
BACKUP DATABASE MyDB TO DISK = N'C:\Demo\Backups\MyDBUnencrypted.bak' 

-- 4C 75 6B 65 = Luke

-- Create DEK
CREATE DATABASE ENCRYPTION KEY
 WITH ALGORITHM = AES_128
 ENCRYPTION BY SERVER CERTIFICATE MyEncryptionCert

-- Enable TDE on the database
ALTER DATABASE MyDB SET ENCRYPTION ON

-- Verify TDE is enabled on the database
SELECT name, is_encrypted FROM sys.databases

-- Monitor encryption progress
SELECT
   sys.databases.name,
   sys.dm_database_encryption_keys.encryption_state,
   sys.dm_database_encryption_keys.percent_complete,
   sys.dm_database_encryption_keys.key_algorithm,
   sys.dm_database_encryption_keys.key_length
 FROM
   sys.dm_database_encryption_keys INNER JOIN sys.databases
   ON sys.dm_database_encryption_keys.database_id = sys.databases.database_id

-- Backup the encrypted database
BACKUP DATABASE MyDB TO DISK = N'C:\Demo\Backups\MyDBEncrypted.bak' 

-- Backup the certificate and its private key (protecting the private key backup with a password)
USE master
GO

BACKUP CERTIFICATE MyEncryptionCert TO FILE='C:\Demo\Backups\MyEncryptionCert.certbak'
 WITH PRIVATE KEY (
  FILE='C:\Demo\Backups\MyEncryptionCert.pkbak', 
  ENCRYPTION BY PASSWORD='[PASSWORD]')
 
-- To restore certificate and backup on another server  
USE master
GO

-- SQL08 allowed the certificate to be dropped while existing databases depended on them!
DROP DATABASE MyDB
GO

-- These two DROPs 'simulate' switching to another server
DROP CERTIFICATE MyEncryptionCert
DROP MASTER KEY

CREATE MASTER KEY ENCRYPTION BY PASSWORD = '[PASSWORD]'

CREATE CERTIFICATE MyEncryptionCert
 FROM FILE='C:\Demo\Backups\MyEncryptionCert.certbak'
 WITH PRIVATE KEY(
  FILE='C:\Demo\Backups\MyEncryptionCert.pkbak',
  DECRYPTION BY PASSWORD='[PASSWORD]')

GO

RESTORE DATABASE MyDB FROM DISK = 'C:\Demo\Backups\MyDBEncrypted.bak' WITH REPLACE

-- Cleanup
USE MyDB
GO
DROP TABLE Customer
USE master
GO
DROP DATABASE MyDB
DROP CERTIFICATE MyEncryptionCert
DROP MASTER KEY
