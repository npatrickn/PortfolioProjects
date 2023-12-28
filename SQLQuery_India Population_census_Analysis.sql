Select *
From PortfolioProject.dbo.Data1

Select *
From PortfolioProject.dbo.Data2


Select Count(*) 
From PortfolioProject..Data1

-- Dataset for jharkhand and bihar

Select * 
From PortfolioProject..Data1
Where state in ('jharkand', 'bihar')

--Population of india

Select sum(population) as Population
From PortfolioProject..Data2

--Avg growth

Select state, avg(population)*100 as avg_growth
From PortfolioProject..Data2
group by state;


--avg sex ratio

Select state, round(avg(sex_ratio),0) as avg_sex_ratio
From PortfolioProject..Data1
group by state
Order by avg_sex_ratio desc;

--avg literacy rate

Select state, round(avg(literacy),0) avg_literacy_ratio
From PortfolioProject..Data1
group by state
having round(avg(literacy),0)>90
Order by avg_literacy_ratio desc;

-- Top 3 states showing highest growth ratio

Select top 3 state, avg(population)*100 as avg_growth
From PortfolioProject..Data2
group by state
Order by avg_growth desc;

-- Bottom 3 states showing lowest sex ratio

Select top 3 state, round(avg(sex_ratio),0) as avg_sex_ratio
From PortfolioProject..Data1
group by state
Order by avg_sex_ratio asc;

--Top and Bottom 3 illiterate states

Drop Table if exists #topstates
Create Table #topstates
 (state  nvarchar(255),
     topstates float

	 )

Insert into #topstates
Select state, round(avg(literacy),0) avg_literacy_ratio
From PortfolioProject..Data1
group by state
Order by avg_literacy_ratio desc;


Select  top 3 *
From #topstates
Order by #topstates.topstates desc



Drop Table if exists #bottomstates
Create Table #bottomstates
 (state  nvarchar(255),
     bottomstates float

	 )

Insert into #bottomstates
Select state, round(avg(literacy),0) avg_literacy_ratio
From PortfolioProject..Data1
group by state
Order by avg_literacy_ratio desc;


Select  top 3 *
From #bottomstates
Order by #bottomstates.bottomstates asc


--Union Joining the two tables

Select * From(
Select  top 3 *
From #topstates
Order by #topstates.topstates desc) a

Union

Select * From(
Select  top 3 *
From #bottomstates
Order by #bottomstates.bottomstates asc) b


--States starting with letter a

Select Distinct State
From PortfolioProject..Data1
Where lower(state) like 'a%'

--States starting with letter a or b

Select Distinct State
From PortfolioProject..Data1
Where lower(state) like 'a%' or lower(state) like 'b%'


--States starting with letter a and ends with letter d

Select Distinct State
From PortfolioProject..Data1
Where lower(state) like 'a%' or lower(state) like '%d'

--States starting with letter a and ends with letter m

Select Distinct State
From PortfolioProject..Data1
Where lower(state) like 'a%' and lower(state) like '%m'


--Joining both tables

Select a.district,a.state,a.sex_ratio,b.population from PortfolioProject..Data1 a 
inner join PortfolioProject..Data2 b on a.district=b.district

--Total males and females

Select d.state,sum(d.males) total_males,sum(d.females) total_females From
(Select c.district,c.state,round(c.population/(c.sex_ratio+1),0) males, round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females from
(Select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population from PortfolioProject..Data1 a 
inner join PortfolioProject..Data2 b on a.district=b.district) c) d
group by d.state;


--Total literacy rate

Select c.state,sum(literate_people) total_literate_population,sum(illiterate_people)  total_illiterate_population From
(Select d.district,d.state,round(d.literacy_ratio*d.population,0) literate_people,round((1-d.literacy_ratio)* d.population,0) illiterate_people From 
(Select a.district,a.state,a.literacy/100 literacy_ratio,b.population From PortfolioProject..Data1 a 
inner join PortfolioProject..Data2 b on a.district=b.district) d) c
group by c.state


--Population in previous census

Select sum(m.previous_census_population) previous_census_population,sum(m.current_census_population) current_census_population From
(Select e.state,sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) current_census_population From 
(Select d.district, d.state,round(d.population/(1+ d.growth),0) previous_census_population, d.population current_census_population
(Select a.district,a.state,a.growth growth,b.population from PortfolioProject..Data1 a 
inner join PortfolioProject..Data2 b on a.district=b.district) d)e
group by e.state)m



--Bottom 3 districts with lowest illiteracy rate



Select a. * From
(Select district,state,literacy,rank() over(
Partition by state 
Order by literacy desc) rnk From PortfolioProject..Data1) a 

Where a.rnk in (1,2,3)
Order by state




































































































































