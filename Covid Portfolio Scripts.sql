select *
from PortfolioProject..CovidDeaths
where continent is not null

select *
from PortfolioProject..CovidVaccinations

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

-- Total Cases Vs Total Deaths
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from PortfolioProject..CovidDeaths
where location = 'India' and continent is not null
order by 1,2

-- As of 9th June 2021, there is a 1.22% chance for an individual to lose his life if he/she contracted with COVID-19

--Total Cases Vs Population - shows Population% infected by Covid
select location, date, total_cases, population, (total_cases/population)*100 as Infectedpopulationpercentage
from PortfolioProject..CovidDeaths
where location = 'India' and continent is not null
order by 1,2

--Countries with highest infection rate against their population
select location,  max(total_cases) as HighestInfectionCount, population, max((total_cases/population))*100 as Infectedpopulationpercentage
from PortfolioProject..CovidDeaths
group by location,population
order by Infectedpopulationpercentage desc

--Countries with highest death count
select location,  max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by HighestDeathCount desc

--Continents with highest death count
select continent,  max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by HighestDeathCount desc

--WORLD NUMBERS
select sum(new_cases) as tot_cases, sum(cast(new_deaths as int)) as tot_deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
--group by date
order by 1,2

--Joining the 2 tables
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--TEMP TABLE
Drop table if exists #TempTable
create table #TempTable
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric
)
Insert into #TempTable
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

Select * from #TempTable

--VIEW CREATION
Create view Casesbycontinent as
select continent,  max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent 