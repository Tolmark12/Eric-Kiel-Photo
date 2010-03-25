package app.view.components
{

import flash.display.Sprite;
import app.model.vo.StockPhotoSetVo;
import app.model.vo.StageResizeVo;
import caurina.transitions.Tweener;
import flash.events.*;
import app.view.components.events.StockEvent;

public class StockMap extends Sprite
{
	public static var SET_COLORS:Array = [
		0xFFFFFF,
		0xE89264,
		0xC9BC90,
		0xA18793,
		0xC4A26C,
		0x9C9463,
		0xA8A793
	];

	public static const SHRINK_PERCENTAGE:Number = 0.06;
	private var _mapItemsHolder:Sprite 	= new Sprite();					// Map pucks
	private var _miniPageHolder:Sprite  = new Sprite();					// Divider
	private var _closeBtnHolder:Sprite	= new Sprite();	
	private var _mapDragger:StockMapDragger = new StockMapDragger();	// Used to drag the position
	private var _currentItem:StockMapItem;
	
	public function StockMap():void {
		this.addChild( _miniPageHolder );
		this.addChild( _mapItemsHolder );
		this.addChild( _closeBtnHolder );
		this.addChild( _mapDragger );
		_closeBtnHolder.y = -30;
		
		_mapItemsHolder.addEventListener( StockEvent.STOCK_PHOTO_CLICK, _onStockPhotoClick, false,0,true );
	}
	
	public function clear (  ):void
	{
		_mapDragger.clear();
		this.visible = false;
		
		// Remvoe all the squares
		var len:Number = _mapItemsHolder.numChildren;
		for ( var i:uint=0; i<len; i++ ) {
			var mapItem:StockMapItem = _mapItemsHolder.getChildAt(0) as StockMapItem;
			mapItem.clear();
			_mapItemsHolder.removeChild(mapItem);
		}
		
		// Remove all the page markers
		var len2:uint = _miniPageHolder.numChildren;
		for ( var j:uint=0; j<len2; j++ ) {
			var divider = _miniPageHolder.removeChildAt(0);
		}
		
		//
		var len3:uint = _closeBtnHolder.numChildren;
		for ( var k:uint=0; k<len3; k++ ) {
			var closeBtn:StockCategoryBtn_swc = _closeBtnHolder.removeChildAt(0) as StockCategoryBtn_swc;
			closeBtn.clear();
		}
		
		rows = [0,0];
	}
	
	
	public var rows:Array = [0,0];
	public var pad:Number = 2;
	public function addItem ( $id:String, $rowIndex:uint, $setIndex:Number, $width:Number ):void
	{
		var mapItem:StockMapItem = new StockMapItem( $id );			// Get map item
		_mapItemsHolder.addChild( mapItem );					// Add Child
		mapItem.build( Math.ceil( $width * SHRINK_PERCENTAGE ), Math.ceil( 141 * SHRINK_PERCENTAGE), SET_COLORS[$setIndex]  /*, SET_COLORS[count]*/ );					// Build
		mapItem.x = rows[$rowIndex];
		mapItem.y = (190 * SHRINK_PERCENTAGE) * $rowIndex;
		rows[$rowIndex] += mapItem.width + pad
	}
	
	/** 
	*	Add a Category button that allows the user to remove a search tag
	*	@param		The id of the button (Also used for the search text)
	*	@param		The index of this set
	*/
	public function addCategory ( $id:String, $setIndex:Number ):void
	{
		var btn:StockCategoryBtn_swc = new StockCategoryBtn_swc();
		btn.build( $id, SET_COLORS[$setIndex], $setIndex==0 );
		//btn.x = ( _mapItemsHolder.width > _closeBtnHolder.width + 20) ? _mapItemsHolder.width : _closeBtnHolder.width + 20 ;
		btn.x = (_closeBtnHolder.width==0)? 0 : _closeBtnHolder.width + 25;
		btn.x = Math.round(btn.x) + 5;
		_closeBtnHolder.addChild(btn);
	}
	
	public function buildNewSet ( $stack:Vector.<StockPhotoSetVo> ):void
	{
		this.visible = true;
		var rows:Array = [0,0];
		var pad:Number	= 2;
		_closeBtnHolder.x = -7;
		_mapItemsHolder.x = pad;
		var count:Number = 0;
		
		this.x = StageResizeVo.CENTER - _mapItemsHolder.width/2;
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
		
		//// Dragger
		_mapDragger.y = 0;
		_mapDragger.build( browserWidth, _mapItemsHolder.height, 6 );
		_mapDragger.setHorizontalBounds( _mapItemsHolder.x, _mapItemsHolder.x + _mapItemsHolder.width, browserWidth )
	}
	
	public function activateItem ( $id:String ):void
	{
		
	}
	
	public function highlightItem (  $id:String ):void
	{
		//if( _currentItem != null )
		//	_currentItem.deactivate();
			
		//_currentItem = _getItemById($id);
		_getItemById($id).highlight();
	}
	
	public function unHighlightItem ( $id:String ):void
	{
		_getItemById($id).unHighlight();
	}
	
	public function bumpColorToEndOfList ( $index:uint ):void
	{
		var clr:Number = SET_COLORS.splice($index,1);
		SET_COLORS.push(clr);
	}
	
	// _____________________________ Helpers
	
	private function _getItemById ( $id:String ):StockMapItem {
		var len:uint = _mapItemsHolder.numChildren;
		for ( var i:uint=0; i<len; i++ ) 
		{
			var stockMapItem:StockMapItem = _mapItemsHolder.getChildAt(i) as StockMapItem;
			if( stockMapItem.id == $id )
				return stockMapItem;
		}
		return null;
	}
	
	// _____________________________ Event Handlers
	
	
	private function _onStockPhotoClick ( e:StockEvent ):void {
		_mapDragger.scrollTo( e.target.x );
	}

}

}