CREATE PROCEDURE dbo.`p_get_award_years`(
)
begin
select distinct
	win.Year
from
	dbo.winners as win
order by
	win.Year desc;

    
end