CREATE TABLE dbo.`series_races` (
  `SeriesID` tinyint NOT NULL,
  `RaceID` smallint NOT NULL,
  `IsAwardEligible` bit(1) NOT NULL DEFAULT (0),
  PRIMARY KEY (`RaceID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1