<?php
class Delorum_Stock_Block_Adminhtml_Photo extends Mage_Adminhtml_Block_Widget_Grid_Container
{
  public function __construct()
  {
    $this->_controller = 'adminhtml_photo';
    $this->_blockGroup = 'stock';
    $this->_headerText = Mage::helper('stock')->__('Stock Photo Manager');
    $this->_addButtonLabel = Mage::helper('stock')->__('Add Photo');
    parent::__construct();
  }
}