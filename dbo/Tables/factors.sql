CREATE TABLE dbo.`factors` (
  `AgeGradeVersionID` tinyint unsigned NOT NULL,
  `IsMale` bit(1) NOT NULL,
  `Age` tinyint unsigned NOT NULL,
  `Factor` decimal(5,4) NOT NULL,
  `DistanceID` tinyint unsigned NOT NULL,
  `IsCalculated` bit(1) NOT NULL,
  PRIMARY KEY (`AgeGradeVersionID`,`IsMale`,`Age`,`DistanceID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3