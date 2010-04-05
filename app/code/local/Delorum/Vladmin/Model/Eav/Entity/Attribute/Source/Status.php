<?php

class Delorum_Vladmin_Model_Eav_Entity_Attribute_Source_Status extends Mage_Eav_Model_Entity_Attribute_Source_Abstract
{
	public function getAllOptions()
	{
		return array(
			 array('label'=>'Enabled', 'value'=>1)
			,array('label'=>'Disabled', 'value'=>0)
		);
	}
}
