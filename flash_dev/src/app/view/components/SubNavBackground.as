package app.view.components
{
	import flash.display.Shape;
	
	public class SubNavBackground extends Shape
	{
		public function SubNavBackground( $width:uint, $height:uint ):void
		{
			this.graphics.beginFill(0x000000, 0.5);
			this.graphics.drawRect(0, 0, $width, $height);
		}
	}
}