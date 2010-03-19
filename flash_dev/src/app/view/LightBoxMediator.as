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
	
	private var _lightBoxBtn:LightBoxBtn = new LightBoxBtn_swc();
	private var _lightBox:LightBox = new LightBox();
	
	public function LightBoxMediator($stage:Sprite):void
	{
		super( NAME );
		$stage.addChild( _lightBox )
		$stage.addChild( _lightBoxBtn );
		_lightBoxBtn.addEventListener( MouseEvent.CLICK, _onShowLightBox, false,0,true );
   	}
	
	// PureMVC: List notifications
	override public function listNotificationInterests():Array
	{
		return [	AppFacade.STOCK_INIT,
					AppFacade.STAGE_RESIZE,
		 		 	AppFacade.UPDATE_LIGHTBOX_TOTAL,
		 			AppFacade.STOCK_RESET,
		 			AppFacade.SHOW_LIGHTBOX_CLICK ];
	}
	
	// PureMVC: Handle notifications
	override public function handleNotification( note:INotification ):void
	{
		switch ( note.getName() )
		{
			case AppFacade.STOCK_INIT :
				_lightBoxBtn.init();
			break;
			case  AppFacade.STAGE_RESIZE:
				_lightBox.position(note.getBody() as StageResizeVo );
				_lightBoxBtn.position( note.getBody() as StageResizeVo )
			break;
			case AppFacade.UPDATE_LIGHTBOX_TOTAL :
				_lightBoxBtn.updateItemsInLightbox( note.getBody() as Number );
			break;
			case AppFacade.STOCK_RESET :
				_lightBoxBtn.clear();
			break;
			case AppFacade.POPULATE_LIGHBOX :
				
			break;
			case AppFacade.SHOW_LIGHTBOX_CLICK :
				_lightBox.show();
			break;
		}
	}
	
	// _____________________________ Event Handlers
	
	private function _onShowLightBox ( e:Event ):void {
		sendNotification( AppFacade.SHOW_LIGHTBOX_CLICK );
	}
	
}
}