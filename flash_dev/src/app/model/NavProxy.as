package app.model
{
import org.puremvc.as3.multicore.interfaces.IProxy;
import org.puremvc.as3.multicore.patterns.proxy.Proxy;
import app.model.vo.*;
import app.AppFacade;

public class NavProxy extends Proxy implements IProxy
{
	public static const NAME:String = "nav_proxy";
	
	private var _navVo:NavVo;
	private var _currentPageId:String;

	// Constructor
	public function NavProxy( ):void { super( NAME ); };
	
	public function config ( $vo:ConfigVo ):void {
		sendNotification( AppFacade.LOAD_NAV_DATA );
	}
	
	public function parseNavData ( $json:Object ):void{
		_navVo = new NavVo( $json );
		sendNotification( AppFacade.NAV_DATA_PARSED, _navVo );
		sendNotification( AppFacade.REFRESH_ALIGN );
		changePage( _navVo.defaultNavItem.id );
		
	}
	
	public function changePage ( $newId:String ):void
	{
		// Make sure this page isn't already active
		if( _currentPageId != $newId ){
			
			// Change the page content
			sendNotification( AppFacade.LOAD_PAGE_DATA, _navVo.getNavItemById( $newId ) );
			var pathVo = new PathVo( _currentPageId, $newId );
			_currentPageId = $newId;
			
			//// Show / Hid the sub nav
			//if( currentNavItem.subNav != null && _currentSubNavId != _currentPageId ) {
			//	_currentSubNavId = _currentPageId;
			//	sendNotification( AppFacade.CREATE_SUB_NAV, currentNavItem );
			//} else if (currentNavItem.parentNavItemId != null  && _currentSubNavId != currentNavItem.parentNavItemId ) {
			//	_currentSubNavId = currentNavItem.parentNavItemId;
			//	sendNotification( AppFacade.CREATE_SUB_NAV, _navVo.getNavItemById(_currentSubNavId) );
			//} else if (currentNavItem.parentNavItemId == null && currentNavItem.subNav == null && _currentSubNavId != null){
			//	_currentSubNavId = null
			//	sendNotification( AppFacade.REMOVE_SUB_NAV );
			//}
			
			// Update the path. This affects which nav items are selected
			// and the SWFAddress path
			sendNotification( AppFacade.UPDATE_PATH, pathVo );			
			sendNotification( AppFacade.REFRESH_ALIGN );
		}
		
	}
	
}
}