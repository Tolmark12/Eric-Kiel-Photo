package app.control
{
import org.puremvc.as3.multicore.interfaces.*;
import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
import app.view.*;
import app.model.*;
import app.model.vo.*;
import app.AppFacade;

public class DataRequests extends SimpleCommand implements ICommand
{
	
	override public function execute( note:INotification ):void
	{
		var navProxy:NavProxy = facade.retrieveProxy( NavProxy.NAME ) as NavProxy;
		var externalDataProxy:ExternalDataProxy = facade.retrieveProxy( ExternalDataProxy.NAME ) as ExternalDataProxy;
		var portfolioProxy:PortfolioProxy = facade.retrieveProxy( PortfolioProxy.NAME ) as PortfolioProxy;
		
		switch ( note.getName() )
		{
			case AppFacade.CONFIG_LOADED_AND_PARSED :
				var configVo:ConfigVo = note.getBody() as ConfigVo;
				navProxy.config( configVo );
				portfolioProxy.config( configVo );
			break;
			case AppFacade.LOAD_NAV_DATA :
				externalDataProxy.loadNavData();
			break;
			case AppFacade.NAV_DATA_LOADED :
				navProxy.parseNavData( note.getBody() as Object )
			break;
			case AppFacade.LOAD_PAGE_DATA :
				var navItemVo:NavItemVo = note.getBody() as NavItemVo;
				if( navItemVo.pageType == "portfolio" )
					externalDataProxy.loadPortfolioData( navItemVo.dataFeed );
			break;
			case AppFacade.PORTFOLIO_DATA_LOADED :
				portfolioProxy.parseNewPortfolio( note.getBody() as Object );
			break;
			case AppFacade.IMAGE_LOADED :
				portfolioProxy.imageLoaded( note.getBody() as uint )
			break;
			case AppFacade.IMAGE_LOADED_LOW :
				portfolioProxy.imageLoaded( note.getBody() as uint )
			break;
		}
	}
}
}