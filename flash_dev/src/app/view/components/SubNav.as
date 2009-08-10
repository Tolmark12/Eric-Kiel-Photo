package app.view.components
{

import flash.display.Sprite;
import app.model.vo.SubNavVo;
public class SubNav extends Sprite
{
	public var isActive:Boolean;
	
	public function SubNav(  ):void
	{
		this.graphics.beginFill(0xFF0000,0.6);
		this.graphics.drawRect(0,0,100,300);
	}
	
	// _____________________________ API
	
	public function build ( $subNavVo:SubNavVo ):void
	{
		// build submenu of subMenuItems
		
		deactivate();
	}
	
	public function activate (  ):void
	{
		isActive = true;
		this.visible = true;
		// show the sub munu
	}
	
	public function deactivate (  ):void
	{
		isActive = false;
		this.visible = false;
		// hade the sub menu
	}
	
	public function activateNavItem ( $id:String ):void
	{
		
	}

}

}