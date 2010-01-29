<?php

class Delorum_Stock_Model_Photo_Tag extends Mage_Core_Model_Abstract
{
    public function _construct()
    {
        parent::_construct();
        $this->_init('stock/photo_tag');
    }
}