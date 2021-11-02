create database Covid_19
go

use Covid_19
go

-- Quiery the most important datas from CovidDeaths table.
select location, date, total_cases, new_cases, total_deaths, population from CovidDeaths
order by 1,2,3

-- Showing Death rate per day in Asian Countires.
select continent, location, date, total_cases, total_deaths, round((total_deaths/Total_cases)*100,2) as Death_rate_per_day from CovidDeaths
where continent like 'Asia'
order by 1,2,3

-- Looking at Highest amount of 
select location, population, date, max(total_cases) as Highest_Infection_per_Date, max((total_cases/population))*100 as PercentPopulationInfected from CovidDeaths
where continent is not null 
group by location, population, date
order by Highest_Infection_per_Date, PercentPopulationInfected DESC

-- Looking at countries with highest infection rate in each continent compare to population
select location, population, max(total_cases) as Highest_Infection_per_Date, max((total_cases/population))*100 as PercentPopulationInfected from CovidDeaths
where continent is not null 
group by location, population
order by PercentPopulationInfected DESC

-- Showing the total depths by countinent.
select location, max(cast(total_deaths as int)) as TotalDeathbyCountry from CovidDeaths
where continent is null
and location not in ('World', 'European Union', 'International')
group by location
order by TotalDeathbyCountry desc

-- Showing the total_cases, total_deaths and Deaths percentage
select sum(new_cases) as Total_cases, sum(cast(new_deaths as int)) as Total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage from CovidDeaths
where continent is not null
order by 1, 2

-- Join 2 tables of Vaccine and Deaths together basing on Date and location
    -- The frist way:
select * from CovidDeaths as CD, CovidVaccinations as CV
where CD.date = CV.date
  and CD.location = CV.location

    -- The second way:
select * from CovidDeaths as CD join CovidVaccinations as CV 
on CD.date = CV.date
  and CD.location = CV.location

    -- The third way: we use CovidDeaths is standard data to merger.
select * from CovidDeaths as CD left join CovidVaccinations as CV 
on CD.date = CV.date
  and CD.location = CV.location

   -- The fourth way: we use CovidVaccinate is standard data to merger.
select * from CovidDeaths as CD right join CovidVaccinations as CV 
on CD.date = CV.date
  and CD.location = CV.location


-- Looking at total case, deaths and total vaccination
select CD.continent, CD.location, sum(CD.new_cases) as TotalCases , sum(cast(CD.new_deaths as float)) as TotalDeaths, sum(cast(CV.new_vaccinations as float)) as TotalVaccinations from CovidDeaths as CD, CovidVaccinations as CV 
where CD.date = CV.date
  and CD.location = CV.location
  and CD.continent is not null
group by CD.continent, CD.location


-- Looking total population and vaccinations
select CD.continent, CD.location, CD.population, sum(convert(float,CV.new_vaccinations)) from CovidDeaths as CD join CovidVaccinations as CV
On CD.continent = CV.continent
  and CD.location = CV.location
where CD.continent is not null
group by CD.continent, CD.location, CD.population






