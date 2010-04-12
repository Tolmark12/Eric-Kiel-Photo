<?php

class Delorum_Client_Model_Client extends Mage_Core_Model_Abstract
{
	public function _construct()
    {    
        parent::_construct();
    	$this->_init('client/client');
    }
    
}