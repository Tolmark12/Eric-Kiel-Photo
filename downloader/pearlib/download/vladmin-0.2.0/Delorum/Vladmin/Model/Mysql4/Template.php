<?php

class Delorum_Vladmin_Model_Mysql4_Template extends Mage_Eav_Model_Entity_Abstract
{
	public function __construct()
    {    
        $resource = Mage::getSingleton('core/resource');
        $this->setType('vladmin_template')
        	->setConnection(
        		$resource->getConnection('core_read'),
        		$resource->getConnection('core_write')
        	);
    }
}