package app.view.components.events
{
import flash.events.Event;

public class LightboxEvent extends Event
{
	public static const EMAIL_LIGHTBOX:String = "email_lightbox";
	public static const OPEN_OR_CLOSE:String = "open_or_close";
	
	public function LightboxEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
	{
		super(type, bubbles, cancelable);
	}
	
	public override function toString():String
	{
		return super.toString();
		//return LightboxEvent;
	}

}
}