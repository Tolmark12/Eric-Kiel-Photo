<?php

class Delorum_Template_Block_Adminhtml_Template_Edit_Tab_Form extends Mage_Adminhtml_Block_Widget_Form
{
  protected function _prepareForm()
  {
      $form = new Varien_Data_Form();
      $this->setForm($form);
      $fieldset = $form->addFieldset('template_form', array('legend'=>Mage::helper('template')->__('Item information')));
     
      $fieldset->addField('name', 'text', array(
          'label'     => Mage::helper('template')->__('Name'),
          'class'     => 'required-entry',
          'required'  => true,
          'name'      => 'name',
      ));

      $fieldset->addField('is_active', 'select', array(
          'label'     => Mage::helper('template')->__('Status'),
          'name'      => 'is_active',
          'values'    => array(
              array(
                  'value'     => 1,
                  'label'     => Mage::helper('template')->__('Enabled'),
              ),

              array(
                  'value'     => 0,
                  'label'     => Mage::helper('template')->__('Disabled'),
              ),
          ),
      ));
     
      $fieldset->addField('content', 'editor', array(
          'name'      => 'content',
          'label'     => Mage::helper('template')->__('Content'),
          'title'     => Mage::helper('template')->__('Content'),
          'style'     => 'width:700px; height:500px;',
          'wysiwyg'   => false,
          'required'  => true,
      ));
     
      if ( Mage::getSingleton('adminhtml/session')->getTemplateData() )
      {
          $form->setValues(Mage::getSingleton('adminhtml/session')->getTemplateData());
          Mage::getSingleton('adminhtml/session')->setTemplateData(null);
      } elseif ( Mage::registry('template_data') ) {
          $form->setValues(Mage::registry('template_data')->getData());
      }
      return parent::_prepareForm();
  }
}