CREATE TABLE dbo.`cities` (
  `CityID` smallint NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  PRIMARY KEY (`CityID`),
  UNIQUE KEY `uni_cities_name` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=820 DEFAULT CHARSET=latin1