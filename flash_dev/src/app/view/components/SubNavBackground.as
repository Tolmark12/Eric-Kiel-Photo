package app.view.components
{
	import flash.display.*;
	import flash.filters.BlurFilter;
	
	public class SubNavBackground extends Sprite
	{
		private static const _DIST:uint	= 3;
		private static const _BLUR:uint	= 5;
		private var _blur:BlurFilter 	= new BlurFilter(_BLUR, _BLUR, 3);
		
		private var _shadow:Sprite;
		
		public function SubNavBackground( $width:uint, $height:uint ):void
		{
			this.graphics.beginFill(0x000000, 0.35);
			this.graphics.drawRect(0, 0, $width, $height);
			this.graphics.endFill();
			
			_shadow = new Sprite();
			_shadow.graphics.beginFill(0x000000, 0.25);
			_shadow.graphics.drawRect(_DIST, _DIST, $width, $height);
			_shadow.graphics.endFill();
			this.addChild(_shadow);
			
			_shadow.filters = [_blur];
		}
	}
}