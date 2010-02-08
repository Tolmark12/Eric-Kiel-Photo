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
 
class Delorum_Vladmin_Model_Media_Config implements Mage_Media_Model_Image_Config_Interface
{
		private $_type = 'template';
		
		public function setType($type)
		{
			$this->_type = $type;
		}
	
        public function getBaseMediaPath()
        {
            return Mage::getBaseDir('media') . DS . $this->_type;
        }

        public function getBaseMediaUrl()
        {
            return Mage::getBaseUrl('media') . $this->_type;
        }

        public function getBaseTmpMediaPath()
        {
            return Mage::getBaseDir('media') . DS . 'tmp' .  DS . $this->_type;
        }

        public function getBaseTmpMediaUrl()
        {
            return Mage::getBaseUrl('media') . 'tmp/' . $this->_type;
        }

        public function getMediaUrl($file)
        {
            if(in_array(substr($file, 0, 1), array('/'))) {
                return $this->getBaseMediaUrl() . $file;
            }

            return $this->getBaseMediaUrl() . '/' . $file;
        }

        public function getMediaPath($file)
        {
            if(in_array(substr($file, 0, 1), array('/', DIRECTORY_SEPARATOR))) {
                return $this->getBaseMediaPath() . DIRECTORY_SEPARATOR . substr($file, 1);
            }

            return $this->getBaseMediaPath() . DIRECTORY_SEPARATOR . $file;
        }

        public function getTmpMediaUrl($file)
        {
            if(in_array(substr($file, 0, 1), array('/'))) {
                return $this->getBaseTmpMediaUrl() . $file;
            }

            return $this->getBaseTmpMediaUrl() . '/' . $file;
        }

        public function getTmpMediaPath($file)
        {
            if(in_array(substr($file, 0, 1), array('/', DIRECTORY_SEPARATOR))) {
                return $this->getBaseTmpMediaPath() . DIRECTORY_SEPARATOR . substr($file, 1);
            }

            return $this->getBaseTmpMediaPath() . DIRECTORY_SEPARATOR . $file;
        }
}