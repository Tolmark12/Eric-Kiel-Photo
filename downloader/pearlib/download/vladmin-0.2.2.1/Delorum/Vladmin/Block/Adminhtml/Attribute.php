<?php
/**
 * Delorum Framework
 *
 * LICENSE
 *
 * This source file is subject to the new BSD license that is bundled
 * with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://framework.delorum.com/license/new-bsd
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@delorum.com so we can send you a copy immediately.
 *
 * @category   Delorum
 * @package    Delorum
 * @copyright  Copyright (c) 2009 Delorum Inc. (http://www.delorum.com)
 * @license    http://framework.delorum.com/license/new-bsd     New BSD License
 * @version    1.0
 */
 
class Delorum_Vladmin_Block_Adminhtml_Attribute extends Mage_Adminhtml_Block_Widget_Grid_Container
{
	public function __construct()
    {
        $this->_blockGroup = 'vladmin';
        $this->_controller = 'adminhtml_attribute';
        $this->_headerText = Mage::helper('vladmin')->__('Manage Attributes');
        $this->_addButtonLabel = Mage::helper('vladmin')->__('Add New Attribute');
        parent::__construct();
    }
}