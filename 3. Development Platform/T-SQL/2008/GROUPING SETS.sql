-- GROUPING SETS demo

USE MyDB
GO

CREATE TABLE Inventory(
  Store varchar(2),
  Item varchar(20),
  Color varchar(10),
  Quantity decimal)

GO
 
INSERT INTO Inventory VALUES('NY', 'Table', 'Blue', 124)
INSERT INTO Inventory VALUES('NJ', 'Table', 'Blue', 100)
INSERT INTO Inventory VALUES('NY', 'Table', 'Red', 29)
INSERT INTO Inventory VALUES('NJ', 'Table', 'Red', 56)
INSERT INTO Inventory VALUES('PA', 'Table', 'Red', 138)
INSERT INTO Inventory VALUES('NY', 'Table', 'Green', 229)
INSERT INTO Inventory VALUES('PA', 'Table', 'Green', 304)
INSERT INTO Inventory VALUES('NY', 'Chair', 'Blue', 101)
INSERT INTO Inventory VALUES('NJ', 'Chair', 'Blue', 22)
INSERT INTO Inventory VALUES('NY', 'Chair', 'Red', 21)
INSERT INTO Inventory VALUES('NJ', 'Chair', 'Red', 10)
INSERT INTO Inventory VALUES('PA', 'Chair', 'Red', 136)
INSERT INTO Inventory VALUES('NJ', 'Sofa', 'Green', 2)

-- Group by Item, and then by color within each item
SELECT Item, Color, SUM(Quantity) AS TotalQty, COUNT(Store) AS Stores
 FROM Inventory
 GROUP BY Item, Color
 ORDER BY Item, Color

-- Include rollups for each level (Item and Color)
SELECT Item, Color, SUM(Quantity) AS TotalQty, COUNT(Store) AS Stores
 FROM Inventory
 GROUP BY Item, Color WITH ROLLUP
 ORDER BY Item, Color

-- Include rollups for each level combination (2 dimensions)
SELECT Item, Color, SUM(Quantity) AS TotalQty, COUNT(Store) AS Stores
 FROM Inventory
 GROUP BY Item, Color WITH CUBE
 ORDER BY Item, Color

-- Include rollups for each level combination (3 dimensions)
SELECT Store, Item, Color, SUM(Quantity) AS TotalQty
 FROM Inventory
 GROUP BY Store, Item, Color WITH CUBE
 ORDER BY Store, Item, Color

-- Include *just* the rollups for each level
SELECT Store, Item, Color, SUM(Quantity) AS TotalQty
 FROM Inventory
 GROUP BY GROUPING SETS (Store, Item, Color)
 ORDER BY Store, Item, Color

-- Include just rollups on Store, multi-dimensional rollups on Item, Color
SELECT Store, Item, Color, SUM(Quantity) AS TotalQty
 FROM Inventory
 GROUP BY GROUPING SETS(Store), CUBE(Item, Color)
 ORDER BY Store, Item, Color
/*
The rows with NULL values for both Item and Color are the top-level rollups for Store
returned by the GROUPING SETS(Store) operator. These rows report just the totals for
each store (all items, all colors). All of the other rows are the multi-dimensional
roll-up and summary results returned by CUBE(Item, Color). These rows report
aggregations for every combination of Item and Color. Because Store is returned by
GROUPING SETS and not by CUBE, we don�t see combinations that include all stores.
*/

-- Handling NULLs; Now, a NULL color in the data means *no* color (i.e., n/a)
INSERT INTO Inventory VALUES('NY', 'Stool', NULL, 36)
INSERT INTO Inventory VALUES('NJ', 'Stool', NULL, 8)

-- Can't distinguish no-value from rollups
SELECT Store, Item, Color, SUM(Quantity) AS TotalQty
 FROM Inventory
 GROUP BY GROUPING SETS(Store), CUBE(Item, Color)
 ORDER BY Store, Item, Color

-- Use GROUPING() to test for rollup NULLs and substitue with (all)
SELECT
  CASE WHEN GROUPING(Store) = 1 THEN '(all)' ELSE Store END AS Store,
  CASE WHEN GROUPING(Item) = 1  THEN '(all)' ELSE Item  END AS Item,
  CASE WHEN GROUPING(Color) = 1 THEN '(all)' ELSE Color END AS Color,
  SUM(Quantity) AS TotalQty
 FROM Inventory
 GROUP BY GROUPING SETS(Store), CUBE(Item, Color)
 ORDER BY Store, Item, Color

-- Extend by using ISNULL() to test for no-value NULLs and substitute with (n/a)
SELECT
  CASE WHEN GROUPING(Store) = 1 THEN '(all)'
   ELSE ISNULL(Store, '(n/a)') END AS Store,
  CASE WHEN GROUPING(Item) = 1  THEN '(all)'
   ELSE ISNULL(Item,  '(n/a)') END AS Item,
  CASE WHEN GROUPING(Color) = 1 THEN '(all)'
   ELSE ISNULL(Color, '(n/a)') END AS Color,
  SUM(Quantity) AS TotalQty
 FROM Inventory
 GROUP BY GROUPING SETS(Store), CUBE(Item, Color)
 ORDER BY Store, Item, Color

DROP TABLE Inventory
GO
