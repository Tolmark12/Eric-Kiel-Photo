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

public class LightBoxMediator extends Mediator implements IMediator
{	
	public static const NAME:String = "light_box_mediator";

	public function LightBoxMediator($stage:Sprite):void
	{
		super( NAME );
   	}
	
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