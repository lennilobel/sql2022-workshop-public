/* =================== SESSION_CONTEXT =================== */

USE MyDB
GO

CREATE PROCEDURE DoThis AS
BEGIN
	DECLARE @UsRegion varchar(20) = CONVERT(varchar(20), SESSION_CONTEXT(N'UsRegion'))
	SELECT DoThis = @UsRegion
END
GO

CREATE PROCEDURE DoThat AS
BEGIN
	DECLARE @UsRegion varchar(20)
	SET @UsRegion = CONVERT(varchar(20), SESSION_CONTEXT(N'UsRegion'))
	SELECT DoThat = @UsRegion
END
GO

EXEC DoThis
EXEC DoThat

EXEC sp_set_session_context @key = N'UsRegion', @value = N'Southwest'
EXEC sp_set_session_context @key = N'UsRegion', @value = N'Northeast'
EXEC sp_set_session_context @key = N'UsRegion', @value = N'Southeast', @read_only = 1
EXEC sp_set_session_context @key = N'UsRegion', @value = N'Northwest'

DROP PROCEDURE IF EXISTS DoThis
DROP PROCEDURE IF EXISTS DoThat
