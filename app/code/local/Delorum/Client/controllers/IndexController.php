<?php
class Delorum_Client_IndexController extends Mage_Core_Controller_Front_Action
{
	public function postDataAction()
	{
		$data = $this->getRequest()->getParams();
		if(isset($data['message'])) {
			$type = 3;
		} else {
			$type = 2;
		}
		$data['created_at'] = now();
		$data['updated_at'] = now();
		$client = Mage::getModel('client/client');
		$client->setData($data);
		$client->save();
		Mage::getModel('core/email_template')
			->sendTransactional(
				$type, 
				array('email' => 'web@kielphoto.com', 'name' => 'Eric Kiel Photo'), 
				$data['email'], 
				$data['name'], 
				array('name' => $data['name'])
		);
	}
}