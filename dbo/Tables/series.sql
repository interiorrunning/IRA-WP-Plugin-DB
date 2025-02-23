CREATE TABLE dbo.`series` (
  `SeriesID` tinyint NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `UrlName` varchar(50) GENERATED ALWAYS AS (replace(replace(lower(`Name`),_latin1' ',_utf8mb4'_'),_latin1'-',_utf8mb4'_')) VIRTUAL NOT NULL,
  PRIMARY KEY (`SeriesID`),
  UNIQUE KEY `uni_series_urlname` (`UrlName`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=latin1