CREATE PROCEDURE dbo.`p_get_race_info`(
	IN Year smallint, 
    IN UrlName varchar(50) 
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
	ra2.Name as Name2,
    ra2.UrlName as UrlName2,
    d2.Distance as Distance2,
    d2.IsMiles as IsMiles2,
    se.Name as Series,
    se.UrlName as SeriesUrlName,
    case when exists (select 1 from dbo.results as re where re.RaceID = ra.RaceID and re.StartDelay is not null) then 1 else 0 end as StartDelay
from
	dbo.races as ra
join
	dbo.distances as d on
    d.DistanceID = ra.DistanceID
join
	dbo.cities as ci on
    ci.CityID = ra.CityID
left join
	dbo.races as ra2 on
    ra2.Year = ra.Year and
    ra2.Number = ra.Number and
    ra2.IsRoad = ra.IsRoad and
    ra2.IsCrossCountry = ra.IsCrossCountry and
    ra2.RaceId <> ra.RaceId
left join
	dbo.distances as d2 on
	d2.DistanceID = ra2.DistanceID
left join
	dbo.series as se on
    se.SeriesID = ra.SeriesID
where
	ra.Year = Year and
    ra.UrlName = UrlName;
    
end