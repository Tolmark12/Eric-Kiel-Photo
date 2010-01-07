package app.model
{
import org.puremvc.as3.multicore.interfaces.IProxy;
import org.puremvc.as3.multicore.patterns.proxy.Proxy;
import app.model.vo.*;
import app.AppFacade;

public class StockProxy extends Proxy implements IProxy
{
	public static const NAME:String = "stock_proxy";
	
	// Configuration
	private var _configVo:StockConfigVo;
	// Current tags
	private var _tags:Array; /// Maybe move this into StockPhotoSetVo
	// Current Stack
	private var _set:StockPhotoSetVo;
	
	// Constructor
	public function StockProxy( ):void { super( NAME ); };
	
	// _____________________________ API
	
	/** 
	*	Parse the configuration data defining the basic stock photos categories
	*/
	public function parseConfigData ( $json:Object ):void
	{
		_configVo = new StockConfigVo( $json );
		sendNotification( AppFacade.STOCK_INIT, _configVo );
	}
	
	/** 
	*	Request the data for the photos matching a set of tags
	*	@param		List of tags
	*/
	public function loadNewPhotoSet ( $set:Array ):void
	{
		// If this new set of tags don't match the current set
		// (this will fail, even with the same tags in different order)
		if( !_isEqual($set, _tags) ){
			_copyTags( $set );
			sendNotification( AppFacade.LOAD_STOCK_DATA_SET, _tags.join(",") );
		}else
			trace( "StockProxy.loadNewPhotoSet() - Arrays are equal" );
	}
	
	/** 
	*	Parse a new stock photo data set
	*/
	public function parseNewStockDataSet ( $json:Object ):void
	{
		// !! TEMP !!!!!!!!!!!! - Until we have a working db model, we will be 
		_set = new StockPhotoSetVo({});
		
		// generating the set manually...
		for ( var i:uint=0; i<40; i++ ) 
		{
			var wid:Number = (Math.random() >0.5)? 200 : 75 ;
			var tempObj:Object = {
				id			: "id_" + i,
				name		: "name" + i,
				low_res_src	: "",
				high_res	: "",
				tags		: ["man","hat","landscape"],
				width		: wid
			}
			var stockPhotoVo:StockPhotoVo = new StockPhotoVo( tempObj );
			_set.stack.push( stockPhotoVo );
		}
		// !! TEMP !!!!!!!!!!!!
		
		sendNotification( AppFacade.BUILD_STOCK_RESULTS, _set );
	}
	
	
	// _____________________________ Helpers
	
	// Test to see if two arrays are equivalent
	private function _isEqual ( $ar1:Array, $ar2:Array  ):Boolean {
		if( $ar1 == null || $ar2 == null )
			return false;
		else if( $ar1.join("") == $ar2.join("") )
			return true;
		else
			return false;
	}
	
	// Copy all the tags from new set into _tags array
	private function _copyTags ( $newTags:Array ):void {
		_tags = new Array();
		var len:uint = $newTags.length;
		for ( var i:uint=0; i<len; i++ ) {
			_tags[i] = $newTags[i];
		}
	}
	

}
}