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
GenderRankFinishes as 
(
    select
        gr.LinkID,
        gr.IsFemale,
        json_arrayagg(gr.GenderPlace) as Finishes
    from 
        GenderRank as gr
    group by 
        gr.LinkID,
        gr.IsFemale
),
GenderRankByCompleted as 
(
    select
        gr.IsFemale,
        gr.LinkID,
        avg(gr.GenderPlace) as AvgPlace,
        grf.Finishes,
        rank() over (partition by gr.IsFemale, max(gr.BestFinishesRowNumber) order by avg(gr.GenderPlace)) as AthleteRank,                 
        max(gr.BestFinishesRowNumber) as EligibleFinishes,
        (
            min(err.Races) +
            coalesce(min(ert.Races), 0) -
            min(rac.SeriesCompletedRaces)
        ) as RemainingRaces
    from 
        GenderRank as gr
    join 
        GenderRankFinishes as grf on 
        grf.LinkID = gr.LinkID and
        grf.IsFemale = gr.IsFemale 
    join 
        dbo.eligible_races as err on 
        err.`Year` = Year and 
        err.IsRoad = 1
    left join 
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
            ra.IsOutOfSeries = 0 and 
            ra.IsMissing = 0 and 
            ra.IsCancelled = 0
    ) as rac
    where 
        gr.BestFinishesRowNumber <= err.MaxRaces        
    group by        
        gr.IsFemale,
        gr.LinkID
    having 
        min(err.MaxRaces) <= (min(err.Races) + coalesce(min(ert.Races), 0) + max(gr.BestFinishesRowNumber) - min(rac.SeriesCompletedRaces))
)
select
    cai.UrlName,    
    gr.IsFemale,
    cai.Name,
    cai.City,
    cai.AgeGroup,    
    gr.Finishes
from 
    GenderRankByCompleted as gr
join 
    dbo.cache_athlete_info as cai on 
    cai.Year = Year and 
    cai.LinkID = gr.LinkID
where    
    gr.AthleteRank <= greatest(3, 6 - gr.RemainingRaces)
order by 
    gr.IsFemale,    
    gr.EligibleFinishes desc,
    gr.AvgPlace,
    cai.Name;

end