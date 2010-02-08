<?php

class Delorum_Vladmin_Model_Template_Collection_Order extends Mage_Core_Model_Abstract
{
    public function _construct()
    {
        parent::_construct();
        $this->_init('vladmin/template_collection_order');
    }
}