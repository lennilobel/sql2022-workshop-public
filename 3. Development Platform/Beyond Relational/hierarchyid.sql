/* =================== hierarchyid =================== */

CREATE DATABASE MyDB
GO

USE MyDB
GO

/*
	Sample Hierarchy 
	================

                                 Dave-6
                                    |
                   +----------------+---------------+
                   |                |               |
                Amy-46          John-271        Jill-119
                   |                |               |
              +----+----+           |               |
              |         |           |               |
         Cheryl-269  Wanda-389  Mary-272        Kevin-291
              |
         +----+----+
         |         |
    Richard-87   Jeff-90
*/

-- Create hierarchical table with a depth-first index
CREATE TABLE Employee
(
   NodeId        hierarchyid PRIMARY KEY CLUSTERED,
   NodeLevel     AS NodeId.GetLevel(),
   EmployeeId    int UNIQUE NOT NULL,
   EmployeeName  varchar(20) NOT NULL,
   Title         varchar(20) NULL
)
GO

-- Insert root node
INSERT INTO Employee
  (NodeId, EmployeeId, EmployeeName, Title)
 VALUES
  (hierarchyid::GetRoot(), 6, 'Dave', 'Marketing Manager') ;

GO

SELECT * FROM Employee
GO

-- Insert Amy as the first child beneath Dave
DECLARE @Manager hierarchyid 

SELECT @Manager = NodeId
 FROM Employee
 WHERE EmployeeId = 6

INSERT INTO Employee
  (NodeId, EmployeeId, EmployeeName, Title)
 VALUES
  (@Manager.GetDescendant(NULL, NULL), 46, 'Amy', 'Marketing Specialist')

GO

-- Alternative single-statement version:
INSERT INTO Employee
  (NodeId, EmployeeId, EmployeeName, Title)
 VALUES (
  (SELECT NodeId
    FROM Employee
    WHERE EmployeeId = 6).GetDescendant(NULL, NULL),
  46,
  'Amy',
  'Marketing Specialist')

GO

SELECT NodeId.ToString() AS NodeIdPath, *
 FROM Employee
GO

-- Create stored proc to simplify insertions
CREATE PROC uspAddEmployee(
 @ManagerId int,
 @EmployeeId int,
 @EmployeeName varchar(20),
 @Title varchar(20)) 
AS 
BEGIN

 DECLARE @ManagerNodeId hierarchyid
 DECLARE @LastManagerChild hierarchyid
 DECLARE @NewEmployeeNodeId hierarchyid

 -- Get the hierarchyid of the desired parent passed in to @ManagerId
 SELECT @ManagerNodeId = NodeId 
  FROM  Employee 
  WHERE EmployeeId = @ManagerId

 SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

 BEGIN TRANSACTION

   -- Get the hierarchyid of the last existing child beneath the parent
   SELECT @LastManagerChild = MAX(NodeId)
    FROM  Employee 
    WHERE NodeId.GetAncestor(1) = @ManagerNodeId

   -- Assign a new hierarchyid positioned at the end of any existing siblings
   SELECT @NewEmployeeNodeId =
    @ManagerNodeId.GetDescendant(@LastManagerChild, NULL)

   -- Add the row
   INSERT INTO Employee
     (NodeId, EmployeeId, EmployeeName, Title)
    VALUES
     (@NewEmployeeNodeId, @EmployeeId, @EmployeeName, @Title)

 COMMIT

END

GO

-- Add the remaining employees
EXEC uspAddEmployee 6, 271, 'John', 'Marketing Specialist'
EXEC uspAddEmployee 6, 119, 'Jill', 'Marketing Specialist'
EXEC uspAddEmployee 46, 269, 'Cheryl', 'Marketing Assistant'
EXEC uspAddEmployee 46, 389, 'Wanda', 'Business Assistant'
EXEC uspAddEmployee 271, 272, 'Mary', 'Marketing Assistant'
EXEC uspAddEmployee 119, 291, 'Kevin', 'Marketing Intern'
EXEC uspAddEmployee 269, 87, 'Richard', 'Business Intern'
EXEC uspAddEmployee 269, 90, 'Jeff', 'Business Intern'

SELECT NodeId.ToString() AS NodeIdPath, * 
 FROM Employee
 ORDER BY NodeLevel, NodeId

GO

-- Create a UDF to return the full display path of a node
CREATE FUNCTION dbo.fnGetFullDisplayPath(@EntityNodeId hierarchyid) 
 RETURNS varchar(max) 
AS 
  BEGIN
    DECLARE @EntityLevelDepth smallint
    DECLARE @LevelCounter smallint
    DECLARE @DisplayPath varchar(max)
    DECLARE @ParentEmployeeName varchar(max)
 
    -- Start with the specified node
    SELECT @EntityLevelDepth = NodeId.GetLevel(),
           @DisplayPath = EmployeeName
     FROM  Employee
     WHERE NodeId = @EntityNodeId
 
    -- Loop through all its ancestors
    SET @LevelCounter = 0
    WHILE @LevelCounter < @EntityLevelDepth BEGIN
 
       SET @LevelCounter = @LevelCounter + 1
 
       SELECT @ParentEmployeeName = EmployeeName
        FROM  Employee
        WHERE NodeId = (
              SELECT NodeId.GetAncestor(@LevelCounter)
               FROM Employee
               WHERE NodeId = @EntityNodeId)
 
       -- Prepend the ancestor name to the display path
       SET @DisplayPath = @ParentEmployeeName + ' > ' + @DisplayPath
 
    END
 
    RETURN(@DisplayPath)
   END 
GO

SELECT
  NodeId,
  NodeId.ToString() AS NodeIdPath,
  dbo.fnGetFullDisplayPath(NodeId) AS NodeIdDisplayPath,
  EmployeeName
 FROM
  Employee 
 ORDER BY
  NodeLevel, NodeId
GO

-- Create a breadth-first index
CREATE UNIQUE INDEX IX_EmployeeBreadth
 ON Employee(NodeLevel, NodeId)

GO

-- IsDescendantOfMethod... retrieve a subtree beginning with Amy
DECLARE @AmyNodeId hierarchyid

SELECT @AmyNodeId = NodeId
 FROM  Employee
 WHERE EmployeeId = 46

SELECT NodeId.ToString() AS NodeIdPath, *
 FROM  Employee
 WHERE NodeId.IsDescendantOf(@AmyNodeId) = 1
 ORDER BY NodeLevel, NodeId

-- GetAncestorMethod... retrieve Amy's direct children (1 level down)
SELECT NodeId.ToString() AS NodeIdPath, *
 FROM  Employee
 WHERE NodeId.GetAncestor(1) = 
   (SELECT NodeId
     FROM  Employee
     WHERE EmployeeId = 46)
 ORDER BY NodeLevel, NodeId

-- GetAncestorMethod... retrieve Dave's grandchildren (2 levels down)
SELECT NodeId.ToString() AS NodeIdPath, *
 FROM  Employee
 WHERE NodeId.GetAncestor(2) = 
   (SELECT NodeId
     FROM  Employee
     WHERE EmployeeId = 6)
 ORDER BY NodeLevel, NodeId
GO

-- GetRoot... retrieve the root node (Dave)
SELECT NodeId.ToString() AS NodeIdPath, *
 FROM  Employee
 WHERE NodeId = hierarchyid::GetRoot()
GO

-- GetReparentedValue... Wanda now reports to Jill and no longer to Amy
DECLARE @EmployeeToMove hierarchyid
DECLARE @OldParent hierarchyid
DECLARE @NewParent hierarchyid

SELECT @EmployeeToMove = NodeId
 FROM  Employee
 WHERE EmployeeId = 389 -- Wanda

SELECT @OldParent = NodeId
 FROM  Employee
 WHERE EmployeeId = 46 -- Amy

SELECT @NewParent = NodeId
 FROM  Employee
 WHERE EmployeeId = 119 -- Jill

UPDATE Employee
 SET   NodeId = @EmployeeToMove.GetReparentedValue(@OldParent, @NewParent)
 WHERE NodeId = @EmployeeToMove 
GO

SELECT
  NodeId,
  NodeId.ToString() AS NodeIdPath,
  NodeLevel,
  dbo.fnGetFullDisplayPath(NodeId) AS NodeIdDisplayPath,
  EmployeeName
 FROM
  Employee 
 ORDER BY
  NodeLevel, NodeId
GO

-- Move the entire subtree beneath Amy to a new location beneath Kevin
DECLARE @OldParent hierarchyid
DECLARE @NewParent hierarchyid

SELECT @OldParent = NodeId
 FROM  Employee
 WHERE EmployeeId = 46 -- Amy

SELECT @NewParent = NodeId
 FROM  Employee
 WHERE EmployeeId = 291 -- Kevin

UPDATE Employee
 SET   NodeId = NodeId.GetReparentedValue(@OldParent, @NewParent) 
 WHERE NodeId.IsDescendantOf(@OldParent) = 1
       AND EmployeeId <> 46 -- This excludes Amy from the move.
GO

SELECT
  NodeId,
  NodeId.ToString() AS NodeIdPath,
  NodeLevel,
  dbo.fnGetFullDisplayPath(NodeId) AS NodeIdDisplayPath,
  EmployeeName
 FROM
  Employee
 ORDER BY
  NodeLevel, NodeId
GO

-- Parse method (complement of ToString)
SELECT hierarchyid::Parse('/2/1/1/') AS NodeId
GO


/*
	Understanding GetDescendant()

                  Root
                    |
       +------+-----+--+------+
       |      |        |      |
    Child4  Child1  Child3  Child2
              |
         +----+----+
         |         | 
  GrandChild1   GrandChild2
*/

DECLARE @Root hierarchyid
DECLARE @Child1 hierarchyid
DECLARE @Child2 hierarchyid
DECLARE @Child3 hierarchyid
DECLARE @Child4 hierarchyid
DECLARE @Grandchild1 hierarchyid
DECLARE @Grandchild2 hierarchyid

SET @Root = hierarchyid::GetRoot()
SET @Child1 = @Root.GetDescendant(NULL, NULL)
SET @Child2 = @Root.GetDescendant(@Child1, NULL)
SET @Child3 = @Root.GetDescendant(@Child1, @Child2)
SET @Child4 = @Root.GetDescendant(NULL, @Child1)
SET @Grandchild1 = @Child1.GetDescendant(NULL, NULL)
SET @Grandchild2 = @Child1.GetDescendant(@Grandchild1, NULL)

SELECT
@Root AS Root,
 @Child1 AS Child1,
 @Child2 AS Child2,
 @Child3 AS Child3,
 @Child4 AS Child4,
 @Grandchild1 AS Grandchild1,
 @Grandchild2 AS Grandchild2

SELECT
 @Root.ToString() AS Root,
 @Child1.ToString() AS Child1,
 @Child2.ToString() AS Child2,
 @Child3.ToString() AS Child3,
 @Child4.ToString() AS Child4,
 @Grandchild1.ToString() AS Grandchild1,
 @Grandchild2.ToString() AS Grandchild2
GO

/*
	C L E A N U P
*/

DROP FUNCTION dbo.fnGetFullDisplayPath
DROP PROC uspAddEmployee
DROP TABLE Employee
GO
