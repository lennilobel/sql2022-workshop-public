USE AdventureWorks2017
GO

-- Relies on bigTransactionHistory table in AdventureWorks2017
--  Execute 'Enlarge AdventureWorks.sql' to generate them

EXEC master.dbo.SetDbCompatLevel 'AdventureWorks2017', 140		-- 2017
EXEC master.dbo.SetDbCompatLevel 'AdventureWorks2017', 150		-- 2019

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
