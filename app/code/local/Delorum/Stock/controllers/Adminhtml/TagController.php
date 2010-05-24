<?php

class Delorum_Stock_Adminhtml_TagController extends Mage_Adminhtml_Controller_action
{
	public function importAction()
	{
		$this->loadLayout();
		$this->renderLayout();
	}
	
	protected function _initAction() {
		$this->loadLayout()
			->_setActiveMenu('stock/tags')
			->_addBreadcrumb(Mage::helper('adminhtml')->__('Tags Manager'), Mage::helper('adminhtml')->__('Tags Manager'));
		
		return $this;
	}   
	public function indexAction() {
		$collection = Mage::getModel('stock/photo_tag')->getCollection();
      	$collection->getSelect()
      		->joinLeft(array('tl' => 'stock_photo_tag_link'),
      			'main_table.tag_id = tl.tag_id',
      			array('COUNT(tl.tag_id) as tag_count'))
      		->group('main_table.tag_id');
      	foreach($collection as $tag) {
      		$tag->setUsed($tag->getTagCount());
      		$tag->save();
      	}
		$this->_initAction()
			->renderLayout();
	}
	
	public function importPostAction()
	{
		if($this->getRequest()->isPost()){
			$errors 		= array();
			$success		= array();
			$tagCount 		= 0;
			try{
				$lines = split("(\n|\r)", file_get_contents($_FILES['file']['tmp_name']));
				if(count($lines)){
					// popoff the first line here
					array_shift($lines);
					foreach($lines as $line){
						$fields = split("\t", $line);
						if(count($fields) && isset($fields[0]) && isset($fields[1])){
							try{
								$tags = explode(";", $fields[1]);
								if(count($tags)){
									$photo = Mage::getModel('stock/photo')->load($fields[0], 'image');
									$photo->importTags($tags);
									$tagCount += count($tags);
								}
							}catch(Mage_Core_Exception $e){
								$errors[] = $e->getMessage();
//								echo "Error: {$e->getMessage()} <br />";
							}catch(Exception $e){
								$errors[] = $e->getMessage();
//								echo "Error: {$e->getMessage()} <br />";
							}
						}
					}
				}else{
					$errors[] = "File appears to be empty";
					// add error here
				}
			}catch(Exception $e){
				$errors[] = $e->getMessage();
//				echo "Error: {$e->getMessage()} <br />";
			}
			$success[] = "A total of $tagCount tags have been successfully imported!";
			$this->loadLayout();
			$this->getLayout()->getBlock('import.results')
				->setSuccesses($success)
				->setErrors($errors);
			$this->renderLayout();
		}
	}
	public function massDeleteAction() {
        $tagIds = $this->getRequest()->getParam('tag');
        if(!is_array($tagIds)) {
			Mage::getSingleton('adminhtml/session')->addError(Mage::helper('adminhtml')->__('Please select tags(s)'));
        } else {
            try {
                foreach ($tagIds as $tagId) {
                	//remove tag links incase tag links exist
                	$collection = Mage::getModel('stock/photo_tag_link')->getCollection()
                		->addFieldToFilter('tag_id', $tagId);
                	foreach($collection as $link) {
                		$link->delete();
                	}
                	//remove tag itself
                    $tag = Mage::getModel('stock/photo_tag')->load($tagId);
                    $tag->delete();
                }
                Mage::getSingleton('adminhtml/session')->addSuccess(
                    Mage::helper('adminhtml')->__(
                        'Total of %d tag(s) were successfully deleted', count($tagIds)
                    )
                );
            } catch (Exception $e) {
                Mage::getSingleton('adminhtml/session')->addError($e->getMessage());
            }
        }
        $this->_redirect('*/*/index');
    }
}