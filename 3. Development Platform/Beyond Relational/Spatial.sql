/* =================== Spatial in SQL Server 2008+ =================== */

/* Run this demo in SSMS */

CREATE DATABASE MyDB
GO

USE MyDB
GO


---------------------------------------------------------------------------
-- PART 1) geometry intersection demo

CREATE TABLE District
 (DistrictId    int PRIMARY KEY,
  DistrictName  nvarchar(20),
  DistrictGeo   geometry);
GO

CREATE TABLE Street
 (StreetId    int PRIMARY KEY,
  StreetName  nvarchar(20),
  StreetGeo   geometry);
GO

INSERT INTO District VALUES
 (1, 'Downtown', 'POLYGON ((0 0, 150 0, 150 -150, 0 -150, 0 0))'),
 (2, 'Green Park', 'POLYGON ((300 0, 150 0, 150 -150, 300 -150, 300 0))'),
 (3, 'Harborside', 'POLYGON ((150 -150, 300 -150, 300 -300, 150 -300, 150 -150))')

INSERT INTO Street VALUES
 (1, 'First Avenue', 'LINESTRING (100 -100, 20 -180, 180 -180)'),
 (2, 'Beach Street', 'LINESTRING (300 -300, 300 -150, 50 -50)')

GO

-- Retrieve all shapes
SELECT
  Name = StreetName,
  Shape = StreetGeo,
  ShapeWKT = StreetGeo.ToString()
 FROM Street UNION ALL
 SELECT
  DistrictName,
  DistrictGeo,
  DistrictGeo.ToString()
 FROM District

-- Widen the streets using STBuffer
SELECT
  Name = StreetName,
  Shape = StreetGeo.STBuffer(5),
  ShapeWKT = StreetGeo.STBuffer(5).ToString()
 FROM Street UNION ALL
 SELECT
  DistrictName,
  DistrictGeo,
  DistrictGeo.ToString()
 FROM District

-- Avenues are wider than streets
SELECT
  Name = StreetName,
  Shape = CASE
    WHEN StreetName LIKE '% Avenue'
    THEN StreetGeo.STBuffer(10)
    ELSE StreetGeo.STBuffer(5) END
 FROM Street UNION ALL
 SELECT
  DistrictName,
  DistrictGeo
 FROM District

-- STCentroid() method (not available with geography type)
SELECT
	 Shape = DistrictGeo,
	 ShapeWKT = DistrictGeo.ToString()
 FROM District UNION ALL
 SELECT
	 DistrictGeo.STCentroid().STBuffer(10),
	 DistrictGeo.STCentroid().ToString()
 FROM District

-- Get bounding box for streets using STEnvelope
SELECT
	 ShapeWKT = DistrictGeo.ToString(),
	 ShapeLabel = DistrictName,
	 Shape = DistrictGeo
 FROM District UNION ALL
 SELECT
	StreetGeo.ToString(),
	StreetName,
	StreetGeo.STBuffer(5)
 FROM Street UNION ALL
 SELECT
	StreetGeo.STEnvelope().ToString(),
	StreetName + ' Bounds',
	StreetGeo.STEnvelope()
 FROM Street

-- Return all district/street intersections using STIntersects() method
SELECT
  S.StreetName,
  D.DistrictName
 FROM District AS D CROSS JOIN Street AS S
 WHERE S.StreetGeo.STIntersects(D.DistrictGeo) = 1
 ORDER BY S.StreetName

-- Also show which pieces of road intersect each district using STIntersection()
SELECT
  S.StreetName,
  D.DistrictName,
  S.StreetGeo.STIntersection(D.DistrictGeo).STBuffer(5) AS Intersection,
  S.StreetGeo.STIntersection(D.DistrictGeo).ToString() AS IntersectionWKT
 FROM District AS D CROSS JOIN Street AS S
 WHERE S.StreetGeo.STIntersects(D.DistrictGeo) = 1
 ORDER BY S.StreetName

-- Use STDimension() method to retrieve shape dimensions 
SELECT *, StreetGeo.STDimension() AS Dimension FROM Street
SELECT *, DistrictGeo.STDimension() AS Dimension FROM District

-- Cleanup
DROP TABLE District
DROP TABLE Street


---------------------------------------------------------------------------
-- PART 2) More geography methods

-- Import any shape with WKT using STGeomFromText
DECLARE @line geometry = geometry::STGeomFromText('LINESTRING(5 15, 22 10)', 0)
SELECT @line.ToString(), @line
GO

-- Import specific shape types with WKT using shape-specific methods ST[Line|Point|Poly]FromText
DECLARE @line geometry = geometry::STLineFromText('LINESTRING(5 15, 22 10)', 0)
SELECT @line.ToString(), @line
GO

-- Can't create the wrong type of shape
DECLARE @line geometry = geometry::STLineFromText('POINT(10, 100)', 0)
SELECT @line.ToString(), @line
GO

-- Import any shape with WKT using Parse (invokes STGeomFromText, because WKT is the default)
DECLARE @line geometry = geometry::Parse('LINESTRING(5 15, 22 10)')
SELECT @line.ToString(), @line
GO

-- Import any shape with WKT as a string literal (invokes Parse, which invokes STGeomFromText)
DECLARE @line geometry = 'LINESTRING(5 15, 22 10)'
SELECT @line.ToString(), @line
GO

-- Import specific shape types with WKB using shape-specific methods ST[Line|Point|Poly]FromWKB
DECLARE @point geometry = geometry::STPointFromWKB(0x010100000000000000000059400000000000005940, 0)
SELECT @point.ToString(), @point
GO

DECLARE @line geometry = geometry::STLineFromWKB(0x0102000000020000000000000000005940000000000000594000000000000069400000000000006940, 0)
SELECT @line.ToString(), @line
GO

-- Import spatial data using GML
DECLARE @gml xml = '
<LineString xmlns="http://www.opengis.net/gml">
  <posList>100 100 20 180 180 180</posList>
</LineString>'
DECLARE @line geometry = geometry::GeomFromGml(@gml, 0)
SELECT @line.ToString(), @line
GO

-- Overlapping shape manipulation using STUnion, STIntersection, STDifference, and STSymDifference methods
DECLARE @S1 geometry = 'POLYGON ((60 40, 410 50, 400 270,  60 370, 60 40))'
DECLARE @S2 geometry = 'POLYGON ((300 100, 510 110,  510 330,  300 330,  300 100))'

SELECT @S1 UNION ALL
SELECT @S2
SELECT S1_UNION_S2			= @S1.STUnion(@S2)
SELECT S1_INTERSECTION_S2	= @S1.STIntersection(@S2)
SELECT S1_DIFFERENCE_S2		= @S1.STDifference(@S2)
SELECT S2_DIFFERENCE_S1		= @S2.STDifference(@S1)
SELECT S1_SYMDIFFERENCE_S2	= @S1.STSymDifference(@S2)
GO

-- Can also use lat/long for geometry type; spatial view shows the distortion from the projection...
SELECT
 geography::Parse('LINESTRING(-58.2492 45.25, -58.2492 39.5, -65.2502 39.5, -65.2502 39.4167,-41.0001 39.4167)'),
 geometry::Parse('LINESTRING(-58.2492 45.25, -58.2492 39.5, -65.2502 39.5, -65.2502 39.4167,-41.0001 39.4167)')
GO

---------------------------------------------------------------------------
-- PART 3) geography with FILESTREAM demo

USE MyDB
GO

EXEC sp_configure filestream_access_level, 2
RECONFIGURE
GO

-- Create the database
CREATE DATABASE EventLibrary
 ON PRIMARY
  (NAME = EventLibrary_data, 
   FILENAME = 'C:\Demo\EventLibrary\EventLibrary_data.mdf'),
 FILEGROUP FileStreamGroup CONTAINS FILESTREAM
  (NAME = EventLibrary_group, 
   FILENAME = 'C:\Demo\EventLibrary\Events')
 LOG ON 
  (NAME = EventLibrary_log,
   FILENAME = 'C:\Demo\EventLibrary\EventLibrary_log.ldf')
GO

USE EventLibrary
GO

-- Create and populate a table of regions
CREATE TABLE EventRegion(
	RegionId int PRIMARY KEY,
	RegionName nvarchar(32),
	MapShape geography NOT NULL)

INSERT INTO EventRegion VALUES(1, 'Parkway Area', geography::Parse('POLYGON((
 -75.17031 39.95601,
 -75.16786 39.95778,
 -75.17921 39.96874,
 -75.18441 39.96512,
 -75.17031 39.95601 ))'))

INSERT INTO EventRegion VALUES(2, 'Wall Area', geography::Parse('POLYGON((
 -75.22280 40.02387,
 -75.21442 40.02810,
 -75.21746 40.03142,
 -75.22534 40.02586,
 -75.22280 40.02387))'))

INSERT INTO EventRegion VALUES(3, 'Race Area', geography::Parse('POLYGON((
 -75.17031 39.95601,
 -75.16786 39.95778,
 -75.18870 39.97789,
 -75.18521 39.99237,
 -75.18603 40.00677,
 -75.19922 40.01136,
 -75.21746 40.03142,
 -75.22534 40.02586,
 -75.21052 40.01430,
 -75.19192 40.00634,
 -75.19248 39.99570,
 -75.20526 39.98374,
 -75.19437 39.97704,
 -75.19087 39.96920,
 -75.17031 39.95601))'))

SELECT * FROM EventRegion

-- Simple polygon
SELECT geography::Parse('POLYGON((
-75.17031 39.95601,
-75.16786 39.95778,
-75.18441 39.96512,
-75.17031 39.95601))')

-- Must close the shape
SELECT geography::Parse('POLYGON((
-75.17031 39.95601,
-75.16786 39.95778,
-75.18441 39.96512))')

-- Must plot counter-clockwise (limitation removed in SQL Server 2012)
SELECT geography::Parse('POLYGON((
-75.17031 39.95601,
-75.18441 39.96512,
-75.16786 39.95778,
-75.17031 39.95601))')

-- STArea, STLength, and STDimension methods
SELECT
	RegionName,
    ROUND(MapShape.STArea(), 2) AS Area,
    ROUND(MapShape.STLength(), 2) AS Length,
    MapShape.STDimension() AS Dimension,
    MapShape.ToString() AS MapShapeString
FROM
    EventRegion

-- SRIDs
SELECT * FROM sys.spatial_reference_systems
SELECT * FROM sys.spatial_reference_systems WHERE spatial_reference_id = 4326
SELECT * FROM sys.spatial_reference_systems WHERE unit_of_measure <> 'metre'

-- Create a table of photos taken at various points in the region
CREATE TABLE EventPhoto (
 PhotoId int PRIMARY KEY,
 RowId uniqueidentifier ROWGUIDCOL NOT NULL UNIQUE DEFAULT NEWSEQUENTIALID(),
 Description varchar(max),
 Location geography,
 Photo varbinary(max) FILESTREAM DEFAULT(0x))
GO 

-- Load geocoded photos
INSERT INTO EventPhoto(PhotoId, Description, Location, Photo) VALUES
 (1,
	'Taken from the Ben Franklin parkway near the finish line',
	geography::Parse('POINT(-75.17396 39.96045)'),
	(SELECT BulkColumn FROM OPENROWSET(BULK 'C:\Demo\Files\EventMedia\bike9_2.jpg', SINGLE_BLOB) AS x)),
 (2,
	'This shot was taken from the bottom of the Manayunk Wall',
	geography::Parse('POINT(-75.22457 40.02593)'),
	(SELECT BulkColumn FROM OPENROWSET(BULK 'C:\Demo\Files\EventMedia\wall_race_2.jpg', SINGLE_BLOB) AS x)),
 (3,
	'This shot was taken at the top of the Manayunk Wall',
	geography::Parse('POINT(-75.21986 40.02920)'),
	(SELECT BulkColumn FROM OPENROWSET(BULK 'C:\Demo\Files\EventMedia\wall_race2_2.jpg', SINGLE_BLOB) AS x)),
 (4,
	'This is another shot from the Benjamin Franklin Parkway',
	geography::Parse('POINT(-75.17052 39.95813)'),
	(SELECT BulkColumn FROM OPENROWSET(BULK 'C:\Demo\Files\EventMedia\parkway_area2_2.jpg', SINGLE_BLOB) AS x))
GO

-- Get list of region for selection
CREATE PROCEDURE GetRegions AS
 BEGIN
	SELECT RegionId, RegionName FROM EventRegion
 END
GO

-- Get list of photos taken in selected region (use STIntersects) 
CREATE PROCEDURE GetRegionPhotos(@RegionId int) AS
 BEGIN

	DECLARE @MapShape geography
	
	-- Get the shape of the region
    SELECT   @MapShape = MapShape
     FROM    EventRegion
	 WHERE   RegionId = @RegionId

	-- Get all photos taken in the region
    SELECT   PhotoId, Description
     FROM    EventPhoto
     WHERE   Location.STIntersects(@MapShape) = 1
     
 END
GO

-- Get selected photo PathName and GET_FILESTREAM_TRANSACTION_CONTEXT for SqlFileStream
CREATE PROCEDURE GetPhotoForFilestream(@PhotoId int) AS
 BEGIN

	-- Called by ADO.NET client during open transaction to get
	-- a SqlFileStream object to stream-read the photo 
    SELECT   Photo.PathName(), GET_FILESTREAM_TRANSACTION_CONTEXT()
     FROM    EventPhoto
     WHERE   PhotoId = @PhotoId
 
 END
GO

-- Spatial + Filestream = Beyond Relational!
SELECT
    *,
    Location.STDimension() AS Dimension,
    Location.ToString() AS LocationString
 FROM
    EventPhoto

-- STArea, STLength, and STDimension methods
SELECT
	*,
    ROUND(MapShape.STArea(), 2) AS Area,
    ROUND(MapShape.STLength(), 2) AS Length,
    MapShape.STDimension() AS Dimension,
    MapShape.ToString() AS MapShapeString
 FROM
    EventRegion

-- Plot photo points on map
SELECT Shape = Location.STBuffer(140) FROM EventPhoto UNION ALL
SELECT Shape = MapShape FROM EventRegion


-- STDistance() method
SELECT
    P1.PhotoId AS Photo1,
    P2.PhotoId AS Photo2,
    ROUND(P1.Location.STDistance(P2.location) / 1000, 2) AS Km
 FROM
    EventPhoto AS P1 JOIN EventPhoto AS P2 ON P1.PhotoId < P2.PhotoId
 ORDER BY
    P1.PhotoId 
    

-- Get the largest region
SELECT TOP 1
	*
 FROM
	EventRegion
 ORDER BY
	MapShape.STArea() DESC

DROP PROCEDURE GetRegions
DROP PROCEDURE GetRegionPhotos
DROP PROCEDURE GetPhotoForFilestream
DROP TABLE EventRegion
DROP TABLE EventPhoto


---------------------------------------------------------------------------
-- PART 4) Bing Maps geography demo


USE MyDB
GO

CREATE TABLE Customer
 (CustomerId  int PRIMARY KEY,
  Name        varchar(50),
  Company     varchar(50),
  CustomerGeo geography)
GO

INSERT INTO Customer VALUES
 (1, 'Adam', 'Widgets, Inc.', 'POINT(-111.06687 45.01188)'),
 (2, 'John', 'ACME Corp.', 'POINT(-104.06 41.01929)'),
 (3, 'Paul', 'Jedi Knights Assn', 'POINT(-111.05878 41.003)'),
 (4, 'Joel', 'Super Products Ltd', 'POINT(-121.05878 41.003)'),
 (5, 'Martin', 'ABC Travel', 'POINT(-110.05878 43.003)'),
 (6, 'Remon', 'Amazing Savings', 'POINT(-113.05878 35.003)'),
 (7, 'Jason', 'Fashion Plus', 'POINT(-116.05878 34.003)'),
 (8, 'Fred', 'Fred�s Bank', 'POINT(-114.05878 43.003)')

GO

CREATE PROCEDURE GetCustomers
AS
 BEGIN
	SELECT  Name, Company, CustomerGeo
     FROM   Customer
 END
GO

-- Cleanup
DROP PROCEDURE GetCustomers
DROP TABLE Customer


/* =================== Spatial Enhancements in SQL Server 2012 =================== */

------------------- *** SQL Server 2012 spatial enhancements *** -------------------

-- Three new curved shapes:
--	Circular strings
--	Compound curves
--	Curve polygons


-- *** Circular Strings ***

-- Simple circular string
SELECT geometry::Parse('CIRCULARSTRING(0 1, .25 0, 0 -1)')

-- Straight line
SELECT geometry::Parse('LINESTRING(0 8, 8 -8)')

-- Take the same straight line and curve it
SELECT geometry::Parse('CIRCULARSTRING(0 8, 4 0, 8 -8)').STBuffer(.1)
UNION ALL  -- Curve it
SELECT geometry::Parse('CIRCULARSTRING(0 8, 4 4, 8 -8)').STBuffer(.1)
UNION ALL  -- Curve it some more
SELECT geometry::Parse('CIRCULARSTRING(0 8, 4 6, 8 -8)').STBuffer(.1)
UNION ALL  -- Curve it in the other direction
SELECT geometry::Parse('CIRCULARSTRING(0 8, 4 -6, 8 -8)').STBuffer(.1)

-- Link two semi-circles together to form a circle
SELECT geometry::Parse('CIRCULARSTRING(0 4, 4 0, 8 4, 4 8, 0 4)')

-- Link two circular strings together to form a binoculars shape
SELECT geometry::Parse('CIRCULARSTRING(0 1, 5 0, 0 -2, -5 0, 0 1)')

-- Collapsed
SELECT geometry::Parse('CIRCULARSTRING(0 5, 2 0, 0 -5, -2 0, 0 5)')


-- *** Compound Curves ***

-- Similar to a geometry collection, but:
--  allows only line strings and circular strings
--  requires connecting end-start points
--  more space-efficient

-- Compound curve
DECLARE @CC geometry = '
 COMPOUNDCURVE(
  (4 4, 4 8),
  CIRCULARSTRING(4 8, 6 10, 8 8),
  (8 8, 8 4),
  CIRCULARSTRING(8 4, 2 3, 4 4)
 )'

-- Equivalent geometry collection
DECLARE @GC geometry = '
 GEOMETRYCOLLECTION(
  LINESTRING(4 4, 4 8),
  CIRCULARSTRING(4 8, 6 10, 8 8),
  LINESTRING(8 8, 8 4),
  CIRCULARSTRING(8 4, 2 3, 4 4)
 )'

-- They both render the same shape in the spatial viewer
SELECT @CC.STBuffer(.5)
UNION ALL
SELECT @GC.STBuffer(1.5)

-- They both contain the exact same set of points
SELECT @CC.STEquals(@GC)

-- The compound curve takes only 152 bytes
-- while the geometry collection takes 243
-- so it's 91 bytes less (roughly 43% savings)
SELECT CC = DATALENGTH(@CC), GC = DATALENGTH(@GC)
GO


-- *** Curve Polygons ***

SELECT geometry::Parse('
  CURVEPOLYGON(
   COMPOUNDCURVE(
    (4 4, 4 8),
    CIRCULARSTRING(4 8, 6 10, 8 8),
    (8 8, 8 4),
    CIRCULARSTRING(8 4, 2 3, 4 4)
   )
  )')
GO


-- *** STNumCurves and STCurveN *** --

-- Create a full circle shape (two connected semi-circles)
DECLARE @C geometry = 'CIRCULARSTRING(0 4, 4 0, 8 4, 4 8, 0 4)'
SELECT @C

-- Get the curve count (2) and the 1st curve (bottom semi-circle)
SELECT
	CurveCount = @C.STNumCurves(),
	SecondCurve = @C.STCurveN(1)

GO


-- *** BufferWithCurves ***

DECLARE @streets geometry = '
 GEOMETRYCOLLECTION(
  LINESTRING (100 -100, 20 -180, 180 -180),
  LINESTRING (300 -300, 300 -150, 50 -50)
 )'
SELECT @streets.BufferWithCurves(10)

SELECT
  AsWKT = @streets.ToString(),
  Bytes = DATALENGTH(@streets),
  Points = @streets.STNumPoints()
 UNION ALL
 SELECT
  @streets.STBuffer(10).ToString(),
  DATALENGTH(@streets.STBuffer(10)),
  @streets.STBuffer(10).STNumPoints()
 UNION ALL
 SELECT
  @streets.BufferWithCurves(10).ToString(),
  DATALENGTH(@streets.BufferWithCurves(10)),
  @streets.BufferWithCurves(10).STNumPoints()


-- *** ShortestLineTo *** --

DECLARE @Shape1 geometry = '
 POLYGON ((-20 -30, -3 -26, 14 -28, 20 -40, -20 -30))'

DECLARE @Shape2 geometry = '
 POLYGON ((-18 -20, 0 -10, 4 -12, 10 -20, 2 -22, -18 -20))'

SELECT @Shape1
UNION ALL
SELECT @Shape2
UNION ALL
SELECT @Shape1.ShortestLineTo(@Shape2).STBuffer(.25)
GO


-- *** MinDbCompatibilityLevel

DECLARE @Shape1 geometry = 'CIRCULARSTRING(0 50, 90 50, 180 50)'
DECLARE @Shape2 geometry = 'LINESTRING (0 50, 90 50, 180 50)'

SELECT
 Shape1MinVersion = @Shape1.MinDbCompatibilityLevel(),
 Shape2MinVersion = @Shape2.MinDbCompatibilityLevel()


-- *** STCurveToLine and CurveToLineWithTolerance

-- Create a full circle shape (two connected semi-circles)
DECLARE @C geometry = 'CIRCULARSTRING(0 4, 4 0, 8 4, 4 8, 0 4)'

-- Render as curved shape
SELECT
  Shape = @C,
  ShapeWKT = @C.ToString(),
  ShapeLen = DATALENGTH(@C),
  Points = @C.STNumPoints()

-- Convert to lines (much larger, many more points)
SELECT
  Shape = @C.STCurveToLine(),
  ShapeWKT = @C.STCurveToLine().ToString(),
  ShapeLen = DATALENGTH(@C.STCurveToLine()),
  Points = @C.STCurveToLine().STNumPoints()

-- Convert to lines with tolerance (not as much larger, not as many more points)
SELECT
  Shape = @C.CurveToLineWithTolerance(0.1, 0),
  ShapeWKT = @C.CurveToLineWithTolerance(0.1, 0).ToString(),
  ShapeLen = DATALENGTH(@C.CurveToLineWithTolerance(0.1, 0)),
  Points = @C.CurveToLineWithTolerance(0.1, 0).STNumPoints()

GO


-- *** STIsValid, STIsValidDetailed, and MakeValid ***

DECLARE @line geometry = 'LINESTRING(1 1, 2 2, 3 2, 2 2)'
SELECT
 IsValid = @line.STIsValid(),
 Details = @line.IsValidDetailed()
GO

-- You can still perform metric operations on invalid objects...
DECLARE @line geometry = 'LINESTRING(1 1, 2 2, 3 2, 2 2)'
SELECT @line.STLength()
GO

-- ...but not other operations
DECLARE @line geometry = 'LINESTRING(1 1, 2 2, 3 2, 2 2)'
SELECT @line.STBuffer(.1)
GO

-- Make it valid (changes the shape)
DECLARE @line geometry = 'LINESTRING(1 1, 2 2, 3 2, 2 2)'
SELECT @line.MakeValid().ToString()
GO


-- *** Exceed Logical Hemisphere ***

-- Small (less than a logical hemisphere) polygon
SELECT geography::Parse('POLYGON((-10 -10, 10 -10, 10 10, -10 10, -10 -10))')

-- Reorder in the opposite direction for "rest of the globe"
SELECT geography::Parse('POLYGON((-10 -10, -10 10, 10 10, 10 -10, -10 -10))')

-- Reorient back to the small polygon
SELECT geography::Parse('POLYGON((-10 -10, -10 10, 10 10, 10 -10, -10 -10))').ReorientObject()

GO


-- *** Full Globe ***

-- Construct a new FullGlobe object (a WGS84 ellipsoid)
DECLARE @Earth geography = 'FULLGLOBE'

-- Calculate the area of the earth (510,065,621,710,996 square meters)
SELECT PlanetArea = @Earth.STArea()
