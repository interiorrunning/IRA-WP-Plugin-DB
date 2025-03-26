
drop procedure if exists 
	dbo.p_get_athlete_info;

create procedure
	dbo.p_get_athlete_info (	
    in UrlName varchar(50) 
)
begin
select
	li.urlname,
    cai.Name,
    cai.City
from
	dbo.links as li
join 
	dbo.cache_athlete_info_latest as cai on 
	cai.LinkID = li.LinkID 
where
	li.urlname = UrlName;

end