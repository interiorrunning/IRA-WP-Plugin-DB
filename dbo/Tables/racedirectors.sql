CREATE TABLE dbo.`racedirectors` (
  `RaceDirectorID` int NOT NULL AUTO_INCREMENT,
  `RaceID` smallint NOT NULL,
  `LinkID` int NOT NULL,
  `DivisionID` smallint NOT NULL,
  `IsRaceDirector` bit(1) DEFAULT NULL,
  PRIMARY KEY (`RaceDirectorID`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=latin1