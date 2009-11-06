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
 
class Delorum_CacheControl_Block_Adminhtml_Edit_Form extends Mage_Adminhtml_Block_Widget_Form
{
public function initForm()
    {
        $form = new Varien_Data_Form();

        $fieldset = $form->addFieldset('cache_enable', array(
            'legend' => Mage::helper('adminhtml')->__('Cache Control')
        ));

        $fieldset->addField('all_cache', 'select', array(
            'name'=>'all_cache',
            'label'=>'<strong>'.Mage::helper('adminhtml')->__('All Cache').'</strong>',
            'value'=>1,
            'options'=>array(
                '' => Mage::helper('adminhtml')->__('No change'),
                'refresh' => Mage::helper('adminhtml')->__('Refresh'),
                'disable' => Mage::helper('adminhtml')->__('Disable'),
                'enable' => Mage::helper('adminhtml')->__('Enable'),
            ),
        ));

        foreach (Mage::helper('core')->getCacheTypes() as $type=>$label) {
            $fieldset->addField('enable_'.$type, 'checkbox', array(
                'name'=>'enable['.$type.']',
                'label'=>Mage::helper('adminhtml')->__($label),
                'value'=>1,
                'checked'=>(int)Mage::app()->useCache($type),
                //'options'=>$options,
            ));
        }

        $this->setForm($form);

        return $this;
    }
}