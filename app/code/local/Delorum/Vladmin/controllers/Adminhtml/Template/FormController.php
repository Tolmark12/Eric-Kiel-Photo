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
 
class Delorum_Vladmin_Adminhtml_Template_FormController extends Mage_Adminhtml_Controller_Action
{
	public function instanceCollectionGridAction()
	{
		$this->loadLayout();
		$this->getLayout()->getBlock('root')->setTemplate('blank.phtml');
		$this->_addContent(
			$this->getLayout()->createBlock('vladmin/adminhtml_template_edit_form_collection_instance_grid', '', array('options'=>$this->getRequest()->getParam('options'), 'element'=>$this->getRequest()->getParam('element')))
		);
		$this->renderLayout();
	}
	
	public function instanceCollectionGridAjaxAction()
	{
		$this->getResponse()->setBody(
			$this->getLayout()->createBlock('vladmin/adminhtml_template_edit_form_collection_instance_grid', '', array('options'=>$this->getRequest()->getParam('options'), 'element'=>$this->getRequest()->getParam('element')))->toHtml()
		);
	}
}