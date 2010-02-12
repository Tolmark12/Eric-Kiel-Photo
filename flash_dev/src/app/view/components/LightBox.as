package app.view.components
{

import flash.display.Sprite;
import app.model.vo.StageResizeVo;
import caurina.transitions.Tweener;
import flash.events.*;

public class LightBox extends Sprite
{
	private var _bg:Sprite = new Sprite();
	private var _isHidden:Boolean = false;
	private var _openYPos:Number = 0;
	public function LightBox():void
	{
		_setInvisible();
		hide();
		this.addChild(_bg);
		_drawBg();
		this.addEventListener( MouseEvent.CLICK, _onClick, false,0,true );
	}
	
	public function position ( $stageResizeVo:StageResizeVo ):void
	{
		this.x = $stageResizeVo.left;
		this.y = _openYPos = $stageResizeVo.height - _bg.height;
		_bg.width = $stageResizeVo.width;
	}
	
	public function hide (  ):void
	{
		if( !_isHidden ) {
			_isHidden = true;
			Tweener.addTween( this, { alpha:0, y:_openYPos + 10, time:0.5, transition:"EaseInOutQuint"} );
		}
	}
	
	public function show (  ):void
	{
		if( _isHidden ) {
			_isHidden = false;			
			Tweener.addTween( this, { alpha:1, y:_openYPos, time:1, transition:"EaseInOutQuint"} );
			this.visible = true;
		}
	}
	
	// _____________________________ Helpers
	
	private function _drawBg (  ):void {
		_bg.graphics.beginFill( 0x030303, 0.7 );
		_bg.graphics.drawRect( 0, 0, 100, 50 );
	}
	
	private function _setInvisible (  ):void {
		this.visible = false;
	}
	
	// _____________________________ Event Handlers	
	private function _onClick ( e:Event ):void {
		hide();
	}

}

}