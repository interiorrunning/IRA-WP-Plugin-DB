CREATE TABLE dbo.`cache_results` (
  `ResultID` int NOT NULL,
  `AgeGrade` decimal(4,4) NOT NULL,
  `AgeGradeTime` char(7) NOT NULL,
  `GenderPlace` smallint unsigned NOT NULL,
  `AgeGroupPlace` smallint unsigned NOT NULL,
  `AgeGradePlace` smallint unsigned NOT NULL,
  `SeriesGenderPlace` smallint unsigned DEFAULT NULL,
  `SeriesAgeGroupPlace` smallint unsigned DEFAULT NULL,
  `SeriesAgeGradePlace` smallint unsigned DEFAULT NULL,
  PRIMARY KEY (`ResultID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1