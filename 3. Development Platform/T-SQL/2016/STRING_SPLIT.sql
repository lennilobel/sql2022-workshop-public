/* =================== STRING_SPLIT =================== */

USE MyDB
GO

-- Simple split
SELECT value FROM STRING_SPLIT('Larry,Moe,Curly', ',')

-- Separator must be single non-NULL character
SELECT value FROM STRING_SPLIT('Larry, Moe, Curly', ', ')
SELECT value FROM STRING_SPLIT('Larry, Moe, Curly', NULL)

-- Use LTRIM to ignore spaces following separator character
SELECT
	value, DATALENGTH(value),
	LTRIM(value), DATALENGTH(LTRIM(value))
FROM
	STRING_SPLIT('Larry, Moe, Curly', ',')

-- Combine STRING_SPLIT with WHERE, ORDER
SELECT value
FROM STRING_SPLIT('Larry,Moe,Curly', ',')
WHERE LEFT(value, 1) <> 'L'
ORDER BY value

-- Cannot utilize alias in WHERE, ORDER
SELECT value AS Stooge
FROM STRING_SPLIT('Larry,Moe,Curly', ',')
WHERE LEFT(Stooge, 1) <> 'L'
ORDER BY Stooge

-- Use CTE as workaround to utilize alias in WHERE, ORDER
;WITH StoogeCte AS (
	SELECT value AS Stooge
	FROM STRING_SPLIT('Larry,Moe,Curly', ',')
)
SELECT Stooge FROM StoogeCte
WHERE LEFT(Stooge, 1) <> 'L'
ORDER BY Stooge

-- With JOIN
GO
USE MyDB
GO

CREATE OR ALTER PROCEDURE DoSomethingWithTheseRecords(@Ids varchar(max))
 AS
BEGIN

	-- This example uses a SELECT, but it could just as easily be
	-- an UPDATE or DELETE against the CTE wrapping STRING_SPLIT
	WITH IdsCte AS (
		SELECT TRY_CONVERT(int, value) AS ID
		FROM STRING_SPLIT(@Ids, ',')
	)
	SELECT
		p.BusinessEntityID,
		p.FirstName,
		p.LastName
	FROM
		AdventureWorks2017.Person.Person AS p
		INNER JOIN IdsCte AS i ON i.ID = p.BusinessEntityID

END

EXEC DoSomethingWithTheseRecords '6,12,X,18'	-- Invalid integer X is ignored because of TRY_CONVERT
GO

-- Cleanup
DROP PROCEDURE IF EXISTS DoSomethingWithTheseRecords
