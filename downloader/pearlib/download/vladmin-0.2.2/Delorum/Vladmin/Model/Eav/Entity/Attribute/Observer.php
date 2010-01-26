<?php
/**
 * Delorum Framework
 *
 * LICENSE
 *
 * This source file is subject to the new BSD license that is bundled
 * with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://framework.delorum.com/license/new-bsd
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@delorum.com so we can send you a copy immediately.
 *
 * @category   Delorum
 * @package    Delorum
 * @copyright  Copyright (c) 2009 Delorum Inc. (http://www.delorum.com)
 * @license    http://framework.delorum.com/license/new-bsd     New BSD License
 * @version    1.0
 */
 
class Delorum_Vladmin_Model_Eav_Entity_Attribute_Observer
{
	public function setBackendModels($observer)
	{
		$attribute = $observer->getEvent()->getAttribute();
		switch($attribute->getFrontendInput()){
			case 'instance_collection' :
				// for now, later normalized
				$attribute->setBackendType('varchar');
//				$attribute->setBackendModel('vladmin/eav_entity_attribute_type_collection_instance');
				break;
			case 'tag_collection' :
				// for now, later normalized
				$attribute->setBackendType('int');
//				$attribute->setBackendModel('vladmin/eav_entity_attribute_type_collection_tag');
				break;
			case 'subcomponent' :
				$attribute->setBackendType('int');
//				$attribute->setBackendModel('vladmin/eav_entity_attribute_type_subcomponent');
				break;
			case 'select' :
			case 'multiselect' :
				$attribute->setSourceModel('eav/entity_attribute_source_table');
				break;
		}
	}
}