/* =================== STRING_ESCAPE =================== */

-- (show results as text)

CREATE DATABASE MyDB
GO

USE MyDB
GO

DECLARE @MyString varchar(max) = 'The "name" and/or C:\Demo with a tab:	 and
newline:';

SELECT @MyString
SELECT STRING_ESCAPE(@MyString, 'json')

