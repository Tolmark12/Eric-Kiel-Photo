<?php

class Delorum_Stock_Model_Photo extends Mage_Core_Model_Abstract
{
	
	protected $_tags;
	protected $_tagArray;
	
    public function _construct()
    {
        parent::_construct();
        $this->_init('stock/photo');
    }
    
    public function getTagArray()
    {
    	if(!$this->_tagArray){
	    	$tags = array();
			$tagCollection = $this->getTags();
			
			
			if(count($tagCollection)){
				foreach($tagCollection as $tag){
					$tags[] = array('id'=>(int) $tag->getId(), 'name'=>$tag->getName(), 'rank'=>(int) $tag->getRank());
				}
			}
			$this->_tagArray = $tags;
    	}
    	return $this->_tagArray;
    }
    
    public function getTags()
    {
    	if(!$this->_tags){
    		$tags = Mage::getResourceModel('stock/photo_tag_collection');
    		$tags->getSelect()
				->join(
				 	array('l'=>'stock_photo_tag_link')
					,'l.tag_id = main_table.tag_id'
				)
				->where('l.photo_id = ?', $this->getId())
				->group('main_table.tag_id');
			$this->_tags = $tags;
    	}
    	return $this->_tags;
    }
    
    public function importTags($tags)
    {
    	// assuming an indexed array, not keyed
    	
    	//iterate through tags
    	foreach($tags as $tag){
    		// set tag
    		$tag = Mage::getModel('stock/photo_tag')->load($tag, 'name')->setName($tag)->save();
    		// create link
    		// see if one already exists
    		$links = Mage::getResourceModel('stock/photo_tag_link_collection')
    			->addFieldToFilter('photo_id', $this->getId())
    			->addFieldToFilter('tag_id', $tag->getId());
    		if(!count($links)){
    			// doesn't exist, must create it
    			$link = Mage::getModel('stock/photo_tag_link')
    				->setPhotoId($this->getId())
    				->setTagId($tag->getId())
    				->save();
    		}
    	}
    	return $this;
    }
}