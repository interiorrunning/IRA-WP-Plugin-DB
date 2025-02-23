CREATE PROCEDURE dbo.`p_get_awards`(
	IN Year smallint
)
begin
select
	lin.urlname,
    nam.Name,
    cit.Name as City,
    awa.Name as Award,
    awa.Subtitle
from
	dbo.winners as win
join
	dbo.awards as awa on
    awa.AwardID = win.AwardID
join
	dbo.links as lin on
    lin.LinkID = win.LinkID
join
	dbo.names as nam on
    nam.NameID = win.NameID
join
	dbo.cities as cit on
    cit.CityID = win.CityID
where
	win.Year = Year and
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
order by
	awa.SortOrder,
    nam.Name;

    
end