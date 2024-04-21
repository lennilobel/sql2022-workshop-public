-- XML

USE MyDB
GO


-- *********************************
-- ********* XML Data Type *********
-- *********************************

-- Basic XML data type column
CREATE TABLE OrdersXML(
 	OrdersId int PRIMARY KEY, 
	OrdersDoc xml NOT NULL DEFAULT '<Orders />')
GO

DECLARE @xmlData AS xml
SET @xmlData = '
<Orders>
	<Order>
		<OrderId>5</OrderId>
		<CustomerId>6.0</CustomerID>
		<OrderDate>2008-10-10T14:22:27.25-05:00</OrderDate>
		<OrderAmount>25.9O</OrderAmount>
	</Order>
</Orders>'

INSERT INTO OrdersXML (OrdersId, OrdersDoc) VALUES (1, @xmlData)
INSERT INTO OrdersXML (OrdersId) VALUES (2)
GO

SELECT * FROM OrdersXML
GO
DROP TABLE OrdersXML
GO

-- XSD validation on XML data type columns
CREATE XML SCHEMA COLLECTION OrdersXSD
AS '
<xsd:schema
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:sql="urn:schemas-microsoft-com:mapping-schema">
	<xsd:element name="Orders">
		<xsd:complexType>
			<xsd:sequence>
				<xsd:element name="Order">
					<xsd:complexType>
						<xsd:sequence>
							<xsd:element name="OrderId" type="xsd:int" />
							<xsd:element name="CustomerId" type="xsd:int" />
							<xsd:element name="OrderDate" type="xsd:dateTime" />
							<xsd:element name="OrderAmount" type="xsd:float" />
						</xsd:sequence>
					</xsd:complexType>
				</xsd:element>
			</xsd:sequence>
		</xsd:complexType>
	</xsd:element>
</xsd:schema>'
GO

CREATE TABLE OrdersXML(
 	OrdersId int PRIMARY KEY, 
	OrdersDoc xml(OrdersXSD) NOT NULL)
GO

DECLARE @xmlData AS xml(OrdersXSD)
SET @xmlData = '
<Orders>
	<Order>
		<OrderId>5</OrderId>
		<CustomerId>6.0</CustomerId>
		<OrderDate>2008-10-10T14:22:27.25-05:00</OrderDate>
		<OrderAmount>25.9O</OrderAmount>
	</Order>
</Orders>'

INSERT INTO OrdersXML (OrdersId, OrdersDoc) VALUES (1, @xmlData)
GO

-- Notice time zone preservation; new in SQL 2008
SELECT * FROM OrdersXML
GO

DROP TABLE OrdersXML
DROP XML SCHEMA COLLECTION OrdersXSD
GO


-- XQuery on XML data type variable
DECLARE @BookCatalogXML xml
SET @BookCatalogXML = '
<catalog>
  <book category="ITPro">
    <title>Programming SQL Server</title>
    <author>Lenni Lobel</author>
    <price>49.99</price>
  </book>
  <book category="Developer">
    <title>Developing ADO .NET</title>
    <author>Andrew Brust</author>
    <price>39.93</price>
  </book>
  <book category="ITPro">
    <title>Windows Cluster Server</title> 
    <author>Stephen Forte</author> 
    <price>59.99</price> 
  </book>
</catalog>
'

-- Retrieve ITPro books as XML fragment
SELECT @BookCatalogXML.query('
for $b in /catalog/book
 where $b/@category="ITPro"
 order by $b/author[1] descending 
 return ($b)
')

-- Retrieve ITPro books as XML document
SELECT @BookCatalogXML.query('
<ITProBooks>
{
for $b in /catalog/book
 where $b/@category="ITPro"
 order by $b/author[1] descending 
 return ($b)
}
</ITProBooks>')

-- Dummy table and data for XQuery samples
CREATE TABLE BookCatalog(
 	BookId int PRIMARY KEY, 
	BookDoc xml NOT NULL)
GO

INSERT INTO BookCatalog VALUES (1, '
  <book category="ITPro">
    <title>Programming SQL Server</title>
    <author>Lenni Lobel</author>
    <price currency="USD">49.99</price>
	<purchaseSites>
		<purchaseSite>amazon.com</purchaseSite>
		<purchaseSite>booksonline.com</purchaseSite>
	</purchaseSites>
  </book>
')

INSERT INTO BookCatalog VALUES (2, '
  <book category="Developer">
    <title>Developing ADO .NET</title>
    <author>Andrew Brust</author>
    <price currency="USD">39.93</price>
	<purchaseSites>
		<purchaseSite>booksonline.com</purchaseSite>
	</purchaseSites>
  </book>
')

INSERT INTO BookCatalog VALUES (3, '
  <book category="ITPro">
    <title>Windows Cluster Server</title> 
    <author>Stephen Forte</author> 
    <price currency="CAD">59.99</price> 
	<purchaseSites>
		<purchaseSite>amazon.com</purchaseSite>
	</purchaseSites>
  </book>
')

GO

-- xml.exist()
SELECT *
 FROM BookCatalog
 WHERE BookDoc.exist('/book[@category="ITPro"]') = 1

-- xml.value()
SELECT
	BookId,
	BookDoc.value('/book[1]/@category', 'varchar(max)') AS Category,
	BookDoc.value('/book[1]/title[1]', 'varchar(max)') AS Title,
	BookDoc.value('/book[1]/price[1]', 'float') AS Price,
	BookDoc.value('/book[1]/price[1]/@currency', 'varchar(max)') AS Currency
 FROM
	BookCatalog

-- xml.query()
SELECT
	BookId,
	BookDoc.query('/book/purchaseSites') AS Title
 FROM
	BookCatalog

-- xml.modify(insert)
--  Andrew's book is now available on amazon.com
UPDATE BookCatalog
 SET BookDoc.modify('
	insert
	<purchaseSite>amazon.com</purchaseSite>
	into /book[1]/purchaseSites[1]
	')
 WHERE BookId = 2

SELECT * FROM BookCatalog
GO

-- xml.modify(insert)... using variable substitution (new in SQL 2008)
--  Andrew's book is now available on bestbooks.com
DECLARE @NewSite AS xml
SET @NewSite = '<purchaseSite>bestbooks.com</purchaseSite>'
	
UPDATE BookCatalog
 SET BookDoc.modify('insert sql:variable("@NewSite") into /book[1]/purchaseSites[1]')
 WHERE BookId = 2

SELECT * FROM BookCatalog
GO

-- xml.modify(delete)
--  Lenni's book is no longer available on amazon.com
UPDATE BookCatalog
 SET BookDoc.modify('delete /book[1]/purchaseSites/purchaseSite[1]')
 WHERE BookId = 1

SELECT * FROM BookCatalog
GO

-- xml.modify(replace)
--  Stephen's book was mistakenly marked in Canadian dollars
UPDATE BookCatalog
 SET BookDoc.modify('
	replace value of /book[1]/price[1]/@currency[1]
	with "USD"
	')
 WHERE BookId = 3

SELECT * FROM BookCatalog
GO

DROP TABLE BookCatalog
GO


-- CROSS APPLY with .nodes

-- Shred this XML into a parent row and multiple child rows
DECLARE @XmlSource xml = '
	<Person Id="236">
		<FirstName>John</FirstName>
		<LastName>Doe</LastName>
		<AddressLine>137 Madison Ave</AddressLine>
		<City>New York</City>
		<Province>NY</Province>
		<PostalCode>10018</PostalCode>
		<Contacts>
			<Contact type="mobile">917-777-1234</Contact>  
			<Contact type="home">212-631-1234</Contact>  
			<Contact type="work">212-635-2234</Contact>  
			<Contact type="fax">212-635-2238</Contact> 
		</Contacts>
	</Person>
'
-- The header values can be extracted directly from the XML source
SELECT
	PersonId = @XmlSource.value('/Person[1]/@Id', 'int'),
	FirstName = @XmlSource.value('/Person[1]/FirstName[1]', 'varchar(max)'),
	LastName = @XmlSource.value('/Person[1]/LastName[1]', 'varchar(max)'),
	AddressLine = @XmlSource.value('/Person[1]/AddressLine[1]', 'varchar(max)'),
	City = @XmlSource.value('/Person[1]/City[1]', 'varchar(max)'),
	Province = @XmlSource.value('/Person[1]/Province[1]', 'varchar(max)'),
	PostalCode = @XmlSource.value('/Person[1]/PostalCode[1]', 'varchar(max)')

-- To produce multiple child rows for each contact, shove
-- the XML into a table variable and use CROSS APPLY with .nodes
DECLARE @XmlTable table(XmlData xml) 
INSERT INTO @XmlTable(XmlData) VALUES (@XmlSource)
SELECT
	PersonId = @XmlSource.value('/Person[1]/@Id', 'int'),
	ContactType = Contact.value('@type', 'varchar(max)'),
	ContactNumber = Contact.value('.', 'varchar(max)')
 FROM
	@XmlTable AS t CROSS APPLY XmlData.nodes('/Person/Contacts/Contact') (Contact)


-- ******************************************************
-- ********* FOR XML Commands (SQL 2000 & 2005) *********
-- ******************************************************

USE AdventureWorks2012
GO

-- FOR XML RAW
SELECT
	Customer.CustomerID,
	SalesOrder.SalesOrderID,
	SalesOrder.OrderDate
 FROM Sales.Customer AS Customer
  INNER JOIN Sales.SalesOrderHeader AS SalesOrder ON SalesOrder.CustomerID = Customer.CustomerID
 ORDER BY Customer.CustomerID
 FOR XML RAW

-- FOR XML Auto
SELECT
	Customer.CustomerID,
	SalesOrder.SalesOrderID,
	SalesOrder.OrderDate
 FROM Sales.Customer AS Customer
  INNER JOIN Sales.SalesOrderHeader AS SalesOrder ON SalesOrder.CustomerID = Customer.CustomerID
 ORDER BY Customer.CustomerID, SalesOrder.SalesOrderID
 FOR XML AUTO

-- FOR XML EXPLICIT (2 levels)
SELECT
	1			AS Tag,
	NULL		AS Parent,
	CustomerID	AS [Customer!1!CustomerID], 
	NULL		AS [SalesOrder!2!SalesOrderID], 
	NULL		AS [SalesOrder!2!OrderDate]
 FROM
	Sales.Customer AS Customer
 WHERE
	Customer.CustomerID BETWEEN 11000 AND 11999

UNION ALL

SELECT
	2,
	1,
	Customer.CustomerID,
	OrderHeader.SalesOrderID,
	OrderHeader.OrderDate
 FROM
	Sales.Customer			AS Customer INNER JOIN
	Sales.SalesOrderHeader	AS OrderHeader ON OrderHeader.CustomerID = Customer.CustomerID
 ORDER BY
	[Customer!1!CustomerID],
	[SalesOrder!2!SalesOrderID]
 FOR XML EXPLICIT

-- FOR XML EXPLICIT (3 levels)
SELECT
	1			AS Tag,
	NULL		AS Parent,
	CustomerID	AS [Customer!1!CustomerID], 
	NULL		AS [SalesOrder!2!SalesOrderID], 
	NULL		AS [SalesOrder!2!TotalDue],
	NULL		AS [SalesOrder!2!OrderDate!ELEMENT],
	NULL		AS [SalesOrder!2!ShipDate!ELEMENT],
	NULL		AS [SalesDetail!3!ProductID],
	NULL		AS [SalesDetail!3!OrderQty],
	NULL		AS [SalesDetail!3!LineTotal]
 FROM
	Sales.Customer AS Customer
 WHERE
	Customer.CustomerID BETWEEN 11000 AND 11999

UNION ALL

SELECT 
	2,
	1,
	Customer.CustomerID, 
	OrderHeader.SalesOrderID, 
	OrderHeader.TotalDue,
	OrderHeader.OrderDate,
	OrderHeader.ShipDate,
	NULL,
	NULL,
	NULL
 FROM
	Sales.Customer			AS Customer INNER JOIN
	Sales.SalesOrderHeader	AS OrderHeader ON OrderHeader.CustomerID = Customer.CustomerID

UNION ALL

SELECT 
	3,
	2,
	Customer.CustomerID, 
	OrderHeader.SalesOrderID, 
	OrderHeader.TotalDue,
	OrderHeader.OrderDate,
	OrderHeader.ShipDate,
	OrderDetail.ProductID,
 	OrderDetail.OrderQty,
	OrderDetail.LineTotal
 FROM
	Sales.Customer			AS Customer INNER JOIN
	Sales.SalesOrderHeader	AS OrderHeader ON OrderHeader.CustomerID = Customer.CustomerID INNER JOIN
	Sales.SalesOrderDetail	AS OrderDetail ON OrderDetail.SalesOrderID = OrderHeader.SalesOrderID
 ORDER BY
	[Customer!1!CustomerID],
	[SalesOrder!2!SalesOrderID]
 FOR XML EXPLICIT

-- ***********************************************
-- ********* FOR XML Commands (SQL 2005) *********
-- ***********************************************

-- FOR XML TYPE to an XML variable
DECLARE @xmlData AS XML

SET @xmlData =
(
	SELECT
		Customer.CustomerID,
		OrderDetail.SalesOrderID,
		OrderDetail.OrderDate
	 FROM
		Sales.Customer			AS Customer INNER JOIN
		Sales.SalesOrderHeader	AS OrderDetail ON OrderDetail.CustomerID = Customer.CustomerID
	 WHERE
		Customer.CustomerID BETWEEN 11000 AND 11999
	 ORDER BY
		Customer.CustomerID
	 FOR XML AUTO, TYPE
)

SELECT @xmlData
GO

-- FOR XML TYPE nested in another SELECT
SELECT 
	CustomerID,
	(SELECT SalesOrderID, 
			TotalDue, 
			OrderDate, 
			ShipDate
	  FROM Sales.SalesOrderHeader AS OrderHeader
	  WHERE CustomerID = Customer.CustomerID 
	  FOR XML AUTO, TYPE) AS OrderHeaders
 FROM
	Sales.Customer AS Customer
 WHERE
	CustomerID BETWEEN 11000 AND 11999

-- FOR XML PATH (simple example)
SELECT
	BusinessEntityID AS [@BusinessEntityID],
	FirstName AS [ContactName/First],
	LastName AS [ContactName/Last],
	EmailAddress AS [ContactEmailAddress/EmailAddress1]
 FROM
	HumanResources.vEmployee
 FOR XML PATH('Contact')

-- FOR XML PATH (nested example)
SELECT 
	CustomerID AS [@CustomerID],
	Contact.FirstName + ' ' + Contact.LastName AS [comment()],
	(SELECT SalesOrderID AS [@SalesOrderID], 
			TotalDue AS [@TotalDue], 
			OrderDate, 
			ShipDate,
			(SELECT ProductID AS [@ProductID], 
					OrderQty AS [@OrderQty], 
					LineTotal AS [@LineTotal] 
			  FROM Sales.SalesOrderDetail
			  WHERE SalesOrderID = OrderHeader.SalesOrderID
			  FOR XML PATH('OrderDetail'), TYPE) 
	  FROM Sales.SalesOrderHeader AS OrderHeader
	  WHERE CustomerID = Customer.CustomerID 
	  FOR XML PATH('OrderHeader'), TYPE)
 FROM Sales.Customer AS Customer INNER JOIN
	  Person.Person AS Contact ON Contact.BusinessEntityID = Customer.PersonID
 WHERE CustomerID BETWEEN 11000 AND 11999
 FOR XML PATH ('Customer')

-- FOR XML ROOT
SELECT
	Customer.CustomerID, 
	OrderDetail.SalesOrderID,
	OrderDetail.OrderDate
 FROM
	Sales.Customer			AS Customer INNER JOIN
	Sales.SalesOrderHeader	AS OrderDetail ON OrderDetail.customerid=Customer.customerid
 WHERE
	Customer.CustomerID IN (11000, 11001)
 ORDER BY
	Customer.CustomerID
 FOR XML AUTO, ROOT('Orders')

-- FOR XML XMLSCHEMA
SELECT
	Customer.CustomerID, 
	OrderDetail.SalesOrderID,
	OrderDetail.OrderDate
 FROM
	Sales.Customer			AS Customer INNER JOIN
	Sales.SalesOrderHeader	AS OrderDetail ON OrderDetail.CustomerID = Customer.CustomerID
 WHERE
	Customer.CustomerID IN (11000, 11001)
 ORDER BY
	Customer.CustomerID
 FOR XML AUTO, XMLSCHEMA

-- FOR XML AUTO ELEMENTS
SELECT
	Customer.CustomerID, 
	OrderDetail.SalesOrderID,
	OrderDetail.OrderDate
 FROM
	Sales.Customer			AS Customer INNER JOIN
	Sales.SalesOrderHeader	AS OrderDetail ON OrderDetail.CustomerID = Customer.CustomerID
 WHERE
	Customer.CustomerID IN (11000, 11001)
 ORDER BY
	Customer.CustomerID
 FOR XML AUTO, ROOT('Orders'), ELEMENTS


-- *************************************************************
-- ********* Other XML Enhancements in SQL Server 2008 *********
-- *************************************************************


-- Lax validation (versus skip or strict)
CREATE XML SCHEMA COLLECTION OrderXSD
AS '
<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">
   <xsd:element name="Order">
	<xsd:complexType>
	  <xsd:sequence>
		<xsd:element name="CustomerName" type="xsd:string" />
		<xsd:element name="OrderDate" type="xsd:dateTime"/>
		<xsd:element name="OrderAmount" type="xsd:float"/>	
		<xsd:any namespace="##other" processContents="lax"/>
	  </xsd:sequence>
	</xsd:complexType> 
   </xsd:element>  
</xsd:schema>'
GO

DECLARE @xmlData AS xml(OrderXSD)

SET @xmlData = '
<Order xmlns:shp="http://adventure-works.com/shipping">
	<CustomerName>John Doe</CustomerName>
	<OrderDate>2008-10-10T14:22:27.25-05:00</OrderDate>
	<OrderAmount>100</OrderAmount>
	<shp:Delivery>FedEx</shp:Delivery>
</Order>
'

DROP XML SCHEMA COLLECTION OrderXSD


-- Union and List types
CREATE XML SCHEMA COLLECTION OrderXSD
AS '
<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">
	<xsd:simpleType name="shiptypeList">
		<xsd:union>
			<xsd:simpleType>
			  <xsd:list>
				<xsd:simpleType>
				  <xsd:restriction base="xsd:integer">
					<xsd:enumeration value="1"/>
					<xsd:enumeration value="2"/>
					<xsd:enumeration value="3"/>
				  </xsd:restriction>
				</xsd:simpleType>
			  </xsd:list>
			</xsd:simpleType>
			<xsd:simpleType>
			  <xsd:list>
				<xsd:simpleType>
				  <xsd:restriction base="xsd:string">
					<xsd:enumeration value="FedEx"/>
					<xsd:enumeration value="DHL"/>
					<xsd:enumeration value="UPS"/>
				  </xsd:restriction>
				</xsd:simpleType>
			  </xsd:list>
			</xsd:simpleType>
		</xsd:union>
	</xsd:simpleType>
	<xsd:element name="Order">
		<xsd:complexType>
			<xsd:sequence>
				<xsd:element name="CustomerName" type="xsd:string" />
				<xsd:element name="OrderDate" type="xsd:dateTime"/>
				<xsd:element name="OrderAmount" type="xsd:float"/>
				<xsd:element name="ShipType" type="shiptypeList"/>
			</xsd:sequence>
		</xsd:complexType> 
	</xsd:element>  
</xsd:schema>'
GO

CREATE TABLE OrderXML(
 	OrderId int PRIMARY KEY, 
	OrderDoc xml(OrderXSD) NOT NULL)
GO

DECLARE @xmlData AS xml
SET @xmlData = '
<Order>   
	<CustomerName>Bill Gates</CustomerName>
	<OrderDate>2008-10-10T14:22:27.25-05:00</OrderDate> 
	<OrderAmount>100</OrderAmount>
	<ShipType>1</ShipType>
</Order>'

INSERT INTO OrderXML (OrderId, OrderDoc) VALUES (1, @xmlData)
GO

DECLARE @xmlData AS xml
SET @xmlData = '
<Order>   
	<CustomerName>John Doe</CustomerName>
	<OrderDate>2008-10-10T14:22:27.25-05:00</OrderDate> 
	<OrderAmount>100</OrderAmount>
	<ShipType>UPS</ShipType>
</Order>'

INSERT INTO OrderXML (OrderId, OrderDoc) VALUES (2, @xmlData)
GO

SELECT * FROM OrderXML
DELETE FROM OrderXML -- retry with bad values
GO

DROP TABLE OrderXML
DROP XML SCHEMA COLLECTION OrderXSD
GO


-- Using "let"
DECLARE @xml AS xml
SET @xml='
<Speakers>
    <Speaker name="Stephen Forte">
        <classes>
            <class name="Writing Secure Code for ASP .NET "/>
            <class name="Using XQuery in SQL Server 2008"/>
            <class name="SQL Server and Oracle Working Together"/>
        </classes>
    </Speaker>
    <Speaker name="Lenni Lobel">
        <classes>
            <class name="Using LINQ"/>
            <class name="Advanced SQL Querying Techniques"/>
            <class name="SQL Server 2008"/>
            <class name="Framework Programming in C#"/>
        </classes>
    </Speaker>
</Speakers>
'

SELECT @xml.query(
'<Speakers>
{
for $Speaker in /Speakers/Speaker
  let $count := count($Speaker/classes/class)
  order by $count descending
  return
    <Speaker>
      {$Speaker/@name}
      <SessionCount>
        {$count}
      </SessionCount>
    </Speaker>
}
</Speakers>') 
