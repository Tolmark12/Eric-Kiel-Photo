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


public class StockMediator extends Mediator implements IMediator
{	
	public static const NAME:String = "stock_mediator";

	private var _stockPhotoStrip:StockPhotoStrip = new StockPhotoStrip();
	
	public function StockMediator($stage:Sprite):void
	{
		super( NAME );
		
		$stage.addChild( _stockPhotoStrip );
		/* TEMP */
		KeyTrigger.addKeyListener( _onBPress, "b", true )
		/* TEMP */
   	}

	private function _onBPress (  ):void
	{
		var temp:ModalForm = new ModalForm();
		_stockPhotoStrip.addChild(temp);
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