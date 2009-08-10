package app.view
{
import org.puremvc.as3.multicore.interfaces.*;
import org.puremvc.as3.multicore.patterns.mediator.Mediator;
import app.AppFacade;
import app.model.vo.*;
import app.view.components.*;
import flash.events.*;
import app.view.components.events.*;
import SWFAddress;
import SWFAddressEvent;
import delorum.utils.echo;
import flash.external.ExternalInterface;
import flash.display.Stage;

public class BrowserMediator extends Mediator implements IMediator
{	
	public static const NAME:String = "swf_address_mediator";
	
	private var _stage:Stage;
	
	public function BrowserMediator( $stage:Stage ):void
	{
		super( NAME );
		_stage = $stage;
		_stage.addEventListener( Event.RESIZE, _onStageResize, false,0,true );
		
   	}
	
	// PureMVC: List notifications
	override public function listNotificationInterests():Array
	{
		return [ AppFacade.UPDATE_PATH,
		 		 AppFacade.NAV_DATA_PARSED,
		 		 AppFacade.REFRESH_ALIGN ];
	}
	
	// PureMVC: Handle notifications
	override public function handleNotification( note:INotification ):void
	{
		switch ( note.getName() )
		{
			// After the navigation objects are parsed, listen for 
			// browser address changes
			case AppFacade.NAV_DATA_PARSED :
				SWFAddress.addEventListener(SWFAddressEvent.CHANGE, _onSwfAddressChange );
				ExternalInterface.call("swffit.fit", "kiel_swf", StageResizeVo.MIN_WIDTH, 650 );
			break;
			case AppFacade.UPDATE_PATH:
				var pathVo:PathVo = note.getBody() as PathVo;
				echo( pathVo.fullPath );
				SWFAddress.setValue( pathVo.fullPath );
			break;
			case AppFacade.REFRESH_ALIGN :
				_onStageResize(null);
			break;
		}
	}
	
	// _____________________________ Event Handlers
	
	private function _onSwfAddressChange ( e:SWFAddressEvent ):void {
		sendNotification( AppFacade.NAV_BTN_CLICK, e.value );
	}
	
	private function _onStageResize ( e:Event ):void {
		var vo:StageResizeVo = new StageResizeVo( _stage )
		sendNotification( AppFacade.STAGE_RESIZE, new StageResizeVo( _stage ) );
	}
	
}
}