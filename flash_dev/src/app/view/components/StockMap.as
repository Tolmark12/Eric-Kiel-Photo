package app.view.components
{

import flash.display.Sprite;
import app.model.vo.StockPhotoSetVo;
import app.model.vo.StageResizeVo;
public class StockMap extends Sprite
{
	public static const SHRINK_PERCENTAGE:Number = 0.06;
	
	
	private var _mapItemsHolder:Sprite = new Sprite();
	private var _miniPageHolder:Sprite  = new Sprite();
	
	public function StockMap():void
	{
		this.addChild( _mapItemsHolder );
		this.addChild( _miniPageHolder  );
	}
	
	public function clear (  ):void
	{
		this.visible = false;
		
		// Remvoe all the squares
		var len:Number = _mapItemsHolder.numChildren;
		for ( var i:uint=0; i<len; i++ ) 
		{
			var mapItem:StockMapItem = _mapItemsHolder.getChildAt(0) as StockMapItem;
			mapItem.clear();
			_mapItemsHolder.removeChild(mapItem);
		}
		
		// Remove all the page markers
		var len2:uint = _miniPageHolder.numChildren;
		for ( var j:uint=0; j<len2; j++ ) 
		{
			var divider = _miniPageHolder.removeChildAt(0);
		}
	}
	
	public function buildNewSet ( $setVo:StockPhotoSetVo ):void
	{
		this.visible = true;
		var rows:Array = [0,0,0,0,0];
		var pad:Number	= 2;
		
		_mapItemsHolder.x = -pad;
		
		////  Create the small bricks
		var len:uint = $setVo.stack.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			var mapItem:StockMapItem = new StockMapItem();			// Get map item
			_mapItemsHolder.addChild( mapItem );					// Add Child
			mapItem.build( $setVo.stack[i].width );					// Build
			
			var smallestRowIndex = _getShortestRowIndex(rows);		// Find the shortest row
			mapItem.y = 10 * smallestRowIndex;						// Set the y position based on the position in the array
			mapItem.x = rows[smallestRowIndex] + pad;				// Set the x position based on value of item
			rows[smallestRowIndex] += pad + mapItem.width;			// update row width
		}
		
		this.x = StageResizeVo.CENTER - this.width/2;
		_miniPageHolder.y = _mapItemsHolder.y + _mapItemsHolder.height + 20;
		
		//// TEMP - dividers...
		var browserWidth:Number		= Math.round( 1024 * SHRINK_PERCENTAGE );
		var distance:Number			= browserWidth;
		var numberOfPages:uint	 	= Math.ceil( _mapItemsHolder.width / browserWidth );
		for ( var j:uint=0; j<=numberOfPages; j++ ) 
		{
			var page = new StockMapMiniPage_swc();
			
			var pageNumber:String = ( j == numberOfPages )? "" : String( j + 1 );
			_miniPageHolder.addChild( page );

			page.build( pageNumber, browserWidth, 10 * rows.length + _miniPageHolder.y );
			page.x = distance * j;
		}
	}
	
	// _____________________________ Helpers
	
//	private function _getShortestSprite ( $ar:array ):Sprite
//	{
//		var shortestRow:int = 1000;		// Stores the value of the shortest row
//		var returnSprite:Sprite;		// Sprite to be returned
//		var testSprite:Sprite;			// Holder var
//		
//		var counter:int = $ar.length;
//		while (counter--)
//		{
//			testSprite = numbersArr[counter];
//			if( testSprite.width < shortestRow ){
//				returnSprite 	= sprite;
//				shortestRow		= testSprite.width;
//			}
//		}
//		return returnSprite;
//	}
	
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