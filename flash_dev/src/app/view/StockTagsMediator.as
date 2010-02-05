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

public class StockTagsMediator extends Mediator implements IMediator
{	
	public static const NAME:String = "stock_tags_mediator";

	private var _stockTags:StockTags = new StockTags();


	public function StockTagsMediator( $stage:Sprite ):void
	{
		super( NAME );
		$stage.addChild( _stockTags );
		_stockTags.y = 50;
		_stockTags.x = 400;
		
		_stockTags.addEventListener( 			StockTagEvent.ADD_LETTER_TO_SEARCH, _onAddLetterToSearch, false,0,true );
		_stockTags.addEventListener( 			StockTagEvent.NEW_TAG_SEARCH, _onNewTagSearch, false,0,true );
		_stockTags.addEventListener( 			StockTagEvent.SEARCH_TERM_CHANGE, _onSearchTermChange, false,0,true );
		
   	}
	
	// PureMVC: List notifications
	override public function listNotificationInterests():Array
	{
		return	[	AppFacade.DISPLAY_TAG_HINTS,
		  			AppFacade.STOCK_RESET,
		 			AppFacade.STOCK_INIT,
		 			AppFacade.STOCK_TAGS_LOADED, ];
	}
	
	// PureMVC: Handle notifications
	override public function handleNotification( note:INotification ):void
	{
		switch ( note.getName() )
		{
			case AppFacade.DISPLAY_TAG_HINTS :
				_stockTags.displaySearchTagHints( note.getBody() as Array );
			break;
			case AppFacade.STOCK_RESET :
				_stockTags.clear();
			break;
			case AppFacade.STOCK_INIT :
				//_stockTags.show();
			break;
			case AppFacade.STOCK_TAGS_LOADED :
				_stockTags.show();
			break;
		}
	}
	
	// _____________________________ Event Handlers
	
	private function _onNewTagSearch ( e:StockTagEvent ):void {
		sendNotification( AppFacade.NEW_TAG_SEARCH );
	}
	
	private function _onAddLetterToSearch( e:StockTagEvent ):void {
		sendNotification( AppFacade.ADD_LETTER_TO_SEARCH, e.newLetter );
	}
	
	private function _onSearchTermChange ( e:StockTagEvent ):void {
		sendNotification( AppFacade.SEARCH_TERM_CHANGE, e.searchTerm );
	}
	
}
}