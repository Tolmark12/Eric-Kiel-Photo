package app.view.components.events
{
import flash.events.Event;
import flash.net.URLVariables;
import app.model.vo.StockPhotoVo;

public class ModalEvent extends Event
{
	public static const DOWNLOAD_COMP:String = "download";
	public static const ASK_A_QUESTION:String = "ask";
	public static const LICENCE_IMAGE:String = "licence";
	public static const INPUT_CHANGE:String = "input_change";
	public static const SHOW_TERMS:String = "show_terms";
	
	// EVENTS
	public static const CLOSE_MODAL:String = "close_modal";
	public static const SUBMIT_FORM:String = "submit_form";
	
	public var urlVars:URLVariables;
	public var formId:String;
	public var stockVoId:String;
	public var vo:StockPhotoVo;

	public function ModalEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
	{
		super(type, bubbles, cancelable);
	}
	
}
}