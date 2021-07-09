--Selecting All Data
SELECT *
FROM GDPPortfolioProject..RealGDP

--Looking at Countries on 2019
SELECT *
FROM GDPPortfolioProject..RealGDP
WHERE year like '2019'
ORDER BY country

--Highest Population (in millions) in 2019
SELECT country, year,
SUM(cast(population_in_millions as int)) as total_population_in_millions
FROM GDPPortfolioProject..RealGDP 
WHERE year like '2019'
GROUP BY country, year
order by 1

--Output/Expendtirue from Highest to Lowest in 2019
Select country, year, SUM(Output_GDP)/SUM(Expenditure_GDP)*100 as ExpenditureVSOutput
FROM GDPPortfolioProject..RealGDP 
WHERE year like '2019'
GROUP BY country, year
order by 3 DESC


--DROP Table if exists ....


Select *
FROM GDPPortfolioProject..PriceGDP

--Making Cummulative Output GDP for Chained PPPs

Select price.country, price.year, real.currency_unit, Output_GDP,
SUM(Output_GDP) OVER (Partition by price.country Order by price.country, price.year) as CummulativeOutputGDP
From GDPPortfolioProject..PriceGDP price
Join GDPPortfolioProject..RealGDP real
	On price.country = real.country
	and price.year = real.year
--Where price.year is not null

--Comparing Chained PPPs and CurrentPPPs

Select price.country, price.year, 
SUM(Output_GDP)/SUM(Expenditure_GDP)*100 as ExpenditureVSOutput_ForChainedPPPs,
SUM(Output_GDP_current_PPPs)/SUM(Expenditure_GDP_current_PPPs)*100 as ExpenditureVSOutput_ForCurrentPPPs
From GDPPortfolioProject..PriceGDP price
Join GDPPortfolioProject..RealGDP real
	On price.country = real.country
	and price.year = real.year
--Where price.year is not null
Group by price.country, price.year
Order by 1,2

--SUBQUERIES

--Subquery in Select
SELECT country, year, (Select AVG(CapitalStock_current_PPPs) FROM GDPPortfolioProject..PriceGDP) as AVGCapitalStockCurrentPPPs
FROM GDPPortfolioProject..PriceGDP

SELECT country, year, AVG(CapitalStock_current_PPPs) over () as AVGCapitalStockCurrentPPPs
FROM GDPPortfolioProject..PriceGDP

--Subquery in FROM
SELECT a.country, a.year, AVGCapitalStockCurrentPPPs
FROM (SELECT country, year, CapitalStock_current_PPPs, AVG(CapitalStock_current_PPPs) over () as AVGCapitalStockCurrentPPPs
      FROM GDPPortfolioProject..PriceGDP) a 

--Subquery in WHERE
SELECT country, year, CapitalStock_current_PPPs
FROM GDPPortfolioProject..PriceGDP
WHERE country IN (
	SELECT country
	FROM GDPPortfolioProject..PriceGDP
	WHERE year like '2019')