/* =================== Python in SQL Server 2017+ =================== */

CREATE DATABASE MyDB
GO

USE MyDB
GO

DROP TABLE IF EXISTS Sales

CREATE TABLE Sales(
	[Year] varchar(20),
	[Quarter] varchar(20),
	Customer varchar(20),
	Sales int
)

INSERT INTO Sales VALUES
 ('2014', 'Q1', 'Walmart', 18000),
 ('2014', 'Q2', 'Walmart', 81000),
 ('2014', 'Q3', 'Walmart', 72110),
 ('2014', 'Q4', 'Walmart', 91000),
 ('2014', 'Q1', 'GE', 31000),
 ('2014', 'Q2', 'GE', 81200),
 ('2014', 'Q3', 'GE', 95000),
 ('2014', 'Q4', 'GE', 17721),
 ('2014', 'Q1', 'Pepsi', 90002),
 ('2014', 'Q2', 'Pepsi', 53001),
 ('2014', 'Q3', 'Pepsi', 80210),
 ('2014', 'Q4', 'Pepsi', 90203),
 ('2014', 'Q1', 'Raymond', 109220),
 ('2014', 'Q2', 'Raymond', 89000),
 ('2014', 'Q3', 'Raymond', 100000),
 ('2014', 'Q4', 'Raymond', 910203),
 ('2015', 'Q1', 'Walmart', 16000),
 ('2015', 'Q2', 'Walmart', 82000),
 ('2015', 'Q3', 'Walmart', 73110),
 ('2015', 'Q4', 'Walmart', 92000),
 ('2015', 'Q1', 'GE', 33000),
 ('2015', 'Q2', 'GE', 80200),
 ('2015', 'Q3', 'GE', 92000),
 ('2015', 'Q4', 'GE', 19721),
 ('2015', 'Q1', 'Pepsi', 80002),
 ('2015', 'Q2', 'Pepsi', 43001),
 ('2015', 'Q3', 'Pepsi', 70210),
 ('2015', 'Q4', 'Pepsi', 80203),
 ('2015', 'Q1', 'Raymond', 119220),
 ('2015', 'Q2', 'Raymond', 99000),
 ('2015', 'Q3', 'Raymond', 110000),
 ('2015', 'Q4', 'Raymond', 920203)

-- Raw sales data
SELECT * FROM Sales

-- Use CUBE and PIVOT to generate a matrix from the raw data for 2 row headers (year, customer)
SELECT * FROM (
	SELECT
		ISNULL([Year], 'xTOTAL')	AS [Year],
		ISNULL([Quarter], 'xTOTAL')	AS [Quarter],
		ISNULL(Customer, 'xTOTAL')	AS Customer,
		SUM(Sales)					AS Sales
	FROM 
		Sales
	GROUP BY
		[Year], [Quarter], Customer
	WITH CUBE
) AS c
PIVOT(
	SUM(Sales) FOR [Quarter] IN (Q1, Q2, Q3, Q4, xTOTAL)
) AS p
WHERE
	[Year] != 'xTOTAL' OR ([Year] = 'xTOTAL' AND Customer = 'xTOTAL')	-- eliminate meaningless customer-per-quarter totals for all years
ORDER BY
	[Year]

-- Same query will become more complex when > 2 row headers (year, client) is needed
GO

EXEC sp_configure 'external scripts enabled', 1
RECONFIGURE

-- Using a pandas crosstab in Python is much easier
--  https://pandas.pydata.org/docs/reference/api/pandas.crosstab.html
EXECUTE sp_execute_external_script
	@language = N'Python',
	@script = N'
import pandas as pd

# Aggregate sum and pivot quarters into a new dataframe
ct = pd.crosstab(
	index	= [InputDataSet.Year, InputDataSet.Customer],
	columns	= InputDataSet.Quarter,
	values	= InputDataSet.Sales,
	aggfunc	= sum,
	margins	= True)

ct.sort_index(inplace = True)		# Sort the dataframe
ct.reset_index(inplace = True)		# Reset indexes

OutputDataSet = ct
	',
	@input_data_1 = N'SELECT * FROM Sales'
	WITH RESULT SETS (([Year] nvarchar(10), Customer nvarchar(10), Q1 int, Q2 int, Q3 int, Q4 int,Total int))

-- A little extra effort to add in the year totals
EXECUTE sp_execute_external_script
	@language = N'Python',
	@script = N'
import pandas as pd

# Aggregate sum and pivot quarters into a new dataframe (has all-year totals, but missing totals for 2014 and 2015)
ct = pd.crosstab(
	index	= [InputDataSet.Year, InputDataSet.Customer],
	columns	= InputDataSet.Quarter,
	values	= InputDataSet.Sales,
	aggfunc	= sum,
	margins	= True)

# Aggregate sum and pivot quarters for 2014 and 2015 year totals (also includes all-year totals, which is now a duplicate)
ctyt = pd.crosstab(
	index	= [InputDataSet.Year, "xTOTAL"],
	columns	= InputDataSet.Quarter,
	values	= InputDataSet.Sales,
	aggfunc	= sum,
	margins	= True)

result = pd.concat([ct, ctyt])		# Concatenate the two data frames into a final dataframe
result.sort_index(inplace = True)	# Sort the dataframe
result.reset_index(inplace = True)	# Reset indexes
result = result.drop_duplicates()	# Eliminate the one duplicate row with all-year totals

OutputDataSet = result
',
	@input_data_1 = N'SELECT * FROM Sales'
	WITH RESULT SETS (([Year] nvarchar(10), Customer nvarchar(10), Q1 int, Q2 int, Q3 int, Q4 int,Total int))

-- Compare with the T-SQL version giving same results
SELECT * FROM (
	SELECT
		ISNULL([Year], 'xTOTAL')	AS [Year],
		ISNULL([Quarter], 'xTOTAL')	AS [Quarter],
		ISNULL(Customer, 'xTOTAL')	AS Customer,
		SUM(Sales)					AS Sales
	FROM 
		Sales
	GROUP BY
		[Year], [Quarter], Customer
	WITH CUBE
) AS c
PIVOT(
	SUM(Sales) FOR [Quarter] IN (Q1, Q2, Q3, Q4, xTOTAL)
) AS p
WHERE
	[Year] != 'xTOTAL' OR ([Year] = 'xTOTAL' AND Customer = 'xTOTAL')	-- eliminate meaningless customer-per-quarter totals for all years
ORDER BY
	[Year]

-- Cleanup
DROP TABLE Sales
GO
EXEC sp_configure 'external scripts enabled', 0
RECONFIGURE



-- https://docs.microsoft.com/en-us/sql/advanced-analytics/tutorials/sqldev-py3-explore-and-visualize-the-data?view=sql-server-ver15
