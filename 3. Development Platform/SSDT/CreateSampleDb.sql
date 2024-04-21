CREATE DATABASE SampleDb
GO

USE SampleDb
GO

-- Create the customer and order tables
CREATE TABLE Customer(
  CustomerId bigint NOT NULL PRIMARY KEY,
  FirstName varchar(50) NOT NULL,
  LastName varchar(50) NOT NULL,
  CustomerRanking varchar(50) NULL)

CREATE TABLE OrderHeader(
  OrderHeaderId bigint NOT NULL,
  CustomerId bigint NOT NULL,
  OrderTotal money NOT NULL)

-- Create the relationship
ALTER TABLE OrderHeader ADD CONSTRAINT FK_OrderHeader_Customer
 FOREIGN KEY(CustomerId) REFERENCES Customer(CustomerId)

-- Add a few customers
INSERT INTO Customer (CustomerId, FirstName, LastName, CustomerRanking) VALUES
 (1, 'Lukas', 'Keller', NULL),
 (2, 'Jeff', 'Hay', 'Good'),
 (3, 'Keith', 'Harris', 'so-so'),
 (4, 'Simon', 'Pearson', 'A+'),
 (5, 'Matt', 'Hink', 'Stellar'),
 (6, 'April', 'Reagan', '')

-- Add a few orders
INSERT INTO OrderHeader(OrderHeaderId, CustomerId, OrderTotal) VALUES
 (1, 2, 28.50), (2, 2, 169.00),  -- Jeff's orders
 (3, 3, 12.99),  -- Keith's orders
 (4, 4, 785.75), (5, 4, 250.00),  -- Simon's orders
 (6, 5, 6100.00), (7, 5, 4250.00),  -- Matt’s orders
 (8, 6, 18.50), (9, 6, 10.00), (10, 6, 18.00)  -- April's orders
GO

-- Create a handy view summarizing customer orders
CREATE VIEW vwCustomerOrderSummary WITH SCHEMABINDING AS
 SELECT
   c.CustomerID, c.FirstName, c.LastName, c.CustomerRanking,
   ISNULL(SUM(oh.OrderTotal), 0) AS OrderTotal
  FROM
   dbo.Customer AS c
   LEFT OUTER JOIN dbo.OrderHeader AS oh ON c.CustomerID = oh.CustomerID
  GROUP BY
   c.CustomerID, c.FirstName, c.LastName, c.CustomerRanking
GO 
