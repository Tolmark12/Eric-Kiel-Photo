<?php

$installer = $this;

$installer->startSetup();

$installer->run("

DROP TABLE IF EXISTS stock_photo;
CREATE TABLE stock_photo (
	 photo_id		int(10) unsigned NOT NULL auto_increment PRIMARY KEY
	,name			varchar(255) NOT NULL default ''
	,rank			int(10) unsigned NOT NULL default '0'
	,image			varchar(255) NOT NULL default ''
	,small_width	int(10) unsigned NOT NULL default '0'
	,mid_width		int(10) unsigned NOT NULL default '0'
	,large_width	int(10) unsigned NOT NULL default '0'
	,created_at		datetime
	,updated_at		datetime
	,INDEX (image);
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS stock_photo_tag;
CREATE TABLE stock_photo_tag (
	 tag_id		int(10) unsigned NOT NULL auto_increment PRIMARY KEY
	,name			varchar(255) NOT NULL default ''
	,rank			int(10) unsigned NOT NULL default '0'
	,created_at		datetime
	,updated_at		datetime
	,INDEX (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS stock_photo_tag_link;
CREATE TABLE stock_photo_tag_link (
	 link_id		int(10) unsigned NOT NULL auto_increment PRIMARY KEY
	,photo_id		int(10) unsigned NOT NULL
	,tag_id			int(10) unsigned NOT NULL
	,created_at		datetime
	,updated_at		datetime
	,INDEX (photo_id)
	,INDEX (tag_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

");

$installer->endSetup(); 