-- How Many Records are in the dataset?
SELECT count(id) AS count_of_records
FROM aliens;

-- Are there any duplicate emails?
with CTE as (
Select email, row_number() over (partition by email order by email) as rn
from aliens)
select * from CTE where rn>1;

-- how many countries are represented in our dataset?
Select count(distinct country)
from location;
/* Only Country was USA */

-- Are all states represented in the dataset?
Select state
from location
group by state;

Select count(distinct state)
from location;


-- Percentage of aggression between aliens
create view AggressionPercentages as
with cte as(
Select case
when aggressive = 1 Then 'Yes'
else 'No'
End as Aggressive
, Count(aggressive) as count_of_aliens
from details
group by aggressive)
Select  * ,(count_of_aliens / 50000)*100 as Aggression_Percentage
from cte;






-- What are the youngest and oldest alien ages in the US?
Select max(2023-birth_year) as 'Oldest Age'
from aliens;

Select min(2023-birth_year) as 'Youngest Age'
from aliens;


-- What is the count of aliens per state ?
-- and what is the average age? Order from highest to lowest population.
-- Include the percentage of hostile vs. friendly aliens per state. 

/* First I will change the boolean options into numbers*/
Select 
case
when aggressive = 'Yes' Then '1'
else '0'
End as New_Aggressive
from details
;

update details
set aggressive = case
when aggressive = 'Yes' Then '1'
else '0'
End; 

select aggressive 
from details;

Create View Alien_Population_by_state as
With cte as(
Select state, Count(aliens.id) as number_of_aliens,
round(cast(avg( '2023'- aliens.birth_year)as float)) as Average_Age,
sum(details.aggressive) as "agressive" ,
(count(details.aggressive) - sum(details.aggressive)) as "friendly"
from aliens 
join location
on aliens.id = loc_id
join details
on aliens.id = details.detail_id
group by state)
select * ,round((cte.friendly/cte.number_of_aliens)*100) as
 'Friendly_Percentage',
 round((cte.agressive/cte.number_of_aliens)*100) as 'Aggressive_percentage' 
from cte 
order by number_of_aliens desc
;

-- What is the alien population and gender per state
create view alien_population_by_gender as
Select Gender,state, count(id) as count_of_gender
from aliens
join location 
group by state,gender;

-- favorite Foods
Create view favorite_foods as
Select favorite_food,Count(favorite_food) Count_of_favFood
from details
group by favorite_food
order by Count_of_favFood desc;

-- feeding_frequency
Create view feeding_frequency as
Select feeding_frequency, count(feeding_frequency) as count_of_feedingf
from details
group by feeding_frequency
order by count_of_feedingf desc;

select * from
location
