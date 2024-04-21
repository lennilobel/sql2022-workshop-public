CREATE OR ALTER PROCEDURE GetOrderPrices AS
BEGIN
	DECLARE @Order table(
		[Order Key] bigint NOT NULL,
		[Quantity] int NOT NULL	)

	INSERT INTO @Order
		SELECT TOP 1000000 [Order Key], [Quantity]		-- One million rows in a table variable!
		FROM [Fact].[OrderHistory]

	SELECT TOP 10000
		oh.[Order Key], oh.[Order Date Key], oh.[Unit Price], o.Quantity
	FROM
		Fact.OrderHistoryExtended AS oh
		INNER JOIN @Order AS o ON o.[Order Key] = oh.[Order Key]
	WHERE
		oh.[Unit Price] > 0.10
	ORDER BY
		oh.[Unit Price] DESC
END
GO

ALTER DATABASE WideWorldImportersDW SET COMPATIBILITY_LEVEL = 140		-- SQL Server 2017
ALTER DATABASE WideWorldImportersDW SET COMPATIBILITY_LEVEL = 150		-- SQL Server 2019

EXEC GetOrderPrices
