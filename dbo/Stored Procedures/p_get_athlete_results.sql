CREATE PROCEDURE dbo.`p_get_athlete_results`(	
    IN UrlName varchar(50) 
)
begin

select
	ra.Date as rd,
    ra.Name as rn,
    ci_r.Name as rc,
    di.AgeGroup as di,        
	#time_format(re.Time, '%k:%i:%s') as t1,
    time_format(sec_to_time(time_to_sec(re.Time) -  coalesce(re.StartDelay, 0)), '%k:%i:%s') as t1,
    time_format(sec_to_time(time_to_sec(re.Time) / dis.DistanceKM), '%i:%s') as pa,
	re2.AgeGrade as ag,    
    ra.UrlName as un,
    re2.GenderPlace as gp,
    re2.AgeGroupPlace as cp,
    re2.AgeGradePlace as ap,
    case when ra.IsOutOfSeries = 1 then 0 else 1 end as `is`,
    case when re2.SeriesGenderPlace = 1 then 1 end as icr,
    case when re2.SeriesAgeGradePlace = 1 then 1 end as iag,
    case when re2.SeriesAgeGroupPlace = 1 then 1 end as idi
from
	dbo.links as li
join
	dbo.results as re on
    re.LinkID = li.LinkID
join
	dbo.cache_results as re2 on
    re2.ResultID = re.ResultID
join
	dbo.races as ra on
    ra.RaceID = re.RaceID
join
	dbo.distances as dis on
    dis.DistanceID = ra.DistanceID
join
	dbo.divisions as di on
    di.DivisionID = re.DivisionID
join
	dbo.names as na on
    na.NameID = re.NameID
join
	dbo.cities as ci_r on
    ci_r.CityID = ra.CityID
where
    li.urlname = UrlName
order by
	ra.Date desc;
    
end