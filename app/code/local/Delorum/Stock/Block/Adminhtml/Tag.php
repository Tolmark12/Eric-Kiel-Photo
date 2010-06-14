<?php
class Delorum_Stock_Block_Adminhtml_Tag extends Mage_Adminhtml_Block_Widget_Grid_Container
{
  public function __construct()
  {
    $this->_controller = 'adminhtml_tag';
    $this->_blockGroup = 'stock';
    $this->_headerText = Mage::helper('stock')->__('Tag Manager');
    parent::__construct();
  }
}