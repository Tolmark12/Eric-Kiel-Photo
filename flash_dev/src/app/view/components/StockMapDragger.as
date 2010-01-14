package app.view.components
{

import flash.display.Sprite;
import flash.events.*;
import flash.geom.Rectangle;
import caurina.transitions.Tweener;
import app.view.components.events.StockScrollEvent;

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
		_bounds = new Rectangle($left, this.y, $right - $width, 0);
		_pageWidth = $width;
	}
	
	/** 
	*	Create the shape
	*/
	public function build ( $width:Number, $height:Number, $overshoot:Number=0 ):void
	{
		this.buttonMode = true;
		this.addEventListener( MouseEvent.MOUSE_DOWN, _onMouseDown, false,0,true );
		this.stage.addEventListener( MouseEvent.MOUSE_UP, _onMouseUp, false,0,true );
		
		this.graphics.beginFill( 0x000000, 0.23 );
		this.graphics.drawRect( -$overshoot, -$overshoot, $width+$overshoot*2, $height+$overshoot*2 );
	}
	
	// _____________________________ Event Handlers
	
	private function _onMouseDown ( e:Event ):void {
		this.startDrag( false, _bounds );
		_isDragging = true;
		this.addEventListener( Event.ENTER_FRAME, _onEnterFrame, false,0,true );
	}
	
	private function _onMouseUp ( e:Event ):void {
		if( _isDragging ){
			this.removeEventListener( Event.ENTER_FRAME, _onEnterFrame );
			this.stopDrag();
			_isDragging = false;
			Tweener.addTween( this, { x:Math.round(this.x/_pageWidth)*_pageWidth, time:0.2, transition:"EaseOutQuint"} );
		}
	}
	
	private function _onEnterFrame ( e:Event ):void {
		var ev:StockScrollEvent = new StockScrollEvent(StockScrollEvent.SCROLL, true);
		ev.pos = ( this.x - _bounds.left  ) / _bounds.width;
		trace( int((ev.pos)*100)/100 );
		dispatchEvent( ev );
	}

}

}