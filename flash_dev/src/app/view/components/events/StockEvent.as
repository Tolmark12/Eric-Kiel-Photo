package app.view.components.events
{
import flash.events.Event;

public class StockEvent extends Event
{
	public static const STOCK_PHOTO_CLICK:String = "stock_photo_click";
	public static const STOCK_PHOTO_CLOSE:String = "stock_photo_click";
	public static const STOCK_PHOTO_OVER:String = "stock_photo_over";
	public static const STOCK_PHOTO_OUT:String = "stock_photo_out";
	public static const REMOVE_CATEGORY:String = "remove_category";
	public static const ADD_TO_LIGHTBOX:String = "add_to_lightbox";
	public static const REMOVE_FROM_LIGHTBOX:String = "remove_from_lightbox";
	public static const RETURN_TO_MAIN_CATEGORIES:String = "return_to_main_categories";
	
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