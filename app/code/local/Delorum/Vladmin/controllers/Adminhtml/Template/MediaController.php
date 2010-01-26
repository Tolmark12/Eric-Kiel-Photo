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
 
class Delorum_Vladmin_Adminhtml_Template_MediaController extends Mage_Adminhtml_Controller_Action
{
	public function uploaderAction()
	{
		echo $this->getLayout()->createBlock('core/template')
			->setTemplate('vladmin/template/edit/form/image/iframe.phtml')
			->setName($this->getRequest()->getParam('name'))
			->setId($this->getRequest()->getParam('id'))
			->toHtml();
	}
	
	public function saveImageAction()
	{
		$result = array();
        try {
            $uploader = new Varien_File_Uploader('image');
            $uploader->setAllowedExtensions(array('jpg','jpeg','gif','png'));
            $uploader->setAllowRenameFiles(true);
            $uploader->setFilesDispersion(true);
            $config = Mage::getSingleton('vladmin/media_config');
			$result = $uploader->save($config->getBaseMediaPath());
			echo $this->getLayout()->createBlock('core/template')
				->setTemplate('vladmin/template/edit/form/image/iframe.phtml')
				->setName($this->getRequest()->getParam('name'))
				->setId($this->getRequest()->getParam('id'))
				->setUploadedFile($result['file'])
				->toHtml();
        } catch (Exception $e) {
            echo $e->getMessage();
        }
	}
}