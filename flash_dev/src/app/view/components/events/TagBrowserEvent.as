package app.view.components.events
{
import flash.events.Event;

public class TagBrowserEvent extends Event
{
	public static const HINT_HIGHLIGHTED:String = "hint_highlighted";
	public static const HINT_SELECTED:String = "hint_selected";
	
	public var hint:String;
	
	public function TagBrowserEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
	{
		super(type, bubbles, cancelable);
	}
	

}
}