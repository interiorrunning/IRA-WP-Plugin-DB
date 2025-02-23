CREATE TABLE dbo.`names` (
  `NameID` smallint NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `First` varchar(50) GENERATED ALWAYS AS ((case when (`Name` like _latin1'% %') then left(`Name`,(locate(_latin1' ',`Name`) - 1)) else `Name` end)) VIRTUAL,
  `Last` varchar(50) GENERATED ALWAYS AS ((case when (`Name` like _latin1'% %') then reverse(left(reverse(`Name`),(locate(_latin1' ',reverse(`Name`)) - 1))) end)) VIRTUAL,
  `urlname` varchar(50) GENERATED ALWAYS AS (ltrim(rtrim(replace(replace(replace(replace(replace(replace(replace(replace(lower(`Name`),_latin1'-',_utf8mb4' '),_latin1'\'',_utf8mb4''),_latin1')',_utf8mb4' '),_latin1'(',_utf8mb4' '),_latin1'.',_utf8mb4''),_latin1'  ',_utf8mb4' '),_latin1'  ',_utf8mb4' '),_latin1' ',_utf8mb4'_')))) VIRTUAL,
  PRIMARY KEY (`NameID`),
  UNIQUE KEY `uni_names_name` (`Name`),
  FULLTEXT KEY `ftx_names_name` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=20213 DEFAULT CHARSET=latin1