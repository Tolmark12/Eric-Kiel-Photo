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
	,INDEX IDX_VLADMIN_TEMPLATE_ENTITY_COLLECTION_ORDER_PARENT (`parent_id`)
	,INDEX IDX_VLADMIN_TEMPLATE_ENTITY_COLLECTION_ORDER_TEMPLATE (`template_id`)
	,INDEX IDX_VLADMIN_TEMPLATE_ENTITY_COLLECTION_ORDER_ATTRIBUTE (`attribute_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

");
	


$installer->endSetup(); 