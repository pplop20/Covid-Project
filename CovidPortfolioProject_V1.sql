Select *
From PortfolioProject..CovidDeaths
order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations
--order by 3,4

--Data Selection (This is the data we will be using)
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2

--Total Cases vs Total deaths (Likelyhoood of dying if you contract covid in Peru)
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like'%peru%'
order by 1,2

--Total cases vs Population (Percentage of Population that has covid)
Select Location, date, total_cases, Population, (total_cases/population)*100 as InfectionPercentage
From PortfolioProject..CovidDeaths
Where location like'%peru%'
order by 1,2

--Countries with highest infection rate compared to their population
Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as InfectionPercentage
From PortfolioProject..CovidDeaths
Group by Location,Population
order by InfectionPercentage desc

--Countries with highest Death Count per Population
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Location
order by TotalDeathCount desc

--By Continent
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc

--Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
--From PortfolioProject..CovidDeaths
--Where continent is null
--Group by Location
--order by TotalDeathCount desc

--Continents with highest death count
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc

-- Global Numbers
 Select  SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,
 SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage 
 From PortfolioProject..CovidDeaths
 where continent is not null
 --Group by date
 order by 1,2


 --Joining Tables

 --Total Population vs Vaccinations
 '''Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location
 , dea.date) as PeopleVaccinated,
 --(PeopleVaccinated/population)*100
 From PortfolioProject..CovidVaccinations vac
 Join PortfolioProject..CovidDeaths dea
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3'''

--CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, PeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location
, dea.date) as PeopleVaccinated
 --(PeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (PeopleVaccinated/Population)*100
From PopvsVac

--Creating View for later visualiaztions

Create View PopvsVac as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location
, dea.date) as PeopleVaccinated
 --(PeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

