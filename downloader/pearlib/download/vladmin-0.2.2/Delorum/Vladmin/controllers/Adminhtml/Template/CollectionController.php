<?php

class Delorum_Vladmin_Adminhtml_Template_CollectionController extends Mage_Adminhtml_Controller_Action
{
	public function tagSortOrderAction()
	{
		$attribute = $this->_getAttributeByCode($this->getRequest()->getParam('attribute'));
		$collection = Mage::getModel('vladmin/template')->getCollection()
//    		->addFieldToFilter('entity_id', array('neq'=>$this->getId()))
    		->addAttributeToFilter('tags', array('like'=>"%{$this->getRequest()->getParam('tag')}%"))
    		->addAttributeToSelect('name');
	   	$collection->getSelect()
	    	->joinLeft(
	    		 array('o'=>'vladmin_template_entity_collection_order')
	    		,"e.entity_id = o.template_id AND o.parent_id = {$this->getRequest()->getParam('template')} AND o.attribute_id = {$attribute->getId()}"
	    		,array()
	    	)->order('o.position');
	    Mage::register('template_collection', $collection);
		$this->loadLayout();
		$this->getLayout()->getBlock('root')->setTemplate('modal.phtml')->setIsAjax(true);
		$this->_addContent(
			$this->getLayout()->createBlock('vladmin/adminhtml_template_collection_sort')
				->setAttributeId($this->getRequest()->getParam('attribute'))
		);
		$this->renderLayout();
	}
	
	public function instanceSortOrderAction()
	{
		$attribute = $this->_getAttributeByCode($this->getRequest()->getParam('attribute'));
		$templateIds = explode(",", $this->getRequest()->getParam('ids'));
		$collection = Mage::getModel('vladmin/template')->getCollection()
    		->addFieldToFilter('entity_id', array('in'=>$templateIds))
//    		->addAttributeToFilter('tags', array('like'=>"%{$this->getRequest()->getParam('tag')}%"))
    		->addAttributeToSelect('name');
	   	$collection->getSelect()
	    	->joinLeft(
	    		 array('o'=>'vladmin_template_entity_collection_order')
	    		,"e.entity_id = o.template_id AND o.parent_id = {$this->getRequest()->getParam('template')} AND o.attribute_id = {$attribute->getId()}"
	    		,array()
	    	)->order('o.position');
	    Mage::register('template_collection', $collection);
		$this->loadLayout();
		$this->getLayout()->getBlock('root')->setTemplate('modal.phtml')->setIsAjax(true);
		$this->_addContent(
			$this->getLayout()->createBlock('vladmin/adminhtml_template_collection_sort')
				->setAttributeId($this->getRequest()->getParam('attribute'))
		);
		$this->renderLayout();
	}
	
	public function saveCollectionAction()
	{
		$collection 	= $this->getRequest()->getParam('collection');
		$templateId 	= $this->getRequest()->getParam('template');
		$attributeId	= $this->_getAttributeByCode($this->getRequest()->getParam('attribute'))->getId();
		
		$collection = explode(",", $collection);
		$position = 1;
		if(count($collection)){
			foreach($collection as $template){
				$order = '';
				$orderCollection = Mage::getModel('vladmin/template_collection_order')->getCollection()
					->addFieldToFilter('parent_id', $templateId)
					->addFieldToFilter('template_id', $template)
					->addFieldToFilter('attribute_id', $attributeId);
				if(count($orderCollection)){
					$order = $orderCollection->getFirstItem();
				}else{
					$order = Mage::getModel('vladmin/template_collection_order');
				}
				$order
					->setParentId($templateId)
					->setTemplateId($template)
					->setAttributeId($attributeId)
					->setPosition($position)
					->save();
				$position++;
			}
		}
		echo 'success';
	}
	
	protected function _getAttributeByCode($code)
	{
		return Mage::getModel('eav/entity_attribute')->getCollection()
			->addFieldToFilter('attribute_code', $code)
			->addFieldToFilter('entity_type_id', Mage::getModel('eav/entity_type')->load('vladmin_template', 'entity_type_code'))
			->getFirstItem();
	}
}