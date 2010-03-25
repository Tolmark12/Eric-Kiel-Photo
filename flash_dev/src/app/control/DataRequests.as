package app.control
{
import org.puremvc.as3.multicore.interfaces.*;
import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
import app.view.*;
import app.model.*;
import app.model.vo.*;
import app.AppFacade;
import delorum.utils.echo;

public class DataRequests extends SimpleCommand implements ICommand
{
	
	override public function execute( note:INotification ):void
	{
		var navProxy:NavProxy                   = facade.retrieveProxy( NavProxy.NAME ) as NavProxy;
		var externalDataProxy:ExternalDataProxy = facade.retrieveProxy( ExternalDataProxy.NAME ) as ExternalDataProxy;
		var portfolioProxy:PortfolioProxy       = facade.retrieveProxy( PortfolioProxy.NAME ) as PortfolioProxy;
		var lightBoxProxy:LightBoxProxy         = facade.retrieveProxy( LightBoxProxy.NAME ) as LightBoxProxy;
		var stockProxy:StockProxy 				= facade.retrieveProxy( StockProxy.NAME ) as StockProxy;
		var tagProxy:TagsProxy 					= facade.retrieveProxy( TagsProxy.NAME ) as TagsProxy;
		
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
				else if( navItemVo.pageType == "stock" )
					externalDataProxy.loadStockConfigData( navItemVo.dataFeed );
					//externalDataProxy.loadStockConfigData( navItemVo.dataFeed );
				//else
				//	trace( "Add the handler to DataRequests.as" );
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
			case AppFacade.NAV_INITIALIZED :
				// If the url indicates there is a lightbox to show, show that
				if( lightBoxProxy.doShowLightBox )
					lightBoxProxy.showLightBox();
				// Else, show the default nav item
				else
					navProxy.showDefaultPage();
			break;
			
			// _____________________________ Stock
			case AppFacade.STOCK_CONFIG_LOADED :
				stockProxy.parseConfigData( note.getBody() as Object );
			break;
			case AppFacade.LOAD_STOCK_DATA_SET :
				externalDataProxy.loadStockDataSet( note.getBody() as String );
			break;
			case AppFacade.STOCK_DATA_SET_LOADED :
				stockProxy.parseNewStockDataSet( note.getBody() as Object );
			break;
			case AppFacade.STOCK_TAGS_LOADED :
				tagProxy.parseStockDataTags( note.getBody() as Object );
			break;
			case AppFacade.LOAD_VIDEO :
				externalDataProxy.loadAjaxVideo( note.getBody() as String );
			break;
		}
	}
}
}