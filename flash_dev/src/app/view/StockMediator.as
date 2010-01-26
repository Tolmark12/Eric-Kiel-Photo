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
import app.view.components.stock_tags.TagBrowser;

public class StockMediator extends PageMediator implements IMediator
{	
	public static const NAME:String = "stock_mediator";

	private var _stockPhotoLanding:StockPhotoLanding = new StockPhotoLanding();	// Landing Page
	private var _stockPhotoStrip:StockPhotoStrip = new StockPhotoStrip();		// The actual photos
	private var _stockFilter:StockFilter = new StockFilter();					// The filter / browser
	private var _stockDetailView:StockDetailView = new StockDetailView();		// Shows the large image after click
	private var _stockMap:StockMap = new StockMap();
	private var _stockTags:StockTags = new StockTags();
	
	public function StockMediator($stage:Sprite):void
	{
		super( NAME );
		$stage.addChild( _stockPhotoLanding );
		$stage.addChild( _stockFilter );
		$stage.addChild( _stockPhotoStrip );
		$stage.addChild( _stockDetailView );
		$stage.addChild( _stockMap );
		$stage.addChild( _stockTags );
		
		_stockMap.y  = 550;
		_stockTags.y = 50;
		_stockTags.x = 400;
		
		_stockPhotoStrip.addEventListener( 		FilterEvent.ADD_TAG_TO_CURRENT_FILTER, _onAddTagToCurrentFilter, false,0,true );
		_stockFilter.addEventListener( 			FilterEvent.ADD_TAG_TO_CURRENT_FILTER, _onAddTagToCurrentFilter, false,0,true );
		_stockFilter.addEventListener( 			FilterEvent.NEW_FILTER, _onNewFilter, false,0,true );
		_stockPhotoLanding.addEventListener( 	FilterEvent.NEW_FILTER, _onNewFilter, false,0,true );
		_stockPhotoStrip.addEventListener( 		StockEvent.STOCK_PHOTO_CLICK, _onStockPhotoClick, false,0,true );
		_stockDetailView.addEventListener( 		StockEvent.ASK_A_QUESTION, _onAskAQuestion, false,0,true );
		_stockDetailView.addEventListener( 		StockEvent.DOWNLOAD_COMP, _onDownloadComp, false,0,true );
		
		_stockTags.addEventListener( 			StockTagEvent.ADD_LETTER_TO_SEARCH, _onAddLetterToSearch, false,0,true );
		_stockTags.addEventListener( 			StockTagEvent.NEW_TAG_SEARCH, _onNewTagSearch, false,0,true );
		_stockTags.addEventListener( 			StockTagEvent.SEARCH_TERM_CHANGE, _onSearchTermChange, false,0,true );
		
		_stockMap.addEventListener( StockScrollEvent.SCROLL, _onScroll, false,0,true );
   	}
	
	
	// PureMVC: List notifications
	override public function listNotificationInterests():Array
	{
		return	[	AppFacade.STOCK_INIT,
					AppFacade.BUILD_STOCK_RESULTS,
		 			AppFacade.DISPLAY_STOCK_PHOTO,
					AppFacade.DISPLAY_TAG_HINTS,
					AppFacade.STOCK_SCROLL,
					AppFacade.STAGE_RESIZE,
			  	];
	}
	
	// PureMVC: Handle notifications
	override public function handleNotification( note:INotification ):void
	{
		switch ( note.getName() )
		{
			case AppFacade.STOCK_SCROLL :
				_stockPhotoStrip.scroll( note.getBody() as Number );
			break;
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
			case AppFacade.DISPLAY_TAG_HINTS :
				_stockTags.displaySearchTagHints( note.getBody() as Array );
			break;
			case AppFacade.STAGE_RESIZE :
				_stockPhotoStrip.setScrollWindow( note.getBody() as StageResizeVo );
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
		_stockTags.clear();
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
	
	private function _onNewTagSearch ( e:StockTagEvent ):void {
		sendNotification( AppFacade.NEW_TAG_SEARCH );
	}
	
	private function _onAddLetterToSearch( e:StockTagEvent ):void {
		sendNotification( AppFacade.ADD_LETTER_TO_SEARCH, e.newLetter );
	}
	
	private function _onSearchTermChange ( e:StockTagEvent ):void {
		sendNotification( AppFacade.SEARCH_TERM_CHANGE, e.searchTerm );
	}
	
	private function _onScroll ( e:StockScrollEvent ):void {
		sendNotification( AppFacade.STOCK_SCROLL, e.pos );
	}
	
	
	
}
}