/* =================== Python in SQL Server =================== */

-- https://learn.microsoft.com/en-us/sql/machine-learning/install/sql-machine-learning-services-windows-install-sql-2022?view=sql-server-ver16
-- https://docs.microsoft.com/en-us/sql/advanced-analytics/tutorials/sqldev-py3-explore-and-visualize-the-data?view=sql-server-ver15

EXEC sp_configure 'external scripts enabled', 1
RECONFIGURE
GO

EXEC sp_execute_external_script
	@script = N'import sys;print("Hello from Python " + sys.version)',
	@language=N'Python'
GO

-- Do some calculations, and write the result to STDOUT
DECLARE @script nvarchar(max) = N'
a = 1
b = 2
c = a / b
d = a * b
print(c, d)
'
EXEC sp_execute_external_script @language = N'Python', @script = @script
GO

-- Whatever data frame gets stored to OutputDataSet is what gets returned
DECLARE @script nvarchar(max) = N'
import pandas as pd
OutputDataSet = pd.DataFrame(list(range(1, 5)))
'
EXEC sp_execute_external_script @language = N'Python', @script = @script
GO


USE AdventureWorks2019
GO

-- Whatever T-SQL query gets passed as @input_data_1 is fed into the InputDataSet data frame
DECLARE @script nvarchar(max) = N'
OutputDataSet = InputDataSet
'
DECLARE @input nvarchar(max) = N'
	SELECT FirstName, LastName, CONVERT(float, SalesYTD) AS SalesYTD
	FROM Sales.vSalesPerson
	WHERE SalesYTD > 2000000
	ORDER BY SalesYTD DESC
'
EXEC sp_execute_external_script @language = N'Python', @script = @script,
    @input_data_1 = @input
GO

-- Do something useful with Python, like divide SalesYTD by 7 and round to two decimal places
DECLARE @script nvarchar(max) = N'
OutputDataSet = InputDataSet
OutputDataSet["JulyMonthlyAverage"] = round(InputDataSet["SalesYTD"] / 7, 2)
'
DECLARE @input nvarchar(max) = N'
	SELECT FirstName, LastName, CONVERT(float, SalesYTD) AS SalesYTD
	FROM Sales.vSalesPerson
	WHERE SalesYTD > 2000000
	ORDER BY SalesYTD DESC
'
EXEC sp_execute_external_script @language = N'Python', @script = @script,
    @input_data_1 = @input
GO

-- Override the default InputDataSet and OutputDataSet data frame names
DECLARE @script nvarchar(max) = N'
MonthlySales = SalesPersonData
MonthlySales["JulyMonthlyAverage"] = round(SalesPersonData["SalesYTD"] / 7, 2)
'
DECLARE @input nvarchar(max) = N'
	SELECT FirstName, LastName, CONVERT(float, SalesYTD) AS SalesYTD
	FROM Sales.vSalesPerson
	WHERE SalesYTD > 2000000
	ORDER BY SalesYTD DESC
'
EXEC sp_execute_external_script @language = N'Python', @script = @script,
    @input_data_1 = @input,
	@input_data_1_name = N'SalesPersonData',
	@output_data_1_name = N'MonthlySales'
GO

-- Use WITH RESULT SETS to define column names and data types to the output data frame
DECLARE @script nvarchar(max) = N'
MonthlySales = SalesPersonData
MonthlySales["JulyMonthlyAverage"] = round(SalesPersonData["SalesYTD"] / 7, 2)
'
DECLARE @input nvarchar(max) = N'
	SELECT FirstName, LastName, CONVERT(float, SalesYTD) AS SalesYTD
	FROM Sales.vSalesPerson
	WHERE SalesYTD > 2000000
	ORDER BY SalesYTD DESC
'
EXEC sp_execute_external_script @language = N'Python', @script = @script,
    @input_data_1 = @input,
	@input_data_1_name = N'SalesPersonData',
	@output_data_1_name = N'MonthlySales'
	WITH RESULT SETS(
		(FirstName varchar(max), LastName varchar(max), SalesYTD money, JulyMonthlyAverage money)
	)
GO

-- Supply input parameters to the Python code and/or source query
DECLARE @script nvarchar(max) = N'
MonthlySales = SalesPersonData
MonthlySales["MonthlyAverage"] = round(SalesPersonData["SalesYTD"] / MonthNumber, 2)
'
DECLARE @input nvarchar(max) = N'
	SELECT FirstName, LastName, CONVERT(float, SalesYTD) AS SalesYTD
	FROM Sales.vSalesPerson
	WHERE SalesYTD > @MinSales
	ORDER BY SalesYTD DESC
'
EXEC sp_execute_external_script @language = N'Python', @script = @script,
    @input_data_1 = @input,
	@input_data_1_name = N'SalesPersonData',
	@output_data_1_name = N'MonthlySales',
	@params = N'@MinSales float, @MonthNumber tinyint',
	@MinSales = 2000000,
	@MonthNumber = 7
	WITH RESULT SETS(
		(FirstName varchar(max), LastName varchar(max), SalesYTD money, MonthlyAverage money)
	)
GO

-- Embed Python scripts inside stored procedures
CREATE OR ALTER PROCEDURE GetMonthlyAverages (
	@MinSales money,
	@MonthNumber tinyint
) AS
BEGIN
	DECLARE @script nvarchar(max) = N'
MonthlySales = SalesPersonData
MonthlySales["MonthlyAverage"] = round(SalesPersonData["SalesYTD"] / MonthNumber, 2)
	'
	DECLARE @input nvarchar(max) = N'
		SELECT FirstName, LastName, CONVERT(float, SalesYTD) AS SalesYTD
		FROM Sales.vSalesPerson
		WHERE SalesYTD > @MinSales
		ORDER BY SalesYTD DESC
	'
	EXEC sp_execute_external_script @language = N'Python', @script = @script,
		@input_data_1 = @input,
		@input_data_1_name = N'SalesPersonData',
		@output_data_1_name = N'MonthlySales',
		@params = N'@MinSales float, @MonthNumber tinyint',
		@MinSales = @MinSales,
		@MonthNumber = @MonthNumber
		WITH RESULT SETS(
			(FirstName varchar(max), LastName varchar(max), SalesYTD money, MonthlyAverage money)
		)
END

EXEC GetMonthlyAverages @MinSales = 2000000, @MonthNumber = 7
EXEC GetMonthlyAverages @MinSales = 2000000, @MonthNumber = 12
EXEC GetMonthlyAverages @MinSales = 1000000, @MonthNumber = 12

DROP PROCEDURE IF EXISTS GetMonthlyAverages
GO

-- Do a crosstabs

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
		ISNULL([Year], 'All')		AS [Year],
		ISNULL([Quarter], 'All')	AS [Quarter],
		ISNULL(Customer, 'All')		AS Customer,
		SUM(Sales)					AS Sales
	FROM 
		Sales
	GROUP BY
		[Year], [Quarter], Customer
	WITH CUBE
) AS c
PIVOT(
	SUM(Sales) FOR [Quarter] IN (Q1, Q2, Q3, Q4, [All])
) AS p
WHERE
	Customer != 'All' AND [Year] != 'All' OR ([Year] = 'All' AND Customer = 'All')	-- eliminate meaningless customer-per-quarter totals for all years
ORDER BY
	[Year]

-- Same query will become more complex when > 2 row headers (year, client) is needed
GO

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

-- Compare with the T-SQL version giving same results
SELECT * FROM (
	SELECT
		ISNULL([Year], 'All')	AS [Year],
		ISNULL([Quarter], 'All')	AS [Quarter],
		ISNULL(Customer, 'All')	AS Customer,
		SUM(Sales)					AS Sales
	FROM 
		Sales
	GROUP BY
		[Year], [Quarter], Customer
	WITH CUBE
) AS c
PIVOT(
	SUM(Sales) FOR [Quarter] IN (Q1, Q2, Q3, Q4, [All])
) AS p
WHERE
	Customer != 'All' AND [Year] != 'All' OR ([Year] = 'All' AND Customer = 'All')	-- eliminate meaningless customer-per-quarter totals for all years
ORDER BY
	[Year]

-- Cleanup
DROP TABLE IF EXISTS Sales
GO
EXEC sp_configure 'external scripts enabled', 0
RECONFIGURE
