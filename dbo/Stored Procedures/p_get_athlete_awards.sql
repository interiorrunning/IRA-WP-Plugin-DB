CREATE PROCEDURE dbo.`p_get_athlete_awards`(	
    IN UrlName varchar(50) 
)
begin
select
	awa.Name as Award,
    awa.Subtitle,
    awa.Description,
    json_arrayagg(win.Year) as Years
from
	dbo.links as lin
join
	dbo.winners as win on
    win.LinkID = lin.LinkID
join
	dbo.awards as awa on
    awa.AwardID = win.AwardID
where
	lin.urlname = UrlName and
    (
		awa.Name <> 'Iron Legs' or
        not exists
        (
			select 1
            from
				dbo.winners as win2
			join
				dbo.awards as awa2 on
                awa2.AwardID = win2.AwardID
			where
				awa2.Name = 'Legs of Steel' and
                win2.LinkID = lin.LinkID and
                win2.Year = win.Year
        )
    )
group by
	awa.Name,
    awa.Subtitle,
    awa.Description,
    awa.SortOrder
order by
	SortOrder,
    Subtitle;

end