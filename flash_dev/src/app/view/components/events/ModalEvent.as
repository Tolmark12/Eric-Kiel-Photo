package app.view.components.events
{
import flash.events.Event;
import flash.net.URLVariables;

public class ModalEvent extends Event
{
	public static const DOWNLOAD_COMP:String = "download_comp";
	public static const ASK_A_QUESTION:String = "ask_a_question";
	public static const INPUT_CHANGE:String = "input_change";
	
	// EVENTS
	public static const CLOSE_MODAL:String = "close_modal";
	public static const SUBMIT_FORM:String = "submit_form";
	
	public var urlVars:URLVariables;

	public function ModalEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
	{
		super(type, bubbles, cancelable);
	}
	
}
}