/* =================== TRANSLATE =================== */

USE MyDB
GO

-- REPLACE ( string_expression, string_pattern, string_replacement)
--   vs.
-- TRANSLATE ( inputString, characters, translations)

-- Same behavior
GO
DECLARE @Sample varchar(max) = 'Easy as 123!'
SELECT 
    REPLACE(@Sample, '123', '456') AS [REPLACE],		-- Easy as 456!		123=456
    TRANSLATE(@Sample, '123', '456') AS [TRANSLATE]		-- Easy as 456!		1=4, 2=5, 3=6

-- Different behavior
GO
DECLARE @Sample varchar(max) = 'Easy as 123!'
SELECT 
    REPLACE(@Sample, '321', '456') AS [REPLACE],		-- Easy as 123!		321=not found (no replacement)
    TRANSLATE(@Sample, '321', '456') AS [TRANSLATE]		-- Easy as 654!		1=6, 2=5, 3=4

-- Simplified single-character replacements
GO
DECLARE @Sample varchar(max) = '2 * [3 + 4] / {{ 7 - 2 } + [ 4 * 2 })'
SELECT 
    REPLACE(REPLACE(REPLACE(REPLACE(@Sample,'[','('), ']', ')'), '{', '('), '}', ')') AS [REPLACE],
    TRANSLATE(@Sample, '[]{}', '()()') AS [TRANSLATE]

