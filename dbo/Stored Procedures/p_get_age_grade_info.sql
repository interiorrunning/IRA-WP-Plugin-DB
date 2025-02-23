CREATE PROCEDURE dbo.`p_get_age_grade_info`(
	IN Year smallint
)
begin

call dbo.p_get_age_category_info(Year);

end