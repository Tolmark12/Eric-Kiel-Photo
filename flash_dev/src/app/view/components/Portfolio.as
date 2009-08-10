package app.view.components
{

import flash.display.*;
import app.model.vo.PortfolioVo;
import app.model.vo.PortfolioItemVo;
import app.model.vo.StageResizeVo;
import caurina.transitions.Tweener;
import app.view.components.events.ImageLoadEvent;
import flash.events.*;
import delorum.scrolling.*;


public class Portfolio extends Page
{
	private static const _ITEM_PADDING:Number = 10;
	private static const _SCROLL_PADDING:Number = 10;
	private var _imageHolder:Sprite;
	private var _currentItem:PortfolioItem;
	private var _currentIndex:uint;
	private var _items:Array;
	private var _scroller:Scroller;
	
	public function Portfolio():void
	{

	}
	
	public function init (  ):void
	{
		_scroller = new Scroller(20,20);
		_scroller.createDefaultScroller();
		_scroller.build();
		_scroller.visible = false
		this.addChild(_scroller);
		_scroller.addEventListener( Scroller.SCROLL, _onScroll, false,0,true );
		this.addEventListener( ImageLoadEvent.HIGH_RES_IMAGE_LOADED, _onHighResImageLoaded, false,0,true );
		this.addEventListener( ImageLoadEvent.LOW_RES_IMAGE_LOADED, _onLowResImageLoaded, false,0,true );
		this.addEventListener( ImageLoadEvent.RECENTER_STRIP, _onRecenterStrip, false,0,true );
	}
	
	// _____________________________ API
	
	/** 
	*	Create and show a new portfolio of images
	*	@param		The data used to build the portfolio
	*/
	public function showNewPortfolio ( $portfolioVo:PortfolioVo ):void
	{
		_scroller.visible = true;
//		this.stage.addEventListener( MouseEvent.MOUSE_MOVE, _onMouseMove, false,0,true );
		
		// Clean up an existing portfolio
		if( _imageHolder != null )
			_removeExistingPortfolio();
			
		// Init holder
		_imageHolder = new Sprite();
		_imageHolder.y = 100;
		this.addChild( _imageHolder );
		
		// Create new portfolio Items
		_items = new Array();
		var portfolioItemVo:PortfolioItemVo;
		var portfolioItem:PortfolioItem;
		var len:uint = $portfolioVo.items.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			portfolioItemVo = $portfolioVo.items[i];
			portfolioItem	= new PortfolioItem();
			portfolioItem.buildAndLoad( portfolioItemVo );
			portfolioItem.x = i * 200;
			_items.push( portfolioItem )
			_imageHolder.addChild( portfolioItem );
		}
	}
	
	/** 
	*	Activate a portfolio item (make it big)
	*	@param		index of item to activate
	*/
	public function activateItem ( $index:uint ):void
	{
		if( _currentItem != null )
			_currentItem.deactivate();
	
		_currentIndex = $index;
		_currentItem = _items[$index] as PortfolioItem;
		_imageHolder.swapChildrenAt( _imageHolder.numChildren-1, _imageHolder.getChildIndex(_currentItem) );
		_currentItem.activate();
		_centerStripOnImage( $index );
		_distributeObjects(0);
	}
	
	public function onStageResize ( $vo:StageResizeVo ):void
	{
		_scroller.changeWidth( $vo.width - _SCROLL_PADDING*2, 0 );
		_scroller.y = $vo.height - _scroller.height - _SCROLL_PADDING;
		_scroller.x = $vo.left + _SCROLL_PADDING;
	}
	
	// _____________________________ Helpers
	
	private function _removeExistingPortfolio (  ):void
	{
		this.removeChild( _imageHolder );
	}
	
	private function _totalWidth (  ):Number
	{
		var totalWidth:Number = 0;
		var len:uint = _items.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			totalWidth += _items[i].width + _ITEM_PADDING;
		}
		return totalWidth;
	}
	
	// _____________________________ Strip
	
	private function _centerStripOnImage ( $index:uint ):void
	{
		_distributeObjects(0);
		Tweener.addTween( _imageHolder, { x:StageResizeVo.CENTER - _currentItem.targetX - _currentItem.width/2, time:0.5, transition:"EaseInOutQuint"} );
		_scroller.changeScrollPosition( (_currentItem.targetX) / (_totalWidth() -_currentItem.width) );
	}
	
	private function _distributeObjects ( $startingIndex:Number, $doTween:Boolean=true ):void
	{
		var len:uint 	= _items.length;
		var xPos:Number = _ITEM_PADDING;
		var item:PortfolioItem;
		
		
		for ( var i:uint=$startingIndex; i<len; i++ ) 
		{
			item = _items[i] as PortfolioItem
			item.moveTo( xPos, $doTween );
			xPos += item.width + _ITEM_PADDING;
		}
	}
	
	
	// _____________________________ Events
	
	private function _onLowResImageLoaded ( e:ImageLoadEvent ):void {
		_distributeObjects( e.imageIndex, false );
		_scroller.updateScrollWindow( StageResizeVo.lastResize.width / _imageHolder.width, 0 );
	}
	
	private function _onHighResImageLoaded ( e:ImageLoadEvent ):void {
		_distributeObjects( e.imageIndex, false );
	}
	
	private function _onRecenterStrip ( e:ImageLoadEvent ):void
	{
		_centerStripOnImage(_currentIndex);
	}
	
	private function _onMouseMove ( e:Event ):void{
		_imageHolder.x =  -_imageHolder.width * ( this.mouseX - StageResizeVo.lastResize.left ) / StageResizeVo.lastResize.width + StageResizeVo.lastResize.width;
	}
	
	private function _onScroll ( e:ScrollEvent ):void
	{
		var sidePadding = (StageResizeVo.lastResize.width/2 - _currentItem.width/2);
		_imageHolder.x = StageResizeVo.lastResize.left + sidePadding + (( - _totalWidth()-sidePadding*2 + StageResizeVo.lastResize.width )   * e.percent);		
	}

}

}