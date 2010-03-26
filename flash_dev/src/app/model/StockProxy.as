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
	// A special VO only containing photos that are matched match all given tags
	// this is compiled here, not parsed from json
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
	private var _lastSearchTerm:String;
	private var _doClearExistingSearch:Boolean;
	public function loadNewPhotoSet ( $newTerm:String, $doClearExistingSearch:Boolean ):void
	{
		_doClearExistingSearch = $doClearExistingSearch;
		_lastSearchTerm = $newTerm;
		// Flix, we may need to do some validation here to make sure we're not searching for a tag that already has been searched for.
		sendNotification( AppFacade.LOAD_STOCK_DATA_SET, $newTerm );
	}
	
	/** 
	*	Parse a new stock photo data set
	*/
	public function parseNewStockDataSet ( $json:Object ):void
	{   
		// If there are search results:
		if( $json.items.length != 0 ) {
			
			if( _doClearExistingSearch ) {
				_tags				= null;
				_sets 				= new Vector.<StockPhotoSetVo>();
				_matches			= new StockPhotoSetMatchesVo({})
				_currentPhotoId		= null;
			}
			
			var newSet:StockPhotoSetVo 	= new StockPhotoSetVo($json);
			_findAndAddNewMatches( newSet );
			_sets.unshift(newSet);
			_prepareAneSentResults();
		}
		//...else:
		else{
			sendNotification( AppFacade.SHOW_MESSAGE, new MessageVo("No photos matched your search for: "+_lastSearchTerm) );
		}
		
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
	
	/** 
	*	For activating a photo currently in the lightbox
	*/
	public function activateLightBoxPhotoById ( $id:String ):void
	{
		if( $id != _currentPhotoId){
			var lightBoxProxy:LightBoxProxy = facade.retrieveProxy( LightBoxProxy.NAME ) as LightBoxProxy;
			_currentPhotoId = $id;
			sendNotification( AppFacade.DISPLAY_STOCK_PHOTO, lightBoxProxy.lightBoxPhotoSet.getStockPhotoById($id) );
		}
	}
	
	/** 
	*	Deactivate any photo
	*/
	public function deactivateCurrentPhoto (  ):void {
		_currentPhotoId = null;
	}
	
	public function removeStockCategory ( $category:String ):void
	{
		sendNotification( AppFacade.STOCK_CATEGORY_REMOVED, _removeSetById($category) );
		_prepareAneSentResults();
	}
	
	public function reset (  ):void
	{
		_configVo 			= null;
		_tags				= null;
		_sets 				= new Vector.<StockPhotoSetVo>();
		_matches			= new StockPhotoSetMatchesVo({})
		_currentPhotoId		= null;
	}
	
	public function getPhotoVo ( $id:String ) : StockPhotoVo {
		return _getStockPhotoById( $id );
	}
	
	// _____________________________ Helpers
	
	private function _prepareAneSentResults (  ):void {
		_matches.setName = _sets.join(" + ");
		
		var stockResults = _sets.concat();
		if( stockResults.length > 1 )
			stockResults.unshift(_matches);
			
		sendNotification( AppFacade.BUILD_STOCK_RESULTS, stockResults );
	}
	
	private function _findAndAddNewMatches ( $set:StockPhotoSetVo ):void {
		var totalSets:uint = _sets.length;
		var oldSet:StockPhotoSetVo;
		var i:uint;
		var len:uint;
		
		// If there aren't any other sets currently stored, 
		// then the lone set is considered the match
		if( totalSets == 0 ) {	
			// Don't show a white matches set
			sendNotification( AppFacade.SHOW_SEARCH_OPTIONS );
		}
		
		// else If there is only one set currently in the matches stack, 
		// we only have to test the tags against one set
		else if( totalSets == 1 ) {
			// Do show a white matches set
			// Loop through the new set
			oldSet = _sets[0];
			len = $set.stack.length;
			for ( i=0; i<len; i++ ) 
			{
				// If this photo exists in both sets...
				if( oldSet.dictionary[ $set.stack[i].id ] != null ){
					//...hide it from both sets, and add to matches
					oldSet.dictionary[ $set.stack[i].id ].doShowInParentSet 	= false;
					$set.stack[i].doShowInParentSet 							= false;
					_matches.addStockPhotoToSet($set.stack[i])
				}
			}
			sendNotification( AppFacade.HIDE_SEARCH_OPTIONS );
		}
		
		// Else, there are multiple matches to test against
		else{
			// store the items to delete, we can't delete them 
			// right away because it throws off our "i" index
			var idsToDelete:Array = new Array();
			len = _matches.stack.length;
			for ( i=0; i<len; i++ ) 
			{
				// If this exists in the match set, set the display flag false. 
				if( $set.dictionary[ _matches.stack[i].id ] != null ){
					$set.getStockPhotoById(_matches.stack[i].id).doShowInParentSet = false;
				} 
				// else it doesn't exist, it no longer matches all the tags and...
				else {
					// ...activate this in each parent set since we're 
					// removing it from the match set
					for each( var stockSet:StockPhotoSetVo in _sets){
						stockSet.dictionary[_matches.stack[i].id].doShowInParentSet = true;
					}
					idsToDelete.push(_matches.stack[i].id);
				}
			}
			// Remove all items we're deleting:
			var totalToDelete:uint = idsToDelete.length;
			for ( var k:uint=0; k<totalToDelete; k++ ) {
				_matches.removeStockPhotoFromSet( idsToDelete[k] );
			}
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
		//trace( $error );
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
	
	public function get stockConfigVo (  ):StockConfigVo{ return _configVo; };

//	public static function toTitleCase( original:String ):String {
//	      var words:Array = original.split( " " );
//	      for (var i:int = 0; i < words.length; i++) {
//	        words[i] = toInitialCap( words[i] );
//	      }
//	      return ( words.join( " " ) );
//	    }
//	    public static function toInitialCap( original:String ):String {
//	      return original.charAt( 0 ).toUpperCase(  ) + original.substr( 1 ).toLowerCase(  );
//	    }
}
}