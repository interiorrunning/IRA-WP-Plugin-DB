CREATE PROCEDURE dbo.`p_get_race_results`(
	IN Year smallint, 
    IN UrlName varchar(50) 
)
begin
select
	na.Name as na,
    ci.Name as ci,
    di.AgeGroup as di,    
    re.Place as pl,
	time_format(re.Time, '%k:%i:%s') as t1,
    time_format(sec_to_time(time_to_sec(re.Time) / dis.DistanceKm), '%i:%s') as pa,
	re2.AgeGrade as ag,
    re2.AgeGradeTime as t2,
    li.UrlName as un,
	case when re2.SeriesGenderPlace = 1 then 1 end as crg,
    case when re2.SeriesAgeGradePlace = 1 then 1 end as cra,
    case when re2.SeriesAgeGroupPlace = 1 then 1 end as crc,
    time_format(sec_to_time(time_to_sec(re.Time) -  re.StartDelay), '%k:%i:%s') as ct
from
	dbo.races as ra
join
	dbo.distances as dis on
    dis.DistanceID = ra.DistanceID
join
	dbo.results as re on
    ra.RaceID = re.RaceID
join
	dbo.cache_results as re2 on
    re2.ResultID = re.ResultID
join
	dbo.divisions as di on
    di.DivisionID = re.DivisionID
join
	dbo.names as na on
    na.NameID = re.NameID
join
	dbo.cities as ci on
    ci.CityID = re.CityID
left join
	dbo.links as li on
    li.LinkID = re.LinkID
where
	ra.Year = Year and
    ra.urlname = UrlName
order by
	re.Place;
end