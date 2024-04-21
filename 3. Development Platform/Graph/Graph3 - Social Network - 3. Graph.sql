/* =================== Graph DB =================== */

/* Social Network - Graph version */

USE MyDB
GO

SET NOCOUNT ON
GO

CREATE SCHEMA g
GO

-- Create node table for entities (friends)

DROP TABLE IF EXISTS g.Friend
CREATE TABLE g.Friend(
	Id int PRIMARY KEY, 
	Name varchar(25)
) AS NODE
GO

-- Populate nodes from relational table
INSERT INTO g.Friend
 SELECT Id, Name
 FROM r.Friend

GO

-- View the node table
SELECT * FROM g.Friend
SELECT $node_id, Id, Name FROM g.Friend

-- Create Edge table for relationships (friend of)

DROP TABLE IF EXISTS g.FriendOf 
CREATE TABLE g.FriendOf AS EDGE
GO

-- Populate edges from relational table
INSERT INTO g.FriendOf
SELECT
	g.Friend.$node_id,
	FriendFriends.$node_id
FROM
	g.Friend 
	INNER JOIN r.FriendOf ON r.FriendOf.Id1 = g.Friend.Id
	INNER JOIN g.Friend AS FriendFriends ON FriendFriends.Id = r.FriendOf.Id2

GO

-- Verify that we have the same number of relationships in graph and relational models (989)
SELECT COUNT(*) FROM r.FriendOf
SELECT COUNT(*) FROM g.FriendOf

-- View the edge table
SELECT * FROM g.FriendOf

-- Find my friends
DECLARE @MyName varchar(max) = 'Lenni'
SELECT
	Me		= Person1.Name,
	Friend	= Person2.Name 
FROM
	g.Friend AS Person1, g.FriendOf,
	g.Friend AS Person2
WHERE
	MATCH(Person1-(FriendOf)->Person2)
	AND Person1.Name = @MyName
ORDER BY
	Friend

GO

-- This is equivalent
DECLARE @MyName varchar(max) = 'Lenni'
SELECT
	Me		= Person1.Name,
	Friend	= Person2.Name 
FROM
	g.Friend AS Person1, g.FriendOf,
	g.Friend AS Person2
WHERE
	MATCH(Person2<-(FriendOf)-Person1)	-- Reversed the node positions and edge direction
	AND Person1.Name = @MyName
ORDER BY
	Friend

GO

-- Find out who friended me
DECLARE @MyName varchar(max) = 'Lenni'
SELECT
	Me		= Person1.Name,
	Person	= Person2.Name 
FROM
	g.Friend AS Person1, g.FriendOf,
	g.Friend AS Person2
WHERE
	MATCH(Person2-(FriendOf)->Person1)
	AND Person1.Name = @MyName
ORDER BY
	Person

GO

-- Find my friends (1), and their friends (2)
DECLARE @MyName varchar(max) = 'Lenni'
SELECT
	Me		= Person1.Name,
	Friend1	= Person2.Name,
	Friend2	= Person3.Name
FROM
	g.Friend AS Person1, g.FriendOf AS FriendOf1,
	g.Friend AS Person2, g.FriendOf AS FriendOf2,
	g.Friend AS Person3
WHERE
	MATCH(Person1-(FriendOf1)->Person2-(FriendOf2)->Person3) 
	AND Person1.Name = @MyName
	AND Person2.Name != @MyName
	AND Person3.Name != @MyName
ORDER BY
	Friend1, Friend2

GO

-- Find my friends (1), their friends (2), and their friends (3)
DECLARE @MyName varchar(max) = 'Lenni'
SELECT
	Me		= Person1.Name,
	Friend1	= Person2.Name,
	Friend2	= Person3.Name,
	Friend3	= Person4.Name
FROM
	g.Friend AS Person1, g.FriendOf AS FriendsOf1,
	g.Friend AS Person2, g.FriendOf AS FriendsOf2,
	g.Friend AS Person3, g.FriendOf AS FriendsOf3,
	g.Friend AS Person4
WHERE
	MATCH(Person1-(FriendsOf1)->Person2-(FriendsOf2)->Person3-(FriendsOf3)->Person4) 
	AND Person1.Name = @MyName
	AND Person2.Name != @MyName
	AND Person3.Name != @MyName
	AND person4.Name != @MyName
ORDER BY
	Friend1, Friend2, Friend3

GO

-- Find my friends (1), their friends (2), their friends (3), and their friends (4)
DECLARE @MyName varchar(max) = 'Lenni'
SELECT
	Me		= Person1.Name,
	Friend1	= Person2.Name,
	Friend2	= Person3.Name,
	Friend3	= Person4.Name,
	Friend4	= Person5.Name
FROM
	g.Friend AS Person1, g.FriendOf AS FriendsOf1,
	g.Friend AS Person2, g.FriendOf AS FriendsOf2,
	g.Friend AS Person3, g.FriendOf AS FriendsOf3,
	g.Friend AS Person4, g.FriendOf AS FriendsOf4,
	g.Friend AS Person5
WHERE
	MATCH(Person1-(FriendsOf1)->Person2-(FriendsOf2)->Person3-(FriendsOf3)->Person4-(FriendsOf4)->Person5) 
	AND Person1.Name = @MyName
	AND Person2.Name != @MyName
	AND Person3.Name != @MyName
	AND Person4.Name != @MyName
	AND Person5.Name != @MyName
	AND Person2.Name != Person5.Name
ORDER BY
	Friend1, Friend2, Friend3, Friend4

GO

-- We could obviously continue to write more complicated queries for next level friendships
-- But what we really want is a way to traverse our nodes as many times as desired in one query
-- This is called "Transitive Closure" and was not available in SQL Server 2017

-- But it's here now in SQL Server 2019!
SELECT 
	Friend1		= Person1.Name,
	Traversal	= STRING_AGG(Person2.Name, ' > ')	WITHIN GROUP (GRAPH PATH),	-- aggregate over the graph path
	FriendN		= LAST_VALUE(Person2.Name)			WITHIN GROUP (GRAPH PATH),	-- last item in the graph path
	LevelCount	= COUNT(Person2.Id)					WITHIN GROUP (GRAPH PATH)	-- number of items in the graph path
FROM
	g.Friend				AS Person1,		-- No FOR PATH b/c we are not parsing calculating the shortest path over this reference in our query
	g.Friend	FOR PATH	AS Person2,		-- FOR PATH b/c we shall be constantly looping over it with the Shortest Path calculations
	g.FriendOf	FOR PATH	AS FriendsOf	-- FOR PATH on our Edge dbo.Follows, since we need to loop over it.
WHERE 
	MATCH(SHORTEST_PATH(Person1(-(FriendsOf)->Person2)+))	-- a person that follows another person, with no limit for the depth search since the Arbitrary Length Pattern is specified with + (plus).
	AND Person1.Name = 'Lenni'

-- Not farther than 2 connections away (10 are 1 away, 29 are 2 away)
;WITH LenniFriendsCte AS (
	SELECT 
		Friend1		= Person1.Name,
		Traversal	= STRING_AGG(Person2.Name, ' > ')	WITHIN GROUP (GRAPH PATH),
		FriendN		= LAST_VALUE(Person2.Name)			WITHIN GROUP (GRAPH PATH),
		LevelCount	= COUNT(Person2.Id)					WITHIN GROUP (GRAPH PATH)
	FROM
		g.Friend				AS Person1,
		g.Friend	FOR PATH	AS Person2,
		g.FriendOf	FOR PATH	AS FriendsOf
	WHERE 
		MATCH(SHORTEST_PATH(Person1(-(FriendsOf)->Person2){1,2}))	-- arbitrary length pattern between 1 and 2
		AND Person1.Name = 'Lenni'
)
SELECT * FROM LenniFriendsCte ORDER BY Friend1, LevelCount, FriendN

-- Find common people who James and I have made friends with
DECLARE @MyName varchar(max) = 'Lenni'
DECLARE @MyFriendsName varchar(max) = 'James'

SELECT
	CommonFriendName = Person2.Name
FROM
	g.Friend AS Person1, g.FriendOf AS FriendsOf1,
	g.Friend AS Person2, g.FriendOf AS FriendsOf2,
	g.Friend AS Person3
WHERE
	MATCH(Person1-(FriendsOf1)->Person2<-(FriendsOf2)-Person3)	-- Person2 is ->"in the middle"<-
	AND Person1.Name = @MyFriendsName
	AND Person3.Name = @MyName
ORDER BY
	CommonFriendName

-- Who has been requesting friendship?
SELECT
	Requested		= Person1.Name,
	Requestor		= Person2.Name
FROM
	g.Friend AS Person1, g.FriendOf,
	g.Friend AS Person2 
WHERE
	MATCH(Person1<-(FriendOf)-Person2)
ORDER BY
	Requested,
	Requestor

-- Who's most popular?
SELECT TOP 10
	Requested		= Person1.Name,
	RequestCount	= COUNT(*)
FROM
	g.Friend AS Person1, g.FriendOf,
	g.Friend AS Person2 
WHERE
	MATCH(Person2-(FriendOf)->Person1)
GROUP BY
	Person1.Name
ORDER BY
	RequestCount DESC,
	Requested
