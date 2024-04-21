USE AdventureWorks2017
GO

-- Relies on bigProduct and bigTransactionHistory tables in AdventureWorks2017
--  Execute 'Enlarge AdventureWorks.sql' to generate them


-- Add a FEW transaction history rows with quantity 9726
INSERT INTO bigTransactionHistory
	(TransactionID, ProductID, TransactionDate, Quantity, ActualCost)
 VALUES
	(-1, 1359, GETDATE(), 9726, 42.2),
	(-2, 1003, GETDATE(), 9726, 109.4),
	(-3, 1417, GETDATE(), 9726, 60.8)
GO

-- Run queries as SQL Server 2016, 2017, 2019
EXEC master.dbo.SetDbCompatLevel 'AdventureWorks2017', 130		-- 2016
EXEC master.dbo.SetDbCompatLevel 'AdventureWorks2017', 140		-- 2017


-- *** Show actual execution plan ***

-- Return three rows
DBCC FREEPROCCACHE; DBCC DROPCLEANBUFFERS
DECLARE @Quantity int = 9726
SELECT
	p.Name,
	COUNT(th.ProductID) AS Count
FROM
	bigTransactionHistory AS th
	INNER JOIN bigProduct AS p ON p.ProductID = th.ProductID
WHERE
	th.Quantity = @Quantity
GROUP BY
	p.Name
GO

-- Return multiple rows
DBCC FREEPROCCACHE; DBCC DROPCLEANBUFFERS
DECLARE @Quantity int = 1
SELECT
	p.Name,
	COUNT(th.ProductID) AS Count
FROM
	bigTransactionHistory AS th
	INNER JOIN bigProduct AS p ON p.ProductID = th.ProductID
WHERE
	th.Quantity = @Quantity
GROUP BY
	p.Name

-- In SQL Server 2016, it's always a hash match
-- In SQL Server 2017, it's an adaptive join (row mode on rowstore)

-- Cleanup
DELETE FROM dbo.bigTransactionHistory WHERE TransactionId < 0
