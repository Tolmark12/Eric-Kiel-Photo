package app.view.components
{
	import flash.display.Sprite;
	
	import caurina.transitions.Tweener;

	public class Modal extends Sprite
	{
		private static const TIME:Number 		= 1;
		private static const DELAY:Number 		= 0;
		private static const TRANSITION:String 	= 'easeOutExpo';
		
		//private var closeButton:ModalClose_swc = new ModalClose_swc();
		
		/*------------------------- CONSTRUCTOR */
		public function Modal($width:Number, $height:Number):void
		{
			trace('new ' + $width + ' x ' + $height + ' modal');
						
			_drawModal($width, $height);
		}
		
		/*------------------------- API */
		public function updateWidth($width:Number):void
		{
			Tweener.addTween(this, {width:$width, time:TIME, delay:DELAY, transition:TRANSITION});
		}
		
		public function updateHeight($height:Number):void
		{
			Tweener.addTween(this, {height:$height, time:TIME, delay:DELAY, transition:TRANSITION});
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