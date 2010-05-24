<?php

class Delorum_Stock_Block_Adminhtml_Tag_Grid extends Mage_Adminhtml_Block_Widget_Grid
{
  public function __construct()
  {
      parent::__construct();
      $this->setId('tagGrid');
      $this->setDefaultSort('tag_id');
      $this->setDefaultDir('ASC');
      $this->setSaveParametersInSession(true);
  }

  protected function _prepareCollection()
  {
      $collection = Mage::getModel('stock/photo_tag')->getCollection();
     /*
 $collection->getSelect()
      		->join(array('tl' => 'stock_photo_tag_link'),
      			'main_table.tag_id = tl.tag_id',
      			array('COUNT(tl.tag_id) as tag_count'))
      		->group('main_table.tag_id')
      		->having('main_table.tag_id');
*/
      
      //echo $collection->getSelect()->__tostring();
      //exit;
      $this->setCollection($collection);
      return parent::_prepareCollection();
  }

  protected function _prepareColumns()
  {
      $this->addColumn('tag_id', array(
          'header'    => Mage::helper('stock')->__('ID'),
          'align'     =>'right',
          'width'     => '50px',
          'index'     => 'tag_id',
      ));

      $this->addColumn('name', array(
          'header'    => Mage::helper('stock')->__('Name'),
          'align'     =>'left',
          'index'     => 'name',
      ));
      
      $this->addColumn('used', array(
          'header'    => Mage::helper('stock')->__('Used Count'),
          'align'     =>'left',
          'width'     => '50px',
          'index'     => 'used',
      ));
		
//		$this->addExportType('*/*/exportCsv', Mage::helper('stock')->__('CSV'));
//		$this->addExportType('*/*/exportXml', Mage::helper('stock')->__('XML'));
	  
      return parent::_prepareColumns();
  }

    protected function _prepareMassaction()
    {
        $this->setMassactionIdField('tag_id');
        $this->getMassactionBlock()->setFormFieldName('tag');

        $this->getMassactionBlock()->addItem('delete', array(
             'label'    => Mage::helper('stock')->__('Delete'),
             'url'      => $this->getUrl('*/*/massDelete'),
             'confirm'  => Mage::helper('stock')->__('Are you sure?')
        ));

        $statuses = Mage::getSingleton('stock/status')->getOptionArray();

        array_unshift($statuses, array('label'=>'', 'value'=>''));
//        $this->getMassactionBlock()->addItem('status', array(
//             'label'=> Mage::helper('stock')->__('Change status'),
//             'url'  => $this->getUrl('*/*/massStatus', array('_current'=>true)),
//             'additional' => array(
//                    'visibility' => array(
//                         'name' => 'status',
//                         'type' => 'select',
//                         'class' => 'required-entry',
//                         'label' => Mage::helper('stock')->__('Status'),
//                         'values' => $statuses
//                     )
//             )
//        ));
        return $this;
    }


//public function getRowUrl($row)
  //{
     // return $this->getUrl('*/*/edit', array('id' => $row->getId()));
  //}


}