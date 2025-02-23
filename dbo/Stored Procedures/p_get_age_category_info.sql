CREATE PROCEDURE dbo.`p_get_age_category_info`(
	IN Year smallint
)
begin
with T as
(
	select
	er.IsRoad,
	er.Year,
	json_object
	(
		'Races',
		er.Races,
		'MaxRaces',
		er.MaxRaces,
		'MinRaces',
		er.MinRaces,
		'Numbers',
		(
			select
				json_arrayagg(json_object('Number', t.Number, 'UrlName', t.UrlName, 'Name', t.Name))
			from
			(
				select distinct
					ra.Number,
                    ra.UrlName,
                    ra.Name
				from
					dbo.races as ra
				where
					ra.Year = er.Year and
					ra.IsRoad = er.IsRoad and
					ra.IsOutOfSeries = 0
				order by ra.Number                    
			) as t
		)
	) as jobj
	from
		dbo.eligible_races as er
	where
		er.Year = Year 
)
select
	coalesce((select t.jobj from T as t where t.IsRoad = 1), '{}') as Road,
    coalesce((select t.jobj from T as t where t.IsRoad = 0), '{}') as `Cross`,
    (select json_arrayagg(t.Year) from (select distinct ra.Year from dbo.eligible_races as ra order by ra.Year desc) as t) as Years,    
    Year;
    
end