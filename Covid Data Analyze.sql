use [ PortfolioProject];

--- Catch a glimpse of what our data looks like ---

select *
from CovidDeaths
order by location

--------------- INFORMATION about each COUNTRY and REGION ---------------

select
	iso_code, continent, location, max(cast(population as int)) Population,
	max(total_cases) 'Total Cases', max(total_deaths) 'Total Deaths'
from CovidDeaths
where iso_code not like '%OWID%'
group by iso_code, continent, location
order by location

--------- TOTAL CASES per COUNTRY ----------

select
	location, max(total_cases) 'Total Cases'
from CovidDeaths
where iso_code not like '%OWID%'
group by location
order by 'Total Cases' desc;

---------- TOTAL DEATHS per COUNTRY ----------

select
	location, max(total_deaths) TotalDeaths
from CovidDeaths
where iso_code not like '%OWID%'
group by location
order by TotalDeaths desc;

---------- TOTAL DEATHS per CONTINENT ----------

select
	continent, max(total_deaths) 'Total Deaths'
from CovidDeaths
where continent != ''
group by continent
order by 'Total Deaths' desc;

------------------------- DEATH RATE for each COUNTRY ---------------------------

select
	location, max(total_deaths) as 'Total Deaths', max(total_cases) 'Total Cases',
	max(total_deaths) / max(cast(total_cases as float))*100 as 'DeathPerCase (%)'
from CovidDeaths
where total_cases != 0
group by location
order by 'DeathPerCase (%)' desc

------------------ DEATHS RATE GROWTH for each COUNTRY ---------------------

declare @location varchar(50) = 'Pakistan' --store the COUNTRY NAME as location
select
	location, date, total_deaths, total_cases,
	(total_deaths) / (cast(total_cases as float))*100 as 'DeathPerCase (%)'
from CovidDeaths
where total_cases != 0 --and location = @location -- If you want for a specific COUNTRY
order by location

------------------------ TOTAL CASES per POPULATION for each COUNTRY ------------------------

select
	location, population, max(total_cases) 'Total Cases',
	max(cast(total_cases as float)) / max(cast(population as int))*100 'Population Infected (%)'
from CovidDeaths
where iso_code not like '%OWID%'
group by location, population
order by 'Population Infected (%)' desc;
