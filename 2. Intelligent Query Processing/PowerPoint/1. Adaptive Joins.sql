ALTER DATABASE AdventureWorks2017 SET COMPATIBILITY_LEVEL = 130		-- SQL Server 2016
ALTER DATABASE AdventureWorks2017 SET COMPATIBILITY_LEVEL = 140		-- SQL Server 2017

DECLARE @Quantity int = 1		-- Returns 24,975 rows

SELECT p.Name, COUNT(th.ProductID) AS Count
  FROM bigTransactionHistory AS th INNER JOIN bigProduct AS p ON p.ProductID = th.ProductID
  WHERE th.Quantity = @Quantity
  GROUP BY p.Name
GO

DECLARE @Quantity int = 9726	-- Returns 3 rows

SELECT p.Name, COUNT(th.ProductID) AS Count
  FROM bigTransactionHistory AS th INNER JOIN bigProduct AS p ON p.ProductID = th.ProductID
  WHERE th.Quantity = @Quantity
  GROUP BY p.Name
