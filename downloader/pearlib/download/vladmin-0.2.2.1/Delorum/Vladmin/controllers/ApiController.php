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
 
class Delorum_Vladmin_ApiController extends Mage_Core_Controller_Front_Action
{
	protected $_root;
	
	protected function _getRootTemplate()
	{
		if(!$this->_root){
			$this->_root = Mage::getModel('vladmin/template')->getCollection()
				->addAttributeToFilter('name', 'root')
				->addAttributeToSelect('*')
				->getFirstItem();
		}
		return $this->_root;
	}
	
	protected function _loadCache()
	{
		if (is_null($this->getCacheLifetime()) || !Mage::app()->useCache('vladmin_template')) {
            return false;
        }
        return Mage::app()->loadCache($this->getCacheKey());
	}
	
	protected function _saveCache($data)
	{
		if (is_null($this->getCacheLifetime()) || !Mage::app()->useCache('vladmin_template')) {
            return false;
        }
        Mage::app()->saveCache($data, $this->getCacheKey(), $this->getCacheTags(), $this->getCacheLifetime());
        return $this;
	}
	
	public function getCacheLifetime()
	{
		return false;
	}
	
	public function getCacheKey()
	{
		return 'vladmin_api_template_' . (($template = $this->getRequest()->getParam('template'))? $template : 'root');
	}
	
	public function getCacheTags()
	{
		return array(Delorum_Vladmin_Model_Template::CACHE_TAG . '_' . (($template = $this->getRequest()->getParam('template'))? $template : 'root'));
	}
	
	public function indexAction()
	{
		ini_set('display_errors', 1);
		ini_set('memory_limit', '512M');
		Mage::setIsDeveloperMode(true);
		
		echo "here";
		
		$output = '';
		if (!($output = $this->_loadCache())) {
			$template = '';
			$id = (int) $this->getRequest()->getParam('template');
			if($id){
				$template = Mage::getModel('vladmin/template')->load($id);
			}else{
				// find root template
				$template = $this->_getRootTemplate();
			}
			$build = $template->build();
//			print_r($build);
//			exit;
			$json = Zend_Json::encode($build);
			$this->_saveCache($json);
			$output = $json;
		}
		
		echo $output;
	}
	
}