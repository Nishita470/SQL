/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

-- Query 1: Initial Data Exploration
SELECT *
FROM SQL..CovidDeaths
WHERE continent IS NOT NULL 
ORDER BY 3, 4;

-- Query 2: Selecting Initial Data
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM SQL..CovidDeaths
WHERE continent IS NOT NULL 
ORDER BY 1, 2;

-- Query 3: Total Cases vs Total Deaths for States
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM SQL..CovidDeaths
WHERE location LIKE '%states%' AND continent IS NOT NULL 
ORDER BY 1, 2;

-- Query 4: Total Cases vs Population
SELECT Location, date, Population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
FROM SQL..CovidDeaths
ORDER BY 1, 2;

-- Query 5: Countries with Highest Infection Rate
SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM SQL..CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;

-- Query 6: Countries with Highest Death Count per Population
SELECT Location, MAX(CAST(Total_deaths AS INT)) AS TotalDeathCount
FROM SQL..CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY Location
ORDER BY TotalDeathCount DESC;

-- Query 7: Highest Death Count per Population by Continent
SELECT continent, MAX(CAST(Total_deaths AS INT)) AS TotalDeathCount
FROM SQL..CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- Query 8: Global Covid Statistics
SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT))/SUM(New_Cases)*100 AS DeathPercentage
FROM SQL..CovidDeaths
WHERE continent IS NOT NULL 
ORDER BY 1, 2;

-- Query 9: Total Population vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
FROM SQL..CovidDeaths dea
JOIN SQL..CovidVaccinations vac ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
ORDER BY 2, 3;

-- Query 10: Using CTE for Population vs Vaccinations
WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) AS (
    SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
    SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
    FROM SQL..CovidDeaths dea
    JOIN SQL..CovidVaccinations vac ON dea.location = vac.location AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL 
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac;

-- Query 11: Using Temp Table for Population vs Vaccinations
DROP TABLE IF EXISTS #PercentPopulationVaccinated;
CREATE TABLE #PercentPopulationVaccinated (
    Continent NVARCHAR(255),
    Location NVARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
);
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
FROM SQL..CovidDeaths dea
JOIN SQL..CovidVaccinations vac ON dea.location = vac.location AND dea.date = vac.date;
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated;

-- Query 12: Creating View for Population vs Vaccinations
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
FROM SQL..CovidDeaths dea
JOIN SQL..CovidVaccinations vac ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;
SELECT * FROM PercentPopulationVaccinated;
