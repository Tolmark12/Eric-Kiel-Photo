package app.view.components
{

import flash.display.*;
import app.model.vo.NavItemVo;
import flash.events.*;
import app.view.components.events.NavEvent;
import caurina.transitions.Tweener;
	
public class NavItemSubNav extends NavItem
{
	private var _subNav:SubNav;
	
	public function NavItemSubNav( $navItemVo:NavItemVo ):void
	{
		super($navItemVo);
		
		// Intercept any sub nav clicks, and fire our own click if they are fired
		_subNav.addEventListener( NavEvent.ADD_FILTER, _onAddFilter, false,0,true );
		_subNav.addEventListener( NavEvent.REMOVE_FILTER, _onRemoveFilter, false,0,true );
	}
	
	// _____________________________ API
	
	override public function deactivate (  ):void
	{
		_subNav.activateSubNavItem( null );
		super.deactivate();
	}
	
	// _____________________________ Build
	
	override protected function _build ( $navItemVo:NavItemVo ):void
	{
		super._build($navItemVo);
		
		// Add the sub nav
		_subNav 	= new SubNav();
		_subNav.y 	= this.y + this.height + 20;
		_subNav.build( $navItemVo.subNav );
		this.addChild( _subNav );
		
		// Remove the rollout handler since we're
		// handling that below with enterframe
		_hitArea.removeEventListener( MouseEvent.MOUSE_OUT, _onMouseOut );
	}
	
	public function activateSubItem ( $id:String ):void
	{
		_subNav.activateSubNavItem( $id );
	}
	
	override public function activateSubItems ( $tags:Array ):void
	{
		_subNav.activateSubItems( $tags );
	}
	
	
	// _____________________________ Events
	
	private function _onEnterFrame ( e:Event ):void {
		// If the mouse is outside the bounds...
		if( _hitArea.mouseX < 0 || _hitArea.mouseY < 0 || _hitArea.mouseX > _hitArea.width ||  _hitArea.mouseY > _hitArea.height/_hitArea.scaleY )
			_onMouseOut(null);
	}
	
	override protected function _onMouseOver ( e:Event ):void {
		if( !_subNav.isActive ){
			// Resize hit area
			_hitAreaWidth 		= _hitArea.width;
			_hitAreaHeight		= _hitArea.height;
			_hitArea.height 	= _subNav.y + _subNav.height - 31;
			_hitArea.width 		= _subNav.x + _subNav.width + 4;
			
			if( e != null )
				_subNav.activate();
			this.stage.addEventListener( Event.ENTER_FRAME, _onEnterFrame, false,0,true );
			super._onMouseOver(e);
		}
	}
	
	override protected function _onMouseOut ( e:Event ):void {
		if( _subNav.isActive )
			_subNav.deactivate();
		
		_hitArea.height 	= _hitAreaHeight;
		_hitArea.width 		= _hitAreaWidth;
		this.stage.removeEventListener( Event.ENTER_FRAME, _onEnterFrame );
		super._onMouseOut(e);
	}
	
	override protected function _onClick ( e:Event ):void {
		super._onClick(e);
	}
	
	private function _onAddFilter ( e:NavEvent ):void {
		super._onClick(e);
	}
	
	private function _onRemoveFilter ( e:NavEvent ):void {
		super._onClick(e);
	}

}

}