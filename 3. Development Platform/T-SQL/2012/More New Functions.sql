/*--------------------------------------------------------------
  Logical Functions
  --------------------------------------------------------------*/

-- CHOOSE
DECLARE @CardTypeId int = 2  -- Master card
DECLARE @MC varchar(max) = 'MC'

-- ...the longer CASE version
SELECT CardType =
	CASE @CardTypeId
	 WHEN 1 THEN 'Amex'
	 WHEN 2 THEN @MC
	 WHEN 3 THEN 'Visa'
	 WHEN 4 THEN 'Discover' END

-- ...the shorter CHOOSE version
SELECT CardType = CHOOSE(@CardTypeId, 'Amex', @MC, 'Visa', 'Discover')


-- IIF (shorthand CASE statement)
DECLARE @Num1 int = 45
DECLARE @Num2 int = 40

SELECT Result = IIF(@Num1 > @Num2, 'larger', 'not larger' )

-- ...and the longer CASE version:
SELECT Result =
	CASE WHEN @Num1 > @Num2
		THEN 'larger'
		ELSE 'not larger' END


/*--------------------------------------------------------------
  String Functions
  --------------------------------------------------------------*/

-- CONCAT (converts all to string, and treats NULL as empty)
SELECT Greeting = CONCAT('Happy', ' Birthday ', 8, '/', NULL, '30')

-- ...fails because you can't mix data types with the + operator
SELECT Greeting = 'Happy' + ' Birthday ' + 8 + '/' + NULL + '30'

-- ...doesn't fail, but returns null because NULL + anything is always NULL
SELECT Greeting = 'Happy' + ' Birthday ' + CONVERT(varchar, 8) + '/' + NULL + '30'

-- ...this works, but much uglier than CONCAT!
SELECT Greeting =
	ISNULL('Happy', '') +
	ISNULL(' Birthday ', '') +
	ISNULL(CONVERT(varchar, 8), '') +
	ISNULL('/', '') +
	ISNULL(NULL, '') +
	ISNULL('30', '')


-- FORMAT (.NET string formatting)
DECLARE @Cultures table(Culture varchar(10), Lang varchar(50))
INSERT INTO @Cultures VALUES
 ('en', 'English'),
 ('nl', 'Dutch'),
 ('ja', 'Japanese'),
 ('ru', 'Russian'),
 ('no', 'Norwegian')

DECLARE @d datetime2 = DATETIME2FROMPARTS(2011, 2, 1, 16, 5, 0, 0, 7)
DECLARE @m money = 199.99

SELECT
  Lang,
  [Date]   = FORMAT(@d, 'd', Culture),
  TimeOnly = FORMAT(@d, 't', Culture),
  LongDate = FORMAT(@d, 'D', Culture),
  LongTime = FORMAT(@d, 'T', Culture),
  Dow      = FORMAT(@d, 'ddd', Culture),
  Currency = FORMAT(@m, 'c2', Culture)
 FROM
  @Cultures

-- Using SET LANGUAGE to set the default culture
DECLARE @old_lang VARCHAR(32) = @@LANGUAGE
DECLARE @new_lang VARCHAR(32) = 'Dutch'

SELECT FORMAT(DATEFROMPARTS(2011, 2, 1), 'd')
SET LANGUAGE @new_lang
SELECT FORMAT(DATEFROMPARTS(2011, 2, 1), 'd')
SET LANGUAGE @old_lang

-- Careful! Only hard-code individual date & time parts when targeting known cultures!
DECLARE @d datetime2 = DATETIME2FROMPARTS(2011, 2, 1, 16, 5, 0, 0, 7)
SELECT DateAndTime = FORMAT(@d, 'M/d/yyyy')
SELECT DateAndTime = FORMAT(@d, 'ddd M/d/yyyy h:mm tt')
SELECT DateAndTime = FORMAT(@d, 'ddd yyyy-MMM-dd HH:mm')
SELECT DateAndTime = FORMAT(@d, 'dddd MMMM d, yyyy HH:mm')



/*
  -------------------------------------------------------------
  Conversion Functions
  -------------------------------------------------------------
*/

-- CONVERT
SELECT CONVERT(money, 'test') AS BadResult
SELECT CONVERT(money, '29.5') AS GoodResult

-- TRY_CONVERT
SELECT TRY_CONVERT(money, 'test') AS BadResult
SELECT TRY_CONVERT(money, '29.5') AS GoodResult

-- PARSE
SELECT PARSE('Monday, 13 December 2010' AS datetime2 USING 'en-US') AS USResult
SELECT PARSE('1/2/2010' AS datetime2 USING 'en-US') AS NLResult
SELECT PARSE('1/2/2010' AS datetime2 USING 'nl-NL') AS NLResult
SELECT PARSE('�345,98' AS money USING 'nl-NL') AS NLResult
SELECT PARSE('$345,98' AS money USING 'nl-NL') AS NLResult  -- Error, can't parse

-- TRY_PARSE
SELECT TRY_PARSE('$345,98' AS money USING 'nl-NL') AS NLResult  -- NULL, can't parse


/*
  -------------------------------------------------------------
  Date/Time Functions
  -------------------------------------------------------------
*/

-- xxxFROMPARTS
SELECT DATEFROMPARTS(2010, 12, 31) AS ADate
SELECT TIMEFROMPARTS (23, 59, 59, 1234567, 7) AS ATime
SELECT DATETIME2FROMPARTS (2010, 12, 31, 23, 59, 59, 1234567, 7) AS ADateTime2
SELECT DATETIMEOFFSETFROMPARTS (2010, 12, 31, 14, 23, 36, 1234567, 5, 0, 7) ADateTimeOff
SELECT DATETIMEFROMPARTS (2010, 12, 31, 23, 59, 59, 123) AS ADateTime
SELECT SMALLDATETIMEFROMPARTS (2010, 12, 31, 23, 59) AS ASmallDateTime

-- EOMONTH
SELECT DATEADD(DAY, -1, DATEFROMPARTS(2012, 3, 1))
SELECT EOMONTH(DATEFROMPARTS(2012, 2, 1))

SELECT LastDayOfMonth =
		EOMONTH(DATEFROMPARTS(2011, 1, 1)) UNION ALL  -- 31
SELECT	EOMONTH(DATEFROMPARTS(2011, 2, 1)) UNION ALL  -- 28
SELECT	EOMONTH(DATEFROMPARTS(2011, 3, 1)) UNION ALL  -- 31
SELECT	EOMONTH(DATEFROMPARTS(2011, 4, 1)) UNION ALL  -- 30
SELECT	EOMONTH(DATEFROMPARTS(2012, 2, 1))            -- 29 (leap year)

SELECT DaysInFeb2012 = DATEPART(day, EOMONTH('2/1/2012'))


/*
  -------------------------------------------------------------
  Math Functions
  -------------------------------------------------------------
*/

-- LOG and LOG10 give natural and base 10 logarithms
SELECT Result = CONCAT('The natural logarithm of 11 is: ', LOG(11))
SELECT Result = CONCAT('The base 10 logarithm of 11 is: ', LOG10(11))

-- ...to get the logarithm in a different base, division was necessary
SELECT Result = CONCAT('The base 2 logarithm of 11 is: ', LOG(11) / LOG(2))

-- ...2012 adds the base parameter to LOG
SELECT Result = CONCAT('The base 2 logarithm of 11 is: ', LOG(11, 2))
GO
