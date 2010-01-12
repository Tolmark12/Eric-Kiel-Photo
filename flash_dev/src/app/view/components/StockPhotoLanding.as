package app.view.components
{

import flash.display.Sprite;
import app.model.vo.StockConfigVo;
import app.model.vo.StageResizeVo;
import flash.filters.*;
import flash.events.*;
import app.view.components.events.FilterEvent;
import caurina.transitions.Tweener;
public class StockPhotoLanding extends Sprite
{
	private var _categoryBtnHolder:Sprite;
	
	public function StockPhotoLanding():void
	{
		
	}
	
	// _____________________________ API
	
	/** 
	*	Build
	*/
	public function build ( $stockConfigVo:StockConfigVo ):void
	{
		this.visible = true;
		this.alpha = 1;
		_categoryBtnHolder = new Sprite();
		var len:uint = $stockConfigVo.defaultStockCategories.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			var categoryBtn:StockLandingMainCat = new StockLandingMainCat( $stockConfigVo.defaultStockCategories[i] );
			categoryBtn.x = i*296;
			categoryBtn.addEventListener( MouseEvent.CLICK, _onCategoryBtnClick, false,0,true );
			_categoryBtnHolder.addChild(categoryBtn);
		}
		
		_categoryBtnHolder.y = 200;
		_categoryBtnHolder.x = StageResizeVo.CENTER - (296*3)/2
		_categoryBtnHolder.filters = [new DropShadowFilter(10, 45, 0x000000, .45, 15, 15, 1, 3)];
		
		
		this.addChild(_categoryBtnHolder);
	}
	
	
	/** 
	*	Clean up
	*/
	public function clear (  ):void
	{
		if( _categoryBtnHolder != null ) {
			_categoryBtnHolder.filters = [];
			var len:uint = _categoryBtnHolder.numChildren;
			for ( var i:uint=0; i<len; i++ ) 
			{
				var categoryBtn:StockLandingMainCat = _categoryBtnHolder.getChildAt(0) as StockLandingMainCat;
				categoryBtn.clear();
				_categoryBtnHolder.removeChildAt(0);
			}
			
			this.removeChild(_categoryBtnHolder);
			_categoryBtnHolder = null;
			
		}
	}
	
	public function hide (  ):void
	{
		Tweener.addTween( this, { alpha:0, time:1, transition:"EaseInOutQuint", onComplete:_hideFadeComplete} );
	}
	
	// _____________________________ Event Handlers
	
	private function _onCategoryBtnClick ( e:Event ):void {
		var categoryBtn:StockLandingMainCat = e.currentTarget as StockLandingMainCat;
		var ev:FilterEvent = new FilterEvent( FilterEvent.NEW_FILTER, true );
		ev.tags = categoryBtn.tags;
		dispatchEvent( ev );
	}
	
	private function _hideFadeComplete (  ):void
	{
		this.visible = false;
	}

}

}