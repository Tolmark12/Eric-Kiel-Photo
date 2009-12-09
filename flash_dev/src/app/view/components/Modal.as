package app.view.components
{
	import flash.display.Sprite;

	public class Modal extends Sprite
	{
		//private var closeButton:ModalClose_swc = new ModalClose_swc();
		
		/*------------------------- CONSTRUCTOR */
		public function Modal($width:Number, $height:Number):void
		{
			trace('new modal');
						
			_drawModal($width, $height);
		}
		
		/*------------------------- API */
		public function updateHeight($height:Number):void
		{
			this.height = $height;
		}
		
		/*------------------------- INTERNAL */
		private function _drawModal($width:Number, $height:Number):void
		{
			this.graphics.beginFill(0x000000, .75);
			this.graphics.drawRoundRect(0, 0, $width, $height, 5, 5);
			this.graphics.endFill();
		}
	}
}