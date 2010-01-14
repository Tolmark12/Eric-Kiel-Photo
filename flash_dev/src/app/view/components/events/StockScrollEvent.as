package app.view.components.events
{
import flash.events.Event;

public class StockScrollEvent extends Event
{
	public static const SCROLL:String = "stkscroll";
	
	// Decimal percentage representing the position of the scroller
	public var pos:Number;
	
	public function StockScrollEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
	{
		super(type, bubbles, cancelable);
	}
	
	public override function toString():String
	{
		return super.toString();
		//return StockScrollEvent;
	}

}
}