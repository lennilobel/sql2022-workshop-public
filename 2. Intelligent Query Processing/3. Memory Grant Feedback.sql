USE WideWorldImporters
GO

-- Create a simple stored procedure
CREATE OR ALTER PROCEDURE GetOrders AS
BEGIN
	SELECT 
		oh.CustomerID,
		oh.CustomerPurchaseOrderNumber,
		od.Quantity,
		od.UnitPrice
	FROM
		Sales.Orders oh
		INNER JOIN Sales.OrderLines od ON oh.OrderID = od.OrderID
	ORDER BY
		oh.Comments
END

EXEC master.dbo.SetDbCompatLevel 'WideWorldImporters', 140		-- SQL Server 2017
GO

EXEC GetOrders
-- Run it three times; observe MemoryGrantInfo on SELECT operation each time:
--  required = 5 MB; granted = 373 MB


EXEC master.dbo.SetDbCompatLevel 'WideWorldImporters', 150		-- SQL Server 2019
GO

EXEC GetOrders
-- Run it three times; observe MemoryGrantInfo on SELECT operation:
--  first time:  required = 5 MB; granted = 417 MB; LastRequestedMemory:   0 MB; IsMemoryGrandFeedbackAdjusted: NoFirstExecution
--  second time: required = 5 MB; granted =  12 MB; LastRequestedMemory: 417 MB; IsMemoryGrandFeedbackAdjusted: YesAdjusting
--  third time:  required = 512K; granted =  12 MB; LastRequestedMemory:  12 MB; IsMemoryGrandFeedbackAdjusted: YesStable

-- Preceding stream operation is *row* mode


-- Cleanup
DROP PROCEDURE IF EXISTS GetOrders
