package app.control
{
import org.puremvc.as3.multicore.interfaces.*;
import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
import app.view.*;
import app.model.*;
import app.model.vo.*;
import app.AppFacade;
import app.view.components.events.*;

public class Clicks extends SimpleCommand implements ICommand
{

	override public function execute( note:INotification ):void
	{
		var navProxy:NavProxy 				= facade.retrieveProxy( NavProxy.NAME ) as NavProxy;
		var portfolioProxy:PortfolioProxy 	= facade.retrieveProxy( PortfolioProxy.NAME ) as PortfolioProxy;
		var stockProxy:StockProxy 			= facade.retrieveProxy( StockProxy.NAME ) as StockProxy;
		
		switch (note.getName())
		{
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
			case AppFacade.NEW_FILTER_CLK :
				var fe:FilterEvent = note.getBody() as FilterEvent;
				stockProxy.loadNewPhotoSet( fe.tags )
			break;
			case AppFacade.STOCK_PHOTO_CLICKED :
				var stockEvent:StockEvent = note.getBody() as StockEvent;
				stockProxy.activateStockPhotoById(stockEvent.id)
			break;
			case AppFacade.STOCK_RESET :
				stockProxy.reset();
			break;
		}
	}
}
}