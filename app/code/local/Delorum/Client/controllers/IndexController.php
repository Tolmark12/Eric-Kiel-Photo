<?php
class Delorum_Client_IndexController extends Mage_Core_Controller_Front_Action
{
	public function postDataAction()
	{
		$data = $this->getRequest()->getParams();
		$type = $data['formtype'];
		$data['created_at'] = now();
		$data['updated_at'] = now();
		try {
			$client = Mage::getModel('client/client');
			$client->setData($data);
			$client->save();
			if(isset($data['name'])) {
				$data['emailname'] = $data['name'];
			}
			if(isset($data['email'])) {
				$data['emailemail'] = $data['email'];
			}
			Mage::getModel('core/email_template')
				->sendTransactional(
					$type, 
					array('email' => 'web@kielphoto.com', 'name' => 'Eric Kiel Photo'), 
					$data['targetemail'], 
					$data['targetemail'],  
					$data
			);
		} catch(Exception $e) {
			echo 'There was an error in saving information';
		}
		return $this;
	}
}