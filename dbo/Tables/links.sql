CREATE TABLE dbo.`links` (
  `LinkID` int NOT NULL AUTO_INCREMENT,
  `urlname` varchar(50) NOT NULL,
  `Birthdate` date DEFAULT NULL,
  PRIMARY KEY (`LinkID`),
  UNIQUE KEY `uni_links_urlname` (`urlname`)
) ENGINE=InnoDB AUTO_INCREMENT=19157 DEFAULT CHARSET=latin1