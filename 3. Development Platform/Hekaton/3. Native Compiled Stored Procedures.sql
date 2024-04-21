/* =================== Hekaton: Native Compiled Stored Procedures =================== */

SET NOCOUNT ON
GO

USE MyDb
GO


-- Delete rows from disk-based table (:08)
DELETE FROM Order_disk

-- Delete rows from memory-optimized table (fully logged, :00)
DELETE FROM Order_mod WITH (SNAPSHOT)

GO

-- Create native stored procedure
CREATE PROCEDURE uspInsertMemoryOrders
 WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
 AS
  BEGIN ATOMIC WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = 'us_english')
	DECLARE @OrderId int = 1
	WHILE @OrderId <= 250000
	BEGIN
		INSERT INTO dbo.Order_mod VALUES(
			@OrderId,
			RAND() * (2500 - 1) + 1,		-- CustomerId
			RAND() * (50000 - 120) + 120,	-- TotalPrice
			DATEFROMPARTS(					-- OrderDate
			 RAND() * (2014 - 2010) + 2010,	--	Y
			 RAND() * (12 - 1) + 1,			--	M
			 RAND() * (28 - 1) + 1))		--	D
		SET @OrderId += 1
	END
  END
GO

-- Run it (0:00, vs. 0:08 using interop, vs. 0:11 using disk-based tables)
EXEC uspInsertMemoryOrders
GO
SELECT * FROM Order_mod
GO

-- Can't use DISTINCT, CTEs, ranking functions, EXISTS/IN, subqueries... (:54)
CREATE PROCEDURE uspGetLostRevenue(@StartShipDate datetime, @EndShipDate datetime)
 WITH
	NATIVE_COMPILATION,
	SCHEMABINDING,
	EXECUTE AS OWNER
 AS
 BEGIN ATOMIC
  WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE='english')

	SELECT
		LostRevenue = SUM(ExtendedPrice * Discount)
	 FROM
		dbo.OrderDetail_mod
	 WHERE
		ShipDate BETWEEN @StartShipDate AND @EndShipDate AND
		Discount BETWEEN 0.02 - 0.01 and 0.02 + 0.01 AND
		Quantity < 24

 END
GO

SET STATISTICS TIME ON
DECLARE @StartShipDate datetime = '01/01/2011'
DECLARE @EndShipDate datetime = '01/01/2014'

/* 1 - MOD table with interop */
SELECT
	LostRevenue = SUM(ExtendedPrice * Discount)
 FROM
	dbo.OrderDetail_mod
 WHERE
	ShipDate BETWEEN @StartShipDate AND @EndShipDate AND
	Discount BETWEEN 0.02 - 0.01 and 0.02 + 0.01 AND
	Quantity < 24

/* 2 - MOD table with native compiled stored procedure */
EXEC dbo.uspGetLostRevenue @StartShipDate, @EndShipDate

/*
 SQL Server Execution Times:
   CPU time = 109 ms,  elapsed time = 94 ms.

 SQL Server Execution Times:
   CPU time = 31 ms,  elapsed time = 36 ms.
*/

-- See the DLL files loaded into SQL Server's memory space
SELECT name, description
 FROM sys.dm_os_loaded_modules
 WHERE
  name like '%xtp_p_' + CONVERT(varchar, DB_ID()) + '_' + CONVERT(varchar, OBJECT_ID('dbo.uspGetLostRevenue')) + '.dll' OR
  name like '%xtp_p_' + CONVERT(varchar, DB_ID()) + '_' + CONVERT(varchar, OBJECT_ID('dbo.uspInsertMemoryOrders')) + '.dll'
