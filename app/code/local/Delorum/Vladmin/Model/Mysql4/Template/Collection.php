<?php

class Delorum_Vladmin_Model_Mysql4_Template_Collection extends Mage_Eav_Model_Entity_Collection_Abstract
{
	public function _construct()
    {
        $this->_init('vladmin/template');
    }
}