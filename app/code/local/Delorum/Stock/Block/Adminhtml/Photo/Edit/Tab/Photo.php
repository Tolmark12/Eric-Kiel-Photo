<?php
class Delorum_Stock_Block_Adminhtml_Photo_Edit_Tab_Photo extends Mage_Adminhtml_Block_Abstract
{
  	public function _construct() 
	{
		$this->setTemplate('stock/photo/edit.phtml');
	}
	public function getPhotoUrl()
	{
		$id = $this->getRequest()->getParam('id');
		$photo = Mage::getModel('stock/photo')->getCollection()
			->addFieldToFilter('photo_id', $id)
			->getFirstItem();
		$path = Mage::getBaseUrl('web') . 'media/stock/comp/small/';
		return $path . $photo->getImage();
	}
	
	protected function _imageResize($width, $height, $target) {
		if ($width > $height) {
			$percentage = ($target / $width);
		} else {
			$percentage = ($target / $height);
		}

		$width = round($width * $percentage);
		$height = round($height * $percentage);

		return "width=\"$width\" height=\"$height\"";
	} 
	public function resizeMe()
	{
		$mydims = getimagesize($this->getPhotoUrl());
		return $this->_imageResize($mydims[0], $mydims[1], 350);
	}
	public function getRank()
	{
		$id = $this->getRequest()->getParam('id');
		$row = Mage::getModel('stock/photo')->getCollection()
			->addFieldToFilter('photo_id', $id)
			->getFirstItem();
		return $row->getRank();
	}
	public function getPhotoTags()
	{
		$id = $this->getRequest()->getParam('id');
		$photo = Mage::getModel('stock/photo_tag_link')->getCollection()
			->addFieldToFilter('photo_id', $id);
		$photo->getSelect()
			->join(array('t'=>'stock_photo_tag'),
			'main_table.tag_id = t.tag_id');
		return $photo;
	}
	
	public function popularTags()
	{
		$narr = $this->_staticArray('neq');
		$collection = Mage::getModel('stock/photo_tag_link')->getCollection()
			->addFieldToFilter('name', $narr);
		$collection->getSelect()
			->joinLeft(array('t'=>'stock_photo_tag'),
			'main_table.tag_id = t.tag_id',
			array('tag_count'=> 'COUNT(main_table.tag_id)', 'tag_name'=>'t.name'))
			->group('t.name')
			->order(array('tag_count DESC'))
			->limit(20);
		return $collection;
	}
	
	public function staticTags()
	{
		$arr = $this->_staticArray('eq');
		$collection = Mage::getModel('stock/photo_tag')->getCollection()
			->addFieldToFilter('name', $arr);
		return $collection;
	}
	
	protected function _staticArray($operand)
	{
		$array = array();
		$array[] = array(array($operand => 'places'));
		$array[] = array(array($operand => 'people'));
		$array[] = array(array($operand => 'sports'));
		$array[] = array(array($operand => 'water'));
		$array[] = array(array($operand => 'motors'));
		$array[] = array(array($operand => 'pieces+parts'));
		$array[] = array(array($operand => 'lifestyle'));
		$array[] = array(array($operand => 'animals'));
		return $array;
	}
}