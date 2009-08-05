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

public class PortfolioMediator extends Mediator implements IMediator
{	
	public static const NAME:String = "portfolio_mediator";
	
	private var _portfolio:Portfolio = new Portfolio();
	
	public function PortfolioMediator( $stage:Sprite ):void
	{
		super( NAME );
		_portfolio.addEventListener( NavEvent.PORTFOLIO_ITEM_CLICK, _onPortfolioItemClick, false,0,true );
		$stage.addChild( _portfolio );
   	}
	
	// PureMVC: List notifications
	override public function listNotificationInterests():Array
	{
		return [ AppFacade.PORTFOLIO_DATA_PARSED, 
		 		 AppFacade.ACTIVATE_PORTFOLIO_ITEM ];
	}
	
	// PureMVC: Handle notifications
	override public function handleNotification( note:INotification ):void
	{
		switch ( note.getName() )
		{
			case AppFacade.PORTFOLIO_DATA_PARSED:
				_portfolio.showNewPortfolio( note.getBody() as PortfolioVo );
			break;
			case AppFacade.ACTIVATE_PORTFOLIO_ITEM :
				_portfolio.activateItem( note.getBody() as uint );
			break;
		}
	}
	
	// _____________________________ Events
	
	private function _onPortfolioItemClick ( e:NavEvent ):void
	{
		sendNotification( AppFacade.PORTFOLIO_ITEM_CLICK, e.portfolioItemIndex );
	}
	
}
}