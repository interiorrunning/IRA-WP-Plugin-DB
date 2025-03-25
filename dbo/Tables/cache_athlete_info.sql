drop table if exists 
    dbo.cache_athlete_info;
    
create table 
    dbo.cache_athlete_info (
    Year smallint not null,
    LinkID int not null,
    IsLatest bit not null,
    Name varchar(50) not null,
    City varchar(50) not null,
    AgeGroup varchar(10) not null,
    UrlName varchar(50) not null,
    index idx_cache_athlete_info (
        LinkID,
        IsLatest
    ),
    primary key (        
        Year,
        LinkID
    )
);