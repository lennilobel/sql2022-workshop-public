-- *** Configure PolyBase to use Azure blob storage ***

USE MyDB
GO

-- Verify PolyBase is installed
SELECT SERVERPROPERTY ('IsPolyBaseInstalled') AS IsPolyBaseInstalled

-- Enable PolyBase
EXEC sp_configure @configname = 'polybase enabled', @configvalue = 1
RECONFIGURE
GO

-- All the external data source credentials will be encrypted by this master key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '[PASSWORD]'
