package app.view.components
{
	import flash.display.Sprite;
	
	public class SubNavItem extends Sprite
	{
		private var _txt:NavText_swc;
	
		public function SubNavItem( $text:String ):void
		{
			// Text
			_txt = new NavText_swc();
			this.addChild( _txt );
			
			_txt.titleTxt.autoSize = "left";
			_txt.titleTxt.text = $text.toLowerCase();
		}
	}
}