package app.view.components.swc
{

import flash.display.MovieClip;
import flash.text.*;

public class NavText extends MovieClip
{
	public var titleTxt:TextField;
	
	public function NavText():void
	{
		titleTxt = this.getChildByName("titleTxt") as TextField;
		titleTxt.autoSize = "left";
	}
	
	public function set text ( $str:String ):void{ htmlText = $str; trace( $str ); }
	public function set htmlText ( $str:String ):void
	{
		var format:TextFormat = titleTxt.getTextFormat();
		titleTxt.htmlText = $str;
		titleTxt.setTextFormat(format);
	}
	public function get text (  ):String{ return titleTxt.text; };

}

}