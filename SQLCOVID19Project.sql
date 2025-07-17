-- Display all records from the CovidDeaths table sorted by columns 3 and 4 (likely location and date)
Select *
From PortfolioProject..CovidDeaths
order by 3, 4

-- View all records from the CovidVaccinations table (currently commented out)
-- Select *
-- From PortfolioProject..CovidVaccinations
-- order by 3, 4 

-- Retrieve essential COVID-19 metrics for all countries: location, date, cases, deaths, and population
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1, 2

-- Analyze the death rate in the Philippines by calculating the percentage of deaths out of total cases
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%philippines'
order by 1, 2

-- Determine the percentage of the population infected by comparing total cases to population
SELECT location, date, total_cases, population, (total_cases/population)*100 as InfectionRate
From PortfolioProject..CovidDeaths
-- WHERE location like '%Philippines%'
Order by 1, 2

-- Identify countries with the highest infection rates relative to their population
Select location, population, 
       MAX(total_cases) as HighestInfectionCount, 
       MAX((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
Group by Location, population
Order by PercentPopulationInfected desc

-- Identify countries with the highest total death count from COVID-19
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null 
Group by Location
order by TotalDeathCount desc

-- Compare total death counts by continent to determine which continents were most affected
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc

-- Aggregate global COVID-19 statistics: total cases, total deaths, and global death percentage
Select 
    SUM(new_cases) as TotalCases, 
    SUM(cast(new_deaths as int)) as TotalDeaths, 
    SUM(cast(new_deaths as int)) / SUM(new_cases) * 100 as GlobalDeathRate
From PortfolioProject..CovidDeaths
Where continent is not null 
order by 1, 2

-- Compare population to vaccination rollout; calculate cumulative vaccinations per location
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CONVERT(int, vac.new_vaccinations)) 
       OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated / population) * 100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.location = vac.location
   And dea.date = vac.date
Where dea.continent is not null 
order by 2, 3

-- Use a CTE to calculate the cumulative number of people vaccinated per location and derive vaccination rate
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) as
(
    Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
           SUM(CONVERT(int, vac.new_vaccinations)) 
           OVER (Partition by dea.Location Order by dea.Location, dea.Date) as RollingPeopleVaccinated
    From PortfolioProject..CovidDeaths dea
    Join PortfolioProject..CovidVaccinations vac
        On dea.location = vac.location
       And dea.date = vac.date
    Where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated / Population) * 100 as VaccinationRate
From PopvsVac

-- Create a temporary table to store vaccination calculations for further use or analysis
DROP Table if exists #PercentPopulationVaccinated

Create Table #PercentPopulationVaccinated
(
    Continent nvarchar(255),
    Location nvarchar(255),
    Date datetime,
    Population numeric,
    New_vaccinations numeric,
    RollingPeopleVaccinated numeric
)

-- Populate the temporary table with cumulative vaccination data
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CONVERT(int, vac.new_vaccinations)) 
       OVER (Partition by dea.Location Order by dea.Location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.location = vac.location
   And dea.date = vac.date

-- Calculate the percentage of population vaccinated using the temp table
Select *, (RollingPeopleVaccinated / Population) * 100 as VaccinationRate
From #PercentPopulationVaccinated

-- Create a view for persistent use of vaccination data in dashboards or reports
Create View PercentPopulationVaccinatedd as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CONVERT(int, vac.new_vaccinations)) 
       OVER (Partition by dea.Location Order by dea.Location, dea.Date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated / population) * 100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.location = vac.location
   And dea.date = vac.date
Where dea.continent is not null
