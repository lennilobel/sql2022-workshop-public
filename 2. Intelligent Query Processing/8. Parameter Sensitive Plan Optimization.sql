--USE WideWorldImporters
--GO

---- https://www.youtube.com/watch?v=wmdamh7Gjgc

--CREATE OR ALTER PROCEDURE Warehouse.GetStockItemsBySupplier @SupplierID int
--AS
--BEGIN

--	SELECT StockItemID
--	FROM Warehouse.StockItems AS s
--	WHERE SupplierID = @SupplierID
--	ORDER BY StockItemName

--END

--GO

--ALTER DATABASE SCOPED CONFIGURATION CLEAR PROCEDURE_CACHE
--GO

--EXEC Warehouse.GetStockItemsBySupplier @SupplierID = 2
--GO

--EXEC Warehouse.GetStockItemsBySupplier @SupplierID = 4
--GO

ALTER DATABASE CURRENT SET COMPATIBILITY_LEVEL = 150;

GO

DECLARE @BatchCount int = 5000
DECLARE @BatchRowCount int = 1000

DECLARE @BatchCounter int = 1
WHILE @BatchCounter <= @BatchCount BEGIN
	DECLARE @BatchRowCounter int = 1
	DECLARE @BatchSql nvarchar(max) = 'INSERT INTO Warehouse.StockItems (StockItemName, SupplierID, UnitPackageID, OuterPackageID, LeadTimeDays, QuantityPerOuter, IsChillerStock, TaxRate, UnitPrice, TypicalWeightPerUnit, LastEditedBy) VALUES'
	WHILE @BatchRowCounter <= @BatchRowCount BEGIN
		SET @BatchSql = CONCAT(@BatchSql, CHAR(10), ' (''Dummy Item ', @BatchCounter, '-', @BatchRowCounter, ''', 4, 7, 7, 14, 1, 0, 15, 25, .3, 1)')
		IF @BatchRowCounter < @BatchRowCount SET @BatchSql = CONCAT(@BatchSql, ',')
		SET @BatchRowCounter += 1
	END
	PRINT @BatchSql
	EXEC sp_executesql @BatchSql
	SET @BatchCounter += 1
END


PRINT @BatchSql

--SELECT StockItemName, SupplierID, UnitPackageID, OuterPackageID, LeadTimeDays, QuantityPerOuter, IsChillerStock, TaxRate, UnitPrice, TypicalWeightPerUnit, LastEditedBy FROM Warehouse.StockItems
