package app.view.components
{

import flash.display.*;
import app.model.vo.PortfolioVo;
import app.model.vo.PortfolioItemVo;
import app.model.vo.StageResizeVo;
import caurina.transitions.Tweener;
import app.view.components.events.ImageLoadEvent;

public class Portfolio extends Page
{
	private static const _ITEM_PADDING:Number = 10;
	private var _imageHolder:Sprite;
	private var _currentItem:PortfolioItem;
	private var _currentIndex:uint;
	private var _items:Array;
	
	public function Portfolio():void
	{
		this.addEventListener( ImageLoadEvent.HIGH_RES_IMAGE_LOADED, _onHighResImageLoaded, false,0,true );
		this.addEventListener( ImageLoadEvent.LOW_RES_IMAGE_LOADED, _onLowResImageLoaded, false,0,true );
	}
	
	// _____________________________ API
	
	public function showNewPortfolio ( $portfolioVo:PortfolioVo ):void
	{
		if( _imageHolder != null )
			_removeExistingPortfolio();
			
		_imageHolder = new Sprite();
		_imageHolder.y = 200;
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
	
	public function activateItem ( $index:uint ):void
	{
		if( _currentItem != null )
			_currentItem.deactivate();
	
		_currentIndex = $index;
		_currentItem = _items[$index] as PortfolioItem;
		_imageHolder.swapChildrenAt( _imageHolder.numChildren-1, _imageHolder.getChildIndex(_currentItem) );
		_currentItem.activate();
		_centerStripOnImage( $index )
	}
	
	// _____________________________ Helpers
	
	private function _removeExistingPortfolio (  ):void
	{
		this.removeChild( _imageHolder );
	}
	
	// _____________________________ Strip
	
	private function _centerStripOnImage ( $index:uint ):void
	{
		var len:uint 	= _items.length;
		var xPos:Number = 0;
		var item:PortfolioItem;
		var totalWidth:Number = 0;
		
		for ( var i:uint=0; i<len; i++ ) 
		{
			item = _items[i] as PortfolioItem
			item.moveTo(xPos);
			xPos += item.width + _ITEM_PADDING;
			if( i != $index )
				item.deactivate();
		}
		
		Tweener.addTween( _imageHolder, { x:StageResizeVo.CENTER - _currentItem.targetX - _currentItem.width/2, time:1.0, transition:"EaseInOutQuint"} );
	}
	
	// _____________________________ Events
	
	private function _onLowResImageLoaded ( e:ImageLoadEvent ):void {
		//var len:uint = _items.length;
		//for ( var i:uint=e.; i<len; i++ ) 
		//{
		//	
		//}
	}
	
	private function _onHighResImageLoaded ( e:ImageLoadEvent ):void {
		//_centerStripOnImage(_currentIndex);
	}

}

}