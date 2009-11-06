package app.view.components
{
	import flash.display.Sprite;
	import app.model.vo.ComingSoonVo;
	import caurina.transitions.Tweener;

	public class ComingSoon extends Sprite
	{
		private static const _TIMEIN:Number 		= 0;
		private static const _TIMEOUT:Number 		= .25;
		private static const _DELAY:Number			= 0;
		private static const _TRANSITION:String 	= "easeOutExpo";
		
		private static const _PADDING:uint			= 25;
		
		private var _arrow:SubNavArrow;
		private var _background:SubNavBackground;
		
		private var _comingSoon:ComingSoon_swc	= new ComingSoon_swc();
		
		public var isActive:Boolean;
		
		public function ComingSoon( $comingSoonVo:ComingSoonVo ):void
		{			
			_arrow = new SubNavArrow();
			_arrow.x 			= 0 + _arrow.width;
			_arrow.y 			= 0 - _arrow.height;
			_arrow.alpha 		= 0;
			this.addChild(_arrow);
			
			_comingSoon.titleTxt.autoSize = "left";
			_comingSoon.titleTxt.htmlText = $comingSoonVo.message;
			
			_background = new SubNavBackground( (_comingSoon.width + _PADDING), (_comingSoon.height + _PADDING));
			_background.x 		= 0 - (_comingSoon.width - _PADDING);
			_background.y 		= 0;
			_background.alpha 	= 0;
			this.addChild(_background);
			
			_comingSoon.x 		= _background.x + (_background.width - _comingSoon.width)/2;
			_comingSoon.y 		= (_background.height - _comingSoon.height)/2;
			_comingSoon.alpha 	= 0;
			this.addChild(_comingSoon);
		}
		
		public function activate(  ):void
		{			
			isActive = true;
			
			Tweener.addTween(_arrow, {alpha:1, time:_TIMEIN, delay:_DELAY, transition:_TRANSITION});
			Tweener.addTween(_background, {alpha:1, time:_TIMEIN, delay:_DELAY, transition:_TRANSITION});
			
			Tweener.addTween(_comingSoon, {alpha:1, time:_TIMEIN, delay:_DELAY, transition:_TRANSITION, onComplete:_setVisible } );			
		}
		
		public function deactivate (  ):void
		{			
			isActive = false;
			
			Tweener.addTween(_arrow, {alpha:0, time:_TIMEOUT, delay:_DELAY, transition:_TRANSITION});
			Tweener.addTween(_background, {alpha:0, time:_TIMEOUT, delay:_DELAY, transition:_TRANSITION});
			
			Tweener.addTween(_comingSoon, {alpha:0, time:_TIMEOUT, delay:_DELAY, transition:_TRANSITION, onComplete:_setVisible });
		}
		
		private function _setVisible(  ):void
		{
			if( isActive )
				this.visible = true;
			else
				this.visible = false;
		}
	}
}