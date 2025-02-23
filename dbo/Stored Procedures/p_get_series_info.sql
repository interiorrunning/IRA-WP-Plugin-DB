CREATE PROCEDURE dbo.`p_get_series_info`(	
    IN UrlName varchar(50) 
)
begin
select
	se.Name as Series
from
	dbo.series as se
where
	se.UrlName = UrlName;

end