/* =================== R in SQL Server 2017+ =================== */

EXEC sp_configure 'external scripts enabled', 1
RECONFIGURE
GO

DROP DATABASE IF EXISTS MyDB
GO

CREATE DATABASE MyDB
GO

USE MyDB

DROP TABLE IF EXISTS Club
DROP TABLE IF EXISTS Player
DROP TABLE IF EXISTS PlayedFor

CREATE TABLE Club (Name varchar(100)) AS NODE
CREATE TABLE Player (Name varchar(100)) AS NODE
CREATE TABLE PlayedFor AS EDGE

INSERT INTO Club([Name]) VALUES
	('Tottenham Hotspur'), ('Chelsea'), ('Manchester City'), ('Arsenal'), ('West Ham United')

INSERT INTO Player([Name]) VALUES
	('Frank Lampard'), ('Petr Cech'), ('Cesc Fabregas'), ('Gael Clichy'), ('William Gallas')

INSERT INTO PlayedFor ($to_id, $from_id) VALUES 
	-- Frank Lampard
	((SELECT $node_id FROM Club WHERE [Name] = 'Chelsea'), (SELECT $node_id FROM Player WHERE [Name] = 'Frank Lampard')), 
	((SELECT $node_id FROM Club WHERE [Name] = 'Manchester City'), (SELECT $node_id FROM Player WHERE [Name] = 'Frank Lampard')), 
	((SELECT $node_id FROM Club WHERE [Name] = 'West Ham United'), (SELECT $node_id FROM Player WHERE [Name] = 'Frank Lampard')),
	-- William Gallas
	((SELECT $node_id FROM Club WHERE [Name] = 'Chelsea'), (SELECT $node_id FROM Player WHERE [Name] = 'William Gallas')), 
	((SELECT $node_id FROM Club WHERE [Name] = 'Arsenal'), (SELECT $node_id FROM Player WHERE [Name] = 'William Gallas')), 
	((SELECT $node_id FROM Club WHERE [Name] = 'Tottenham Hotspur'), (SELECT $node_id FROM Player WHERE [Name] = 'William Gallas')),
	-- Gael Clichy
	((SELECT $node_id FROM Club WHERE [Name] = 'Manchester City'), (SELECT $node_id FROM Player WHERE [Name] = 'Gael Clichy')), 
	((SELECT $node_id FROM Club WHERE [Name] = 'Arsenal'), (SELECT $node_id FROM Player WHERE [Name] = 'Gael Clichy')),
	-- Cesc Fabregas
	((SELECT $node_id FROM Club WHERE [Name] = 'Chelsea'), (SELECT $node_id FROM Player WHERE [Name] = 'Cesc Fabregas')), 
	((SELECT $node_id FROM Club WHERE [Name] = 'Arsenal'), (SELECT $node_id FROM Player WHERE [Name] = 'Cesc Fabregas')),
	-- Petr Cech
	((SELECT $node_id FROM Club WHERE [Name] = 'Chelsea'), (SELECT $node_id FROM Player WHERE [Name] = 'Petr Cech')), 
	((SELECT $node_id FROM Club WHERE [Name] = 'Arsenal'), (SELECT $node_id FROM Player WHERE [Name] = 'Petr Cech'))

/*
	R package Dependencies:

		The standard R install.packages command is not recommended for adding R packages on SQL Server. Instead, use sqlmlutils as described in this article.
		https://docs.microsoft.com/en-us/sql/advanced-analytics/package-management/install-additional-r-packages-on-sql-server?view=sql-server-ver15

		Run C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\R_SERVICES\bin\R.exe
			install.packages("C:\\Users\\lenni\\Downloads\\<zipfile>")
			Create a personal library at 'C:\Users\lenni\OneDrive\Documents/R/win-library/3.5'

		igraph R package
			Download from http://igraph.org/nightly/get/r-win/igraph_1.0.1.zip
			install.packages("C:\\Users\\lenni\\Downloads\\igraph_1.0.1.zip")

		magrittr
			Download from https://cran.r-project.org/bin/windows/contrib/3.5/magrittr_1.5.zip
			install.packages("C:\\Users\\lenni\\Downloads\\magrittr_1.5.zip")
*/

EXECUTE sp_execute_external_script @language = N'R',
	@script = N'
		require(igraph)
		g <- graph.data.frame(graphdf)
		V(g)$label.cex <- 2
		png(filename = "C:/Users/lenni/OneDrive/Documents/PLVeterans.png", height = 800, width = 1500, res = 100);
		plot(g, vertex.label.family = "sans", vertex.size = 5)
		dev.off()
	',
	@input_data_1 = N'
		SELECT p.Name AS PlayerName, c.Name AS ClubName
		FROM Player AS p, PlayedFor, Club AS c
		WHERE MATCH(p-(PlayedFor)->c)
	',
	@input_data_1_name = N'graphdf'
GO


-- Install sqlmlutils on the client computer
--  Download the latest sqlmlutils zip file from https://github.com/Microsoft/sqlmlutils/tree/master/R/dist to the client computer. Don't unzip the file.

EXECUTE sp_execute_external_script @language=N'R'
, @script = N'str(OutputDataSet); packagematrix <- installed.packages(); NameOnly <- packagematrix[,1];
OutputDataSet <- as.data.frame(NameOnly);' ,@input_data_1 = N'SELECT 1 as col'
WITH RESULT SETS ((PackageName nvarchar(250) ));
GO












-- https://www.red-gate.com/simple-talk/sql/bi/sql-server-r-services-digging-r-language/

USE AdventureWorks2017;
GO
 
DECLARE @rscript NVARCHAR(MAX);
SET @rscript = N'
 
  # import scales and ggplot2 packages
  library(scales)
  library(ggplot2)
 
  # set up report file for chart
  reportfile <- "C:\\DataFiles\\SalesReport.png"
  png(filename=reportfile, width=1000, height=600)
 
  # construct data frame
  sales <- InputDataSet
  c1 <- levels(sales$SalesTerritories)
  c2 <- round(tapply(sales$Subtotal, sales$SalesTerritories, sum))
  salesdf <- data.frame(c1, c2)
  names(salesdf) <- c("Territories", "Sales")
 
  # generate bar chart
  barchart <- ggplot(salesdf, aes(x=Territories, y=Sales)) + 
    labs(title="Total Sales per Territory", x="Sales Territories \n (with country code)", y="Sales Amounts") +
    geom_bar(stat="identity", color="green", size=1, fill="lightgreen") + 
    coord_flip() + xlim(rev(levels(sales$SalesTerritories))) +
    scale_y_continuous(labels=function(x) format(x, big.mark=",", scientific=FALSE)) +
    geom_text(aes(label=comma(Sales), ymax=100, ymin=0), size=4, hjust=0, position=position_fill())
  print(barchart)
  dev.off()';
 
DECLARE @sqlscript NVARCHAR(MAX);
SET @sqlscript = N'
  SELECT h.Subtotal, 
    t.Name + '' ('' + t.CountryRegionCode + '')'' AS SalesTerritories
  FROM Sales.SalesOrderHeader h INNER JOIN Sales.SalesTerritory t
    ON h.TerritoryID = t.TerritoryID;';
 
EXEC sp_execute_external_script
  @language = N'R',
  @script = @rscript,
  @input_data_1 = @sqlscript
  WITH RESULT SETS NONE; 
GO











  SELECT h.Subtotal, 
    t.Name + ' (' + t.CountryRegionCode + ')' AS SalesTerritories
  FROM Sales.SalesOrderHeader h INNER JOIN Sales.SalesTerritory t
    ON h.TerritoryID = t.TerritoryID;
