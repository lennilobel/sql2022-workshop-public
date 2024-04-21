USE WideWorldImportersDW
GO


-- Create a MSTVF
CREATE OR ALTER FUNCTION Fact.WhatIfOutlierEventQuantity(@Event varchar(15), @BeginOrderDateKey date, @EndOrderDateKey date)
RETURNS
	@OutlierEventQuantity table (
		[Order Key] bigint,
		[City Key] int,
		[Customer Key] int,
		[Outlier Event Quantity] int
	)
AS
BEGIN

	IF @Event = 'Mild Recession'
		INSERT INTO @OutlierEventQuantity
		SELECT
			o.[Order Key], o.[City Key], o.[Customer Key],
			OutlierEventQuantity = CASE
				WHEN o.Quantity > 2 THEN o.Quantity * .5
				ELSE o.Quantity
			END
		FROM
			Fact.[Order] AS o
			INNER JOIN Dimension.City AS c ON c.[City Key] = o.[City Key]

	IF @Event = 'Hurricane - South Atlantic'
		INSERT INTO @OutlierEventQuantity
		SELECT
			o.[Order Key], o.[City Key], o.[Customer Key],
			OutlierEventQuantity = CASE
				WHEN o.Quantity > 10 THEN o.Quantity * .5
				ELSE o.Quantity
			END
		FROM
			Fact.[Order] AS o
			INNER JOIN Dimension.City AS c ON c.[City Key] = o.[City Key]
		WHERE
			c.[State Province] IN ('Florida', 'Georgia', 'Maryland', 'North Carolina', 'South Carolina', 'Virginia', 'West Virginia', 'Delaware')
			AND o.[Order Date Key] BETWEEN @BeginOrderDateKey AND @EndOrderDateKey

	IF @Event = 'Hurricane - East South Central'
		INSERT INTO @OutlierEventQuantity
		SELECT
			o.[Order Key], o.[City Key], o.[Customer Key],
			CASE
				WHEN o.Quantity > 50 THEN o.Quantity * .5
				ELSE o.Quantity
			END
		FROM
			Fact.[Order] AS o
			INNER JOIN Dimension.City AS c ON c.[City Key] = o.[City Key]
			INNER JOIN Dimension.[Stock Item] AS si ON si.[Stock Item Key] = o.[Stock Item Key]
		WHERE
			c.[State Province] IN ('Alabama', 'Kentucky', 'Mississippi', 'Tennessee')
			AND si.[Buying Package] = 'Carton'
			AND o.[Order Date Key] BETWEEN @BeginOrderDateKey AND @EndOrderDateKey

	RETURN
END
GO

EXEC master.dbo.SetDbCompatLevel 'WideWorldImportersDW', 130		-- SQL Server 2016
GO

-- Run query against MSTVF
--  Table scan shows estimated 100 rows, actual 231,412; hash match has spillover warning; downstream nested loops est 11 rows, actual 26,098
DBCC FREEPROCCACHE; DBCC DROPCLEANBUFFERS
SELECT
	*
FROM
	Fact.[Order] AS fo
	INNER JOIN
	  Fact.WhatIfOutlierEventQuantity('Mild Recession', '2013-01-01', '2014-10-15') AS tvf
	  ON fo.[Order Key] = tvf.[Order Key] AND fo.[City Key] = tvf.[City Key] AND fo.[Customer Key] = tvf.[Customer Key]
	INNER JOIN
	  Dimension.[Stock Item] AS si ON fo.[Stock Item Key] = si.[Stock Item Key]
WHERE
	fo.Quantity > 100


EXEC master.dbo.SetDbCompatLevel 'WideWorldImportersDW', 140		-- SQL Server 2017
GO

-- Run same query
--  Table scan shows estimated 231,412 rows, actual 231,412; no spillover warning on first hash match; downstream hash match est 26,030 rows, actual 26,098
DBCC FREEPROCCACHE; DBCC DROPCLEANBUFFERS
SELECT
	*
FROM
	Fact.[Order] AS fo
	INNER JOIN
	  Fact.WhatIfOutlierEventQuantity('Mild Recession', '2013-01-01', '2014-10-15') AS tvf
	  ON fo.[Order Key] = tvf.[Order Key] AND fo.[City Key] = tvf.[City Key] AND fo.[Customer Key] = tvf.[Customer Key]
	INNER JOIN
	  Dimension.[Stock Item] AS si ON fo.[Stock Item Key] = si.[Stock Item Key]
WHERE
	fo.Quantity > 100


-- Cleanup

DROP FUNCTION Fact.WhatIfOutlierEventQuantity
