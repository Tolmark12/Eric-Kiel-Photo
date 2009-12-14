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
	public static const CONFIG_LOADED_AND_PARSED:String 			= "config_loaded_and_parsed";
	public static const LOAD_NAV_DATA:String 						= "load_nav_data";
	public static const NAV_DATA_LOADED:String 						= "nav_data_loaded";
	public static const NAV_DATA_PARSED:String 						= "nav_data_parsed";
	public static const NAV_INITIALIZED:String 						= "nav_initialized";
	public static const LOAD_PAGE_DATA:String 						= "load_page_data";
	public static const PORTFOLIO_DATA_LOADED:String 				= "portfolio_data_loaded";
	public static const PORTFOLIO_DATA_PARSED:String 				= "portfolio_data_parsed";
	public static const STOCK_CONFIG_LOADED:String 					= "stock_config_loaded";
	                                                        		
	// Browser                                              		
	public static const UPDATE_PATH:String 							= "update_path";
	                                                        		
	// User initiated                                       		
	public static const STAGE_RESIZE:String 						= "stage_resize";
	public static const NAV_BTN_CLICK:String 						= "nav_btn_click";
	public static const PORTFOLIO_ITEM_CLICK:String 				= "portfolio_item_click";
	public static const PORTFOLIO_NEXT:String 						= "portfolio_next";
	public static const PORTFOLIO_PREV:String 						= "portfolio_prev";
	public static const PORTFOLIO_START:String 						= "portfolio_start";
	public static const PORTFOLIO_END:String   						= "portfolio_end";
	public static const ADD_FILTER:String      						= "add_filter";
	public static const REMOVE_FILTER:String   						= "remove_filter";
	                                                        		
	// Misc                                                 		
	public static const REFRESH_ALIGN:String 						= "refresh_align";
    public static const IMAGE_LOADED:String 						= "image_loaded";
	public static const IMAGE_LOADED_LOW:String 					= "image_loaded_low";
	
	// State Changes        
	public static const REMOVE_CURRENT_PAGE:String 					= "remove_current_page";                                		
	public static const ACTIVATE_PORTFOLIO_ITEM:String 				= "activate_portfolio_item";
	public static const APPLY_PORTFOLIO_FILTERS:String 				= "apply_portfolio_filters";
	public static const ACTIVE_PORTFOLIO_TAGS:String 				= "active_portfolio_tags";  		// An array of the portfolio tags that are active
	public static const DEACTIVATE_ACTIVE_PORTFOLIO_ITEM:String 	= "deactivate_active_portfolio_item";
	public static const ACTIVE_ITEM_CLICKED_AGAIN:String 			= "active_item_clicked_again";
	public static const UPDATE_TOTAL_LOADED:String 					= "update_total_loaded";
	public static const MEDIATOR_ACTIVATED:String 					= "mediator_activated";
	
	// Forms
	
	// Stock Photos
	public static const STOCK_INIT:String 							= "stock_init";
	
	// Lightbox
	public static const SHOW_LIGHT_BOX:String 						= "show_light_box";		// An array of images, or stock photo items?
	
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
		registerCommand( STOCK_CONFIG_LOADED, DataRequests );
		registerCommand( NAV_BTN_CLICK, Clicks );
		registerCommand( PORTFOLIO_ITEM_CLICK, Clicks );
		registerCommand( PORTFOLIO_NEXT, Clicks );
		registerCommand( PORTFOLIO_PREV, Clicks );
		registerCommand( PORTFOLIO_START, Clicks );
		registerCommand( PORTFOLIO_END, Clicks );
		registerCommand( ADD_FILTER, Clicks );
		registerCommand( REMOVE_FILTER, Clicks );
		registerCommand( IMAGE_LOADED, DataRequests );
		registerCommand( IMAGE_LOADED_LOW, DataRequests );
		registerCommand( NAV_INITIALIZED, DataRequests );
	}

}
}