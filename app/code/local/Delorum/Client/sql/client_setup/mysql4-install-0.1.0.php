<?php

$installer = $this;

$installer->startSetup();

$installer->run("

DROP TABLE IF EXISTS client_detail;
CREATE TABLE client_detail (
	 client_id		int(10) unsigned NOT NULL auto_increment PRIMARY KEY
	,name			varchar(255) NOT NULL DEFUALT ''
	,email			varchar(255) NOT NULL DEFAULT ''
	,message		mediumtext
	,company		varchar(255)
	,phone			varchar(255)
	,created_at		datetime
	,updated_at		datetime
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

");

$installer->endSetup(); 