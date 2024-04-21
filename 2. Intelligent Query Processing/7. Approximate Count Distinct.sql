USE WideWorldImportersDW
GO

-- Relies on Fact.OrderHistoryExtended table in WideWorldImportersDW
--  Execute 'Enlarge WWIDW.sql' to generate it


-- APPROX_COUNT_DISTINCT function
--  Accurate within up to 2% error rate and 97% probability

EXEC master.dbo.SetDbCompatLevel 'WideWorldImportersDW', 150		-- 2019

-- 29,620,736 rows
DBCC FREEPROCCACHE; DBCC DROPCLEANBUFFERS
SELECT COUNT(*) FROM Fact.OrderHistoryExtended


-- Get ACCURATE distinct counts with COUNT(DISTINCT)
--
--	Duration		~ 17 sec
--	Exact count		29,620,736
--	Memory grant	1.9 GB (high)

DBCC FREEPROCCACHE; DBCC DROPCLEANBUFFERS
SELECT COUNT(DISTINCT [WWI Order ID]) AS ExactCount FROM Fact.OrderHistoryExtended
 OPTION (USE HINT('DISALLOW_BATCH_MODE'), RECOMPILE)

-- Get ESTIMATED distinct counts with APPROX_COUNT_DISTINCT()
--
--	Duration		~ 10 sec
--	Approx count	30,382,637
--	Memory grant 	136 K (low)

DBCC FREEPROCCACHE; DBCC DROPCLEANBUFFERS
SELECT APPROX_COUNT_DISTINCT([WWI Order ID]) AS ApproxCount FROM Fact.OrderHistoryExtended
 OPTION (USE HINT('DISALLOW_BATCH_MODE'), RECOMPILE)
