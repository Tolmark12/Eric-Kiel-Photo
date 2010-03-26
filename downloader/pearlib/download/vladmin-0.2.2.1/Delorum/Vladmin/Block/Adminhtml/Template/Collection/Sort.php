<?php

class Delorum_Vladmin_Block_Adminhtml_Template_Collection_Sort extends Mage_Core_Block_Template
{
	public function _construct()
	{
		$this->setTemplate('vladmin/template/collection/sort.phtml');
	}
	
	public function getCollection()
	{
		return Mage::registry('template_collection');
	}
}