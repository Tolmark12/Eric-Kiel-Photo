<?php

class Delorum_Stock_Block_Adminhtml_Photo_Edit_Tabs extends Mage_Adminhtml_Block_Widget_Tabs
{

  public function __construct()
  {
      parent::__construct();
      $this->setId('photo_tabs');
      $this->setDestElementId('edit_form');
//      $this->setTitle(Mage::helper('stock')->__('Photo Information'));
  }

  protected function _beforeToHtml()
  {
      $this->addTab('form_section', array(
          'label'     => Mage::helper('stock')->__('Photo Information'),
          'title'     => Mage::helper('stock')->__('Photo Information'),
          'content'   => $this->getLayout()->createBlock('stock/adminhtml_photo_edit_tab_photo')->toHtml(),
      ));
     
      return parent::_beforeToHtml();
  }
}