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
	private var _portfolioNav:PortfolioNav;
	private var _copyRight:Copyright_swc;
	
	public function Portfolio():void
	{

	}
	
	public function init (  ):void
	{
		_scroller = new Scroller(20,20);
		_scroller.createDefaultScroller();
		_scroller.build();
		_scroller.visible = false;
		this.addChild(_scroller);
		_scroller.addEventListener( Scroller.SCROLL, _onScroll, false,0,true );
		this.addEventListener( ImageLoadEvent.HIGH_RES_IMAGE_LOADED, _onHighResImageLoaded, false,0,true );
		this.addEventListener( ImageLoadEvent.LOW_RES_IMAGE_LOADED, _onLowResImageLoaded, false,0,true );
		this.addEventListener( ImageLoadEvent.RECENTER_STRIP, _onRecenterStrip, false,0,true );
		
		_copyRight = new Copyright_swc();
		this.addChild(_copyRight);
		
		_portfolioNav = new PortfolioNav();
		_portfolioNav.build();
		_portfolioNav.visible = false;
		_portfolioNav.x = StageResizeVo.CENTER - _portfolioNav.width/2;
		_portfolioNav.y = 640;
		this.addChild(_portfolioNav);
	}
	
	// _____________________________ API
	
	/** 
	*	Create and show a new portfolio of images
	*	@param		The data used to build the portfolio
	*/
	public function showNewPortfolio ( $portfolioVo:PortfolioVo ):void
	{
		_currentIndex 	= 0;
		_currentItem	= null;
		
		//_scroller.visible = true;
		this.stage.addEventListener( Event.ENTER_FRAME, _onEnterFrame, false,0,true );
		
		this.alpha = 0;
		Tweener.addTween( this, { alpha:1, time:1, transition:"EaseInOutQuint"} );
		
		// Clean up an existing portfolio
		if( _imageHolder != null )
			_removeExistingPortfolio();
			
		// Init holder
		_imageHolder = new Sprite();
		_imageHolder.y = 100;
		this.addChildAt( _imageHolder, 0 );
		
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
			portfolioItem.deactivate();
			portfolioItem.addEventListener( "madeBig", _onItemActivationComplete, false,0,true );
			_items.push( portfolioItem )
			_imageHolder.addChild( portfolioItem );
		}
		
		_portfolioNav.hideArrows();
		_portfolioNav.visible = true;
		_imageHolder.x = StageResizeVo.lastResize.left;
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
		_currentItem.activate();
		_centerStripOnImage( $index );
		this.stage.removeEventListener( Event.ENTER_FRAME, _onEnterFrame )
		//_distributeObjects(0);
		
		var ammount:Number = _currentItem.width/2 - 20;
		
		_portfolioNav.positionArrows( ammount )
		_portfolioNav.showArrows();

	}
	
	public function deactivateCurrentItem ( $index:uint ):void
	{
		_portfolioNav.hideArrows();
		if( _currentItem != null )
			_currentItem.deactivate();
		
		_currentItem = _items[$index] as PortfolioItem
			
		this.stage.addEventListener( Event.ENTER_FRAME, _onEnterFrame, false,0,true );
		_centerStripOnImage( $index );
		
		if( _currentItem != null )
			_currentItem.deactivate();
	}
	
	/** 
	*	Turns images on (or off) based on a list of active / inactive items
	*	@param		list of items
	*/
	public function filterImages ( $images:Array ):void
	{
		var portfolioItem:PortfolioItem;
		var len:uint = $images.length;
		var firstIndex:int = -1;
		
		for ( var i:uint=0; i<len; i++ ) 
		{
			portfolioItem = _items[i] as PortfolioItem;
			if( $images[i] && portfolioItem.isHidden )
				portfolioItem.show()
			else if( !$images[i] && !portfolioItem.isHidden )
				portfolioItem.hide();
				
			if( $images[i] && firstIndex < 0 )
				firstIndex = i;
		}
		
		if( _currentItem != null )
			if( _currentItem.isHidden )
				_currentItem = null;
		
		_distributeObjects(_currentIndex)
		
		if( _currentItem != null )
			_centerStripOnImage( _currentItem.index, 0, 0)
		else 
			_centerStripOnImage( firstIndex, 0, 0 )
	}
	
	public function activeItemClickedAgain (  ):void
	{
		deactivateCurrentItem(_currentItem.index);
	}
	
	public function onStageResize ( $vo:StageResizeVo ):void
	{
		_copyRight.x = $vo.right - _copyRight.width - 20;
		_copyRight.y = $vo.height - _copyRight.height - 20
		//_scroller.changeWidth( $vo.width - _SCROLL_PADDING*2, 0 );
		//_scroller.y = $vo.height - _scroller.height - _SCROLL_PADDING;
		//_scroller.x = $vo.left + _SCROLL_PADDING;
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
	
	private function _centerStripOnImage ( $index:uint, $speed:Number =1.3, $speed2:Number=0.8 ):void
	{
		_distributeObjects(0,true,$speed2);
		_lastXmouse = this.mouseX;
		var xTarg:Number = (_currentItem != null)? StageResizeVo.CENTER - _currentItem.targetX - _currentItemWidth/2 : StageResizeVo.lastResize.left ;
		Tweener.addTween( _imageHolder, { x:xTarg, time:$speed, transition:"EaseInOutQuint"} );
//		_scroller.changeScrollPosition( (_currentItem.targetX) / (_totalWidth() -_currentItemWidth) );
	}
	
	public var count:Number = 0;
	private function _distributeObjects ( $startingIndex:Number, $doTween:Boolean=true, $speed:Number=0.8 ):void
	{
		var len:uint 	= _items.length;
		var xPos:Number = _ITEM_PADDING;
		var item:PortfolioItem;
		
		for ( var i:uint=0; i<len; i++ ) 
		{
			item = _items[i] as PortfolioItem
			if( i >= $startingIndex )
				item.moveTo( xPos, $doTween, $speed );
			xPos += item.width;
			if( item.width != 0 )
				xPos += _ITEM_PADDING;
		}
	}
	
	
	// _____________________________ Events
	
	private function _onLowResImageLoaded ( e:ImageLoadEvent ):void {
		_distributeObjects( e.imageIndex, false );
//		_scroller.updateScrollWindow( StageResizeVo.lastResize.width / _imageHolder.width, 0 );
	}
	
	private function _onHighResImageLoaded ( e:ImageLoadEvent ):void {
		_distributeObjects( e.imageIndex, false );
	}
	
	private function _onRecenterStrip ( e:ImageLoadEvent ):void {
		_centerStripOnImage(_currentIndex, e.imageIndex, 0);
	}
	
	private var _scrollWindowWidth:Number = 250
	private var _isScrolling:Boolean = false;
	private var _lastXmouse:Number = 0;
	private function _onEnterFrame ( e:Event ):void{
		_isScrolling = false
		if( this.mouseY > 200 && this.mouseY < 380 && Math.abs( _lastXmouse - this.mouseX ) > 13 ) {
			_lastXmouse = StageResizeVo.CENTER;
			var pos:Number = StageResizeVo.CENTER - this.stage.mouseX;
			if( Math.abs(pos) > _scrollWindowWidth ){
				_isScrolling = true;
				pos += (pos < 1)? _scrollWindowWidth : -_scrollWindowWidth ;
				var xTarg:Number = Math.round( _imageHolder.x + pos * 0.07 );
				
				var sidePadding = (StageResizeVo.lastResize.width/2 - _currentItemWidth/2);
				
				if( pos > 1 ){
					if( xTarg < StageResizeVo.lastResize.left + sidePadding )
						_imageHolder.x = xTarg;
					else
						_imageHolder.x = StageResizeVo.lastResize.left + sidePadding 
				}else{
					if( xTarg > StageResizeVo.lastResize.right - _totalWidth() - sidePadding )
						_imageHolder.x = xTarg;
					else
						_imageHolder.x = StageResizeVo.lastResize.right - _totalWidth() - sidePadding
				}
			}			
		}

	}
	
	private function _onItemActivationComplete ( e:Event ):void
	{
		_imageHolder.swapChildrenAt( _imageHolder.numChildren-1, _imageHolder.getChildIndex(_currentItem) );
	}
	
	private function _onScroll ( e:ScrollEvent ):void
	{
		var sidePadding = (StageResizeVo.lastResize.width/2 - _currentItemWidth/2);
		
		var xTarget:Number = StageResizeVo.lastResize.left + sidePadding + (( - _totalWidth()-sidePadding*2 + StageResizeVo.lastResize.width )   * e.percent);
		Tweener.addTween( _imageHolder, { x:xTarget, time:0.5} );
		//_imageHolder.x = xTarget;
	}
	
	private function get _currentItemWidth():Number{
		if( _currentItem != null )
			return _currentItem.width;
		else 
			return StageResizeVo.lastResize.width;
	}
}

}