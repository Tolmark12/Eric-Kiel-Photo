package app.view.components
{
	import flash.display.Shape;
	
	public class SubNavArrow extends Shape
	{
		public function SubNavArrow(  ):void
		{
			this.graphics.beginFill(0x000000, 0.75);
			this.graphics.moveTo(0, 0);
			this.graphics.lineTo(-5, 5);
			this.graphics.lineTo(5, 5);
			this.graphics.lineTo(0, 0);
			this.graphics.endFill();
		}
	}
}