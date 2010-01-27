package app.view.components
{

import flash.display.Sprite;
import app.model.vo.StockPhotoSetVo;
import app.model.vo.StockPhotoVo;
import delorum.utils.KeyTrigger;
import caurina.transitions.Tweener;
import app.model.vo.StageResizeVo;
import flash.geom.Rectangle;
public class StockPhotoStrip extends Sprite
{
	private var _dictionary:Object	= {};			// An object with reference to the photos by id
	private var _photoHolder:Sprite	= new Sprite();
	private var _photoMap:StockMap;
	private var _windowWidth:Number;
	private var _scrollWindow:Rectangle;
	
	private var _activePhoto:StockPhoto;
	
	// Map
	private var _stockMap:StockMap = new StockMap();
	
	
	public function StockPhotoStrip():void
	{
		this.addChild(_photoHolder);
		this.addChild( _stockMap );

		_stockMap.y  = 550;
		_photoHolder.y = 110;
		KeyTrigger.addKeyListener( _tempTween, "w", true );
	}
	
	private function _tempTween (  ):void
	{
		Tweener.addTween( _photoHolder, { x:Math.round(Math.random()*-_photoHolder.width), time:1.4, transition:"EaseInOutQuint"} );
	}
	
	// _____________________________ API
	
	/** 
	*	Builds out a display of all the photo items. If a photo item in the new set
	*	is identical to an existing item, the existing item is retained so we don't 
	*	have to load in the images again. 
	*	
	*	What I need to figure out:
	*	1 - I should probably output an object that the stock map can use to create a representation of the 
	*		images shown here
	*/
	public function buildNewSet ( $sets:Vector.<StockPhotoSetVo> ):void
	{
		_dictionary = _buildNewDictionary($sets);
		var rows:Array = [0,0];
		var pad:Number	= 20;
		
		// Loop through each set of photos
		for each( var photoSet:StockPhotoSetVo in $sets)
		{	
			////  Create the small bricks
			var len:uint = photoSet.stack.length;
			for ( var i:uint=0; i<len; i++ ) 
			{
				var photo:StockPhoto = _dictionary[ photoSet.stack[i].id ];
				_photoHolder.addChild( photo );
				photo.build( photoSet.stack[i].width );
				
				var smallestRowIndex = _getShortestRowIndex(rows);		// Find the shortest row
				photo.y = 220 * smallestRowIndex;						// Set the y position based on the position in the array
				photo.x = rows[smallestRowIndex] + pad;					// Set the x position based on value of item
								
				rows[smallestRowIndex] += pad + photo.width;			// update row width
			}
		}
		
		setScrollWindow(StageResizeVo.lastResize);
		_stockMap.buildNewSet($sets);
	}
	
	/** 
	*	Clean up / delete all images and shut it down
	*/
	public function clear (  ):void
	{
		_clearDictionaryPhotos();
		_stockMap.clear();
		//_photoMap.clear();
	}
	
	/** 
	*	Activate a certain Stock Photo
	*/
	public function displayPhoto ( $stockPhotoVo:StockPhotoVo ):void
	{
		if( _activePhoto != null )
			_activePhoto.unHighlight();
		
		_activePhoto = _dictionary[$stockPhotoVo.id];
		_activePhoto.highlight();
	}
	
	public function scroll ( $perc:Number ):void
	{
		_photoHolder.x = 0 - ( _scrollWindow.width * $perc );
	}
	
	public function setScrollWindow ( $resize:StageResizeVo ):void
	{
		//_scrollWindow = new Rectangle( 0,0, _photoHolder.width - StageResizeVo.lastResize.width ,0 );
		_scrollWindow = new Rectangle( 0,0, _photoHolder.width - StageResizeVo.MIN_WIDTH ,0 );
	}
	
	// _____________________________ Helpers
	
	
	// Delete all the photos that are no longer found in the new stack
	// Keep the ones that are in the new stack
	private function _buildNewDictionary ( $stack:Vector.<StockPhotoSetVo> ):Object
	{
		// Create new Dictionary
		var newDictionary:Object = new Object();

		for each( var photoSet:StockPhotoSetVo in $stack)
		{
			var len:uint = photoSet.stack.length;
			for ( var i:uint=0; i<len; i++ ) 
			{
				var photoVo:StockPhotoVo = photoSet.stack[i];
				var photo:StockPhoto;
				
				// If this alread exists, delete it from the current
				// dictionary and save reference in the new dictionary
				// everything in old dictionary will be deleted via _clearDictionaryPhotos()
				if( _dictionary[ photoVo.id ] != null ){
					photo = _dictionary[ photoVo.id ];
					delete  _dictionary[ photoVo.id ]; 
				// else, doesn't exist, create it
				} else {
					photo = new StockPhoto( photoVo );
				}
			
				// Add photo to the new dictionary
				newDictionary[ photo.id ] = photo;
			}
		}
		
		// Clear loaded jpgs and other data
		_clearDictionaryPhotos();
		return newDictionary;
	}
	
	private function _clearDictionaryPhotos (  ):void
	{
		// Clear remaining photos, and delete them
		for( var i:String in _dictionary )
		{
			var photo:StockPhoto = _dictionary[i];
			photo.clear();
			photo.parent.removeChild(photo);
			delete _dictionary[i];
		}
	}
	
	private function _getShortestRowIndex ( $ar:Array ):Number
	{
		var lowestNumIndex:int 	= $ar.length-1;			// Index of number
		var lowestNum:int 		= $ar[$ar.length-1];	// Lowest number so far
		var counter:int 		= lowestNumIndex;		// simple counter
		while (counter-- >= 0)
		{
			if( $ar[counter] < lowestNum ){				// Is this new # lower than previously lowest number...
				lowestNumIndex 	= counter;
				lowestNum		= $ar[counter]
			}
		}
		return lowestNumIndex;
	}
	
}

}