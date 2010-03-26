<?php

$installer = $this;

$installer->startSetup();

$installer->run("

DROP TABLE IF EXISTS {$this->getTable('vladmin_template_entity')};
CREATE TABLE {$this->getTable('vladmin_template_entity')} (
  `entity_id` int(10) unsigned NOT NULL auto_increment,
  `entity_type_id` smallint(8) unsigned NOT NULL default '0',
  `attribute_set_id` smallint(5) unsigned NOT NULL default '0',
  `increment_id` varchar(50) NOT NULL default '',
  `parent_id` int(10) unsigned default NULL,
  `created_at` datetime NOT NULL default '0000-00-00 00:00:00',
  `updated_at` datetime NOT NULL default '0000-00-00 00:00:00',
  `is_active` tinyint(1) unsigned NOT NULL default '1',
  PRIMARY KEY  (`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='template Entities';

DROP TABLE IF EXISTS {$this->getTable('vladmin_template_entity_datetime')};
CREATE TABLE {$this->getTable('vladmin_template_entity_datetime')} (
  `value_id` int(11) NOT NULL auto_increment,
  `entity_type_id` smallint(8) unsigned NOT NULL default '0',
  `attribute_id` smallint(5) unsigned NOT NULL default '0',
  `entity_id` int(10) unsigned NOT NULL default '0',
  `value` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`value_id`),
  CONSTRAINT `FK_".strtoupper('vladmin_template')."_DATETIME_ENTITY_TYPE` FOREIGN KEY (`entity_type_id`)
  	REFERENCES eav_entity_type (entity_type_id)
  	ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_".strtoupper('vladmin_template')."_DATETIME_ATTRIBUTE` FOREIGN KEY (`attribute_id`)
  	REFERENCES eav_attribute (attribute_id)
  	ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_".strtoupper('vladmin_template')."_DATETIME_ENTITY` FOREIGN KEY (`entity_id`)
  	REFERENCES vladmin_template_entity (entity_id)
  	ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS {$this->getTable('vladmin_template_entity_decimal')};
CREATE TABLE {$this->getTable('vladmin_template_entity_decimal')} (
  `value_id` int(11) NOT NULL auto_increment,
  `entity_type_id` smallint(8) unsigned NOT NULL default '0',
  `attribute_id` smallint(5) unsigned NOT NULL default '0',
  `entity_id` int(10) unsigned NOT NULL default '0',
  `value` decimal(12,4) NOT NULL default '0.0000',
  PRIMARY KEY  (`value_id`),
  CONSTRAINT `FK_".strtoupper('vladmin_template')."_DECIMAL_ENTITY_TYPE` FOREIGN KEY (`entity_type_id`)
  	REFERENCES eav_entity_type (entity_type_id)
  	ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_".strtoupper('vladmin_template')."_DECIMAL_ATTRIBUTE` FOREIGN KEY (`attribute_id`)
  	REFERENCES eav_attribute (attribute_id)
  	ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_".strtoupper('vladmin_template')."_DECIMAL_ENTITY` FOREIGN KEY (`entity_id`)
  	REFERENCES vladmin_template_entity (entity_id)
  	ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS {$this->getTable('vladmin_template_entity_int')};
CREATE TABLE {$this->getTable('vladmin_template_entity_int')} (
  `value_id` int(11) NOT NULL auto_increment,
  `entity_type_id` smallint(8) unsigned NOT NULL default '0',
  `attribute_id` smallint(5) unsigned NOT NULL default '0',
  `entity_id` int(10) unsigned NOT NULL default '0',
  `value` int(11) NOT NULL default '0',
  PRIMARY KEY  (`value_id`),
  CONSTRAINT `FK_".strtoupper('vladmin_template')."_INT_ENTITY_TYPE` FOREIGN KEY (`entity_type_id`)
  	REFERENCES eav_entity_type (entity_type_id)
  	ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_".strtoupper('vladmin_template')."_INT_ATTRIBUTE` FOREIGN KEY (`attribute_id`)
  	REFERENCES eav_attribute (attribute_id)
  	ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_".strtoupper('vladmin_template')."_INT_ENTITY` FOREIGN KEY (`entity_id`)
  	REFERENCES vladmin_template_entity (entity_id)
  	ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS {$this->getTable('vladmin_template_entity_text')};
CREATE TABLE {$this->getTable('vladmin_template_entity_text')} (
  `value_id` int(11) NOT NULL auto_increment,
  `entity_type_id` smallint(8) unsigned NOT NULL default '0',
  `attribute_id` smallint(5) unsigned NOT NULL default '0',
  `entity_id` int(10) unsigned NOT NULL default '0',
  `value` text NOT NULL,
  PRIMARY KEY  (`value_id`),
  CONSTRAINT `FK_".strtoupper('vladmin_template')."_TEXT_ENTITY_TYPE` FOREIGN KEY (`entity_type_id`)
  	REFERENCES eav_entity_type (entity_type_id)
  	ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_".strtoupper('vladmin_template')."_TEXT_ATTRIBUTE` FOREIGN KEY (`attribute_id`)
  	REFERENCES eav_attribute (attribute_id)
  	ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_".strtoupper('vladmin_template')."_TEXT_ENTITY` FOREIGN KEY (`entity_id`)
  	REFERENCES vladmin_template_entity (entity_id)
  	ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS {$this->getTable('vladmin_template_entity_varchar')};
CREATE TABLE {$this->getTable('vladmin_template_entity_varchar')} (
  `value_id` int(11) NOT NULL auto_increment,
  `entity_type_id` smallint(8) unsigned NOT NULL default '0',
  `attribute_id` smallint(5) unsigned NOT NULL default '0',
  `entity_id` int(10) unsigned NOT NULL default '0',
  `value` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`value_id`),
  CONSTRAINT `FK_".strtoupper('vladmin_template')."_VARCHAR_ENTITY_TYPE` FOREIGN KEY (`entity_type_id`)
  	REFERENCES eav_entity_type (entity_type_id)
  	ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_".strtoupper('vladmin_template')."_VARCHAR_ATTRIBUTE` FOREIGN KEY (`attribute_id`)
  	REFERENCES eav_attribute (attribute_id)
  	ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_".strtoupper('vladmin_template')."_VARCHAR_ENTITY` FOREIGN KEY (`entity_id`)
  	REFERENCES vladmin_template_entity (entity_id)
  	ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- add a column to eav_attribute
ALTER TABLE eav_attribute
	ADD COLUMN is_feed tinyint(1) unsigned NOT NULL DEFAULT 0;

INSERT INTO `eav_entity_type` (
	`entity_type_id` ,
	`entity_type_code` ,
	`entity_model` ,
	`attribute_model` ,
	`entity_table` ,
	`value_table_prefix` ,
	`entity_id_field` ,
	`is_data_sharing` ,
	`data_sharing_key` ,
	`default_attribute_set_id` ,
	`increment_model` ,
	`increment_per_store` ,
	`increment_pad_length` ,
	`increment_pad_char`
)
VALUES (
	NULL , 
	'vladmin_template', 
	'vladmin/template', 
	'', 
	'vladmin/template', 
	'', 
	'', 
	'1', 
	'default', 
	'', 
	'', 
	'0', 
	'8', 
	'0'
);

UPDATE `eav_entity_type` 
	SET `default_attribute_set_id`=`entity_type_id`
	WHERE `entity_type_code`='vladmin_template';

	
-- create a Default Attribute set
INSERT INTO eav_attribute_set
VALUES (
	NULL
	,(SELECT entity_type_id FROM eav_entity_type WHERE entity_type_code = 'vladmin_template')
	,'Default'
	,1
);

-- create a General attribute group
INSERT INTO eav_attribute_group
VALUES (
	NULL
	,(SELECT attribute_set_id FROM eav_attribute_set 
	  WHERE	entity_type_id = (SELECT entity_type_id FROM eav_entity_type WHERE entity_type_code = 'vladmin_template')
	  AND 	attribute_set_name = 'Default'	
	 ) 
	,'General'
	,1
	,1
);

-- create a name attribute
INSERT INTO eav_attribute (
	attribute_id
	,entity_type_id
	,attribute_code
	,backend_model
	,backend_type
	,frontend_input
	,frontend_label
)
VALUES (
	NULL
	,(SELECT entity_type_id FROM eav_entity_type WHERE entity_type_code = 'vladmin_template')
	,'name'
	,''
	,'varchar'
	,'text'
	,'Name'
);

-- create a status attribute
INSERT INTO eav_attribute (
	attribute_id
	,entity_type_id
	,attribute_code
	,backend_model
	,backend_type
	,frontend_input
	,frontend_label
	,source_model
)
VALUES (
	NULL
	,(SELECT entity_type_id FROM eav_entity_type WHERE entity_type_code = 'vladmin_template')
	,'status'
	,''
	,'int'
	,'select'
	,'Status'
	,'eav/entity_attribute_source_table'
);

-- create a tags attribute
INSERT INTO eav_attribute (
	attribute_id
	,entity_type_id
	,attribute_code
	,backend_model
	,backend_type
	,frontend_input
	,frontend_label
	,source_model
)
VALUES (
	NULL
	,(SELECT entity_type_id FROM eav_entity_type WHERE entity_type_code = 'vladmin_template')
	,'tags'
	,'eav/entity_attribute_backend_array'
	,'varchar'
	,'multiselect'
	,'Tags'
	,'eav/entity_attribute_source_table'
);

-- assign name, status, and tags to Default attribute set, and General group
INSERT INTO eav_entity_attribute 
VALUES (
	NULL
	,(SELECT entity_type_id FROM eav_entity_type WHERE entity_type_code = 'vladmin_template')
	,(SELECT attribute_set_id FROM eav_attribute_set 
	  WHERE	entity_type_id = (SELECT entity_type_id FROM eav_entity_type WHERE entity_type_code = 'vladmin_template')
	  AND 	attribute_set_name = 'Default'	
	 )
	,(SELECT attribute_group_id FROM eav_attribute_group
	  WHERE attribute_set_id = (SELECT attribute_set_id FROM eav_attribute_set 
	  							WHERE	entity_type_id = (SELECT entity_type_id FROM eav_entity_type WHERE entity_type_code = 'vladmin_template')
	  							AND 	attribute_set_name = 'Default')
	  AND attribute_group_name = 'General'
	 )
	,(SELECT attribute_id FROM eav_attribute WHERE attribute_code = 'name' and entity_type_id = (SELECT entity_type_id FROM eav_entity_type WHERE entity_type_code = 'vladmin_template'))
	,1
);

INSERT INTO eav_entity_attribute 
VALUES (
	NULL
	,(SELECT entity_type_id FROM eav_entity_type WHERE entity_type_code = 'vladmin_template')
	,(SELECT attribute_set_id FROM eav_attribute_set 
	  WHERE	entity_type_id = (SELECT entity_type_id FROM eav_entity_type WHERE entity_type_code = 'vladmin_template')
	  AND 	attribute_set_name = 'Default'	
	 )
	,(SELECT attribute_group_id FROM eav_attribute_group
	  WHERE attribute_set_id = (SELECT attribute_set_id FROM eav_attribute_set 
	  							WHERE	entity_type_id = (SELECT entity_type_id FROM eav_entity_type WHERE entity_type_code = 'vladmin_template')
	  							AND 	attribute_set_name = 'Default')
	  AND attribute_group_name = 'General'
	 )
	,(SELECT attribute_id FROM eav_attribute WHERE attribute_code = 'status' and entity_type_id = (SELECT entity_type_id FROM eav_entity_type WHERE entity_type_code = 'vladmin_template'))
	,3
);

INSERT INTO eav_entity_attribute 
VALUES (
	NULL
	,(SELECT entity_type_id FROM eav_entity_type WHERE entity_type_code = 'vladmin_template')
	,(SELECT attribute_set_id FROM eav_attribute_set 
	  WHERE	entity_type_id = (SELECT entity_type_id FROM eav_entity_type WHERE entity_type_code = 'vladmin_template')
	  AND 	attribute_set_name = 'Default'	
	 )
	,(SELECT attribute_group_id FROM eav_attribute_group
	  WHERE attribute_set_id = (SELECT attribute_set_id FROM eav_attribute_set 
	  							WHERE	entity_type_id = (SELECT entity_type_id FROM eav_entity_type WHERE entity_type_code = 'vladmin_template')
	  							AND 	attribute_set_name = 'Default')
	  AND attribute_group_name = 'General'
	 )
	,(SELECT attribute_id FROM eav_attribute WHERE attribute_code = 'tags' and entity_type_id = (SELECT entity_type_id FROM eav_entity_type WHERE entity_type_code = 'vladmin_template'))
	,2
);

");
	


$installer->endSetup(); 