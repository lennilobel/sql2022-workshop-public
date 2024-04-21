/* =================== Graph DB =================== */

/* Social Network - Relational version */

USE MyDB
GO

-- Find my friends
DECLARE @MyName varchar(max) = 'Lenni'
SELECT
	Me		= r.Friend.Name,
	Friend	= FriendNames.Name
FROM
	r.Friend   
	INNER JOIN r.FriendOf ON r.FriendOf.Id1 = r.Friend.Id
	INNER JOIN r.Friend AS FriendNames ON FriendNames.Id = r.FriendOf.Id2
WHERE
	r.Friend.Name = @MyName
ORDER BY
	Friend

GO

-- Find out who friended me
DECLARE @MyName varchar(max) = 'Lenni'
SELECT
	Me		= r.Friend.Name,
	Person	= FriendNames.Name
FROM
	r.Friend   
	INNER JOIN r.FriendOf ON r.FriendOf.Id2 = r.Friend.Id					--	\__ swap Id1 and Id2 to
	INNER JOIN r.Friend AS FriendNames ON FriendNames.Id = r.FriendOf.Id1	--	/    "reverse the edge"
WHERE
	r.Friend.Name = @MyName
ORDER BY
	Person

GO

-- Find my friends (1), and their friends (2)
DECLARE @MyName varchar(max) = 'Lenni'
;WITH MyFriends1Cte (Friend, Id) AS (
	SELECT
		Friend	= FriendNames.Name,
		Id		= FriendNames.Id
	FROM
		r.Friend
		INNER JOIN r.FriendOf ON r.FriendOf.Id1 = r.Friend.Id
		INNER JOIN r.Friend AS FriendNames ON FriendNames.Id = r.FriendOf.Id2
	WHERE
		r.Friend.Name = @MyName
)
SELECT
	Me		= @MyName,
	Friend1	= MyFriends1Cte.Friend,
	Friend2	= r.Friend.Name
FROM
	MyFriends1Cte
	INNER JOIN r.FriendOf ON r.FriendOf.Id1 = MyFriends1Cte.Id
	INNER JOIN r.Friend ON r.Friend.Id = r.FriendOf.Id2
ORDER BY
	Friend1, Friend2

GO

-- Find my friends (1), their friends (2), and their friends (3)
DECLARE @MyName varchar(max) = 'Lenni'
;WITH
MyFriends1Cte (Friend, Id) AS (
	SELECT
		Friend	= FriendNames.Name,
		Id		= FriendNames.Id
	FROM
		r.Friend
		INNER JOIN r.FriendOf ON r.FriendOf.Id1 = r.Friend.Id
		INNER JOIN r.Friend AS FriendNames ON FriendNames.Id = r.FriendOf.Id2
	WHERE
		r.Friend.Name = @MyName
), 
MyFriends2Cte (Friend1, Friend2, Id) AS (
	SELECT
		Friend1	= MyFriends1Cte.Friend,
		Friend2	= r.Friend.Name,
		Id		= r.Friend.Id
	FROM
		MyFriends1Cte
		INNER JOIN r.FriendOf ON r.FriendOf.Id1 = MyFriends1Cte.Id
		INNER JOIN r.Friend ON r.Friend.Id = r.FriendOf.Id2
	WHERE
		r.Friend.Name != @MyName 
)
SELECT
	Me		= @MyName,
	Friend1	= MyFriends2Cte.Friend1,
	Friend2	= MyFriends2Cte.Friend2,
	Friend3	= r.Friend.Name
FROM
	MyFriends2Cte
	INNER JOIN r.FriendOf ON r.FriendOf.Id1 = MyFriends2Cte.Id
	INNER JOIN r.Friend ON r.Friend.Id = r.FriendOf.Id2
WHERE
	r.Friend.Name != @MyName AND
	r.Friend.Name != MyFriends2Cte.Friend1
ORDER BY
	Friend1, Friend2, Friend3

GO

-- Find my friends (1), their friends (2), their friends (3), and their friends (4)
DECLARE @MyName varchar(max) = 'Lenni'
;WITH
MyFriends1Cte (Friend, Id) AS (
	SELECT
		Friend	= FriendNames.Name,
		Id		= FriendNames.Id
	FROM
		r.Friend
		INNER JOIN r.FriendOf ON r.FriendOf.Id1 = r.Friend.Id
		INNER JOIN r.Friend AS FriendNames ON FriendNames.Id = r.FriendOf.Id2
	WHERE
		r.Friend.Name = @MyName
),
MyFriends2Cte (Friend1, Friend2, Id) AS (
	SELECT
		Friend1	= MyFriends1Cte.Friend,
		Friend2	= r.Friend.Name,
		Id		= r.Friend.Id
	FROM
		r.FriendOf 
		INNER JOIN MyFriends1Cte ON r.FriendOf.Id1 = MyFriends1Cte.Id
		INNER JOIN r.Friend ON r.FriendOf.Id2 = r.Friend.Id
	WHERE
		r.Friend.Name != @MyName 
),
MyFriends3Cte (Friend1, Friend2, Friend3, Id) AS (
	SELECT
		Friend1	= MyFriends2Cte.Friend1,
		Friend2	= MyFriends2Cte.Friend2,
		Friend3	= r.Friend.Name,
		Id		= r.Friend.Id
	FROM
		MyFriends2Cte
		INNER JOIN r.FriendOf ON r.FriendOf.Id1 = MyFriends2Cte.Id
		INNER JOIN r.Friend ON r.Friend.Id = r.FriendOf.Id2
	WHERE
		r.Friend.Name != @MyName AND
		r.Friend.Name != MyFriends2Cte.Friend1
)
SELECT
	Me		= @MyName,
	Friend1	= MyFriends3Cte.Friend1,
	Friend2	= MyFriends3Cte.Friend2,
	Friend3	= MyFriends3Cte.Friend3,
	Friend4	= r.Friend.Name
FROM
	MyFriends3Cte
	INNER JOIN r.FriendOf ON r.FriendOf.Id1 = MyFriends3Cte.Id
	INNER JOIN r.Friend ON r.Friend.Id = r.FriendOf.Id2
WHERE
	r.Friend.Name != @MyName AND
	r.Friend.Name != MyFriends3Cte.Friend1 AND
	r.Friend.Name != MyFriends3Cte.Friend2
ORDER BY
	Friend1, Friend2, Friend3, Friend4
GO

-- Find common people who James and I have made friends with
DECLARE @MyName varchar(max) = 'Lenni'
DECLARE @MyFriendsName varchar(max) = 'James'

SELECT
	CommonFriendName = FriendNames.Name
FROM
	r.Friend   
	INNER JOIN r.FriendOf ON r.Friend.Id = r.FriendOf.Id1 
	INNER JOIN r.Friend AS FriendNames ON r.FriendOf.Id2 = FriendNames.Id
WHERE
	r.Friend.Name = @MyName  -- My friends

INTERSECT  -- Intersection of my friends AND my friend's friends

SELECT
	CommonFriendName = FriendNames.Name
FROM
	r.Friend   
	INNER JOIN r.FriendOf ON r.Friend.Id = r.FriendOf.Id1 
	INNER JOIN r.Friend AS FriendNames ON r.FriendOf.Id2 = FriendNames.Id
WHERE
	r.Friend.Name = @MyFriendsName	-- My friend's friends
ORDER BY
	CommonFriendName

-- Who has been requesting friendship?
SELECT
	Requested	= FriendNames.Name,
	Requestor	= r.Friend.Name
FROM
	r.Friend   
	INNER JOIN r.FriendOf ON r.Friend.Id = r.FriendOf.Id1 
	INNER JOIN r.Friend AS FriendNames ON r.FriendOf.Id2 = FriendNames.Id
ORDER BY
	Requested,
	Requestor

-- Who's most popular?
SELECT TOP 10
	Requested		= FriendNames.Name,
	RequestCount	= COUNT(*)
FROM
	r.Friend   
	INNER JOIN r.FriendOf ON r.Friend.Id = r.FriendOf.Id1 
	INNER JOIN r.Friend AS FriendNames ON r.FriendOf.Id2 = FriendNames.Id
GROUP BY
	FriendNames.Name
ORDER BY
	RequestCount DESC,
	Requested
