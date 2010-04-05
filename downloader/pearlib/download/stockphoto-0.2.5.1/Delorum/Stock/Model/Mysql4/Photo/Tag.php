<?php

class Delorum_Stock_Model_Mysql4_Photo_Tag extends Mage_Core_Model_Mysql4_Abstract
{
    public function _construct()
    {    
        // Note that the stock_id refers to the key field in your database table.
        $this->_init('stock/photo_tag', 'tag_id');
    }
}