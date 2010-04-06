package app.control
{
import Kiel09;
import org.puremvc.as3.multicore.interfaces.*;
import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
import app.view.*;
import app.model.*;
import app.model.vo.*;
import app.AppFacade;
import flash.display.Sprite;
import flash.events.Event;
import delorum.utils.echo;

public class Startup extends SimpleCommand implements ICommand
{

	override public function execute( note:INotification ):void
	{
		
		var kielRoot:Kiel09 = note.getBody() as Kiel09;
		
		// Mediators
		var browserMediator:BrowserMediator 		= new BrowserMediator(kielRoot.stage);
		var contentMediator:ContentMediator 		= new ContentMediator(kielRoot);
		var portfolioMediator:PortfolioMediator 	= new PortfolioMediator(kielRoot);
		var stockMediator:StockMediator 			= new StockMediator(kielRoot);
		var navMediator:NavMediator 				= new NavMediator(kielRoot);
		var stockTagsMediator:StockTagsMediator 	= new StockTagsMediator(kielRoot);
		
		// Call this funtion so the detail view is above the nav...
		stockMediator.addDetailViewToStage(kielRoot)
		var formsMediator:FormsMediator		 		= new FormsMediator(kielRoot);
		var lightBoxMediator:LightBoxMediator 		= new LightBoxMediator(kielRoot);
					
		// Proxies
		var externalDataProxy:ExternalDataProxy 	= new ExternalDataProxy();
		var navProxy:NavProxy 						= new NavProxy( kielRoot );
		var portfolioProxy:PortfolioProxy 			= new PortfolioProxy();
		var stockProxy:StockProxy 					= new StockProxy();
		var lightBoxProxy:LightBoxProxy 			= new LightBoxProxy(kielRoot.urlLightboxItems);
		var tagsProxy:TagsProxy 					= new TagsProxy();
		var formProxy:FormProxy 					= new FormProxy();
		
		
		// Register Mediators + Proxies
		facade.registerMediator( contentMediator );
		facade.registerMediator( browserMediator );
		facade.registerMediator( portfolioMediator );
		facade.registerMediator( navMediator );
		facade.registerMediator( stockMediator );
		facade.registerMediator( lightBoxMediator );
		facade.registerMediator( formsMediator );
		facade.registerMediator( stockTagsMediator );
		
		facade.registerProxy( externalDataProxy );
		facade.registerProxy( navProxy );
		facade.registerProxy( portfolioProxy );
		facade.registerProxy( stockProxy );
		facade.registerProxy( lightBoxProxy );
		facade.registerProxy( tagsProxy );
		facade.registerProxy( formProxy );
		
		// Start Data load
		externalDataProxy.getConfigData(kielRoot.stage);
		// Fire first stage resize event
		kielRoot.stage.dispatchEvent( new Event(Event.RESIZE, true) );
	}
}
}