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
	}
	
	// _____________________________ API
	
	override protected function _build ( $navItemVo:NavItemVo ):void
	{
		super._build($navItemVo);

		if( !$navItemVo.isLogo ) {
			
			_subNav = new SubNav();
			_subNav.build( $navItemVo.subNav );
			_subNav.y = this.y + this.height + 20;
			this.addChild( _subNav );				
			_hitArea.removeEventListener( MouseEvent.MOUSE_OUT, _onMouseOut );
		}
	}
	
	// _____________________________ Events
	
	private function _onEnterFrame ( e:Event ):void {
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
	}

}

}