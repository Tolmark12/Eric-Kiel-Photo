<?php
class Delorum_Vladmin_Block_Adminhtml_Template extends Mage_Adminhtml_Block_Widget_Grid_Container
{
  public function __construct()
  {
    $this->_controller = 'adminhtml_template';
    $this->_blockGroup = 'vladmin';
    $this->_headerText = Mage::helper('vladmin')->__('Template Manager');
    $this->_addButtonLabel = Mage::helper('vladmin')->__('Add Template');
    parent::__construct();
  }
}