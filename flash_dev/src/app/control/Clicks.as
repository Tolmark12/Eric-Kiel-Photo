package app.control
{
import org.puremvc.as3.multicore.interfaces.*;
import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
import app.view.*;
import app.model.*;
import app.model.vo.*;
import app.AppFacade;
import app.view.components.events.*;
import flash.net.URLVariables;

public class Clicks extends SimpleCommand implements ICommand
{

	override public function execute( note:INotification ):void
	{
		var navProxy:NavProxy 						= facade.retrieveProxy( NavProxy.NAME ) as NavProxy;
		var portfolioProxy:PortfolioProxy 			= facade.retrieveProxy( PortfolioProxy.NAME ) as PortfolioProxy;
		var stockProxy:StockProxy 					= facade.retrieveProxy( StockProxy.NAME ) as StockProxy;
		var tagsProxy:TagsProxy 					= facade.retrieveProxy( TagsProxy.NAME ) as TagsProxy;
		var formProxy:FormProxy 					= facade.retrieveProxy( FormProxy.NAME ) as FormProxy;
		var lightBoxProxy:LightBoxProxy 			= facade.retrieveProxy( LightBoxProxy.NAME ) as LightBoxProxy;
		
		switch (note.getName())
		{
			case AppFacade.SEARCH_TERM_CHANGE :
				tagsProxy.onSearchTermChange( note.getBody() as String );
			break;
			case AppFacade.ADD_LETTER_TO_SEARCH :
				//trace( note.getBody() as String );
				tagsProxy.addLetterToSearch( note.getBody() as String );
			break;
			case AppFacade.NAV_BTN_CLICK :
				navProxy.changePage( note.getBody() as String );
			break;
			case AppFacade.PORTFOLIO_ITEM_CLICK :
				portfolioProxy.changeActiveItemByIndex( note.getBody() as uint );
			break;
			case AppFacade.PORTFOLIO_NEXT :
				portfolioProxy.next();
			break
			case AppFacade.PORTFOLIO_PREV :
				portfolioProxy.prev();
			break
			case AppFacade.PORTFOLIO_START :
				portfolioProxy.first();
			break
			case AppFacade.PORTFOLIO_END :
				portfolioProxy.last();
			break
			case AppFacade.ADD_FILTER :
				portfolioProxy.addFilter( note.getBody() as String );
			break;
			case AppFacade.REMOVE_FILTER :
				portfolioProxy.removeFilter( note.getBody() as String );
			break;
			case AppFacade.ADD_TAG_TO_FILTER_CLK :
				note.getBody() as FilterEvent;
				trace( "ADD_TAG_TO_FILTER_CLK" );
			break;
			case AppFacade.STOCK_PHOTO_CLICKED :
				var stockEvent:StockEvent = note.getBody() as StockEvent;
				stockProxy.activateStockPhotoById(stockEvent.id)
			break;
			case AppFacade.STOCK_RESET :
				stockProxy.reset();
			break;
			case AppFacade.NEW_TAG_SEARCH :
				tagsProxy.newSearch();
			break;
			case AppFacade.STOCK_REMOVE_CATEGORY :
				stockProxy.removeStockCategory( note.getBody()as String );
			break;
			case AppFacade.SUBMIT_SEARCH_TERM :
				var submitEvent:StockTagEvent = note.getBody() as StockTagEvent; 
				stockProxy.loadNewPhotoSet( submitEvent.searchTerm, submitEvent.clearPreviousSearch );
			break;
			case AppFacade.SHOW_MODAL_CLICK :
				formProxy.createNewModal( note.getBody() as ModalEvent );
			break;
			case AppFacade.STOCK_PHOTO_CLOSE :
				stockProxy.deactivateCurrentPhoto();
			break;
			case AppFacade.SUBMIT_FORM :
				formProxy.submitForm( note.getBody() as URLVariables);
			break;
			case AppFacade.ADD_TO_LIGHTBOX :
				lightBoxProxy.addItemToLightBox( note.getBody() as String );
			break;
			case AppFacade.PORTFOLIO_ITEM_SHOW_VIDEO :
				portfolioProxy.stockPhotoVideoClick();
			break;
			case AppFacade.LIGHTBOX_PHOTO_CLICKED :
				var stockEventTwo:StockEvent = note.getBody() as StockEvent;
				stockProxy.activateLightBoxPhotoById(stockEventTwo.id)
			break;
			case AppFacade.REMOVE_FROM_LIGHTBOX :
				lightBoxProxy.removeItemFromLightBox( note.getBody() as String );
			break;
			case AppFacade.EMAIL_LIGHTBOX :
				lightBoxProxy.emailLightBox();
			break;
		}
	}
}
}