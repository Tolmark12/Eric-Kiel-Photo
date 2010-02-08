<?php

class Delorum_Vladmin_Model_Mysql4_Template_Collection_Order extends Mage_Core_Model_Mysql4_Abstract
{
	public function _construct()
    {    
        // Note that the bug_id refers to the key field in your database table.
        $this->_init('vladmin/template_collection_order', 'order_id');
    }
}