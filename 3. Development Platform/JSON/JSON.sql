/* =================== JSON in SQL Server 2016 =================== */

USE AdventureWorks2019
GO

-- ***********************
-- *** Generating JSON ***
-- ***********************

/*** FOR JSON AUTO ***/

-- Relational
SELECT
	Customer.CustomerID,
	Customer.AccountNumber,
	SalesOrder.SalesOrderID,
	SalesOrder.OrderDate
 FROM
	Sales.Customer AS Customer
	INNER JOIN Sales.SalesOrderHeader AS SalesOrder ON SalesOrder.CustomerID = Customer.CustomerID
 WHERE
	Customer.CustomerID BETWEEN 11001 AND 11003
 ORDER BY
	Customer.CustomerID

-- FOR JSON AUTO
SELECT
	Customer.CustomerID,
	Customer.AccountNumber,
	SalesOrder.SalesOrderID,
	SalesOrder.OrderDate
 FROM
	Sales.Customer AS Customer
	INNER JOIN Sales.SalesOrderHeader AS SalesOrder ON SalesOrder.CustomerID = Customer.CustomerID
 WHERE
	Customer.CustomerID BETWEEN 11001 AND 11003
 ORDER BY
	Customer.CustomerID
 FOR JSON AUTO

-- FOR JSON AUTO, ROOT
SELECT
	Customer.CustomerID,
	Customer.AccountNumber,
	SalesOrder.SalesOrderID,
	SalesOrder.OrderDate
 FROM
	Sales.Customer AS Customer
	INNER JOIN Sales.SalesOrderHeader AS SalesOrder ON SalesOrder.CustomerID = Customer.CustomerID
 WHERE
	Customer.CustomerID BETWEEN 11001 AND 11003
 ORDER BY
	Customer.CustomerID
 FOR JSON AUTO, ROOT

-- FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER
SELECT
	Customer.CustomerID,
	Customer.AccountNumber,
	SalesOrder.SalesOrderID,
	SalesOrder.OrderDate
 FROM
	Sales.Customer AS Customer
	INNER JOIN Sales.SalesOrderHeader AS SalesOrder ON SalesOrder.CustomerID = Customer.CustomerID
 WHERE
	Customer.CustomerID = 11003
 ORDER BY
	Customer.CustomerID
 FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER


/*** Storing JSON to variable ***/

-- FOR JSON to an NVARCHAR variable
DECLARE @JsonData AS nvarchar(max)
SET @JsonData =
(
	SELECT
		Customer.CustomerID,
		Customer.AccountNumber,
		SalesOrder.SalesOrderID,
		SalesOrder.OrderDate
	 FROM
		Sales.Customer AS Customer
		INNER JOIN Sales.SalesOrderHeader AS SalesOrder ON SalesOrder.CustomerID = Customer.CustomerID
	 WHERE
		Customer.CustomerID BETWEEN 11001 AND 11003
	 ORDER BY
		Customer.CustomerID
	 FOR JSON AUTO
)
SELECT @JsonData
GO


/*** Nested FOR JSON queries ***/

-- FOR JSON nested in another SELECT
SELECT 
	CustomerID,
	AccountNumber,
	(SELECT SalesOrderID, TotalDue, OrderDate, ShipDate
	  FROM Sales.SalesOrderHeader AS SalesOrder
	  WHERE CustomerID = Customer.CustomerID 
	  FOR JSON AUTO) AS SalesOrders
 FROM
	Sales.Customer AS Customer
 WHERE
	Customer.CustomerID BETWEEN 11001 AND 11003
 ORDER BY
	Customer.CustomerID


/*** FOR JSON PATH ***/

-- FOR JSON PATH (simple example)
SELECT
	Customer.CustomerID,
	Customer.AccountNumber,
	SalesOrder.SalesOrderID,
	SalesOrder.OrderDate
 FROM
	Sales.Customer AS Customer
	INNER JOIN Sales.SalesOrderHeader AS SalesOrder ON SalesOrder.CustomerID = Customer.CustomerID
 WHERE
	Customer.CustomerID BETWEEN 11001 AND 11003
 ORDER BY
	Customer.CustomerID
 FOR JSON PATH

-- FOR JSON PATH (nested example)
SELECT 
	CustomerID,
	AccountNumber,
	Contact.FirstName AS [Name.First],
	Contact.LastName AS [Name.Last],
	(SELECT SalesOrderID,
			TotalDue,
			OrderDate, 
			ShipDate,
			(SELECT ProductID, 
					OrderQty, 
					LineTotal
			  FROM Sales.SalesOrderDetail
			  WHERE SalesOrderID = OrderHeader.SalesOrderID
			  FOR JSON PATH) AS OrderDetail
	  FROM Sales.SalesOrderHeader AS OrderHeader
	  WHERE CustomerID = Customer.CustomerID 
	  FOR JSON PATH) AS OrderHeader
 FROM
	Sales.Customer AS Customer
	INNER JOIN Person.Person AS Contact ON Contact.BusinessEntityID = Customer.PersonID
 WHERE
	CustomerID BETWEEN 11001 AND 11002
 FOR JSON PATH

-- Same using JSON AUTO with traditional JOINs doesn't let you control hierarchical nesting (always one perjoin)
SELECT 
	Customer.CustomerID,
	Customer.AccountNumber,
	Contact.FirstName AS [Name.First],
	Contact.LastName AS [Name.Last],
	OrderHeader.SalesOrderID,
	OrderHeader.TotalDue,
	OrderHeader.OrderDate, 
	OrderHeader.ShipDate,
	OrderDetail.ProductID, 
	OrderDetail.OrderQty, 
	OrderDetail.LineTotal
 FROM
	Sales.Customer AS Customer
	INNER JOIN Person.Person AS Contact ON Contact.BusinessEntityID = Customer.PersonID
    INNER JOIN Sales.SalesOrderHeader AS OrderHeader ON OrderHeader.CustomerID = Customer.CustomerID
	INNER JOIN Sales.SalesOrderDetail AS OrderDetail ON OrderDetail.SalesOrderID = OrderHeader.SalesOrderID
 WHERE
	Customer.CustomerID BETWEEN 11001 AND 11002
 FOR JSON AUTO

-- *********************************
-- *** Storing and Querying JSON ***
-- *********************************

USE MyDB
GO

/*** ISJSON ***/

DECLARE @JsonData AS nvarchar(max) = N'
[
	{
		"OrderId": 5,
		"CustomerId: 6,
		"OrderDate": "2015-10-10T14:22:27.25-05:00",
		"OrderAmount": 25.9
	},
	{
		"OrderId": 29,
		"CustomerId": 76,
		"OrderDate": "2015-12-10T11:02:36.12-08:00",
		"OrderAmount": 350.25
	}
]'

SELECT ISJSON(@JsonData)	-- Returns false because of missing closing quote on CustomerId property
GO


/*** Store JSON orders data in a table ***/

DROP TABLE IF EXISTS OrdersJson

CREATE TABLE OrdersJson(
 	OrdersId int PRIMARY KEY, 
	OrdersDoc varchar(max) NOT NULL DEFAULT '[]',
    CONSTRAINT CK_OrdersJson_OrdersDoc CHECK (ISJSON(OrdersDoc) = 1)
)

DECLARE @JsonData AS varchar(max) = '
[
	{
		"OrderId": 5,
		"CustomerId: 6,
		"OrderDate": "2015-10-10T14:22:27.25-05:00",
		"OrderAmount": 25.9
	},
	{
		"OrderId": 29,
		"CustomerId": 76,
		"OrderDate": "2015-12-10T11:02:36.12-08:00",
		"OrderAmount": 350.25
	}
]'

INSERT INTO OrdersJson(OrdersId, OrdersDoc) VALUES (1, @JsonData)	-- Fails because of missing closing quote on CustomerId property

INSERT INTO OrdersJson(OrdersId) VALUES (2)	-- Accepts default empty array

SELECT * FROM OrdersJson

UPDATE OrdersJson SET OrdersDoc = JSON_MODIFY(OrdersDoc, '$[1].OrderAmount', 999) WHERE OrdersId = 1

SELECT * FROM OrdersJson


/*** Store JSON book data in a table for querying ***/

CREATE TABLE BooksJson(
 	BookId int PRIMARY KEY, 
	BookDoc varchar(max) NOT NULL,
    CONSTRAINT CK_BooksJson_BookDoc CHECK (ISJSON(BookDoc) = 1)
)

INSERT INTO BooksJson VALUES (1, '
	{
		"category": "ITPro",
		"title": "Programming SQL Server",
		"author": "Lenni Lobel",
		"price": {
			"amount": 49.99,
			"currency": "USD"
		},
		"purchaseSites": [
			"amazon.com",
			"booksonline.com"
		]
	}
')

INSERT INTO BooksJson VALUES (2, '
	{
		"category": "Developer",
		"title": "Developing ADO .NET",
		"author": "Andrew Brust",
		"price": {
			"amount": 39.93,
			"currency": "USD"
		},
		"purchaseSites": [
			"booksonline.com"
		]
	}
')

INSERT INTO BooksJson VALUES (3, '
	{
		"category": "ITPro",
		"title": "Windows Cluster Server",
		"author": "Stephen Forte",
		"price": {
			"amount": 59.99,
			"currency": "CAD"
		},
		"purchaseSites": [
			"amazon.com"
		]
	}
')

SELECT * FROM BooksJson


/*** JSON_VALUE ***/

-- Get all ITPro books
SELECT *
 FROM BooksJson
 WHERE JSON_VALUE(BookDoc, '$.category') = 'ITPro'

-- Index the category property
ALTER TABLE BooksJson
 ADD BookCategory AS JSON_VALUE(BookDoc, '$.category')

CREATE INDEX IX_BooksJson_BookCategory
 ON BooksJson(BookCategory)

SELECT *
 FROM BooksJson
 WHERE BookCategory = 'ITPro'

-- Extract other properties
SELECT
	BookId,
	JSON_VALUE(BookDoc, '$.category') AS Category,
	JSON_VALUE(BookDoc, '$.title') AS Title,
	JSON_VALUE(BookDoc, '$.price.amount') AS PriceAmount,
	JSON_VALUE(BookDoc, '$.price.currency') AS PriceCurrency
 FROM
	BooksJson


/*** JSON_QUERY ***/

SELECT
	BookId,
	JSON_VALUE(BookDoc, '$.category') AS Category,
	JSON_VALUE(BookDoc, '$.title') AS Title,
	JSON_VALUE(BookDoc, '$.price.amount') AS PriceAmount,
	JSON_VALUE(BookDoc, '$.price.currency') AS PriceCurrency,
	JSON_QUERY(BookDoc, '$.purchaseSites') AS PurchaseSites
 FROM
	BooksJson

-- Cleanup
DROP TABLE BooksJson
GO


-- **********************
-- *** Using OPENJSON ***
-- **********************

/*** OPENJSON (simple example) ***/

-- Store books as JSON array
DECLARE @BooksJson varchar(max) = '
[
  {
    "category": "ITPro",
    "title": "Programming SQL Server",
    "author": "Lenni Lobel",
    "price": 49.99
  },
  {
    "category": "Developer",
    "title": "Developing ADO .NET",
    "author": "Andrew Brust",
    "price": 39.93
  },
  {
    "category": "ITPro",
    "title": "Windows Cluster Server",
    "author": "Stephen Forte",
    "price": 59.99
  }
]
'

-- Shred the JSON array into multiple rows
SELECT * FROM OPENJSON(@BooksJson)

-- Shred the JSON array into multiple rows with filtering and sorting
SELECT *
 FROM		OPENJSON(@BooksJson, '$') AS b
 WHERE		JSON_VALUE(b.value, '$.category') = 'ITPro'
 ORDER BY	JSON_VALUE(b.value, '$.author') DESC
	
-- Shred the properties of the first object in the JSON array into multiple rows
SELECT *
 FROM		OPENJSON(@BooksJson, '$[0]')

--	0 = null
--	1 = string
--	2 = int
--	3 = bool
--	4 = array
--  5 = object


/*** OPENJSON (parent/child example) ***/

-- Store a person with multiple contacts as JSON object
DECLARE @PersonJson varchar(max) = '
	{
		"Id": 236,
		"Name": {
			"FirstName": "John",
			"LastName": "Doe"
		},
		"Address": {
			"AddressLine": "137 Madison Ave",
			"City": "New York",
			"Province": "NY",
			"PostalCode": "10018"
		},
		"Contacts": [
			{
				"Type": "mobile",
				"Number": "917-777-1234"
			},
			{
				"Type": "home",
				"Number": "212-631-1234"
			},
			{
				"Type": "work",
				"Number": "212-635-2234"
			},
			{
				"Type": "fax",
				"Number": "212-635-2238"
			}
		]
	}
'

-- The header values can be extracted directly from the JSON source
SELECT
	PersonId		= JSON_VALUE(@PersonJson, '$.Id'),
	FirstName		= JSON_VALUE(@PersonJson, '$.Name.FirstName'),
	LastName		= JSON_VALUE(@PersonJson, '$.Name.LastName'),
	AddressLine		= JSON_VALUE(@PersonJson, '$.Address.AddressLine'),
	City			= JSON_VALUE(@PersonJson, '$.Address.City'),
	Province		= JSON_VALUE(@PersonJson, '$.Address.Province'),
	PostalCode		= JSON_VALUE(@PersonJson, '$.Address.PostalCode')

-- To produce multiple child rows for each contact, use OPENJSON
SELECT
	PersonId		= JSON_VALUE(@PersonJson, '$.Id'),	-- FK
	ContactType		= JSON_VALUE(c.value, '$.Type'),
	ContactNumber	= JSON_VALUE(c.value, '$.Number')
 FROM
	OPENJSON(@PersonJson, '$.Contacts') AS c


/*** OPENJSON (with schema) ***/

-- Store a batch of orders in JSON
DECLARE @OrdersJson Nvarchar(max) = '
{
  "BatchId": 442,
  "Orders": [
    {
      "OrderNumber": "SO43659",
      "OrderDate": "2011-05-31T00:00:00",
      "AccountNumber": "AW29825",
      "Item": {
        "Quantity": 1,
        "Price": 2024.9940
      }
    },
    {
      "OrderNumber": "SO43661",
      "OrderDate": "2011-06-01T00:00:00",
      "AccountNumber": "AW73565",
      "Item": {
        "Quantity": 3,
        "Price": 2024.9940
      }
    }
  ]
}
'

-- Query with default schema
SELECT *
 FROM OPENJSON (@OrdersJson, '$.Orders')

-- Query with explicit schema
SELECT *
 FROM OPENJSON (@OrdersJson, '$.Orders')
 WITH ( 
	OrderNumber	varchar(200),
	OrderDate	datetime,
	Customer	varchar(200)    '$.AccountNumber',
	Item		nvarchar(max)	'$.Item' AS JSON,
	Quantity	int				'$.Item.Quantity',
	Price		money			'$.Item.Price'
) 


/* =================== JSON in SQL Server 2022 =================== */

/*** Testing for properties with the JSON_PATH_EXISTS function ***/

DECLARE @JsonData AS varchar(max) = '
	{
		"OrderId": 5,
		"CustomerId": 6,
		"OrderDate": "2015-10-10T14:22:27.25-05:00",
		"OrderAmount": 25.9
	}
'

SELECT
	JSON_PATH_EXISTS(@JsonData, '$.CustomerId')	AS '$.CustomerId',
	JSON_PATH_EXISTS(@JsonData, '$.Discount')	AS '$.Discount'

GO

DECLARE @JsonData AS varchar(max) = '
[
	{
		"OrderId": 5,
		"CustomerId": 6,
		"OrderDate": "2015-10-10T14:22:27.25-05:00",
		"OrderAmount": 25.9
	},
	{
		"OrderId": 29,
		"CustomerId": 76,
		"OrderDate": "2015-12-10T11:02:36.12-08:00",
		"OrderAmount": 350.25,
		"Discount": 0.1
	}
]'

SELECT
	JSON_PATH_EXISTS(@JsonData, '$[0].CustomerId')	AS '$[0].CustomerId',	-- 1 | First object has CustomerId property
	JSON_PATH_EXISTS(@JsonData, '$[0].Discount')	AS '$[0].Discount',		-- 0 | First object has no Discount property
	JSON_PATH_EXISTS(@JsonData, '$[1].CustomerId')	AS '$[1].CustomerId',	-- 1 | Second object has CustomerId property
	JSON_PATH_EXISTS(@JsonData, '$[1].Discount')	AS '$[1].Discount',		-- 1 | Second object has Discount property
	JSON_PATH_EXISTS(@JsonData, '$[2].CustomerId')	AS '$[2].CustomerId'	-- 0 | There is no third object

GO


/*** Testing for valid JSON object versus array with the enhanced ISJSON function ***/

DECLARE @JsonObject AS varchar(max) = '{ "Color": "Red" }'
DECLARE @JsonArray AS varchar(max) = '[{ "Color": "Red", "Color": "Blue"}]'

SELECT
	IsObjectAValue		= ISJSON(@JsonObject, VALUE),
	IsObjectAnObject	= ISJSON(@JsonObject, OBJECT),
	IsObjectAnArray		= ISJSON(@JsonObject, ARRAY),
	IsArrayAValue		= ISJSON(@JsonArray, VALUE),
	IsArrayAnObject		= ISJSON(@JsonArray, OBJECT),
	IsArrayAnArray		= ISJSON(@JsonArray, ARRAY)

GO


/*** Constructing JSON with the JSON_OBJECT and JSON_ARRAY functions ***/

USE MyDB
GO

DROP TABLE IF EXISTS Customer

CREATE TABLE Customer (
	CustomerId int IDENTITY PRIMARY KEY,
	FirstName varchar(50) NOT NULL,
	LastName varchar(50) NOT NULL,
	Ranking varchar(10) NULL,
	IsTopTier bit NULL,
	Phone1 varchar(20) NULL,
	Phone2 varchar(20) NULL,
	Phone3 varchar(20) NULL
)

INSERT INTO Customer
 (FirstName,	LastName,		Ranking,	IsTopTier,	Phone1,			Phone2,			Phone3) VALUES
 ('Ken',		'Sanchez',		'Platinum',	1,			'123-456-7890',	NULL,			NULL),
 ('Terri',		'Duffy',		'',			0,			'123-456-7890',	'234-567-8901',	'345-678-9012'),
 ('Roberto',	'Tamburello',	NULL,		1,			NULL,			'234-567-8901',	NULL),
 ('Rob',		'Walters',		'Silver',	NULL,		'123-456-7890',	'234-567-8901',	NULL),
 ('Gail',		'Erickson',		'Gold',		1,			'123-456-7890',	'234-567-8901',	'345-678-9012')

-- Use JSON_OBJECT to construct a valid JSON object
SELECT
    CustomerId,
	JSON_OBJECT(
		'firstName': FirstName,
		'lastName': LastName,
		'ranking': Ranking,
		'isTopTier': IsTopTier
	) AS JsonObject
FROM
	Customer
ORDER BY
	CustomerId

-- Before 2022, we had to use string concatenation...
SELECT
    CustomerId,
	CONCAT('
        {
            "firstName": "', FirstName, '",
            "lastName": "', LastName, '",
            "ranking": "', Ranking, '",
            "isTopTier": ', IsTopTier, '
        }
	') AS JsonObject
FROM
	Customer
ORDER BY
	CustomerId

-- But is it valid and accurate?
SELECT
    CustomerId,
	ISJSON(CONCAT('
		{
			"firstName": "', FirstName, '",
			"lastName": "', LastName, '",
			"ranking": "', Ranking, '",
			"isTopTier": ', IsTopTier, '
		}
	')) AS IsValidJsonObject
FROM
	Customer
ORDER BY
	CustomerId

-- Extra measures are required with string concatenation to achieve 100% validity and accuracy (nulls, booleans, escaped values, date/time formats, etc)
SELECT
    CustomerId,
	CONCAT('
        {
            "firstName": "', FirstName, '",
            "lastName": "', LastName, '",
            "ranking": ', IIF(Ranking IS NULL, 'null', CONCAT('"', Ranking, '"')), ',
            "isTopTier": ', CASE WHEN IsTopTier IS NULL THEN 'null' WHEN IsTopTier = 0 THEN 'false' ELSE 'true' END, '
        }
	') AS JsonObject
FROM
	Customer
ORDER BY
	CustomerId

-- Now it's valid and accurate (but still carries unneeded whitespace)
SELECT
    CustomerId,
	ISJSON(CONCAT('
		{
			"firstName": "', FirstName, '",
			"lastName": "', LastName, '",
			"ranking": ', IIF(Ranking IS NULL, 'null', CONCAT('"', Ranking, '"')), ',
			"isTopTier": ', CASE WHEN IsTopTier IS NULL THEN 'null' WHEN IsTopTier = 0 THEN 'false' ELSE 'true' END, '
		}
	')) AS IsValidJsonObject
FROM
	Customer
ORDER BY
	CustomerId

-- Use JSON_ARRAY to construct a valid JSON array
SELECT
    CustomerId,
	FirstName,
	LastName,
	JSON_ARRAY(
		Ranking,
		IsTopTier
			NULL ON NULL		-- default is ABSENT ON NULL
	) AS Tier
FROM
	Customer
ORDER BY
	CustomerId

-- Can nest JSON_ARRAY or JSON_OBJECT functions
SELECT
    CustomerId,
	JSON_OBJECT(
		'firstName': FirstName,
		'lastName': LastName,
		'tier': JSON_ARRAY(
			Ranking,
			IsTopTier
				NULL ON NULL		-- default is ABSENT ON NULL
		)
	) AS JsonObject
FROM
	Customer
ORDER BY
	CustomerId

-- Create variable-length phone numbers array
SELECT
    CustomerId,
	JSON_OBJECT(
		'firstName': FirstName,
		'lastName': LastName,
		'tier': JSON_ARRAY(
			Ranking,
			IsTopTier
				NULL ON NULL		-- default is ABSENT ON NULL
		)
	) AS JsonObject,
	JSON_ARRAY (
		Phone1,
		Phone2,
		Phone3
	) AS JsonArray
FROM
	Customer
ORDER BY
	CustomerId


-- Cleanup
DROP TABLE IF EXISTS OrdersJson
DROP TABLE IF EXISTS BooksJson
DROP TABLE IF EXISTS Customer
