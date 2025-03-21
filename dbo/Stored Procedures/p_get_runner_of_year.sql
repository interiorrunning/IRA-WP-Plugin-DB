drop procedure if exists 
    dbo.p_get_runner_of_year;

create procedure dbo.p_get_runner_of_year(
	in Year smallint
)
begin

with GenderRank as 
(
    select
        re.LinkID,
        di.IsFemale,
        cr.GenderPlace,
        row_number() over (partition by re.LinkID order by cr.GenderPlace) as BestFinishesRowNumber
    from 
        dbo.races as ra
    join 
        dbo.results as re on 
        re.RaceID = ra.RaceID
    join 
        dbo.divisions as di on 
        di.DivisionID = re.DivisionID
    join 
        dbo.cache_results as cr on 
        cr.ResultID = re.ResultID
    where 
        ra.Year = Year and 
        ra.IsOutOfSeries = 0
),
GenderRankByCompleted as 
(
    select
        gr.IsFemale,
        gr.LinkID,
        avg(gr.GenderPlace) as AvgGenderPlace,
        json_arrayagg(gr.GenderPlace) as ListOfPlaces,
        rank() over (partition by gr.IsFemale, max(gr.BestFinishesRowNumber) order by avg(gr.GenderPlace)) as AthleteRank,                 
        max(gr.BestFinishesRowNumber) as AthleteEligibleFinishes
    from 
        GenderRank as gr
    join 
        dbo.eligible_races as err on 
        err.`Year` = Year and 
        err.IsRoad = 1
    join 
        dbo.eligible_races as ert on 
        ert.`Year` = Year and 
        ert.IsRoad = 0
    cross join 
    (
        select
            count(*) as SeriesCompletedRaces
        from
            dbo.races as ra
        where
            ra.Year = Year and
            ra.IsOutOfSeries = 0
    ) as rac
    where 
        gr.BestFinishesRowNumber <= err.MaxRaces        
    group by
        gr.IsFemale,
        gr.LinkID
    having 
        min(err.MaxRaces) <= (min(err.Races) + min(ert.Races) - min(rac.SeriesCompletedRaces) + max(gr.BestFinishesRowNumber))
)
select
    gr.LinkID,
    gr.IsFemale,
    cai.Name,
    cai.City,
    cai.AgeGroup,    
    gr.AvgGenderPlace,
    gr.ListOfPlaces,
    gr.AthleteEligibleFinishes
from 
    GenderRankByCompleted as gr
join 
    dbo.cache_athlete_info as cai on 
    cai.Year = Year and 
    cai.LinkID = gr.LinkID
where
    gr.AthleteRank <= 3
order by 
    gr.IsFemale,    
    gr.AvgGenderPlace,
    gr.AthleteEligibleFinishes desc;

end