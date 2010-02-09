package app.view.components.swc
{
	import flash.display.MovieClip;
	import flash.text.*;

	public class ModalText extends MovieClip
	{
		public var textField:TextField;
		
		public function ModalText():void
		{
			textField 			= this.getChildByName('$text') as TextField;
			textField.multiline = true;
			textField.wordWrap 	= true;
			textField.autoSize 	= TextFieldAutoSize.LEFT;
		}
		
		public function set text ($text:String):void
		{
			textField.text = $text;
		}
		
		public function set htmlText($htmlText:String):void
		{
			textField.htmlText = $htmlText;
		}
		
		public function set textWidth ( $width:Number ):void
		{
			textField.width = $width;
		}
	
	}
}