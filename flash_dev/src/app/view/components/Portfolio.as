package app.view.components
{

import flash.display.*;
import app.model.vo.PortfolioVo;
import app.model.vo.PortfolioItemVo;
import app.model.vo.StageResizeVo;
import app.model.vo.DeactivateVo;
import caurina.transitions.Tweener;
import app.view.components.events.ImageLoadEvent;
import flash.events.*;
import delorum.scrolling.*;
import delorum.loading.Queue;
// TEMP
import flash.net.LocalConnection;
import delorum.loading.*;
import delorum.utils.KeyTrigger;

public class Portfolio extends Page
{
	private static const _ITEM_PADDING:Number = 10;
	private static const _SCROLL_PADDING:Number = 10;
	private var _imageHolder:Sprite;
	private var _currentItem:PortfolioItem;
	private var _currentIndex:uint;
	private var _items:Array;
	private var _portfolioNav:PortfolioNav;
	private var _copyRight:Copyright_swc;
	private var _loading:LoadingDisplay = new LoadingDisplay();
	private var _portfolioNumber:Number = 0;
	public function Portfolio():void
	{
		//Queue.setQueueIndex("low", 0);
		//Queue.setQueueIndex("high", 1);
	}
	
	public function init (  ):void
	{
		this.addEventListener( ImageLoadEvent.HIGH_RES_IMAGE_LOADED, _onHighResImageLoaded, false,0,true );
		this.addEventListener( ImageLoadEvent.LOW_RES_IMAGE_LOADED, _onLowResImageLoaded, false,0,true );
		this.addEventListener( ImageLoadEvent.RECENTER_STRIP, _onRecenterStrip, false,0,true );
		
		_copyRight = new Copyright_swc();
		
		_portfolioNav = new PortfolioNav();
		_portfolioNav.build();
		_portfolioNav.visible = false;
		_portfolioNav.x = StageResizeVo.CENTER - _portfolioNav.width/2;
		_portfolioNav.y = 640;
		
		this.addChild(_copyRight);
		this.addChild(_portfolioNav);
		this.addChild(_loading)
		_loading.hide();
	}
	
	
	// _____________________________ API
	
	/** 
	*	Reset and prepare for new data
	*/
	public function clear (  ):void
	{
		_portfolioNav.visible = false;
		this.stage.removeEventListener( Event.ENTER_FRAME, _onEnterFrame );
		
		// Reset vars
		_currentIndex 	= 0;
		_currentItem	= null;
		
		// Remove any current images
		if( _imageHolder != null ) {
			this.removeChild(_imageHolder);
			var len:uint = _imageHolder.numChildren;
			for ( var i:uint=0; i<len; i++ ) 
			{
				var portfolioItem:PortfolioItem = _imageHolder.getChildAt(0) as PortfolioItem;
				portfolioItem.clear();
				_imageHolder.removeChild( portfolioItem );
			}
		}

		// Reset the loading display
		_loading.reset();
		_loading.hide(true);
		
		// Create image holder
		_imageHolder = new Sprite();
		_imageHolder.y = 100;
		this.addChildAt( _imageHolder, 0 );
	}
	
	/** 
	*	Create and show a new portfolio of images
	*	@param		The data used to build the portfolio
	*/
	public function showNewPortfolio ( $portfolioVo:PortfolioVo ):void
	{ 
		_portfolioNumber++;
		// Reset
		clear();
		BaseLoader._currentlyLoading = false;
		//Queue.setQueueIndex("low"+_portfolioNumber, 0);
		//Queue.setQueueIndex("high"+_portfolioNumber, 1)
		this.stage.addEventListener( Event.ENTER_FRAME, _onEnterFrame, false,0,true );
		this.alpha = 0;
		Tweener.addTween( this, { alpha:1, time:1, transition:"EaseInOutQuint"} );
		
		// Create new portfolio Items
		_items = new Array();
		var portfolioItemVo:PortfolioItemVo;
		var portfolioItem:PortfolioItem;
		var len:uint = $portfolioVo.items.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			portfolioItemVo = $portfolioVo.items[i];
			portfolioItem	= new PortfolioItem();
			portfolioItem.buildAndLoad( portfolioItemVo, _portfolioNumber );
			portfolioItem.x = i * 200;
			portfolioItem.deactivate();
			portfolioItem.addEventListener( "madeBig", _onItemActivationComplete, false,0,true );
			_items.push( portfolioItem )
			_imageHolder.addChild( portfolioItem );
		}
		
		_portfolioNav.hideArrows();
		_portfolioNav.visible = true;
		_imageHolder.x = StageResizeVo.lastResize.left;
		_loading.show();
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
	
	/** 
	*	Deactivates the current item
	*/
	public function deactivateCurrentItem ( $deactivateVo:DeactivateVo ):void
	{
		_portfolioNav.hideArrows();
		if( _currentItem != null )
			_currentItem.deactivate();
		
		_currentItem = _items[ $deactivateVo.index ] as PortfolioItem
			
		this.stage.addEventListener( Event.ENTER_FRAME, _onEnterFrame, false,0,true );
		
		if( $deactivateVo.direction == "left" )
			_leftStripOnImage( $deactivateVo.index );
		else if( $deactivateVo.direction == "right" )
			_rightStripOnImage( $deactivateVo.index );
		else
			_centerStripOnImage( $deactivateVo.index )	
		
		if( _currentItem != null )
			_currentItem.deactivate();
	}
	
	/** 
	*	Turns images on (or off) based on a list of active / inactive items
	*	@param		list of items
	*/
	public function filterImages ( $images:Array=null ):void
	{
		var portfolioItem:PortfolioItem;
		var len:uint = $images.length;
		var firstIndex:int = -1;
		
		for ( var i:uint=0; i<len; i++ ) 
		{
			portfolioItem = _items[i] as PortfolioItem;
			if( $images[i] && portfolioItem.isHidden ){
				portfolioItem.show();
			}else if( !$images[i] && !portfolioItem.isHidden ){
				portfolioItem.hide();
			}			
			if( $images[i] && firstIndex < 0 ){
				firstIndex = i;
			}
		}
		
		if( _currentItem != null )
			if( _currentItem.isHidden )
				_currentItem = null;
		
		_distributeObjects(0)
		//Tweener.addTween( _imageHolder, { x:StageResizeVo.lastResize.left + _ITEM_PADDING, time:0, transition:"EaseInOutQuint"} );
	}
	
	/** 
	*	Called when the active item is clicked again
	*/
	public function activeItemClickedAgain (  ):void
	{
		deactivateCurrentItem( new DeactivateVo(_currentItem.index, "center") );
	}
	
	/** 
	*	Called when the stage resizes
	*/
	public function onStageResize ( $vo:StageResizeVo ):void
	{
		_loading.x 		= $vo.left//StageResizeVo.CENTER - LoadingDisplay.WIDTH/2;
		_copyRight.x 	= $vo.right - _copyRight.width - 20;
		_copyRight.y 	= $vo.height - _copyRight.height - 20
	}
	
	public function updateTotalImagesLoaded ( $loaded:Number, $total:Number ):void
	{
		_loading.update($loaded, $total, StageResizeVo.lastResize.width)
	}
	
	private function _totalWidth (  ):Number
	{
		var totalWidth:Number = 0;
		var len:uint = _items.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			totalWidth += _items[i].width;
			if( _items[i].width > 0 )
				totalWidth += _ITEM_PADDING;
				
		}
		return totalWidth;
	}
	
	// _____________________________ Strip
	
	private function _leftStripOnImage ( $index:uint, $speed:Number =1.3, $speed2:Number=0.8 ):void
	{
		_distributeObjects(0,true,$speed2);
		_lastXmouse = this.mouseX;
		var xTarg:Number = StageResizeVo.lastResize.left - _items[$index].targetX + _ITEM_PADDING;
		Tweener.addTween( _imageHolder, { x:xTarg, time:$speed, transition:"EaseInOutQuint"} );
	}
	
	private function _rightStripOnImage ( $index:uint, $speed:Number =1.3, $speed2:Number=0.8 ):void
	{
		_distributeObjects(0,true,$speed2);
		_lastXmouse = this.mouseX;
		var xTarg:Number = StageResizeVo.lastResize.right - _items[$index].targetX - _items[$index].width - _ITEM_PADDING;
		Tweener.addTween( _imageHolder, { x:xTarg, time:$speed, transition:"EaseInOutQuint"} );
	}
	
	private function _centerStripOnImage ( $index:uint, $speed:Number =1.3, $speed2:Number=0.8 ):void
	{
		_distributeObjects(0,true,$speed2);
		_lastXmouse = this.mouseX;
		var xTarg:Number = (_currentItem != null)? StageResizeVo.CENTER - _currentItem.targetX - _currentItemWidth/2 : StageResizeVo.lastResize.left ;
		Tweener.addTween( _imageHolder, { x:xTarg, time:$speed, transition:"EaseInOutQuint"} );
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
				
				var sidePadding = _ITEM_PADDING;//(StageResizeVo.lastResize.width/2 - _currentItemWidth/2);
				
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