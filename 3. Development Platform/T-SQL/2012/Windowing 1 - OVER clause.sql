---------------------------------------------------------------
-- OVER clause enhancements (SQL Server 2012)
---------------------------------------------------------------

CREATE DATABASE MyDB
GO

USE MyDB
GO

CREATE TABLE TxnData (AcctId int, TxnDate date, Amount decimal)
INSERT INTO TxnData (AcctId, TxnDate, Amount) VALUES
  (1, DATEFROMPARTS(2011, 8, 10), 500),  -- 5 transactions for acct 1
  (1, DATEFROMPARTS(2011, 8, 22), 250),
  (1, DATEFROMPARTS(2011, 8, 24), 75),
  (1, DATEFROMPARTS(2011, 8, 26), 125),
  (1, DATEFROMPARTS(2011, 8, 28), 175),
  (2, DATEFROMPARTS(2011, 8, 11), 500),  -- 8 transactions for acct 2
  (2, DATEFROMPARTS(2011, 8, 15), 50),
  (2, DATEFROMPARTS(2011, 8, 22), 5000),
  (2, DATEFROMPARTS(2011, 8, 25), 550),
  (2, DATEFROMPARTS(2011, 8, 27), 105),
  (2, DATEFROMPARTS(2011, 8, 27), 95),
  (2, DATEFROMPARTS(2011, 8, 29), 100),
  (2, DATEFROMPARTS(2011, 8, 30), 2500),
  (3, DATEFROMPARTS(2011, 8, 14), 500),  -- 4 transactions for acct 3
  (3, DATEFROMPARTS(2011, 8, 15), 600),
  (3, DATEFROMPARTS(2011, 8, 22), 25),
  (3, DATEFROMPARTS(2011, 8, 23), 125)

-- OVER (PARTITION BY ...) was supported with aggregate functions
-- since SQL 2005

SELECT
  AcctId,
  TxnDate,
  Amount,
  Average         = AVG(Amount) OVER (PARTITION BY AcctId),
  TxnCount        = COUNT(*)    OVER (PARTITION BY AcctId),
  SmallAmt        = MIN(Amount) OVER (PARTITION BY AcctId),
  LargeAmt        = MAX(Amount) OVER (PARTITION BY AcctId),
  TotalAmt        = SUM(Amount) OVER (PARTITION BY AcctId)
 FROM
  TxnData
 ORDER BY
  AcctId,
  TxnDate

-- SQL Server 2012 now supports ORDER BY for running/sliding aggregations

SELECT AcctId, TxnDate, Amount,
  RAvg = AVG(Amount) OVER (PARTITION BY AcctId ORDER BY TxnDate),
  RCnt = COUNT(*)    OVER (PARTITION BY AcctId ORDER BY TxnDate),
  RMin = MIN(Amount) OVER (PARTITION BY AcctId ORDER BY TxnDate),
  RMax = MAX(Amount) OVER (PARTITION BY AcctId ORDER BY TxnDate),
  RSum = SUM(Amount) OVER (PARTITION BY AcctId ORDER BY TxnDate)
 FROM TxnData
 ORDER BY AcctId, TxnDate
GO

SELECT AcctId, TxnDate, Amount,
  SAvg = AVG(Amount) OVER (PARTITION BY AcctId ORDER BY TxnDate
                            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),
  SCnt = COUNT(*)    OVER (PARTITION BY AcctId ORDER BY TxnDate ROWS 2 PRECEDING),
  SMin = MIN(Amount) OVER (PARTITION BY AcctId ORDER BY TxnDate ROWS 2 PRECEDING),
  SMax = MAX(Amount) OVER (PARTITION BY AcctId ORDER BY TxnDate ROWS 2 PRECEDING),
  SSum = SUM(Amount) OVER (PARTITION BY AcctId ORDER BY TxnDate ROWS 2 PRECEDING)
 FROM TxnData
 ORDER BY AcctId, TxnDate
GO

-- ROWS vs RANGE clause

SELECT AcctId, TxnDate, Amount,
  SumByRows    = SUM(Amount) OVER (ORDER BY TxnDate ROWS UNBOUNDED PRECEDING),
  SumByRange   = SUM(Amount) OVER (ORDER BY TxnDate RANGE UNBOUNDED PRECEDING)
 FROM TxnData
 WHERE AcctId = 2
 ORDER BY TxnDate
GO

-- Cleanup

DROP TABLE TxnData
GO
