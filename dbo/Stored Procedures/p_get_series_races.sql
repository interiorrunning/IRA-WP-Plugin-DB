CREATE PROCEDURE dbo.`p_get_series_races`(	
    IN UrlName varchar(50) 
)
begin
select
	ra.Year,
    ra.UrlName,
    ra.Name as Race,
    ra.Distance,
    ra.IsAwardEligible,
    fe.urlname as Furlname,
    fe.Name as FName,
    fe.Time as FTime,
    ma.urlname as Murlname,
    ma.Name as MName,
    ma.Time as MTime,
    t.Finishers
from
	dbo.series as se
join
	dbo.races as ra on
    ra.SeriesID = se.SeriesID
left join lateral
(
	select
		li.urlname,
        na.Name,
        re.Time
    from
		dbo.results as re
	join
		dbo.divisions as di on
        di.DivisionID = re.DivisionID  
	join
		dbo.links as li on
        li.LinkID = re.LinkID
	join
		dbo.names as na on
        na.NameID = re.NameID
	where
		re.RaceID = ra.RaceID and
        di.IsWheeler = 0 and
        di.IsFemale = 1
	order by
		re.Time
	limit 1
) as fe on 1=1
left join lateral
(
	select
		li.urlname,
        na.Name,
        re.Time
    from
		dbo.results as re
	join
		dbo.divisions as di on
        di.DivisionID = re.DivisionID  
	join
		dbo.links as li on
        li.LinkID = re.LinkID
	join
		dbo.names as na on
        na.NameID = re.NameID
	where
		re.RaceID = ra.RaceID and
        di.IsWheeler = 0 and
        di.IsMale = 1
	order by
		re.Time
	limit 1
) as ma on 1=1
inner join lateral
(
	select
		count(*) as Finishers
    from
		dbo.results as re
	where
		re.RaceID = ra.RaceID
) as t
where
	se.UrlName = UrlName and
    ra.IsCancelled = 0 and
    ra.IsMissing = 0
order by
	ra.Year desc;

end