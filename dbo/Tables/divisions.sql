CREATE TABLE dbo.`divisions` (
  `DivisionID` smallint NOT NULL AUTO_INCREMENT,
  `IsFemale` bit(1) NOT NULL,
  `IsMale` bit(1) NOT NULL,
  `IsWheeler` bit(1) NOT NULL,
  `AgeStart` smallint NOT NULL,
  `AgeEnd` smallint NOT NULL,
  `AgeGroup` varchar(10) GENERATED ALWAYS AS ((case when (`IsWheeler` = 1) then _utf8mb4'Wheeler' else concat((case when (`IsMale` = 1) then _utf8mb4'M' when (`IsFemale` = 1) then _utf8mb4'F' else _utf8mb4'O' end),if((`AgeStart` = `AgeEnd`),right(concat(_utf8mb4'0',`AgeStart`),2),concat(right(concat(_utf8mb4'0',`AgeStart`),2),_utf8mb4'-',(case when (`AgeEnd` > 99) then _utf8mb4'99+' else right(concat(_utf8mb4'0',`AgeEnd`),2) end)))) end)) VIRTUAL,
  `IsCurrentAgeGroup` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`DivisionID`),
  UNIQUE KEY `uni_divisions` (`AgeStart`,`AgeEnd`,`IsMale`,`IsFemale`,`IsWheeler`)
) ENGINE=InnoDB AUTO_INCREMENT=258 DEFAULT CHARSET=latin1