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

	private var _stockPhotoLanding:StockPhotoLanding = new StockPhotoLanding();	// Landing Page
	private var _stockPhotoStrip:StockPhotoStrip = new StockPhotoStrip();		// The actual photos
	private var _stockFilter:StockFilter = new StockFilter();					// The filter / browser
	private var _stockDetailView:StockDetailView = new StockDetailView();		// Shows the large image after click
	private var _stockMap:StockMap = new StockMap();
	
	public function StockMediator($stage:Sprite):void
	{
		super( NAME );
		$stage.addChild( _stockPhotoLanding );
		$stage.addChild( _stockFilter );
		$stage.addChild( _stockPhotoStrip );
		$stage.addChild( _stockDetailView );
		$stage.addChild( _stockMap );
		
		_stockMap.y = 550;
		
		_stockPhotoStrip.addEventListener( 		FilterEvent.ADD_TAG_TO_CURRENT_FILTER, _onAddTagToCurrentFilter, false,0,true );
		_stockFilter.addEventListener( 			FilterEvent.ADD_TAG_TO_CURRENT_FILTER, _onAddTagToCurrentFilter, false,0,true );
		_stockFilter.addEventListener( 			FilterEvent.NEW_FILTER, _onNewFilter, false,0,true );
		_stockPhotoLanding.addEventListener( 	FilterEvent.NEW_FILTER, _onNewFilter, false,0,true );
		_stockPhotoStrip.addEventListener( 		StockEvent.STOCK_PHOTO_CLICK, _onStockPhotoClick, false,0,true );
		_stockDetailView.addEventListener( 		StockEvent.ASK_A_QUESTION, _onAskAQuestion, false,0,true );
		_stockDetailView.addEventListener( 		StockEvent.DOWNLOAD_COMP, _onDownloadComp, false,0,true );
   	}
	
	
	// PureMVC: List notifications
	override public function listNotificationInterests():Array
	{
		return	[	AppFacade.STOCK_INIT,
					AppFacade.BUILD_STOCK_RESULTS,
		 			AppFacade.DISPLAY_STOCK_PHOTO,
			  	];
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
				_stockMap.buildNewSet( note.getBody() as StockPhotoSetVo )
			break;
			case AppFacade.DISPLAY_STOCK_PHOTO :
				_stockPhotoStrip.displayPhoto( note.getBody() as StockPhotoVo );
				_stockDetailView.displayImage( note.getBody() as StockPhotoVo );
			break;
		}
	}
	
	// _____________________________ Clear
	
	override public function clear (  ):void
	{
		_stockDetailView.clear();
		_stockPhotoLanding.clear();
		_stockPhotoStrip.clear();
		_stockFilter.clear();
		_stockMap.clear();
		sendNotification( AppFacade.STOCK_RESET );
	}
	
	// _____________________________ Event Handlers
	
	private function _onAddTagToCurrentFilter ( e:Event ):void {
		sendNotification( AppFacade.ADD_TAG_TO_FILTER_CLK, e );
	}
	
	private function _onNewFilter ( e:Event ):void {
		sendNotification( AppFacade.NEW_FILTER_CLK, e );
	}
	
	private function _onStockPhotoClick ( e:StockEvent ):void {
		sendNotification( AppFacade.STOCK_PHOTO_CLICKED, e );
	}
	
	
	private function _onAskAQuestion ( e:Event ):void {
		trace( "StockMediator: ask question" );
	}
	
	private function _onDownloadComp ( e:Event ):void {
		trace( "StockMediator: download comp" );
	}
	
	
}
}