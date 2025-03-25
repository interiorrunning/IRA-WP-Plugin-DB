drop procedure if exists 
    dbo.p_refresh_cache_athlete_info;

create procedure 
    dbo.p_refresh_cache_athlete_info (
)
begin

declare exit handler for sqlexception rollback;

start transaction with consistent snapshot;

insert into 
    dbo.cache_athlete_info (
    Year,
    LinkID,
    IsLatest,
    Name,
    City,
    AgeGroup,
    UrlName
)
select
    Year,
    LinkID,
    if(lrn = 1, 1, 0) as IsLatest,
    Name,
    City,
    AgeGroup,
    UrlName
from 
(
    select 
        ra.Year,
        re.LinkID,
        row_number() over (partition by re.LinkID order by ra.Date desc) as lrn,
        row_number() over (partition by ra.Year, re.LinkID order by ra.IsOutOfSeries, ra.Date desc) as rn,
        na.Name,
        ci.Name as City,
        di.AgeGroup,
        li.urlname
    from 
        dbo.races as ra
    join 
        dbo.results as re on 
        re.RaceID = ra.RaceID
    join 
        dbo.links as li on 
        li.LinkID = re.LinkID
    join 
        dbo.names as na on 
        na.NameID = re.NameID 
    join 
        dbo.cities as ci on 
        ci.CityID = re.CityID
    join 
        dbo.divisions as di on 
        di.DivisionID = re.DivisionID
) as t 
where 
    t.rn = 1;

commit;

end