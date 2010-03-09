<?php

$installer = $this;

$installer->startSetup();

$installer->run("

DROP TABLE IF EXISTS vladmin_template_entity_collection_order;
CREATE TABLE vladmin_template_entity_collection_order (
	 `order_id`		int(10)		unsigned NOT NULL auto_increment
	,`parent_id`	int(10)		unsigned NOT NULL
	,`template_id`	int(10) 	unsigned NOT NULL
	,`attribute_id`	smallint(5) unsigned NOT NULL
	,`position`		int(10) 	unsigned NOT NULL
	,PRIMARY KEY (`order_id`)
	,CONSTRAINT `FK_VLADMIN_TEMPLATE_ENTITY_COLLECTION_ORDER_PARENT` FOREIGN KEY (`parent_id`)
		REFERENCES vladmin_template_entity (entity_id)
		ON DELETE CASCADE ON UPDATE CASCADE
	,CONSTRAINT `FK_VLADMIN_TEMPLATE_ENTITY_COLLECTION_ORDER_TEMPLATE` FOREIGN KEY (`template_id`)
		REFERENCES vladmin_template_entity (entity_id)
		ON DELETE CASCADE ON UPDATE CASCADE
	,CONSTRAINT `FK_VLADMIN_TEMPLATE_ENTITY_COLLECTION_ORDER_ATTRIBUTE` FOREIGN KEY (`attribute_id`)
		REFERENCES eav_attribute (attribute_id)
		ON DELETE CASCADE ON UPDATE CASCADE
	,INDEX IDX_VLADMIN_TEMPLATE_ENTITY_COLLECTION_ORDER_PARENT (`parent_id`)
	,INDEX IDX_VLADMIN_TEMPLATE_ENTITY_COLLECTION_ORDER_TEMPLATE (`template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

");
	


$installer->endSetup(); 