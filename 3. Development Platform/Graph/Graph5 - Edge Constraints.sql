USE MyDB
GO


-- Create a node table for administrators
CREATE TABLE Administrators (
	AdministratorId int PRIMARY KEY,
	AdministratorName varchar(100)
) AS NODE

INSERT INTO Administrators VALUES (1, 'Lenni')
SELECT * FROM Administrators


-- Create a node table for users
CREATE TABLE Users (
	UserId int PRIMARY KEY,
	Username varchar(100)
) AS NODE

INSERT INTO Users VALUES (1, 'Mark'), (2, 'Adam')
SELECT * FROM Users


-- Create an edge table for authorizations from administrators to users
CREATE TABLE Authorizations AS EDGE


-- We want to permit an authorization edge from administrators to users
INSERT INTO Authorizations ($from_id, $to_id) VALUES (
	(SELECT $node_id FROM Administrators WHERE AdministratorName = 'Lenni'),
	(SELECT $node_id FROM Users WHERE Username = 'Mark'))

-- We don't want to permit an authorization edge from users to administrators, but before 2019, we couldn't enforce that
INSERT INTO Authorizations ($from_id, $to_id) VALUES (
	(SELECT $node_id FROM Users WHERE Username = 'Adam'),
	(SELECT $node_id FROM Administrators WHERE AdministratorName = 'Lenni'))

SELECT * FROM Authorizations


-- Recreate the edge table with a constraint on permitted connections
DROP TABLE Authorizations
CREATE TABLE Authorizations (
	CONSTRAINT EC_Authorizations CONNECTION (
		Administrators TO Users
	)
)
AS EDGE


-- Can still connect administrators to users
INSERT INTO Authorizations ($from_id, $to_id) VALUES (
	(SELECT $node_id FROM Administrators WHERE AdministratorName = 'Lenni'),
	(SELECT $node_id FROM Users WHERE Username = 'Mark'))

-- But can no longer connect users to administrators
INSERT INTO Authorizations ($from_id, $to_id) VALUES (
	(SELECT $node_id FROM Users WHERE Username = 'Adam'),
	(SELECT $node_id FROM Administrators WHERE AdministratorName = 'Lenni'))

SELECT * FROM Authorizations


-- Create a node table for groups
CREATE TABLE Groups (
	GroupId int PRIMARY KEY,
	GroupName varchar(100)
) AS NODE

INSERT INTO Groups VALUES (1, 'ReadGroup')
SELECT * FROM Groups


-- Create an edge table for group membership with constraint for Users to Groups
CREATE TABLE Membership (
	CONSTRAINT EC_Membership CONNECTION (
		Users TO Groups
	)
)
AS EDGE

-- Can connect users to groups on the membership edge
INSERT INTO Membership ($from_id, $to_id) VALUES (
	(SELECT $node_id FROM Users WHERE UserName = 'Mark'),
	(SELECT $node_id FROM Groups WHERE GroupName = 'ReadGroup'))

-- Can't connect administrators to users on the membership edge
INSERT INTO Membership ($from_id, $to_id) VALUES (
	(SELECT $node_id FROM Administrators WHERE AdministratorName = 'Lenni'),
	(SELECT $node_id FROM Users WHERE UserName = 'Mark'))

-- Can't connect administrators to groups
INSERT INTO Authorizations ($from_id, $to_id) VALUES (
	(SELECT $node_id FROM Administrators WHERE AdministratorName = 'Lenni'),
	(SELECT $node_id FROM Groups WHERE GroupName = 'ReadGroup'))


-- Let's adjust the edge table constraints so that we can
ALTER TABLE Authorizations DROP CONSTRAINT EC_Authorizations

ALTER TABLE Authorizations ADD
	CONSTRAINT EC_Authorizations CONNECTION (
		Administrators TO Users,
		Administrators TO Groups
	)


-- Now we can create an edge from administrators to groups
INSERT INTO Authorizations ($from_id, $to_id) VALUES (
	(SELECT $node_id FROM Administrators WHERE AdministratorName = 'Lenni'),
	(SELECT $node_id FROM Groups WHERE GroupName = 'ReadGroup'))

-- But still no other disallowed connections; e.g., groups to users
INSERT INTO Authorizations ($from_id, $to_id) VALUES (
	(SELECT $node_id FROM Users WHERE Username = 'Mark'),
	(SELECT $node_id FROM Groups WHERE GroupName = 'ReadGroup'))


-- Delete user 1
SELECT * FROM Users		-- User 0 is referenced in both edge tables

-- Can delete user not referenced by any edge
DELETE FROM Users WHERE Username = 'Adam'

-- Can't delete user referenced by edge
DELETE FROM Users WHERE Username = 'Mark'

-- Delete references in the membership edge table
DELETE FROM Membership WHERE $from_id = (SELECT $node_id FROM Users WHERE Username = 'Mark')

-- Can't delete; user is still referenced by the authorizations edge table
DELETE FROM Users WHERE Username = 'Mark'

-- Delete references in the authorizations edge table
DELETE FROM Authorizations WHERE $to_id = (SELECT $node_id FROM Users WHERE Username = 'Mark')

-- Can now delete the user
DELETE FROM Users WHERE Username = 'Mark'


-- Cleanup

DROP TABLE IF EXISTS Membership
DROP TABLE IF EXISTS Authorizations
DROP TABLE IF EXISTS Administrators
DROP TABLE IF EXISTS Groups
DROP TABLE IF EXISTS Users
