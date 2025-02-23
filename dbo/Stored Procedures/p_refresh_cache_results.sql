CREATE PROCEDURE dbo.`p_refresh_cache_results`(
)
begin

declare exit handler for sqlexception rollback;

start transaction with consistent snapshot;

delete from
	dbo.cache_results;

insert into
	dbo.cache_results (
	ResultID,
    AgeGrade,
    AgeGradeTime,
    GenderPlace,
    AgeGroupPlace,
    AgeGradePlace,
    SeriesGenderPlace,
    SeriesAgeGroupPlace,
    SeriesAgeGradePlace
)
select
	re.ResultID,
    if(di.IsWheeler = 1, 0, cast((ws.Standard / time_to_sec(re.Time) / af.Factor) as decimal(4,4))) as AgeGrade,
    time_format(sec_to_time(ceiling(time_to_sec(re.Time) * af.Factor)), '%k:%i:%s'),
    if(di.IsWheeler = 1, 0, rank() over (partition by re.RaceID, di.IsMale, di.IsWheeler order by re.Time)) as GenderPlace,
    if(di.IsWheeler = 1, 0, rank() over (partition by re.RaceID, di.DivisionID, di.IsWheeler order by re.Time)) as AgeGroupPlace,
    if(di.IsWheeler = 1, 0, rank() over (partition by re.RaceID, di.IsMale, di.IsWheeler order by (ws.Standard / time_to_sec(re.Time) / af.Factor) desc)) as AgeGradePlace,
    if(di.IsWheeler = 1, 0, rank() over (partition by ra.IsAwardEligible, ra.SeriesID, di.IsMale, di.IsWheeler order by re.Time)) as SeriesGenderPlace,
    if(di.IsWheeler = 1, 0, rank() over (partition by ra.IsAwardEligible, ra.SeriesID, di.DivisionID, di.IsWheeler order by re.Time)) as SeriesAgeGroupPlace,
    if(di.IsWheeler = 1, 0, rank() over (partition by ra.IsAwardEligible, ra.SeriesID, di.IsMale, di.IsWheeler order by (ws.Standard / time_to_sec(re.Time) / af.Factor) desc)) as SeriesAgeGradePlace
from
	dbo.results as re
join
	dbo.links as li on
    li.LinkID = re.LinkID
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
	dbo.cities as ci_a on
    ci_a.CityID = re.CityID
join
	dbo.cities as ci_r on
    ci_r.CityID = ra.CityID
join
    dbo.v_year_agegradeversionid as ya on
    ya.Year = ra.Year
join
	dbo.factors as af on
    af.AgeGradeVersionID = ya.AgeGradeVersionID and
af.DistanceID = ra.DistanceID and
    af.IsMale = di.IsMale and
    af.Age = coalesce(timestampdiff(year, li.Birthdate, ra.Date), if(di.AgeStart >= 19, di.AgeStart, if(di.AgeEnd <= 19, di.AgeEnd, 19)))
join
	dbo.standards as ws on
    ws.AgeGradeVersionID = ya.AgeGradeVersionID and
ws.DistanceID = ra.DistanceID and
    ws.IsMale = di.IsMale
order by
	AgeGrade desc,
    ra.Year desc,
    ra.Date desc;

commit;

end