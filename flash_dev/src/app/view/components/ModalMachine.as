package app.view.components
{

import flash.display.Sprite;
import app.model.vo.FormVO;

public class ModalMachine extends Sprite
{
	private var _activeModal:Modal;
	
	public function ModalMachine():void
	{
		
	}
	
	public function createNewModal ( $formVo:FormVO ):void
	{
		closeModal();
		
		var modal:ModalForm = new ModalForm();
		this.addChild(modal);
		modal.build($formVo)
		_activeModal = modal;
	}
	
	public function closeModal (  ):void
	{
		if( _activeModal != null )
			_activeModal.clear();
		_activeModal = null;
	}
	
	public function get activeModal (  ):Modal { return _activeModal; };

}

}