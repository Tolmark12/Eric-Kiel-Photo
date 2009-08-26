package app.view.components
{

import flash.display.Sprite;
import app.model.vo.NavVo;
import app.model.vo.NavItemVo;
import app.model.vo.StageResizeVo;
import flash.events.*;

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
				navItem.x = Math.round( xPos );
				navItem.addEventListener( MouseEvent.MOUSE_OVER, _onNavMouseOver, false,0,true );
				navItem.addEventListener( MouseEvent.MOUSE_OUT, _onNavMouseOut, false,0,true );
				xPos += navItem.width + 12;
				this.addChild( navItem );
			}
		}
		this.y = 40
		this.x = Math.round( StageResizeVo.CENTER - this.width/2 );
	}
	
	public function activateNavItem ( $id:String ):void
	{
		if( _selectedItem != null )
			_selectedItem.deactivate();
			
		_selectedItem = _getNavItemById( $id );
		_selectedItem.activate();
	}
	
	public function activateSubNavItem ( $id:String ):void
	{
		if( _selectedItem != null )
			( _selectedItem as NavItemSubNav ).activateSubItem( $id );
	}
	
	public function changeActiveSubItems ( $tags:Array ):void
	{
		if( _selectedItem != null )
			_selectedItem.activateSubItems( $tags );
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
		switch ($navItemVo.kind)
		{
			case "subNav" :
				return new NavItemSubNav( $navItemVo );
			break;
			case "contact" :
				return new NavItemContact( $navItemVo );
			break;
			case "coming_soon" :
				return new NavItemComingSoon( $navItemVo );
			break;
			default :
				return new NavItem( $navItemVo );
			break
		}
		
	}
	
	// _____________________________ Events	
	
	private var _currentRolledNavItem:NavItem;
	
	private function _onNavMouseOver ( e:Event ):void {
		if( _currentRolledNavItem != null && _currentRolledNavItem != e.currentTarget )
			_currentRolledNavItem.dispatchEvent( new Event( "forceMouseOut", true ) );
			
		_currentRolledNavItem = e.currentTarget as NavItem;
	}
	
	private function _onNavMouseOut ( e:Event ):void{

	}
}

}