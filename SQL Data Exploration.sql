--select *
--from PortfolioProject..CovidDeaths
--where continent is not null
--order by 3,4

select *
from PortfolioProject..CovidDeaths
order by 3,4

--select * 
--from PortfolioProject..CovidVaccinations
--order by 3,4


select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1, 2

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 As death_percentage
from PortfolioProject..CovidDeaths
where location = 'India' and continent is not null
order by 1, 2


select location, date, population, total_cases, (total_cases/population)*100 as percentage_population_infected
from PortfolioProject..CovidDeaths
where continent is not null
--where location = 'India'
order by 1, 2


select location, population, max(total_cases) as Highest_Infection_Count, max((total_cases/population))*100 as percentage_population_infected
from PortfolioProject..CovidDeaths
where continent is not null
group by location, population
order by percentage_population_infected desc

select continent, max(cast(total_deaths as int)) as total_death_Count
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by total_death_count desc


select location, max(cast(total_deaths as int)) as total_death_Count
from PortfolioProject..CovidDeaths
where continent is null
group by location
order by total_death_count desc


select continent, max(cast(total_deaths as int)) as total_death_Count
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by total_death_count desc

select SUM(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage 
from PortfolioProject..CovidDeaths
--where location = 'India' and 
where continent is not null
order by 1

select date, SUM(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage 
from PortfolioProject..CovidDeaths
--where location = 'India' and 
where continent is not null
group by date
order by 1
 

 select *
 from PortfolioProject..CovidDeaths dea
 join PortfolioProject..CovidVaccinations vac
 on
 dea.date = vac.date and dea.location = vac.location


 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as rolling_people_vaccinated
 from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3


With PopVsVac (continent, location, date, population, new_vaccinations, rolling_people_vaccinated) as
(
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as rolling_people_vaccinated
 from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null)
select *, (rolling_people_vaccinated/population)*100
from PopVsVac