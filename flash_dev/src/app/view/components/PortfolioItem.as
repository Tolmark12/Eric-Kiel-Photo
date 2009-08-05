package app.view.components
{

import flash.display.Sprite;
import app.model.vo.PortfolioItemVo;
import delorum.loading.ImageLoader;
import flash.events.*;
import app.view.components.events.NavEvent;
import caurina.transitions.Tweener;

public class PortfolioItem extends Sprite
{
	public static const _LOWER_Y:Number = 100;
	private static const _TIME:Number = 0.8;
	public var isActive:Boolean = false;
	private var _portfolioItemVo:PortfolioItemVo;
	private var _portfolioImages:PortfolioImage;
	public var targetX:Number;
	
	public function PortfolioItem():void
	{
		this.y = _LOWER_Y;
		this.addEventListener( MouseEvent.CLICK, _onClick, false,0,true );
		this.buttonMode = true;
	}
	
	// _____________________________ API
	
	public function buildAndLoad ( $portfolioItemVo:PortfolioItemVo ):void
	{
		_portfolioItemVo = $portfolioItemVo;
		_portfolioImages = new PortfolioImage();
		this.addChild(_portfolioImages);
		_portfolioImages.loadImages( _portfolioItemVo.lowResSrc, _portfolioItemVo.src );
		deactivate();
	}
	
	public function activate (  ):void
	{
		_removeTweens()
		Tweener.addTween( super, { y:0, scaleX:1, scaleY:1, time:_TIME, transition:"EaseInOutQuint"} );
		this.isActive = true;
		this.alpha = 0.3;
	}
	
	public function deactivate (  ):void
	{
		_removeTweens()
		Tweener.addTween( this, { y:_LOWER_Y, scaleX:_portfolioImages.shrinkPercentage, scaleY:_portfolioImages.shrinkPercentage, time:_TIME, transition:"EaseInOutQuint"} );
		this.isActive = false;
		this.alpha = 0.8;
	}
	
	public function moveTo ( $x:Number ):void
	{
		Tweener.removeTweens( this, "x" );
		targetX = $x;
		if( this.x != $x )
			Tweener.addTween( this, { x:$x, time:_TIME, transition:"EaseInOutQuint"} );
	}
	
	// _____________________________ Event Handlers
	
	private function _onClick ( e:Event ):void
	{
		var navEvent:NavEvent = new NavEvent( NavEvent.PORTFOLIO_ITEM_CLICK, true );
		navEvent.portfolioItemIndex = _portfolioItemVo.index;
		dispatchEvent( navEvent );
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
		Tweener.removeTweens( this, "scaleX", "scaleY" );
	}
}

}