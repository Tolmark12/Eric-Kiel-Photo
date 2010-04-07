package app.view.components
{

import flash.geom.Point;
import caurina.transitions.Tweener;
import flash.events.*;
import app.model.vo.StockPhotoVo;
import app.view.components.events.StockEvent;

public class LightboxStockPhoto extends StockPhoto
{
	private var _originPoint:Point = new Point();
	
	public function LightboxStockPhoto($vo:StockPhotoVo):void
	{
		this.addEventListener( MouseEvent.MOUSE_DOWN, _onMouseDown, false,0,true );
		this.addEventListener( MouseEvent.MOUSE_UP, _onMouseUp, false,0,true );
		
		super($vo);
	}
	
	public function hide (  ):void
	{
		Tweener.addTween( this, { alpha:0, x:this.x+this.width / 2, y:this.y + this.height/2, scaleX:0, scaleY:0, time:0.8, transition:"EaseOutQuint", onComplete:_onClear} );
	}
	
	// _____________________________ EVENTS
	
	private function _onMouseDown ( e:Event ):void {
		this.alpha = 0.3
		_originPoint.x = this.x;
		_originPoint.y = this.y;
		this.startDrag(false);
	}
	
	private function _onMouseUp ( e:Event ):void {
		this.alpha = 1;
		this.stopDrag();
	}
	
	override protected function _onClick ( e:Event ):void {
		if( this.y < -130 ){
			var stockEvent:StockEvent = new StockEvent( StockEvent.REMOVE_FROM_LIGHTBOX, true );
			stockEvent.id = super.id;
			dispatchEvent( stockEvent );
		}else{
			Tweener.addTween( this, { x:_originPoint.x, y:_originPoint.y, time:0.5, transition:"EaseInOutQuint"} );
			super._onClick(e);
		}
	}
	
	private function _onClear (  ):void {
		this.parent.removeChild(this);
	}

}

}