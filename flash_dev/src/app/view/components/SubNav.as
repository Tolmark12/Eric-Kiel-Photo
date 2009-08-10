package app.view.components
{
	import flash.display.Sprite;
	import app.model.vo.SubNavVo;
	
	import caurina.transitions.Tweener;
	
	public class SubNav extends Sprite
	{
		private static const _PADDING:uint			= 25;
		
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
				var subNavItem:SubNavItem = new SubNavItem( $subNavVo.pages[i].text );
				subNavItem.y = (subNavItem.height*i);
				subNavItem.alpha = 0;
				_subNavHolder.addChild( subNavItem );
				
				_subNavArray.push(subNavItem);
			}
			
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
			Tweener.addTween(_background, {scaleY:1, time:1, delay:0, transition:"easeOutExpo"});
			_background.alpha = 1;
			
			for(var i:uint = 0; i < _subNavArray.length; i++)
			{
				Tweener.addTween(_subNavArray[i], {alpha:1, time:(1*i), delay:.25, transition:"easeOutExpo"});
			}
			
			isActive = true;
		}
	
		public function deactivate (  ):void
		{	
			Tweener.addTween(_background, {scaleY:0, time:.25, delay:.25, transition:"easeOutExpo", onComplete:function(){ _background.alpha = 0; }});
			
			for(var i:int = _subNavArray.length; i >= 0; i--)
			{
				Tweener.addTween(_subNavArray[i], {alpha:0, time:.25*i, delay:0, transition:"easeOutExpo"});
			}
			
			isActive = false;
		}
	
		public function activateNavItem ( $id:String ):void
		{
		
		}
	}
}