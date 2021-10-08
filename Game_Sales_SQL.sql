/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (10) [Rank]
      ,[Name]
      ,[Platform]
      ,[Year]
      ,[Genre]
      ,[Publisher]
      ,[NA_Sales]
      ,[EU_Sales]
      ,[JP_Sales]
      ,[Other_Sales]
  FROM [master].[dbo].[ConsoleGames$]

  --1. What % of  global sales were in NA?
  -----------------------------------------------------
  SELECT sum(NA_Sales) as TotalNA_Sales, (sum(NA_Sales) + sum(EU_Sales) + sum(JP_Sales)) as Global_Sales, 
  round((sum(NA_Sales)/(sum(NA_Sales) + sum(EU_Sales) + sum(JP_Sales))*100),2) as NA_perc
  from [master].[dbo].[ConsoleGames$]

  /*Results*/
  /*TotalNA_Sales	Global_Sales	NA_perc
12931.5000000013	23877.75	54.16
  */

  --2. Extract a view of the console game titles ordered by platform name in asc order and year of release in desc order
  --------------------------------------------------------------------------------------------------------------------------
  CREATE VIEW [Console_Titles] AS
  (
  SELECT NAME, Platform, Year
  from [master].[dbo].[ConsoleGames$]
  )

  SELECT *
  FROM Console_Titles
  ORDER BY Platform ASC, YEAR DESC

  --3. For each game title extract and abbreviate the publisher by first 4 letters
  -----------------------------------------------------------------------------------
  SELECT Distinct(Name), UPPER(LEFT(Publisher, 4)) as Abbr_Publisher
  FROM [master].[dbo].[ConsoleGames$]
  WHERE Name is not NULL
    /*Sample Results*/
  /*
  Name						Abbr_Publisher
.hack//G.U. Vol.1//Rebirth			NAMC
.hack//G.U. Vol.2//Reminisce			NAMC
.hack//G.U. Vol.2//Reminisce (jp sales)		NAMC
.hack//G.U. Vol.3//Redemption			NAMC
.hack//Infection Part 1				ATAR
.hack//Link					NAMC
.hack//Mutation Part 2				ATAR
.hack//Outbreak Part 3				ATAR
.hack//Quarantine Part 4: The Final Chapter	ATAR
  */

  --4.Show the rolling sum in Role-playing games overtime in JP
   ---------------------------------------------------------------
  Create View [JP_RPG] as
 (
  SELECT Year, sum(JP_Sales) as Annual_ttl
  FROM ConsoleGames$
  WHERE Year is not NULL
  AND Genre = 'Role-Playing'
  GROUP BY Year)

  SELECT *,
  SUM(Annual_ttl) OVER(Order by Year) as RollingSum
  FROM JP_RPG
  ORDER BY Year

  --5.Show the rate of change in Role-playing games overtime in JP
   --------------------------------------------------------------------
  With JP_RPG_ROC as(
  Select *,
  lag(Annual_ttl, 1) over (order by year) as total
  From JP_RPG
  Group By Year, Annual_ttl
  )

  Select Year, Annual_ttl, ISNULL(total,0) as prev_ttl, 
    round(Annual_ttl - total,2) as annual_change
  From JP_RPG_ROC
  Order By Year
  /* Sample Result*/
/*	Year	Annual_ttl	prev_ttl	annual_change
	1986	1.56		0		NULL
	1987	12.54		1.56		10.98
	1988	17.34		12.54		4.8
	1989	6.6		17.34		-10.74
	1990	13.26		6.6		6.66
	1991	8.43		13.26		-4.83
	1992	20.49		8.43		12.06
	1993	15.75		20.49		-4.74
	1994	18.69		15.75		2.94
*/
  
  
 --6.From the years where the sales were less than the previous year, rank the top 3 years where the dip was greatest 
 ---------------------------------------------------------------------------------------------------------------------
   With JP_RPG_ROC as(
  Select *,
  lag(Annual_ttl, 1) over (order by year) as total
  From JP_RPG
  Group By Year, Annual_ttl
  )

  Select TOP(3) Year, Annual_ttl, ISNULL(total,0) as prev_ttl, 
    round(Annual_ttl - total,2) as annual_change
  From JP_RPG_ROC
  Where total is not NULL
  Order By annual_change ASC
   /* Sample Result*/
   /*
Year	Annual_ttl	prev_ttl	annual_change
2015	20.13		53.13			-33
2011	43.29		71.01			-27.72
2007	37.29		59.49			-22.2
   */
