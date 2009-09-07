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
 
class Delorum_CacheControl_Adminhtml_IndexController extends Mage_Adminhtml_Controller_action
{
	public function indexAction()
	{
		 $this->loadLayout()
            ->_setActiveMenu('system/cachecontroller')
            ->_addContent($this->getLayout()->createBlock('cachecontrol/adminhtml_edit')->initForm())
            ->renderLayout();
	}
	
	public function saveAction()
	{
		/**
         * Protect empty post data
         */
        $postData = $this->getRequest()->getPost();
        if (empty($postData)) {
            $this->_redirect('*/*');
            return;
        }

        /**
         * Process cache settings
         */
        $allCache = $this->getRequest()->getPost('all_cache');
        if ($allCache=='disable' || $allCache=='refresh') {
            Mage::app()->cleanCache();
        }

        $e = $this->getRequest()->getPost('enable');
        $enable = array();
        $clean  = array();
        $cacheTypes = array_keys(Mage::helper('core')->getCacheTypes());
        foreach ($cacheTypes as $type) {
            $flag = $allCache!='disable' && (!empty($e[$type]) || $allCache=='enable');
            $enable[$type] = $flag ? 1 : 0;
            if ($allCache=='' && !$flag) {
                $clean[] = $type;
            }
        }

        $beta = $this->getRequest()->getPost('beta');
        $betaCache = array_keys(Mage::helper('core')->getCacheBetaTypes());

        foreach ($betaCache as $type) {
            if (empty($beta[$type])) {
                $clean[] = $type;
            } else {
                $enable[$type] = 1;
            }
        }

        if (!empty($clean)) {
            Mage::app()->cleanCache($clean);
        }
        Mage::app()->saveUseCache($enable);
        
        $this->_redirect('*/*');
	}
	
	protected function _isAllowed()
    {
        return Mage::getSingleton('admin/session')->isAllowed('system/tools/cachecontrol');
    }
}