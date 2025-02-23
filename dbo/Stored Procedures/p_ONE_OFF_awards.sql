CREATE PROCEDURE dbo.`p_ONE_OFF_awards`(
	IN Year smallint, 
    IN UrlName varchar(50) 
)
begin



insert into
	dbo.winners (
    AwardID,
    Year,
    LinkID,
    NameID,
    CityID
)
select
	6 as AwardID,
    2024 as Year,	
    LinkID,
    max(NameID) as NameID,
    max(CityID) as CityID
from
(
select 
	t.Year,
    t.IsRoad,
    t.Number,
    t.AgeGroup,    
    t.urlname,
    t.LinkID,
    t.Name,
    t.NameID,
    t.City,
    t.CityID,
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
    t.LinkID,
    t.Name,
    t.NameID,
    t.City,
    t.CityID,
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
    li.LinkID,
    na.Name,
    na.NameID,
    ci.Name as City,
    ci.CityID,
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
	ra.Year = 2024 and    
	ra.IsOutOfSeries = 0 and
	di.IsWheeler = 0
) as t
    
union all
    
select
	ra.Year,
    ra.IsRoad,
    ra.Number,    
    di.AgeGroup,
	li.urlname,
    li.LinkID,
    null as Name,
    null as NameID,
    null as City,
    null as CityID,
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
where
	ra.Year = 2024
) as t
join
	dbo.eligible_races as er on
    er.Year = t.Year and
    er.IsRoad = t.IsRoad
) as t
where t.IsRoad = 1 #and t.rn = 9
group by
	LinkID
having
	max(t.rn) = 9
order by LinkID;

end