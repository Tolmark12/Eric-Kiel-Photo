<?php

class Delorum_Stock_Block_Adminhtml_Photo_Edit extends Mage_Adminhtml_Block_Widget_Form_Container
{
    public function __construct()
    {
        parent::__construct();
                 
        $this->_objectId = 'id';
        $this->_blockGroup = 'stock';
        $this->_controller = 'adminhtml_photo';
        
        $this->_updateButton('save', 'label', Mage::helper('stock')->__('Save'));
        $this->_updateButton('delete', 'label', Mage::helper('stock')->__('Delete'));
		
        $this->_addButton('saveandcontinue', array(
            'label'     => Mage::helper('adminhtml')->__('Save And Continue Edit'),
            'onclick'   => 'saveAndContinueEdit()',
            'class'     => 'save',
        ), -100);

    }

    public function getHeaderText()
    {
        if( Mage::registry('photo_data') && Mage::registry('photo_data')->getId() ) {
            return Mage::helper('stock')->__("Edit Photo '%s'", $this->htmlEscape(Mage::registry('photo_data')->getName()));
        } else {
            return Mage::helper('stock')->__('Add Photo');
        }
    }
}