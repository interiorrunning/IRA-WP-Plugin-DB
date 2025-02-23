CREATE PROCEDURE dbo.`p_get_age_category`(
	IN Year smallint
)
begin
select
	t.Year,
    t.IsRoad,
    t.AgeGroup,
    t.urlname as UrlName,
    min(t.Name) as Name,
    min(t.City) as City,
    sum(t.AdjPoints) as TotalPoints,    
    min(if(t.Number = 1, t.AdjPoints, null)) as AdjPoints01,
    min(if(t.Number = 2, t.AdjPoints, null)) as AdjPoints02,
    min(if(t.Number = 3, t.AdjPoints, null)) as AdjPoints03,
    min(if(t.Number = 4, t.AdjPoints, null)) as AdjPoints04,
    min(if(t.Number = 5, t.AdjPoints, null)) as AdjPoints05,
    min(if(t.Number = 6, t.AdjPoints, null)) as AdjPoints06,
    min(if(t.Number = 7, t.AdjPoints, null)) as AdjPoints07,
    min(if(t.Number = 8, t.AdjPoints, null)) as AdjPoints08,
    min(if(t.Number = 9, t.AdjPoints, null)) as AdjPoints09,
    min(if(t.Number = 10, t.AdjPoints, null)) as AdjPoints10,
    min(if(t.Number = 11, t.AdjPoints, null)) as AdjPoints11,
    min(if(t.Number = 12, t.AdjPoints, null)) as AdjPoints12,
    min(if(t.Number = 13, t.AdjPoints, null)) as AdjPoints13,
    min(if(t.Number = 1, t.Points, null)) as OriPoints01,
    min(if(t.Number = 2, t.Points, null)) as OriPoints02,
    min(if(t.Number = 3, t.Points, null)) as OriPoints03,
    min(if(t.Number = 4, t.Points, null)) as OriPoints04,
    min(if(t.Number = 5, t.Points, null)) as OriPoints05,
    min(if(t.Number = 6, t.Points, null)) as OriPoints06,
    min(if(t.Number = 7, t.Points, null)) as OriPoints07,
    min(if(t.Number = 8, t.Points, null)) as OriPoints08,
    min(if(t.Number = 9, t.Points, null)) as OriPoints09,
    min(if(t.Number = 10, t.Points, null)) as OriPoints10,
    min(if(t.Number = 11, t.Points, null)) as OriPoints11,
    min(if(t.Number = 12, t.Points, null)) as OriPoints12,
    min(if(t.Number = 13, t.Points, null)) as OriPoints13,
    min(if(t.Number = 1, t.IsRaceDirector, null)) as IsRaceDirector01,
    min(if(t.Number = 2, t.IsRaceDirector, null)) as IsRaceDirector02,
    min(if(t.Number = 3, t.IsRaceDirector, null)) as IsRaceDirector03,
    min(if(t.Number = 4, t.IsRaceDirector, null)) as IsRaceDirector04,
    min(if(t.Number = 5, t.IsRaceDirector, null)) as IsRaceDirector05,
    min(if(t.Number = 6, t.IsRaceDirector, null)) as IsRaceDirector06,
    min(if(t.Number = 7, t.IsRaceDirector, null)) as IsRaceDirector07,
    min(if(t.Number = 8, t.IsRaceDirector, null)) as IsRaceDirector08,
    min(if(t.Number = 9, t.IsRaceDirector, null)) as IsRaceDirector09,
    min(if(t.Number = 10, t.IsRaceDirector, null)) as IsRaceDirector10,
    min(if(t.Number = 11, t.IsRaceDirector, null)) as IsRaceDirector11,
    min(if(t.Number = 12, t.IsRaceDirector, null)) as IsRaceDirector12,
    min(if(t.Number = 13, t.IsRaceDirector, null)) as IsRaceDirector13
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
	ra.Year = Year and    
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
    null as Name,
    null as City,
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
	ra.Year = Year
) as t
join
	dbo.eligible_races as er on
    er.Year = t.Year and
    er.IsRoad = t.IsRoad
) as t
group by
	t.Year,
    t.IsRoad,
    t.AgeGroup,
    t.urlname
order by
	IsRoad,	
    AgeGroup,
    TotalPoints desc,
    urlname;

    
end