<?php

class Delorum_Client_Model_Resource_Client extends Mage_Core_Model_Mysql4_Abstract
{
	public function _construct()
    {   
    	$this->_init('client/client', 'client_id');
    }	
}