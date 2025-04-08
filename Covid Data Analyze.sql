-----------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------- ANALYZING COVID DEATH DATA ------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------

--- Catch a glimpse of what our data looks like ---

select *
from CovidDeaths
order by location;

------- COVID-19 in each COUNTRY ---------

select
	iso_code, continent, location,
	max(cast(population as int)) Population,
	max(total_cases) 'Total Cases',
	max(total_deaths) 'Total Deaths'
from CovidDeaths
where iso_code not like '%OWID%'
group by iso_code, continent, location
order by location;

---------- TOTAL DEATHS per CONTINENT ----------

select
	continent,
	max(total_deaths) 'Total Deaths'
from CovidDeaths
where continent != ''
group by continent
order by 'Total Deaths' desc;

------------------------- DEATH RATE for each COUNTRY ---------------------------

-- Shows the liklihood of DYING due to COVID in each of the LOCATIONS

select
	location,
	max(total_deaths) 'Total Deaths',
	max(total_cases) 'Total Cases',
	max(total_deaths) / max(cast(total_cases as float))*100 as 'DeathPerCase (%)'
from CovidDeaths
where total_cases != 0
group by location
order by 'DeathPerCase (%)' desc;

------------------ DEATHS RATE GROWTH for each COUNTRY ---------------------

declare @location varchar(50) = 'Pakistan' --store the COUNTRY NAME as location
select
	location,
	date,
	total_deaths,
	total_cases,
	(total_deaths) / (cast(total_cases as float))*100 'DeathPerCase (%)'
from CovidDeaths
where total_cases != 0 --and location = @location -- If you want for a specific COUNTRY
order by location

------------------------ TOTAL CASES per POPULATION for each COUNTRY ------------------------

-- Shows what percentage of a POPULATION that has been infected with COVID-19 for each LOCATION

select
	location,
	population,
	max(total_cases) 'Total Cases',
	max(cast(total_cases as float)) / max(cast(population as int))*100 'Population Infected (%)'
from CovidDeaths
where iso_code not like '%OWID%'
group by location, population
order by 'Population Infected (%)' desc;

------------------------ TOTAL DEATHS per POPULATION for each COUNTRY ------------------------

-- Shows what percentage of a POPULATION had DIED due to COVID-19 for each LOCATION

select
	location,
	population,
	max(total_deaths) 'Total Deaths',
	max(cast(total_deaths as float)) / max(cast(population as int))*100 'Population Died (%)'
from CovidDeaths
where iso_code not like '%OWID%'
group by location, population
order by 'Population Died (%)' desc;

-----------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------ ANALYZING COVID VACCINATION DATA -------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------

------------------------ TOTAL VACCINATIONS per POPULATION for each COUNTRY ------------------------

-- Shows what percentage of a POPULATION had been VACCINATED to COVID-19 for each LOCATION

select
	D.location,
	max(D.population),
	sum(convert(int, V.new_vaccinations)) 'Total Vaccinations',
	max(V.new_vaccinations / convert(float, D.population)) * 100 'Population Vaccinated (%)'
from
	CovidDeaths D
	join
	CovidVaccination V on
	D.location = V.location and D.date = V.date
where
	D.iso_code not like '%OWID%'
group by
	D.location
order by
	location

-----------------------------------------------------------------------------------------------------------------------------------------------
select * from CovidVaccination
where location = 'united states'

select continent, location, life_expectancy,cardiovasc_death_rate from CovidVaccination
where iso_code not like '%OWID%'
group by location, life_expectancy, cardiovasc_death_rate,continent
order by cardiovasc_death_rate desc