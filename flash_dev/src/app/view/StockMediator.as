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


public class StockMediator extends PageMediator implements IMediator
{	
	public static const NAME:String = "stock_mediator";

	private var _stockPhotoLanding:StockPhotoLanding = new StockPhotoLanding();
	private var _stockPhotoStrip:StockPhotoStrip = new StockPhotoStrip();
	private var _stockFilter:StockFilter = new StockFilter();
	
	public function StockMediator($stage:Sprite):void
	{
		super( NAME );
		$stage.addChild( _stockPhotoLanding );
		$stage.addChild( _stockFilter );
		$stage.addChild( _stockPhotoStrip );
		
		
		_stockPhotoStrip.addEventListener( 		FilterEvent.ADD_TAG_TO_CURRENT_FILTER, _onAddTagToCurrentFilter, false,0,true );
		_stockFilter.addEventListener( 			FilterEvent.ADD_TAG_TO_CURRENT_FILTER, _onAddTagToCurrentFilter, false,0,true );
		_stockFilter.addEventListener( 			FilterEvent.NEW_FILTER, _onNewFilter, false,0,true );
		_stockPhotoLanding.addEventListener( 	FilterEvent.NEW_FILTER, _onNewFilter, false,0,true );
		
   	}
	
	
	// PureMVC: List notifications
	override public function listNotificationInterests():Array
	{
		return [ AppFacade.STOCK_INIT,
		 		 AppFacade.BUILD_STOCK_RESULTS, ];
	}
	
	// PureMVC: Handle notifications
	override public function handleNotification( note:INotification ):void
	{
		switch ( note.getName() )
		{
			case AppFacade.STOCK_INIT :
				sendNotification( AppFacade.MEDIATOR_ACTIVATED, this );
				_stockPhotoLanding.build(note.getBody() as StockConfigVo );
			break;
			case AppFacade.BUILD_STOCK_RESULTS :
				//_stockPhotoStrip.clear();
				_stockPhotoLanding.hide();
				_stockPhotoStrip.buildNewSet( note.getBody() as StockPhotoSetVo );
			break;
		}
	}
	
	// _____________________________ Clear
	
	override public function clear (  ):void
	{
		_stockPhotoLanding.clear();
		_stockPhotoStrip.clear();
		_stockFilter.clear();
	}
	
	// _____________________________ Events
	
	private function _onAddTagToCurrentFilter ( e:Event ):void {
		sendNotification( AppFacade.ADD_TAG_TO_FILTER_CLK, e );
	}
	
	private function _onNewFilter ( e:Event ):void {
		sendNotification( AppFacade.NEW_FILTER_CLK, e );
	}
	
	
	
}
}