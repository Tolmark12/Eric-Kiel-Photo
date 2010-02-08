<?php

class Delorum_Stock_Adminhtml_TagController extends Mage_Adminhtml_Controller_action
{
	public function importAction()
	{
		$this->loadLayout();
		$this->renderLayout();
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
	
}