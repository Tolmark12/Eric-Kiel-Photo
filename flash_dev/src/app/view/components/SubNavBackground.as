package app.view.components
{
	import flash.display.*;
	import flash.filters.*;
	
	public class SubNavBackground extends Sprite
	{
		private static const _DIST:uint					= 5;
		private static const _BLUR:uint					= 5;
		private var _dropShadowFilter:DropShadowFilter 	= new DropShadowFilter(_DIST, 45, 0x000000, .25, _BLUR, _BLUR, 1, 3);
		
		public function SubNavBackground( $width:uint, $height:uint ):void
		{
			this.graphics.beginFill(0x000000, 0.5);
			this.graphics.drawRect(0, 0, $width, $height);
			this.graphics.endFill();
			
			//this.filters = [ _dropShadowFilter ];
		}
	}
}