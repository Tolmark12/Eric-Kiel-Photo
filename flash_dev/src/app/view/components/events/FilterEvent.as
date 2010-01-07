package app.view.components.events
{
import flash.events.Event;

public class FilterEvent extends Event
{
	public static const NEW_FILTER:String 					= "new_filter";
	public static const ADD_TAG_TO_CURRENT_FILTER:String 	= "add_tag_to_filter";
	
	public var tags:Array;
	
	public function FilterEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
	{
		super(type, bubbles, cancelable);
	}
   
	public override function toString():String
	{
		return super.toString();
		//return FilterEvent;
	}

}
}