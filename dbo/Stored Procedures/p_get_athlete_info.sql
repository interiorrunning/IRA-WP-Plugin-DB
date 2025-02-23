CREATE PROCEDURE dbo.`p_get_athlete_info`(	
    IN UrlName varchar(50) 
)
begin
select
	li.urlname,
    na.Name,
    na.City
from
	dbo.links as li
join lateral
(
	select
		na.Name,
        ci.Name as City
    from
		dbo.results as re
	join
		dbo.names as na on
        na.NameID = re.NameID
	join
		dbo.cities as ci on
        ci.CityID = re.CityID
	join
		dbo.races as ra on
        ra.RaceID = re.RaceID
	where
		re.LinkID = li.LinkID
	order by
		ra.Date desc
	limit 1
) as na
where
	li.urlname = UrlName;

end