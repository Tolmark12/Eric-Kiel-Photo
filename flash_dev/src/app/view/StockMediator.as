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
	private var _stockDetailView:StockDetailView = new StockDetailView();		// Shows the large image after click
	
	public function StockMediator($stage:Sprite):void
	{
		super( NAME );
		$stage.addChild( _stockPhotoLanding );
		$stage.addChild( _stockPhotoStrip );
		$stage.addChild( _stockDetailView );
		
		_stockPhotoLanding.addEventListener( 	StockTagEvent.SUBMIT_SEARCH_TERM, _onSubmitTerm, false,0,true );

		_stockPhotoStrip.addEventListener( 		FilterEvent.ADD_TAG_TO_CURRENT_FILTER, _onAddTagToCurrentFilter, false,0,true );
		_stockPhotoStrip.addEventListener( 		StockScrollEvent.SCROLL, _onScroll, false,0,true );
		_stockPhotoStrip.addEventListener( 		StockEvent.REMOVE_CATEGORY, _onRemoveCatetory, false,0,true );
		_stockPhotoStrip.addEventListener( 		StockEvent.STOCK_PHOTO_CLICK, _onStockPhotoClick, false,0,true );
		_stockPhotoStrip.addEventListener( 		StockEvent.STOCK_PHOTO_OVER, _onStockPhotoOver, false,0,true );
		_stockPhotoStrip.addEventListener( 		StockEvent.STOCK_PHOTO_OUT, _onStockPhotoOut, false,0,true );
		_stockPhotoStrip.addEventListener( 		StockEvent.ADD_TO_LIGHTBOX, _onAddToLightbox, false,0,true );
		
		_stockDetailView.addEventListener( 		ModalEvent.ASK_A_QUESTION, _onAskAQuestion, false,0,true );
		_stockDetailView.addEventListener( 		ModalEvent.DOWNLOAD_COMP, _onDownloadComp, false,0,true );
		_stockDetailView.addEventListener( 		ModalEvent.CLOSE_MODAL, _onCloseModal, false,0,true );
		_stockDetailView.addEventListener( 		StockEvent.STOCK_PHOTO_CLOSE, _onStockPhotoClose, false,0,true );
		_stockDetailView.addEventListener( 		StockEvent.ADD_TO_LIGHTBOX, _onAddToLightbox, false,0,true );
		
   	}
	
	
	// PureMVC: List notifications
	override public function listNotificationInterests():Array
	{
		return	[	AppFacade.STOCK_INIT,
					AppFacade.BUILD_STOCK_RESULTS,
		 			AppFacade.DISPLAY_STOCK_PHOTO,
					AppFacade.STOCK_SCROLL,
					AppFacade.STAGE_RESIZE,
					AppFacade.STOCK_CATEGORY_REMOVED,
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
				_stockPhotoLanding.hide();
				_stockPhotoStrip.buildNewSet( note.getBody() as Vector.<StockPhotoSetVo> );
			break;
			case AppFacade.DISPLAY_STOCK_PHOTO :
				_stockPhotoStrip.displayPhoto( note.getBody() as StockPhotoVo );
				_stockDetailView.displayImage( note.getBody() as StockPhotoVo );
				
			break;
			case AppFacade.STAGE_RESIZE :
				_stockPhotoStrip.setScrollWindow( note.getBody() as StageResizeVo );
			break;
			case AppFacade.STOCK_CATEGORY_REMOVED :
				_stockPhotoStrip.deleteStockTagById( note.getBody() as uint );
			break;
		}
	}
	
	public function addDetailViewToStage ( $stage:Sprite ):void
	{
		$stage.addChild( _stockDetailView );
	}
	
	// _____________________________ Clear
	
	override public function clear (  ):void
	{
		_stockDetailView.clear();
		_stockPhotoLanding.clear();
		_stockPhotoStrip.clear();
		sendNotification( AppFacade.STOCK_RESET );
	}
	
	// _____________________________ Event Handlers
	
	private function _onAddTagToCurrentFilter ( e:Event ):void {
		sendNotification( AppFacade.ADD_TAG_TO_FILTER_CLK, e );
	}
	
	private function _onSubmitTerm ( e:StockTagEvent ):void {
		sendNotification( AppFacade.SUBMIT_SEARCH_TERM, e );
	}
	
	private function _onStockPhotoClick ( e:StockEvent ):void {
		sendNotification( AppFacade.STOCK_PHOTO_CLICKED, e );
	}
	
	private function _onStockPhotoOver ( e:StockEvent ):void {
		_stockPhotoStrip.highlightImage( e.id );
	}
	
	private function _onStockPhotoOut ( e:StockEvent ):void {
		_stockPhotoStrip.unHighlightImage( e.id );
	}
	
	private function _onAskAQuestion ( e:ModalEvent ):void {
		sendNotification( AppFacade.SHOW_MODAL_CLICK, e );
	}
	
	private function _onDownloadComp ( e:ModalEvent ):void {
		sendNotification( AppFacade.SHOW_MODAL_CLICK, e )
	}
	
	private function _onScroll ( e:StockScrollEvent ):void {
		sendNotification( AppFacade.STOCK_SCROLL, e.pos );
	}
	
	private function _onRemoveCatetory ( e:StockEvent ):void {
		sendNotification( AppFacade.STOCK_REMOVE_CATEGORY, e.id );
	}
	
	private function _onCloseModal ( e:Event ):void {
		sendNotification( AppFacade.CLOSE_MODAL );
	}
	
	private function _onStockPhotoClose ( e:Event ):void {
		sendNotification( AppFacade.STOCK_PHOTO_CLOSE );
	}
	
	private function _onAddToLightbox ( e:StockEvent ):void {
		sendNotification( AppFacade.ADD_TO_LIGHTBOX, e.id );
	}
	
}
}