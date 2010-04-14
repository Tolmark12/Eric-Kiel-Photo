package app.view.components
{

import flash.display.*;
import flash.text.TextField;

public class SimpleTextButton extends Sprite
{
	private var _titleTxt:TextField;
	private var _arrow:MovieClip;
	
	public function SimpleTextButton(  ):void
	{
		_titleTxt = this.getChildByName( "titleTxt" ) as TextField;
		this.mouseChildren = false;
		this.buttonMode = true;
		_arrow = this.getChildByName( "arrowMc" ) as MovieClip;
	}
	
	public function build ( $text:String=null ):void
	{
		if( $text != null )
			_titleTxt.text = $text;
			
		var pad:Number = 3;
		this.graphics.beginFill( 0xFF0000, 0 );
		this.graphics.drawRect( -pad, -pad, _titleTxt.x + _titleTxt.textWidth + pad*4, this.height + pad*3 );
	}
	
	public function hideArrow (  ):void
	{
		_arrow.visible = false;
	}

}

}