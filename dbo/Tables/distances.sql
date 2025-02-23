CREATE TABLE dbo.`distances` (
  `DistanceID` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `Distance` decimal(12,9) NOT NULL,
  `IsMiles` bit(1) NOT NULL,
  `DistanceKm` decimal(12,9) GENERATED ALWAYS AS ((`Distance` * (case when (`IsMiles` = 1) then 1.609344 else 1 end))) STORED,
  PRIMARY KEY (`DistanceID`),
  UNIQUE KEY `uni_Distances_Distance` (`Distance`,`IsMiles`)
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8mb3