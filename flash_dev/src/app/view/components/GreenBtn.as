package app.view.components
{

import flash.display.*;
import flash.text.*;
import flash.events.*;

public class GreenBtn extends Sprite
{
	private var _background:Sprite;
	private var _titleTxt:TextField;
	
	public function GreenBtn():void
	{
		this.addEventListener( MouseEvent.MOUSE_OVER, _onMosueOver, false,0,true );
		this.addEventListener( MouseEvent.MOUSE_OUT, _onMouseOut, false,0,true );
		
		_background = this.getChildByName( "background" ) as MovieClip;
		_titleTxt = this.getChildByName( "titleTxt" ) as TextField;
		_titleTxt.autoSize = "left";
		
		this.mouseChildren = false;
		this.buttonMode = true;
	}
	
	public function setTitle ( $text:String ):void
	{
		_titleTxt.text = $text;
		_background.width = _titleTxt.textWidth + _titleTxt.x*2 + 3;
	}
	
	
	// _____________________________ Event Handlers
	
	private function _onMosueOver ( e:Event ):void {
		_background.alpha = 0.8;
	}
	
	private function _onMouseOut ( e:Event ):void {
		_background.alpha = 1;
	}
}

}