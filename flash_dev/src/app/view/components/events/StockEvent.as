package app.view.components.events
{
import flash.events.Event;

public class StockEvent extends Event
{
	public static const STOCK_PHOTO_CLICK:String = "stock_photo_click";
	public static const STOCK_PHOTO_OVER:String = "stock_photo_over";
	public static const STOCK_PHOTO_OUT:String = "stock_photo_out";
	
	public static const DOWNLOAD_COMP:String = "download_comp";
	public static const ASK_A_QUESTION:String = "ask_a_question";
	public static const REMOVE_CATEGORY:String = "remove_category";

	public var id:String;
	
	public function StockEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
	{
		super(type, bubbles, cancelable);
	}
	
	public override function toString():String
	{
		return super.toString();
		//return StockEvent;
	}

}
}