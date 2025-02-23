CREATE TABLE dbo.`standards` (
  `AgeGradeVersionID` tinyint unsigned NOT NULL,
  `IsMale` bit(1) NOT NULL,
  `DistanceID` tinyint unsigned NOT NULL,
  `Standard` smallint unsigned NOT NULL,
  `IsCalculated` bit(1) NOT NULL,
  PRIMARY KEY (`AgeGradeVersionID`,`IsMale`,`DistanceID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3