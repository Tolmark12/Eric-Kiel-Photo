<?php

class Delorum_Vladmin_Model_Template extends Mage_Core_Model_Abstract
{
	const CACHE_TAG	= 'vladmin_template';
	
	public function __construct()
    {
        $this->_init('vladmin/template');
    }
    
    protected function _getIgnoredAttributes()
    {
    	return array(
    		'entity_type_id'
    		,'attribute_set_id'
    		,'created_at'
    		,'updated_at'
    	);
    }
    
    public function getCollection()
    {
    	return Mage::getResourceModel('vladmin/template_collection');
    }
    
	public function getAttributeText($attributeCode)
    {
        return $this->getResource()
            ->getAttribute($attributeCode)
                ->getSource()
                    ->getOptionText($this->getData($attributeCode));
    }
    
	public function build()
	{
		$array = array();
    	foreach($this->getResource()->getAttributesByCode() as $key=>$attribute){
    		// ignore certain attributes
    		if(in_array($key, $this->_getIgnoredAttributes())){
    			continue;
    		}
    		if($this->getData($key)){
	    		switch($attribute->getFrontendInput()){
	    			case 'select':
	    				$array[$key] = $this->getAttributeText($key);
	    				break;
	    			case 'multiselect':
	    				$selected = array();
	    				foreach(explode(",", $this->getData($key)) as $option){
	    					$selected[] = $attribute->getSource()->getOptionText($option);
	    				}
						$array[$key] = $selected; 				
	    				break;
	    			case 'instance_collection':
	    				$instanceCollection = array();
	    				$collection = Mage::getModel('vladmin/template')->getCollection()
	    					->addFieldToFilter('entity_id', array('in'=>explode(",", $this->getData($key))))
	    					->addFieldToFilter('entity_id', array('neq'=>$this->getId()))
							// ->addAttributeToFilter('status', 1)
	    					->addAttributeToSelect('*');
	    				// add collection sorting
	    				$collection->getSelect()
	    					->joinLeft(
		    					 array('o'=>'vladmin_template_entity_collection_order')
		    					,"e.entity_id = o.template_id AND o.parent_id = {$this->getId()} AND o.attribute_id = {$attribute->getId()}"
		    					,array()
		    				)->order('o.position');
	    				foreach($collection as $template){
	    					if($attribute->getIsFeed()){
	    						$instanceCollection[] = Mage::getBaseUrl('web') . 'vladmin/api/index/template/' . $template->getId();
	    					}else{
	    						$instanceCollection[] = $template->build();
	    					}
	    				}
	    				$array[$key] = $instanceCollection;
	    				break;
	    			case 'tag_collection':
	    				$tagCollection = array();
	    				$collection = Mage::getModel('vladmin/template')->getCollection()
	    					->addFieldToFilter('entity_id', array('neq'=>$this->getId()))
	    					->addAttributeToFilter('tags', array('like'=>"%{$this->getData($key)}%"))
							// ->addAttributeToFilter('status', 1)
	    					->addAttributeToSelect('*');
	    				// add collection sorting
	    				$collection->getSelect()
	    					->joinLeft(
		    					 array('o'=>'vladmin_template_entity_collection_order')
		    					,"e.entity_id = o.template_id AND o.parent_id = {$this->getId()} AND o.attribute_id = {$attribute->getId()}"
		    					,array()
		    				)->order('o.position');
	    				foreach($collection as $template){
	    					if($attribute->getIsFeed()){
	    						$tagCollection[] = Mage::getBaseUrl('web') . 'vladmin/api/index/template/' . $template->getId();
	    					}else{
    							$tagCollection[] = $template->build();
	    					}
	    				}
	    				$array[$key] = $tagCollection;
	    				break;
	    			case 'subcomponent':
	    				if($attribute->getIsFeed()){
	    					$array[$key] = Mage::getBaseUrl('web') . 'vladmin/api/index/template/' . $this->getData($key);
	    				}else{
    						$array[$key] = Mage::getModel('vladmin/template')->load($this->getData($key))->build();
	    				}
	    				break;
	    			case 'image':
	    				$array[$key] = Mage::getBaseUrl('media') . 'template' . $this->getData($key);
	    				break;
	    			default:
	    				$array[$key] = $this->getData($key);
	    				break;
	    		}
    		}
    	}
    	return $array;
	}
    
}