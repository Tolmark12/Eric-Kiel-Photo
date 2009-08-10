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
		
		private var _contentHolder:Sprite 			= new Sprite();
		private var _txt1:NavText_swc;
		private var _txt2:NavText_swc;
		private var _txt3:NavText_swc;
		
		public var isActive:Boolean;
		
		public function Contact( $contactVo:ContactVo ):void
		{
			_txt1 = new NavText_swc();			
			_txt1.titleTxt.autoSize 	= "left";
			_txt1.titleTxt.text 		= "test text field 1";
			_txt1.x 					= 0;
			_txt1.y 					= 0;
			
			_txt2 = new NavText_swc();			
			_txt2.titleTxt.autoSize 	= "left";
			_txt2.titleTxt.text 		= "test text field 2";
			_txt2.x 					= (_txt1.x + _txt1.width) + _PADDING;
			_txt2.y 					= _txt1.y;
			
			_txt3 = new NavText_swc();			
			_txt3.titleTxt.autoSize 	= "left";
			_txt3.titleTxt.text 		= "test text field 3";
			_txt3.x 					= _txt1.x;
			_txt3.y 					= (_txt1.y + _txt1.height) + _PADDING;
			
			_contentHolder.addChild(_txt1);
			_contentHolder.addChild(_txt2);
			_contentHolder.addChild(_txt3);
			
			_arrow = new SubNavArrow();
			_arrow.x = 0 + _arrow.width;
			_arrow.y = 0 - _arrow.height;
			_arrow.alpha = 0;
			this.addChild(_arrow);
			
			_background = new SubNavBackground( (_contentHolder.width + _PADDING), (_contentHolder.height + _PADDING));
			_background.x = -150;
			_background.y = 0;
			_background.alpha = 0;
			this.addChild(_background);
			
			_contentHolder.x = (_background.width - _contentHolder.width)/2 + _background.x;
			_contentHolder.y = (_background.height - _contentHolder.height)/2;
			this.addChild(_contentHolder);
		}
		
		public function activate(  ):void
		{
			Tweener.addTween(_arrow, {alpha:1, time:_TIMEIN, delay:_DELAY, transition:_TRANSITION});
			Tweener.addTween(_background, {alpha:1, time:_TIMEIN, delay:_DELAY, transition:_TRANSITION});
			
			Tweener.addTween(_contentHolder, {alpha:1, time:_TIMEIN, delay:_DELAY, transition:_TRANSITION});
			
			isActive = true;
		}
		
		public function deactivate (  ):void
		{	
			Tweener.addTween(_arrow, {alpha:0, time:_TIMEOUT, delay:_DELAY, transition:_TRANSITION});
			Tweener.addTween(_background, {alpha:0, time:_TIMEOUT, delay:_DELAY, transition:_TRANSITION, onComplete:function(){ _background.alpha = 0; }});
			
			Tweener.addTween(_contentHolder, {alpha:0, time:_TIMEOUT, delay:_DELAY, transition:_TRANSITION});
			
			isActive = false;
		}
	}
}