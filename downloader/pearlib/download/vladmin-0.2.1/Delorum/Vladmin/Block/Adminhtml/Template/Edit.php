<?php

class Delorum_Vladmin_Block_Adminhtml_Template_Edit extends Mage_Adminhtml_Block_Widget_Form_Container
{
    public function __construct()
    {
        parent::__construct();
                 
        $this->_objectId = 'id';
        $this->_blockGroup = 'vladmin';
        $this->_controller = 'adminhtml_template';
        
        $this->_updateButton('save', 'label', Mage::helper('vladmin')->__('Save Template'));
        $this->_updateButton('delete', 'label', Mage::helper('vladmin')->__('Delete Template'));
		
        $this->_addButton('saveandcontinue', array(
            'label'     => Mage::helper('adminhtml')->__('Save And Continue Edit'),
            'onclick'   => 'saveAndContinueEdit()',
            'class'     => 'save',
        ), -100);

        $this->_formScripts[] = "
            function orderTagCollection(url, selectId, attributeId){
				value = $(selectId).value;
				openModal(url, '300','500', false, {parameters: {tag: value, attribute: attributeId, template: '" . Mage::registry('template_data')->getId() . "'}});
			}
			
			function orderInstanceCollection(url, textId, attributeId){
				value = $(textId).value;
				if(value == ''){
					alert('First assign instances to your collection');
					return;
				}
				openModal(url, '300','500', false, {parameters: {ids: value, attribute: attributeId, template: '" . Mage::registry('template_data')->getId() . "'}});
			}
			
			function saveSortOrder(attributeId){
				var ids = '';
				$$('ul#collection_items li').each(function(li){
					if(ids){
						ids += ',';
					}
					ids += li.id;
				});
				new Ajax.Request('" . Mage::getModel('adminhtml/url')->getUrl('vladmin/adminhtml_template_collection/saveCollection') . "', {
					 parameters : {collection: ids, template: '" . Mage::registry('template_data')->getId() . "', attribute: attributeId}
					,onSuccess : function(transport){
					 	Windows.closeAll();
					 }
				});
			}
			
            function saveAndContinueEdit(){
                editForm.submit($('edit_form').action+'back/edit/');
            }
        ";
    }

    public function getHeaderText()
    {
        if( Mage::registry('template_data') && Mage::registry('template_data')->getId() ) {
            return Mage::helper('vladmin')->__("Edit Template '%s'", $this->htmlEscape(Mage::registry('template_data')->getTitle()));
        } else {
            return Mage::helper('vladmin')->__('New Template');
        }
    }
}