/* =================== STRING_AGG =================== */

USE MyDB
GO

CREATE TABLE Contact (
	ContactId int PRIMARY KEY,
	FirstName varchar(50),
	LastName varchar(50)
)

CREATE TABLE Email (
	EmailId int IDENTITY PRIMARY KEY,
	ContactId int,
	EmailAddress varchar(255),
	CONSTRAINT FK_Email_Contact FOREIGN KEY (ContactId) REFERENCES Contact (ContactId)
)

INSERT INTO Contact VALUES
 (1, 'John', 'Doe'),
 (2, 'Jane', 'Smith')

INSERT INTO Email VALUES
 (1, 'john.doe@gmail.com'),
 (1, 'jdoe@hotmail.com'),
 (2, 'jane.smith@outlook.com'),
 (2, 'jsmith@hotmail.com'),
 (2, 'jsm@gmail.com')

-- Old FOR XML trick:
DECLARE @EmailAddresses varchar(max) = CONVERT(varchar(max), (
	SELECT CONCAT('; ', EmailAddress)
	FROM Email
	WHERE ContactId = 2
	FOR XML PATH(''), TYPE
))
SET @EmailAddresses = RIGHT(@EmailAddresses, LEN(@EmailAddresses) - 2)
SELECT @EmailAddresses

-- Using STRING_AGG:
SELECT STRING_AGG(EmailAddress, '; ') 
FROM Email
WHERE ContactId = 2

-- Build aggregation columns of email address count and concatenated email address values
SELECT
	c.ContactId,
	c.FirstName,
	c.LastName,
	EmailAddressCount = COUNT(*),
	EmailAddresses = STRING_AGG(e.EmailAddress, '; ')
FROM
	Contact AS c
	INNER JOIN Email AS e ON e.ContactId = c.ContactId
GROUP BY
	c.ContactId,
	c.FirstName,
	c.LastName


-- Handling large strings

USE AdventureWorks2017
GO

-- Fails because some concatenated results exceed 8000 bytes
SELECT
	LastName,
	STRING_AGG(EmailAddress, '; ') AS EmailAddress
FROM
	Person.Person AS p
	INNER JOIN Person.EmailAddress AS e ON e.BusinessEntityID = p.BusinessEntityID
GROUP BY
	p.lastname 

-- Solution is to cast expression parameter as varchar(max)
SELECT
	LastName,
	STRING_AGG(CONVERT(varchar(max), EmailAddress), ', ') AS EmailAddress
FROM
	Person.Person AS p
	INNER JOIN Person.EmailAddress AS e ON e.BusinessEntityID = p.BusinessEntityID
GROUP BY
	p.lastname 

-- Sort the strings using WITHIN GROUP
SELECT
	LastName,
	STRING_AGG(CONVERT(varchar(max), EmailAddress), ', ') WITHIN GROUP (ORDER BY EmailAddress ASC) AS EmailAddress
FROM
	Person.Person AS p
	INNER JOIN Person.EmailAddress AS e ON e.BusinessEntityID = p.BusinessEntityID
GROUP BY
	p.lastname 


-- Cleanup

USE MyDB
GO

DROP TABLE IF EXISTS Email
DROP TABLE IF EXISTS Contact
