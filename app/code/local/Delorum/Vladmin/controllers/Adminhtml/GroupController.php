<?php
/**
 * Magento
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Open Software License (OSL 3.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://opensource.org/licenses/osl-3.0.php
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@magentocommerce.com so we can send you a copy immediately.
 *
 * DISCLAIMER
 *
 * Do not edit or add to this file if you wish to upgrade Magento to newer
 * versions in the future. If you wish to customize Magento for your
 * needs please refer to http://www.magentocommerce.com for more information.
 *
 * @category   Mage
 * @package    Mage_Adminhtml
 * @copyright  Copyright (c) 2008 Irubin Consulting Inc. DBA Varien (http://www.varien.com)
 * @license    http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
 */

/**
 * description
 *
 * @category   Mage
 * @package    Mage_Adminhtml
 * @author      Magento Core Team <core@magentocommerce.com>
 */

class Delorum_Vladmin_Adminhtml_GroupController extends Mage_Adminhtml_Controller_Action
{
    public function saveAction()
    {
        $model = Mage::getModel('eav/entity_attribute_group');

        $model->setAttributeGroupName($this->getRequest()->getParam('attribute_group_name'))
              ->setAttributeSetId($this->getRequest()->getParam('attribute_set_id'));

        if( $model->itemExists() ) {
            Mage::getSingleton('adminhtml/session')->addError(Mage::helper('vladmin')->__('Error while saving this group. Group with the same name already exists.'));
        } else {
            try {
                $model->save();
            } catch (Exception $e) {
                Mage::getSingleton('adminhtml/session')->addError(Mage::helper('vladmin')->__('Error while saving this group. Please try again later.'));
            }
        }
    }
    
//    protected function _isAllowed()
//    {
//        return Mage::getSingleton('admin/session')->isAllowed('catalog/products');
//    }
}
