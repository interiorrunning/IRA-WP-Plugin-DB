CREATE PROCEDURE dbo.`p_get_series_awards`(	
    IN UrlName varchar(50) 	
)
begin

select
	r.rn,
	r.Record,    
	if(r.Record = 'Division', di.AgeGroup, case when di.IsFemale then 'Female' else 'Male' end) as AgeGroup,
    li.urlname as Athlete_UrlName,
    na.Name,
    ci.Name as City,
    ra.Year,
    re.Time,
    re2.AgeGrade    
from
	dbo.series as se 
join
	dbo.races as ra on
    ra.SeriesID = se.SeriesID
join
	dbo.results as re on
    re.RaceID = ra.RaceID
join
	dbo.cache_results as re2 on
    re2.ResultID = re.ResultID 
join
	dbo.names as na on
    na.NameID = re.NameID
join
	dbo.cities as ci on
    ci.CityID = re.CityID
join
	dbo.links as li on
    li.LinkID = re.LinkID
join
	dbo.divisions as di on
    di.DivisionID = re.DivisionID and
    di.IsWheeler = 0
join lateral
(
	values 
	row('Course', re2.SeriesGenderPlace, 5, null, null),
    row('Age Grade', re2.SeriesAgeGradePlace, null, 5, null),
    row('Division', re2.SeriesAgeGroupPlace, null, null, 5)
) as r(Record, rn, rn_cr, rn_ag, rn_di) on 
	r.rn_cr >= re2.SeriesGenderPlace or
    r.rn_ag >= re2.SeriesAgeGradePlace or
    r.rn_di >= re2.SeriesAgeGroupPlace and
    di.IsCurrentAgeGroup = 1    
where
	se.UrlName = UrlName and
    ra.IsAwardEligible = 1
order by
	case when r.Record = 'Course' then 0 when Record = 'Age Grade' then 1 else 2 end,    
    AgeGroup,
    r.rn;

end