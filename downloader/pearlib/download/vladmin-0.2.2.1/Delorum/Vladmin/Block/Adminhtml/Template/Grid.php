<?php

class Delorum_Vladmin_Block_Adminhtml_Template_Grid extends Mage_Adminhtml_Block_Widget_Grid
{
  public function __construct()
  {
      parent::__construct();
      $this->setId('templateGrid');
      $this->setDefaultSort('template_id');
      $this->setDefaultDir('ASC');
      $this->setSaveParametersInSession(true);
      $this->setUseAjax(true);
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

	  /*
      $this->addColumn('content', array(
			'header'    => Mage::helper('vladmin')->__('Item Content'),
			'width'     => '150px',
			'index'     => 'content',
      ));
	  */

	  $this->addColumn('created_at', array(
			'header'    => Mage::helper('vladmin')->__('Creation Time'),
			'align'     => 'left',
			'width'     => '120px',
			'type'      => 'date',
			'default'   => '--',
			'index'     => 'created_at',
	  ));

	  $this->addColumn('updated_at', array(
			'header'    => Mage::helper('vladmin')->__('Update Time'),
			'align'     => 'left',
			'width'     => '120px',
			'type'      => 'date',
			'default'   => '--',
			'index'     => 'updated_at',
	  ));

      $this->addColumn('is_active', array(
          'header'    => Mage::helper('vladmin')->__('Status'),
          'align'     => 'left',
          'width'     => '80px',
          'index'     => 'is_active',
          'type'      => 'options',
          'options'   => array(
              1 => 'Enabled',
              0 => 'Disabled',
          ),
      ));
	  
        $this->addColumn('action',
            array(
                'header'    =>  Mage::helper('vladmin')->__('Action'),
                'width'     => '100',
                'type'      => 'action',
                'getter'    => 'getId',
                'actions'   => array(
                    array(
                        'caption'   => Mage::helper('vladmin')->__('Edit'),
                        'url'       => array('base'=> '*/*/edit'),
                        'field'     => 'id'
                    )
                ),
                'filter'    => false,
                'sortable'  => false,
                'index'     => 'stores',
                'is_system' => true,
        ));
		
		$this->addExportType('*/*/exportCsv', Mage::helper('vladmin')->__('CSV'));
		$this->addExportType('*/*/exportXml', Mage::helper('vladmin')->__('XML'));
	  
      return parent::_prepareColumns();
  }

    protected function _prepareMassaction()
    {
        $this->setMassactionIdField('template_id');
        $this->getMassactionBlock()->setFormFieldName('template');

        $this->getMassactionBlock()->addItem('delete', array(
             'label'    => Mage::helper('vladmin')->__('Delete'),
             'url'      => $this->getUrl('*/*/massDelete'),
             'confirm'  => Mage::helper('vladmin')->__('Are you sure?')
        ));

        // $statuses = Mage::getSingleton('vladmin/status')->getOptionArray();
        // 
        //        array_unshift($statuses, array('label'=>'', 'value'=>''));
        //        $this->getMassactionBlock()->addItem('status', array(
        //             'label'=> Mage::helper('vladmin')->__('Change status'),
        //             'url'  => $this->getUrl('*/*/massStatus', array('_current'=>true)),
        //             'additional' => array(
        //                    'visibility' => array(
        //                         'name' => 'status',
        //                         'type' => 'select',
        //                         'class' => 'required-entry',
        //                         'label' => Mage::helper('vladmin')->__('Status'),
        //                         'values' => $statuses
        //                     )
        //             )
        //        ));
        return $this;
    }

	public function getGridUrl()
    {
        return $this->getUrl('*/*/grid', array('_current'=>true));
    }
    
	public function getRowUrl($row)
	{
		return $this->getUrl('*/*/edit', array('id' => $row->getId()));
	}

}