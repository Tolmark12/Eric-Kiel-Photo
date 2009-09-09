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
 * Product attributes tab
 *
 * @category   Mage
 * @package    Mage_Adminhtml
 * @author      Magento Core Team <core@magentocommerce.com>
 */
class Delorum_Vladmin_Block_Adminhtml_Template_Edit_Tab_Attributes extends Mage_Adminhtml_Block_Widget_Form
{
    protected function _prepareForm()
    {
        if ($group = $this->getGroup()) {
            $form = new Varien_Data_Form();
            /**
             * Initialize product object as form property
             * for using it in elements generation
             */
            $form->setDataObject(Mage::registry('template_data'));

            $fieldset = $form->addFieldset('group_fields'.$group->getId(),
                array('legend'=>Mage::helper('vladmin')->__($group->getAttributeGroupName()))
            );

            $attributes = $this->getGroupAttributes();

            $this->_setFieldset($attributes, $fieldset, array('gallery'));

//            /**
//             * Add new attribute button if not image tab
//             */
//            if (!$form->getElement('media_gallery')
//                 && Mage::getSingleton('admin/session')->isAllowed('catalog/attributes/attributes')) {
//                $headerBar = $this->getLayout()->createBlock(
//                    'adminhtml/catalog_product_edit_tab_attributes_create'
//                );
//
//                $headerBar->getConfig()
//                    ->setTabId('group_' . $group->getId())
//                    ->setGroupId($group->getId())
//                    ->setStoreId($form->getDataObject()->getStoreId())
//                    ->setAttributeSetId($form->getDataObject()->getAttributeSetId())
//                    ->setTypeId($form->getDataObject()->getTypeId())
//                    ->setProductId($form->getDataObject()->getId());
//
//                $fieldset->setHeaderBar(
//                    $headerBar->toHtml()
//                );
//            }

            $values = Mage::registry('template_data')->getData();
            /**
             * Set attribute default values for new product
             */
            if (!Mage::registry('template_data')->getId()) {
                foreach ($attributes as $attribute) {
                    if (!isset($values[$attribute->getAttributeCode()])) {
                        $values[$attribute->getAttributeCode()] = $attribute->getDefaultValue();
                    }
                }
            }

            if (Mage::registry('template_data')->hasLockedAttributes()) {
                foreach (Mage::registry('template_data')->getLockedAttributes() as $attribute) {
                    if ($element = $form->getElement($attribute)) {
                        $element->setReadonly(true, true);
                    }
                }
            }

//            Mage::dispatchEvent('adminhtml_catalog_product_edit_prepare_form', array('form'=>$form));

            $form->addValues($values);
//            $form->setFieldNameSuffix('template');
            $this->setForm($form);
        }
    }

    protected function _getAdditionalElementTypes()
    {
        $result = array(
//            'price'   => Mage::getConfig()->getBlockClassName('adminhtml/catalog_product_helper_form_price'),
            'image'   				=> Mage::getConfig()->getBlockClassName('vladmin/adminhtml_template_edit_form_image')
        	,'instance_collection'	=> Mage::getConfig()->getBlockClassName('vladmin/adminhtml_template_edit_form_collection_instance')
        	,'tag_collection'		=> Mage::getConfig()->getBlockClassName('vladmin/adminhtml_template_edit_form_collection_tag')
        	,'subcomponent'			=> Mage::getConfig()->getBlockClassName('vladmin/adminhtml_template_edit_form_subcomponent')
//            'boolean' => Mage::getConfig()->getBlockClassName('adminhtml/catalog_product_helper_form_boolean')
        );

        $response = new Varien_Object();
        $response->setTypes(array());
//        Mage::dispatchEvent('adminhtml_catalog_product_edit_element_types', array('response'=>$response));

        foreach ($response->getTypes() as $typeName=>$typeClass) {
            $result[$typeName] = $typeClass;
        }

        return $result;
    }
}
