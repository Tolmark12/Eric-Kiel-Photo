package app.view.components.events
{
import flash.events.Event;

public class NavEvent extends Event
{
	// PORTFOLIO
	// Bottom buttons
	public static const PORTFOLIO_NEXT:String = "portfolio_next";
	public static const PORTFOLIO_PREV:String = "portfolio_prev";
	public static const PORTFOLIO_START:String = "portfolio_start";
	public static const PORTFOLIO_END:String = "portfolio_end";
	// Images click
	public static const PORTFOLIO_ITEM_CLICK:String = "portfolio_item_click";
	// Index of the portfolio item clicked
	public var portfolioItemIndex:uint;

	public static const NAV_BTN_CLICK:String = "nav_btn_click";
	public var id:String;
	
	public function NavEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
	{
		super(type, bubbles, cancelable);
	}
   
}
}