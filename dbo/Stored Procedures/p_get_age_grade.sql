CREATE PROCEDURE dbo.`p_get_age_grade`(
	IN Year smallint
)
begin
select
	t.Year as y,
    t.IsRoad as ir,
    t.Number as n,
	t.urlname as ur,
	t.Name as na,
	t.City as ci,
	t.AgeGroup as di,
	t.ag as ag,
	t.pnts as p1,
	if(if(t.Year >= 2025, t.rnk2, t.rnk) <= er.MaxRaces, t.pnts, null) as p2
from
(
    select
        t.Year,
        t.IsRoad,
        t.Number,
        t.LinkID,
        t.urlname,
        if(t.rn = 1, t.Name, null) as Name,
        if(t.rn = 1, t.City, null) as City,
        t.AgeGroup,
        t.ag,
        case
            when
                t.Year >= 2025 then
                t.ag * 100
            when
                t.pl = 1 then
                200
            when
                t.pl = 2 then
                195
            when
                t.pl = 3 then
                192
            when
                t.pl >= 194 then
                1
            else
                194 - t.pl
            end as pnts,
        row_number() over (partition by t.Year, t.IsRoad, t.LinkID order by t.pl, t.Number) as rnk,
        row_number() over (partition by t.Year, t.IsRoad, t.LinkID order by t.ag desc, t.Number) as rnk2
    from
    (
        select
            ra.Year,
            ra.IsRoad,
            ra.Number,
            li.LinkID,
            li.urlname,
            na.Name,
            ci.Name as City,
            di.AgeGroup,
            re2.AgeGrade as ag,
            rank() over (partition by ra.Year, ra.IsRoad, ra.Number, di.IsMale order by re2.AgeGrade desc) as pl,
            row_number() over (partition by ra.Year, ra.IsRoad, li.LinkID order by ra.Number desc) as rn
        from
            dbo.races as ra
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
            dbo.links as li on
            li.LinkID = re.LinkID
        join
            dbo.names as na on
            na.NameID = re.NameID
        join
            dbo.cities as ci on
            ci.CityID = ra.CityID
        where
            ra.Year = Year and
            ra.IsOutOfSeries = 0 and
            di.IsWheeler = 0
    ) as t
) as t
join
	dbo.eligible_races as er on
    er.Year = t.Year and
    er.IsRoad = t.IsRoad
order by
	t.Year,
    t.IsRoad,
    t.LinkID,
    t.Number;
end