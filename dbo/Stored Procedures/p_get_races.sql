CREATE PROCEDURE dbo.`p_get_races`()
begin
select
	r.Year,
    r.Number,        
    date_format(r.Date, "%Y-%m-%d") as Date,	
    r.Name,
    c.Name as City,
	r.IsRoad,
    cast(round(r.Distance, 1) as char) + 0 as Distance,
    r.UrlName,
    fe.urlname as Furlname,
    fe.Name as FName,
    #fe.Time as FTime,
    ma.urlname as Murlname,
    ma.Name as MName,
    #ma.Time as MTime,
    t.Finishers
from
	dbo.races as r
join
	dbo.distances as d on
    d.DistanceID = r.DistanceID
join
	dbo.cities as c on
    c.CityID = r.CityID
inner join lateral
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
		re.RaceID = r.RaceID and
        di.IsFemale = 1
	order by
		re.Time
	limit 1
) as fe
inner join lateral
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
		re.RaceID = r.RaceID and
        di.IsMale = 1
	order by
		re.Time
	limit 1
) as ma
inner join lateral
(
	select
		count(*) as Finishers
    from
		dbo.results as re
	where
		re.RaceID = r.RaceID
) as t
where
	r.IsMissing = 0 and
    r.IsCancelled = 0 and
    r.IsOutOfSeries = 0 and
    exists
    (
		select 1
        from
			dbo.results as re
		where
			re.RaceID = r.RaceID
    )
order by
	r.Year desc,
    r.IsRoad,
    r.Date desc,
    r.Number desc;
end