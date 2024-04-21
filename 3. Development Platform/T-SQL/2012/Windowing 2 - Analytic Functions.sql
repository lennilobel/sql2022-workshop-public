/*--------------------------------------------------------------
  Analytic Windowing Functions
  --------------------------------------------------------------*/

USE MyDB
GO

-- FIRST_VALUE, LAST_VALUE, LAG, LEAD

CREATE TABLE [Order](OrderDate date, ProductID int, Quantity int)
INSERT INTO [Order] VALUES
 ('2011-03-18', 142, 74),
 ('2011-04-11', 123, 95),
 ('2011-04-12', 101, 38),
 ('2011-05-30', 101, 28),
 ('2011-05-21', 130, 12),
 ('2011-07-25', 123, 57),
 ('2011-07-28', 101, 12)

SELECT
  OrderDate,
  ProductID,
  Quantity,
  LowestOn  = FIRST_VALUE(OrderDate) OVER(PARTITION BY ProductID ORDER BY Quantity),
  HighestOn = LAST_VALUE(OrderDate)  OVER(PARTITION BY ProductID ORDER BY Quantity
                                      ROWS BETWEEN UNBOUNDED PRECEDING
                                      AND UNBOUNDED FOLLOWING),
  ProductPrevOn = LAG(OrderDate, 1)  OVER(PARTITION BY ProductID ORDER BY OrderDate),
  ProductNextOn = LEAD(OrderDate, 1) OVER(PARTITION BY ProductID ORDER BY OrderDate)
 FROM [Order]
 ORDER BY OrderDate


-- PERCENT_RANK, CUME_DIST, PERCENTILE_DISC, PERCENTILE_CONT

-- Distributed across all 8 quarters
CREATE TABLE Sales(Yr int, Qtr int, Amount money)
INSERT INTO Sales VALUES
  (2010, 1, 5000), (2010, 2, 6000), (2010, 3, 7000), (2010, 4, 2000),
  (2011, 1, 1000), (2011, 2, 2000), (2011, 3, 3000), (2011, 4, 4000)

SELECT
  Yr, Qtr, Amount,
  RN = ROW_NUMBER()   OVER(ORDER BY Amount),
  DR = DENSE_RANK()   OVER(ORDER BY Amount),
  R  = RANK()         OVER(ORDER BY Amount),
  PR = PERCENT_RANK() OVER(ORDER BY Amount),
  CD = CUME_DIST()    OVER(ORDER BY Amount)
 FROM Sales
 ORDER BY Amount

-- Distributed (partitioned) by year with percentile lookups
SELECT
  Yr, Qtr, Amount,
  R   = RANK()         OVER(PARTITION BY Yr ORDER BY Amount),
  CD  = CUME_DIST()    OVER(PARTITION BY Yr ORDER BY Amount),
  PD5 = PERCENTILE_DISC(.5) WITHIN GROUP (ORDER BY Amount) OVER(PARTITION BY Yr),
  PD6 = PERCENTILE_DISC(.6) WITHIN GROUP (ORDER BY Amount) OVER(PARTITION BY Yr),
  PC5 = PERCENTILE_CONT(.5) WITHIN GROUP (ORDER BY Amount) OVER(PARTITION BY Yr),
  PC6 = PERCENTILE_CONT(.6) WITHIN GROUP (ORDER BY Amount) OVER(PARTITION BY Yr)
 FROM Sales
 ORDER BY Yr, Amount

GO

-- Cleanup
DROP TABLE [Order]
DROP TABLE Sales
GO
