package app.view.components.events
{
import flash.events.Event;

public class NavEvent extends Event
{
	// PORTFOLIO
	// Bottom buttons
	public static const PORTFOLIO_NEXT:String  = "portfolio_next";
	public static const PORTFOLIO_PREV:String  = "portfolio_prev";
	public static const PORTFOLIO_START:String = "portfolio_start";
	public static const PORTFOLIO_END:String   = "portfolio_end";
	// Images click
	public static const PORTFOLIO_ITEM_CLICK:String = "portfolio_item_click";
	// Images video btn
	public static const SHOW_VIDEO:String = "show_video";
	// Index of the portfolio item clicked
	public var portfolioItemIndex:uint;
	
	// NAVIGATION
	public static const NAV_BTN_CLICK:String = "nav_btn_click";
	public static const ADD_FILTER:String    = "add_filter";
	public static const REMOVE_FILTER:String = "remove_filter";
	public var tag:String;
	public var id:String;
	
	public function NavEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
	{
		super(type, bubbles, cancelable);
	}
   
}
}
