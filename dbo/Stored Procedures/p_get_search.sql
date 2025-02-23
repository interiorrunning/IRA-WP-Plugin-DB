CREATE PROCEDURE dbo.`p_get_search`(	
    IN search varchar(4000),
    IN `offset` int,
    IN `limit` int
)
begin

select	
	li.urlname,
	na.Name,
    ci.Name as City,
    di.AgeGroup,
    t.Races    
    #,t.Score
from
(
	select
		t.LinkID,        
		max(t.Score) as Score,
		sum(t.Races) as Races,
		max(t.ResultID) as ResultID,
        max(t.RaceDate) as RaceDate
	from
	(
		select
			na.NameID,
			re.LinkID,
			na.Score,
			count(*) as Races,
			max(re.ResultID) as ResultID,
			max(ra.Date) as RaceDate
		from
		(
			select
				na.NameID,
				match(name) against(search in boolean mode) as Score
			from
				dbo.names as na
			where
				match(name) against(search IN BOOLEAN MODE)
			order by
				score desc			
		) as na
		join
			dbo.results as re on
			re.NameID = na.NameID
		join 
			dbo.races as ra on
            ra.RaceID = re.RaceID
		group by
			re.NameID,
			re.LinkID
	) as t
	group by
		t.LinkID
) as t
join
	dbo.results as re on
    re.ResultID = t.ResultID
join
	dbo.names as na on
    na.NameID = re.NameID
join
	dbo.cities as ci on
    ci.CityID = re.CityID
join
	dbo.divisions as di on
    di.DivisionID = re.DivisionID
join
	dbo.links as li on
    li.LinkID = t.LinkID
order by
	t.Score desc,
    t.Races desc,
    t.RaceDate desc,
    t.ResultID desc
limit `offset`, `limit`;
    
end