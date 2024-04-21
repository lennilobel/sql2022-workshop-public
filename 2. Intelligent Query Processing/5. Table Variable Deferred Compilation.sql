USE WideWorldImportersDW
GO

-- Relies on Fact.OrderHistory table in WideWorldImportersDW
--  Execute 'Enlarge WWIDW.sql' to generate it

-- Create a stored procedure using a very large table variable
CREATE OR ALTER PROCEDURE GetOrderPrices AS
BEGIN
	DECLARE @Order table(
		[Order Key] bigint NOT NULL,
		[Quantity] int NOT NULL
	)

	INSERT INTO @Order
		SELECT TOP 1000000 [Order Key], [Quantity]		-- One million rows in a table variable!
		FROM [Fact].[OrderHistory]

	SELECT TOP 10000
		oh.[Order Key],
		oh.[Order Date Key],
		oh.[Unit Price],
		o.Quantity
	FROM
		Fact.OrderHistoryExtended AS oh
		INNER JOIN @Order AS o ON o.[Order Key] = oh.[Order Key]
	WHERE
		oh.[Unit Price] > 0.10
	ORDER BY
		oh.[Unit Price] DESC
END
GO


EXEC master.dbo.SetDbCompatLevel 'WideWorldImportersDW', 140	-- SQL Server 2017
GO

-- Takes ~ 30 sec
--   Table scan uses row mode over rowstore
--   Actual rows = 1,000,000; estimated rows = 1
--   Downstream nested loops join
--   Sort spills 15k pages to disk
--   Memory grant on SELECT = 1.6 MB
DBCC FREEPROCCACHE; DBCC DROPCLEANBUFFERS
EXEC GetOrderPrices
GO


EXEC master.dbo.SetDbCompatLevel 'WideWorldImportersDW', 150	-- SQL Server 2019
GO

-- Takes ~ 6 sec
--   Table scan uses batch mode over rowstore
--   Actual rows = 1,000,000; estimated rows = 1,000,000
--   Downstream hash match join
--   Sort doesn't spill to disk
--   Memory grant on SELECT = 176 MB
DBCC FREEPROCCACHE; DBCC DROPCLEANBUFFERS
EXEC GetOrderPrices
GO


-- *** Cleanup ***

DROP PROCEDURE IF EXISTS GetOrderPrices
GO
