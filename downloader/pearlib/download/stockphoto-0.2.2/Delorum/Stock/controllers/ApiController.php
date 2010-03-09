<?php
class Delorum_Stock_ApiController extends Mage_Core_Controller_Front_Action
{
	public function getAllStockTagsAction()
	{
		$tags = array();
		$tagCollection = Mage::getResourceModel('stock/photo_tag_collection')->addOrder('name', 'asc');
		if(count($tagCollection)){
			foreach($tagCollection as $tag){
				$tags[] = array('id'=>(int) $tag->getId(), 'name'=>$tag->getName(), 'rank'=> (int) $tag->getRank());
			}
		}
//		print_r($tags);
		echo Zend_Json::encode($tags);
	}
	
	public function incrementStockTagRatingAction()
	{
		if($id = $this->getRequest()->getParam('id')){
			$tag = Mage::getModel('stock/photo_tag')->load($id);
			$tag->setRank($tag->getRank() + 1);
			$tag->save();
		}
		// maybe return something?
	}
	
	public function getStockPhotosByTagAction()
	{
		if(!$id = $this->getRequest()->getParam('id')){
			$text = $this->getRequest()->getParam('text');
			$tag = Mage::getModel('stock/photo_tag')->load($text, 'name');
			$id = $tag->getId();
		}
		$photos = array();
		$photoCollection = Mage::getResourceModel('stock/photo_collection');
		$photoCollection->getSelect()
		->join(
		array('t'=>'stock_photo_tag_link')
		,'t.photo_id = main_table.photo_id'
		)
		->where('t.tag_id = ?', $id);
		if(count($photoCollection)){
			foreach($photoCollection as $photo){
				$photos[] = array(
				 'id'					=> $photo->getId()
				,'name'					=> $photo->getName()
				,'rank'					=> $photo->getRank()
				,'tags'					=> $photo->getTagArray()
				,'file'					=> $photo->getImage()
				,'image'				=> Mage::getBaseUrl('media') . 'stock/comp/' . $photo->getImage()
				,'small_image'			=> Mage::getBaseUrl('media') . 'stock/comp/small/' . $photo->getImage()
				,'mid_image'			=> Mage::getBaseUrl('media') . 'stock/comp/mid/' . $photo->getImage()
				,'small_image_width'	=> $photo->getSmallWidth()
				);
			}
		}
		//			print_r($photos);
		echo Zend_Json::encode($photos);
	}
	
	public function getStockPhotosByIds()
	{
		$ids = explode(",", $this->getRequest()->getParam('ids'));
		$photos = array();
		$photoCollection = Mage::getResourceModel('stock/photo_collection');
		$photoCollection->getSelect()
		->join(
		array('t'=>'stock_photo_tag_link')
		,'t.photo_id = main_table.photo_id'
		)
		->where('t.tag_id IN (?)', $ids);
		if(count($photoCollection)){
			foreach($photoCollection as $photo){
				$photos[] = array(
				 'id'					=> $photo->getId()
				,'name'					=> $photo->getName()
				,'rank'					=> $photo->getRank()
				,'tags'					=> $photo->getTagArray()
				,'file'					=> $photo->getImage()
				,'image'				=> Mage::getBaseUrl('media') . 'stock/comp/' . $photo->getImage()
				,'small_image'			=> Mage::getBaseUrl('media') . 'stock/comp/small/' . $photo->getImage()
				,'mid_image'			=> Mage::getBaseUrl('media') . 'stock/comp/mid/' . $photo->getImage()
				,'small_image_width'	=> $photo->getSmallWidth()
				);
			}
		}
		//			print_r($photos);
		echo Zend_Json::encode($photos);
	}
}