package app.model
{
import org.puremvc.as3.multicore.interfaces.IProxy;
import org.puremvc.as3.multicore.patterns.proxy.Proxy;
import app.model.vo.*;
import app.AppFacade;
import delorum.utils.echo;
import flash.net.SharedObject;
import flash.net.navigateToURL;
import flash.net.URLRequest;

public class LightBoxProxy extends Proxy implements IProxy
{
	public static const NAME:String = "light_box_proxy";
	
	private var _sharedObject:SharedObject;
	private var _lightBoxStack:Array = new Array();
	public var doShowLightBox:Boolean = false;			// Set this true if the lightbox was passed in via URL
	public var lightBoxPhotoSet:StockPhotoSetVo = new StockPhotoSetVo({});
	private var _urlLightBoxItems:Array;
	
	// Constructor
	public function LightBoxProxy( $urlLightBoxItems:Array ):void { 
		super( NAME );
		_urlLightBoxItems = $urlLightBoxItems;
		_sharedObject = SharedObject.getLocal("kiel-light-box");
		//emptyLightBox();
	 };
	
	// _____________________________ API
	
	/** 
	*	Initialize the lightbox. This first checks to see if there is a lightbox passed
	*	in through the URL. It then checks to see if there is a lightbox saved locally 
	*/
	public function initLightBox (  ):void
	{
		if( _urlLightBoxItems.length != 0 ){
			_lightBoxStack = _urlLightBoxItems;
		}
			
		
		// else if there is a shared object with a stack, use that !only! if there is no
		// lightbox in the url
		if( _sharedObject.data.lightBox != null && _lightBoxStack.length == 0 ){
			if( _sharedObject.data.lightBox.length > 1 )
				_lightBoxStack = _sharedObject.data.lightBox.split("/");
		}
		
		updateTotalItemsInLightbox();
		if( _lightBoxStack.length > 0 )
			sendNotification( AppFacade.LOAD_LIGHTBOX_ITEMS, _lightBoxStack.join(",") );
			
	}
	
	public function parseLightBoxJson ( $json:Object ):void {
		// Create an object with all the ids in the lightbox
		var tempObj:Object = {};
		var len:uint = _lightBoxStack.length;
		for ( var i:uint=0; i<len; i++ ) {
			tempObj[ _lightBoxStack[i] ] = "";
		}
		
		lightBoxPhotoSet = new StockPhotoSetVo($json, tempObj);
		sendNotification( AppFacade.POPULATE_LIGHTBOX, lightBoxPhotoSet );
		_broadcastLightbox();
	}
	
	/** 
	*	Adds an item to the lightbox stack
	*	@param		The id of the item to add
	*/
	public function addItemToLightBox ( $itemId:String ):String
	{		
		// If it's already in the lightbox, don't add it
		for each( var itemId:String in _lightBoxStack) {
			if( itemId == $itemId )
				return null;
		}
		_lightBoxStack.push($itemId);
		_saveToLocalObject();
		updateTotalItemsInLightbox();
		
		// Add this item to the photo set
		var stockProxy:StockProxy = facade.retrieveProxy( StockProxy.NAME ) as StockProxy;
		lightBoxPhotoSet.addStockPhotoToSet( stockProxy.getPhotoVo($itemId) );
		sendNotification( AppFacade.POPULATE_LIGHTBOX, lightBoxPhotoSet );
		_broadcastLightbox();
		return null;
	}
	
	/** 
	*	Remove item from the lightbox stack
	*/
	public function removeItemFromLightBox ( $itemId:String ):void{
		var len:uint = _lightBoxStack.length;
		for ( var i:uint=0; i<len; i++ ) {
			if( _lightBoxStack[i] == $itemId ){
				_lightBoxStack.splice(i,1);
			}
		}
		
		lightBoxPhotoSet.removeStockPhotoFromSet($itemId);
		_saveToLocalObject();
		updateTotalItemsInLightbox();
		sendNotification( AppFacade.POPULATE_LIGHTBOX, lightBoxPhotoSet );
		_broadcastLightbox()
	}
	
	/** 
	*	Show the lightbox
	*/
	public function showLightBox (  ):void
	{
		_broadcastLightbox();
	}
	
	/** 
	*	Return a URL that when clicked will open the site and the lightbox
	*/
	public function getLightBoxURL (  ):String
	{
		var externalDataProxy:ExternalDataProxy = facade.retrieveProxy( ExternalDataProxy.NAME ) as ExternalDataProxy;
		return externalDataProxy.server + "?" + _lightBoxStack.join( "/" );
	}
	
	public function updateTotalItemsInLightbox (  ):void
	{
		sendNotification( AppFacade.UPDATE_LIGHTBOX_TOTAL, _lightBoxStack.length );
	}
	
	/** 
	*	Removes all items from the lightbox
	*/
	public function emptyLightBox (  ):void
	{
		_lightBoxStack = new Array();
		_saveToLocalObject();
	}
	
	public function emailLightBox (  ):void
	{
		var emailLink = "mailto:?subject=Check out my Lightbox at Kielphoto.com&body=View the following lightbox I created at Kiel Photo.com: " + getLightBoxURL();
		navigateToURL(new URLRequest(emailLink), "_top");
	}
	
	// _____________________________ Helpers	
	
	// Save the contents of _lightBoxStack into a delimited sting in the shared object
	private function _saveToLocalObject (  ):void
	{
		_sharedObject.data.lightBox = _lightBoxStack.join("/");
	}
	
	private function _broadcastLightbox (  ):void {
		var sendAr:Array = new Array();
		var stockProxy:StockProxy = facade.retrieveProxy( StockProxy.NAME ) as StockProxy;
		for each( var itemId:String in _lightBoxStack) {
			sendAr.push( stockProxy.getPhotoVo(itemId) );
		}

		stockProxy.updateLightBoxItems(_lightBoxStack);
		sendNotification( AppFacade.SHOW_LIGHTBOX, sendAr );
	}
	
	
	

}
}