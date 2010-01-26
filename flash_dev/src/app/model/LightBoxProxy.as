package app.model
{
import org.puremvc.as3.multicore.interfaces.IProxy;
import org.puremvc.as3.multicore.patterns.proxy.Proxy;
import app.model.vo.*;
import app.AppFacade;
import flash.external.ExternalInterface;
import delorum.utils.echo;
import flash.net.SharedObject;
public class LightBoxProxy extends Proxy implements IProxy
{
	public static const NAME:String = "light_box_proxy";
	
	private var _sharedObject:SharedObject;
	private var _lightBoxStack:Array = new Array();
	public var doShowLightBox:Boolean = false;			// Set this true if the lightbox was passed in via URL
	
	// Constructor
	public function LightBoxProxy( ):void { 
		super( NAME );
		_sharedObject = SharedObject.getLocal("kiel-light-box");
	 };
	
	// _____________________________ API
	
	/** 
	*	Initialize the lightbox. This first checks to see if there is a lightbox passed
	*	in through the URL. It then checks to see if there is a lightbox saved locally 
	*/
	public function initLightBox (  ):void
	{
		var urlPath:String = ExternalInterface.call( "window.location.href.toString" );
		
		// If there is a lightbox stack included in the url, split that
		// and create the lightbox: EX - http://kiel.com/?/213/123/123/123/etc..
		if( urlPath != null )
		{
			// Split on the "?"
			var tempAr = urlPath.split("?");
			
			// If there are images in the second part of that string, create the array
			if( tempAr.length > 1 ) {
				echo( tempAr[0] + '  :  ' + tempAr[1] );
				_lightBoxStack = tempAr[1].split("/");
				_saveToLocalObject();
				doShowLightBox = true;
			}
		}	
			
		// else if there is a shared object with a stack, use that
		else if( _sharedObject.data.lightBox != null ){
			_lightBoxStack = _lightBoxStack.data.lightBox.split("/");
		}
	}
	
	/** 
	*	Adds an item to the lightbox stack
	*	@param		The id of the item to add
	*/
	public function addItemToLightBox ( $itemId:String ):void
	{
		_lightBoxStack.push($itemId);
		_saveToLocalObject();
	}
	
	/** 
	*	Return a URL that when clicked will open the site and the lightbox
	*/
	public function getLightBoxURL (  ):String
	{
		var externalDataProxy:ExternalDataProxy = facade.retrieveProxy( ExternalDataProxy.NAME ) as ExternalDataProxy;
		return externalDataProxy.server + "?" + _lightBoxStack.join( "/" );
	}
	
	public function showLightBox (  ):void
	{
		
	}
	
	// _____________________________ Helpers	
	
	// Save the contents of _lightBoxStack into a delimited sting in the shared object
	private function _saveToLocalObject (  ):void
	{
		_sharedObject.data.lightBox = _lightBoxStack.join("/");
	}
	
	

}
}