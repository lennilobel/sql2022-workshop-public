/* =================== Graph DB =================== */

SET NOCOUNT OFF
GO

/* Airport demo */

USE MyDB
GO

DROP TABLE IF EXISTS Terminal
DROP TABLE IF EXISTS Gate
DROP TABLE IF EXISTS Restaurant

CREATE TABLE Terminal (
	Name varchar(50),
	CONSTRAINT UC_Terminal_Name UNIQUE (Name)
) AS NODE

CREATE TABLE Gate (
	Name varchar(50),
	CONSTRAINT UC_Gate_Name UNIQUE (Name)
) AS NODE

CREATE TABLE Restaurant (
	Name varchar(50),
	Rating decimal (19, 4),
	AveragePrice decimal (19, 4),
	CONSTRAINT UC_Restaurant_Name UNIQUE (Name)
) AS NODE

INSERT INTO Terminal VALUES
	('Terminal 1'),
	('Terminal 2')

INSERT INTO Gate VALUES
	('Gate T1-1'),
	('Gate T1-2'),
	('Gate T1-3'), 
	('Gate T2-1'),
	('Gate T2-2'),
	('Gate T2-3')

INSERT INTO Restaurant VALUES
	('Wendys', .4, 9.5),
	('McDonalds', .3, 8.15),
	('Chipotle', .5, 12.5), 
	('Jack in the Box', .3, 3.15),
	('Kentucky Fried Chicken', .4, 7.5),
	('Burger King', .2, 7.15)


DROP TABLE IF EXISTS LeadsTo

CREATE TABLE LeadsTo (
	DistanceInMinutes int
) AS EDGE

GO

CREATE OR ALTER PROCEDURE CreateEdgesBothWays
	@SourceTable varchar(max),
	@SourceName varchar(max),
	@TargetTable varchar(max),
	@TargetName varchar(max),
	@DistanceInMinutes int
	AS
BEGIN

	DECLARE @Sql nvarchar(max) = CONCAT(N'
		INSERT INTO LeadsTo ($from_id, $to_id, DistanceInMinutes) VALUES
		(
			(SELECT $node_id FROM ', @SourceTable, ' WHERE Name = @SourceName),
			(SELECT $node_id FROM ', @TargetTable, ' WHERE Name = @TargetName),
			@DistanceInMinutes),
		(
			(SELECT $node_id FROM ', @TargetTable, ' WHERE Name = @TargetName),
			(SELECT $node_id FROM ', @SourceTable, ' WHERE Name = @SourceName),
			@DistanceInMinutes)
	')

	EXECUTE sp_executesql @Sql,
		N'@SourceName varchar(max), @TargetName varchar(max), @DistanceInMinutes int',
			@SourceName = @SourceName,
			@TargetName = @TargetName,
			@DistanceInMinutes = @DistanceInMinutes

END
GO

-- Create edges between terminals and other terminals
EXEC CreateEdgesBothWays 'Terminal', 'Terminal 1', 'Terminal', 'Terminal 2', 10

-- Create edges between terminals and gates
EXEC CreateEdgesBothWays 'Terminal', 'Terminal 1', 'Gate', 'Gate T1-1', 3
EXEC CreateEdgesBothWays 'Terminal', 'Terminal 1', 'Gate', 'Gate T1-2', 5
EXEC CreateEdgesBothWays 'Terminal', 'Terminal 1', 'Gate', 'Gate T1-3', 7
EXEC CreateEdgesBothWays 'Terminal', 'Terminal 2', 'Gate', 'Gate T2-1', 3
EXEC CreateEdgesBothWays 'Terminal', 'Terminal 2', 'Gate', 'Gate T2-2', 5
EXEC CreateEdgesBothWays 'Terminal', 'Terminal 2', 'Gate', 'Gate T2-3', 7

-- Create edges between terminals and restaurants
EXEC CreateEdgesBothWays 'Terminal', 'Terminal 1', 'Restaurant', 'Wendys', 5
EXEC CreateEdgesBothWays 'Terminal', 'Terminal 1', 'Restaurant', 'McDonalds', 7
EXEC CreateEdgesBothWays 'Terminal', 'Terminal 1', 'Restaurant', 'Chipotle', 10
EXEC CreateEdgesBothWays 'Terminal', 'Terminal 2', 'Restaurant', 'Jack in the Box', 5
EXEC CreateEdgesBothWays 'Terminal', 'Terminal 2', 'Restaurant', 'Kentucky Fried Chicken', 7
EXEC CreateEdgesBothWays 'Terminal', 'Terminal 2', 'Restaurant', 'Burger King', 10

-- Create edges between gates and other gates
EXEC CreateEdgesBothWays 'Gate', 'Gate T1-1', 'Gate', 'Gate T1-2', 2
EXEC CreateEdgesBothWays 'Gate', 'Gate T1-2', 'Gate', 'Gate T1-3', 2
EXEC CreateEdgesBothWays 'Gate', 'Gate T2-1', 'Gate', 'Gate T2-2', 2
EXEC CreateEdgesBothWays 'Gate', 'Gate T2-2', 'Gate', 'Gate T2-3', 2

-- Create edges between gates and restaurants
EXEC CreateEdgesBothWays 'Gate', 'Gate T1-1', 'Restaurant', 'Wendys', 2
EXEC CreateEdgesBothWays 'Gate', 'Gate T1-1', 'Restaurant', 'McDonalds', 4
EXEC CreateEdgesBothWays 'Gate', 'Gate T1-1', 'Restaurant', 'Chipotle', 6
EXEC CreateEdgesBothWays 'Gate', 'Gate T1-2', 'Restaurant', 'Wendys', 2
EXEC CreateEdgesBothWays 'Gate', 'Gate T1-2', 'Restaurant', 'McDonalds', 4
EXEC CreateEdgesBothWays 'Gate', 'Gate T1-2', 'Restaurant', 'Chipotle', 6
EXEC CreateEdgesBothWays 'Gate', 'Gate T1-3', 'Restaurant', 'Wendys', 6
EXEC CreateEdgesBothWays 'Gate', 'Gate T1-3', 'Restaurant', 'McDonalds', 4
EXEC CreateEdgesBothWays 'Gate', 'Gate T1-3', 'Restaurant', 'Chipotle', 2
EXEC CreateEdgesBothWays 'Gate', 'Gate T2-1', 'Restaurant', 'Jack in the Box', 2
EXEC CreateEdgesBothWays 'Gate', 'Gate T2-1', 'Restaurant', 'Kentucky Fried Chicken', 4
EXEC CreateEdgesBothWays 'Gate', 'Gate T2-1', 'Restaurant', 'Burger King', 6
EXEC CreateEdgesBothWays 'Gate', 'Gate T2-2', 'Restaurant', 'Jack in the Box', 2
EXEC CreateEdgesBothWays 'Gate', 'Gate T2-2', 'Restaurant', 'Kentucky Fried Chicken', 4
EXEC CreateEdgesBothWays 'Gate', 'Gate T2-2', 'Restaurant', 'Burger King', 6
EXEC CreateEdgesBothWays 'Gate', 'Gate T2-3', 'Restaurant', 'Jack in the Box', 6
EXEC CreateEdgesBothWays 'Gate', 'Gate T2-3', 'Restaurant', 'Kentucky Fried Chicken', 4
EXEC CreateEdgesBothWays 'Gate', 'Gate T2-3', 'Restaurant', 'Burger King', 2

SELECT * FROM Terminal
SELECT * FROM Gate
SELECT * FROM Restaurant

SELECT * FROM LeadsTo

GO

-- View all connections between terminals and other terminals
SELECT
	Point1 = Term1.Name,
	Walk = LeadsTo.DistanceInMinutes,
	Point2 = Term2.Name
FROM
	Terminal AS Term1, LeadsTo, Terminal AS Term2
WHERE
	MATCH(Term1-(LeadsTo)->Term2)

-- View all connections between terminals and gates
SELECT
	Point1 = Terminal.Name,
	Walk = LeadsTo.DistanceInMinutes,
	Point2 = Gate.Name
FROM
	Terminal, LeadsTo, Gate
WHERE
	MATCH(Terminal-(LeadsTo)->Gate)
UNION
SELECT
	Point1 = Gate.Name,
	Walk = LeadsTo.DistanceInMinutes,
	Point2 = Terminal.Name
FROM
	Gate, LeadsTo, Terminal
WHERE
	MATCH(Gate-(LeadsTo)->Terminal)

-- View all connections between terminals and restaurants
SELECT
	Point1 = Terminal.Name,
	Walk = LeadsTo.DistanceInMinutes,
	Point2 = Restaurant.Name
FROM
	Terminal, LeadsTo, Restaurant
WHERE
	MATCH(Terminal-(LeadsTo)->Restaurant)
UNION
SELECT
	Point1 = Restaurant.Name,
	Walk = LeadsTo.DistanceInMinutes,
	Point2 = Terminal.Name
FROM
	Restaurant, LeadsTo, Terminal
WHERE
	MATCH(Restaurant-(LeadsTo)->Terminal)

-- View all connections between gates and other gates
SELECT
	Gate1 = Gate1.Name,
	Walk = LeadsTo.DistanceInMinutes,
	Gate2 = Gate2.Name
FROM
	Gate AS Gate1, LeadsTo, Gate AS Gate2
WHERE
	MATCH(Gate1-(LeadsTo)->Gate2)

-- View all connections between gates and restaurants
SELECT
	Point1 = Gate.Name,
	Walk = LeadsTo.DistanceInMinutes,
	Point2 = Restaurant.Name
FROM
	Gate, LeadsTo, Restaurant
WHERE
	MATCH(Gate-(LeadsTo)->Restaurant)
UNION
SELECT
	Point2 = Restaurant.Name,
	Walk = LeadsTo.DistanceInMinutes,
	Point1 = Gate.Name
FROM
	Restaurant, LeadsTo, Gate
WHERE
	MATCH(Restaurant-(LeadsTo)->Gate)
ORDER BY
	Point1, Point2

-- Arrive at Gate T1-2
-- Depart from Gate T2-3
-- First eat (rating > 3), then switch terminals
SELECT
	ArrivalGate = ArrivalGate.Name,				ArrivalGateTo = ArrivalGateTo.DistanceInMinutes,
	Restaurant = Restaurant.Name,				RestaurantTo = RestaurantTo.DistanceInMinutes,
	ArrivalTerminal = ArrivalTerminal.Name,		ArrivalTerminalTo = ArrivalTerminalTo.DistanceInMinutes,
	DepartureTerminal = DepartureTerminal.Name,	DepartureTerminalTo = DepartureTerminalTo.DistanceInMinutes,
	DepartureGate = DepartureGate.Name,
	TotalDistanceInMinutes =
		ArrivalGateTo.DistanceInMinutes +
		RestaurantTo.DistanceInMinutes +
		ArrivalTerminalTo.DistanceInMinutes +
		DepartureTerminalTo.DistanceInMinutes
FROM
	Gate AS ArrivalGate,			LeadsTo AS ArrivalGateTo,
	Restaurant,						LeadsTo AS RestaurantTo,
	Terminal AS ArrivalTerminal,	LeadsTo AS ArrivalTerminalTo,
	Terminal AS DepartureTerminal,	LeadsTo AS DepartureTerminalTo,
	Gate AS DepartureGate
WHERE
	MATCH(
		ArrivalGate-(ArrivalGateTo)->
		Restaurant-(RestaurantTo)->
		ArrivalTerminal-(ArrivalTerminalTo)->
		DepartureTerminal-(DepartureTerminalTo)->
		DepartureGate
	)
	AND ArrivalGate.Name = 'Gate T1-2'
	AND Restaurant.Rating > .3
	AND DepartureGate.Name = 'Gate T2-3'


-- Arrive at Gate T1-2
-- Depart from Gate T2-3
-- First switch terminals, then eat (rating > 2)
SELECT
	ArrivalGate = ArrivalGate.Name,				ArrivalGateTo = ArrivalGateTo.DistanceInMinutes,
	ArrivalTerminal = ArrivalTerminal.Name,		ArrivalTerminalTo = ArrivalTerminalTo.DistanceInMinutes,
	DepartureTerminal = DepartureTerminal.Name,	DepartureTerminalTo = DepartureTerminalTo.DistanceInMinutes,
	Restaurant = Restaurant.Name,				RestaurantTo = RestaurantTo.DistanceInMinutes,
	DepartureGate = DepartureGate.Name,
	TotalDistanceInMinutes =
		ArrivalGateTo.DistanceInMinutes +
		ArrivalTerminalTo.DistanceInMinutes +
		RestaurantTo.DistanceInMinutes +
		DepartureTerminalTo.DistanceInMinutes
FROM
	Gate AS ArrivalGate,			LeadsTo AS ArrivalGateTo,
	Terminal AS ArrivalTerminal,	LeadsTo AS ArrivalTerminalTo,
	Terminal AS DepartureTerminal,	LeadsTo AS DepartureTerminalTo,
	Restaurant,						LeadsTo AS RestaurantTo,
	Gate AS DepartureGate
WHERE
	MATCH(
		ArrivalGate-(ArrivalGateTo)->
		ArrivalTerminal-(ArrivalTerminalTo)->
		DepartureTerminal-(DepartureTerminalTo)->
		Restaurant-(RestaurantTo)->
		DepartureGate
	)
	AND ArrivalGate.Name = 'Gate T1-2'
	AND Restaurant.Rating > .2
	AND DepartureGate.Name = 'Gate T2-3'
