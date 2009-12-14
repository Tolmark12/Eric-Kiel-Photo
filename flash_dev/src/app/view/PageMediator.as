package app.view
{
import org.puremvc.as3.multicore.interfaces.*;
import org.puremvc.as3.multicore.patterns.mediator.Mediator;
import app.AppFacade;
import app.model.vo.*;
import app.view.components.*;
import flash.events.*;
import app.view.components.events.*;


public class PageMediator extends Mediator implements IMediator
{	
	public var isClear:Boolean;
	
	public function PageMediator($name:String):void
	{
		super( $name );
   	}

	public function clear (  ):void
	{
		
	}
	
	// PureMVC: List notifications
	//override public function listNotificationInterests():Array {return [];}
	
	// PureMVC: Handle notifications
	//override public function handleNotification( note:INotification ):void {}
	
}
}