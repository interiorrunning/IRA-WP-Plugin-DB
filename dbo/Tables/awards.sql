CREATE TABLE dbo.`awards` (
  `AwardID` smallint NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Subtitle` varchar(50) DEFAULT NULL,
  `Description` varchar(2000) DEFAULT NULL,
  `SortOrder` smallint DEFAULT NULL,
  PRIMARY KEY (`AwardID`),
  UNIQUE KEY `uni_awards_name` (`Name`,`Subtitle`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1