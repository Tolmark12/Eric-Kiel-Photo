package app.view.components
{

import flash.display.*;
import flash.text.*;
public class GreenBtn extends Sprite
{
	private var _background:Sprite;
	private var _titleTxt:TextField;
	
	public function GreenBtn():void
	{
		_background = this.getChildByName( "background" ) as MovieClip;
		_titleTxt = this.getChildByName( "titleTxt" ) as TextField;
		
		this.mouseChildren = false;
		this.buttonMode = true;
	}

}

}