package app.view.components
{

import flash.display.Sprite;
import app.model.vo.SubNavVo;
public class SubNav extends Sprite
{
	public var isActive:Boolean;
	
	public function SubNav(  ):void
	{
		
	}
	
	// _____________________________ API
	
	public function build ( $subNavVo:SubNavVo ):void
	{
		// build submenu of subMenuItems
	}
	
	public function activate (  ):void
	{
		isActive = true;
		// show the sub munu
	}
	
	public function deactivate (  ):void
	{
		isActive = false;
		// hade the sub menu
	}
	
	public function activateNavItem ( $id:String ):void
	{
		
	}

}

}