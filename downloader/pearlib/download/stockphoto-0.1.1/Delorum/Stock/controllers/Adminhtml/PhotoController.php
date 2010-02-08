<?php

class Delorum_Stock_Adminhtml_PhotoController extends Mage_Adminhtml_Controller_action
{

	protected function _initAction() {
		$this->loadLayout()
			->_setActiveMenu('stock/items')
			->_addBreadcrumb(Mage::helper('adminhtml')->__('Items Manager'), Mage::helper('adminhtml')->__('Item Manager'));
		
		return $this;
	}   
 
	public function indexAction() {
		$this->_initAction()
			->renderLayout();
	}

	public function editAction() {
		$id     = $this->getRequest()->getParam('id');
		$model  = Mage::getModel('stock/photo')->load($id);

		if ($model->getId() || $id == 0) {
			$data = Mage::getSingleton('adminhtml/session')->getFormData(true);
			if (!empty($data)) {
				$model->setData($data);
			}

			Mage::register('photo_data', $model);

			$this->loadLayout();
			$this->_setActiveMenu('stock/items');

			$this->_addBreadcrumb(Mage::helper('adminhtml')->__('Item Manager'), Mage::helper('adminhtml')->__('Item Manager'));
			$this->_addBreadcrumb(Mage::helper('adminhtml')->__('Item News'), Mage::helper('adminhtml')->__('Item News'));

			$this->getLayout()->getBlock('head')->setCanLoadExtJs(true);

			$this->_addContent($this->getLayout()->createBlock('stock/adminhtml_photo_edit'))
				->_addLeft($this->getLayout()->createBlock('stock/adminhtml_photo_edit_tabs'));

			$this->renderLayout();
		} else {
			Mage::getSingleton('adminhtml/session')->addError(Mage::helper('stock')->__('Item does not exist'));
			$this->_redirect('*/*/');
		}
	}
 
	public function newAction() {
		$this->_forward('edit');
	}
 
	public function saveAction() {
		if ($data = $this->getRequest()->getPost()) {
			
//			print_r($_FILES);
//			exit;
			
			if(isset($_FILES['image']['name']) && $_FILES['image']['name'] != '') {
				try {
					/* Starting upload */	
					$uploader = new Varien_File_Uploader('image');
					
					// Any extention would work
	           		$uploader->setAllowedExtensions(array('jpg','jpeg','gif','png'));
					$uploader->setAllowRenameFiles(false);
					
					// Set the file upload mode 
					// false -> get the file directly in the specified folder
					// true -> get the file in the product like folders 
					//	(file.jpg will go in something like /media/f/i/file.jpg)
					$uploader->setFilesDispersion(false);
					
					$image = $_FILES['image']['name'];
					
					// We set media as the upload dir
					$path = Mage::getBaseDir('media') . DS . 'stock' . DS . 'comp' . DS;
					$uploader->save($path, $image);
					
					// comp(osition)
					list($width, $height, $type, $attr) = getimagesize($path.$image);
					
					// now resize to make a mid
					// height will be 475
					// width will be %
					$midWidth = ceil($width * (475 / $height));
					$mid = new Delorum_Image_Resize($path.$image);
					$mid->resize($midWidth, 475);
					if (!(@is_dir($path . 'mid' . DS) || @mkdir($path . 'mid' . DS, 0777, true))) {
						Mage::getSingleton('adminhtml/session')->addError("Unable to create directory '" . $path . 'mid' . DS ."'.");
			        }
					$mid->save($path . 'mid' . DS . $image);
					
					// now resize to make a small
					// height will be 141
					// width will be %
					$smallWidth = ceil($width * (141 / $height));
					$small = new Delorum_Image_Resize($path.$image);
					$small->resize($smallWidth, 141);
					if (!(@is_dir($path . 'small' . DS) || @mkdir($path . 'small' . DS, 0777, true))) {
			            Mage::getSingleton('adminhtml/session')->addError("Unable to create directory '" . $path . 'small' . DS ."'.");
			        }
					$small->save($path . 'small' . DS . $image);
					
				} catch (Exception $e) {
					echo $e->getMessage();
		        }
	        
		        //this way the name is saved in DB
	  			$data['image'] 			= $image;
	  			$data['small_width']	= $smallWidth;
	  			$data['mid_width']		= $midWidth;
	  			$data['large_width']	= $width;
			}
	  			
	  			
			$model = Mage::getModel('stock/photo');		
			$model->setData($data)
				->setId($this->getRequest()->getParam('id'));
			
			try {
				if ($model->getCreatedAt() == NULL || $model->getUpdatedAt() == NULL) {
					$model->setCreatedAt(now())
						->setUpdatedAt(now());
				} else {
					$model->setUpdatedAt(now());
				}	
				
				$model->save();
				Mage::getSingleton('adminhtml/session')->addSuccess(Mage::helper('stock')->__('Item was successfully saved'));
				Mage::getSingleton('adminhtml/session')->setFormData(false);

				if ($this->getRequest()->getParam('back')) {
					$this->_redirect('*/*/edit', array('id' => $model->getId()));
					return;
				}
				$this->_redirect('*/*/');
				return;
            } catch (Exception $e) {
                Mage::getSingleton('adminhtml/session')->addError($e->getMessage());
                Mage::getSingleton('adminhtml/session')->setFormData($data);
                $this->_redirect('*/*/edit', array('id' => $this->getRequest()->getParam('id')));
                return;
            }
        }
        Mage::getSingleton('adminhtml/session')->addError(Mage::helper('stock')->__('Unable to find item to save'));
        $this->_redirect('*/*/');
	}
 
	public function deleteAction() {
		if( $this->getRequest()->getParam('id') > 0 ) {
			try {
				$model = Mage::getModel('stock/photo');
				 
				$model->setId($this->getRequest()->getParam('id'))
					->delete();
					 
				Mage::getSingleton('adminhtml/session')->addSuccess(Mage::helper('adminhtml')->__('Item was successfully deleted'));
				$this->_redirect('*/*/');
			} catch (Exception $e) {
				Mage::getSingleton('adminhtml/session')->addError($e->getMessage());
				$this->_redirect('*/*/edit', array('id' => $this->getRequest()->getParam('id')));
			}
		}
		$this->_redirect('*/*/');
	}

    public function massDeleteAction() {
        $stockIds = $this->getRequest()->getParam('stock');
        if(!is_array($stockIds)) {
			Mage::getSingleton('adminhtml/session')->addError(Mage::helper('adminhtml')->__('Please select item(s)'));
        } else {
            try {
                foreach ($stockIds as $stockId) {
                    $stock = Mage::getModel('stock/photo')->load($stockId);
                    $stock->delete();
                }
                Mage::getSingleton('adminhtml/session')->addSuccess(
                    Mage::helper('adminhtml')->__(
                        'Total of %d record(s) were successfully deleted', count($stockIds)
                    )
                );
            } catch (Exception $e) {
                Mage::getSingleton('adminhtml/session')->addError($e->getMessage());
            }
        }
        $this->_redirect('*/*/index');
    }
	
    public function massStatusAction()
    {
        $stockIds = $this->getRequest()->getParam('stock');
        if(!is_array($stockIds)) {
            Mage::getSingleton('adminhtml/session')->addError($this->__('Please select item(s)'));
        } else {
            try {
                foreach ($stockIds as $stockId) {
                    $stock = Mage::getSingleton('stock/photo')
                        ->load($stockId)
                        ->setStatus($this->getRequest()->getParam('status'))
                        ->setIsMassupdate(true)
                        ->save();
                }
                $this->_getSession()->addSuccess(
                    $this->__('Total of %d record(s) were successfully updated', count($stockIds))
                );
            } catch (Exception $e) {
                $this->_getSession()->addError($e->getMessage());
            }
        }
        $this->_redirect('*/*/index');
    }
  
    public function exportCsvAction()
    {
        $fileName   = 'stock.csv';
        $content    = $this->getLayout()->createBlock('stock/adminhtml_stock_grid')
            ->getCsv();

        $this->_sendUploadResponse($fileName, $content);
    }

    public function exportXmlAction()
    {
        $fileName   = 'stock.xml';
        $content    = $this->getLayout()->createBlock('stock/adminhtml_stock_grid')
            ->getXml();

        $this->_sendUploadResponse($fileName, $content);
    }

    protected function _sendUploadResponse($fileName, $content, $contentType='application/octet-stream')
    {
        $response = $this->getResponse();
        $response->setHeader('HTTP/1.1 200 OK','');
        $response->setHeader('Pragma', 'public', true);
        $response->setHeader('Cache-Control', 'must-revalidate, post-check=0, pre-check=0', true);
        $response->setHeader('Content-Disposition', 'attachment; filename='.$fileName);
        $response->setHeader('Last-Modified', date('r'));
        $response->setHeader('Accept-Ranges', 'bytes');
        $response->setHeader('Content-Length', strlen($content));
        $response->setHeader('Content-type', $contentType);
        $response->setBody($content);
        $response->sendResponse();
        die;
    }
}