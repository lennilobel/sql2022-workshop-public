USE MyDB
GO

-- Populate a local table of flights
CREATE TABLE Flight (
	FlightId int PRIMARY KEY,
	FromAirport char(3),
	ToAirport char(3)
)

INSERT INTO Flight VALUES
 (1, 'JFK', 'LAX'),
 (2, 'LGA', 'LAS'),
 (3, 'EWR', 'SEA')

SELECT * FROM Flight

-- List all our tasks in Mongo DB, with flight info in local database, and airport name in Azure Blob Storage
SELECT
	TaskId		= t._id,
	FlightId	= t.flightId,
	TaskName	= t.name,
	DueOn		= t.dueDate,		
	DestCode	= f.ToAirport,
	DestAirport	= a.Description
FROM
	Task AS t											--  <- from Mongo DB collection in Cosmos DB
	INNER JOIN Flight AS f ON f.FlightId = t.flightId	--  <- from table in local SQL Server database
	INNER JOIN Airport AS a ON a.Code = f.ToAirport		--  <- from CSV file in Azure Blob Storage
ORDER BY
	t.dueDate

-- List all our flights in the local database, with tasks in Mongo DB embedded as JSON, and from/to airport names in Azure Blob Storage
SELECT
	f.FlightId,
	FromAirportCode	= f.FromAirport,
	FromAirportName	= fa.Description,
	ToAirportCode	= f.ToAirport,
	ToAirportName	= ta.Description,
	Tasks = (
		SELECT t.dueDate, t.name
		FROM Task AS t
		WHERE f.FlightId = t.flightId
		ORDER BY t.dueDate
		FOR JSON AUTO
	)
FROM
	Flight AS f
	INNER JOIN Airport AS fa ON fa.Code = f.FromAirport
	INNER JOIN Airport AS ta ON ta.Code = f.ToAirport
ORDER BY
	f.FlightId
