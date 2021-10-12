
--look for location and the total cases vs deaths, the mean.


select location,date,total_cases,total_tests,total_deaths,(total_deaths/total_cases)  as 'mean' from dbo.[covide_ vaccination] 
where location like 'Ireland'
order by date


--look for location and the total cases vs population, the mean.
select location,date,population,total_cases,total_tests,total_deaths,(total_cases  / population)*100  as 'mean' from dbo.[covide_ vaccination] 
where location like 'Ireland'
order by date


select location,date,population,total_cases,total_tests,total_deaths,(total_cases  / population)*100  as 'mean' from dbo.[covide_ vaccination] 
where location like 'Mexico'
order by date


--creat new table from another table 

select location,SUBSTRING(date,1,4) as 'year',SUBSTRING(date,6,2) as 'moth',SUBSTRING(date,9,2) as 'day',total_tests,total_vaccinations,population 
into Ireland_covid  
from dbo.Covid_deaths 
where location  = 'Ireland'

---- I noticed that the population column was a nvchard and not in Int. to fix it ... 

alter table [dbo].[Ireland_covid] --Alter our new table
alter column total_vaccinations int;--- change nvchar to int 

--what is the percentage of the population already vaccinated until October 2021

select  concat(max(population)/MAX(total_vaccinations)*100,'%')  as 'percentage' 
from Ireland_covid

--number of deaths for continent
select continent, max(cast(Total_deaths as int)) as TotalDeathCount from Covid_deaths
where continent is not null
group by continent
order by TotalDeathCount desc


--total cases for continent

select continent,sum(new_cases)as TotalCasesCount from Covid_deaths
where continent is not null
group by continent
order by TotalCasesCount desc



--Looking at total  population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int,vac.new_vaccinations)) over (partition by dea.Location order by dea.location, 
convert(datetime,dea.date)) as rollingPeople
from dbo.Covid_deaths as dea 
join dbo.[covide_ vaccination] as vac
on dea.location = vac.location
and dea.date= vac.date
where dea.continent is not null
order by 2,3