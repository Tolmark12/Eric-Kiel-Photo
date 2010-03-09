package app.view.components.events
{
import flash.events.Event;

public class StockTagEvent extends Event
{
	public static const ADD_NEW_TAG:String = "add_new_tag";
	public static const NEW_TAG_SEARCH:String = "new_tag_search";					// maybe not needed
	public static const ADD_LETTER_TO_SEARCH:String = "add_letter_to_search";		// maybe not needed
	public static const SEARCH_TERM_CHANGE:String = "search_term_change";
	public static const SUBMIT_SEARCH_TERM:String = "submit_term";
	
	public var newLetter:String;
	public var searchTerm:String;

	public function StockTagEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
	{
		super(type, bubbles, cancelable);
	}
	
	public override function toString():String
	{
		return super.toString();
		//return StockTagEvent;
	}

}
}