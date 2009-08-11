package app.view.components
{
	import flash.display.Sprite;
	import app.model.vo.ContactVo;
	
	import caurina.transitions.Tweener;

	public class Contact extends Sprite
	{
		private static const _TIMEIN:Number 		= 0;
		private static const _TIMEOUT:Number 		= .25;
		private static const _DELAY:Number			= 0;
		private static const _TRANSITION:String 	= "easeOutExpo";
		
		private static const _PADDING:uint			= 25;
		
		private var _arrow:SubNavArrow;
		private var _background:SubNavBackground;
		
		private var _contactInfo:ContactInfo_swc	= new ContactInfo_swc();
		
		public var isActive:Boolean;
		
		public function Contact( $contactVo:ContactVo ):void
		{			
			_arrow = new SubNavArrow();
			_arrow.x 			= 0 + _arrow.width;
			_arrow.y 			= 0 - _arrow.height;
			_arrow.alpha 		= 0;
			this.addChild(_arrow);
			
			_background = new SubNavBackground( (_contactInfo.width + _PADDING), (_contactInfo.height + _PADDING));
			_background.x 		= 0 - (_contactInfo.width - _PADDING);
			_background.y 		= 0;
			_background.alpha 	= 0;
			this.addChild(_background);
			
			_contactInfo.x 		= _background.x + (_background.width - _contactInfo.width)/2;
			_contactInfo.y 		= (_background.height - _contactInfo.height)/2;
			_contactInfo.alpha 	= 0;
			this.addChild(_contactInfo);
		}
		
		public function activate(  ):void
		{			
			isActive = true;
			
			Tweener.addTween(_arrow, {alpha:1, time:_TIMEIN, delay:_DELAY, transition:_TRANSITION});
			Tweener.addTween(_background, {alpha:1, time:_TIMEIN, delay:_DELAY, transition:_TRANSITION});
			
			Tweener.addTween(_contactInfo, {alpha:1, time:_TIMEIN, delay:_DELAY, transition:_TRANSITION, onComplete:function(){ _setVisible(isActive); }});			
		}
		
		public function deactivate (  ):void
		{			
			isActive = false;
			
			Tweener.addTween(_arrow, {alpha:0, time:_TIMEOUT, delay:_DELAY, transition:_TRANSITION});
			Tweener.addTween(_background, {alpha:0, time:_TIMEOUT, delay:_DELAY, transition:_TRANSITION});
			
			Tweener.addTween(_contactInfo, {alpha:0, time:_TIMEOUT, delay:_DELAY, transition:_TRANSITION, onComplete:function(){ _setVisible(isActive); }});
		}
		
		private function _setVisible( $bool:Boolean ):void
		{
			if( $bool )
			{
				this.visible = true;
				
			}else{
				this.visible = false;
			}	
		}
	}
}