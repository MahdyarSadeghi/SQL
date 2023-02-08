-- Looking at the CovidDeaths table
Select *
From dbo.CovidDeaths
Where continent is not NULL 
order by 3, 4

-- Looking at the CovidVaccination table
Select location, MAX(cast(people_vaccinated as numeric))
From dbo.CovidVaccinations
Where continent is not NULL
Group By location
Order By 1


-- total cases vs. total deaths
-- Shows likelihood of dying if you contract covid in your country
Select location, Max(total_deaths)/Max(total_cases) as DeathRate
From dbo.CovidDeaths
Where continent is not NULL
Group By location
Order By 1

-- total cases vs. population
-- Shows what percentage of population infected with Covid in each country
Select location, max(population) as population, Max(total_cases) as total_cases,  Max(total_cases)/Max(population) as InfectionRate
From dbo.CovidDeaths
Where continent is not NULL
Group By location
Order By 1

-- Shows the status of vacciantion in each country: total_vacciantion, percentage of fully vaccinated people, 
Select location, max(population) as population,
		Max(cast(total_vaccinations as numeric)) as total_vaccination,
		Max(cast(people_fully_vaccinated as numeric))/max(population) as fully_vaccinated_rate,
		Max(cast(total_boosters as numeric))/max(population) as boosters_rate
From dbo.CovidVaccinations
Where continent is not NULL
Group By location
Order By 1

-- Covid Vaccination status of each CONTINENT
Select continent, max(population) as population,
		Max(cast(total_vaccinations as numeric)) as total_vaccination,
		Max(cast(people_fully_vaccinated as numeric))/max(population) as fully_vaccinated_rate,
		Max(cast(total_boosters as numeric))/max(population) as boosters_rate
From dbo.CovidVaccinations
Where continent is not NULL
Group By continent
Order By 1

-- total cases vs. population & total cases vs. total deaths
-- Shows what percentage of population infected by Covid and shows Liklihood of dying if contract in you CONTINENT 
Select continent, Max(population) as population, 
		Max(total_cases) as total_cases,
		Max(total_deaths) as total_deaths,
		Max(total_cases)/Max(population) as InfectionRate,
		Max(total_deaths)/Max(total_cases) as DeathRate
From dbo.CovidDeaths
Where continent is not NULL
Group By continent
Order By continent

-- CREATE VIEW FOR LATER VISUALIZATIONS -> for each CONTINENT
Create View ContinentCovidStatus as

Select d.continent, Max(d.population) as population, 
		Max(total_cases) as total_cases,
		Max(total_deaths) as total_deaths,
		Max(total_cases)/Max(d.population) as InfectionRate,
		Max(total_deaths)/Max(total_cases) as DeathRate,
		Max(cast(total_vaccinations as numeric)) as total_vaccination,
		Max(cast(people_fully_vaccinated as numeric))/max(d.population) as fully_vaccinated_rate,
		Max(cast(total_boosters as numeric))/max(d.population) as boosters_rate

From dbo.CovidDeaths d
join  dbo.CovidVaccinations v
on d.location=v.location and d.date=v.date
Where d.continent is not null
Group By d.continent


-- CREATE VIEW FOR LATER VISUALIZATIONS -> for each COUNTRY
Create View LocationCovidStatus as

Select d.location, Max(d.population) as population, 
		Max(total_cases) as total_cases,
		Max(total_deaths) as total_deaths,
		Max(total_cases)/Max(d.population) as InfectionRate,
		Max(total_deaths)/Max(total_cases) as DeathRate,
		Max(cast(total_vaccinations as numeric)) as total_vaccination,
		Max(cast(people_fully_vaccinated as numeric))/max(d.population) as fully_vaccinated_rate,
		Max(cast(total_boosters as numeric))/max(d.population) as boosters_rate

From dbo.CovidDeaths d
join  dbo.CovidVaccinations v
on d.location=v.location and d.date=v.date
Where d.location is not null
Group By d.location