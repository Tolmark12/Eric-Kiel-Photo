package app.view.components
{
	import flash.display.Sprite;
	import app.model.vo.SubNavVo;
	
	import caurina.transitions.Tweener;
	
	public class SubNav extends Sprite
	{
		private static const _TIMEIN:Number 		= 0;
		private static const _TIMEOUT:Number 		= .25;
		private static const _DELAY:Number			= 0;
		private static const _TRANSITION:String 	= "easeOutExpo";
		
		private static const _PADDING:uint			= 25;
		
		private var _arrow:SubNavArrow;
		private var _background:SubNavBackground;
		
		private var _subNavHolder:Sprite 			= new Sprite();
		private var _subNavArray:Array 				= new Array();
	
		public var isActive:Boolean;
	
		public function SubNav(  ):void
		{
			
		}
	
		// _____________________________ API
	
		public function build ( $subNavVo:SubNavVo ):void
		{
			// build submenu of subMenuItems			
			for(var i:uint = 0; i < $subNavVo.pages.length; i++)
			{
				var subNavItem:SubNavItem = new SubNavItem( $subNavVo.pages[i].text, $subNavVo.pages[i].id );
				subNavItem.y = (subNavItem.height*i);
				subNavItem.alpha = 0;
				_subNavHolder.addChild( subNavItem );
				
				_subNavArray.push(subNavItem);
			}
			
			// This is that top arrow:
			_arrow = new SubNavArrow();
			_arrow.x = 0 + _arrow.width;
			_arrow.y = 0 - _arrow.height;
			_arrow.alpha = 0;
			
			// This is that dark shape behind the text:
			_background = new SubNavBackground( (_subNavHolder.width + _PADDING), (_subNavHolder.height + _PADDING));
			_background.alpha = 0;
			
			// Create sub nav Holder:
			_subNavHolder.x = (_background.width - _subNavHolder.width)/2;
			_subNavHolder.y = (_background.height - _subNavHolder.height)/2;
			
			// Place children
			this.addChild(_arrow);
			this.addChild(_background);
			this.addChild(_subNavHolder);
			this.deactivate();
		}
	
		public function activate (  ):void
		{			
			isActive = true;
			
			Tweener.addTween(_arrow, {alpha:1, time:_TIMEIN, delay:_DELAY, transition:_TRANSITION});
			Tweener.addTween(_background, {alpha:1, time:_TIMEIN, delay:_DELAY, transition:_TRANSITION, onComplete:function(){ _setVisible(isActive); }});
			
			for(var i:uint = 0; i < _subNavArray.length; i++)
			{
				Tweener.addTween( _subNavArray[i], {alpha:1, time:_TIMEIN, delay:_DELAY, transition:_TRANSITION} );
			}
		}
	
		public function deactivate (  ):void
		{	
			isActive = false;
			
			Tweener.addTween(_arrow, {alpha:0, time:_TIMEOUT, delay:_DELAY, transition:_TRANSITION});
			Tweener.addTween(_background, {alpha:0, time:_TIMEOUT, delay:_DELAY, transition:_TRANSITION, onComplete:function(){ _setVisible(isActive); }});
			
			for(var i:int = _subNavArray.length; i >= 0; i--)
			{
				Tweener.addTween(_subNavArray[i], {alpha:0, time:_TIMEOUT, delay:_DELAY, transition:_TRANSITION});
			}
		}
	
		
//		public function activateNavItem ( $id:String ):void
//		{
//			if( _currentItem != null )
//				_currentItem.deactivate();
//			
//			_currentItem = _getSubNavItemById( $id );
//			_currentItem.activate();
//		}
		
		
		private function _setVisible( $bool:Boolean ):void
		{
			if( $bool )
			{
				this.visible = true;
				
			}else{
				this.visible = false;
			}	
		}
		
		// _____________________________ Helpers
		
//		private function _getSubNavItemById ( $id:String ):SubNavItem
//		{
//			var subNavItem:SubNavItem;
//			var len:uint = _subNavArray.length;
//			for ( var i:uint=0; i<len; i++ ) 
//			{
//				subNavItem = _subNavArray[i];
//				if( subNavItem.id == $id )
//					return subNavItem;
//			}
//		}
	}
}
