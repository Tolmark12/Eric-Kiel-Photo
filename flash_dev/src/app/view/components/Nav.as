package app.view.components
{

import flash.display.Sprite;
import app.model.vo.NavVo;
import app.model.vo.NavItemVo;
import app.model.vo.StageResizeVo;

public class Nav extends Sprite
{
	private var _selectedItem:NavItem;
	
	public function Nav():void
	{
		
	}
	
	// _____________________________ API
	
	public function build ( $navVo:NavVo ):void
	{
		var len:uint = $navVo.pages.length;
		var xPos:Number = 0;
		for ( var i:uint=0; i<len; i++ ) 
		{
			var navItemVo:NavItemVo = $navVo.pages[i];
			
			// Make sure this isn't a sub nav item
			if( navItemVo.parentNavItemId == null  ) {
				var navItem:NavItem = _getNavItem( navItemVo );
				navItem.x = xPos;
				xPos += navItem.width + 12;
				this.addChild( navItem );
			}
		}
		this.y = 40
		this.x = StageResizeVo.CENTER - this.width/2;
	}
	
	public function activateNavItem ( $id:String ):void
	{
		if( _selectedItem != null )
			_selectedItem.deactivate();
			
		_selectedItem = _getNavItemById( $id );
		_selectedItem.activate();
	}
	
	// _____________________________ Helpers
	
	private function _getNavItemById ( $id:String ):NavItem
	{
		var len:uint = this.numChildren;
		var navItem:NavItem;
		for ( var i:uint=0; i<len; i++ ) 
		{
			navItem = this.getChildAt(i) as NavItem;
			if( navItem.id == $id )
				return navItem;
		}
		return null;
	}
	
	private function _getNavItem ( $navItemVo ):NavItem
	{
		if( $navItemVo.subNav != null )
			return new NavItemSubNav( $navItemVo );
		else if( $navItemVo.sub != null )
			return new NavItemContact( $navItemVo );
		else
			return new NavItem( $navItemVo );
		
	}
}

}