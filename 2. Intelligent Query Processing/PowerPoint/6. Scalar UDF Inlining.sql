CREATE OR ALTER FUNCTION fnGetCityAverage(@CityKey int)
RETURNS decimal(5, 2)
AS 
BEGIN
	DECLARE @AvgQty decimal(5, 2) = (
		SELECT AVG(CAST(Quantity AS decimal(5, 2)))
		FROM Fact.[Order]
		WHERE [City Key] = @CityKey
	)
	RETURN @AvgQty
END
GO

CREATE OR ALTER FUNCTION fnGetCityRating(@CityKey int)
RETURNS varchar(max) 
AS 
BEGIN
	DECLARE @AvgQty decimal(5, 2) = dbo.fnGetCityAverage(@CityKey)
	DECLARE @Rating varchar(max) =
		IIF(@AvgQty / 40 >= 1,
			'Above Average',
			'Below Average'
		)
	RETURN @Rating
END
GO

CREATE OR ALTER PROCEDURE GetCityAverages
AS
BEGIN

	SELECT
		[City Key],
		City,
		[State Province],
		Average = dbo.fnGetCityAverage([City Key]),
		Rating = dbo.fnGetCityRating([City Key])
	FROM
		Dimension.City
	WHERE
		dbo.fnGetCityAverage([City Key]) IS NOT NULL
	ORDER BY
		City, [State Province]

END

GO

ALTER DATABASE WideWorldImportersDW SET COMPATIBILITY_LEVEL = 140		-- SQL Server 2017
EXEC GetCityAverages

ALTER DATABASE WideWorldImportersDW SET COMPATIBILITY_LEVEL = 150		-- SQL Server 2019
EXEC GetCityAverages
GO

CREATE OR ALTER PROCEDURE GetCityAveragesDoItYourself
AS
BEGIN

	SELECT
		[City Key],
		City,
		[State Province],
		Average = (	SELECT AVG(CAST(Quantity AS decimal(5, 2)))
					FROM Fact.[Order] AS o
					WHERE o.[City Key] = c.[City Key]),
		Rating = IIF((
					SELECT AVG(CAST(Quantity AS decimal(5, 2)))
					FROM Fact.[Order] AS o
					WHERE o.[City Key] = c.[City Key]) / 40 > = 1,
						'Above Average', 'Below Average')
	FROM
		Dimension.City AS c
	WHERE
		(	SELECT AVG(CAST(Quantity AS decimal(5, 2)))
			FROM Fact.[Order] AS o
			WHERE o.[City Key] = c.[City Key]
		) IS NOT NULL
	ORDER BY
		City, [State Province]

END

ALTER DATABASE WideWorldImportersDW SET COMPATIBILITY_LEVEL = 140		-- SQL Server 2017
EXEC GetCityAveragesDoItYourself
GO
