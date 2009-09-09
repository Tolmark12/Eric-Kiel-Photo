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
 
class Delorum_Vladmin_Block_Adminhtml_Attribute_Grid extends Mage_Adminhtml_Block_Widget_Grid
{
	public function __construct()
    {
        parent::__construct();
        $this->setId('attributeGrid');
        $this->setDefaultSort('attribute_code');
        $this->setDefaultDir('ASC');
    }

    protected function _prepareCollection()
    {
        $collection = Mage::getResourceModel('eav/entity_attribute_collection')
            ->setEntityTypeFilter( Mage::getModel('eav/entity')->setType('vladmin_template')->getTypeId() )
            ->addVisibleFilter();
        $this->setCollection($collection);

        return parent::_prepareCollection();
    }

    protected function _prepareColumns()
    {
        /*
        $this->addColumn('attribute_id', array(
            'header'=>Mage::helper('vladmin')->__('ID'),
            'align'=>'right',
            'sortable'=>true,
            'width' => '50px',
            'index'=>'attribute_id'
        ));
        */

        $this->addColumn('attribute_code', array(
            'header'=>Mage::helper('vladmin')->__('Attribute Code'),
            'sortable'=>true,
            'index'=>'attribute_code'
        ));

        $this->addColumn('frontend_label', array(
            'header'=>Mage::helper('vladmin')->__('Attribute Label'),
            'sortable'=>true,
            'index'=>'frontend_label'
        ));

//        $this->addColumn('is_visible', array(
//            'header'=>Mage::helper('vladmin')->__('Visible'),
//            'sortable'=>true,
//            'index'=>'is_visible_on_front',
//            'type' => 'options',
//            'options' => array(
//                '1' => Mage::helper('vladmin')->__('Yes'),
//                '0' => Mage::helper('vladmin')->__('No'),
//            ),
//            'align' => 'center',
//        ));

//        $this->addColumn('is_global', array(
//            'header'=>Mage::helper('vladmin')->__('Scope'),
//            'sortable'=>true,
//            'index'=>'is_global',
//            'type' => 'options',
//            'options' => array(
//                Mage_Catalog_Model_Resource_Eav_Attribute::SCOPE_STORE =>Mage::helper('catalog')->__('Store View'),
//                Mage_Catalog_Model_Resource_Eav_Attribute::SCOPE_WEBSITE =>Mage::helper('catalog')->__('Website'),
//                Mage_Catalog_Model_Resource_Eav_Attribute::SCOPE_GLOBAL =>Mage::helper('catalog')->__('Global'),
//            ),
//            'align' => 'center',
//        ));

        $this->addColumn('is_required', array(
            'header'=>Mage::helper('vladmin')->__('Required'),
            'sortable'=>true,
            'index'=>'is_required',
            'type' => 'options',
            'options' => array(
                '1' => Mage::helper('vladmin')->__('Yes'),
                '0' => Mage::helper('vladmin')->__('No'),
            ),
            'align' => 'center',
        ));

        $this->addColumn('is_user_defined', array(
            'header'=>Mage::helper('vladmin')->__('System'),
            'sortable'=>true,
            'index'=>'is_user_defined',
            'type' => 'options',
            'align' => 'center',
            'options' => array(
                '0' => Mage::helper('vladmin')->__('Yes'),   // intended reverted use
                '1' => Mage::helper('vladmin')->__('No'),    // intended reverted use
            ),
        ));

//        $this->addColumn('is_searchable', array(
//            'header'=>Mage::helper('catalog')->__('Searchable'),
//            'sortable'=>true,
//            'index'=>'is_searchable',
//            'type' => 'options',
//            'options' => array(
//                '1' => Mage::helper('catalog')->__('Yes'),
//                '0' => Mage::helper('catalog')->__('No'),
//            ),
//            'align' => 'center',
//        ));
//
//        $this->addColumn('is_filterable', array(
//            'header'=>Mage::helper('catalog')->__('Use In Layered Navigation'),
//            'sortable'=>true,
//            'index'=>'is_filterable',
//            'type' => 'options',
//            'options' => array(
//                '1' => Mage::helper('catalog')->__('Filterable (with results)'),
//                '2' => Mage::helper('catalog')->__('Filterable (no results)'),
//                '0' => Mage::helper('catalog')->__('No'),
//            ),
//            'align' => 'center',
//        ));
//
//        $this->addColumn('is_comparable', array(
//            'header'=>Mage::helper('catalog')->__('Comparable'),
//            'sortable'=>true,
//            'index'=>'is_comparable',
//            'type' => 'options',
//            'options' => array(
//                '1' => Mage::helper('catalog')->__('Yes'),
//                '0' => Mage::helper('catalog')->__('No'),
//            ),
//            'align' => 'center',
//        ));

        return parent::_prepareColumns();
    }

    public function getRowUrl($row)
    {
        return $this->getUrl('*/*/edit', array('attribute_id' => $row->getAttributeId()));
    }
}