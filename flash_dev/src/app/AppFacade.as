package app
{
import org.puremvc.as3.multicore.interfaces.IFacade;
import org.puremvc.as3.multicore.patterns.facade.Facade;
import org.puremvc.as3.multicore.patterns.observer.Notification;
import flash.display.Sprite;
import app.control.*;

public class AppFacade extends Facade implements IFacade
{
	public static const STARTUP:String = "startup";

	// Data requests and completions
	public static const CONFIG_LOADED_AND_PARSED:String 	= "config_loaded_and_parsed";
	public static const LOAD_NAV_DATA:String 				= "load_nav_data";
	public static const NAV_DATA_LOADED:String 				= "nav_data_loaded";
	public static const NAV_DATA_PARSED:String 				= "nav_data_parsed";
	public static const LOAD_PAGE_DATA:String 				= "load_page_data";
	public static const PORTFOLIO_DATA_LOADED:String 		= "portfolio_data_loaded";
	public static const PORTFOLIO_DATA_PARSED:String 		= "portfolio_data_parsed";
	
	// Browser
	public static const UPDATE_PATH:String 					= "update_path";
	
	// User initiated
	public static const STAGE_RESIZE:String 				= "stage_resize";
	public static const NAV_BTN_CLICK:String 				= "nav_btn_click";
	public static const PORTFOLIO_ITEM_CLICK:String 		= "portfolio_item_click";
	
	// Misc
	public static const REFRESH_ALIGN:String 				= "refresh_align";

	// State Changes
	public static const ACTIVATE_PORTFOLIO_ITEM:String 		= "activate_portfolio_item";
	
	// Example: var myFacade:AppFacade = AppFacade.getInstance( 'app_facade' );
	public function AppFacade( key:String ):void
	{
		super(key);	
	}

	/** Singleton factory method */
	public static function getInstance( key:String ) : AppFacade 
    {
        if ( instanceMap[ key ] == null ) instanceMap[ key ]  = new AppFacade( key );
        return instanceMap[ key ] as AppFacade;
    }
	
	public function startup(app:Sprite):void
	{
	 	sendNotification( STARTUP, app ); 
	}

	/** Register Controller commands */
	override protected function initializeController( ) : void 
	{
		super.initializeController();
		registerCommand( STARTUP, Startup );
		registerCommand( CONFIG_LOADED_AND_PARSED, DataRequests );
		registerCommand( NAV_DATA_LOADED, DataRequests );
		registerCommand( LOAD_NAV_DATA, DataRequests );
		registerCommand( LOAD_PAGE_DATA, DataRequests );
		registerCommand( PORTFOLIO_DATA_LOADED, DataRequests );
		registerCommand( NAV_BTN_CLICK, Clicks );
		registerCommand( PORTFOLIO_ITEM_CLICK, Clicks );
	}

}
}