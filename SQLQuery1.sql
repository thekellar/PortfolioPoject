Select *
From PortfolioProjectFinal..CovidDeaths
Where continent is not null
order by 3,4

--Select *
--From PortfolioProjectFinal..CovidVaccinations
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProjectFinal..CovidDeaths
order by 1,2

-- total cases vs total deaths

Select Location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProjectFinal..CovidDeaths
order by 1,2

Select Location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProjectFinal..CovidDeaths
Where location= 'India'
order by 1,2

-- Total Cases vs Population
--Shows what Percentage of population that got Covid
Select Location, date, Population, total_cases,  total_deaths, (total_cases/Population)*100 as PercentagePopulationInfected
From PortfolioProjectFinal..CovidDeaths
--Where location= 'India'
order by 1,2

-- Countries with Highest Infection Rates compared to Population


Select Location, Population, MAX(total_cases) as HighestInfectionCount,  MAX((total_cases/Population))*100 
as PercentagePopulationInfected
From PortfolioProjectFinal..CovidDeaths
--Where location= 'India'
Group by Location, Population
order by PercentagePopulationInfected desc

-- Showing countries with Highest death count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProjectFinal..CovidDeaths
--Where location= 'India'
Where continent is not null
Group by Location
order by TotalDeathCount desc

-- Same thing by Continent

Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProjectFinal..CovidDeaths
--Where location= 'India'
Where continent is null
Group by location
order by TotalDeathCount desc

--Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
--From PortfolioProjectFinal..CovidDeaths
----Where location= 'India'
--Where continent is not null
--Group by continent
--order by TotalDeathCount desc

--Showing continents with highest death count per population
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProjectFinal..CovidDeaths
--Where location= 'India'
Where continent is not null
Group by continent
order by TotalDeathCount desc

-- global numbers
Select date,SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_cases as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProjectFinal..CovidDeaths
--Where location= 'India'
where continent is not null 
Group by date
order by 1,2
-- we can get just the total cases in the world if we remove date nad group by line as well

--Total Population vs Vaccination
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) 
OVER (Partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
From PortfolioProjectFinal..CovidDeaths dea
Join PortfolioProjectFinal..CovidVaccinations vac
     On dea.location=vac.location
	 and dea.date=vac.date
where dea.continent is not null
order by 2,3


--USE CTE
 With PopvsVac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
 as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) 
OVER (Partition by dea.location Order by dea.location,dea.date)
as RollingPeopleVaccinated
From PortfolioProjectFinal..CovidDeaths dea
Join PortfolioProjectFinal..CovidVaccinations vac
     On dea.location=vac.location
	 and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
Select*, (RollingPeopleVaccinated/Population)*100
From PopvsVac

--TEMP TABLE

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric, 
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) 
OVER (Partition by dea.location Order by dea.location,dea.date)
as RollingPeopleVaccinated
From PortfolioProjectFinal..CovidDeaths dea
Join PortfolioProjectFinal..CovidVaccinations vac
     On dea.location=vac.location
	 and dea.date=vac.date
where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

--Creating View for later visualization

Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) 
OVER (Partition by dea.location Order by dea.location,dea.date)
as RollingPeopleVaccinated
From PortfolioProjectFinal..CovidDeaths dea
Join PortfolioProjectFinal..CovidVaccinations vac
     On dea.location=vac.location
	 and dea.date=vac.date
where dea.continent is not null
--order by 2,3


Select * from PercentPopulationVaccinated






