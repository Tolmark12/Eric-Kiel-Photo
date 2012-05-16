package app.model
{
import flash.net.*;
import org.puremvc.as3.multicore.interfaces.IProxy;
import org.puremvc.as3.multicore.patterns.proxy.Proxy;
import app.model.vo.*;
import app.AppFacade;
import flash.external.ExternalInterface;
import Kiel09;
import delorum.utils.echo;

public class NavProxy extends Proxy implements IProxy
{
	public static const NAME:String = "nav_proxy";
	
	private var _navVo:NavVo;
	private var _currentPageId:String;
	private var _defaultPageFromRoot:String;
	
	// Constructor
	public function NavProxy( $root:Kiel09 ):void { 
		super( NAME );
		_defaultPageFromRoot = $root.defaultPage;
	};
	
	public function config ( $vo:ConfigVo ):void {
		sendNotification( AppFacade.LOAD_NAV_DATA );
	}
	
	public function parseNavData ( $json:Object ):void{
		_navVo = new NavVo( $json );
		sendNotification( AppFacade.NAV_DATA_PARSED, _navVo );
		sendNotification( AppFacade.REFRESH_ALIGN );
		sendNotification( AppFacade.NAV_INITIALIZED );
	}
	
	public function showDefaultPage (  ):void {
		
		// If there is a sub page defined, that trumps all - http://kielphoto.com/#/some/page
		if( _defaultPageFromRoot != "there is sub page" ){
			
			// We should redirect based on the url : http://kielphotofilms.com	
			if( _defaultPageFromRoot.length != 0 )
				changePage( _defaultPageFromRoot );
				
			// else there is no redirect from main url, goto default page : 
			else

				// IMPORTANT
				// To change default page to the value that is passed in via json, 
				// uncomment the line below

				//changePage( _navVo.defaultNavItem.id )
				changePage( "/stock" )
		}
		
	}
	
	public function changePage ( $newId:String ):String
	{
		// If they've clicked on the logo, call the default page:
		if( $newId == "/" ) {
			showDefaultPage();
			return null;
		}
		
		// Make sure this page isn't already active
		if( _currentPageId != $newId ){
			var vo:NavItemVo = _navVo.getNavItemById( $newId );
			
			// If this is an external url, go there
			if( vo.pageType == "external" ){
				navigateToURL( new URLRequest(vo.id), "_self" );
				return null;
			}
			
			// Unload the current view
			sendNotification( AppFacade.REMOVE_CURRENT_PAGE );
			
			// Change the page content
			
			sendNotification( AppFacade.LOAD_PAGE_DATA, vo );
			var pathVo = new PathVo( _currentPageId, $newId );
			_currentPageId = $newId;
			_sendToAnalytics(_currentPageId);
			
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
		return null;
	}
	
	/** 
	*	Allow navigation on an existing page (used for analytics)
	*/
	public function navigationOnCurrentPage ( $nav:String ):void
	{
		_sendToAnalytics(_currentPageId + "/" + $nav )
	}
	
	private function _sendToAnalytics ( $url:String ):void
	{
		ExternalInterface.call( "track", $url );
	}
	
}
}