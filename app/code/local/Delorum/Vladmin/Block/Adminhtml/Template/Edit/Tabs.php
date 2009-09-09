<?php

class Delorum_Vladmin_Block_Adminhtml_Template_Edit_Tabs extends Mage_Adminhtml_Block_Widget_Tabs
{

	public function __construct()
	{
		parent::__construct();
		$this->setId('template_tabs');
		$this->setDestElementId('edit_form');
		$this->setTitle(Mage::helper('vladmin')->__('Item Information'));
	}

	protected function _prepareLayout()
	{
		$template = $this->getModel();
		
		if (!($setId = $template->getAttributeSetId())) {
	    	$setId = $this->getRequest()->getParam('set', null);
        }
        
        if ($setId) {
        	$groupCollection = Mage::getResourceModel('eav/entity_attribute_group_collection')
                ->setAttributeSetFilter($setId);
	        foreach ($groupCollection as $group) {
//                $attributes = $template->getAttributes($group->getId(), true);
				$attributes = Mage::getModel('eav/entity_attribute')->getCollection()->setAttributeGroupFilter($group->getId());
                // do not add groups without attributes

                foreach ($attributes as $key => $attribute) {
                    if( !$attribute->getIsVisible() ) {
                        unset($attributes[$key]);
                    }
                }

                if (count($attributes)==0) {
                    continue;
                }

                $this->addTab('group_'.$group->getId(), array(
                    'label'     => Mage::helper('vladmin')->__($group->getAttributeGroupName()),
                    'content'   => $this->getLayout()->createBlock('vladmin/adminhtml_template_edit_tab_attributes')
                        ->setGroup($group)
                        ->setGroupAttributes($attributes)
                        ->toHtml(),
                ));
            }
        }else{
        	$this->addTab('set', array(
                'label'     => Mage::helper('vladmin')->__('Settings'),
                'content'   => $this->getLayout()->createBlock('vladmin/adminhtml_template_edit_tab_settings')->toHtml(),
                'active'    => true
            ));
        }
//		$this->addTab('form_section', array(
//          'label'     => Mage::helper('template')->__('Item Information'),
//          'title'     => Mage::helper('template')->__('Item Information'),
//          'content'   => $this->getLayout()->createBlock('template/adminhtml_template_edit_tab_form')->toHtml(),
//		));
		 
		return parent::_prepareLayout();
	}
	
	public function getModel()
	{
		if (!($this->getData('template_model') instanceof Delorum_Vladmin_Model_Template)) {
            $this->setData('template_model', Mage::registry('template_data'));
        }
        return $this->getData('template_model');
	}
}