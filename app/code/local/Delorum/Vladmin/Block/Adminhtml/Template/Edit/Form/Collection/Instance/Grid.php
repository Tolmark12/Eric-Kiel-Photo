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

class Delorum_Vladmin_Block_Adminhtml_Template_Edit_Form_Collection_Instance_Grid extends Mage_Adminhtml_Block_Widget_Grid
{
	public function __construct($params=null)
	{
		parent::__construct();
		$this->setTemplate('vladmin/template/edit/form/collection/instance/grid.phtml');
		$this->setId('templateGrid');
		$this->setDefaultSort('template_id');
		$this->setDefaultDir('ASC');
		$this->setSaveParametersInSession(true);
		$this->setUseAjax(true);
		$this->setTemplateOptions($params['options']);
		$this->setElementId($params['element']);
		$this->setRowClickCallback($this->getCallback());
		$this->setCheckboxCheckCallback($this->getSelectAllCallback());
	}

	protected function _prepareCollection()
	{
		$collection = Mage::getModel('vladmin/template')->getCollection()
			->addAttributeToSelect('name');
		$this->setCollection($collection);
		return parent::_prepareCollection();
	}

	protected function _prepareColumns()
	{
		$this->addColumn('in_templates', array(
			'header_css_class' => 'a-center',
			'type'      => 'checkbox',
			'name'      => 'in_templates',
			'values'    => $this->getSelectedTemplates(),
			'align'     => 'center',
			'index'     => 'entity_id'
		));
		
		$this->addColumn('entity_id', array(
          'header'    => Mage::helper('vladmin')->__('ID'),
          'align'     =>'right',
          'width'     => '50px',
          'index'     => 'entity_id',
		));

		$sets = Mage::getResourceModel('eav/entity_attribute_set_collection')
            ->setEntityTypeFilter(Mage::getModel('vladmin/template')->getResource()->getTypeId())
            ->load()
            ->toOptionHash();

        $this->addColumn('set_name',
            array(
                'header'=> Mage::helper('vladmin')->__('Template Type'),
                'width' => '100px',
                'index' => 'attribute_set_id',
                'type'  => 'options',
                'options' => $sets,
        ));
		
		$this->addColumn('name', array(
          'header'    => Mage::helper('vladmin')->__('Name'),
          'align'     =>'left',
          'index'     => 'name',
		));
	}

	public function getGridUrl()
    {
        return $this->getUrl('*/*/instanceCollectionGridAjax', array('_current'=>true, 'options'=>$this->getTemplateOptions(), 'element'=>$this->getElementId()));
    }
    
    public function getSelectedTemplates()
    {
    	return explode(",", $this->getTemplateOptions());
    }
    
	public function getCallback()
    {
    	return "
    		function(grid, event){
    			var box 	= $(Event.element(event));
    			var id 		= box.up().next().innerHTML;
    			var options = parent.$('{$this->getElementId()}');
    			if(box.checked){
    				if(options.value)
    					options.value += ',';
    				options.value += id;
    			}else{
    				var ids = options.value.split(',');
					var without = ids.without(id);
					options.value = without.toString();    					
    			}
			}
    		";
    }
    
	public function getSelectAllCallback()
    {
    	return "
    		function(grid, element, checked, event){
    			var id = parseInt(element.value);
    			if(id){
	    			var options = parent.$('{$this->getElementId()}');
	    			if(checked){
	    				if(options.value)
	    					options.value += ',';
	    				options.value += id;
	    			}else{
	    				var ids = options.value.split(',');
						var without = ids.without(id);
						options.value = without.toString();    					
	    			}
    			}
			}
    		";
    }


}