<?php

class Delorum_Stock_Block_Adminhtml_Photo_Edit_Tab_Form extends Mage_Adminhtml_Block_Widget_Form
{
	protected function _prepareForm()
	{
		$form = new Varien_Data_Form();
		$this->setForm($form);
		$fieldset = $form->addFieldset('stock_form', array());
		
		$fieldset->addField('image', 'file', array(
		  'label'     => Mage::helper('stock')->__('File'),
				'class'     => 'required-entry',
		 // 'required'  => true,
		  'name'      => 'image',
		));
		
		$fieldset->addField('rank', 'text', array(
		  'label'     => Mage::helper('stock')->__('Rank'),
		  'name'      => 'rank',
		));
		
		
		echo "<img src='' />";
		
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