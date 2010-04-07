package app.view.components
{

import flash.display.*;
import flash.text.TextField;
import flash.events.*;

public class TextIconBtn extends MovieClip
{
	private var _titleTxt:TextField;
	private var _icon:MovieClip;
	
	public function TextIconBtn():void
	{
		this.buttonMode = true;
		this.mouseChildren = false;
		_titleTxt 	= this.getChildByName( "titleTxt" ) as TextField;
		_titleTxt.autoSize = "left";
		_icon 		= this.getChildByName( "icon" ) as MovieClip;
		
		this.addEventListener( MouseEvent.MOUSE_OVER, _onMouseOver, false,0,true );
		this.addEventListener( MouseEvent.MOUSE_OUT, _onMouseOut, false,0,true );
	}
	
	/** 
	*	Initialize the button
	*	@param		Title
	*	@param		The icon frame
	*/
	public function build ( $title:String, $frame:String ):void
	{
		// Set Text
		_titleTxt.text = $title;
		_icon.x = _titleTxt.textWidth + 14;
		
		// Show the specified icon
		_icon.gotoAndStop($frame);
		
		// Draw invisible hit area
		this.graphics.clear();
		this.graphics.beginFill(0xFF0000, 0);
		this.graphics.drawRect(-10, -5, this.width+30, this.height+10);
	}
	
	
	// _____________________________ Event Handlers
	
	private function _onMouseOver ( e:Event ):void {
		this.alpha = 0.8;
	}
	
	private function _onMouseOut ( e:Event ):void {
		this.alpha = 1;
	}

}

}