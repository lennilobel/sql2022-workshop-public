/* =================== INSERT OVER DML =================== */

USE MyDB
GO

-- Using OUTPUT...INTO

CREATE TABLE Book(
  ISBN varchar(20) PRIMARY KEY,
  Price decimal,
  Shelf int)

CREATE TABLE WeeklyChange(
  ISBN varchar(20) PRIMARY KEY,
  Price decimal,
  Shelf int)

CREATE TABLE BookHistory(
  Action nvarchar(10),
  NewISBN varchar(20),
  NewPrice decimal,
  NewShelf int,
  OldISBN varchar(20),
  OldPrice decimal,
  OldShelf int,
  ArchivedAt datetime2)

GO

CREATE PROCEDURE uspUpdateBooks AS
 BEGIN

  MERGE Book AS B
   USING WeeklyChange AS WC
    ON B.ISBN = WC.ISBN
   WHEN MATCHED THEN
    UPDATE SET B.Price = WC.Price, B.Shelf = WC.Shelf
   WHEN NOT MATCHED THEN
    INSERT VALUES(WC.ISBN, WC.Price, WC.Shelf)
   OUTPUT $action, inserted.*, deleted.*, SYSDATETIME()
    INTO BookHistory;
    
 END
GO

INSERT INTO Book VALUES('A', 100, 1)
INSERT INTO Book VALUES('B', 200, 2)
INSERT INTO WeeklyChange VALUES('A', 101, 1)
INSERT INTO WeeklyChange VALUES('C', 300, 3)

SELECT * FROM Book
SELECT * FROM WeeklyChange

EXEC uspUpdateBooks
GO

SELECT * FROM BookHistory
GO

DROP TABLE Book
DROP TABLE WeeklyChange
DROP TABLE BookHistory
DROP PROCEDURE uspUpdateBooks
GO

-- Using INSERT OVER DML

CREATE TABLE Book(
  ISBN varchar(20),
  Price decimal,
  Shelf int,
  ArchivedAt datetime2)

CREATE UNIQUE CLUSTERED INDEX
 UI_Book ON Book(ISBN, ArchivedAt)

CREATE TABLE WeeklyChange(
  ISBN varchar(20) PRIMARY KEY,
  Price decimal,
  Shelf int)

GO

CREATE PROCEDURE uspUpdateBooks AS
 BEGIN

  INSERT INTO Book(ISBN, Price, Shelf, ArchivedAt)
   SELECT ISBN, Price, Shelf, GETDATE() FROM
   (MERGE Book AS B
     USING WeeklyChange AS WC
      ON B.ISBN = WC.ISBN AND B.ArchivedAt IS NULL
     WHEN MATCHED THEN
      UPDATE SET Price = WC.Price, Shelf = WC.Shelf
     WHEN NOT MATCHED THEN
      INSERT VALUES(WC.ISBN, WC.Price, WC.Shelf, NULL)
     OUTPUT $action, WC.ISBN, Deleted.Price, Deleted.Shelf
   ) CHANGES(Action, ISBN, Price, Shelf)
    WHERE Action = 'UPDATE';

 END
GO

INSERT INTO Book VALUES('A', 100, 1, NULL)
INSERT INTO Book VALUES('B', 200, 2, NULL)
INSERT INTO WeeklyChange VALUES('A', 110, 1)

SELECT * FROM Book
SELECT * FROM WeeklyChange
GO

EXEC uspUpdateBooks
SELECT * FROM Book
GO

DELETE FROM WeeklyChange
INSERT INTO WeeklyChange VALUES('A', 110, 6)
INSERT INTO WeeklyChange VALUES('C', 300, 3)
GO

SELECT * FROM Book
SELECT * FROM WeeklyChange
GO

EXEC uspUpdateBooks
SELECT * FROM Book
GO

-- Cleanup
DROP TABLE Book
DROP TABLE WeeklyChange
DROP PROCEDURE uspUpdateBooks
GO

