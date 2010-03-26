<?php

class Delorum_Stock_Model_Mysql4_Photo_Tag_Collection extends Mage_Core_Model_Mysql4_Collection_Abstract
{
    public function _construct()
    {
        parent::_construct();
        $this->_init('stock/photo_tag');
    }
}