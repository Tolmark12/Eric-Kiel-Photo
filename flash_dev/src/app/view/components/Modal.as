package app.view.components
{
	import flash.display.Sprite;

	public class Modal extends Sprite
	{
		//private var closeButton:ModalClose_swc = new ModalClose_swc();
		
		public function Modal($width:Number = 100, $height:Number = 100):void
		{
			this.width 	= $width;
			this.height = $height;
			
			_drawModal($width, $height);
		}
		
		public function updateHeight($height):void
		{
			this.height = $height;
		}
		
		private function _drawModal($width:Number, $height:Number):void
		{
			this.graphics.beginFill(0x000000, .75);
			this.graphics.drawRoundRect(0, 0, $width, $height, 5, 5);
			this.graphics.endFill();
		}
	}
}