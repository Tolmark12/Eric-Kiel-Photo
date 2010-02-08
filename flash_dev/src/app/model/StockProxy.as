package app.model
{
import org.puremvc.as3.multicore.interfaces.IProxy;
import org.puremvc.as3.multicore.patterns.proxy.Proxy;
import app.model.vo.*;
import app.AppFacade;
import delorum.utils.echo;

public class StockProxy extends Proxy implements IProxy
{
	public static const NAME:String = "stock_proxy";
	
	// Configuration
	private var _configVo:StockConfigVo;
	// Current tags
	private var _tags:Array; /// Maybe move this into StockPhotoSetVo
	// Current Stack
	private var _sets:Vector.<StockPhotoSetVo>;
	// Set of photos that match all given tags
	private var _matches:StockPhotoSetVo;
	//private var _set:StockPhotoSetVo;
	private var _currentPhotoId:String;
	
	// Constructor
	public function StockProxy( ):void { 
		super( NAME );
		reset();
	};
	
	/** 
	*	TODO:
	*	
	*	This will need to be set up with the following APIs
	*	
	*	deleteSetById( $setId );													// Remove the subset from the matches
	*	addSet( $set );					(currently parseNewStockDataSet() )			// Add the set to the matches
	*	extractMatchesInAllSets();													// Find all the photoVo items that match all the tags
	*/
	
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
	public function loadNewPhotoSet ( $newTerm:String ):void
	{
		// Flix, we may need to do some validation here to make sure we're not searching for a tag that already has been searched for.
		sendNotification( AppFacade.LOAD_STOCK_DATA_SET, $newTerm );
	}
	
	/** 
	*	Parse a new stock photo data set
	*/
	public function parseNewStockDataSet ( $json:Object ):void
	{   		
		var newSet:StockPhotoSetVo 	= new StockPhotoSetVo({});
		newSet.setName				= $json.term;
		
		// generating the set manually...
		for ( var i:uint=0; i<20; i++ ) 
		{
			var wid:Number = (Math.random() >0.5)? 222 : 99 ;
			var tempObj:Object = {
				id			: "id_" + i + "_"+newSet.setName,
				name		: "name" + i,
				low_res_src	: "",
				high_res	: "",
				tags		: ["man","hat","landscape"],
				width		: wid
			}
			var stockPhotoVo:StockPhotoVo = new StockPhotoVo( tempObj );
			newSet.stack.push( stockPhotoVo );
		}
		
		_sets.push(newSet);
		_findAndAddNewMatches( newSet );
		
		// !! TEMP !!!!!!!!!!!!
		_matches.setName = _sets.join(" + ");
		
		var stockResults = _sets.concat();
		if( stockResults.length > 1 )
			stockResults.unshift(_matches);
			
		sendNotification( AppFacade.BUILD_STOCK_RESULTS, stockResults );
	}
	
	/** 
	*	Activate the specified stock photo
	*/
	public function activateStockPhotoById ( $id:String ):void
	{
		// Make sure the id isn't alread active and make sure
		// that the _set isn't undefined
		if( $id != _currentPhotoId && _sets != null){
			
			// Make sure this new photo does exist in this set
			var stockPhotoVo:StockPhotoVo = _getStockPhotoById( $id );
			if( stockPhotoVo != null ) {
				_currentPhotoId = $id;
				sendNotification( AppFacade.DISPLAY_STOCK_PHOTO, stockPhotoVo );
			}else{
				_throwError( "This Stock photo id does not match any in the list" );
			}
		}
			
	}
	
	public function removeStockCategory ( $category:String ):void
	{
		sendNotification( AppFacade.STOCK_CATEGORY_REMOVED, _removeSetById($category) );
		sendNotification( AppFacade.BUILD_STOCK_RESULTS, _sets );
	}
	
	public function reset (  ):void
	{
		_configVo 			= null;
		_tags				= null;
		_sets 				= new Vector.<StockPhotoSetVo>();
		_matches			= new StockPhotoSetVo({})
		_currentPhotoId		= null;
	}
	
	// _____________________________ Helpers
	
	private function _findAndAddNewMatches ( $set:StockPhotoSetVo ):void {
		var totalSets:uint = _matches.stack.length;
		if( totalSets == 0 ) {
			
		}else if( totalSets == 1 ) {
			
		}else{
			
		}
	}
	
	private function _removeSearchTermFromMatches ( $set:StockPhotoSetVo ):void {
		
	}
	
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
	
	private function _throwError ( $error:String ):void{
		trace( $error );
		echo( $error );
	}
	
	// Loop through each set and find/return the StockPhotoVo with the matching id
	private function _getStockPhotoById ( $id:String ):StockPhotoVo {
		var len:uint = _sets.length;
		var set:StockPhotoSetVo;
		for ( var i:uint=0; i<len; i++ ) 
		{
			set = _sets[i];
			var returnPhoto:StockPhotoVo = set.getStockPhotoById($id);
			if( returnPhoto != null )
				return returnPhoto;
		}
		return null;
	}
	
	// Loop throught he sets and delete the one that matches the id
	private function _removeSetById ( $tagName ):uint {
		var len:uint = _sets.length;
		var set:StockPhotoSetVo;
		for ( var i:uint=0; i<len; i++ ) 
		{
			set = _sets[i];
			if( set.setName == $tagName ){
				_sets.splice(i,1);
				return i;
			}
		}
		return null;
	}
}
}