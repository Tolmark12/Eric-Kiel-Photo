package app.view.components
{

import flash.display.Sprite;
import flash.events.*;
import caurina.transitions.Tweener;
import flash.filters.*;

public class ArrowButton extends Sprite
{
	
	private var _mouseOverColor:Number = 0xFFFFFF;
	private var _mouseOutColor:Number = 0x000000;
	private var _hasMoved:Boolean = false;
	private var _isWhite:Boolean = false;
	private var _graphic:ArrowButton_swc = new ArrowButton_swc();
	
	public function ArrowButton():void
	{
		this.addChild(_graphic);
		this.alpha = 0;
		this.addEventListener( MouseEvent.MOUSE_OVER, _onMouseOver, false,0,true );
		this.addEventListener( MouseEvent.MOUSE_OUT, _onMouseOut, false,0,true );
		var dropShadowFilter:DropShadowFilter 	= new DropShadowFilter(3, 45, 0x000000, 0.5, 4, 4, 1, 3);
		this.filters = [dropShadowFilter];
	}
	
	
	public function set isWhite ( $isWhite:Boolean ):void
	{
		if( $isWhite ){
			this._onMouseOver(null);
			_isWhite = true
			_mouseOutColor = 0xFFFFFF;
			_mouseOverColor = 0x000000;
			this._onMouseOut(null);
			this.alpha = 0;
		}
	}
	
	public function moveTo ( $x:Number ):void
	{
		
		Tweener.addTween( this, { x:$x, time:1, transition:"EaseInOutQuint"} );
		if( !_hasMoved ){
			Tweener.addTween( this, { alpha:0.6, time:1, delay:1, transition:"EaseInOutQuint"} );
			_hasMoved = true;
		}
	}
	
	
	private function _onMouseOver ( e:Event ):void {
		if( !_isWhite )
			Tweener.addTween(_graphic, {_color: _mouseOverColor, time:0});
		else{
			this.alpha = 1;
		}
	}

	private function _onMouseOut ( e:Event ):void {
		if( !_isWhite )
			Tweener.addTween(_graphic, {_color: _mouseOutColor, time:0});
		else
			this.alpha = 0.6;
	}

}

}