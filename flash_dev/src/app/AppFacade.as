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

	
	// DATA REQUESTS AND COMPLETIONS::
		// ...General / Nav
	public static const CONFIG_LOADED_AND_PARSED:String 			= "config_loaded_and_parsed";
	public static const LOAD_NAV_DATA:String 						= "load_nav_data";
	public static const NAV_DATA_LOADED:String 						= "nav_data_loaded";
	public static const NAV_DATA_PARSED:String 						= "nav_data_parsed";
	public static const NAV_INITIALIZED:String 						= "nav_initialized";
	public static const LOAD_PAGE_DATA:String 						= "load_page_data";
		// ...Portfolio
	public static const PORTFOLIO_DATA_LOADED:String 				= "portfolio_data_loaded";
	public static const PORTFOLIO_DATA_PARSED:String 				= "portfolio_data_parsed";
		// ...Stock...
	public static const STOCK_CONFIG_LOADED:String 					= "stock_config_loaded";
	public static const LOAD_STOCK_DATA_SET:String 					= "load_stock_data_set";
	public static const STOCK_DATA_SET_LOADED:String 				= "stock_data_set_loaded";
	
	// BROWSER                                              		
	public static const UPDATE_PATH:String 							= "update_path";
	                                                        		
	// USER INITIATED                                       		
	public static const STAGE_RESIZE:String 						= "stage_resize";
	public static const NAV_BTN_CLICK:String 						= "nav_btn_click";
	public static const PORTFOLIO_ITEM_CLICK:String 				= "portfolio_item_click";
	public static const PORTFOLIO_ITEM_SHOW_VIDEO:String 			= "portfolio_item_show_video";
	public static const PORTFOLIO_NEXT:String 						= "portfolio_next";
	public static const PORTFOLIO_PREV:String 						= "portfolio_prev";
	public static const PORTFOLIO_START:String 						= "portfolio_start";
	public static const PORTFOLIO_END:String   						= "portfolio_end";
	public static const ADD_FILTER:String      						= "add_filter";
	public static const REMOVE_FILTER:String   						= "remove_filter";
	                                                        		
	// MISC                                                 		
	public static const REFRESH_ALIGN:String 						= "refresh_align";
    public static const IMAGE_LOADED:String 						= "image_loaded";
	public static const IMAGE_LOADED_LOW:String 					= "image_loaded_low";
	
	// STATE CHANGES        
	public static const REMOVE_CURRENT_PAGE:String 					= "remove_current_page";                                		
	public static const ACTIVATE_PORTFOLIO_ITEM:String 				= "activate_portfolio_item";
	public static const APPLY_PORTFOLIO_FILTERS:String 				= "apply_portfolio_filters";
	public static const ACTIVE_PORTFOLIO_TAGS:String 				= "active_portfolio_tags";  		// An array of the portfolio tags that are active
	public static const DEACTIVATE_ACTIVE_PORTFOLIO_ITEM:String 	= "deactivate_active_portfolio_item";
	public static const ACTIVE_ITEM_CLICKED_AGAIN:String 			= "active_item_clicked_again";
	public static const UPDATE_TOTAL_LOADED:String 					= "update_total_loaded";
	public static const MEDIATOR_ACTIVATED:String 					= "mediator_activated";
	
	// FORMS
	public static const SHOW_MODAL_CLICK:String 					= "show_modal_click";
	public static const CREATE_NEW_MODAL:String 					= "create_new_modal";
	public static const CLOSE_MODAL:String 							= "close_modal";
	public static const SUBMIT_FORM:String 							= "submit_form";
	
	// STOCK PHOTOS
	public static const STOCK_INIT:String 							= "stock_init";
	public static const STOCK_RESET:String 							= "stock_reset";
	public static const ADD_TAG_TO_FILTER_CLK:String 				= "add_tag_to_filter_clk";
	public static const BUILD_STOCK_RESULTS:String 					= "build_stock_results";
	public static const STOCK_PHOTO_CLICKED:String 					= "stock_photo_clicked";
	public static const DISPLAY_STOCK_PHOTO:String 					= "display_stock_photo";
	public static const STOCK_PHOTO_CLOSE:String 					= "stock_photo_close";
	public static const STOCK_SCROLL:String 						= "stock_scroll";
	public static const STOCK_REMOVE_CATEGORY:String 				= "stock_remove_category";
	public static const STOCK_CATEGORY_REMOVED:String 				= "stock_category_removed";
	public static const ACTIVATE_MODAL:String 						= "activate_modal";
	public static const ADD_TO_LIGHTBOX:String 						= "add_to_lightbox";
	public static const HIDE_SEARCH_OPTIONS:String 					= "hide_search_options";
	public static const SHOW_SEARCH_OPTIONS:String 					= "show_search_options";
	
	// Tags
	public static const STOCK_TAGS_LOADED:String 					= "stock_tags_loaded";
	public static const NEW_TAG_SEARCH:String					 	= "new_tag_search";
	public static const ADD_LETTER_TO_SEARCH:String 				= "add_letter_to_search";
	public static const DISPLAY_TAG_HINTS:String 					= "display_tag_hints";
	public static const SEARCH_TERM_CHANGE:String 					= "search_term_change";
	public static const SUBMIT_SEARCH_TERM:String 					= "submit_search_term";
	
	// LIGHTBOX
	public static const LOAD_LIGHTBOX_ITEMS:String 					= "load_lightbox_items";
	public static const LIGHTBOX_ITEMS_LOADED:String 				= "lightbox_items_loaded";
	public static const SHOW_LIGHTBOX:String 						= "show_lightbox";
	public static const HIDE_LIGHTBOX:String 						= "hide_lightbox";
	public static const UPDATE_LIGHTBOX_TOTAL:String 				= "update_lightbox_total";
	public static const POPULATE_LIGHTBOX:String 					= "populate_lighbox";
	public static const LIGHTBOX_PHOTO_CLICKED:String 				= "lightbox_photo_clicked";
	
	// VIDEO
	public static const LOAD_VIDEO:String 							= "load_video";
	
	// MESSAGES
	public static const SHOW_MESSAGE:String 						= "show_message";
	
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
		registerCommand( ADD_TAG_TO_FILTER_CLK, Clicks );
		registerCommand( LOAD_STOCK_DATA_SET, DataRequests );
		registerCommand( STOCK_DATA_SET_LOADED, DataRequests );
		registerCommand( STOCK_PHOTO_CLICKED, Clicks );
		registerCommand( STOCK_RESET, Clicks );
		registerCommand( NEW_TAG_SEARCH, Clicks );
		registerCommand( ADD_LETTER_TO_SEARCH, Clicks );
		registerCommand( SEARCH_TERM_CHANGE, Clicks );
		registerCommand( STOCK_REMOVE_CATEGORY, Clicks );
		registerCommand( STOCK_TAGS_LOADED, DataRequests );
		registerCommand( SUBMIT_SEARCH_TERM, Clicks );
		registerCommand( SHOW_MODAL_CLICK, Clicks );
		registerCommand( STOCK_PHOTO_CLOSE, Clicks );
		registerCommand( SUBMIT_FORM, Clicks );
		registerCommand( ADD_TO_LIGHTBOX, Clicks );
		registerCommand( PORTFOLIO_ITEM_SHOW_VIDEO, Clicks );
		registerCommand( LOAD_VIDEO, DataRequests );
		registerCommand( LOAD_LIGHTBOX_ITEMS, DataRequests );
		registerCommand( LIGHTBOX_ITEMS_LOADED, DataRequests );
		registerCommand( LIGHTBOX_PHOTO_CLICKED, Clicks );
	}

}
}