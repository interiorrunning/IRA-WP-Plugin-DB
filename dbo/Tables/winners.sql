CREATE TABLE dbo.`winners` (
  `WinnerID` smallint NOT NULL AUTO_INCREMENT,
  `AwardID` smallint NOT NULL,
  `Year` smallint NOT NULL,
  `LinkID` int NOT NULL,
  `Notes` varchar(2000) DEFAULT NULL,
  `NameID` smallint NOT NULL,
  `CityID` smallint NOT NULL,
  PRIMARY KEY (`WinnerID`)
) ENGINE=InnoDB AUTO_INCREMENT=991 DEFAULT CHARSET=latin1