CREATE PROCEDURE GetOrders AS
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

ALTER DATABASE WideWorldImporters SET COMPATIBILITY_LEVEL = 140		-- SQL Server 2017
ALTER DATABASE WideWorldImporters SET COMPATIBILITY_LEVEL = 150		-- SQL Server 2019

EXEC GetOrders
