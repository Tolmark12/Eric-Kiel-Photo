package app.view.components.events
{
import flash.events.Event;

public class ImageLoadEvent extends Event
{
	
	public static const LOW_RES_IMAGE_LOADED:String = "low_res_image_loaded";
	public static const HIGH_RES_IMAGE_LOADED:String = "high_res_image_loaded";
	public static const RECENTER_STRIP:String = "recenter_strip";
	
	public var imageIndex:uint;
	
	public function ImageLoadEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false){
		super(type, bubbles, cancelable);
	}
}
}