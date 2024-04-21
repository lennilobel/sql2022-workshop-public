USE Library
GO

CREATE TABLE Branch
(
    BranchId int IDENTITY PRIMARY KEY,
    BranchName varchar(50),
    ManagerName varchar(50)
)

SET IDENTITY_INSERT Branch ON
INSERT Branch (BranchId, BranchName, ManagerName) VALUES 
	(1, 'Battery Park City Library', 'jim.librarian@dablibrary.onmicrosoft.com'), 
	(2, 'Columbus Library', 'jane.librarian@dablibrary.onmicrosoft.com'), 
	(3, 'Riverside Library', 'jim.librarian@dablibrary.onmicrosoft.com'),
	(4, 'Bloomingdale Library', 'sam.librarian@dablibrary.onmicrosoft.com'), 
	(5, '58th Street Library', 'jim.librarian@dablibrary.onmicrosoft.com'), 
	(6, 'Hamiltone Library', 'jane.librarian@dablibrary.onmicrosoft.com')
SET IDENTITY_INSERT Branch OFF
GO

CREATE FUNCTION BranchManagerPredicate(@Username varchar(max))
    RETURNS TABLE
    WITH SCHEMABINDING
AS
    RETURN
		SELECT
			1 AS result
		WHERE
			CONVERT(varchar(max), SESSION_CONTEXT(N'preferred_username')) = @Username
GO

CREATE SECURITY POLICY BranchManagerPolicy
    ADD FILTER PREDICATE dbo.BranchManagerPredicate(ManagerName) ON dbo.Branch,
    ADD BLOCK PREDICATE dbo.BranchManagerPredicate(ManagerName) ON dbo.Branch AFTER INSERT,
    ADD BLOCK PREDICATE dbo.BranchManagerPredicate(ManagerName) ON dbo.Branch AFTER UPDATE
    WITH (STATE = ON)

SELECT * FROM Branch
SELECT COUNT(*) FROM Branch
GO

EXEC sp_set_session_context @key = N'preferred_username', @value = 'jim.librarian@dablibrary.onmicrosoft.com'
SELECT * FROM Branch
SELECT COUNT(*) FROM Branch
GO

EXEC sp_set_session_context @key = N'preferred_username', @value = 'jane.librarian@dablibrary.onmicrosoft.com'
SELECT * FROM Branch
SELECT COUNT(*) FROM Branch
GO

EXEC sp_set_session_context @key = N'preferred_username', @value = 'joe.reader@dablibrary.onmicrosoft.com', @readonly=1
SELECT * FROM Branch
SELECT COUNT(*) FROM Branch
GO

CREATE OR ALTER PROCEDURE GetSessionContextValues
AS
BEGIN

	SELECT
		CONVERT(varchar(max), SESSION_CONTEXT(N'aud'))					AS aud,
		CONVERT(varchar(max), SESSION_CONTEXT(N'iss'))					AS iss,
		CONVERT(varchar(max), SESSION_CONTEXT(N'name'))					AS name,
		CONVERT(varchar(max), SESSION_CONTEXT(N'preferred_username'))	AS preferred_username,
		CONVERT(varchar(max), SESSION_CONTEXT(N'roles'))				AS roles,
		CONVERT(varchar(max), SESSION_CONTEXT(N'scp'))					AS scp

END
GO

EXEC GetSessionContextValues
