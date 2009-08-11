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

public class NavMediator extends Mediator implements IMediator
{	
	public static const NAME:String = "nav_mediator";
	
	private var _nav:Nav = new Nav();
	
	public function NavMediator( $stage:Sprite ):void
	{
		super( NAME );
		$stage.addChild( _nav );
		_nav.addEventListener( NavEvent.NAV_BTN_CLICK, _onNavBtnClick, false,0,true );
   	}
	
	// PureMVC: List notifications
	override public function listNotificationInterests():Array
	{
		return [ AppFacade.NAV_DATA_PARSED, 
		 		 AppFacade.UPDATE_PATH];
	}
	
	// PureMVC: Handle notifications
	override public function handleNotification( note:INotification ):void
	{
		switch ( note.getName() )
		{
			case AppFacade.NAV_DATA_PARSED:
				_nav.build( note.getBody() as NavVo );
			break;
			case AppFacade.UPDATE_PATH :
				var pathVo:PathVo = note.getBody() as PathVo;
				
				// Activate the main nav item
				if( pathVo.path[0].hasChanged )
					_nav.activateNavItem( pathVo.path[0].id );
				
				// Activate any sub nav items
				if( pathVo.path[1] != null){
					if( pathVo.path[1].hasChanged )
						_nav.activateSubNavItem( pathVo.path[1].id );
				}
								
			break;
		}
	}
	
	// _____________________________ Event Handlers
	
	private function _onNavBtnClick ( e:NavEvent ):void {
		sendNotification( AppFacade.NAV_BTN_CLICK, e.id );
	}
	
}
}