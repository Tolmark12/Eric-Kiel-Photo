package app.view.components
{
	import flash.display.Sprite;
	
	import caurina.transitions.Tweener; 

	public class Modal extends Sprite
	{
		private static const _TIME:Number 			= 1;
		private static const _DELAY:Number 			= 0;
		private static const _TRANSITION:String 	= 'easeOutExpo';
		
		public const PADDING:Number					= 15;
		
		private var _background:Sprite				= new Sprite();
		
		//private var closeButton:ModalClose_swc = new ModalClose_swc();
		
		/*------------------------- CONSTRUCTOR */
		public function Modal($width:Number, $height:Number):void
		{
			_drawModal($width, $height);
		}
		
		/*------------------------- API */
		public function updateWidth($width:Number):void
		{
			Tweener.addTween(_background, {width:$width, time:_TIME, delay:_DELAY, transition:_TRANSITION});
		}
		
		public function updateHeight($height:Number):void
		{
			Tweener.addTween(_background, {height:$height, time:_TIME, delay:_DELAY, transition:_TRANSITION});
		}
		
		/*------------------------- INTERNAL */
		private function _drawModal($width:Number, $height:Number):void
		{
			_background.graphics.beginFill(0x000000, .75);
			_background.graphics.drawRoundRect(0, 0, $width, $height, 5, 5);
			_background.graphics.endFill();
			
			this.addChildAt(_background, 0);
		}
	}
}