USE Library
GO

CREATE OR ALTER PROCEDURE GetBooksCowrittenByAuthor
	@SearchType char(1) = 'C',		-- C = contains; S = starts with
	@Author varchar(max)
AS
BEGIN

	DECLARE @AuthorSearchString varchar(max)

	IF @SearchType = 'C' 
		SET @AuthorSearchString = '%' + @Author + '%'	-- contains
	ELSE IF @SearchType = 'S' 
		SET @AuthorSearchString = @Author + '%'			-- starts with
	ELSE 
		THROW 50000, '@SearchType must be set to "C" or "S"', 16

	;WITH AggregatedAuthorsCte AS
	(
		SELECT 
			ba.BookId,
			STRING_AGG(CONCAT(a.FirstName, ' ', (a.MiddleName + ' '), a.LastName), ', ') AS Authors,
			AuthorCount = COUNT(*)
		FROM
			BookAuthor AS ba 
			INNER JOIN Author AS a ON a.AuthorId = ba.AuthorId
		GROUP BY
			ba.BookId    
	)
	SELECT
		b.BookId,
		b.Title,
		b.Pages,
		b.Year,
		aa.Authors
	FROM
		Book AS b
		INNER JOIN AggregatedAuthorsCte AS aa on b.BookId = aa.BookId
		INNER JOIN BookAuthor AS ba on b.BookId = ba.BookId
		INNER JOIN Author AS a ON a.AuthorId = ba.AuthorId
	WHERE
		aa.AuthorCount > 1 AND (
			CONCAT(a.FirstName, ' ', (a.MiddleName + ' '), a.LastName) LIKE @AuthorSearchString OR
			CONCAT(a.FirstName, ' ', a.LastName) LIKE @AuthorSearchString
		)

END
GO

EXEC GetBooksCowrittenByAuthor @SearchType = 'S', @Author = 'Robert'
EXEC GetBooksCowrittenByAuthor @SearchType = 'S', @Author = 'Asimov'
EXEC GetBooksCowrittenByAuthor @SearchType = 'C', @Author = 'Asimov'
EXEC GetBooksCowrittenByAuthor @SearchType = 'C', @Author = 'Hoffman'
