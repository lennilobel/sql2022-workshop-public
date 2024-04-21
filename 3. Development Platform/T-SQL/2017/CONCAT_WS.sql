/* =================== CONCAT_WS =================== */

DECLARE @AddressLine1 varchar(max) = '123 Main St.'
DECLARE @AddressLine2 varchar(max)
DECLARE @City varchar(max) = 'New York'
DECLARE @State varchar(max) = 'NY'
DECLARE @Zip varchar(max) = '11229'

SELECT CONCAT(@AddressLine1, @AddressLine2, @City, @State, @Zip)
SELECT CONCAT(@AddressLine1, ', ', @AddressLine2, ', ', @City, ', ', @State, ', ', @Zip)
SELECT CONCAT_WS(', ', @AddressLine1, @AddressLine2, @City, @State, @Zip)

USE AdventureWorks2017
GO

-- No concatenation
SELECT
	be.BusinessEntityID,
	p.LastName, p.FirstName, p.MiddleName,
	a.AddressLine1, a.AddressLine2, a.City, a.PostalCode
FROM
	Person.BusinessEntity AS be
	INNER JOIN Person.Person AS p ON p.BusinessEntityID = be.BusinessEntityID
	INNER JOIN Person.BusinessEntityAddress AS bea ON bea.BusinessEntityID = be.BusinessEntityID
	INNER JOIN Person.Address AS a ON a.AddressID = bea.AddressID

-- With CONCAT_WS
SELECT
	be.BusinessEntityID,
	CONCAT_WS(', ', p.LastName, p.FirstName, p.MiddleName) AS Person,
	CONCAT_WS(', ', a.AddressLine1, a.AddressLine2, a.City, a.PostalCode) AS Address
FROM
	Person.BusinessEntity AS be
	INNER JOIN Person.Person AS p ON p.BusinessEntityID = be.BusinessEntityID
	INNER JOIN Person.BusinessEntityAddress AS bea ON bea.BusinessEntityID = be.BusinessEntityID
	INNER JOIN Person.Address AS a ON a.AddressID = bea.AddressID
