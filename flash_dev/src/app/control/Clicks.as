package app.control
{
import org.puremvc.as3.multicore.interfaces.*;
import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
import app.view.*;
import app.model.*;
import app.model.vo.*;
import app.AppFacade;

public class Clicks extends SimpleCommand implements ICommand
{

	override public function execute( note:INotification ):void
	{
		var navProxy:NavProxy = facade.retrieveProxy( NavProxy.NAME ) as NavProxy;
		var portfolioProxy:PortfolioProxy = facade.retrieveProxy( PortfolioProxy.NAME ) as PortfolioProxy;
		
		switch (note.getName())
		{
			case AppFacade.NAV_BTN_CLICK :
				navProxy.changePage( note.getBody() as String );
			break;
			case AppFacade.PORTFOLIO_ITEM_CLICK :
				portfolioProxy.changeActiveItemByIndex( note.getBody() as uint );
			break;
		}
	}
}
}