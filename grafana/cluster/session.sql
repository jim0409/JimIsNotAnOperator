-- create grafana table first
CREATE DATABASE grafana DEFAULT CHARACTER SET utf8;

-- then add extra table `session` into grafana
CREATE TABLE `session` ( 
`key`CHAR(16) NOT NULL,
`data`BLOB,
`expiry`INT(11) UNSIGNED NOT NULL,
PRIMARY KEY (`key`) 
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


