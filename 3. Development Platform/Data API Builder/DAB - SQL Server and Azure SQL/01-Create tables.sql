USE master
GO

EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'Library'
DROP DATABASE IF EXISTS Library
GO

CREATE DATABASE Library
GO

USE Library
GO

-- Create objects to support random text generation
DROP VIEW IF EXISTS vwRandomNumber
GO

CREATE VIEW vwRandomNumber 
AS
    SELECT RandomNumber = RAND()
GO

DROP FUNCTION IF EXISTS dbo.GetBioUdf
GO

CREATE FUNCTION dbo.GetBioUdf()
RETURNS varchar(max)
AS
BEGIN

    DECLARE @StartPos int = FLOOR((SELECT RandomNumber FROM vwRandomNumber) * 100) + 1
    DECLARE @Length int = FLOOR((SELECT RandomNumber FROM vwRandomNumber) * 1000) + 500
    DECLARE @Text varchar(3000) =
        'lorem ipsum dolor sit amet consectetur adipiscing elit integer rhoncus ' +
        'laoreet tincidunt sed tincidunt eros ac tincidunt egestas nulla massa p' +
        'orta dolor sit amet egestas dolor elit sed justo phasellus sed aliquam ' +
        'nunc integer neque odio ornare et luctus ut pretium eget ante pellentes' +
        'que volutpat sodales ante sed iaculis nibh tincidunt vitae sed sagittis' +
        ' augue non viverra accumsan odio eros adipiscing mauris et sollicitudin' +
        ' nulla arcu vitae urna nunc consequat tristique odio ut fringilla quisq' +
        'ue ac leo nec ante pretium luctus nullam vestibulum malesuada mi id sag' +
        'ittis nisi dictum eget sed ultrices leo nec malesuada bibendum mauris e' +
        'nim fringilla dolor eget suscipit nisl sem ac urna vivamus et posuere p' +
        'urus praesent laoreet velit ac molestie varius dui lectus egestas torto' +
        'r lacinia feugiat mauris ipsum non est odio ornare et luctus ut pretium' +
        'laoreet tincidunt sed tincidunt eros ac tincidunt egestas nulla massa p' +
        'orta dolor sit amet egestas dolor elit sed justo phasellus sed aliquam ' +
        'nunc integer neque odio ornare et luctus ut pretium eget ante pellentes' +
        'que volutpat sodales ante sed iaculis nibh tincidunt vitae sed sagittis' +
        ' augue non viverra accumsan odio eros adipiscing mauris et sollicitudin' +
        ' nulla arcu vitae urna nunc consequat tristique odio ut fringilla quisq' +
        'ue ac leo nec ante pretium luctus nullam vestibulum malesuada mi id sag' +
        'ittis nisi dictum eget sed ultrices leo nec malesuada bibendum mauris e' +
        'nim fringilla dolor eget suscipit nisl sem ac urna vivamus et posuere p' +
        'urus praesent laoreet velit ac molestie varius dui lectus egestas torto' +
        'r lacinia feugiat mauris ipsum non est odio ornare et luctus ut pretium'
    
    DECLARE @Result varchar(1000) = TRIM(SUBSTRING(@Text, @StartPos, @Length))

    RETURN UPPER(SUBSTRING(@Result, 1, 1)) + SUBSTRING(@Result, 2, LEN(@Result) - 1)

END
GO

-- Create books table
CREATE TABLE Book
(
    BookId int IDENTITY PRIMARY KEY,
    Title varchar(100),
    Year int,
    Pages int
)
GO

-- Create authors table
CREATE TABLE Author
(
    AuthorId int IDENTITY PRIMARY KEY,
    FirstName varchar(100),
    MiddleName varchar(100),
    LastName varchar(100),
    Dob date,
    Email varchar(100),
    Bio varchar(1000)
)
GO

-- Create many-to-many relationship table joining books to authors
CREATE TABLE BookAuthor
(
    BookId int NOT NULL FOREIGN KEY REFERENCES Book(BookId),
    AuthorId int NOT NULL FOREIGN KEY REFERENCES Author(AuthorId),
    PRIMARY KEY (AuthorId, BookId)
)
GO

-- Populate books table
SET IDENTITY_INSERT Book ON
INSERT INTO Book (BookId, Title, Year, Pages) VALUES
 (1000, 'Prelude to Foundation', 1988, 403),
 (1001, 'Forward the Foundation', 1993, 417),
 (1002, 'Foundation', 1951, 255),
 (1003, 'Foundation and Empire', 1952, 247),
 (1004, 'Second Foundation', 1953, 210),
 (1005, 'Foundation''s Edge', 1982, 367),
 (1006, 'Foundation and Earth', 1986, 356),
 (1007, 'Nemesis', 1989, 386),
 (1008, 'Starship Troopers', NULL, NULL),
 (1009, 'Stranger in a Strange Land', NULL, NULL),
 (1010, 'Nightfall', NULL, NULL),
 (1011, 'Nightwings', NULL, NULL),
 (1012, 'Across a Billion Years', NULL, NULL),
 (1013, 'Hyperion', 1989, 482),
 (1014, 'The Fall of Hyperion', 1990, 517),
 (1015, 'Endymion', 1996, 441),
 (1016, 'The Rise of Endymion', 1997, 579),
 (1017, 'Practical Azure SQL Database for Modern Developers', 2020, 326),
 (1018, 'SQL Server 2019 Revealed: Including Big Data Clusters and Machine Learning', 2019, 444),
 (1019, 'Azure SQL Revealed: A Guide to the Cloud for SQL Server Professionals', 2020, 528),
 (1020, 'SQL Server 2022 Revealed: A Hybrid Data Platform Powered by Security, Performance, and Availability', 2022, 506)
SET IDENTITY_INSERT Book OFF
GO

-- Populate authors table
SET IDENTITY_INSERT Author ON
INSERT INTO Author (
  AuthorId, FirstName,  MiddleName, LastName,       Dob,             Email,                     Bio) VALUES
 (1000,     'Isaac',    NULL,       'Asimov',       '1964-08-11',    'iasimov@hotmail.com',     dbo.GetBioUdf()),
 (1001,     'Robert',   'A.',       'Heinlein',     '1989-05-25',    'rheinlein@gmail.com',     dbo.GetBioUdf()),
 (1002,     'Robert',   NULL,       'Silvenberg',   '1973-01-30',    'rsilvenberg@yahoo.com',   dbo.GetBioUdf()),
 (1003,     'Dan',      NULL,       'Simmons',      '1968-02-04',    'dsimmons@hotmail.com',    dbo.GetBioUdf()),
 (1004,     'Davide',   NULL,       'Mauri',        '1992-06-01',    'dmauri@hotmail.com',      dbo.GetBioUdf()),
 (1005,     'Bob',      NULL,       'Ward',         '2001-04-30',    'bward@yahoo.com',         dbo.GetBioUdf()),
 (1006,     'Anna',     NULL,       'Hoffman',      '1998-04-18',    'ahoffman@gmail.com',      dbo.GetBioUdf()),
 (1007,     'Silvano',  NULL,       'Coriani',      '1984-10-26',    'scoriani@gmail.com',      dbo.GetBioUdf()),
 (1008,     'Sanjay',   NULL,       'Mishra',       '1999-01-06',    'smishra@hotmail.com',     dbo.GetBioUdf()),
 (1009,     'Jovan',    NULL,       'Popovic',      '1978-12-10',    'jpopvic@gmail.com',       dbo.GetBioUdf())
SET IDENTITY_INSERT Author OFF
GO

-- Populate many-to-many relationship table joining books to authors
INSERT INTO BookAuthor VALUES
 (1000, 1000),
 (1001, 1000),
 (1002, 1000),
 (1003, 1000),
 (1004, 1000),
 (1005, 1000),
 (1006, 1000),
 (1007, 1000),
 (1010, 1000),
 (1008, 1001),
 (1009, 1001),
 (1011, 1001),
 (1010, 1002),
 (1012, 1002),
 (1017, 1002),
 (1013, 1003),
 (1014, 1003),
 (1015, 1003),
 (1016, 1003),
 (1017, 1004),
 (1018, 1005),
 (1019, 1005),
 (1020, 1005),
 (1017, 1006), 
 (1017, 1007), 
 (1017, 1008), 
 (1017, 1009)

SELECT * FROM Book
SELECT * FROM Author
SELECT * FROM BookAuthor
