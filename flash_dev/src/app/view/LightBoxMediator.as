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
		_lightBoxBtn.addEventListener( 	MouseEvent.CLICK, _onOpenOrClose, false,0,true );
		_lightBox.addEventListener(	StockEvent.STOCK_PHOTO_CLICK, _onStockPhotoClick, false,0,true );
		_lightBox.addEventListener( StockEvent.REMOVE_FROM_LIGHTBOX, _onRemoveFromLightbox, false,0,true );
		_lightBox.addEventListener( LightboxEvent.EMAIL_LIGHTBOX, _onEmailLightbox, false,0,true );
		_lightBox.addEventListener( LightboxEvent.OPEN_OR_CLOSE, _onOpenOrClose, false,0,true );
   	}
	
	// PureMVC: List notifications
	override public function listNotificationInterests():Array
	{
		return [	AppFacade.STOCK_INIT,
					AppFacade.STAGE_RESIZE,
		 		 	AppFacade.UPDATE_LIGHTBOX_TOTAL,
		 			AppFacade.STOCK_RESET,
		 			AppFacade.SHOW_LIGHTBOX,
		 			AppFacade.HIDE_LIGHTBOX,
		 			AppFacade.POPULATE_LIGHTBOX, ];
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
			case AppFacade.POPULATE_LIGHTBOX :
				_lightBox.populate( note.getBody() as StockPhotoSetVo );
			break;
			case AppFacade.SHOW_LIGHTBOX :
				_lightBoxBtn.activate();
				_lightBox.show();
			break;
			case AppFacade.HIDE_LIGHTBOX :
				_lightBoxBtn.deactivate();
				_lightBox.hide();
			break;
		}
	}
	
	// _____________________________ Event Handlers
	
	private function _onOpenOrClose ( e:Event ):void {
		if( _lightBoxBtn.isActive )
			sendNotification( AppFacade.HIDE_LIGHTBOX );
		else
			sendNotification( AppFacade.SHOW_LIGHTBOX );
	}
	
	private function _onStockPhotoClick ( e:Event ):void {
		sendNotification( AppFacade.LIGHTBOX_PHOTO_CLICKED, e );
	}
	
	private function _onRemoveFromLightbox ( e:StockEvent ):void {
		sendNotification( AppFacade.REMOVE_FROM_LIGHTBOX, e.id );
	}
	
	private function _onEmailLightbox ( e:Event ):void {
		sendNotification( AppFacade.EMAIL_LIGHTBOX );
	}
	
}
}