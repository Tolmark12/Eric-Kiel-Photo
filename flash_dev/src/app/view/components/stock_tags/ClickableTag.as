package app.view.components.stock_tags
{

import flash.display.*;
import flash.text.TextField;
import flash.events.*;

public class ClickableTag extends Sprite
{
	public var text:String;
	private var _txt:TextField;
	private var _bg:MovieClip;
	
	public function ClickableTag():void
	{
		_txt = this.getChildByName( "txt" ) as TextField;
		_bg = this.getChildByName( "bg" ) as MovieClip;
		_bg.alpha = 0;
		this.buttonMode = true;
		this.mouseChildren = false;
		this.addEventListener( MouseEvent.MOUSE_OVER, _onMouseOver, false,0,true );
		this.addEventListener( MouseEvent.MOUSE_OUT, _onMouseOut, false,0,true );
	}
	
	/** 
	*	Build
	*/
	public function build ( $title:String ):void
	{
		text = $title;
		_txt.text = $title;
	}
	
	/** 
	*	Clear
	*/
	public function clear (  ):void
	{
		this.removeEventListener( MouseEvent.MOUSE_OVER, _onMouseOver );
		this.removeEventListener( MouseEvent.MOUSE_OUT, _onMouseOut );
	}
	
	// _____________________________ Event Handlers
	
	private function _onMouseOver ( e:Event ):void {
		_bg.alpha = 1;
	}
	
	private function _onMouseOut ( e:Event ):void {
		_bg.alpha = 0;
	}

}

}