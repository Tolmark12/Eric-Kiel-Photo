<?php
/**
 * Magento
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Open Software License (OSL 3.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://opensource.org/licenses/osl-3.0.php
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@magentocommerce.com so we can send you a copy immediately.
 *
 * DISCLAIMER
 *
 * Do not edit or add to this file if you wish to upgrade Magento to newer
 * versions in the future. If you wish to customize Magento for your
 * needs please refer to http://www.magentocommerce.com for more information.
 *
 * @category   Mage
 * @package    Mage_Adminhtml
 * @copyright  Copyright (c) 2008 Irubin Consulting Inc. DBA Varien (http://www.varien.com)
 * @license    http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
 */

/**
 * Convert profile edit tab
 *
 * @category   Mage
 * @package    Mage_Adminhtml
 * @author      Magento Core Team <core@magentocommerce.com>
 */
class Mage_Adminhtml_Block_Extensions_Remote_Edit_Tab_Package
    extends Mage_Adminhtml_Block_Extensions_Remote_Edit_Tab_Abstract
{

    public function __construct()
    {
        parent::__construct();
        $this->setTemplate('extensions/remote/package.phtml');
    }

    public function getRelease()
    {
        if (!$this->hasData('release')) {
            $release = new Varien_Object;
            $release->setData($this->getPkg()->getData('releases/'.$this->getPkg()->getStable()));
            $this->setData('release', $release);
        }
        return $this->getData('release');
    }

    public function getMaintainerRoles()
    {
        return Mage::getModel('adminhtml/extension')->getMaintainerRoles();
    }

}

