package app.view.components
{

import flash.display.Sprite;
import app.model.vo.PortfolioItemVo;
import delorum.loading.ImageLoader;
import flash.events.*;
import app.view.components.events.NavEvent;
import caurina.transitions.Tweener;
import app.view.components.events.ImageLoadEvent;
import flash.filters.BitmapFilter;
import flash.filters.BitmapFilterQuality;
import flash.filters.GlowFilter;

public class PortfolioItem extends Sprite
{
	private static const _LOWER_Y:Number = 100;
	private static const _TIME:Number = 0.8;
	
	public var isActive:Boolean = false;
	private var _portfolioItemVo:PortfolioItemVo;
	private var _portfolioImages:PortfolioImage;
	public var targetX:Number;
	
	public function PortfolioItem():void
	{
		this.cacheAsBitmap = true;
		this.visible = false;
		this.y = _LOWER_Y;
		this.addEventListener( MouseEvent.CLICK, _onClick, false,0,true );
		this.addEventListener( MouseEvent.MOUSE_OVER, _onMouseOver, false,0,true );
		this.addEventListener( MouseEvent.MOUSE_OUT, _onMouseOut, false,0,true );
//		this.buttonMode = true;
	}
	
	// _____________________________ API
	
	/** 
	*	Initialize - also load images
	*	@param		Data for portfolio (image paths, index)
	*/
	public function buildAndLoad ( $portfolioItemVo:PortfolioItemVo ):void
	{
		_portfolioItemVo = $portfolioItemVo;
		_portfolioImages = new PortfolioImage(_portfolioItemVo.index);
		_portfolioImages.addEventListener( ImageLoadEvent.HIGH_RES_IMAGE_LOADED, _onHighResImageLoaded, false,0,true );
		_portfolioImages.addEventListener( ImageLoadEvent.LOW_RES_IMAGE_LOADED, _onLowResImageLoaded, false,0,true );
		this.addChild(_portfolioImages);
		_portfolioImages.loadImages( _portfolioItemVo.lowResSrc, _portfolioItemVo.src );
	}
	
	/** 
	*	Make this item selected
	*/
	public function activate (  ):void
	{
		_portfolioImages.loadLargeImage()
		_removeTweens();
		Tweener.addTween( super, { y:0, scaleX:1, scaleY:1, time:_TIME, transition:"EaseInOutQuint"} );
		blur = 0;
		Tweener.addTween( this, { blur:30, time:0.6, delay:0.3, transition:"EaseInOutQuint", onUpdate:_updateGlow} );
		
		_onMouseOver(null);
		this.isActive = true;
	}
	
	/** 
	*	Return this item to its previous state
	*/
	public function deactivate ( $doTween:Boolean = true ):void
	{
		_removeTweens();
		if( $doTween ){
			Tweener.addTween( this, { y:_LOWER_Y, scaleX:_portfolioImages.shrinkPercentage, scaleY:_portfolioImages.shrinkPercentage, time:_TIME, transition:"EaseInOutQuint"} );
			Tweener.addTween( this, { blur:0, time:0.3, transition:"EaseInOutQuint", onUpdate:_updateGlow} );
		}else{
			this.scaleX = this.scaleY = _portfolioImages.shrinkPercentage;
			filters = [];
		}
		
		this.isActive = false;
		_onMouseOut(null);
		this.filters = [];
	}
	
	/** 
	*	Tween this item to a new x position
	*/
	public function moveTo ( $x:Number, $doTween:Boolean ):void
	{
		Tweener.removeTweens( this, "x" );
		targetX = $x;
		if( this.x != $x ){
			if( $doTween || isActive )
				Tweener.addTween( this, { x:$x, time:_TIME, transition:"EaseInOutQuint"} );
			else
				this.x = $x;
		}
	}
	
	// _____________________________ Event Handlers
	
	private function _onClick ( e:Event ):void
	{
		var navEvent:NavEvent = new NavEvent( NavEvent.PORTFOLIO_ITEM_CLICK, true );
		navEvent.portfolioItemIndex = _portfolioItemVo.index;
		dispatchEvent( navEvent );
	}
	
	private function _onMouseOver ( e:Event ):void {
		if( !isActive )
			this.alpha = 1;
	}
	
	private function _onMouseOut ( e:Event ):void {
		if( !isActive )
			this.alpha = 0.8;
	}
	
	private function _onLowResImageLoaded ( e:ImageLoadEvent ):void
	{
		this.visible = true;
		//Tweener.addTween( this, { alpha:0.8, time:1, transition:"EaseInOutQuint"} );
		_onHighResImageLoaded(null);
	}
	
	private function _onHighResImageLoaded ( e:ImageLoadEvent ):void
	{
		if( !isActive )
			deactivate(false);
		else
			dispatchEvent( new ImageLoadEvent(ImageLoadEvent.RECENTER_STRIP, true) );
	}
	
	// _____________________________ Getters + Setters
	
	override public function get width (  ):Number
	{
		if( this.isActive ) 
			return _portfolioImages.activeWidth;
		else
			return _portfolioImages.inactiveWidth;
	}
	
	// _____________________________ Helprs
	
	private function _removeTweens (  ):void
	{
		Tweener.removeTweens( this, "scaleX", "scaleY", "blur" );
	}
	
	// _____________________________ Glow
	
	public var blur:Number = 0;
	
	private function _getGlow (  ):GlowFilter
	{
		var color:Number = 0x000000;
		var alpha:Number = 0.3;
		var strength:Number = 2;
		var inner:Boolean = false;
		var knockout:Boolean = false;
		var quality:Number = BitmapFilterQuality.MEDIUM;
        
		return new GlowFilter(color,
		                      alpha,
		                      blur,
		                      blur,
		                      strength,
		                      quality,
		                      inner,
		                      knockout);
	}
	
	private function _updateGlow (  ):void
	{
		this.filters = [_getGlow()];
	}
}

}