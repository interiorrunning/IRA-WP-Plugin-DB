
/*
insert into 
    dbo.winners (
    AwardID,
    `Year`,
    LinkID
)
*/
/*
select
    8,
    `Year`,
    LinkID
from 
    dbo.winners as w
where 
    w.`Year` = 2025 and 
    w.AwardID = 6
intersect
select
    8,
    `Year`,
    LinkID
from 
    dbo.winners as w
where 
    w.`Year` = 2025 and 
    w.AwardID = 9
*/


select
    9 as AwardID,
    2025 as `Year`,
    li.LinkID

from
   (
   select 
        t.Year,
        t.IsRoad,
        t.Number,
        t.AgeGroup,    
        t.urlname,
        t.Name,
        t.City,
        coalesce(t.Points, min(t.Points) over (partition by t.Year, t.IsRoad, t.AgeGroup, t.urlname)) as Points,    
        row_number() over (partition by t.Year, t.IsRoad, t.AgeGroup, t.urlname order by if(t.Points is not null, 0, 1), t.Points, t.Number) as rn,    
        if
        (
            er.MaxRaces >=
            row_number() over (partition by t.Year, t.IsRoad, t.AgeGroup, t.urlname order by if(t.Points is not null, 0, 1), t.Points desc, t.Number),
            coalesce
            (
                t.Points,
                min(t.Points) over (partition by t.Year, t.IsRoad, t.AgeGroup, t.urlname)
            ),
            null
        ) as AdjPoints,
        t.IsRaceDirector
    from
    (
        select
            t.Year,
            t.IsRoad,
            t.Number,    
            t.AgeGroup,
            t.urlname,
            t.Name,
            t.City,
            case
                when
                    t.Place = 1 then
                    30
                when
                    t.Place = 2 then
                    25
                when
                    t.Place = 3 then		
                    22
                when
                    t.Place > 23 then
                    1
                else
                    24 - t.Place
            end as Points,
            t.IsRaceDirector
        from
        (
            select
                ra.Year,
                ra.IsRoad,
                ra.Number,    
                di.AgeGroup,
                li.urlname,
                na.Name,
                ci.Name as City,
                rank() over (partition by ra.RaceID, di.AgeGroup order by re.Time) as Place,
                null as IsRaceDirector
            from
                dbo.races as ra
            join
                dbo.results as re on
                ra.RaceID = re.RaceID
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
                di.DivisionID = re.DivisionID
            where
                ra.Year = 2025 and    
                ra.IsOutOfSeries = 0 and
                di.IsWheeler = 0 and 
                (
                    di.IsFemale = 1 or 
                    di.IsMale = 1
                )
        ) as t
            
        union all
            
        select
            ra.Year,
            ra.IsRoad,
            ra.Number,    
            di.AgeGroup,
            li.urlname,
            cai.Name,
            cai.City,
            null as Place,
            rd.IsRaceDirector
        from
            dbo.racedirectors as rd
        join
            dbo.races as ra on
            ra.RaceID = rd.RaceID
        join
            dbo.divisions as di on
            di.DivisionID = rd.DivisionID
        join
            dbo.links as li on
            li.LinkID = rd.LinkID
        join 
            dbo.cache_athlete_info as cai on 
            cai.Year = ra.Year and 
            cai.LinkID = rd.LinkID
        where
            ra.Year = 2025 and 
            (
                di.IsFemale = 1 or 
                di.IsMale = 1
            )
    ) as t
    join
        dbo.eligible_races as er on
        er.Year = t.Year and
        er.IsRoad = t.IsRoad
) as t
join 
    dbo.links as li on 
    li.urlname = t.urlname
where
    t.IsRoad = 0 and
    t.rn = 5