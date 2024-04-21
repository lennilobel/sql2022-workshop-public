-- Run '01-Create tables.sql' to create sample data in SQL Server
-- before running this script.
USE Library
GO

-- Convert column names to camel case, convert primary key IDs to type-qualified strings, and add type column
DROP TABLE IF EXISTS #Book
SELECT
    id      = CONCAT('B', BookId),
    type    = 'book',
    title   = Title,
    year    = [Year],
    pages   = Pages
INTO
    #Book
FROM
    Book

DROP TABLE IF EXISTS #Author
SELECT
    id          = CONCAT('A', AuthorId),
    type        = 'author',
    firstName   = FirstName,
    middleName  = MiddleName,
    lastName    = LastName,
    dob         = Dob,
    email       = Email,
    bio         = Bio
INTO
    #Author
FROM
    Author

-- Enable OLE automation for Scripting.FileSystemObject so we can save JSON text files from T-SQL
EXECUTE sp_configure 'show advanced options', 1
RECONFIGURE
EXECUTE sp_configure 'Ole Automation Procedures', 1
RECONFIGURE

DECLARE @OleFileSystemObject INT
DECLARE @OleFileHandle INT
EXECUTE sp_OACreate 'Scripting.FileSystemObject', @OleFileSystemObject OUT

-- Create book documents with denormalized author information
DECLARE @BooksJson varchar(max) = (
    SELECT
        b.id,
        b.type,
        b.title,
        b.year,
        b.pages,
        id          = authors.id,
        firstName   = authors.firstName,
        middleName  = authors.middleName,
        lastName    = authors.lastName
    FROM
        #Book AS b
        INNER JOIN BookAuthor AS ba ON CONCAT('B', ba.BookId) = b.id
        INNER JOIN #Author AS authors ON authors.id = CONCAT('A', ba.AuthorId)
    ORDER BY
        b.id,
        authors.id
    FOR JSON AUTO, INCLUDE_NULL_VALUES
)
EXECUTE sp_OAMethod @OleFileSystemObject, 'OpenTextFile', @OleFileHandle OUT, 'C:\Projects\Sleek\SQL2022 Workshop\3. Development Platform\Data API Builder\DAB - Azure Cosmos DB\DabCreateCosmosDatabase\books.json', 2, 1
EXECUTE sp_OAMethod @OleFileHandle, 'WriteLine', NULL, @BooksJson
EXECUTE sp_OADestroy @OleFileHandle

-- Create master author documents
DECLARE @AuthorsJson varchar(max) = (
    SELECT
        id,
        type,
        firstName,
        middleName,
        lastName,
        dob,
        email,
        bio
    FROM
        #Author
    FOR JSON AUTO, INCLUDE_NULL_VALUES
)
EXECUTE sp_OAMethod @OleFileSystemObject, 'OpenTextFile', @OleFileHandle OUT, 'C:\Projects\Sleek\SQL2022 Workshop\3. Development Platform\Data API Builder\DAB - Azure Cosmos DB\DabCreateCosmosDatabase\authors.json', 2, 1
EXECUTE sp_OAMethod @OleFileHandle, 'WriteLine', NULL, @AuthorsJson
EXECUTE sp_OADestroy @OleFileHandle

-- Disable OLE automation
EXECUTE sp_OADestroy @OleFileSystemObject
EXECUTE sp_configure 'Ole Automation Procedures', 0
RECONFIGURE
EXECUTE sp_configure 'show advanced options', 0
RECONFIGURE
GO

DROP VIEW IF EXISTS vwRandomNumber
DROP FUNCTION IF EXISTS dbo.GetLoremIpsumUdf
GO
