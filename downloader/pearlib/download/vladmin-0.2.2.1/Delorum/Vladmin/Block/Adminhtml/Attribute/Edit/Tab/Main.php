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
 * Product attribute add/edit form main tab
 *
 * @category   Mage
 * @package    Mage_Adminhtml
 * @author      Magento Core Team <core@magentocommerce.com>
 */
class Delorum_Vladmin_Block_Adminhtml_Attribute_Edit_Tab_Main extends Mage_Adminhtml_Block_Widget_Form
{

    protected function _prepareForm()
    {
        $model = Mage::registry('entity_attribute');

        $form = new Varien_Data_Form(array(
            'id' => 'edit_form',
            'action' => $this->getData('action'),
            'method' => 'post'
        ));

        $disableAttributeFields = array(
            'sku'       => array(
                'is_global',
                'is_unique',
            ),
            'url_key'   => array(
                'is_unique',
            ),
            'status'    => array(
                'is_configurable'
            )
        );

        $fieldset = $form->addFieldset('base_fieldset',
            array('legend'=>Mage::helper('vladmin')->__('Attribute Properties'))
        );
        if ($model->getAttributeId()) {
            $fieldset->addField('attribute_id', 'hidden', array(
                'name' => 'attribute_id',
            ));
        }

        $this->_addElementTypes($fieldset);

        $yesno = array(
            array(
                'value' => 0,
                'label' => Mage::helper('vladmin')->__('No')
            ),
            array(
                'value' => 1,
                'label' => Mage::helper('vladmin')->__('Yes')
            ));

        $fieldset->addField('attribute_code', 'text', array(
            'name'  => 'attribute_code',
            'label' => Mage::helper('vladmin')->__('Attribute Code'),
            'title' => Mage::helper('vladmin')->__('Attribute Code'),
            'note'  => Mage::helper('vladmin')->__('For internal use. Must be unique with no spaces'),
            'class' => 'validate-code',
            'required' => true,
        ));

//        $scopes = array(
//            Mage_vladmin_Model_Resource_Eav_Attribute::SCOPE_STORE =>Mage::helper('catalog')->__('Store View'),
//            Mage_Catalog_Model_Resource_Eav_Attribute::SCOPE_WEBSITE =>Mage::helper('catalog')->__('Website'),
//            Mage_Catalog_Model_Resource_Eav_Attribute::SCOPE_GLOBAL =>Mage::helper('catalog')->__('Global'),
//        );
//
//        if ($model->getAttributeCode() == 'status' || $model->getAttributeCode() == 'tax_class_id') {
//            unset($scopes[Mage_Catalog_Model_Resource_Eav_Attribute::SCOPE_STORE]);
//        }

//        $fieldset->addField('is_global', 'select', array(
//            'name'  => 'is_global',
//            'label' => Mage::helper('catalog')->__('Scope'),
//            'title' => Mage::helper('catalog')->__('Scope'),
//            'note'  => Mage::helper('catalog')->__('Declare attribute value saving scope'),
//            'values'=> $scopes
//        ));

        $inputTypes = array(
            array(
                'value' => 'text',
                'label' => Mage::helper('vladmin')->__('Text Field')
            ),
            array(
                'value' => 'textarea',
                'label' => Mage::helper('vladmin')->__('Text Area')
            ),
            array(
            	'value' => 'image',
            	'label' => Mage::helper('vladmin')->__('Image')
            ),
            array(
                'value' => 'date',
                'label' => Mage::helper('vladmin')->__('Date')
            ),
//            array(
//                'value' => 'boolean',
//                'label' => Mage::helper('vladmin')->__('Yes/No')
//            ),
            array(
                'value' => 'multiselect',
                'label' => Mage::helper('vladmin')->__('Multiple Select')
            ),
            array(
                'value' => 'select',
                'label' => Mage::helper('vladmin')->__('Dropdown')
            ),
            array(
            	'value' => 'instance_collection',
            	'label'	=> Mage::helper('vladmin')->__('Instance Collection')
            ),
            array(
            	'value'	=> 'tag_collection',
            	'label'	=> Mage::helper('vladmin')->__('Smart Collection (tags)')
            ),
            array(
            	'value'	=> 'subcomponent',
            	'label'	=> Mage::helper('vladmin')->__('Subcomponent (Template Instance)')
            )
//            array(
//                'value' => 'price',
//                'label' => Mage::helper('vladmin')->__('Price')
//            ),
//            array(
//                'value' => 'gallery',
//                'label' => Mage::helper('vladmin')->__('Gallery')
//            ),
//            array(
//                'value' => 'media_image',
//                'label' => Mage::helper('vladmin')->__('Media Image')
//            ),
        );

        $response = new Varien_Object();
        $response->setTypes(array());
//        Mage::dispatchEvent('adminhtml_product_attribute_types', array('response'=>$response));

        $_disabledTypes = array();
        $_hiddenFields = array();
        foreach ($response->getTypes() as $type) {
            $inputTypes[] = $type;
            if (isset($type['hide_fields'])) {
                $_hiddenFields[$type['value']] = $type['hide_fields'];
            }
            if (isset($type['disabled_types'])) {
                $_disabledTypes[$type['value']] = $type['disabled_types'];
            }
        }
        Mage::register('attribute_type_hidden_fields', $_hiddenFields);
        Mage::register('attribute_type_disabled_types', $_disabledTypes);


        $fieldset->addField('frontend_input', 'select', array(
            'name' => 'frontend_input',
            'label' => Mage::helper('vladmin')->__('Admin Input Type'),
            'title' => Mage::helper('vladmin')->__('Admin Input Type'),
            'value' => 'text',
            'values'=> $inputTypes
        ));

//        $fieldset->addField('default_value_text', 'text', array(
//            'name' => 'default_value_text',
//            'label' => Mage::helper('vladmin')->__('Default value'),
//            'title' => Mage::helper('vladmin')->__('Default value'),
//            'value' => $model->getDefaultValue(),
//        ));
//
//        $fieldset->addField('default_value_yesno', 'select', array(
//            'name' => 'default_value_yesno',
//            'label' => Mage::helper('vladmin')->__('Default value'),
//            'title' => Mage::helper('vladmin')->__('Default value'),
//            'values' => $yesno,
//            'value' => $model->getDefaultValue(),
//        ));
//
//        $dateFormatIso = Mage::app()->getLocale()->getDateFormat(Mage_Core_Model_Locale::FORMAT_TYPE_SHORT);
//        $fieldset->addField('default_value_date', 'date', array(
//            'name'   => 'default_value_date',
//            'label'  => Mage::helper('vladmin')->__('Default value'),
//            'title'  => Mage::helper('vladmin')->__('Default value'),
//            'image'  => $this->getSkinUrl('images/grid-cal.gif'),
//            'value'  => $model->getDefaultValue(),
//            'format'       => $dateFormatIso
//        ));
//
//        $fieldset->addField('default_value_textarea', 'textarea', array(
//            'name' => 'default_value_textarea',
//            'label' => Mage::helper('vladmin')->__('Default value'),
//            'title' => Mage::helper('vladmin')->__('Default value'),
//            'value' => $model->getDefaultValue(),
//        ));
        
        $fieldset->addField('is_feed', 'select', array(
            'name' => 'is_feed',
            'label' => Mage::helper('vladmin')->__('Data Feed Only'),
            'title' => Mage::helper('vladmin')->__('Data Feed Only'),
            'values' => $yesno,
        ));

//        $fieldset->addField('is_unique', 'select', array(
//            'name' => 'is_unique',
//            'label' => Mage::helper('vladmin')->__('Unique Value'),
//            'title' => Mage::helper('vladmin')->__('Unique Value (not shared with other templates)'),
//            'note'  => Mage::helper('vladmin')->__('Not shared with other templates'),
//            'values' => $yesno,
//        ));

        $fieldset->addField('is_required', 'select', array(
            'name' => 'is_required',
            'label' => Mage::helper('vladmin')->__('Values Required'),
            'title' => Mage::helper('vladmin')->__('Values Required'),
            'values' => $yesno,
        ));

//        $fieldset->addField('frontend_class', 'select', array(
//            'name'  => 'frontend_class',
//            'label' => Mage::helper('vladmin')->__('Input Validation'),
//            'title' => Mage::helper('vladmin')->__('Input Validation'),
//            'values'=>  array(
//                array(
//                    'value' => '',
//                    'label' => Mage::helper('vladmin')->__('None')
//                ),
//                array(
//                    'value' => 'validate-number',
//                    'label' => Mage::helper('vladmin')->__('Decimal Number')
//                ),
//                array(
//                    'value' => 'validate-digits',
//                    'label' => Mage::helper('vladmin')->__('Integer Number')
//                ),
//                array(
//                    'value' => 'validate-email',
//                    'label' => Mage::helper('vladmin')->__('Email')
//                ),
//                array(
//                    'value' => 'validate-url',
//                    'label' => Mage::helper('vladmin')->__('Url')
//                ),
//                array(
//                    'value' => 'validate-alpha',
//                    'label' => Mage::helper('vladmin')->__('Letters')
//                ),
//                array(
//                    'value' => 'validate-alphanum',
//                    'label' => Mage::helper('vladmin')->__('Letters(a-zA-Z) or Numbers(0-9)')
//                ),
//            )
//        ));
/*
        $fieldset->addField('use_in_super_product', 'select', array(
            'name' => 'use_in_super_product',
            'label' => Mage::helper('catalog')->__('Apply To Configurable/Grouped Product'),
            'values' => $yesno,
        )); */

//        $fieldset->addField('apply_to', 'apply', array(
//            'name'        => 'apply_to[]',
//            'label'       => Mage::helper('catalog')->__('Apply To'),
//            'values'      => Mage_Catalog_Model_Product_Type::getOptions(),
//            'mode_labels' => array(
//                'all'     => Mage::helper('catalog')->__('All Product Types'),
//                'custom'  => Mage::helper('catalog')->__('Selected Product Types')
//            ),
//            'required'    => true
//        ));
//
//        $fieldset->addField('is_configurable', 'select', array(
//            'name' => 'is_configurable',
//            'label' => Mage::helper('catalog')->__('Use To Create Configurable Product'),
//            'values' => $yesno,
//        ));
        // -----


        // frontend properties fieldset
//        $fieldset = $form->addFieldset('front_fieldset', array('legend'=>Mage::helper('catalog')->__('Frontend Properties')));
//
//        $fieldset->addField('is_searchable', 'select', array(
//            'name' => 'is_searchable',
//            'label' => Mage::helper('catalog')->__('Use in quick search'),
//            'title' => Mage::helper('catalog')->__('Use in quick search'),
//            'values' => $yesno,
//        ));
//
//        $fieldset->addField('is_visible_in_advanced_search', 'select', array(
//            'name' => 'is_visible_in_advanced_search',
//            'label' => Mage::helper('catalog')->__('Use in advanced search'),
//            'title' => Mage::helper('catalog')->__('Use in advanced search'),
//            'values' => $yesno,
//        ));
//
//        $fieldset->addField('is_comparable', 'select', array(
//            'name' => 'is_comparable',
//            'label' => Mage::helper('catalog')->__('Comparable on Front-end'),
//            'title' => Mage::helper('catalog')->__('Comparable on Front-end'),
//            'values' => $yesno,
//        ));
//
//
//        $fieldset->addField('is_filterable', 'select', array(
//            'name' => 'is_filterable',
//            'label' => Mage::helper('catalog')->__("Use In Layered Navigation"),
//            'title' => Mage::helper('catalog')->__('Can be used only with catalog input type Dropdown, Multiple Select and Price'),
//            'note' => Mage::helper('catalog')->__('Can be used only with catalog input type Dropdown, Multiple Select and Price'),
//            'values' => array(
//                array('value' => '0', 'label' => Mage::helper('catalog')->__('No')),
//                array('value' => '1', 'label' => Mage::helper('catalog')->__('Filterable (with results)')),
//                array('value' => '2', 'label' => Mage::helper('catalog')->__('Filterable (no results)')),
//            ),
//        ));
//
//        $fieldset->addField('is_filterable_in_search', 'select', array(
//            'name' => 'is_filterable_in_search',
//            'label' => Mage::helper('catalog')->__("Use In Search Results Layered Navigation"),
//            'title' => Mage::helper('catalog')->__('Can be used only with catalog input type Dropdown, Multiple Select and Price'),
//            'note' => Mage::helper('catalog')->__('Can be used only with catalog input type Dropdown, Multiple Select and Price'),
//            'values' => $yesno,
//        ));
//
//        $fieldset->addField('is_used_for_price_rules', 'select', array(
//            'name' => 'is_used_for_price_rules',
//            'label' => Mage::helper('catalog')->__('Use for Price Rule Conditions'),
//            'title' => Mage::helper('catalog')->__('Use for Price Rule Conditions'),
//            'values' => $yesno,
//        ));
//
//        $fieldset->addField('position', 'text', array(
//            'name' => 'position',
//            'label' => Mage::helper('catalog')->__('Position'),
//            'title' => Mage::helper('catalog')->__('Position In Layered Navigation'),
//            'note' => Mage::helper('catalog')->__('Position of attribute in layered navigation block'),
//            'class' => 'validate-digits',
//        ));
//
//        $htmlAllowed = $fieldset->addField('is_html_allowed_on_front', 'select', array(
//            'name' => 'is_html_allowed_on_front',
//            'label' => Mage::helper('catalog')->__('Allow HTML-tags on Front-end'),
//            'title' => Mage::helper('catalog')->__('Allow HTML-tags on Front-end'),
//            'values' => $yesno,
//        ));
//        if (!$model->getId()) {
//            $htmlAllowed->setValue(1);
//        }
//
//        $fieldset->addField('is_visible_on_front', 'select', array(
//            'name'      => 'is_visible_on_front',
//            'label'     => Mage::helper('catalog')->__('Visible on Product View Page on Front-end'),
//            'title'     => Mage::helper('catalog')->__('Visible on Product View Page on Front-end'),
//            'values'    => $yesno,
//        ));
//
//        $fieldset->addField('used_in_product_listing', 'select', array(
//            'name'      => 'used_in_product_listing',
//            'label'     => Mage::helper('catalog')->__('Used in product listing'),
//            'title'     => Mage::helper('catalog')->__('Used in product listing'),
//            'note'      => Mage::helper('catalog')->__('Depends on design theme'),
//            'values'    => $yesno,
//        ));
//        $fieldset->addField('used_for_sort_by', 'select', array(
//            'name'      => 'used_for_sort_by',
//            'label'     => Mage::helper('catalog')->__('Used for sorting in product listing'),
//            'title'     => Mage::helper('catalog')->__('Used for sorting in product listing'),
//            'note'      => Mage::helper('catalog')->__('Depends on design theme'),
//            'values'    => $yesno,
//        ));

        if ($model->getId()) {
            $form->getElement('attribute_code')->setDisabled(1);
            $form->getElement('frontend_input')->setDisabled(1);

            if (isset($disableAttributeFields[$model->getAttributeCode()])) {
                foreach ($disableAttributeFields[$model->getAttributeCode()] as $field) {
                    $form->getElement($field)->setDisabled(1);
                }
            }
        }
//        if (!$model->getIsUserDefined() && $model->getId()) {
//            $form->getElement('is_unique')->setDisabled(1);
//        }

        $form->addValues($model->getData());

//        if ($model->getId() && isset($rewriteAttributeValue[$model->getAttributeCode()])) {
//            foreach ($rewriteAttributeValue[$model->getAttributeCode()] as $field => $value) {
//                $form->getElement($field)->setValue($value);
//            }
//        }

//        $form->getElement('apply_to')->setSize(5);
//
//        if ($applyTo = $model->getApplyTo()) {
//            $applyTo = is_array($applyTo) ? $applyTo : explode(',', $applyTo);
//            $form->getElement('apply_to')->setValue($applyTo);
//        } else {
//            $form->getElement('apply_to')->addClass('no-display ignore-validate');
//        }

        $this->setForm($form);

        return parent::_prepareForm();
    }

    protected function _getAdditionalElementTypes()
    {
        return array(
//            'apply' => Mage::getConfig()->getBlockClassName('adminhtml/catalog_product_helper_form_apply')
        );
    }

}
