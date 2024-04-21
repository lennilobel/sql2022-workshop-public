/* =================== MERGE =================== */

CREATE DATABASE MyDB
GO

USE MyDB
GO

------------------------------------------------------------------------------------
/* Stock Portfolio Example */

CREATE TABLE Stock(Symbol varchar(10) PRIMARY KEY, Qty int CHECK (Qty > 0))
CREATE TABLE Trade(Symbol varchar(10) PRIMARY KEY, Delta int CHECK (Delta <> 0))
GO

INSERT INTO Stock VALUES ('MSFT', 10)
INSERT INTO Stock VALUES ('WMT', 5)

INSERT INTO Trade VALUES('MSFT', 5)
INSERT INTO Trade VALUES('WMT', -5)
INSERT INTO Trade VALUES('GE', 3)

SELECT * FROM Stock
SELECT * FROM Trade

MERGE Stock
 USING Trade
 ON Stock.Symbol = Trade.Symbol
 WHEN MATCHED AND (Stock.Qty + Trade.Delta = 0) THEN
   -- delete stock if entirely sold
   DELETE
 WHEN MATCHED THEN
   -- update stock quantity (delete takes precedence over update)
   UPDATE SET Stock.Qty += Trade.Delta
 WHEN NOT MATCHED BY TARGET THEN
   -- add newly purchased stock
  INSERT VALUES (Trade.Symbol, Trade.Delta);

SELECT * FROM Stock

DROP TABLE Stock
DROP TABLE Trade

------------------------------------------------------------------------------------
/* Table Replication Example */

CREATE TABLE [Original](Id int PRIMARY KEY, Name varchar(10), Number int)
CREATE TABLE [Replica](Id int PRIMARY KEY, Name varchar(10), Number int)
GO

CREATE PROCEDURE uspSyncReplica AS

 MERGE [Replica] AS r
  USING [Original] AS o ON o.Id = r.Id
  WHEN MATCHED AND (o.Name != r.Name OR o.Number != r.Number) THEN
    UPDATE SET r.Name = o.Name, r.Number = o.Number
  WHEN NOT MATCHED THEN
    INSERT VALUES(o.Id, o.Name, o.Number)
  WHEN NOT MATCHED BY SOURCE THEN
    DELETE
 OUTPUT $action, inserted.*, deleted.*;

GO

SELECT * FROM [Original]
SELECT * FROM [Replica]

-- Add two rows
INSERT [Original] VALUES(1, 'Sara', 10)
INSERT [Original] VALUES(2, 'Steven', 20)
GO

SELECT * FROM [Original]
SELECT * FROM [Replica]

EXEC uspSyncReplica
GO

SELECT * FROM [Original]
SELECT * FROM [Replica]

-- Mix of INSERT, UPDATE, and DELETE
INSERT INTO [Original] VALUES(3, 'Andrew', 100)
UPDATE [Original] SET Name = 'Stephen', Number += 10 WHERE Id = 2
DELETE FROM [Original] WHERE Id = 1
GO

SELECT * FROM [Original]
SELECT * FROM [Replica]

EXEC uspSyncReplica

SELECT * FROM [Original]
SELECT * FROM [Replica]

DROP PROC uspSyncReplica
DROP TABLE [Original]
DROP TABLE [Replica]

------------------------------------------------------------------------------------
/* Upsert 1 */

SET NOCOUNT ON
GO

CREATE TABLE Customer(
  CustomerId  int PRIMARY KEY,
  FirstName   varchar(30),
  LastName    varchar(30),
  Balance     decimal)

GO

CREATE PROCEDURE uspUpsertCustomer(
  @CustomerId int,
  @FirstName varchar(30),
  @LastName varchar(30),
  @Balance decimal)
 AS
  BEGIN
  
  MERGE Customer AS tbl
   USING (SELECT
            @CustomerId AS CustomerId,
            @FirstName AS FirstName,
            @LastName AS LastName,
            @Balance AS Balance) AS row
   ON tbl.CustomerId = row.CustomerId
  WHEN NOT MATCHED THEN
    INSERT(CustomerId, FirstName, LastName, Balance)
     VALUES(row.CustomerId, row.FirstName, row.LastName, row.Balance)
  WHEN MATCHED THEN
    UPDATE SET
      tbl.FirstName = row.FirstName,
      tbl.LastName = row.LastName,
      tbl.Balance = row.Balance
  ;

  END
GO

-- Add Customer 1
EXEC uspUpsertCustomer 1, 'Mark', 'Smith', 100

-- Add Customer 2
EXEC uspUpsertCustomer 2, 'Sam', 'Waters', 120

SELECT * FROM Customer
GO

-- Change Customer 1's first name and balance
EXEC uspUpsertCustomer 1, 'Marc', 'Smith', 110

SELECT * FROM Customer
GO

DROP TABLE Customer
DROP PROCEDURE uspUpsertCustomer
GO

------------------------------------------------------------------------------------
/* Upsert 2 */

CREATE TABLE Customer(
  CustomerId int IDENTITY(1, 1) PRIMARY KEY,
  FirstName varchar(30),
  LastName varchar(30),
  Balance decimal,
  Created datetime2(0),
  Modified datetime2(0),
  Version rowversion)

GO

ALTER TABLE Customer ADD CONSTRAINT
 DF_Customer_Created DEFAULT (SYSDATETIME()) FOR Created
 
ALTER TABLE Customer ADD CONSTRAINT
 DF_Customer_Modified DEFAULT (SYSDATETIME()) FOR Modified

GO

CREATE PROCEDURE uspUpsertCustomer(
  @CustomerId int OUTPUT,  -- Passed in as NULL for new customer
  @FirstName varchar(30),
  @LastName varchar(30),
  @Balance decimal,
  @Created datetime2(0) OUTPUT,
  @Modified datetime2(0) OUTPUT,
  @Version rowversion OUTPUT)
 AS
  BEGIN

  -- Merge single-row source built from params into Customer table
  MERGE Customer AS tbl
   USING (SELECT
            @CustomerId AS CustomerId,
            @FirstName AS FirstName,
            @LastName AS LastName,
            @Balance AS Balance) AS row
   ON tbl.CustomerId = row.CustomerId
  -- Insert new row if not found (@CustomerId was passed in as NULL)
  WHEN NOT MATCHED THEN
    INSERT(FirstName, LastName, Balance)
     VALUES(row.FirstName, row.LastName, row.Balance)
  -- Update existing row if found, but *only* if the rowversions match
  WHEN MATCHED AND tbl.Version = @Version THEN
    UPDATE SET
      tbl.FirstName = row.FirstName,
      tbl.LastName = row.LastName,
      tbl.Balance = row.Balance,
      tbl.Modified = SYSDATETIME()
  ;

  -- If no rows were affected by an update, the rowversion changed
  IF @@ROWCOUNT = 0 AND @CustomerId IS NOT NULL
   RAISERROR('Optimistic concurrency violation', 18, 1)

  -- If this was an insert, return the newly assigned identity value
  IF @CustomerId IS NULL
   SET @CustomerId = SCOPE_IDENTITY()

  -- Return 'read-only' creation/modification times and new rowversion
  SELECT @Created = Created, @Modified = Modified, @Version = Version
   FROM Customer
   WHERE CustomerId = @CustomerId

  END

GO

DECLARE @C1Id int
DECLARE @C2Id int
DECLARE @Crt datetime2(0)
DECLARE @Mod datetime2(0)
DECLARE @C1Ver rowversion
DECLARE @C2Ver rowversion

SET @C1Id = NULL
SET @C2Id = NULL

-- Add Customer 1
EXEC uspUpsertCustomer
 @C1Id OUTPUT, 'Mark', 'Smith', 100, @Crt OUTPUT, @Mod OUTPUT, @C1Ver OUTPUT

SELECT @C1Id AS C1Id, @Crt AS Crt, @Mod AS Mod, @C1Ver AS C1Ver
WAITFOR DELAY '00:00:01'

-- Add Customer 2
EXEC uspUpsertCustomer
 @C2Id OUTPUT, 'Sam', 'Waters', 120, @Crt OUTPUT, @Mod OUTPUT, @C2Ver OUTPUT

SELECT @C2Id AS C2Id, @Crt AS Crt, @Mod AS Mod, @C2Ver AS C2Ver
WAITFOR DELAY '00:00:01'

-- Change Customer 1's first name and balance, passing in the
--  rowversion from the original insert
EXEC uspUpsertCustomer
 @C1Id OUTPUT, 'Marc', 'Smith', 110,
 @Crt OUTPUT, @Mod OUTPUT, @C1Ver OUTPUT
 
SELECT @C1Id AS C1Id, @Crt AS Crt, @Mod AS Mod, @C1Ver AS C1Ver


SELECT * FROM Customer

-- Cleanup
DROP TABLE Customer
DROP PROCEDURE uspUpsertCustomer
GO
