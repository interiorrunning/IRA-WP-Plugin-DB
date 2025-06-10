drop procedure if exists
    dbo.p_get_race_info;

create procedure
    dbo.p_get_race_info (
	in Year smallint, 
    in UrlName varchar(50) 
)
begin
select
	ra.Number,
	ra.Name,
    ci.Name as City,
    date_format(ra.Date, "%b %D") as Date,
	d.Distance,    
    d.IsMiles,
    ra.IsRoad,
    ra.IsCrossCountry,
    ra.IsOutOfSeries,
    se.Name as Series,
    se.UrlName as SeriesUrlName,
    case when exists (select 1 from dbo.results as re where re.RaceID = ra.RaceID and re.StartDelay is not null) then 1 else 0 end as StartDelay,
    rd.Distances
from
	dbo.races as ra
join
	dbo.distances as d on
    d.DistanceID = ra.DistanceID
join
	dbo.cities as ci on
    ci.CityID = ra.CityID
join lateral 
(
    select 
        json_arrayagg(
            json_object
            (
                'Distance', d2.Distance,
                'IsMiles', cast(d2.IsMiles as unsigned),
                'UrlName', ra2.UrlName
            )
        ) as Distances
    from 
	    dbo.races as ra2    
    join
        dbo.distances as d2 on
        d2.DistanceID = ra2.DistanceID
    where 
        ra2.Year = ra.Year and
        ra2.Number = ra.Number and
        ra2.IsRoad = ra.IsRoad and
        ra2.IsCrossCountry = ra.IsCrossCountry 
) as rd
left join
	dbo.series as se on
    se.SeriesID = ra.SeriesID
where
	ra.Year = Year and
    ra.UrlName = UrlName;
    
end