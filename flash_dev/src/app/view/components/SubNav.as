package app.view.components
{
	import flash.display.Sprite;
	import app.model.vo.SubNavVo;
	
	import caurina.transitions.Tweener;
	
	public class SubNav extends Sprite
	{
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
			
			_arrow = new SubNavArrow();
			_arrow.x = 0 + _arrow.width;
			_arrow.y = 0 - _arrow.height;
			_arrow.alpha = 0;
			this.addChild(_arrow);
			
			_background = new SubNavBackground( (_subNavHolder.width + _PADDING), (_subNavHolder.height + _PADDING));
			_background.alpha = 0;
			this.addChild(_background);
			
			_subNavHolder.x = (_background.width - _subNavHolder.width)/2;
			_subNavHolder.y = (_background.height - _subNavHolder.height)/2;
			this.addChild(_subNavHolder);
		
			this.deactivate();
		}
	
		public function activate (  ):void
		{
			_background.alpha = 1;
			
			Tweener.addTween(_arrow, {alpha:1, time:.5, delay:0, transition:"easeOutExpo"});
			Tweener.addTween(_background, {alpha:1, time:.5, delay:0, transition:"easeOutExpo"});
			
			for(var i:uint = 0; i < _subNavArray.length; i++)
			{
				Tweener.addTween(_subNavArray[i], {alpha:1, time:(1*i), delay:.15, transition:"easeOutExpo"});
			}
			
			isActive = true;
		}
	
		public function deactivate (  ):void
		{	
			Tweener.addTween(_arrow, {alpha:0, time:1.5, delay:.25, transition:"easeOutExpo"});
			Tweener.addTween(_background, {alpha:0, time:1.5, delay:.25, transition:"easeOutExpo", onComplete:function(){ _background.alpha = 0; }});
			
			for(var i:int = _subNavArray.length; i >= 0; i--)
			{
				Tweener.addTween(_subNavArray[i], {alpha:0, time:1*i, delay:0, transition:"easeOutExpo"});
			}
			
			isActive = false;
		}
	
		public function activateNavItem ( $id:String ):void
		{
		
		}
	}
}