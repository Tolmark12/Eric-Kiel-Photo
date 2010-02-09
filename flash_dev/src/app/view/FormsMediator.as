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
		
		/* TEMP !!!!!!!!! */
		KeyTrigger.addKeyListener( _onBPress, "b", true )
		/* TEMP !!!!!!!!! */
   	}

	/* TEMP !!!!!!!!! */
	private function _onBPress (  ):void
	{
	   // var temp:ModalForm = new ModalForm();
	   // temp.build();
	   // _modalMachine.addChild(temp);
	}
	/* TEMP !!!!!!!!! */
	
	

	
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
	
}
}