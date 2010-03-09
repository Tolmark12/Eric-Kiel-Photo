package app.view.components
{
	import flash.display.Sprite;
	import app.model.vo.StageResizeVo;
	import caurina.transitions.Tweener; 
	import flash.events.*;
	
	public class Modal extends Sprite
	{
		private static const _TIME:Number 			= 0;
		private static const _DELAY:Number 			= 0;
		private static const _TRANSITION:String 	= 'easeOutExpo';
		
		public const PADDING:Number					= 15;
		
		private var _background:Sprite				= new Sprite();
		private var _closeBtn:CloseBtn_swc			= new CloseBtn_swc();
		
		//private var closeButton:ModalClose_swc = new ModalClose_swc();
		
		public function Modal($width:Number, $height:Number):void
		{
			this.addChild(_closeBtn);
			_closeBtn.x = _closeBtn.y = -8;
			_closeBtn.buttonMode = true;
			_closeBtn.addEventListener( MouseEvent.CLICK, _onCloseClick, false,0,true );
			
			this.y = 100
			_drawModal($width, $height);
		}
		
		// _____________________________ API
		
		public function updateWidth($width:Number):void
		{
			Tweener.addTween(_background, {width:$width, time:_TIME, delay:_DELAY, transition:_TRANSITION});
			this.x = StageResizeVo.CENTER - $width / 2;
		}
		
		public function updateHeight($height:Number):void
		{
			Tweener.addTween(_background, {height:$height, time:_TIME, delay:_DELAY, transition:_TRANSITION});
		}
		
		// _____________________________ Helpers
		
		private function _drawModal($width:Number, $height:Number):void
		{
			_background.graphics.beginFill(0x262626, 1);
			_background.graphics.drawRect(0, 0, $width, $height);
			_background.graphics.endFill();
			
			this.addChildAt(_background, 0);
			updateWidth($width);
		}
		
		public function clear (  ):void
		{
			this.visible = false
			if( this.parent != null )
				this.parent.removeChild(this);
		}
		
		// _____________________________ Event Handlers
		
		private function _onCloseClick ( e:Event ):void {
			clear();
		}
	}
}