---------------------------------------------------------------
-- Server-side Paging (SQL Server 2012)
---------------------------------------------------------------

USE AdventureWorks2017
GO

SELECT COUNT(*) FROM Person.Person

-- Get 10 rows starting at row 21 (rows 21-30; i.e., page 3)
-- from the Person.Person table

-- Using ROW_NUMBER introduced in SQL Server 2005
DECLARE @pageNum int = 3
DECLARE @pageSize int = 10
DECLARE @firstRow int = ((@pageNum - 1) * @pageSize) + 1
DECLARE @lastRow int = @firstRow + @pageSize - 1

SELECT *
 FROM
   (SELECT
     RowNum = ROW_NUMBER() OVER (ORDER BY LastName, FirstName),
     Title, FirstName, LastName
    FROM
     Person.Person
    ) AS a
 WHERE RowNum BETWEEN @firstRow AND @lastRow
 ORDER BY LastName, FirstName
GO

-- Using OFFSET/FETCH NEXT in SQL Server 2012
DECLARE @pageNum int = 3
DECLARE @pageSize int = 10
DECLARE @offset int = (@pageNum - 1) * @pageSize

SELECT Title, FirstName, LastName
 FROM Person.Person
 ORDER BY LastName, FirstName
  OFFSET @offset ROWS FETCH NEXT @pageSize ROWS ONLY

GO

-- Using OFFSET/FETCH NEXT with ROW_NUMBER
DECLARE @PageNum int = 3
DECLARE @PageSize int = 10
DECLARE @Offset int = (@PageNum - 1) * @PageSize

SELECT RowNum = ROW_NUMBER() OVER (ORDER BY LastName, FirstName), Title, FirstName
 FROM Person.Person
 ORDER BY LastName, FirstName
 OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY
