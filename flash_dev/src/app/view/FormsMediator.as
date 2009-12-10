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

public class FormsMediator extends Mediator implements IMediator
{	
	public static const NAME:String = "forms_mediator";
	
	private var _forms:Sprite = new Sprite();
	
	public function FormsMediator($stage:Sprite):void
	{
		super( NAME );
		
		$stage.addChild( _forms );
		
		/* TEMP !!!!!!!!! */
		KeyTrigger.addKeyListener( _onBPress, "b", true )
		/* TEMP !!!!!!!!! */
   	}

	/* TEMP !!!!!!!!! */
	private function _onBPress (  ):void
	{
		var temp:ModalForm = new ModalForm();
		temp.build();
		_forms.addChild(temp);
	}
	/* TEMP !!!!!!!!! */
	
	

	
	// PureMVC: List notifications
	override public function listNotificationInterests():Array
	{
		return []; //[ AppFacade.NOTIFICATION ];
	}
	
	// PureMVC: Handle notifications
	override public function handleNotification( note:INotification ):void
	{
		switch ( note.getName() )
		{
			/*case AppFacade.NOTIFICATION:
				// CODE
				break;*/
		}
	}
	
}
}