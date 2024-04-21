CREATE DATABASE MyDB
GO

USE MyDB
GO

-- Both can be used to throw user errors (message 50000) at severity 16 ("red") with an adhoc message description
THROW 50000, 'An error occurred querying the table.', 1;
RAISERROR ('An error occurred querying the table.', 16, 1);

-- RAISERROR supports token substitutions; THROW does not
RAISERROR ('An error occurred querying the %s table.', 16, 1, 'Customer');

-- RAISERROR lets you set the severity; THROW severity is always 16 (unless re-throwing inside CATCH block)
RAISERROR ('A warning occurred querying the table.', 10, 1);   -- 10 and lower are warnings or informationals
RAISERROR ('An error occurred querying the table.', 11, 1);   -- 11 and higher are errors

-- RAISERROR allows you to throw user messages with codes greater than 50000, but requires you to define
-- the message text in sys.messages. THROW does not require and never refers to sys.messages.
RAISERROR(66666, 16, 1, 'cat', 'morris');
EXEC sys.sp_addmessage 66666, 16, 'There is already a %s named %s.';
RAISERROR(66666, 16, 1, 'cat', 'morris');
THROW 66666, 'There is already a cat named morris', 1

-- FORMATMESSAGE workaround for THROW to utilize sys.messages for user errors (> 50000)
DECLARE @Message varchar(max) = FORMATMESSAGE(66666, 'dog', 'snoopy');
THROW 66666, @Message, 1;

-- RAISERROR can raise a system error; THROW cannot
RAISERROR(14088, 16, 1, N'foo');
THROW 14088, N'System error', 1;      -- error, must be 50000 or higher


-- THROW can be used inside a CATCH block to re-throw the same error
CREATE TABLE ErrorLog(OccurredAt datetime2, Severity varchar(max), ErrMsg varchar(max));
GO

CREATE PROCEDURE DivideTheNumbers(@Numerator decimal, @Denominator decimal, @Result decimal OUTPUT)
 AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY 
	  SET @Result = @Numerator / @Denominator;
	END TRY 
	BEGIN CATCH 
	  -- Log the error info, then re-throw it 
	  INSERT INTO ErrorLog VALUES(SYSDATETIME(), ERROR_SEVERITY(), ERROR_MESSAGE()); 
	  THROW;
	END CATCH 
END
GO

DECLARE @Result decimal
EXEC DivideTheNumbers 5, 0, @Result OUTPUT

SELECT * FROM ErrorLog;



-- Cleanup
EXEC sys.sp_dropmessage 66666;
DROP TABLE ErrorLog;
DROP PROCEDURE DivideTheNumbers
