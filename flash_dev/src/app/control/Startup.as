package app.control
{
import org.puremvc.as3.multicore.interfaces.*;
import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
import app.view.*;
import app.model.*;
import app.model.vo.*;
import app.AppFacade;
import flash.display.Sprite;
import flash.events.Event;

public class Startup extends SimpleCommand implements ICommand
{

	override public function execute( note:INotification ):void
	{
		var kielRoot = note.getBody() as Sprite;
		
		// Mediators
		var browserMediator:BrowserMediator 		= new BrowserMediator(kielRoot.stage);
		var contentMediator:ContentMediator 		= new ContentMediator(kielRoot);
		var portfolioMediator:PortfolioMediator 	= new PortfolioMediator(kielRoot);
		var stockMediator:StockMediator 			= new StockMediator(kielRoot);
		var navMediator:NavMediator 				= new NavMediator(kielRoot);
		var formsMediator:FormsMediator		 		= new FormsMediator(kielRoot);
		var lightBoxMediator:LightBoxMediator 		= new LightBoxMediator(kielRoot);
		
		// Proxies
		var externalDataProxy:ExternalDataProxy 	= new ExternalDataProxy();
		var navProxy:NavProxy 						= new NavProxy();
		var portfolioProxy:PortfolioProxy 			= new PortfolioProxy();
		var stockProxy:StockProxy 					= new StockProxy();
		var lightBoxProxy:LightBoxProxy 			= new LightBoxProxy();
		
		// Register Mediators + Proxies
		facade.registerMediator( contentMediator );
		facade.registerMediator( browserMediator );
		facade.registerMediator( portfolioMediator );
		facade.registerMediator( navMediator );
		facade.registerMediator( stockMediator );
		facade.registerMediator( lightBoxMediator );
		facade.registerMediator( formsMediator );
		
		facade.registerProxy( externalDataProxy );
		facade.registerProxy( navProxy );
		facade.registerProxy( portfolioProxy );
		facade.registerProxy( stockProxy );
		facade.registerProxy( lightBoxProxy );
		
		// Initialize Stock photo
		lightBoxProxy.initLightBox();
		// Start Data load
		externalDataProxy.getConfigData(kielRoot.stage);
		// Fire first stage resize event
		kielRoot.stage.dispatchEvent( new Event(Event.RESIZE, true) );
	}
}
}