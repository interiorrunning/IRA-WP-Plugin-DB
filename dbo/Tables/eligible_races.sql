CREATE TABLE dbo.`eligible_races` (
  `Year` smallint NOT NULL,
  `IsRoad` bit(1) NOT NULL,
  `Races` tinyint NOT NULL,
  `MaxRaces` tinyint NOT NULL,
  `MinRaces` tinyint NOT NULL,
  PRIMARY KEY (`Year`,`IsRoad`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1