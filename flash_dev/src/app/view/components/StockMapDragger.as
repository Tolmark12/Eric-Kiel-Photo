package app.view.components
{

import flash.display.Sprite;
import flash.events.*;
import flash.geom.Rectangle;
import caurina.transitions.Tweener;
import app.view.components.events.StockScrollEvent;
import caurina.transitions.Tweener;

public class StockMapDragger extends Sprite
{
	private var _bounds:Rectangle;
	private var _isDragging:Boolean = false;
	private var _pageWidth:Number;
	
	public function StockMapDragger():void{}
	
	/** 
	*	Set the dragging bounds
	*	@param		left bound
	*	@param		right bound
	*	@param		overshoot
	*/
	public function setHorizontalBounds ( $left:Number, $right:Number, $width:Number ):void{
		_bounds = new Rectangle($left+2, this.y, $right - $width, 0);
		this.x = _bounds.x;
		_pageWidth = $width;
	}
	
	/** 
	*	Create the shape
	*/
	public function build ( $width:Number, $height:Number, $overshoot:Number=0 ):void
	{
		this.x = 0
		//$overshoot = 0;
		this.buttonMode = true;
		this.addEventListener( MouseEvent.MOUSE_DOWN, _onMouseDown, false,0,true );
		this.stage.addEventListener( MouseEvent.MOUSE_UP, _onMouseUp, false,0,true );
		
		this.graphics.beginFill( 0x000000, 0.6 );
		this.graphics.drawRect( -$overshoot, -$overshoot, $width+$overshoot*2, $height+$overshoot*2 );
	}
	
	public function clear (  ):void
	{
		this.graphics.clear();
		this.removeEventListener( MouseEvent.MOUSE_DOWN, _onMouseDown );
		this.stage.removeEventListener( MouseEvent.MOUSE_UP, _onMouseUp );
	}
	
	public function scrollTo ( $x:Number ):void
	{
		_onMouseDown(null);
		$x = ($x > _bounds.width)? _bounds.width: $x ;
 		Tweener.addTween( this, { x:$x, time:1, transition:"EaseInOutQuint", onComplete:_onMouseUp, onCompleteParams:[null]} );
	}
	
	// _____________________________ Event Handlers
	
	private function _onMouseDown ( e:Event ):void {
		if( e != null )
			this.startDrag( false, _bounds );
		_isDragging = true;
		this.addEventListener( Event.ENTER_FRAME, _onEnterFrame, false,0,true );
	}
	
	private function _onMouseUp ( e:Event ):void {
		if( _isDragging ){
			this.removeEventListener( Event.ENTER_FRAME, _onEnterFrame );
			this.stopDrag();
			_isDragging = false;
			//Tweener.addTween( this, { x:Math.round(this.x/_pageWidth)*_pageWidth, time:0.2, transition:"EaseOutQuint"} );
		}
	}
	
	private function _onEnterFrame ( e:Event ):void {
		var ev:StockScrollEvent = new StockScrollEvent(StockScrollEvent.SCROLL, true);
		ev.pos = int((( this.x - _bounds.left  ) / _bounds.width)*100)/100 ;
		dispatchEvent( ev );
	}

}

}