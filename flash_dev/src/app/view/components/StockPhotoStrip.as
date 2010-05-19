package app.view.components
{

import flash.display.Sprite;
import app.model.vo.StockPhotoSetVo;
import app.model.vo.StockPhotoVo;
import app.model.vo.StockTagVo;
import delorum.utils.KeyTrigger;
import caurina.transitions.Tweener;
import app.model.vo.StageResizeVo;
import flash.geom.Rectangle;
import app.model.vo.LightBoxDispayItemsVo;
import flash.events.*;
import app.view.components.events.StockEvent;

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
	
	// Back button
	private var _backBtn:SimpleTextButton = new SimpleTextButton_swc();
	
	public function StockPhotoStrip():void
	{
		this.visible = false;
		this.addChild(_photoHolder);
		this.addChild( _stockMap );
		this.addChild( _backBtn );
		
		_backBtn.y = 100;
		_backBtn.build();
		_stockMap.y  = 605;
		_photoHolder.y = 135;
		KeyTrigger.addKeyListener( _tempTween, "w", true );
		_backBtn.addEventListener( MouseEvent.CLICK, _onBackBtnClick, false,0,true );
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
		this.visible = true;
		_photoHolder.graphics.clear();
		_dictionary = _buildNewDictionary($sets);
		_stockMap.clear();
		var rows:Array = [0,0];
		var pad:Number	= 25;
		var setIndex:uint = 0;		
		var xPos:Number = pad;
		var count:Number = 0;
		var widthMod:Number = _stockMap.getPercentageOfFullWidth( $sets );		
		
		// Loop through each set of photos
		for each( var photoSet:StockPhotoSetVo in $sets)
		{	
			_stockMap.addCategory( photoSet.setName, setIndex )
			
			// Grab the list of items to display
			var stack:Vector.<StockPhotoVo> = photoSet.displayStack;
			
			////  Create the small bricks
			var len:uint = stack.length;
			for ( var i:uint=0; i<len; i++ ) 
			{
				var photo:StockPhoto = _dictionary[ stack[i].id ];
				_photoHolder.addChild( photo );
				photo.build( stack[i].width );
				photo.loadThumbnail();
				
				var smallestRowIndex = _getShortestRowIndex(rows);		// Find the shortest row
				photo.y = 220 * smallestRowIndex;						// Set the y position based on the position in the array
				photo.x = rows[smallestRowIndex] + pad;					// Set the x position based on value of item
				
				_stockMap.addItem( stack[i].id, smallestRowIndex, setIndex, stack[i].width * widthMod );
				
				rows[smallestRowIndex] += pad + photo.width;			// update row width
			}
			
			_drawColoredBar(xPos, rows[0], StockMap.SET_COLORS[count++]);
			xPos = rows[0] + pad;
			setIndex++;
		}
		
		// If there's just one set, don't show the colored lines
		if( count == 1 )
			_photoHolder.graphics.clear();
		
		_stockMap.buildNewSet($sets, widthMod);
		setScrollWindow(StageResizeVo.lastResize);
		scroll(0);
	}
	
	public function hide (  ):void
	{
		this.visible = false;
	}
	
	/** 
	*	Clean up / delete all images and shut it down
	*/
	public function clear (  ):void
	{
		_clearDictionaryPhotos();
		_stockMap.clear();
		_photoHolder.graphics.clear();
		hide();
		//_photoMap.clear();
	}
	
	/** 
	*	Activate a certain Stock Photo
	*/
	public function displayPhoto ( $stockPhotoVo:StockPhotoVo ):void
	{
	}
	
	public function highlightImage ( $id:String ):void
	{
		//if( _activePhoto != null )
		//	_activePhoto.unHighlight();
		
		//_activePhoto = _dictionary[ $id ];
		_dictionary[ $id ].highlight();
		_stockMap.highlightItem( $id );
	}
	
	public function unHighlightImage ( $id:String ):void
	{
		_dictionary[ $id ].unHighlight();
		_stockMap.unHighlightItem( $id );
	}
	
	public function scroll ( $perc:Number ):void
	{
		var xtarg:Number = 0 - ( _scrollWindow.width * $perc );
		Tweener.addTween( _photoHolder, { x:xtarg, time:0.6, transition:"EaseOutQuint"} );
	}
	
	public function setScrollWindow ( $resize:StageResizeVo ):void
	{
		//_scrollWindow = new Rectangle( 0,0, _photoHolder.width - StageResizeVo.lastResize.width ,0 );
		_scrollWindow = new Rectangle( 0,0, _photoHolder.width - StageResizeVo.MIN_WIDTH ,0 );
		_stockMap.draggerVisible = ( _photoHolder.width > StageResizeVo.MIN_WIDTH )? true : false;
			
			
	}
	
	public function deleteStockTagById ( $tagIndex:uint ):void
	{
		_stockMap.bumpColorToEndOfList($tagIndex);
	}
	
	public function updatePhotoLightBoxStatus ( $vo:LightBoxDispayItemsVo ):void
	{
		var i:uint; var len:uint; var photo:StockPhoto;
		
		len = $vo.itemsToAddToLightBox.length;
		for ( i=0; i<len; i++ ) {
			photo = _dictionary[ $vo.itemsToAddToLightBox[i] ];
			if( photo != null )
				photo.isInLightBox = true;
		}
		
		len = $vo.itemsToRemoveFromLightbox.length;
		for ( i=0; i<len; i++ ) {
			photo = _dictionary[ $vo.itemsToRemoveFromLightbox[i] ];
			if( photo != null )
				photo.isInLightBox = false;
		}
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
			// Grab the list of items to display
			var stack:Vector.<StockPhotoVo> = photoSet.displayStack;
			
			var len:uint = stack.length;
			for ( var i:uint=0; i<len; i++ ) 
			{
				var photoVo:StockPhotoVo = stack[i];
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
	
	private function _drawColoredBar ( $startX:Number, $endX:Number, $color:Number ):void {
		_photoHolder.graphics.beginFill($color);
		_photoHolder.graphics.drawRect($startX, -8, $endX - $startX-1, 2);
	}
	
	// _____________________________ Event Handlers
	
	private function _onBackBtnClick ( e:Event ):void {
		dispatchEvent( new StockEvent(StockEvent.RETURN_TO_MAIN_CATEGORIES, true) );
	}
	
}

}