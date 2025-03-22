drop procedure if exists 
	dbo.p_get_runner_of_year_info;

create procedure dbo.p_get_runner_of_year_info (
	in Year smallint
)
begin
    select
        er.MaxRaces,        
        (select json_arrayagg(t.Year) from (select distinct ra.Year from dbo.eligible_races as ra order by ra.Year desc) as t) as Years,    
        Year
    from 
        dbo.eligible_races as er 
    where 
        er.Year = Year and 
        er.IsRoad = 1;
    
end