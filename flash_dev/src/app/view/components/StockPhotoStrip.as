package app.view.components
{

import flash.display.Sprite;
import app.model.vo.StockPhotoSetVo;
import app.model.vo.StockPhotoVo;

public class StockPhotoStrip extends Sprite
{
	private var _dictionary:Object	= {};			// An object with reference to the photos by id
	private var _photoHolder:Sprite	= new Sprite();
	private var _photoMap:StockMap;
	
	private var _activePhoto:StockPhoto;
	
	public function StockPhotoStrip():void
	{
		//this.addChild(_photoMap);
		this.addChild(_photoHolder);
	}
	
	// _____________________________ API
	
	public function buildNewSet ( $setVo:StockPhotoSetVo ):void
	{
		
		// TEMP !!!!!
		/** 
		*	In reality, this will not happen like this, 
		*	right now, we're showing the entire set. instead, what will
		*	happen is that we display a "page" of select photos.
		*/
		_dictionary = _buildNewDictionary($setVo.stack);
		
		var row1:Number = 0
		var row2:Number = 0;
		var yPos:Number	= 0
		var pad:Number	= 20;
		
		var len:uint = $setVo.stack.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			var photo:StockPhoto = _dictionary[ $setVo.stack[i].id ];
			_photoHolder.addChild( photo );
			photo.build( $setVo.stack[i].width );
			
			// Place the photo in the shortest row
			if( row2 > row1 ){
				photo.y = 100;
				photo.x = row1 + pad;
				row1 += pad + photo.width;
			}else{
				photo.y = 320;
				photo.x = row2 + pad;
				row2 += pad + photo.width;
			}
		}
		// TEMP !!!!!
		
	}
	
	/** 
	*	Clean up / delete all images and shut it down
	*/
	public function clear (  ):void
	{
		_clearDictionaryPhotos();
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
	
	// _____________________________ Helpers
	
	
	// Delete all the photos that are no longer found in the new stack
	// Keep the ones that are in the new stack
	private function _buildNewDictionary ( $stack:Vector.<StockPhotoVo> ):Object
	{
		// Create new Dictionary
		var newDictionary:Object = new Object;
		var len:uint = $stack.length;	
		for ( var i:uint=0; i<len; i++ ) 
		{
			var photo:StockPhoto;
			var photoVo:StockPhotoVo = $stack[i];
			
			// If this alread exists, reference it (saves reloading photos)
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
}

}