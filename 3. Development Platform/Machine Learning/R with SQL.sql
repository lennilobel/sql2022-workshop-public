/* =================== R in SQL Server 2017+ =================== */

EXEC sp_configure 'external scripts enabled', 1
RECONFIGURE
GO

-- Do some calculations, and write the result to STDOUT
DECLARE @script nvarchar(max) = N'
	a <- 1
	b <- 2
	c <- a / b
	d <- a * b
	print(c(c, d))
'
EXEC sp_execute_external_script @language = N'R', @script = @script
GO

-- Whatever data frame gets stored to OutputDataSet is what gets returned
DECLARE @script nvarchar(max) = N'
	OutputDataSet <- data.frame(seq(1, 4, 0.5))
'
EXEC sp_execute_external_script @language = N'R', @script = @script
GO

USE AdventureWorks2019
GO

-- Whatever T-SQL query gets passed as @input_data_1 is fed into the InputDataSet data frame
DECLARE @script nvarchar(max) = N'
	OutputDataSet <- InputDataSet
'
DECLARE @input nvarchar(max) = N'
	SELECT FirstName, LastName, SalesYTD
	FROM Sales.vSalesPerson
	WHERE SalesYTD > 2000000
	ORDER BY SalesYTD DESC
'
EXEC sp_execute_external_script @language = N'R', @script = @script,
    @input_data_1 = @input
GO

-- Do something useful with R, like divide SalesYTD by 7 and round to two decimal places
DECLARE @script nvarchar(max) = N'
	OutputDataSet <- InputDataSet
	OutputDataSet[,4] <- round(InputDataSet$SalesYTD / 7, 2)
'
DECLARE @input nvarchar(max) = N'
	SELECT FirstName, LastName, SalesYTD
	FROM Sales.vSalesPerson
	WHERE SalesYTD > 2000000
	ORDER BY SalesYTD DESC
'
EXEC sp_execute_external_script @language = N'R', @script = @script,
    @input_data_1 = @input
GO

-- Override the default InputDataSet and OutputDataSet data frame names
DECLARE @script nvarchar(max) = N'
	MonthlySales <- SqlData
	MonthlySales[,4] <- round(SqlData$SalesYTD / 7, 2)
'
DECLARE @input nvarchar(max) = N'
	SELECT FirstName, LastName, SalesYTD
	FROM Sales.vSalesPerson
	WHERE SalesYTD > 2000000
	ORDER BY SalesYTD DESC
'
EXEC sp_execute_external_script @language = N'R', @script = @script,
    @input_data_1 = @input,
	@input_data_1_name = N'SqlData',
	@output_data_1_name = N'MonthlySales'
GO

-- Use WITH RESULT SETS to define column names and data types to the output data frame
DECLARE @script nvarchar(max) = N'
	MonthlySales <- SqlData
	MonthlySales[,4] <- round(SqlData$SalesYTD / 7, 2)
'
DECLARE @input nvarchar(max) = N'
	SELECT FirstName, LastName, SalesYTD
	FROM Sales.vSalesPerson
	WHERE SalesYTD > 2000000
	ORDER BY SalesYTD DESC
'
EXEC sp_execute_external_script @language = N'R', @script = @script,
    @input_data_1 = @input,
	@input_data_1_name = N'SqlData',
	@output_data_1_name = N'MonthlySales'
	WITH RESULT SETS(
		(FirstName varchar(max), LastName varchar(max), SalesYTD money, MonthlyAverage money)
	)
GO

-- Supply input parameters to the R code and/or source query
DECLARE @script nvarchar(max) = N'
	MonthlySales <- SqlData
	MonthlySales[,4] <- round(SqlData$SalesYTD / MonthNumber, 2)
'
DECLARE @input nvarchar(max) = N'
	SELECT FirstName, LastName, SalesYTD
	FROM Sales.vSalesPerson
	WHERE SalesYTD > @MinSales
	ORDER BY SalesYTD DESC
'
EXEC sp_execute_external_script @language = N'R', @script = @script,
    @input_data_1 = @input,
	@input_data_1_name = N'SqlData',
	@output_data_1_name = N'MonthlySales',
	@params = N'@MinSales money, @MonthNumber tinyint',
	@MinSales = 2000000,
	@MonthNumber = 7
	WITH RESULT SETS(
		(FirstName varchar(max), LastName varchar(max), SalesYTD money, MonthlyAverage money)
	)
GO

-- Embed R scripts inside stored procedures
CREATE OR ALTER PROCEDURE GetMonthlyAverages (
	@MinSales money,
	@MonthNumber tinyint
) AS
BEGIN
	DECLARE @script nvarchar(max) = N'
		MonthlySales <- SqlData
		MonthlySales[,4] <- round(SqlData$SalesYTD / MonthNumber, 2)
	'
	DECLARE @input nvarchar(max) = N'
		SELECT FirstName, LastName, SalesYTD
		FROM Sales.vSalesPerson
		WHERE SalesYTD > @MinSales
		ORDER BY SalesYTD DESC
	'
	EXEC sp_execute_external_script @language = N'R', @script = @script,
		@input_data_1 = @input,
		@input_data_1_name = N'SqlData',
		@output_data_1_name = N'MonthlySales',
		@params = N'@MinSales money, @MonthNumber tinyint',
		@MinSales = @MinSales,
		@MonthNumber = @MonthNumber
		WITH RESULT SETS(
			(FirstName varchar(max), LastName varchar(max), SalesYTD money, MonthlyAverage money)
		)
END

EXEC GetMonthlyAverages @MinSales = 2000000, @MonthNumber = 7
EXEC GetMonthlyAverages @MinSales = 2000000, @MonthNumber = 12
EXEC GetMonthlyAverages @MinSales = 1000000, @MonthNumber = 12


-- Cleanup
DROP PROCEDURE IF EXISTS GetMonthlyAverages
GO
EXEC sp_configure 'external scripts enabled', 0
RECONFIGURE
GO
