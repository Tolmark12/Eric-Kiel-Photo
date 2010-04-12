<?php
class Delorum_Client_Model_Resource_Client_Collection extends Mage_Core_Model_Mysql4_Collection_Abstract
{
    public function _construct()
    {
        parent::_construct();
        $this->_init('client/client');
    }
}