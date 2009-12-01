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
		_portfolio.init();
		_portfolio.addEventListener( NavEvent.PORTFOLIO_ITEM_CLICK, _onPortfolioItemClick, false,0,true );
		_portfolio.addEventListener( ImageLoadEvent.HIGH_RES_IMAGE_LOADED, _onHighResImageLoaded, false,0,true );
		_portfolio.addEventListener( ImageLoadEvent.LOW_RES_IMAGE_LOADED, _onLowResImageLoaded, false,0,true );
		_portfolio.addEventListener( NavEvent.PORTFOLIO_NEXT, _onPortfolioNext, false,0,true );
		_portfolio.addEventListener( NavEvent.PORTFOLIO_PREV, _onPortfolioPrev, false,0,true );
		_portfolio.addEventListener( NavEvent.PORTFOLIO_START, _onPortfolioStart, false,0,true );
		_portfolio.addEventListener( NavEvent.PORTFOLIO_END, _onPortfolioEnd, false,0,true );
		
		$stage.addChild( _portfolio );
   	}
	
	// PureMVC: List notifications
	override public function listNotificationInterests():Array
	{
		return [ AppFacade.PORTFOLIO_DATA_PARSED, 
		 		 AppFacade.ACTIVATE_PORTFOLIO_ITEM,
		 		 AppFacade.STAGE_RESIZE,
				 AppFacade.APPLY_PORTFOLIO_FILTERS,
				 AppFacade.DEACTIVATE_ACTIVE_PORTFOLIO_ITEM,
				 AppFacade.ACTIVE_ITEM_CLICKED_AGAIN,
				 AppFacade.UPDATE_TOTAL_LOADED,
				 AppFacade.REMOVE_CURRENT_PAGE ];
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
			case AppFacade.STAGE_RESIZE :
				_portfolio.onStageResize( note.getBody() as StageResizeVo )
			break;
			case AppFacade.APPLY_PORTFOLIO_FILTERS :
				_portfolio.filterImages( note.getBody() as Array );
			break;
			case AppFacade.DEACTIVATE_ACTIVE_PORTFOLIO_ITEM :
				_portfolio.deactivateCurrentItem( note.getBody() as DeactivateVo );
			break;
			case AppFacade.ACTIVE_ITEM_CLICKED_AGAIN :
				_portfolio.activeItemClickedAgain();
			break;
			case AppFacade.UPDATE_TOTAL_LOADED :
				var tempObj:Object = note.getBody() as Object;
				_portfolio.updateTotalImagesLoaded( tempObj.loaded, tempObj.total)
				//if( tempObj.loaded  == tempObj.total ){
				//	_portfolio.clear()
				//	_portfolio = null;
				//}
			break;
			case AppFacade.REMOVE_CURRENT_PAGE :
				//_portfolio.reset();
			break;
		}
	}
	
	// _____________________________ Events
	
	private function _onPortfolioItemClick ( e:NavEvent ):void{
		sendNotification( AppFacade.PORTFOLIO_ITEM_CLICK, e.portfolioItemIndex );
	}
	
	private function _onPortfolioNext ( e:Event ):void {
		sendNotification( AppFacade.PORTFOLIO_NEXT );
	}
	
	private function _onPortfolioPrev ( e:Event ):void {
		sendNotification( AppFacade.PORTFOLIO_PREV );
	}
	
	private function _onPortfolioStart ( e:Event ):void {
		sendNotification( AppFacade.PORTFOLIO_START );
	}
	
	private function _onPortfolioEnd ( e:Event ):void {
		sendNotification( AppFacade.PORTFOLIO_END );
	}
	
	private function _onHighResImageLoaded ( e:ImageLoadEvent ):void {
		sendNotification( AppFacade.IMAGE_LOADED_LOW, e.imageIndex );
	}
	
	private function _onLowResImageLoaded ( e:ImageLoadEvent ):void {
		sendNotification( AppFacade.IMAGE_LOADED, e.imageIndex );
	}
	
}
}