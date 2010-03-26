<?php

class Delorum_Stock_Block_Adminhtml_Photo_Edit_Tab_Form extends Mage_Adminhtml_Block_Widget_Form
{
  protected function _prepareForm()
  {
      $form = new Varien_Data_Form();
      $this->setForm($form);
      $fieldset = $form->addFieldset('stock_form', array());
     
//      $fieldset->addField('name', 'text', array(
//          'label'     => Mage::helper('stock')->__('Name'),
//          'class'     => 'required-entry',
//          'required'  => true,
//          'name'      => 'name',
//      ));

      $fieldset->addField('image', 'file', array(
          'label'     => Mage::helper('stock')->__('File'),
      		'class'     => 'required-entry',
          'required'  => true,
          'name'      => 'image',
	  ));
	  
	  $fieldset->addField('rank', 'text', array(
          'label'     => Mage::helper('stock')->__('Rank'),
          'name'      => 'rank',
      ));
	  
		
//      $fieldset->addField('status', 'select', array(
//          'label'     => Mage::helper('stock')->__('Status'),
//          'name'      => 'status',
//          'values'    => array(
//              array(
//                  'value'     => 1,
//                  'label'     => Mage::helper('stock')->__('Enabled'),
//              ),
//
//              array(
//                  'value'     => 2,
//                  'label'     => Mage::helper('stock')->__('Disabled'),
//              ),
//          ),
//      ));
//     
//      $fieldset->addField('content', 'editor', array(
//          'name'      => 'content',
//          'label'     => Mage::helper('stock')->__('Content'),
//          'title'     => Mage::helper('stock')->__('Content'),
//          'style'     => 'width:700px; height:500px;',
//          'wysiwyg'   => false,
//          'required'  => true,
//      ));
     
      if ( Mage::getSingleton('adminhtml/session')->getPhotoData() )
      {
          $form->setValues(Mage::getSingleton('adminhtml/session')->getPhotoData());
          Mage::getSingleton('adminhtml/session')->setPhotoData(null);
      } elseif ( Mage::registry('photo_data') ) {
          $form->setValues(Mage::registry('photo_data')->getData());
      }
      return parent::_prepareForm();
  }
}