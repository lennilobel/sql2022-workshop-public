/* =================== Date and Time Types =================== */

USE MyDb
GO

-- Separate Date and Time types
DECLARE @DOB date
DECLARE @MedsAt time(0)

SET @DOB = '2008-03-24'
SET @MedsAt = '13:00:00'

SELECT @DOB AS DOB, @MedsAt AS MedsAt

/* Extract date or time on indexed datetime2 type */
CREATE TABLE DateList(MyDate datetime2)
CREATE CLUSTERED INDEX idx1 ON DateList(MyDate);

-- Insert some rows in to dbo.Search...
INSERT INTO DateList VALUES
 ('2011-10-10 12:15:00'), ('2011-10-10 09:00:00'), ('2011-10-10 12:15:00'), ('2011-10-10 12:15:00'),
 ('2011-10-10 12:15:00'), ('2011-10-10 12:15:00'), ('2011-10-10 12:15:00'), ('2011-10-10 12:15:00'),
 ('2011-10-10 12:15:00'), ('2011-10-10 12:15:00'), ('2011-10-10 12:15:00'), ('2011-10-11 09:00:00')

SELECT MyDate FROM DateList
 WHERE MyDate = '2011-10-10 12:15:00';

SELECT MyDate FROM DateList
 WHERE CONVERT(time(0), MyDate) = '09:00:00';

SELECT MyDate FROM DateList
 WHERE CONVERT(date, MyDate) = '2011-10-11';

DROP TABLE DateList

-- Time zone awareness
DECLARE @Time1 datetimeoffset
DECLARE @Time2 datetimeoffset
DECLARE @MinutesDiff int

SET @Time1 = '2011-10-10 09:15:00-05:00'  -- NY time is UTC -05:00
SET @Time2 = '2011-10-10 10:30:00-08:00'  -- LA time is UTC -08:00

SET @MinutesDiff = DATEDIFF(minute, @Time1, @Time2)

SELECT @MinutesDiff

-- Date/time functions added in SQL Server 2008
SET NOCOUNT ON
SELECT GETDATE() AS 'GETDATE() datetime'
SELECT GETUTCDATE() AS 'GETUTCDATE() datetime'
SELECT SYSDATETIME() AS 'SYSDATETIME() datetime2'
SELECT SYSUTCDATETIME() AS 'SYSUTCDATETIME() datetime2'
SELECT SYSDATETIMEOFFSET() AS 'SYSDATETIMEOFFSET() datetimeoffset'

SET NOCOUNT ON
DECLARE @TimeInNY datetimeoffset
SET @TimeInNY = SYSDATETIMEOFFSET()

-- Show the current time in NY
SELECT @TimeInNY AS 'Time in NY'

-- DATEPART with tz gets the time-zone value
SELECT DATEPART(tz, @TimeInNY) AS 'NY Time Zone Value'

-- DATENAME with tz gets the time-zone string 
SELECT DATENAME(tz, @TimeInNY) AS 'NY Time Zone String'

-- Both DATEPART and DATENAME with mcs gets the microseconds
SELECT DATEPART(mcs, @TimeInNY) AS 'NY Time Microseconds'

-- Both DATEPART and DATENAME with ns gets the nanoseconds
SELECT DATEPART(ns, @TimeInNY) AS 'NY Time Nanoseconds'


/* Time zone offset manipulation with TODATETIMEOFFSET and SWITCHOFFSET */

SET NOCOUNT ON
DECLARE @TheTime datetime2
DECLARE @TheTimeInNY datetimeoffset
DECLARE @TheTimeInLA datetimeoffset

-- Hold a time that doesn't specify a time zone
SET @TheTime = '2011-11-10 7:35PM'

-- Convert it into one that specifies time zone for New York
SET @TheTimeInNY = TODATETIMEOFFSET(@TheTime, '-05:00')

-- Calculate the equivalent time in Los Angeles
SET @TheTimeInLA = SWITCHOFFSET(@TheTimeInNY , '-08:00')

SELECT @TheTime AS 'Any Time'
SELECT @TheTimeInNY AS 'NY Time'
SELECT @TheTimeInLA AS 'LA Time'


-- Times with no time zone information
CREATE TABLE TimeZoneTest1(TheTime datetime2(0))
INSERT INTO TimeZoneTest1 VALUES('2008-02-25 09:15:00')
INSERT INTO TimeZoneTest1 VALUES('2008-02-28 16:30:00')
INSERT INTO TimeZoneTest1 VALUES('2008-03-10 23:45:00')
INSERT INTO TimeZoneTest1 VALUES('2008-03-12 18:00:00')

-- Target table will get time zones
CREATE TABLE TimeZoneTest2(TheTime datetimeoffset(0))

-- Copy from plain datetime2 to datetimeoffset, using NY time
INSERT INTO TimeZoneTest2(TheTime)
 SELECT TODATETIMEOFFSET(TheTime, '-05:00') FROM TimeZoneTest1
 
SELECT * FROM TimeZoneTest1
SELECT * FROM TimeZoneTest2

-- Insert a California time
INSERT INTO TimeZoneTest2 VALUES('2008-03-15 17:15:00-08:00')
SELECT * FROM TimeZoneTest2

-- Show all the times in NY time
SELECT SWITCHOFFSET(TheTime, '-05:00') FROM TimeZoneTest2

-- Show all the times in Paris time
SELECT SWITCHOFFSET(TheTime, '+01:00') FROM TimeZoneTest2

DROP TABLE TimeZoneTest1
DROP TABLE TimeZoneTest2

