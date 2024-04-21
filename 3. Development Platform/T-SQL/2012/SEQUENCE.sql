---------------------------------------------------------------
-- Sequences (SQL Server 2012)
---------------------------------------------------------------

USE MyDB
GO

CREATE TABLE Customer
 (Id        int PRIMARY KEY,
  FirstName varchar(max),
  LastName  varchar(max))

-- Create the sequence with a start, increment, and min/max settings
CREATE SEQUENCE CustomerSequence AS int
 START WITH 1
 INCREMENT BY 1
 NO MAXVALUE

-- Use the sequence for new primary key values 1, 2, 3
INSERT INTO Customer (Id, FirstName, LastName) VALUES
 (NEXT VALUE FOR CustomerSequence, 'Bill', 'Malone'),
 (NEXT VALUE FOR CustomerSequence, 'Justin', 'Thorp'),
 (NEXT VALUE FOR CustomerSequence, 'Paul', 'Duffy')

SELECT * FROM Customer

-- Set the default for IDENTITY-behavior
ALTER TABLE Customer
 ADD DEFAULT NEXT VALUE FOR CustomerSequence FOR Id

-- Generates 4
INSERT INTO Customer (FirstName, LastName) VALUES('Jeff', 'Smith')
SELECT * FROM Customer

-- Peek at the current value (4)
SELECT current_value FROM sys.sequences WHERE name='CustomerSequence'

-- Set the next number
ALTER SEQUENCE CustomerSequence
  RESTART WITH 1001
  MINVALUE 1000
  MAXVALUE 1003
  CYCLE

-- Generates 1001, 1002, 1003, 1000... starts again with 1000
INSERT INTO Customer (FirstName, LastName) VALUES
 ('Pat', 'Coleman'),
 ('Aaron', 'Lee'),
 ('Shy', 'Cohen'),
 ('Peter', 'Sloth')

SELECT * FROM Customer

-- Next one fails because recycling back from 1003 to 1001
INSERT INTO Customer (FirstName, LastName) VALUES
 ('Joe', 'Unlucky')

-- Cleanup
DROP TABLE Customer
DROP SEQUENCE CustomerSequence
