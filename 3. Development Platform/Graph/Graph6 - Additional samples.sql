/* =================== Graph DB =================== */

SET NOCOUNT OFF
GO


/* Discover metadata */

SELECT
	t.object_id,
	schema_name = SCHEMA_NAME(t.schema_id),
	table_name = t.name,
	t.is_node,
	t.is_edge,
	column_name = c.name,
	c.is_hidden,
	c.graph_type_desc
FROM
	sys.columns AS c
	INNER JOIN sys.tables AS t ON t.object_id = c.object_id
ORDER BY
	t.name,
	c.column_id


/* Breaking down node and edge IDs */

-- OBJECT_ID_FROM_NODE_ID - Return the node's object_id (i.e.; the node table)
SELECT OBJECT_ID_FROM_NODE_ID('{"type":"node","schema":"dbo","table":"Person","id":0}')
SELECT OBJECT_NAME(OBJECT_ID_FROM_NODE_ID('{"type":"node","schema":"dbo","table":"Person","id":0}'))

-- GRAPH_ID_FROM_NODE_ID - Return the node's graph id
SELECT GRAPH_ID_FROM_NODE_ID('{"type":"node","schema":"dbo","table":"Person","id":1}')

-- NODE_ID_FROM_PARTS - Build a node from an object_id (i.e., the node table) and a graph id
DECLARE @PersonObjectId int = (SELECT object_id FROM sys.tables WHERE name = 'Person')
DECLARE @GraphId int = 2
SELECT NODE_ID_FROM_PARTS(@PersonObjectId, @GraphId)

-- OBJECT_ID_FROM_EDGE_ID - Return the edge's object_id (i.e., the edge table)
SELECT OBJECT_ID_FROM_EDGE_ID('{"type":"edge","schema":"dbo","table":"FriendOf","id":1}')
SELECT OBJECT_NAME(OBJECT_ID_FROM_EDGE_ID('{"type":"edge","schema":"dbo","table":"FriendOf","id":1}'))

-- GRAPH_ID_FROM_EDGE_ID - Return the edge's graph id
SELECT GRAPH_ID_FROM_EDGE_ID('{"type":"edge","schema":"dbo","table":"FriendOf","id":1}')

-- EDGE_ID_FROM_PARTS - Build an edge from an object_id (i.e., the edge table) and a graph id
DECLARE @FriendOrObjectId int = (SELECT object_id FROM sys.tables WHERE name = 'FriendOf')
DECLARE @GraphId int = 2
SELECT EDGE_ID_FROM_PARTS(@FriendOrObjectId, @GraphId)


/* Family Tree example */

USE MyDB
GO

DROP TABLE IF EXISTS Family
GO

CREATE TABLE Family (  
   FamilyId int NOT NULL,
   LastName varchar(40) NOT NULL,
   ParentFamilyId int,
   YearOfBirth int,
   INUM int)	
GO

INSERT INTO Family VALUES
 (10000, 'William', NULL,   1850, 1),
 (140000,'ALLEN',   10000,  1877, 1),
 (60000, 'ROBINSON',140000, 1902, 1),
 (70000, 'DAVIS',   140000, 1903, 1),
 (80000, 'ADAM',    140000, 1904, 1),
 (90000, 'SCOTT',   140000, 1905, 1),
 (100000,'NELSON',  140000, 1906, 1),
 (20000, 'GONZALEZ',10000,  1876, 1),
 (30000, 'LEWIS',   20000,  1901, 1),
 (31000, 'GRANT',   30000,  1926, 1),
 (40000, 'WALKER',  10000,  1875, 2),
 (120000,'YOUNG',   40000,  1900, 2),
 (50000, 'HARRIS',  120000, 1925, 2),
 (130000,'MITCHELL',120000, 1926, 2),
 (110000,'CAMPBELL',130000, 1951, 2),
 (150000,'BLACK',   130000, 1952, 2),
 (160000,'WHITE',   150000, 1977, 2),
 (170000,'JAMES',   160000, 2002, 2);

SELECT * FROM Family

DROP TABLE IF EXISTS FamilyNode
GO

CREATE TABLE FamilyNode
(
   FamilyNodeId int IDENTITY,
   FamilyId int NOT NULL,
   LastName varchar(40) NOT NULL,
   ParentFamilyId int,
   INUM INT
) AS NODE
GO

INSERT INTO FamilyNode(FamilyId, LastName, ParentFamilyId, INUM) 
 SELECT FamilyId, LastName, ParentFamilyId, INUM  
 FROM Family

SELECT * FROM FamilyNode

DROP TABLE IF EXISTS FamilyEdge
GO

CREATE TABLE FamilyEdge
(
   FamilyId int
) AS EDGE
GO

INSERT INTO FamilyEdge 
 SELECT
	p.$node_id,
	c.$node_id,
	p.FamilyNodeId
 FROM
	FamilyNode AS p
	INNER JOIN FamilyNode AS c ON p.FamilyId = c.ParentFamilyId

SELECT * FROM Family
SELECT * FROM FamilyNode
SELECT * FROM FamilyEdge

-- The first query shows William first and then his sons and the second query shows the sons first and then William.
SELECT
	n1.LastName AS Parent,
	n2.LastName AS Child
FROM
	FamilyNode AS n1,
	FamilyEdge AS e,
	FamilyNode AS n2
WHERE
	MATCH (n1-(e)->n2)				-- n1 is the parent
	AND n1.LastName = 'William'

SELECT
	n1.LastName AS Child,
	n2.LastName AS Parent
FROM
	FamilyNode AS n1,
	FamilyEdge AS e,
	FamilyNode AS n2
WHERE
	MATCH (n1<-(e)-n2)				-- n2 is the parent
	AND n2.LastName = 'William'

-- return data for William, his sons and any son that has sons.
SELECT
	n1.LastName AS Parent,
	n2.LastName AS Child,
	n3.LastName AS Grandchild
FROM
	FamilyNode AS n1,
	FamilyEdge AS e1,
	FamilyNode AS n2,
	FamilyEdge AS e2,
	FamilyNode n3
WHERE
	MATCH (n1-(e1)->n2-(e2)->n3)
	AND n1.LastName = 'William'

-- return data for all lineages
;WITH FamilyCte
AS
(
	SELECT
		r1.LastName AS TopNode,
		r2.LastName AS ChildNode,
		CAST(CONCAT(r1.LastName, '-<', r2.LastName) AS varchar(250)) AS Output,
		r1.$node_id AS parentid,
		r2.$node_id AS bottomnode,
		1 AS Tree
	FROM
		FamilyNode r1 
		JOIN FamilyEdge AS e ON e.$from_id = r1.$node_id 
		JOIN FamilyNode AS r2 ON r2.$node_id = e.$to_id AND r1.LastName IN( 'WILLIAM')
	UNION ALL
	SELECT
		c.ChildNode,
		r.LastName,
		CAST(CONCAT(c.Output, '-<', r.LastName) AS varchar(250)),
		c.bottomnode,
		r.$node_id,
		Tree + 1
	FROM
		FamilyCte AS c
		JOIN FamilyEdge AS e ON e.$from_id = c.bottomnode
		JOIN FamilyNode AS r ON r.$node_id = e.$to_id
)
SELECT output FROM FamilyCte	
