package app.view.components.events
{
import flash.events.Event;

public class NavEvent extends Event
{
	public static const PORTFOLIO_ITEM_CLICK:String = "portfolio_item_click";
	public var portfolioItemIndex:uint;

	public static const NAV_BTN_CLICK:String = "nav_btn_click";
	public var id:String;
	
	public function NavEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
	{
		super(type, bubbles, cancelable);
	}
   
}
}