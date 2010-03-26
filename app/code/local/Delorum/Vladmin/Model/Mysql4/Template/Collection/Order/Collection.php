<?php

class Delorum_Vladmin_Model_Mysql4_Template_Collection_Order_Collection extends Mage_Core_Model_Mysql4_Collection_Abstract
{
	public function _construct()
    {
        parent::_construct();
        $this->_init('vladmin/template_collection_order');
    }
}