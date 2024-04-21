ALTER DATABASE AdventureWorks2017 SET COMPATIBILITY_LEVEL = 140		-- SQL Server 2017
ALTER DATABASE AdventureWorks2017 SET COMPATIBILITY_LEVEL = 150		-- SQL Server 2019

SELECT
	p.ProductID,
	p.Name,
	ProductCount = COUNT(p.ProductId),
	TotalQuantity = SUM(th.Quantity)
FROM
	bigTransactionHistory AS th
	INNER JOIN bigProduct AS p ON p.ProductID = th.ProductID
GROUP BY
	p.ProductID,
	p.Name
ORDER BY
	p.ProductID
