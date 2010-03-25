package app.view
{
import org.puremvc.as3.multicore.interfaces.*;
import org.puremvc.as3.multicore.patterns.mediator.Mediator;
import app.AppFacade;
import app.model.vo.*;
import app.view.components.*;
import flash.events.*;
import app.view.components.events.*;
import flash.display.Sprite;
import delorum.utils.KeyTrigger;

public class FormsMediator extends Mediator implements IMediator
{	
	public static const NAME:String = "forms_mediator";
	
	private var _modalMachine:ModalMachine = new ModalMachine();
	
	public function FormsMediator($stage:Sprite):void
	{
		super( NAME );
		
		$stage.addChild( _modalMachine );
		_modalMachine.addEventListener( ModalEvent.SUBMIT_FORM, _onSubmitForm, false,0,true );
   	}

	
	// PureMVC: List notifications
	override public function listNotificationInterests():Array
	{
		return [	AppFacade.CREATE_NEW_MODAL,
		 			AppFacade.CLOSE_MODAL ];
	}
	
	// PureMVC: Handle notifications
	override public function handleNotification( note:INotification ):void
	{
		switch ( note.getName() )
		{
			case AppFacade.CREATE_NEW_MODAL :
				_modalMachine.createNewModal( note.getBody() as FormVO );
			break;
			case AppFacade.CLOSE_MODAL :
				_modalMachine.closeModal()
			break;
		}
	}
	
	// _____________________________ Event Handlers
	
	private function _onSubmitForm ( e:ModalEvent ):void {
		sendNotification( AppFacade.SUBMIT_FORM, e.urlVars );
	}
	
}
}